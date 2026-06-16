# Queens inner-loop rewrite — drive n=16 toward its theoretical floor

**Date**: 2026-06-16
**Session**: 2026-06-16--3 (`d7f7d3d6-4aac-45ce-b684-6984e5ed6275`)
**References**:
- **The why:** [theoretical floor doc](../2026-06-16-queens-theoretical-floor.md) — n=16 floor
  ~30 s central (band ~15–40 s), today 2502 s ⇒ **~75–150× headroom**; the gap is **per-node
  compute density** (~250–400×), not memory. §8 has the n=18 node count (~3×10¹²) + feasibility.
- **The umbrella:** [n=16 memory roadmap](2026-06-15-queens-memory-roadmap.md) — n=16 SOLVED
  (second); this work stream is the *speed* follow-on (the roadmap was the *memory/fitting* story).
- Code: `rust/src/queens.rs` (geometry, canon, solver lineage, TT), `rust/src/bin/queens.rs` (CLI).

## Context

n=16 is solved (~42 min). The floor analysis says the optimal solver is **compute-bound, not
DRAM-bound** — the binding term is **canonicalisation-per-edge**, and today's node is ~250–400×
too fat (~20–33 k cyc/distinct node vs ~80–140 at the floor). Memory micro-opts have repeatedly
washed *because they nibbled a node assumed latency-bound*; the floor says the node itself needs a
structural rewrite (incremental state, register-resident, branchless), not more nibbling.

This is **frontier 1 of a 3-frontier program** (decided 2026-06-16, user):
1. **n=16 → its floor** (this handoff) — inner-loop rewrite.
2. **n=18** — external-memory ply-windowed DDD + BuRR-on-disk (~3×10¹² nodes, ~130–450 GB on the
   1.3 TB zpool; needs *this* rewrite as a prerequisite). See floor-doc §8.
3. **n=14 nimber** — later; component decomposition + small-component nimber DB (#8). Floor +
   feasibility in [the nimber floor doc](../2026-06-16-queens-nimber-floor.md): plain mex is
   *bigger* than solved n=16 (~2×10¹⁰), but Sprague-Grundy decomposition collapses the work base
   from positions to ~distinct connected components (~100–1000×) → feasible. Soft input = the
   distinct-component count (the b̄-analog), unmeasured.

## Key Architecture Decisions

### DFS-resident first, kept mode-agnostic for streaming (n=18)
Build the node primitive **depth-first, register-resident** (n=16's tighter feedback loop), but
keep the kernel decoupled enough that a later **streaming/ply-batched** mode (for n=18's
external-memory DDD) can reuse it. The two architectures may not fully compose (floor-doc §6
caveat: DFS-stack-resident orientations vs ply-batched streaming) — accept that n=18 may fork the
*driver*, but the *node kernel* should be shared.

### The optimal node kernel (the thing to prototype + measure)
Target ~20–140 cyc/node. The design:
- **Hold all 8 dihedral orientations of `available` live** (8 of 32 zmm), carried down the DFS
  stack; per move = 8× `vpandnq` against the orientation's attack mask; **canon = a ~7-op
  `vpminuq` reduction**, never re-folded. (Today's `canon` at `queens.rs:646` re-folds bit-by-bit
  via `mask.each(|s| img.set(perm[s]))` — the per-bit scatter is the fat.)
- Caveat (floor-doc §3): the 8-orientation update needs the attack mask in 8 frames — either 8
  pre-permuted tables (8×16 KB = 128 KB → spills L1d into the 1 MB L2) or on-the-fly GFNI
  re-permutation. Measure which wins in Step 1.
- `Bits` is `[u64;4]` = 256 bits = one zmm with room (`queens.rs:65`). GFNI `GF2P8AFFINEQB` does
  the 16×16 transpose/reflect; znver5 has GFNI + AVX-512 + native 512-bit datapath.

## Plan (3 steps)

### Step 1 — isolated canon/movegen kernel benchmark (the Fermi check; do FIRST)
Standalone harness (no search, no TT, no recursion): the optimal node kernel fed a stream of
realistic deep-position masks, measuring **cycles/node** (rdtsc or `perf stat`). **Gate the whole
rewrite on this:** if it lands ~20–140 cyc/node → commit to Step 3. If it's stuck in the
thousands → the floor model is wrong; re-read the trace at a wider angle before writing search
code (CLAUDE.md: "if the bench disagrees with the napkin by an order of magnitude, the *model* is
wrong"). Prototype both attack-mask strategies (8 pre-permuted tables vs on-the-fly GFNI).

### Step 2 — measurements (parallel with Step 1; cheap; set the target)
Two `count`-style instrumentation passes (copy the `iso_key_fast_in::<const HIST>`
monomorphisation template — `queens.rs:803`, zero production cost):
- **b̄ (edge-weighted branching)** — `expanded_edges ÷ distinct_nodes`, by ply. Pins the floor at
  ~30 s vs ~60–90 s (the floor is ~linear in b̄, floor-doc §3). Tally at the child-iteration loop
  in `wins_keyed` (`queens.rs:1361`).
- **proof-DAG gap** — at prove-a-win (odd) nodes, count children explored past the first cutoff
  (move-ordering inefficiency) + fraction of visited nodes on the verified proof vs discarded.
  Decides whether a DAG-aware proof search (df-pn done right) could beat the floor by a factor no
  inner-loop work recovers. Instrument `par_wins` (`queens.rs:1495`) / `wins_keyed`.

### Step 3 — full DFS-resident inner-loop rewrite (only if Step 1 validates)
Rewrite the node hot path to the Step-1 kernel, behind the validation gates every step. Likely a
new `Solver` impl (keep `Tt`/`Parallel` for the lineage cross-check) so A/B is interleaved and
the old path stays as ground truth until the new one passes all gates.

## Validation gates (every step must hold — CLAUDE.md)
- `solver_lineage_agrees` — new path matches memo-less `naive` verdict on n≤9.
- `queens solve 12 --distinct` → second, exact distinct **1,060,823**, re-exp ≈ 1.0×.
- `queens solve 14 --distinct` → second, ≈49.3M, re-exp ≈ 1.0×.
- A distinct-count change = lost merges (key bug); a re-exp jump = under-sized table. A canon
  rewrite touches the key → both must hold byte-for-byte on the merge count.
- `make test` + `make clippy` green. Bench **interleaved A/B** (thermal throttle ~1 s on a ~12 s
  n=14 solve), anchor on n=14 or partial n=16, never n=12 for perf.

## Codebase Reference

**`queens.rs` was split into `src/queens/` this session** (commit `30aa892`). Paths below are
module files, not line numbers (those drift). `mod.rs` keeps the `othello::queens::*` API.

| What | Where |
|------|-------|
| **`Incremental` (the A3 solver — Step 3, the thing to extend next)** | `src/queens/solver/incremental.rs` |
| `Bits` (`[u64;4]`, 256-bit, the board/available rep) | `src/queens/bits.rs` |
| `Queens` geom: `place`, `attack`, `sym`, `canon`, `pos_key`, `distinct_first_moves` | `src/queens/geom.rs` |
| graph-iso keys (`iso_key*`, WL/IR, `iso_key_fast_in::<const HIST>`, `tally_components`) | `src/queens/graph.rs` |
| `Solver` trait + `make_solver` + key knobs (`par_depth`, `min_avail_for`, `KeyMode`) | `src/queens/solver/mod.rs` |
| `Tt` (`wins_keyed`/`node_key`, memo/symmetry + `count --branching`) | `src/queens/solver/memo.rs` |
| `Parallel` (parity-YBWC `par_wins`; **left untouched** — the A/B baseline) | `src/queens/solver/parallel.rs` |
| `Naive` / `Nimber` / `Pn` | `src/queens/solver/{naive,nimber,pn}.rs` |
| `QueensTt::get`/`put`/`prefetch`/`bump`/`summary` (TT + counters) | `src/queens/tt.rs` |
| `Counter` / `Hll` / `CountReport` (HLL + exact-set hooks) | `src/queens/count.rs` |
| `Cmd` enum + `count_mode` + main dispatch + `--distinct`/`--resume` solver wiring | `src/bin/queens.rs` |
| Step-1 kernel bench (A0–A3, the cyc/canon regression harness) | `src/bin/canon_bench.rs` |

## Build/Test Commands
Per CLAUDE.md / `rust/Makefile`: `make release` / `make test` / `make clippy` (znver5+mold
RUSTFLAGS — never bare `cargo build` for benches). Bench: `./target/release/queens solve 14
parallel`. Wrap noisy builds in `~/.claude/bin/run-quiet "make …"`.

## Delegation Strategy
- **Step 1 (kernel bench)** — **Opus**: the load-bearing de-risk; AVX-512/GFNI intrinsics +
  cycle measurement + the attack-mask strategy decision. Architectural; main context drives it.
- **Step 2 (b̄ + proof-DAG instrumentation)** — **Sonnet-delegable**: isolated, clear template
  (`iso_key_fast_in::<const HIST>`), `count`-mode plumbing. Main reviews the numbers + decides.
- **Step 3 (rewrite)** — **Opus**: touches the recursion key + canon + correctness; behind gates.
- Always re-run `solver_lineage_agrees` + the distinct gates after any key/canon touch.

## Workflow Instructions
- Read this file + the floor doc first; check Progress.
- **Step 1 gates Step 3** — do not start the rewrite until the kernel bench validates the model.
- After each step: update Progress, add a dated Handoff Note (session id), keep `make
  test`/`clippy` green, commit (simple message, no co-author). Ask before any revert/git-state
  change.

## Progress
- [x] **Step 1 DONE — kernel characterized, incremental validated** (`src/bin/canon_bench.rs`).
      Best recompute **A2 = 94 cyc/canon** (SWAR transpose + GFNI byte h-flips); **incremental
      A3 = 62 cyc/canon** (DFS-faithful harness) — **the Step-3 kernel cost, 1.5× under recompute,
      a perfect D4-invariant.** Full perf table + the knob negatives in the session-3b note. Floor
      recalibrated: 62 × b̄≈4 ≈ **~60 s central** n=16, **~42×** over today's 42 min. **GATE: PROCEED
      to Step 3.**
- [x] Step 2: b̄ + proof-DAG-gap instrumentation (`count --branching`, `queens.rs`/`bin`).
      **b̄ ≈ 3.35 (n=12) → 3.92 (n=14) → ~4–4.5 (n=16)** — the floor's b̄≈3 was slightly low (×~1.3),
      no 5–8 tail. **mean win-node cutoff 2.57 → 2.82** (43% first-move) — real ordering waste, so
      the proof-DAG gap is non-trivial but the known ordering levers already failed (df-pn stays a
      research bet, not a sure win). Gates green. See Handoff Note.
- [x] **Step 3 DONE — `Incremental` solver, n=14 ~1.5× wall, same nodes** (session 2026-06-16--4,
      commit `1b8bdcd`). New `incremental` solver (`src/queens/solver/incremental.rs`) carries the 8
      dihedral orientations of `available` live down the DFS; per move `orient[t] &= !att[sq][t]`
      (`att[sq][t] = perm_t(attack[sq])`, 64 KB), key = `lex_min8(orient)` — **byte-identical to
      `pos_key`**, so node count / distinct / re-exp / verdict are identical to `parallel`; only the
      per-node canon cost changes (~574 → ~62 cyc). Same parity-YBWC structure as `Parallel`
      (left untouched, per user), D4-only. **Interleaved n=14 A/B (6 rounds, thermal-controlled):
      incremental ~6.4 s vs parallel ~9.9 s median = ~1.5× wall**, identical ~53.2M nodes. Gates:
      lineage agrees (n≤9); `solve 12 incremental --distinct` second/**1,060,823 exact**/1.01×;
      `solve 14` second/~49.2M/1.08×. `make test` + `clippy` green.
- [x] **n=16 SOLVED with `incremental` (2026-06-16, user's full run) — SECOND, ~34 min search,
      ~1.2× over D4 parallel.** `QUEENS_…`/`solve 16 incremental --distinct`: **2025 s search**
      (≈33m45s), 10.96B nodes, ≈8.0B distinct, 1.37× re-exp, 36/36 roots refuted ⇒ second player
      (cross-checks Jenrich). vs the D4 `parallel` ~2502 s (session-8) — and **this was *with* the old
      5-min zstd-3 periodic dumps contending** (the dump is CPU-starved by the 24 workers: ~55 MB/s
      contended vs ~235 MB/s once the search ends), so uncontended it's faster still. The 62-cyc
      incremental kernel is the lever: Step 3 validated at the real target, not just n=14.
- [x] **Module split (same session, commit `30aa892`) — user-requested prerequisite.** The
      3184-line `queens.rs` → `src/queens/` tree: `bits`, `geom`, `graph`, `count`, `tt`,
      `solver/{mod,naive,memo,parallel,incremental,nimber,pn}`. Pure move (cross-module items →
      `pub(crate)`; `Parallel` verbatim); `mod.rs` preserves the `othello::queens::*` API. Gates
      byte-identical pre/post.
- [x] **Checkpoint + solve-output UX overhaul (commits `983c953`, `fc17d22`).** The n=16 dump is
      **CPU-bound** (lone zstd thread starved by the 24 search workers), not IO-bound (NVMe). So:
      checkpointing is now **opt-in** (`--checkpoint`; no n=16 default), **periodic is opt-in too**
      (`--checkpoint-every`; else on-demand), press **S** / SIGUSR2 to snapshot on demand, **zstd
      3→1**, the **live search bar keeps ticking** with dump progress folded in (dump = lock-free
      relaxed loads), Ctrl-C announces the save + a 2nd Ctrl-C `_exit`s mid-dump. Solve output:
      solver/timing + distinct print **right under the verdict** (before the PV step), the **PV bar
      resets** to its own nodes (`Phase::OptimalLine`), times as **XmYs**. `make pgo-queens`/`pgo-release`
      now profile `solve 14 incremental`. Gates green; checkpoint round-trip + SIGINT save verified.
- [ ] **Next levers (Step 3 follow-ons, the ~60 s floor still ~28× below):** the n=14 ~1.5× is the
      first cut — the canon was a big per-node fraction but TT/DRAM latency + movegen remain. The
      kernel notes' deferred levers: (1) **ILP** — overlap the 8 independent `and-not`s / break the
      lex-min serial chain; (2) **vectorise** `[Bits;8]` orientations into `__m256i`/`zmm` (lex-min
      via pairwise `vpcmpuq` tree, *not* the A1 lane-gather); (3) thread the prefetched `(route,fp)`
      from `prefetch` into `get` (saves the 2nd `hash128`). Bench each against `canon_bench` cyc/canon
      + interleaved n=14, then a **partial n=16** throughput check (grab a fixture via SIGUSR2).
- [ ] **n=16 with `incremental` (ask-first — the real n=16 run gate).** The payoff target: re-run the
      full n=16 with `solve 16 incremental --checkpoint` once a couple more per-node levers land;
      project from partial throughput first. Checkpoint/resume wired (`from_tt`), default-on for n=16.

## Handoff Notes

### Step 3 — `Incremental` solver + module split (2026-06-16, session 2026-06-16--4)
**WIN — the incremental kernel works in the real search: n=14 ~1.5× wall, identical work.**
Commits `30aa892` (split) then `1b8bdcd` (solver).

**Two pieces, both user-directed:**
1. **Module split first** (user: "queens.rs too large / split into sub-modules", "leave the existing
   parallel solver as it is"). The 3184-line `queens.rs` → `src/queens/` tree (see Codebase
   Reference). Pure byte-exact move: cross-module items bumped to `pub(crate)` (the compiler
   enumerated each — `Bits.0`/methods/`ZERO`, `Queens` fields, `Tt`/`QueensTt` internals, `Slot`,
   `IsoScratch`, knobs); tests stayed in `mod.rs` (import graph/tt internals by path). `Parallel`
   moved verbatim. Gates byte-identical pre/post split.
2. **`Incremental` solver** (`solver/incremental.rs`, the A3 port). Carries `[Bits;8]` orientations
   down the DFS; per move `child[t] = parent[t] & !att[sq][t]` where `att[sq][t]=perm_t(attack[sq])`
   (built once per solve, 64 KB, threaded — never per-node `OnceLock::get`); key = serial early-out
   `lex_min8`. `orient[0]` *is* `available` (identity image), so availability/terminal tests read it
   directly — no separate `blocked`. Same parity-YBWC fan as `par_wins` (even=fan-all, odd=cutoff),
   D4-only. Registered in `make_solver`/`SOLVER_NAMES`/bin (`--distinct` + resume) + lineage test.

**Why it's exact (so the win is purely per-node cost):** `lex_min8(orient) == canon(available) ==
pos_key(blocked)` by construction (perm distributes over `&`/`!`; the 8 orientations are the exact 8
images `canon` minimises over). So the TT key per node is byte-identical to `parallel` ⇒ same node
count, same distinct, same re-exp, same verdict. Confirmed: `solve 12 incremental --distinct` =
**1,060,823 exact** (= parallel), `solve 14` ≈49.2M/1.08×, both SECOND.

**Measured (interleaved, thermal-controlled, 6 rounds n=14, non-distinct):**

| round | parallel | incremental |
|-------|---------:|------------:|
| 1     |  7.785 s |    5.402 s  |
| 3     |  9.873 s |    6.230 s  |
| 6     | 10.101 s |    6.534 s  |

Median ≈ **9.9 s vs 6.4 s = ~1.5× wall**, ~53.2M nodes both (matched). Both arms drift up together
with throttle; incremental stays ~1.5× ahead every round.

**Read.** Step-3 thesis confirmed at n=14: per-node canon was a large wall fraction, and the 62-cyc
incremental kernel cuts it. But ~1.5× is the *first* cut, not the floor's ~42× — TT/DRAM latency,
movegen, and recursion overhead remain (the floor assumed all per-node cost collapses to the canon).
The cheap structural levers (ILP over the 8 and-nots, vectorised lex-min into `__m256i`/`zmm`,
threading `(route,fp)` from `prefetch`→`get`) are the next cuts before a partial-n16 throughput check
and the ask-first full n=16 run. **`canon_bench` cyc/canon + interleaved n=14 are the regression
gates for each.**

### Kickoff (2026-06-16, session 2026-06-16--3)
**Completed**: work stream created; codebase hot-path mapped (Explore agent — see Codebase
Reference for exact file:line). Floor doc (the why) + n=18 §8 written. No code yet.
**Next**: Step 1 kernel bench + Step 2 measurements, dispatched in parallel.

### Step 2 — b̄ + proof-DAG measurement DONE (2026-06-16, session 2026-06-16--3)
**Completed**: `count --branching` — a const-generic `wins_keyed_in::<COUNT>` (production is
`::<false>`, byte-identical, zero added branch; the runtime decision is made once at the root in
`Tt::wins`). Tallies total `node_key`/canon calls (b̄ numerator) + the win-node cutoff histogram.
Two delegated Sonnet agents died on transient API 500s (one did nothing, one left only stray
`cargo fmt` noise → restored with user OK); implemented in the main context instead.

**Measured (sequential `Tt`):**

| n  | b̄ (÷distinct) | b̄ (÷expanded) | mean win-node cutoff | cut@1 |
|----|---------------|---------------|----------------------|-------|
| 12 | 3.353         | 3.337         | 2.573                | 45.5% |
| 14 | 3.922         | 3.681         | 2.817                | 43.0% |

**Reads:**
- **b̄ ≈ 4 at n=16** (gentle up-trend, no 5–8 tail) — the floor's b̄≈3 undercounts ~1.3×, so the
  per-node cost (and the central floor) scales up ~1.3× (≈30 s → ≈40 s). **Step 1 green-lit** — the
  model's branching assumption holds within ~1.3×.
- **Proof-DAG gap is real but the recoverable fraction is uncertain.** mean cutoff ~2.8 (not ≈1) ⇒
  ordering is imperfect (57% of win nodes try ≥2 moves), so the searched set sits above the minimal
  proof DAG. *Caveat:* this metric counts moves-before-cutoff, not the *node-count* of the wasted
  pre-cutoff subtrees (which may be cheap), and the known ordering levers already failed (fact #6:
  history 2× worse, effective-degree decays). So df-pn / DAG-aware proof search remains a *research
  bet* with measured justification — defer behind Step 1/3 (a faster node helps regardless).

**Files**: `queens.rs` (`Tally`/`BranchingStats`, `wins_keyed_in::<COUNT>` + wrapper, `Tt::wins`
root dispatch, `with_branching`, `branching_stats`); `bin/queens.rs` (`--branching` flag,
`count_mode` param, `branching_report`). **Gates**: `solve 12 --distinct` 1,060,823/1.00×; `solve
14` ≈49.3M/1.08×; `make test` 23 ok incl. `solver_lineage_agrees`; `make clippy` clean.

### Step 1 — canon kernel Fermi check DONE (2026-06-16, session 2026-06-16--3)
**GATE: PROCEED (calibrated).** Built `src/bin/canon_bench.rs` (Opus sub-agent; reproduced in main
context). Corpus = TT-deduped n=16 DFS of real raw `available` masks (deep-heavy, mean popcount ~9).

| impl                                         | cyc/canon | ns/canon | speedup | note                         |
|----------------------------------------------|-----------|----------|---------|------------------------------|
| baseline (today's `Queens::canon`, scatter)  | 632       | 122      | 1.00×   | the per-bit scatter = the fat|
| **A0** (SWAR word transforms + lex-min-of-8) | **111**   | 23       | 5.3–5.7×| **the kernel**; IPC 1.19     |
| A1 (GFNI transpose + AVX-512 min)            | 186       | 37       | 3.3×    | **NEGATIVE** — repack dominates |

**Correctness (decisive):** A0 is a perfect D4-invariant — partition count = `canon` (2M=2M), and
orbit-stress (500k masks × 8 raw D4 orientations → exactly 500k classes, `merges-match=true`).
Reproduced on a fresh invocation.

**Reads:**
- **Structural thesis CONFIRMED.** Removing the scalar scatter → branchless, **popcount-independent**,
  5.3× immediately, correct. The ~250× fat is real and attackable.
- **GFNI is OUT (measured negative).** The scalar `[u64;4]`↔8×8-block repack per call dominates
  (348 inst, 186 cyc). Do not chase GFNI; the lever is ILP + AVX2/512 256-bit ALU.
- **Recalibration.** A0 (the *recompute* variant) = 111 cyc/canon, ~2.3× the floor's ~49 central
  per-canon assumption ⇒ if the rewrite stalls there, node floor ≈ **~100 s (~25× over today)**,
  not ~45 s. A0 is **dependency-chain-bound, not op-count-bound** (IPC 1.19, 133 inst ≈ the floor's
  op estimate). The ~45 s central needs the three Step-3 levers below — plausible, not yet proven.
- **Step 3 levers (in priority order):** (1) **incremental — hold the 8 orientations live down the
  DFS stack, update per-move** (A0 re-folds all 8 per call = the design doc's Variant A; Variant B
  avoids it); (2) **ILP — overlap the 8 independent images / break the serial delta-swap transpose
  chain** (IPC 1.19 → ~3+); (3) **vectorize `[u64;4]` → one `__m256i`**. `canon_bench.rs` is the
  Step-3 regression harness — re-run cyc/canon as each lands.

**Files**: `src/bin/canon_bench.rs` (new), `Cargo.toml` (`[[bin]]`). Run: `./target/release/canon_bench
4000000 6 bench` (gate + wall); `taskset -c 0-3 perf stat -e cycles ./target/release/canon_bench
2000000 64 perf:a0` (÷128M). Gates green (`make test`/`clippy`). NB: the sub-agent again left
crate-wide `cargo fmt` noise on 3 production files (whitespace only) — **not** committed (bench
commit stages only the 2 new files); left unstaged for the user to keep-or-restore.
**Next**: Step 3 — the DFS-resident incremental rewrite, behind the lineage + distinct gates, A/B'd
on n=14 and tracked against `canon_bench` cyc/canon.

### Step 1 COMPLETE — kernel fully characterized; incremental = 62 cyc (2026-06-16, session 2026-06-16--3)
**Session:** 2026-06-16--3 (`d7f7d3d6-4aac-45ce-b684-6984e5ed6275`). Collaborative kernel push (Codex
on the recompute kernel, this session on the incremental model + harness + knobs). **A3 incremental
validated as the Step-3 kernel.**

**Final perf cyc/canon** (build-subtracted, `taskset -c 0-3 perf stat -e cycles`, cap 120k × 4000):

| kernel | cyc/canon | what it is |
|--------|-----------|------------|
| baseline | 574 | today's `Queens::canon` scalar per-bit scatter |
| A1 | 179 | GFNI 16×16 transpose + AVX lane-gather min — worst kernel |
| A0 | 125 | pure SWAR recompute |
| A2 | 94 | hybrid recompute: SWAR transpose + GFNI byte h-flips (best recompute) |
| **A3** | **62** | **incremental: carry 8 orientations, per-move and-not + scalar early-out min (the Step-3 cost)** |

**Settled design** (what Step 3 builds): incremental orientations — carry the 8 dihedral images of
`available` live down the DFS stack, per move `orient[t] &= !perm_t(attack[sq])` (8 and-not from a
64 KB per-orientation `att` table), key = **scalar early-out `lex_min8`** + hash. No per-node image
recompute. A3 is **1.5× under** the best recompute (A2 94) and a perfect D4-invariant (child-canon
matches direct canon exactly).

**Documented negatives (do NOT re-try):**
- **GFNI full 16×16 transpose** — the `[u64;4]`↔8×8-block scalar repack dominates (A1 179 > A0 125).
  GFNI is only a win for *in-byte* h-flips (A2 keeps SWAR transpose).
- **AVX lane-gather min** (`lex_min8_avx`, `_mm512_set` of 8 scattered images) — the gather costs more
  than the scalar branchy min; it's why A1 is slowest.
- **Branchless `lex_lt`** — +8 cyc/canon (A0 125→134): the early-return wins (most image pairs differ
  in word 0 → exit after one compare; the branchless form does all 4 unconditionally).
- **Tree-reduction `lex_min8`** — +4 cyc (A2 94→108): 7 full 32-byte selects beat the serial fold's
  rare-update copies; ILP doesn't pay. *The lex-min resists optimisation here.*
- **att layout `[s*8+t]` contiguous** — neutral (noise).
- Inline notes left on `lex_lt`/`lex_min8` so these aren't re-attempted.

**Harness lesson (load-bearing):** the FIRST A3 reloaded the 8 orientations from a 4 MB array per
iteration (an L2 stream the DFS never pays — it inherits them register/L1-resident) → A3 looked ≈
recompute (~85 cyc). Cycling a **small L1-resident** orientation set across the full move stream (the
recompute already excluded) revealed the true incremental cost = **62 cyc**. The harness *was* the
finding; `canon_bench` modes: `perf:a0|a1|a2|a3`, divide by the printed `canons`.

**Floor recalibration (measured, replaces the §3 estimate):** per-canon ≈ 62 (not the ~49 estimate)
⇒ per-node ≈ b̄≈4 × 62 ≈ **~248 cyc/node** ⇒ n=16 floor ≈ **~60 s central** (~3.0×10¹⁰ cyc/s),
**~42×** over today's 2502 s. The ~50 cyc/canon / ~45 s aggressive end needs a structural min change
(vectorised lex-min *without* the lane-gather — keep the 8 images in `__m256i`, pairwise `vpcmpuq`
tree); a real AVX-512 lift, deferred — the cheap knobs are exhausted.

**Commits (this kernel push):** `a8dec96` (A2 + A3 + first findings), `7dc2e1e` (DFS-faithful harness
— the 62 vs 95 flip), `1321657` (branchless-min + att-layout negatives), `0bfc6a7` (tree-min negative).
Gates green throughout (`make clippy`; A0/A1/A2 perfect-invariant, A3 child-canon exact). Pre-commit
hook installed this session (`.githooks/pre-commit`, `make install-hooks`): auto-fmt staged Rust +
clippy gate.

**NEXT SESSION = Step 3 (integration):** wire the incremental kernel into the real search — carry the
8 orientations through the DFS recursion (not recompute per node), key each child via the 62-cyc
A3 path. Behind `solver_lineage_agrees` + exact n=12/n=14 distinct-count gates; A/B on n=14 against
the current `Parallel` solver; track wall-clock + cyc/node vs the ~60 s floor. The `att` table + the
incremental update are prototyped in `canon_bench.rs` (a3_key / build_att) — port them into a new
`Solver` impl, keep `Tt`/`Parallel` as the ground-truth cross-check.
