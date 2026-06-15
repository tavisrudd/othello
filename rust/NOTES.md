# Rust engine — performance notes

An engineering log for the pure-Rust port: the optimisation journey, the
hardware it was tuned on, every experiment (wins *and* the instructive losses),
the tuning knobs, and a deep-dive on squeezing the CPU. The short version lives
in `README.md`; this is the long version.

All values are **black-centred and identical to the Python reference** — every
optimisation here is value-preserving (or a documented dead-end). Pruning,
ordering, parallelism, and cache tuning change only the node count / wall-clock,
never the move or the score. The test suite asserts this (independent grid
reference, cross-engine agreement, exact endgame solves, fast-`best_move` ==
`best_by_side`).

## Target hardware

Tuned on an **AMD Ryzen AI 9 HX 370** ("Strix Point", Zen 5). It is **hybrid**,
which matters a lot:

| cluster (CCX) | cores            | max clock | L2/core | shared L3 |
|---------------|------------------|-----------|---------|-----------|
| Zen 5 (perf)  | cpu 0–3 (+12–15) | 5.16 GHz  | 1 MB    | 16 MB     |
| Zen 5c (dense)| cpu 4–11 (+16–23)| 3.29 GHz  | 1 MB    | 8 MB      |

L1d 48 KB, L1i 32 KB per core; 2-way SMT (sibling = core + 12); 24 MB L3 total
across the two CCXes. ISA: AVX-512 (F/DQ/BW/VL/VBMI/VBMI2/VNNI/BITALG/BF16),
GFNI, VAES, VPCLMULQDQ, BMI1/2 (fast single-µop PEXT/PDEP), SHA. Zen 5 has a
**native 512-bit datapath**, so AVX-512 is full-rate (no Zen 4-style double-pump
or down-clock).

Build target: `-C target-cpu=znver5` (see the build gotcha below).

## Headline numbers (`make bench`, one machine)

| metric                                   | time     |
|------------------------------------------|----------|
| single depth-8 search (`search_strong`)  | ~0.26 ms |
| depth-8 `best_move` from the opening     | ~0.5 ms  |
| full depth-8 self-play game (62 plies)   | ~73 ms   |
| exact-scores game, 16 workers            | ~90 ms   |

A single depth-8 *move* — the natural unit — is well under a millisecond. The
full *game* is 62 separate depth-8 analyses.

### Cumulative journey: 488 ms → ~73 ms (≈6.7×)

| step                          | game      | note                                                        |
|-------------------------------|-----------|-------------------------------------------------------------|
| native bitboards + PVS        | baseline  | u64 wraps natively; no FFI in the inner loop                |
| single rooted `best_move`     | ~120 ms   | sibling pruning vs N full-window child searches             |
| lazy flips at shallow nodes   | ~120 ms   | flips only for searched moves (same order → same nodes)     |
| `target-cpu=znver5` + mold    | ~100 ms   | POPCNT/BMI/AVX — **after fixing the build-flag shadow**     |
| aspiration windows            | ~76 ms    | narrow ID window, widen on a miss; tie-break preserved      |
| TT = 4 MB (2^17) for L3       | ~73 ms    | fewer evictions; still fits the 16 MB Zen 5 L3              |

## Build gotcha (cost ~1.2× silently)

The global `~/.cargo/config.toml` sets `[target.x86_64-unknown-linux-gnu].rustflags`
(the mold linker). A project `[build].rustflags` is a **different key** and gets
**shadowed** — so `target-cpu` was silently dropped and everything ran on a
generic baseline. Fix: put `target-cpu` under the **same** `[target.*]` key, where
cargo *merges* the arrays. Lesson: `cargo build -v | grep target-cpu` to confirm
the flag actually reaches `rustc`.

## What didn't help (the instructive losses)

These are the point of the project. Each was implemented, measured, and reverted;
the code/bench for a few is kept so the lesson is reproducible.

| experiment                    | isolated result | in the game | why it lost                                                              |
|-------------------------------|-----------------|-------------|--------------------------------------------------------------------------|
| SIMD across 8 ray directions  | 0.96×           | —           | broadcast + per-call horizontal OR-reduce > a 1.4 ns scalar Kogge-Stone  |
| batched `legal_moves_x8`      | **1.35×** thru  | neutral     | real amortization win, but orderable mobility is too small a slice       |
| killer-move ordering          | —               | 75 → 86 ms  | hash + mobility already near-minimal; depth-indexed killers mis-order    |
| outflank ("PEXT") flips       | **5.5×** kernel | 75 → 79 ms  | real flip runs are short → walk early-exits; outflank pays a table load  |
| PGO                           | —               | wash        | inner loop already tight, branches predictable                           |
| root-parallel `best_move`     | —               | slower      | sub-ms searches: fan-out loses pruning + cross-child reuse to overhead   |

The two with kept code (`make bench-simd`, `make bench-flips`) are the sharpest
lesson: **a kernel microbench can show 1.35×–5.5× and still lose in the real
game.** Random-board microbenches have long, varied flip runs and full move
lists; real Othello positions have short runs and the search prunes — the
in-process A/B *game* benchmark is the only one to trust.

## Tuning knobs

| knob                      | where         | value | meaning                                                        |
|---------------------------|---------------|-------|----------------------------------------------------------------|
| `SEQ_BITS`                | `engines.rs`  | 17    | sequential TT size = 2^17 slots (4 MB). Sweet spot for L3.      |
| `POOL_BITS`               | `engines.rs`  | 13    | per-worker parallel TT (256 KB, L2-resident across 8 workers)  |
| `ASP_DELTA`               | `search.rs`   | 16    | aspiration half-window; 16–20 optimal, 32 over-widens          |
| `OTHELLO_THREADS`         | env / `new()` | 8     | root-parallel fan-out width for `scores`                       |

### TT-size sweep (full depth-8 game)

| 2^bits | size   | game    |
|--------|--------|---------|
| 14     | 512 KB | 83.9 ms |
| 15     | 1 MB   | 76.1 ms |
| 16     | 2 MB   | 75.3 ms |
| **17** | **4 MB** | **72.3 ms** |
| 18     | 8 MB   | 75.5 ms |
| 19     | 16 MB  | 119.7 ms |
| 20     | 32 MB  | 155.8 ms |
| 22     | 128 MB | 197.5 ms |

The crossover at ~16 MB is exactly where the table fills the entire 16 MB Zen 5
L3; past that it's the Cython-era "smaller wins" regime (the 128 MB row). With
aspiration's extra probes and a table that persists across all 62 moves, the new
sweet spot is *bigger* than the old 1.5 MB — but still L3-resident.

## Squeezing the CPU

**CPU pinning.** The hot single-threaded search is at the scheduler's mercy on a
hybrid part:

| placement                  | game     |
|----------------------------|----------|
| pinned Zen 5 (5.16 GHz)    | 72.4 ms  |
| pinned Zen 5c (3.29 GHz)   | 110.7 ms |
| unpinned                   | 71.6 ms  |

Linux already parks the busy thread on a perf core (unpinned ≈ pinned-fast), so
pinning is **not** a production win here — but a stray Zen5c placement is a 1.53×
cliff (matching the clock ratio). `make bench-pinned` (`taskset -c 0-3`) removes
that variance for reproducible numbers. For the parallel path, the lever is the
opposite: pin workers to *distinct physical* cores (avoid SMT siblings) and
prefer the 4 perf cores — left to the scheduler today.

**Working L1/L2/L3.** The inner kernels (`legal_moves`, `flips_for_move`) are
**register-only** — no loads, so no L1/L2 traffic at all. The single memory
access per node is the **TT probe**, which is random-by-hash (no locality) and so
is inherently L3-latency-bound; the only knob is capacity vs recompute, already
tuned (4 MB). Making the TT L2-sized recomputes more and measured *slower*. The
`#[repr(C, align(32))]` slot guarantees a probe touches exactly **one** cache
line (two slots per line, none straddling). Remaining ideas, in rough ROI order:
a software prefetch of the child TT entry (hard given immediate-probe recursion);
an AoS child layout for the ordered path (better spatial locality, but the lazy
path — most nodes — already streams in registers); 2 MB huge pages for the TT
arena (fewer TLB misses on random probes — `madvise(MADV_HUGEPAGE)`). All
marginal; none attempted yet.

**Other znver5 ISA.** GFNI (`gf2p8affineqb`), AVX-512 VBMI/VNNI, and fast BMI2
PEXT/PDEP are all available and full-rate, but they only pay off for work we
don't currently do: GFNI for board-symmetry / diagonal transforms, VNNI + gather
for an n-tuple/NNUE eval dot-product, PEXT for line-indexed flips (which lost,
above). They become relevant if/when we add **pattern evaluation**.

## GPU / NPU?

Not for this search. Alpha-beta is sequential (pruning depends on prior results),
branchy, and pointer-chases the TT — the antithesis of what a GPU wants
(coherent, data-parallel, regular). The integrated **Radeon 890M** (RDNA 3.5) and
the **XDNA NPU** would help only for fundamentally different, data-parallel
workloads:

- **Training a learned eval** (n-tuple / NNUE weights) over millions of labeled
  positions — classic GPU/NPU training. Inference of a small eval stays on the
  CPU (SIMD).
- **Massively-parallel batch board evaluation** — `legal_moves`/`flips` for
  millions of independent positions at once (training-data generation, or a
  retrograde / breadth-first frontier solver). This is the `legal_moves_x8` idea
  scaled to millions of lanes; GPU-friendly.

For the interactive depth-8 search, the GPU is the wrong tool. (Even the published
full solve of Othello used CPU clusters, not GPUs, for exactly this reason.)

## Parallelism

`Strong::scores` is root-parallel: each legal move's child is an independent
full-window search, so values are exact and order-independent. Workers each own a
private, preallocated, L2-sized TT (no shared state, no lock). Scaling on the
exact-scores game: ~275 ms (1 thread) → ~112 ms (8) → ~90 ms (16); it tapers past
8 (shared-L3 pressure, bounded by the small per-worker tables). `best_move` stays
a single rooted search — for sub-ms searches, sibling pruning beats fan-out.

If we ever parallelize a *single* deep search, the literature points to **Lazy
SMP + a lockless (Hyatt XOR) TT**, not YBWC — but only once a single search is
big enough (deep endgame), which the depth-8 game is not.

## Endgame solver (done — value-preserving)

`--depth full` now uses a native exact solver (`solve_pvs`): negamax PVS to
terminal, no horizon heuristic, with the TT keyed by **empty count** (which is
path-independent, so transpositions share fully and the key keeps solve entries
disjoint from depth-keyed PVS entries in the shared table). Exact endgame values
are unchanged (6 / −40 / 4); it replaced the slow HashMap fallback. The values
are the expected exponential, exact to the last disc.

**Leaf solver (done — value-preserving).** At or below `EMPTY_SOLVE_MAX` empties
the solver drops the TT *and* the hash-move hint and switches to `solve_low`: an
explicit empty-square scan (flips are computed for the search anyway, so testing
each empty fuses move-gen with make-move) bottoming out in a `solve_1` base case.
Near the leaves the subtree is tiny and rarely transposes, so the one
random-access TT probe per node — the solver's *only* memory access — costs more
than the recompute it saves. The threshold sits just below `ENDGAME_ORDER_MIN`,
so it replaces exactly the unordered, hint-only region of `solve_pvs`; a sweep
confirmed 7 as the sweet spot (≥10 leaves the TT-less region too large and loses
the transposition reuse that matters higher up). Value-preserving: the new
`exact_solve_matches_minimax_oracle_near_terminal` test cross-checks the full
solve against the no-cache minimax oracle over a spread of bucketed near-terminal
positions (the `solve_pvs`→`solve_low` handoff included). Timings
(`make bench-solve`, before → after):

| empties | before  | after   | speedup |
|--------:|--------:|--------:|--------:|
| 14      | ~18 ms  | ~9 ms   | 2.1×    |
| 16      | ~79 ms  | ~30 ms  | 2.6×    |
| 18      | ~1.30 s | ~0.46 s | 2.8×    |

Still on the table: parity "fastest-first" ordering, unrolled `solve_2..4`, and
stability-based cutoffs would push the tractable depth further.

## Strength (done — `strong+`, changes the value)

`strong+` keeps the search but swaps the horizon eval for a stronger one: the
classic X-/C-square penalty (sitting next to an *empty* corner hands it away)
plus a frontier-disc penalty, on top of corners/mobility/discs. It rides on the
TT (already threaded everywhere) so the leaf branch is predictable and `strong`
is byte-for-byte unchanged. Validated by a colour-balanced self-play match
(`make match-plus`): **77.5 % vs `strong`** (46–13–1 at depth 6). The exact endgame
solve is eval-independent, so `strong+` == `strong` on `--depth full`.

## Multi-ProbCut (done — `strong++`, the search win)

The dominant Othello *search* win (Buro/Logistello): forward-prune a deep node
when a cheap shallow search predicts its value lies outside `(α, β)`. The model
is a calibrated linear fit `v_deep ≈ a·v_shallow + b` with residual std `σ`; cut
when a shallow null-window search clears the window by `t·σ` (`t = 1.5`, Buro's
classic ~93 % one-sided point). This is the first **non-value-preserving** search
change in the crate — it pairs with a strength match, not the equivalence tests.

**Calibration** (`examples/calibrate_mpc.rs` / `make calibrate-mpc`): play
ε-random `strong+`-guided games for phase diversity, take the *exact* (MPC-off)
PVS value at every shallow and deep depth, regress `v_deep` on `v_shallow` per
`(depth-pair, disc-count)`, pooling each disc over a ±4 sliding window. All in
**side-to-move (negamax) units** — the eval is colour-swap symmetric, so the
relation is perspective-invariant and both sides pool into one fit (intercept
`b ≈ 0`, as expected). The per-phase `σ` is the whole story:

| disc count | ~`σ` (d8→s4) | regime                                            |
|-----------:|-------------:|---------------------------------------------------|
| 8 (open)   | ~4           | shallow predicts deep tightly — cut aggressively  |
| 24–48 (mid)| ~8–12        | looser — cut with a wider margin                  |
| 56 (late)  | ~33          | shallow mispredicts tactics — MPC self-disables   |

A flat per-depth fit would over-cut the opening and blunder in the endgame; the
per-disc table self-regulates. Two structural guards keep it clean: every probe
depth is below `MPC_MIN_DEPTH` (so a probe is pure PVS — **MPC never nests**, and
the runtime probe matches the MPC-off calibration), and `solve` never calls
`pvs` (so `--depth full` stays **exact**). The cut math skips the full root
window (`±1e9`), confining MPC to the narrow scout windows where it pays.

**Results** (Zen 5 dev box; `make match` / `make bench`):

| comparison                                  | result                                        |
|---------------------------------------------|-----------------------------------------------|
| iso-depth `strong++` vs `strong+` @ 8       | 48.0 % (95–103–2, *n*=200), 0.83× time        |
| full depth-8 game speed                     | `strong+` 178 ms → `strong++` 133 ms (1.34×)  |
| full depth-9 game speed                     | `strong+` 972 ms → `strong++` 357 ms (2.7×)   |
| one ply deeper: `strong++` @ 9 vs `+` @ 8   | 66.0 % (128–64–8, *n*=200), 1.66× time        |

The iso-depth match is the proof that the *forward pruning itself costs no
measurable strength* (48 % ≈ parity) while running faster. The speedup compounds
with depth — more levels above `MPC_MIN_DEPTH` to prune — so it grows 1.34×→2.7×
from depth 8 to 9. That funded depth is the point: the same eval, one ply deeper,
is +16 % win rate. This is also where the otherwise-idle znver5 ISA finally
matters: a learned eval (next) would put VNNI + gather to work on the leaves MPC
still has to evaluate.

## Future directions

- **Pattern / n-tuple (or NNUE) evaluation** — the largest *strength* gain;
  needs a training pipeline (millions of labeled positions), a natural fit for
  the GPU/NPU. Would slot in as the `strong+` horizon eval.
- **Endgame solver depth** — the TT-free leaf solver (`solve_low`/`solve_1`) is
  in; parity "fastest-first" ordering, unrolled `solve_2..4`, and stability
  cutoffs would solve a few more empties in tractable time.
