# Non-Attacking Queens solver — memory/representation roadmap to n=16

**Date**: 2026-06-15
**Session**: 2026-06-14--3 (`04e367e2-6055-4634-8632-6c841b6c978e`)
**References**:
- Noon & Van Brummelen, "The Non-Attacking Queens Game", College Math. J. 37(3), 2006.
- **OEIS A344227** — Sprague-Grundy nimber of this game (= Node Kayles on the queen graph). Our verdicts match it through n=13. https://oeis.org/A344227
- Jenrich, arXiv:1312.5135 (2013/14) — n=16 is a confirmed **second-player win** (71B calls / 23h, no TT/symmetry).
- Memory note: `[[queens-game-cgt-references]]` in the auto-memory.
- Code: `rust/src/queens.rs` (geometry + solver lineage + TTs), `rust/src/bin/queens.rs` (CLI), README "Bonus: Non-Attacking Queens".

## Context

The `queens` binary solves the adversarial Non-Attacking Queens game (impartial,
normal play; place a queen attacking no other; can't-move loses). It's **Node
Kayles on the queen graph** (deciding the winner is PSPACE-complete, Schaefer
1978). A position is captured by the `blocked` mask (occupied ∪ attacked).

**Solved/known so far:**
- **Odd n: O(1)** — first player wins by centre + 180° mirror pairing (theorem, no search).
- **Even n win/loss: solved through n=14** (second), **n=15** (first, odd→O(1)). Winners:
  every odd n → first; even 4/6/8 → first; 10/12/14 → second.
- **Nimbers (full Sprague-Grundy): validated vs OEIS A344227 through n=12.**
  n≥13 nimbers are **infeasible by plain mex** (no cutoff → ~265× the win/loss
  node count; n=13 nimber ran >31 min unfinished vs 4.1s win/loss).
- **Game does NOT decompose** (queen graph is biconnected + long-range diagonals)
  → Sprague-Grundy nim-sum decomposition is a near-dead-end here.

**The open frontier: n=16 win/loss.** Jenrich proved it (second) in 2014 with a
no-TT backtracker. We're ~22× more node-efficient at n=14 (53M vs his 1.16B), but
n=16's working set (~billions of distinct positions) **exceeds any TT we can hold**
(3B × 40 B ≈ 120 GB vs a 26 GB box), so a straight run thrashes (eviction →
recompute, drifting toward his 71B nodes). **n=16 is a memory-pressure problem.**

## Current solver lineage (all in `rust/src/queens.rs`)

`Queens` is pure geometry; `Solver` trait + ladder, all computing the same
win/loss (cross-checked by `solver_lineage_agrees` vs the memo-less `naive`):

| solver     | adds                                                            | n=8 nodes |
|------------|-----------------------------------------------------------------|-----------|
| `naive`    | win/loss + α-β cutoff, no memo (ground truth)                   | 23,099    |
| `memo`     | + fixed-size open-addressing TT (`QueensTt`, raw `blocked` key)  | 1,278     |
| `symmetry` | + dihedral-canonical key (`pos_key`)                            | 626       |
| `parallel` | + rayon root parallelism (YBWC) + odd-board O(1) — **default**   | 625       |
| `nimber`   | full Sprague-Grundy value via `mex`, **no cutoff**, root-parallel | 8,862   |
| `pn`       | df-pn proof-number search — **instructive negative** (see below) | 5,411    |

`QueensTt` = sharded (1024) fixed-size open-addressing table; slot = `{key:[u64;4]
(256b), val:u8, used:u8}` → **40 bytes** padded. `PnTt` similar with `(phi,delta)`.

## Key facts / decisions already settled (do NOT re-derive)

1. **`pos_key` canonicalises `available` (`board & !blocked`), not `blocked`.**
   Available is a pure function of `blocked`, so this merges the *identical*
   classes (same node counts, byte-for-byte) but `canon` folds far fewer set bits
   for the deep majority of nodes. **Lever 1, done: n=14 went 79.6s → 33.0s (2.4×),
   zero node-count change**; also flipped the old "symmetry slower than memo" note
   (symmetry now faster: n=10 0.055s vs memo 0.188s).
2. **df-pn is a documented negative**: correct but hits the df-pn + transposition
   (graph-history-interaction) pathology on this transposition-dense game; explodes
   past n=8. Kept as an experiment; `parallel` dominates. Competitive df-pn needs
   careful DAG-aware proof numbers (Čížek–Balko–Schmid 2026, arXiv:2511.10339).
3. **Full nimbers stop at ~n=12** (no-cutoff blowup). n=14 win/loss is new-ish info
   relative to OEIS; full nimbers for n≥14 need bounded/partial nimber search AND
   the game doesn't decompose, so they're research-grade. Don't chase them by mex.
4. **GPU does not help** the search (sequential DAG, random-access TT, branchy) —
   same conclusion as the Othello `NOTES.md`. Bottleneck is algorithmic + memory.
5. **Deeper parallelism is a NEW documented negative (session 3).** The search is
   **TT-DRAM-latency-bound**, not parallelism-bound: n=14 is ~11–12 s / ~53.3M nodes
   / ~49.3M distinct (1.08× re-exp) at the default TT, ~18× parallel ≈ the hardware
   ceiling on this 12-core/24-thread box. Two "parallelise sooner" rewrites both
   failed and were reverted: fanning *all* root moves at once is wall-clock-equal to
   the committed sequential-lead YBWC guard (same node count); recursive YBWC
   *inside* subtrees **defeats the α-β cutoff** (searches children the cutoff would
   skip → **~97M nodes / ~18 s vs ~53M / ~12 s**). **Keep the sequential-lead guard**
   (the lead move warms the shared TT for the parallel siblings). Don't re-attempt —
   the lever is memory/per-node cost (Chunk 2), not more cores.

## The plan: measure first, then pick the encoding, then attempt n=16

The whole roadmap turns on **one unknown**: how many *distinct* positions does n=16
actually have? That decides whether any single-box scheme fits.

### Chunk 1 — MEASURE with HyperLogLog (do this first; cheap; decisive)

Wire a HyperLogLog (Flajolet–Martin) cardinality estimator into a solve run: feed
every `pos_key(blocked)` (canonical key) into the HLL during the search; report the
estimated distinct-position count. Goals:
- Confirm n=14's true distinct count (we believe ≈ 53M, i.e. node count ≈ distinct
  since the TT didn't evict at n=14, but parallel re-expansion inflates "nodes" —
  HLL gives the truth).
- Get distinct counts for n=10/12/14 and **fit the growth → extrapolate n=16.**
- **Decision gate:** if n=16 ≈ 2–20B distinct → it *fits* under a compact encoding
  (see below) → build it. If ≫ that → n=16 is distributed-only; stop and document.

HLL is ~KB of memory, ~1–2% error. A dense register HLL (e.g. 2^14 registers) is a
few dozen lines. Feed it the 256-bit key's hash. **No correctness risk** (it's only
instrumentation). Can run on n=12/14 in minutes.

#### Chunk 1 — RESULT (DONE, 2026-06-15)

Built the `count` CLI mode: a dense HyperLogLog (p=16 default, ~0.4% std err) plus
an optional exact hash set, fed every canonical `pos_key` the search looks up (hook
in `QueensTt::get`, so it transparently measures any solver's working set). Validated
HLL vs exact on n=8/10/12 (+0.3–0.4%, within budget) and that the hook never changes
a verdict (`counting_preserves_verdict_and_tracks_exact` test).

**Measured distinct positions (parallel-HLL, second-player-win boards — like-for-like
with n=16):**

| n  | distinct (HLL) | node count   | ratio vs prev | note                          |
|----|----------------|--------------|---------------|-------------------------------|
| 10 |        94,339  |       94,590 |        —      | exact set agreed (94,097)     |
| 12 |     1,070,913  |    1,069,063 |       11.4×   | exact set agreed (1,060,726)  |
| 14 |    49,346,012  |   53,190,566 |       46.1×   | p=18; node count inflated ~8% |

**Key correction:** the roadmap's "n=14 ≈ 53M distinct" was the *node* count; the
true distinct working set is **≈ 49.3M** (eviction re-expansion inflates nodes ~8%).

**Growth is accelerating** (ratio 11.4× → 46.1×; the per-step log-increment grows by
a near-constant +1.40 second difference). Extrapolations to n=16:
- **Model A (geometric, ratio frozen at 46×):** ≈ **2.3B** — a lower bound.
- **Model B (constant 2nd-difference of log = quadratic-in-n log; the natural fit
  for 3 points):** 14→16 ratio ≈ 187× → **≈ 9.2B** — the central estimate.
- Upper tail (if the 2nd difference itself grows): ~2× central, ~18B.

**Memory at 9.2B (central) on the 26 GB box:**

| encoding                                   | footprint | fits 26 GB? |
|--------------------------------------------|-----------|-------------|
| 40 B slot (current)                        | 369 GB    | ❌          |
| 16 B compact slot (Chunk 2A)               | 148 GB    | ❌          |
| 8 B quotient/cuckoo (Chunk 2B)             | 74 GB     | ❌          |
| ~1.25 B/pos BuRR + ribbon filter (Chunk 4) | ~11.5 GB  | ✅          |
| ~0.14 B/pos BuRR value-only (1.1 bits)     | ~1.3 GB   | ✅          |

**DECISION GATE → PROCEED, but the only single-box route is Chunk 4.** n=16 (~2.3–18B,
central ~9.2B distinct) fits 26 GB *only* via the compressed-archive scheme (BuRR/ribbon
at single-digit bits/position → single-digit-to-low-tens of GB, robust even at the upper
tail). **Chunk 2's compact slot is necessary-but-insufficient on its own** (16 B × 9.2B =
148 GB ≫ 26 GB) — it serves the *dynamic/in-flight* tier, not the full solved set. So the
build order shifts: Chunk 2 (compact dynamic-tier slot) + Chunk 3 (two-tier replacement)
are stepping stones; **Chunk 4 (LSM + BuRR-archived solved positions) is the load-bearing
piece** for n=16. The bottleneck then moves from memory to compute time — as predicted.
(n=16 itself is never run for this measurement — running it to completion *is* the open
problem; the whole point of HLL is to size it without solving it.)

### Chunk 2 — pick the encoding based on Chunk 1's number

Two slot-shrink options (current slot is 40 B; the *position's* real entropy is
~66 bits, not 256 — it's a partial permutation `(n+1)^n` ≈ 2^66 for n=16):

- **(A) Exact, ~2.5×: compact lossless queen-set key.** Thread the queen set;
  encode the canonical placement as ≤16 columns + a row-occupancy mask (≤128 bits,
  two `u64`s) and pack the win/loss bit + `used` into spare bits → **16-byte slot**.
  Bonus: `canon` then folds ≤16 queen squares (cheaper than even Lever 1). Cost:
  keying on the queen set drops the rare *different-queens-same-blocked* merges
  (Lever 1's available-key keeps them) — **measure that merge loss on n=12/14**
  before committing; expect a few %. Stays "collision = miss, never wrong."
- **(B) Near-exact, ~5×+: quotienting (Cleary/Lemire) or a cuckoo filter.** Don't
  store the hash bits the slot index already encodes; store an ~50-bit remainder +
  value → **~8-byte slot**. Or a **cuckoo filter with a payload bit** at ~95% load
  factor (better packing than open-addressing). Use **Lemire `fastrange`**
  (`(h as u128 * n as u128) >> 64`) to size the table to ALL available RAM (any n,
  not just 2^k). Tradeoff: hash-based → ~2⁻⁸⁰ wrong-answer probability (negligible;
  cross-check the verdict against Jenrich's known n=16=second). Abandons strict
  "never wrong".

**Default recommendation:** do (A) first (principled, exact, and we can measure if
it even helps vs Lever 1). Layer `fastrange` (free, composes) regardless.

### Chunk 3 — two-tier TT replacement (Lever 2, orthogonal)

Replace `QueensTt`'s replace-always with **depth/subtree-size-preferred two-tier**
replacement (keep high-value shallow entries that gate the most recompute). Reduces
thrash independent of slot size. Classic chess-engine lever; in the Othello
TT-tuning spirit.

### Chunk 4 (ambitious, only if Chunk 1 says n=16 fits) — LSM-tree TT with BuRR archive

The big structural idea. A *static retrieval* structure (ribbon / **BuRR**, Dillinger
et al. 2022) stores an `r`-bit value per key in **~1.1·r bits** — for `r=1`
(win/loss) that's **~1.1 bits/position**, ~280× below the current slot. At that
density even 20B positions = ~2.75 GB → **storage stops being the wall.** But BuRR
is *static* (built from a known key set) — it can't be the live table. So:
- a small dynamic hash TT for in-flight/unsolved positions;
- periodically freeze the **solved** entries (proven win/loss) into an immutable
  **BuRR layer** (+ a ribbon membership filter per layer);
- cascade queries hot → layer₁ → layer₂ … (this is literally how RocksDB uses ribbon filters).
Solved positions dominate as the search matures, so resident memory collapses and
the bottleneck moves to compute time. This is the route to fit n=16 on one box.
**Substantial build**; only worth it if Chunk 1's number is in range.

(NOT useful here: Bloom/daisy-Bloom = membership only, no value; Sprague-Grundy
decomposition = game doesn't decompose; full-nimber n≥14 = mex blowup.)

## Codebase Reference

| What | Where |
|------|-------|
| Geometry, `pos_key`/`canon`, `mirror_line`, `best_move`, `principal_variation` | `rust/src/queens.rs` (`impl Queens`) |
| `Solver` trait + `Naive`/`Tt`/`Parallel`/`Nimber`/`Pn` | `rust/src/queens.rs` (after `// Solver lineage`) |
| `QueensTt` (40-byte slot; shard/slot masks; `hash`/`get`/`put`) | `rust/src/queens.rs` (`pub struct QueensTt`) — **this is what Chunks 2–4 reshape** |
| `PnTt` (proof/disproof table) | `rust/src/queens.rs` (`pub struct PnTt`) |
| Lineage cross-check test | `rust/src/queens.rs` `mod tests::solver_lineage_agrees` |
| OEIS nimber test + CLI table | `nimbers_match_oeis_a344227`; `A344227` const in `bin/queens.rs` |
| CLI modes (`solve`/`nimber`/`self`/`play`), `tt_bits`, `engine_move` | `rust/src/bin/queens.rs` |

## Build/Test Commands

Per `rust/Makefile` / global CLAUDE.md: `make release`, `make test`, `make clippy`
(all with the znver5+mold RUSTFLAGS). Bench a solver: `./target/release/queens
solve <n> <solver>`; nimber: `queens nimber <n>`. `QUEENS_TT_BITS` overrides TT size.

## Delegation Strategy

- **Chunk 1 (HLL)** — delegate to **Sonnet**: isolated, clear spec (add an HLL,
  feed `pos_key`, report). Main context reviews the extrapolation + makes the
  decision-gate call.
- **Chunk 2 (compact key)** — **Opus**: touches the recursion key + canon across
  solvers + correctness (merge-loss) reasoning. Architectural.
- **Chunk 3 (two-tier replacement)** — **Sonnet**: localized to `QueensTt`.
- **Chunk 4 (LSM + BuRR)** — **Opus**: cross-cutting, novel architecture; likely
  multiple sub-sessions. Do not start before Chunk 1's decision gate.
- Always validate against `solver_lineage_agrees` (and add a quotient/encoding
  variant to it) after any TT/key change; verdicts must match for n≤9.

## Workflow Instructions

- Read this file first; check Progress for what's next.
- **Chunk 1 is the gate** — do not build Chunks 2/4 until HLL says n=16 fits.
- After each chunk: update Progress, add a Handoff Note (with session ID), keep
  `make test`/`clippy` green, commit (simple message, no co-author).
- Any key/TT change MUST preserve `solver_lineage_agrees` (n≤9 verdicts).

## Progress

- [x] Lever 1: `pos_key` canonicalises `available` (committed `2ad7b97`, n=14 2.4×)
- [x] Chunk 1: HLL `count` mode; distinct = 94k/1.07M/49.3M (n=10/12/14); n=16 ≈ **9.2B**
      central (~2.3–18B). **GATE → PROCEED; single-box route is Chunk 4 only** (Chunk 2's
      16 B slot ≈ 148 GB ≫ 26 GB; BuRR archive ≈ 11.5 GB fits).
- [x] Tooling (session 3): `solve --distinct` re-expansion report (nodes ÷ distinct; exact
      for n≤12, HLL for n≥14); SIGUSR1/SIGINT/SIGTERM handlers + live width-aware progress
      bar; per-solver summary stats (TT fill, nimber value, pn φ/δ). Static
      `DISTINCT_POSITIONS` table now drives `tt_bits` (tapered headroom; `MAX_TT_BITS=28`;
      n=16 default TT 27→28, i.e. 5.4→10.7 GB). Parallelism negative (see fact #5) — reverted.
- [x] Chunk 2 (slot shrink, session 4, `6c32617`): **compact 8-byte fingerprint slot** (40 B
      → 8 B, **option B**, not the roadmap's option-A queen-set key). Packs `{used:1, val:8,
      fp:55}` into one `u64`; stores a 55-bit fingerprint of the canonical key (independent
      hash half) instead of the full 256-bit key → wrong-hit ≈ 2⁻⁵⁵/colliding-probe (cross-
      checked vs Jenrich). **Keeps the available-mask key, so merges are preserved exactly**
      (n=12 exact distinct unchanged at 1,060,823). n=14: **5.4 GB → 1.07 GB** at the same
      `tt_bits`, same ~1.09× re-exp, same second-player verdict. `MAX_TT_BITS` 28→31 (17 GB).
      *Why B over A:* for the dynamic tier B is smaller (8 vs 16 B) AND merge-preserving
      (A re-keys on the queen set → loses merges → more entries). A's queen-set encoding is
      reserved for the Chunk-4 archive's rankable key (see Chunk 4 prep).
- [ ] Chunk 2b: `fastrange` table sizing (Lemire multiply-shift) — let the table use **all**
      RAM, not just 2^k slots (currently `tt_bits` is a power of two; at 8 B/slot the gap
      between 2³¹=17 GB and 2³²=34 GB is the ~21 GB sweet spot on the 26 GB box). "Free and
      composes"; ripples into `tt_bits` (return a slot *count*, not bits) + the QueensTt ctor.
- [ ] Chunk 4 prep: thread the **queen set**, canonicalise+rank it (option A's ≤16-col +
      row-mask encoding), and **measure merge-loss** = (distinct canonical queen-sets) ÷
      (distinct available-masks) on n=10/12/14. Decides archive keyspace sizing; A's exact
      ranked key is the archive's membership/payload key (with Codex's guard).
- [ ] Chunk 3: two-tier depth-preferred TT replacement
- [ ] Chunk 4: **load-bearing for n=16** — LSM-tree TT with BuRR-compressed solved-position
      layers + ribbon membership filter → attempt n=16 (memory ✅; compute time is the new wall)
- [ ] Final: `make test` + `make clippy` green; n=16 verdict cross-checked vs Jenrich (second)

## Handoff Notes

### Session 4 — Chunk 2 slot shrink: 8-byte fingerprint slot (2026-06-15)

**Session**: 2026-06-15 (queens roadmap, session 4). Committed `6c32617`;
`make build`/`clippy`/`test` green, `fmt-check` clean on my files (a pre-existing
`table.rs` fmt drift from the list-engines commits is unrelated — left untouched).
**Files**: `rust/src/queens.rs` (the slot + hash + get/put + a new
`fingerprint_slot_is_compact_and_round_trips` test), `rust/src/bin/queens.rs`
(`MAX_TT_BITS` 28→31 + byte-figure comments), `rust/README.md` (TT writeup).

**What landed — Chunk 2 as option B, not A.** Replaced `QueensTt`'s 40-byte
`{key:[u64;4], val, used}` slot with a single `u64`: `{used:1, val:8, fp:55}`. The
slot stores a **55-bit fingerprint** of the canonical key (from an independent
`hash128` half), not the full 256-bit key. `get` matches on fingerprint; a wrong
"hit" is ~2⁻⁵⁵ per colliding probe (negligible across 10¹¹ nodes; verdict cross-
checked vs Jenrich). A fingerprint *mismatch* is still just a miss that recomputes.

**Why I diverged from the roadmap's "do A first."** The roadmap defaulted to option
A (lossless queen-set key, 16 B). After studying the code I judged **B strictly
better for the *dynamic tier***: it's 8 B (vs A's 16 B) **and** it keeps the
available-mask key, so all transposition merges survive — whereas A re-keys on the
queen set and *loses* merges (more entries, the opposite of what a memory-bound
tier wants). A's real value is downstream: its rankable queen-set encoding is the
right **Chunk-4 archive key**, where the merge-loss number actually matters. So I
split them: B = dynamic slot now; A = Chunk-4 prep (with merge-loss measurement).

**Validation (the success criterion, met):**
- `solve 14 --distinct`: second-player win, distinct ≈ 49.08M (HLL, ~baseline),
  **TT 1.07 GB (was 5.4 GB) — 5× less RAM at the same `tt_bits=27`**, 1.09× re-exp.
- `solve 12 --distinct`: second-player win, distinct **1,060,823 (exact, identical
  to baseline)** → merges preserved byte-for-byte, no merge-loss.
- `solver_lineage_agrees` (n≤9) + `counting_preserves_verdict` + the new size/round-
  trip test all green. Slot is exactly 8 bytes (`size_of` asserted).
- Wall time unchanged (~11.6s n=14) — the fingerprint compare adds nothing
  measurable; consistent with the throughput-bound thesis (fact #5).

**`MAX_TT_BITS` 28→31**: at 8 B/slot, 2³¹ = 17 GB (was 2²⁸×40 B = 10.7 GB), using
the freed RAM on the 26 GB box. n=16 default TT now ~17 GB holding ~2.1B of ~9.2B
distinct (≈23%, was ≈3%) — 8× more, still thrashes (Chunk 4 remains load-bearing).

**Next**: Chunk 2b (`fastrange`, fills the 17→34 GB power-of-two gap) is a small
free win; the substantive path is **Chunk 4 prep** — thread + canonicalise + rank
the queen set, measure merge-loss, then build the BuRR archive with Codex's
membership guard. Any TT/key change must keep `solver_lineage_agrees` (n≤9) and a
fresh `solve 12/14 --distinct` (distinct unchanged; re-exp ≈ 1.0×).

### Session 3 — observability + re-expansion tooling, cardinality table, parallelism negative (2026-06-15)

**Session**: 2026-06-15 (queens roadmap, session 3). All committed (`b603e15` …
`3565f1c`); `make test`/`clippy`/`fmt` green. Only `rust/src/bin/queens.rs`
(+ `Cargo.toml` for `signal-hook`, `terminal_size`) changed for the CLI/tooling;
`rust/src/queens.rs` gained `Solver::stats()`/`root_progress()` + `QueensTt/PnTt::
fill()/summary()` + Nimber/Pn root caches (the parallelism experiments there were
reverted).

**Built (all on the `solve`/`count` CLI — no change to the search itself):**
- **Observability**: SIGUSR1 → live progress dump to stderr; SIGINT/SIGTERM →
  "how far it got" report then exit 130/143; live progress bar for n>8 on a TTY
  (spinner + determinate root-move bar + nodes/elapsed/rate), **width-aware**
  (truncates to terminal cols, never wraps). Adaptive rate (M/s→K/s→/s),
  comma-grouped node counts.
- **Per-solver summary** (dim grey line): TT fill %, `nimber` value, `pn` root
  φ/δ, `parallel` worker count + root-move fan-out.
- **Re-expansion metric** (the thrash gauge = nodes ÷ distinct): `solve --distinct`
  reports it — **exact** distinct for even n≤12 (from the table), HLL for n≥14,
  and live in the bar; `count` mode gained the same ratio line.
- **Static `DISTINCT_POSITIONS[0..=16]`** (exact ≤12, HLL n=14, extrapolated n=16)
  drives `tt_bits` (tapered: small boards ~1.0× re-exp cheaply, big boards lean on
  `MAX_TT_BITS=28`). Right-sizes small boards (n=12: 2.7 GB → 1.3 GB at ~1.0×) and
  bumps n=16 default 27→28 (5.4→10.7 GB).
- CLI polish: `solve --help` wording; `--engine` on `self`; chess-coloured queens
  (grey 240 / white 255 by square parity); dark-red `.` for attacked cells.
- **`self`/`play` perf fix**: they drive the engine via `Queens::best_move` (a
  sequential loop over `Solver::wins`, which for `Parallel` is the *sequential*
  `Tt::wins`), so they got no root parallelism and `self 14` re-searched the whole
  tree single-core (≫ `solve 14`). Fix: `warm_table()` runs one parallel
  `first_player_wins` before the move loop (as `solve` does implicitly), so
  per-move `best_move` hits the warm table. `self 14`: single-core slog → 11.9 s.

**Discoveries:**
- **The search is TT-DRAM-latency-bound, not parallelism-bound** (see fact #5).
  ~18× parallel ≈ hardware ceiling; the lever is per-node/memory cost (Chunk 2).
- **Deeper parallelism defeats the α-β cutoff** (fact #5) — reverted, documented in
  `Parallel::first_player_wins`. Don't re-attempt.
- **n=16 thrash confirmed live** (user run): 2B nodes / 485 s at ~4M nodes/s
  (parallel — cores engaged), into a 134M-slot TT (~15× over) → pure re-expansion,
  climbing toward Jenrich's 71B, killed. Exactly the Chunk 1 memory wall.

**Next steps**: roadmap unchanged (Chunk 2 → 3 → 4), but now **instrumented** —
`solve --distinct` measures re-expansion directly, so Chunk 2's compact slot can be
validated (target: re-exp ≈ 1.0× at larger n on the same RAM) and any n=16 attempt
monitored live (SIGUSR1 / the bar) and killed cleanly. **Validation**: any TT/key
change must keep `solver_lineage_agrees` (n≤9) and a fresh `solve 14 --distinct`
near ~49.3M distinct / ~1.0× re-exp (a re-expansion jump = lost merges or an
under-sized TT). For an n=16 run, raise `QUEENS_TT_BITS` toward the box's RAM (≈29
= 21.5 GB) to cut thrash — it still won't converge without Chunk 4.

### Chunk 1 landed — distinct-position measurement + decision gate (2026-06-15)

**Session**: 2026-06-15 (queens roadmap, session 2).
**Completed**: Chunk 1. Added the `count` CLI mode (HyperLogLog p=4..=18 + optional
exact hash set), wired non-invasively into `QueensTt::get` so it measures any
solver's working set; two new tests (`hll_estimates_a_known_cardinality`,
`counting_preserves_verdict_and_tracks_exact`). `make test`/`clippy`/`release` green.
**Files**: `rust/src/queens.rs` (Hll/Counter/CountReport + `new_counting` on
QueensTt/Tt/Parallel + `Solver::report`), `rust/src/bin/queens.rs` (`Count` subcommand,
`count_mode`).
**Headline numbers** (parallel-HLL, second-player boards): n=10 = 94.3k, n=12 = 1.07M,
n=14 = **49.3M distinct** (not 53M — that was the inflated node count). Growth
accelerating (11.4× → 46.1×). n=16 ≈ **9.2B** central (range ~2.3–18B).
**Decision (the gate's whole purpose)**: **PROCEED to n=16, but only Chunk 4 fits one
box.** A 16 B compact slot × 9.2B ≈ 148 GB ≫ 26 GB, so Chunk 2 alone is insufficient;
the BuRR/ribbon archive (~1–1.5 B/pos all-in ⇒ ~11.5 GB, robust to the upper tail) is
the load-bearing piece. Re-scope Chunk 2 as the dynamic-tier slot feeding Chunk 4.
**Reproduce**: `queens count <n> [--parallel] [--exact] [--hll-p P]`. Exact validates
HLL on n≤12; `--parallel` (HLL-only) is fast enough for n=14 (~12s). Never run n=16 to
completion — it's the open problem; extrapolate.
**Next agent**: start Chunk 4 design (LSM + BuRR), treating Chunk 2/3 as its dynamic
tier. Opus-grade, cross-cutting; likely multiple sub-sessions. Validate any TT/key
change against `solver_lineage_agrees` (n≤9 verdicts) and a fresh `count 14` (distinct
must stay ~49.3M for an exact scheme; a drop means lost transposition merges).

### Roadmap authored (2026-06-15)

**Session**: 2026-06-14--3 (`04e367e2-6055-4634-8632-6c841b6c978e`)
**Completed**: Lever 1 (available-canon, 2.4× on n=14) committed; this roadmap.
The session before also landed: queens lineage decomposition, odd-board O(1),
nimber solver (OEIS-validated ≤ n=12), df-pn negative, MPC `strong++` (Othello).
**Files**: `rust/src/queens.rs`, `rust/src/bin/queens.rs`, `rust/README.md`.
**Instructions for next agent**: Start with Chunk 1 (HLL) — it's cheap and it
decides everything. Don't build a fancy TT before knowing n=16's distinct count.
When you touch the TT key/slot, re-run `solver_lineage_agrees` and a fresh
`queens solve 14` (node count must stay ~53M for an exact scheme, or you've lost
merges). The current n=14 baseline is **33.0s / 53.2M nodes** on the 24-thread box.
