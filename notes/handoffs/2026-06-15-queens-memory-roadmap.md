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
- [ ] Chunk 2: compact lossless queen-set key (16-byte slot) + `fastrange`; measure merge-loss
      — now scoped as the **dynamic/in-flight tier**, not the full table (it can't hold ~9B)
- [ ] Chunk 3: two-tier depth-preferred TT replacement
- [ ] Chunk 4: **load-bearing for n=16** — LSM-tree TT with BuRR-compressed solved-position
      layers + ribbon membership filter → attempt n=16 (memory ✅; compute time is the new wall)
- [ ] Final: `make test` + `make clippy` green; n=16 verdict cross-checked vs Jenrich (second)

## Handoff Notes

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
