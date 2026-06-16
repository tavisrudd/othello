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

`QueensTt` = fixed-size open-addressing table; slot is a compact **8-byte** `u64`
(`{used:1, val:8, fp:55}`, Chunk 2 / session 4) — the old 40-byte full-key slot is gone.
It is now **lockless and unsharded** (Session 5, L1, `9b30cb2`): one flat
`Box<[AtomicU64]>` with relaxed load/store + `MADV_HUGEPAGE` + per-child slot prefetch,
no mutex. `PnTt` is still sharded (1024) `Mutex<Box<[PnSlot]>>` with `(phi,delta)` — it's
a tiny-board experiment, not under memory pressure.

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
5. **Deeper parallelism: naive YBWC is a negative, but PARITY-AWARE recursion is a
   clean WIN (corrected session 7).** *Naive* recursive YBWC (parallelise every
   level, elder child first) defeats the α-β cutoff — it searches children the cutoff
   would skip (~97M vs ~53M nodes) — and was rightly reverted in session 3. **The
   refinement that works:** the tree alternates *prove-a-loss* nodes (every child must
   be searched ⇒ **no cutoff to lose**) with *prove-a-win* nodes (one winner suffices
   ⇒ cutoff). For a second-player win the root and the **even** plies below it are
   prove-a-loss: fan **all** their children across rayon — same nodes as sequential,
   **zero speculation** — and keep the **odd** (prove-a-win) plies sequential so the
   cutoff survives. This is `Parallel::par_wins` (session 7, `2f51aa5`): n=14 53.3M
   nodes (= baseline), **8.2 s vs 9.8 s, 22.5 cores vs 13.5**; **n=16 24 cores vs the
   old single-core lead** (which at n=16 *never finished* — root-0's subtree is the
   whole runtime). So the old "keep the sequential-lead guard / don't re-attempt" is
   superseded for the elder brother. The search is still DRAM-bound *per useful node*,
   but it is no longer leaving cores idle. `QUEENS_PAR_DEPTH` (default 3) tunes it.

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
| `QueensTt` (8-byte fingerprint slot; shard/slot masks; `hash`/`get`/`put`) | `rust/src/queens.rs` (`pub struct QueensTt`) — **this is what Chunks 2–4 reshape** |
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
- **Ask before any revert.** Never undo work (revert an experiment, drop a change,
  back out a file) without asking the user first — they may want to read it, keep the
  tooling, or decide differently. Surface the measurement and the recommendation, then
  wait for the go-ahead.
- **Report results as simple win / loss summaries.** Lead with the verdict — did the
  lever win or lose, and by how much — in one or two lines, before any mechanism or
  detail. (e.g. "history ordering: LOSS, +130% working set at n=14"; "graph-iso:
  WIN-but-unsized, 3.4× at n=12 capped to [1.3×, 3.4×] safe").

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
- [x] Chunk 2b: `fastrange` table sizing (session 7) — `QueensTt` now indexes by Lemire
      multiply-shift (`index()`) instead of `& mask`, so the table can be **any** slot count,
      not just 2^k. `QUEENS_TT_SLOTS=<count>` (resolved once in the ctor, never per node) fills
      RAM exactly — e.g. the 17→34 GB power-of-two gap at n=16. *Lower-ripple than the roadmap's
      "tt_bits returns a count" plan:* kept every `new(bits)` signature (zero call-site/test
      churn), the override just supersedes `1<<bits`. Gates hold (distinct 1,060,823; solve 14
      second, 1.08× re-exp; all tests). **Pulls its weight:** n=14 forced-small TT, the 50M
      intermediate size = 1.21× re-exp @ 0.40 GB, between 2²⁵ (1.35× @ 0.27 GB) and 2²⁶ (1.16× @
      0.54 GB) — hits the sweet spot the power-of-two grid skips.
- [ ] Chunk 4 prep: thread the **queen set**, canonicalise+rank it (option A's ≤16-col +
      row-mask encoding), and **measure merge-loss** = (distinct canonical queen-sets) ÷
      (distinct available-masks) on n=10/12/14. Decides archive keyspace sizing; A's exact
      ranked key is the archive's membership/payload key (with Codex's guard).
- [x] **Lead L1 (session 5, `9b30cb2`): lockless TT + prefetch + huge pages.** Swapped
      `Vec<Mutex<Box<[Slot]>>>` for one flat `Box<[AtomicU64]>` + relaxed load/store (fp
      self-validates → no lock, no Hyatt XOR-key); `wins()`→`wins_keyed()` software-prefetches
      each child slot before recursing; arena is `MADV_HUGEPAGE`-backed (THP is `[madvise]` on
      the box). Verdicts + distinct unchanged (n=12 exact still 1,060,823). **Did NOT lift the
      ceiling to a multiple** — interleaved A/B (n=14 parallel, thermal-controlled): ~3–5 %
      wall, prefetch ~2 % of that (isolated with a temp toggle, 4/4 rounds, both arms paid the
      `var_os`; toggle reverted). Modest but real, consistent with the DRAM-bound thesis (fact
      #5). *Prefetch caveat:* the hide window is just a call + a 2nd `hash128` (~20 cyc vs
      ~250 cyc DRAM), so its small win likely comes from issuing the non-blocking probe early;
      threading the `(route,fp)` from `prefetch` into `get` would remove the 2nd `hash128`
      (deferred micro-opt). Remaining per-node levers: **cache-line bucketing** (#4),
      **AVX-512 canon** (#5) — see lever backlog below.
- [ ] **Lead L2 (session 5): window the TT by ply.** Transpositions are **strictly intra-ply**
      (each move places one queen → transposing positions share a queen count), so the TT
      partitions cleanly by ply and never needs cross-ply co-residency. Licenses a ply-layered
      + **external-memory delayed-duplicate-detection** solve (Korf 2008; Zhou–Hansen) — the
      ~9.2B distinct positions fit on disk at a few B each — and reframes Chunk 4 as
      freeze-each-solved-ply-into-BuRR. A more robust n=16 route than an all-in-RAM table.
- [x] **Lever #7 graph-isomorphism canon (session 6) — VALIDATED WIN.** `count --iso` +
      `iso_key`/`iso_key_ir`/`iso_key_canon`/`iso_key_fast`. Safe merge **2.63/3.17/3.42/3.40×**
      (n=8/10/12/14, plateaus ~3.4×) → n=16 ~3.4× (~9.2B→~2.7B, ~21 GB). Live-key spike
      (`QUEENS_KEY=fast`, commits `594ab4e`/`0d7c145`/`29937b2`): 3.4× fewer nodes but wall
      LOSS at n ≤ 14 (TMA frontend/branch-bound; D4 branchless). **Deploy as the Chunk-4
      freeze-time key (option 2)**, not the live key. Next: branchless refine (#17), pseudo-
      memoize recurring components (#18).
- [x] **#18 tiny-component shortcut (session 7, `5bd9564`) — WIN: +6% throughput at n=16.**
      `comp_canon` now maps every `k ≤ 4` component straight to a constant from its sorted degree
      sequence (a *complete* iso invariant for connected graphs on ≤4 vertices — proven by the new
      `tiny_component_key_matches_full_canon` test, same partition as the full WL+IR canon), skipping
      CSR build + WL + cert hashing. Merge preserved exactly (fast-key node count unchanged: n=14
      ≈14.8M, n=12 ≈311k), verdict unchanged. **n=16 partial-run throughput +6.2%** (taskset-pinned,
      concurrent, swapped); n=14 parallel ~4-5%; n=12-parallel ~0% (too small to measure). **New
      `count --comps` tool
      (monomorphised `iso_key_fast_in::<const HIST>`, zero production cost) CORRECTS the prior:** tiny
      components are **only ~32% of all components** at n=12 (k=1 = 15%, mass at k=5–8 ≈10% each), NOT
      "overwhelmingly tiny" — so #18 removes WL on the cheapest third; the k=5–16 bulk (the real
      per-node cost) is untouched → that's #17's target, with more headroom than #18 had.
- [x] **Root parallelism fix (session 7, `2f51aa5`) — n=16 was running SINGLE-CORE.**
      The Parallel solver searched root move 0 (the dominant "elder brother") fully
      sequentially as a TT-warming lead before fanning the rest; at n=16 that subtree is
      the whole feasible runtime, so the search sat on **1 core for hours** (Phase 2 never
      started). Fix = `Parallel::par_wins`: bounded recursive parallel search (top
      `QUEENS_PAR_DEPTH` plies, default 3) that fans **all** children at the *even*
      prove-a-loss levels (no α-β cutoff there ⇒ free, zero speculation) and keeps the
      *odd* prove-a-win levels sequential (cutoff preserved). **n=16: 1.4 → 24 busy cores;
      n=14: 53.3M nodes (= baseline, no speculation), 8.2 s vs 9.8 s, 22.5 cores vs 13.5.**
      Verdict + distinct unchanged. Supersedes fact #5's "keep the sequential lead." See
      `[[queens-parallel-parity-ybwc]]`.
- [~] Chunk 3: two-tier depth-preferred TT replacement — **tried, NEGATIVE, parked on
      branch `chunk3-depth-preferred-tt`.** Depth-preferred (keep high-avail/shallow) was
      **3× worse** re-exp at a forced-small n=14 TT (1.34×→4.3×): it evicts the deep,
      heavily-reused transpositions; replace-always (recency ≈ keep-deep in a DFS) wins.
      Kept off main on the branch in case the inverse/two-tier variants are worth a look.
- [ ] Chunk 4: **load-bearing for n=16** — LSM-tree TT with BuRR-compressed solved-position
      layers + ribbon membership filter → attempt n=16 (memory ✅; compute time is the new wall)
- [x] **n=16 SOLVED (session 7, 2026-06-15) — SECOND PLAYER WINS, cross-checks Jenrich.**
      First multi-core run after the parity-YBWC fix: **36/36 distinct first moves refuted**
      (search ran to completion without short-circuiting ⇒ no winning first move ⇒ second
      player wins), **10,017,867,872 nodes · ~7.2B distinct (= 10B ÷ 1.4× re-exp) · 1.4×
      re-exp · 3371 s ≈ 56 min · 2.97 M/s · full 24 cores.** Validates the whole stack:
      the ~7.2B distinct lands inside the Chunk-1 HLL estimate (9.2B central, 2.3–18B), the
      1.4× re-exp shows the TT held the working set (memory levers), and 56 min vs Jenrich's
      23 h is the parallelism unlock. **Rough edge found:** after `first_player_wins` returns,
      `solve()` computes `principal_variation` via the *sequential* `best_move`/`Tt::wins`,
      so for n=16 it re-searches evicted PV positions **single-core** (slow) — and the verdict
      print is gated behind it. Fix queued (backlog #21): print the verdict before the PV +
      drive the PV through the parallel solver (or depth-limit it). The verdict is unaffected.
- [x] **#21 PV no-grind (session 8, `986ce4b`) — DONE.** `principal_variation` now takes
      `root_wins` and threads the value down the optimal line (strictly alternates
      loss→win→loss…): a **loss** ply takes the first legal move with **no search**, only a
      **win** ply searches (`best_move` cutoff over the warm TT). For a 2nd-player win the root
      is a loss, so the old 36-subtree single-core root re-search collapses to one
      `first_available`. CLI prints the verdict **before** the PV (no longer gated behind the
      grind). PV byte-identical by construction (loss ply = `first_available` = old loss
      `best_move`). Gates green. `best_move` unchanged (interactive play/self).
- [x] **TT dump/load — checkpoint + warm resume (session 8, `a57c8c0`) — DONE (proposal Phase 1).**
      Approach A raw image, validated 64-B header (magic + format/hash/canon/arch ids + n +
      **len** [slot count, since routing = `fastrange(route,len)`] + epoch); tag mismatch =
      hard error. `QueensTt::dump_image`/`load_image` (generic Write/Read, lib has no zstd dep;
      zstd wrapping in the bin), `attach_counter`, `Tt`/`Parallel::from_tt`, `Solver::tt()`.
      CLI (opt-in): `solve --checkpoint[=PATH] / --no-checkpoint / --checkpoint-every <dur> /
      --resume`. **Checkpoint defaults ON for n=16, OFF below.** zstd-compressed, atomic write
      (`.tmp`→rename, keep `.prev`); periodic (5m) + final + SIGUSR2 dump-now + SIGINT/SIGTERM
      save-before-exit, all in the watcher thread. Live dump is good-enough-live (each slot one
      atomic u64). **Validated e2e:** solve 14 --checkpoint then --resume = same verdict/line in
      **2,232 nodes / 0.002 s vs cold 53M / 11.9 s**; n=16 default-on writes `./queens-tt-n16.zst`;
      SIGINT interrupt-dumps; wrong-n resume is a hard error. Round-trip unit test +
      gates green. **This is the n=16 benchmark-fixture + checkpoint/resume primitive.**
      Deltas / B2 (Phase 2) deferred.
- [x] **#20 size-based parallel split (session 8, `54b3ccd`) — DONE, n≥15 gated.** A node below
      `par_depth` keeps splitting while available-square count > threshold (subtree-size proxy)
      so an idle core can steal a deep straggler — kills the tail core-drain. Parity-gated
      (even/prove-a-loss only) ⇒ zero speculation, node count identical (n=12 1,060,823; n=14
      53.2M). **Gated auto-on only for n≥15** (default min-avail 96); below it the size split
      is off (forcing it on n=14 regressed ~3%, no tail to fix there). Threshold resolved once
      per solve, threaded through the recursion (no per-node env/atomic). `QUEENS_PAR_MIN_AVAIL`
      overrides (huge = pure fixed-`par_depth` A/B baseline). **n=16 tail benefit pending the
      full-run measurement** (next).
- [ ] **NIGHT GOAL (session 8): get n=16 under 30 min total** (from session 7's 56 min), using
      the checkpoint fixtures to A/B levers. Plan: (a) test `QUEENS_KEY=fast` **live at n=16**
      (the unrun high-value experiment — 3.4× fewer nodes + fits RAM where D4 thrashes; handoff
      kept it freeze-time-only based on n≤14, but n=16 is the regime where it might win live);
      (b) measure #9 free-involution P-certificate fire-rate (cheap counter first); (c) #20 tail
      validation; (d) definitive full n=16 run with the best config. Gate any n<16 regression;
      branch anything that can't be saved on main.
- [ ] Final: `make test` + `make clippy` green (still required for any new code).

## Lever backlog (sessions 4–5 reviews, prioritised)

Consolidated from two "other-agent" perf reviews. Grouped A (per-node cost) / B (node
count) / C (TT memory / windowing). ⭐ = ROI·(1/effort). Items already tracked above
are cross-referenced, not repeated.

| # | lever | cluster | status / where |
|---|-------|---------|----------------|
| 1 | Lockless unsharded `AtomicU64` TT | A | **done** — L1, `9b30cb2` |
| 2 | Software-prefetch child slot | A | **done** — L1 (measured ~2%) |
| 3 | Huge pages (`MADV_HUGEPAGE`) | A | **done** — L1 |
| 6 | ~~History / killer move ordering~~ | B | **NEGATIVE (session 6) — move ordering is a dead end here.** The static most-blocking order is *near-optimal* (this is a blocking game). History (global β-cutoff tally) is **~2× WORSE** (n=14 working set 49.1M→113.0M, +130 %; robust to weight); effective-degree (context-local, #6b) decays to ~0 by n=16 and reverses under parallel. Killer-per-ply untested but a poor bet (Othello "depth-indexed killers mis-order" + this blow-up). **Spend effort on structural levers (#7/#8/#11/Chunk 4), not ordering.** Tables + mechanism in the session-6 note. |
| 6b | ~~Dynamic effective-degree ordering~~ | B | **NEGATIVE (session 6).** Re-rank by `popcount(attack & available)` per node: shrinks the *sequential* working set but the gain **decays super-linearly** (1.80×→1.33×→1.025× at n=10/12/14 → ~0 at n=16) and **reverses under parallel** (n=14 +9–12 %). Mechanism + table in the session-6 handoff note. Reverted. |
| 16 | ABDADA in-evaluation deferral | A/C | **lock-free-enabled.** Mark a slot "being evaluated" (spare bit; `val` uses 1 of 8); a 2nd worker reaching it *defers* (other moves first, return later) not duplicates. *Defers*, so unlike deep-YBWC (fact #5) it preserves the α-β cutoff. Targets the ~1.6 % parallel NODE re-expansion only — **compute/DRAM, not the distinct working set**; low priority, DRAM-bound search. |
| 17 | ~~Branchless graph-key refine~~ | A | **DONE (session 7) — WIN, +3.5% at n=16 (value-preserving).** Padded each WL neighbour row to a fixed `stride` (max degree) with a DUMMY filler → fixed-trip inner loop (kills the per-vertex exit mispredict), and **hoisted `mix64` out of the per-edge loop** into `mcol` (computed once/vertex/round = `k` calls, not once/edge = `2|E|`); the DUMMY's mixed colour is held at 0, so colours come out **byte-identical** (n=12 symmetry fast = 310,356 exactly, all tests pass). +3.5% n=16 partial throughput (taskset, swapped), +3.2% n=14 wall, ~1-2% n=12 (smaller/sparser comps). Modest — the padding wastes adds on skewed-degree comps, offsetting some of the branch+hoist win. **#17b (compact-local layout + AVX-512) landed +2% more** at n=16 (mix64's shifts/xors vectorise to `vpxorq`/`zmm`; the 64-bit multiply stays scalar `imul` — znver5 cost model — capping it). Remaining bang: **#19 amortize comp_canon setup via a per-thread component cache** — see session-7 note. |
| 18 | ~~Pseudo-memoize tiny components (no table)~~ | A | **DONE (session 7) — WIN, modest (~4-5%, grows with n).** `comp_canon` maps `k ≤ 4` components straight to a constant from the sorted degree sequence (complete iso invariant for connected graphs on ≤4 vertices; `tiny_component_key_matches_full_canon` proves same partition as the full canon), skipping CSR+WL+cert. Merge + verdict preserved. **`count --comps` corrected the prior:** tiny components are only ~32% of all (not "overwhelmingly tiny"), so the win is bounded — the k=5–16 bulk (#17) is the real cost. The tooling is monomorphised on `const HIST` (zero production cost; demonstrates the hot-path-toggle rule). k=5,6 stay un-shortcut: degree sequence is *not* complete past k=4. |
| 11 | **Ply-windowing + external-memory DDD** ⭐⭐ | C | **lead L2** (Progress) — the structural n=16 route. Transpositions are *strictly intra-ply*, so layer-by-layer + disk DDD (Korf 2008; Zhou–Hansen). |
| 12 | BuRR/ribbon value-only archive | C | Chunk 4 (Progress) — ~1.1 bit/key; pairs with #11 (freeze a solved ply → BuRR). |
| 13 | Size/subtree-value-preferred replacement | C | Chunk 3 (Progress) — *more valuable now* (17 GB holds ~23% of n=16, so which entries you keep has leverage; `put` is still replace-always). |
| 7 | **Graph-isomorphism canon** ⭐⭐ | B/C | **MEASURED + VALIDATED (session 6) — a WIN, the lever to pursue.** Canonicalise the available-*graph* up to iso, not just D4. `count --iso` with a true IR canonical form (`iso_key_canon`, 0 mixed = provably safe): **2.63 / 3.17 / 3.42 / 3.40×** at n=8/10/12/14, win/loss-consistent (a usable safe key). Rises then **plateaus ~3.4×** → n=16 ≈ 3.4×, ~9.2B → ~2.7B distinct ≈ ~21 GB raw (borderline RAM, multiplies Chunk 4 down ~3.4×). The cheap IR invariant agrees exactly with the canon at every n. (The earlier "[1.30×,3.39×]" bracket was a TT-eviction artifact in the value lookup, fixed by recording values at `put`.) **Live-key spike DONE** (`QUEENS_KEY=fast`): cuts nodes 3.4×, but ~µs/node ⇒ wall LOSS at n ≤ 14 (D4 is branchless); TMA frontend/branch-bound. **Use it as the Chunk-4 freeze-time key (option 2), not the live key** — see session-6 note + row #17 (branchless, queued). |
| 8 | Decomposition + small-component nimber DB | B/C | residual graphs *fragment* in the endgame (where the no-cutoff `mex` blowup doesn't apply); value = XOR of small-component nimbers. Prunes subtrees AND stores tiny components instead of full positions. Softens key-fact "doesn't decompose" (true for the *full* board, not deep leaves). |
| 9 | ~~Free-involution → instant P-verdict~~ | B | **NEGATIVE (session 8) — fires too rarely; not built, probe kept.** Built `count --psym` + `Queens::is_free_involution_loss` (180°-symmetric AND off both centre diagonals; D4-invariant so exact on the canonical key; sound — 0 false fires on win positions at every n). **Fire-rate over the exact working set: n=10 0.07%, n=12 0.018%, n=14 0.003% of loss positions — falling ~4× per n step** (n=16 ≈ 0.0008%). Deep positions are almost never 180°-symmetric (symmetry survives only on the thin mirror-spine), so a per-node check would be ~pure overhead on the DRAM-bound hot path. Documented negative (cost = the `--psym` probe, kept as cold tooling + a unit test). Commit `4a97551`. Original hypothesis below. ⤵ |
| 9-orig | (original #9 writeup) | B | **novel.** Generalise the odd-n centre+180° pairing: at any node, if the residual available-graph admits a fixed-point-free edge-respecting involution, it's a second-player win — return P, no search. P-certificates can sit deep, not just at the root. **Concrete starting form (from Jenrich's `rotsym`, session 7):** if the available mask is **180°-symmetric** (`available == rot180(available)`, using `sym[2]`) **AND** no available square is on the two centre diagonals (`r=c` or `r+c=n-1`, a precomputed `diag_mask`), the mover **loses** → return P, no search. Sound: the responder mirrors every move; the off-diagonal condition guarantees a move never removes its own 180° image, so the symmetry (and the condition) is preserved all the way down. Jenrich's noted mirror-failures (*"for instance (1,2) and (6,7)"*) are exactly the on-diagonal squares — empirical confirmation of the side condition. Targets the expensive **prove-a-loss (even/AND) nodes** (the no-cutoff levels par_wins fans wide), where mirror-spine symmetry clusters. **MEASURE FIRST when we get to #9:** add a cheap fire-rate probe (a `count`-style pass, like `--comps`) counting the fraction of *visited* nodes that are 180°-symmetric-and-diagonal-free — overall and among prove-a-loss nodes — **before** wiring the certificate in. Most deep nodes are asymmetric, so a per-node symmetry check is net overhead if it rarely fires; only build the certificate if the fraction is meaningful, else record the negative (cost = one counter). The dumped n=16 TT (dump/load task) is the ideal corpus for this probe. |
| 4 | Cache-line bucketing (8 slots/64 B line) | A | probe a line before evicting; one miss serves 8 candidates + a better replacement policy. Composes on the flat lockless arena. |
| 5 | AVX-512 canon | A | vectorise the 8-fold D4 fold of the 256-bit board; znver5 has AVX-512. Minor. |
| 15 | Cuckoo filter, 1-bit payload | C | we're already lossy (2⁻⁵⁵ fp); a cuckoo filter at ~95% load packs more entries/byte than open-addressing — a cheap intermediate before the full BuRR build. |
| 10 | df-pn done right (DAG/GHI-aware) | B | in roadmap (Kishimoto–Müller GHI-safe df-pn; Čížek–Balko–Schmid 2026). High effort; only if A/B don't reach n=16. |
| 20 | **Size-based parallel split (kill the single-core tails)** ⏭ | A | **QUEUED — observed live on the n=16 run (session 7).** `par_wins` parallelises a fixed top `par_depth` plies, so every subtree at depth ≥ `par_depth` is an *atomic single-core task*; uneven ⇒ stragglers ⇒ cores drain to a few then to 1 at the tail of each parallel region, **worst near the end** (few root moves left ⇒ all parallelism is intra-root, and its sequential tails are all that remain). Harmless (load imbalance, no speculation, verdict-safe), but leaves cycles idle. Quick lever: raise `QUEENS_PAR_DEPTH` (6+). Real fix: **split by subtree size, not fixed depth** — parallelise an even (prove-a-loss) node while its available-square count is above a threshold (big ⇒ keep splitting; small ⇒ go sequential), so the big stragglers get divided directly. Still parity-gated (even-only) ⇒ no speculation. |
| 21 | **PV no-grind (verdict-first + TT-aware/parallel PV)** ⏭ | A | **QUEUED next session (do this FIRST, before dump/load).** Observed live: after `first_player_wins` returns (n=16 36/36 = second, ~56 min), `solve()` computes `principal_variation` via the *sequential* `best_move`, which **re-confirms the root loss by re-searching all 36 first-move subtrees single-core** (evicted ones from scratch, billions of nodes each) — and the verdict print is gated behind it, so it grinds one core for ~hours before printing a result that's already settled. **Fix (no new tracking — the TT already holds every value):** (1) **print the verdict immediately after `first_player_wins`**, then compute the PV. (2) Make `principal_variation` **value-aware via parity**: the optimal line strictly alternates loss→win→loss→… (a loss node's any-move → a win child; a win node's winning-move → a loss child), so pass `root_wins` in and: at a **loss** ply take the **first legal move with NO search**; at a **win** ply find the winning child via `solver.wins` (warm-TT hits + cutoff). This kills the root re-search entirely. (3) Optional: route any residual evicted win-child re-search through the **parallel** solver, not sequential `Tt::wins`. Validate: PV identical to before on small n; `principal_variation` callers (bin `solve`, 3 tests) updated for the new `root_wins` arg. Keep `best_move` as-is for interactive `play`/`self` (no known value there). |
| — | `fastrange` table sizing | A/C | Chunk 2b (Progress) — fill the 17→34 GB power-of-two gap. |
| — | Chunk-4-prep: rank the queen set + measure merge-loss | C | (Progress) — option-A encoding as the archive's rankable key. |

## Handoff Notes

### Session 8 (2026-06-15) — #21 + dump/load + #20 landed; #9 & live-fast-key NEGATIVE; n=16 < 30 min push

**Mode:** intent-based (`mi`), autonomous overnight ("keep working all night"). Goal set by
user: **get n=16 under 30 min** (from session 7's 56 min), use the new checkpoint dumps as
warm fixtures, gate any n<16 regression, branch anything unsavable.

**Landed (committed, all gates green — `make test`/`clippy`; `solve 12 --distinct` second
1,060,823 1.01×; `solve 14` second 53.2M):**
- **#21 PV no-grind** (`986ce4b`): parity-aware `principal_variation(root_wins)` — loss ply =
  first legal move no search, win ply = cutoff search; CLI prints verdict before the PV. Kills
  the post-solve single-core root re-search.
- **TT dump/load** (`a57c8c0`): Approach-A raw image, validated header, zstd, atomic write +
  `.prev`. CLI `--checkpoint[=PATH]/--no-checkpoint/--checkpoint-every/--resume`, default-on
  n=16. SIGUSR2 dump-now + SIGINT/SIGTERM save-before-exit + periodic + final. e2e: resume =
  same verdict in 2,232 nodes/0.002 s vs cold 53M/11.9 s. **This is the n=16 fixture primitive.**
- **#20 size-based parallel split** (`54b3ccd`): even/prove-a-loss nodes keep splitting while
  available > threshold so idle cores steal stragglers; parity-gated (no speculation, node
  count identical). **n≥15 gated** (default min-avail 96); n=14 regressed ~3% so it's off below
  (per the "gate if regresses below n=16" rule). `QUEENS_PAR_MIN_AVAIL` overrides.
- **#9 free-involution P-certificate — NEGATIVE** (`4a97551`): fire-rate 0.07/0.018/0.003% of
  loss positions at n=10/12/14, falling ~4×/step → ~0 at n=16. Not built; `count --psym` +
  predicate kept as tooling. (Backlog #9 row.)

**Measured NEGATIVE — `QUEENS_KEY=fast` live at n=16 (the handoff's flagged experiment).**
Cold 90s/20s probes, full 24 cores, `--no-checkpoint`: **D4 4.94 M/s vs fast 1.14 M/s = fast
is 4.33× slower per node**, against only 3.4× fewer nodes ⇒ fast ~1.27× slower cold. D4's n=16
thrash was only 1.4× (session 7), not enough to flip it. **Confirms the handoff decision: fast
stays the freeze-time/Chunk-4 key, not the live key.** (Plus fast carries a 64-bit-graph-hash
collision risk at ~2.1B keys.)

**TT RAM ceiling.** Box has 26 GB, ~19 GB available (rust-analyzer/tmux/etc. hold the rest).
The n=16 default TT is 2³¹ = 17 GB (fits); the next power (2³² = 34 GB) doesn't, and
`QUEENS_TT_SLOTS` to ~22 GB risks swap. So re-exp stays ~1.4× — **memory is still the wall**,
and the single-box route to a smaller working set is Chunk 4 (BuRR archive), not a bigger table.

**The <30 min reality.** The cheap levers are now exhausted/measured: #20 (tail, ~10-15%),
bigger TT (RAM-capped), fast key (~tie), #9 (dead), move-ordering (dead, session 6),
decomposition (~1.2 comps/pos, session 7). **None gets 56→<30 min alone**; the working set
(~7.2B distinct) exceeds the 17 GB TT, so n=16 stays re-expansion-bound. **The load-bearing
lever for <30 min remains Chunk 4 (LSM + BuRR-archived solved plies)** — fit the working set
→ kill re-exp → compute-bound. That's a multi-session build (next).

**Definitive full n=16 run (in flight at handoff write time):** D4 + #20 + 17 GB TT +
`--distinct` + final-only checkpoint → a complete warm n=16 fixture at
`rust/queens-tt-n16-final.zst`. Validates #20's tail benefit vs session-7's 3371 s/56 min and
cross-checks the second-player verdict. **[RESULT PENDING — fill in when it completes.]**

### Session 7 (live) — first multi-core n=16 production run + parallelism-tail finding (2026-06-15)

**The n=16 solve is running multi-core for the first time** (after the `2f51aa5`
parity-YBWC fix). Command: `time target/release/queens solve 16 parallel --distinct`.
Live snapshot at 34/36 roots: **7,421,942,597 nodes · 1.4× re-exp · 2186 s · 3.39 M/s**,
full 24 cores while in a parallel region. Healthy and on the ~9.2B-distinct estimate
(nodes are *billions*, not tera — `3.39M/s × elapsed` can't reach trillions, and 1.4×
re-exp means the working set is fitting the TT, not thrashing). re-exp climbed
1.1→1.2→1.4× as the cumulative distinct set filled the TT, then plateaued. ETA was
~tens of minutes vs Jenrich's 23 h. **Verdict must cross-check SECOND player.**

**Finding — periodic single-core dips, worsening toward the end (load-imbalance tails,
not a bug).** `par_wins` parallelises a *fixed* top `par_depth` plies (default 3); below
that the recursion is sequential, so **every subtree rooted at depth ≥ par_depth is an
atomic single-core task**. The even-level fan-out produces *uneven* such tasks — most
finish fast, a few big ones straggle — so at the tail of each parallel region the cores
drain to a few, then to 1 on the single biggest straggler, until the next region/root
opens up and refills. It is **worst near the end**: at 34/36 only two root subtrees
remain, so *all* parallelism is intra-root and there is nothing to mask their sequential
tails. Brief, harmless (pure load imbalance — no speculation, cutoff fully preserved,
verdict-safe), but it leaves cycles idle.

**Fixes** (backlog #20): quick knob — `QUEENS_PAR_DEPTH=6+` pushes the sequential
boundary deeper so stragglers split into more, smaller tasks (safe: parity ⇒ no
speculation; costs only task/alloc overhead, negligible at n=16). Real fix — **split by
subtree size, not fixed depth**: parallelise an even (prove-a-loss) node while its
available-square count exceeds a threshold (big ⇒ keep splitting, small ⇒ sequential),
which divides the big stragglers directly and largely removes the single-core dips.
Still parity-gated (even-only), so still zero speculation. Consider bumping the default
`par_depth` (3 → ~5-6) for the n≥15 boards that want it.

### Session 7 — graph-key cost crusade (#18/#17/#17b/#19) + `count --comps` + PGO + Chunk 2b fastrange (2026-06-15)

**Session**: 2026-06-15 (queens, session 7). `make test`/`clippy`/`fmt` green
(`tiny_component_key_matches_full_canon` + `solver_lineage_agrees` ok; D4 gate:
`solve 12 --distinct` → second, distinct 1,060,823, 1.01× re-exp; `solve 14 --distinct`
→ second, 1.08× re-exp). Commits `5bd9564`…`44f7e74`.

**Headline — graph-key per-node cost cut ≈ +45% compounded** (n=16 partial throughput,
taskset-pinned A/B): #18 tiny-component shortcut +6%, #17 branchless WL +3.5%, #17b
compact-local + AVX-512 +2%, **#19 component-canon cache +29% (the lever)** + cache→2^22
+3.7%. **Also landed:** `count --comps` (monomorphised `iso_key_fast_in::<const HIST>`
tooling), PGO make targets (`pgo-queens`/`pgo-othello`/`pgo-release`, isolated target dirs,
n=14 SIGINT-early-term profile), **Chunk 2b `fastrange`** (TT any slot count via
`QUEENS_TT_SLOTS`), the hot-path-toggle rule in `CLAUDE.md`, and 3 memories
(`[[queens-bench-anchor-n14-n16]]`, `[[keep-pushing-amortize-over-microopt]]`, updated
`[[env-vars-resolved-at-startup]]`). Findings: graph key still ~2× slower *live* than D4 at
n=14 (stays the memory/freeze-time key); decomposition (#8) bounded by ~1.2 comps/position
at n=12; `vpmullq` not worth forcing. Files: `rust/src/queens.rs`, `rust/src/bin/queens.rs`,
`rust/Makefile`, `CLAUDE.md`, auto-memory. Details per lever below.

**WIN (modest) — #18 tiny-component shortcut.** `comp_canon` now maps every connected
component of `k ≤ 4` vertices straight to a constant derived from its **sorted degree
sequence** — a *complete* isomorphism invariant for connected graphs on ≤4 vertices (the
1/1/2/6 such graphs each carry a distinct degree sequence) — skipping CSR construction,
WL refinement, and certificate hashing entirely. The new test
`tiny_component_key_matches_full_canon` proves, over every connected induced subgraph of
size ≤4 on a real n=6 board, that the shortcut induces **exactly the same partition** as
the full WL+IR canon (a bijection both ways), so the graph-key merge — and the distinct
working set — are provably unchanged.

*Measured `QUEENS_KEY=fast`, A/B vs a clean-HEAD worktree binary. **n=16 is the target,
so it is the headline; n=14 is the real comparison; n=12 is correctness-only.***

| board / metric                   | old (HEAD) | new (#18) | delta |
|----------------------------------|-----------:|----------:|------:|
| **n=16 throughput** (taskset, concurrent, swapped) | ~61.6 K/s | ~65.4 K/s | **+6.2%** |
| n=16 throughput (seq round-robin, 24 thr) | ~90.8 K/s | ~96.6 K/s | +6.4% |
| n=14 parallel wall               | ~28.6–30.0s| ~27.3–28.9s| ~4-5% |
| n=12 symmetry (seq) wall         | ~2.85s     | ~2.73s    | ~4-5% |
| n=12 parallel wall               | ~0.61s     | ~0.60s    | ~0% (too small; DRAM/overhead hides it) |

Merge preserved (fast node count unchanged: n=14 ≈14.8M, n=12 ≈311k), verdict unchanged
(second). The n=16 partial-run throughput (+6%) is the number that matters — it is largest
at the target board, slightly above n=14. Cheap, correct, never negative; keep. Value is in
the **Chunk-4 freeze-time key** (option 2) and a live n=16 graph-key run. *Method note (per
user this session):* anchor perf on n=14 / partial-n=16, not n=12; pair runs with `taskset`
to disjoint **equivalent** cores (Zen5c groups `4-7,16-19` vs `8-11,20-23`), swapped, run
concurrently — see `[[queens-bench-anchor-n14-n16]]`.

**Prior CORRECTED — tiny components are NOT "overwhelmingly" dominant.** Channelling
Fermi: the napkin (handoff #18 row: "deep, the graph fragments into overwhelmingly tiny
components") predicted a big win; the bench said ~4-5%. New `count --comps` tool resolves
the gap by measuring the available-graph component-size distribution over the working set.
At n=12 (over 1.06M D4-distinct positions, 1.28M components):

| k (vertices) | share | cumulative |
|--------------|------:|-----------:|
| 1            | 15.1% | 15.1%      |
| ≤4 (#18)     |   —   | **32.2%**  |
| 5–8 (peak)   | ~10% ea| 71.2%     |
| ≤16          |   —   | 95.8%      |

So `k≤4` is ~⅓ by *count* and even less by *cost* (WL cost grows with k) — #18 removes
the cheapest third; the **k=5–16 bulk is the real per-node cost** (that's #17's target,
now sharper). The "overwhelmingly tiny" framing was wrong; the mass is at k=5–8.

**Tooling follows the hot-path-toggle rule (per user guidance this session).** The
component-size tally is gated by a **`const` generic** (`iso_key_fast_in::<const HIST:
bool>`), not a runtime flag: production calls `::<false>` so the tally is *never emitted*
(no L1i / frontend pollution — and the graph key is frontend/L1i-bound, the exact
bottleneck a dead per-node branch would worsen); `count --comps` calls `::<true>` via
`tally_components`, driving the *same* decomposition the live key uses. The single runtime
decision is the `--comps` CLI flag, resolved once at the top. This is now codified as a
canonical rule in `CLAUDE.md` ("Hot-path toggles are resolved once *outside* the loop")
and the `[[env-vars-resolved-at-startup]]` memory — the rule is bigger than env reads: any
run-constant toggle, monomorphise on a const bool or thread the value, never a per-node
`if`.

**Also landed — PGO build targets** (`rust/Makefile`): `make pgo-queens` /
`pgo-othello` / `pgo-release` (profile-generate → run workload → `llvm-profdata merge`
→ profile-use). Queens profiles a **time-boxed n=14 solve** (`timeout -s INT $(PGO_SECS)`,
default 30s) — the instrumented binary is ~3× slower so a full n=14 would take minutes, and
a partial run exercises the same hot functions at representative branch frequencies; the
SIGINT handler exits via `std::process::exit` so the LLVM `.profraw` flushes cleanly
(verified). Builds are isolated into `target/pgo-instrumented/` and `target/pgo-release/`
so PGO never clobbers the plain `make release` (`target/release/`). The PGO'd queens lands
at `target/pgo-release/release/queens` (~1.02 MB vs 1.09 MB plain — PGO trims cold code;
verdict unchanged). (Useful for an eventual n=16 run; orthogonal to the search levers.)

**WIN (modest) — #17 branchless WL refine.** Padded each WL neighbour row to a fixed
`stride` (the component's max degree) with a `DUMMY_VERT` filler so the inner fold loop is
**fixed-trip** (the per-vertex variable trip was the TMA's exit-mispredict source), and
**hoisted `mix64` out of the per-edge loop** into a per-round `mcol` table — computed once
per vertex (`k` calls/round) instead of once per incident edge (`2|E|` calls). The DUMMY's
mixed colour is pinned at 0, so padding slots add nothing and the colours are **byte-
identical** to before — proven: n=12 symmetry fast = **310,356 exactly** (matches pre-#17),
all tests green, D4 gate intact. *Measured (value-preserving ⇒ node counts identical, pure
per-node-cost A/B):* **+3.5% n=16** partial throughput (taskset-pinned, swapped: 65.6→67.9
K/s), **+3.2% n=14** wall (28.0→27.1s), ~1-2% n=12. Modest — for skewed-degree components
the fixed stride wastes adds on DUMMY slots, eating into the branch+hoist win.

**Two ways to get more bang (user prompt, queued):**
- **#17b — DONE (compact-local layout + AVX-512), WIN +2% at n=16 (value-preserving).**
  Switched WL to a **compact local colour layout** (`lcol[0..k]`, `nbr_pad` holds local
  indices) so the per-round `mc[i]=mix64(lcol[i])` map is contiguous and auto-vectorises;
  the fold's gather now hits a small `k`-element array. Colours byte-identical (n=12 symmetry
  fast = 310,356 exactly, all tests pass). **+2.2% n=16** throughput (taskset, swapped),
  ~1% n=12. *Ceiling finding:* LLVM emits AVX-512 `vpxorq`/`zmm` for the shifts/xors but
  keeps the 64-bit **multiply scalar (`imul`, no `vpmullq`)** — its znver5 cost model judges
  scalar multiply faster — so only the xor/shift half of `mix64` vectorises. Forcing
  `vpmullq` via explicit intrinsics is unlikely to beat the cost model; not pursued. This is
  ~the SIMD ceiling for splitmix-style mixing on znver5. Bonus: the compact layout also
  simplified `classes_in`/`hash_colours_in` (no `verts` indirection).
- **#19 — DONE (per-thread component-canon cache), WIN +29% at n=16 — the session's
  biggest lever.** The graph key is recomputed *every node* (before the TT probe), and
  `comp_canon` is a pure function of `(component square-set, board geometry)`. A direct-mapped
  per-thread cache `comp → canon` (2^20 slots × 16 B = 16 MB/thread, fingerprint-guarded like
  the TT, `n` folded into the fingerprint so entries never cross `n`) skips the entire bit-scan
  + CSR build + WL on a recurring component. Value-preserving (n=12 symmetry fast = 310,356
  exactly, tests green). **+29% n=16** partial throughput (taskset, swapped: 68.4→88.2 K/s),
  **+15% n=12** — *grows toward the target*. Confirms the instinct: **skipping work beats
  speeding it up.** Caches only `k ≥ 5` (tiny is already a degree-seq constant). It amortizes
  *exact*-square repeats; iso-repeats already merge at the position key. **Lesson: when
  per-node micro-opts plateau (#17/#17b at 2-3%), step back to amortization — it was 10×.**

**#19 cache sizing + live-gap (follow-on probes).** Cache tuned to **2^22 slots
(64 MB/thread)**: at n=16, 2^20 is capacity-bound (2^22 = +3.7%), 2^23 ties 2^22; 64 MB ×
24 ≈ 1.5 GB fits under the n=16 TT budget. **Live-key gap (does the merge now pay live?):
NO** — n=14 full wall, D4 ~11 s (53.2M nodes) vs fast+#19 ~21 s (14.8M nodes): D4 per-node
is still ~7× cheaper, so the 3.6× merge loses by ~2× *when both fit RAM*. The graph key's
value remains the **memory** reduction at n=16 (where D4 thrashes and fast fits) — not a
live wall win. So keep it the freeze-time / n=16-memory key; #19 just makes computing it
~30% cheaper.

**Decomposition (#8) reality-check — smaller than it looks.** The `count --comps`
histogram already shows **only ~1.2 components/position at n=12** (~80% of positions are a
single connected component), so the disjunctive-sum XOR shortcut would prune only the ~20%
fragmented positions — a modest node-count win, not a multiplier — *and* it needs component
*nimbers* (mex, no cutoff). The component-*reuse* benefit (which IS large) is already
captured by #19 at the key-computation level. So #8 is lower-priority than it first
appeared; fragmentation may rise toward n=16 but is unmeasured. The big remaining lever
stays **structural memory** — Chunk 4 (BuRR archive) / L2 (ply-windowing + external DDD) /
Chunk 3 (two-tier replacement) / Chunk 2b (`fastrange`).

**NOT done / next.** The graph-key per-node line is now well-optimized (#18 +6%, #17 +3.5%,
#17b +2%, #19 +29%+3.7% ≈ +45% compounded over the session's start). k=5,6 are deliberately
*not* given the #18-style degree shortcut (degree sequence stops being complete past k=4).
The load-bearing n=16 path remains structural — Chunk 4 (BuRR archive) / L2 (ply-windowing
+ external DDD) / Chunk 3 (two-tier replacement) / Chunk 2b (`fastrange`).

### Session 6 — move-ordering negative + `--distinct` presentation fix (2026-06-15)

**Session**: 2026-06-15 (queens, session 6). `make test`/`clippy` green
(`solver_lineage_agrees` ok; `solve 12 --distinct` → second, distinct 1,060,823;
`solve 14 --distinct` → second, ≈49M, 1.08× re-exp). Files: `rust/src/bin/queens.rs`
(presentation fix — committed); `rust/src/queens.rs` net-unchanged (the dynamic-order
experiment below was added behind a toggle to measure, then reverted).

**Landed — `--distinct` wording made robust.** The re-expansion line could print a
contradictory sub-`1.0×` ratio and a nonsensical *negative* "% recomputed" whenever
`nodes < distinct`. That happens two ways: (a) for even n≤12 the reported "distinct"
is the **known reference constant** `DISTINCT_POSITIONS[n]` (now labelled `(known
exact)`, not `(exact)`, so it reads as the reference it is), and a run that expands
fewer nodes than the reference would go sub-1.0; (b) HLL estimator noise at n≥14 can
push the estimate just above `nodes`. New shared `reexp_note(nodes, distinct)` helper
(used by both `solve` and `count`) clamps this: when `nodes ≤ distinct` it prints
`no re-expansion (≈1.0×)` instead of a negative percentage.

**Instructive NEGATIVE — dynamic "effective-degree" move ordering (lever #6 variant).**
Hypothesis (codex-review lever, `…-codex-review.md` Finding "minimal graph"): the
static order ranks squares by *context-free* attack degree, a poor proxy deep in the
tree where most of a high-degree square's lines are already blocked. Re-rank each
node's available squares by **effective** degree — `popcount(attack[sq] & available)`,
how many *currently*-available squares the move removes — to surface real cutoff moves
earlier and shrink the distinct working set (the n=16 wall). **Measured (clean
`count … --exact` / `--parallel`, distinct = true working set):**

| n  | seq static | seq dynamic | seq shrink | par static | par dynamic | par result   |
|----|-----------:|------------:|:----------:|-----------:|------------:|:-------------|
| 10 |     94,094 |      52,168 |   1.80×    |       —    |        —    | —            |
| 12 |  1,060,817 |     799,258 |   1.33×    |     1.067M |      0.970M | 1.10× better |
| 14 |    49.13M  |     47.91M  |   1.025×   |     49.0M  |      53.5M  | **0.92× WORSE** |

Two killers: **(1) the sequential shrink decays super-linearly** (bonus 0.80 → 0.33 →
0.025) → **break-even at n=16 even sequentially** — effective-degree → static-degree
as boards grow (few squares blocked early in a big search, so the orders only diverge
deep where few nodes live). **(2) under the parallel default it REVERSES** (+9–12 %
bigger working set, robust to <0.2 % across 3 interleaved rounds: 53.51/53.52/53.51M
vs static 49.02/49.07/49.09M). Mechanism: static order concentrates cutoff ("proof")
moves on a few *globally-good* squares whose resulting positions **transpose heavily**
across the concurrently-searched root subtrees (near-perfect cross-worker TT reuse,
+0 % parallel overhead); effective-degree picks a *context-local* proof move per node,
those positions **don't transpose** across siblings → cross-worker reuse collapses.
Even a perfect parallel fix caps at the sequential benefit (~0 at n=16), so not worth
shipping. Reverted; hot path (`wins_keyed`) kept branch-free per Tiger discipline.

**Instructive NEGATIVE #2 — history-heuristic ordering (lever #6 proper), and it's
worse.** The effective-degree mechanism *suggested* a **global** ordering signal
(history) would keep cutoffs concentrated on transposing squares — reuse-friendly. So
I built it: a global per-square β-cutoff tally (`[AtomicU64; MAX_N²]`, shared lock-free
across workers), re-rank each node's moves by it, reward the cutoff square on a hit,
ties → static degree → ascending square (so zero history == static order exactly).
**It is catastrophically worse, and worsens with n:** distinct working set n=10
94,094→**109,388** (+16 %), n=12 1,060,817→**2,296,081** (+116 %), n=14 49.1M→**113.0M**
(+130 %). This is *sequential* (no reuse effect), so it's purely a worse move order.
Robust to the weight: frequency-only (weight=1) gives n=12 **2,389,822** (+125 %), so
it's not my subtree-size weighting. **Why:** the static "most-blocking-first" order is
*near-optimal* for this game — Non-Attacking Queens *is* a blocking game, so attack
degree is an exceptionally strong, position-consistent cutoff predictor. History
conflates cutoff signal across plies/contexts (a square great deep is tried first
shallow where it's bad) and *replaces* a strong static signal with a noisy learned one
→ worse cutoffs → the working set ~2.2× explodes. This is the Othello precedent
(`NOTES.md`: "hash + mobility already near-minimal; depth-indexed killers mis-order")
holding even harder here. Reverted.

**Unifying conclusion: move ordering is a dead end for the n=16 working set.** Both a
context-local refinement (effective-degree) and a globally-learned one (history) lose
to the static degree order — the small-board win decays to ~0 by n=16, and history is
outright ~2× worse. The static most-blocking order is already near-optimal because the
game is about blocking. **Stop tuning move ordering; the working-set lever is
structural** — graph-automorphism canon (#7, merge *more* transpositions), dynamic
decomposition (#8), ply-windowing + external DDD (L2/#11), and the BuRR archive
(Chunk 4). Killer-per-ply (#6 remainder) is the only ordering idea untested, but the
Othello "depth-indexed killers mis-order" result + this history blow-up make it a poor
bet; the backlog row is marked accordingly.

**Pivot → structural lever #7 (graph-automorphism canon): MEASURED — a validated WIN.**
The game from a position is Node Kayles on its *available-graph* (vertices = available
squares, edges = attacking pairs), so any two positions with **isomorphic** available-
graphs have identical values and subtrees — `canon` only merges the 8 board symmetries,
a strict subset of graph iso (esp. deep, where small residual graphs coincide up to iso
without being board-symmetric). New `count --iso` tool measures, over the working set,
distinct positions under three available-graph keys of rising strength — 1-WL colour
refinement (`iso_key`), 1-WL + individualisation (`iso_key_ir`), and a true
individualisation-refinement **canonical form** (`iso_key_canon`, provably complete) —
and checks **win/loss-consistency** (does any class merge a win with a loss; for a sound
key, impossible). Validated result:

| n  | D4-distinct | graph-iso safe merge (canon, 0 mixed) |
|----|------------:|:--------------------------------------|
|  8 |         625 | **2.63×** |
| 10 |      94,094 | **3.17×** |
| 12 |   1,060,817 | **3.42×** |
| 14 |  49,671,327 | **3.40×** |

The merge is **large, win/loss-consistent (a usable safe key)**, and the complete canon
and the cheap IR invariant **agree exactly at every n** (n=14: both 14,630,229 distinct,
0 mixed) — so the IR invariant suffices on this family (canon is the provably-safe
fallback). The factor **rises then plateaus at ~3.4×** (2.63→3.17→3.42→3.40), so take n=16
≈ **3.4×**, not higher: ~9.2B → **~2.7B distinct ≈ ~21–22 GB raw at the 8-byte slot**. That
is borderline for the 26 GB box — it does *not* leave load-factor headroom for low
re-expansion, so it likely doesn't make n=16 a clean in-RAM solve on its own, but it
**multiplies the Chunk-4 archive down ~3.4×** and brings RAM-fit within reach (pair with
`fastrange` Chunk 2b + some eviction tolerance). Still the strongest working-set lever found.

*Correction of the first cut:* an earlier pass reported a wide bracket "[1.30×, 3.39×]"
and "1-WL too weak, ~half the keys win/loss-mixed". That mixing was a **measurement bug**,
not a property of the graphs: `working_set` read each key's value by `peek`-ing the lossy
fingerprint TT, whose index collisions evicted a few keys → stale/`0` values → *phantom*
mixed classes. Fixed by recording exact values at `put` (eviction-proof) into a key→value
map; the mixing collapsed (n=12: 511,802 → ~8,500 keys, 48 % → 0.8 %, and **0** under the
IR keys). Even plain 1-WL is then ~99 % consistent. Lesson: never source the value-
consistency ground truth from the lossy TT.

**Live-key integration spike DONE (session 6) + TMA-driven cost reduction.** Wired the
graph key as the live TT key behind `QUEENS_KEY=ir|canon|comp|fast` (and `QUEENS_KEY_MAX=k`
for selective keying); default stays D4. Graph keys are namespaced into the 256-bit slot
by a sentinel bit (255, unused for n ≤ 15) so selective mode can mix them with D4 masks.
Verdicts preserved (graph-iso merges only same-value positions); node count drops by the
merge factor (n=14 parallel: 53.2M → 14.8M, 3.6×).

*Result: a wall LOSS at n ≤ 14, by design — the working-set win, not a wall win.* n=12
symmetry, D4 0.62s baseline:

| key | nodes | wall | note |
|-----|------:|-----:|------|
| D4 | 1.07M | 0.62s | branchless 8-fold fold |
| canon | 310k | 5.03s | whole-graph IR canon |
| **fast** | 310k | **2.82s** | component-decomp + prealloc + CSR |

Cost reduction (each measured): component decomposition alone = wash (per-call alloc
dominated); **prealloc thread-local `IsoScratch`** (zero heap, written-before-read, no
per-call zeroing) 5.03 → 3.43s; **CSR neighbour lists** (build once, counted-loop refine
instead of per-round bit-scan) 3.43 → 2.82s — **1.8× total**, same 3.4× merge. Selectivity
(`QUEENS_KEY_MAX`) saved ~nothing: all the merge *and* all the node-visits live in
deep/small graphs, so size-thresholding the large shallow graphs is a no-op (swept 20→144
at n=12, node count flat).

**TMA (perf `-M frontend_bound,backend_bound,bad_speculation,retiring` + `perf record`):**
after prealloc the key is **frontend/branch-bound — ~45 % frontend, ~8.5 % branch-mispredict,
~15-19 % retiring**; D-cache (1.4M) and dTLB (1M) misses negligible, so **not** memory-bound
(refuted the alloc hypothesis once prealloc'd). Branch-misses concentrate in `node_key`
(51 %, the `comp.each`/CSR-build bit-scans) and `wl_refine_in` (42 %, the variable-trip
neighbour loop + early-break); **sorts only 3 %**. The residual is *intrinsic* data-dependent
graph traversal — even counted loops mispredict on exit when degree varies. D4's branchless
fold is hard to beat live; break-even needs ~4.5× more, not reachable by micro-opt.

**Conclusion — this is fine where it matters.** At ~9 µs/node, parallelized, the graph key
adds ~tens of minutes to an n=16 run that is already hours, and n=16 is *memory*-bound where
the 3.4× working-set cut is the point; for the **Chunk-4 archive (option 2)** it is computed
offline at freeze-time where 9 µs/position is trivially cheap. So: do **not** make it the
live key for n ≤ 14; **do** use it as the freeze-time archive key (option 2) and as the live
key only for an n=16 attempt where RAM-fit beats wall-time.

**QUEUED for next session — branchless/SIMD refinement.** The TMA floor is branch
mispredicts in the data-dependent graph walk. Next attack: pad each vertex's neighbour list
to a fixed stride (kill the variable-trip exit mispredict) and vectorise the colour fold
with AVX-512 (znver5 has it); plus memoize recurring tiny components (isolated vertex / edge
/ path-3 dominate deep) keyed by a 1-WL hash. High effort, uncertain — only worth it if a
live n=16 graph-key run needs the wall back. Backlog row #17.

**Parallel-over-serial inflation (answering "can we adjust the parallelism?").** With
**static order the lockless solver already has ~0 % distinct inflation** over serial
(serial 49.13M vs parallel ≈49.05M, within HLL noise) — the relaxed-atomic puts are
visible to all workers immediately (no shard-lock staleness), so cross-worker reuse is
as timely as possible; the lockless swap already bought the inflation-reduction. What
remains is **~1.6 % NODE re-expansion** (53.2M par vs 52.4M seq nodes; distinct
unchanged) — two workers occasionally expand the same position before the other's put
lands. The lock-free-*enabled* lever to shave that is **ABDADA-style in-evaluation
deferral** (Weill 1996): mark a slot "being evaluated" (a spare bit — `val` only needs
1 of its 8), and a second worker reaching it **defers** (searches other moves first,
returns later) rather than duplicating the subtree. Unlike the documented deep-YBWC
negative (fact #5, which *speculates* extra children and defeats the α-β cutoff),
ABDADA *defers* and so preserves the cutoff. But it reduces **compute/DRAM (~1–2 %),
not the distinct working set** (the memory wall is untouched) — record as a low-
priority lead, behind the structural levers. New backlog row #16.

### Session 5 (impl) — L1 landed: lockless TT + prefetch + huge pages (2026-06-15)

**Session**: 2026-06-15 (queens, session 5 impl). Committed `9b30cb2`; `make
test`/`clippy` green, `fmt-check` clean on my files (pre-existing `table.rs` drift
left untouched). Implements lead **L1** from the lit-search note below. Files:
`rust/src/queens.rs`, `rust/Cargo.toml`/`.lock` (added `libc` for `madvise`),
`rust/README.md`.

**What landed (all three of the per-node-cost cluster #1–#3):**
- **#1 Lockless, unsharded TT.** `QueensTt` is now one flat `Box<[AtomicU64]>` with
  `Relaxed` load/store — the `Vec<Mutex<Box<[Slot]>>>` and the 1024-shard routing are
  gone. Safe because the slot is exactly one `u64` (a load can't tear), a position's
  value is deterministic (same key ⇒ same stored val even under a concurrent write),
  and a foreign key is rejected by the 55-bit fp — so no lock and no Hyatt XOR-key.
- **#2 Software prefetch.** `wins()` now defers to `wins_keyed(q, blocked, key)`; the
  parent computes each child's canonical key, `_mm_prefetch`es its slot, then recurses,
  so the child's entry `get` is warm.
- **#3 Huge pages.** `zeroed_huge_atomics()` allocs via `vec![0u64; n]` (lazy
  `alloc_zeroed`, so a 17 GB table doesn't commit until probed) then `MADV_HUGEPAGE`s
  it and reinterprets as `AtomicU64` (one small, documented `unsafe`).

**Measurement:** interleaved A/B vs the `6c32617` mutex build (n=14 parallel,
thermal-controlled, in a throwaway worktree): lockless **~3–5 % wall**, winning 4/5
rounds, gap growing under thermal load. Prefetch isolated with a temp `QUEENS_NO_PREFETCH`
toggle (reverted before commit): **~2 %**, 4/4 rounds — *both arms paid the per-node
`var_os`, so it cancels in the delta* (it did inflate absolute times, ~17 s vs ~12 s).
Not the hoped-for ceiling multiple — reinforces fact #5 (DRAM-bound). **Reviewer caveats
(addressed):** (a) prefetch's hide window is tiny (a call + a 2nd `hash128`), so credit
it only the measured ~2 %; the 2nd `hash128` per node could be removed by threading
`(route,fp)` from `prefetch` into `get` (deferred). (b) The `var_os`-per-node was the
*measurement toggle only*; committed code calls `prefetch` unconditionally.

**Next**: per-node cluster has cache-line bucketing (#4) + AVX-512 canon (#5) left, but
the bigger levers are the **node-count** ones (history/killer ordering #6) and the
**structural** n=16 route (L2 ply-windowing / external-memory DDD #11 → Chunk 4 BuRR).
See the prioritised **Lever backlog** above Handoff Notes.

### Session 5 — perf lit search, published-baseline comparison, two new leads (2026-06-15)

**Session**: 2026-06-15 (queens, session 5 — **lit search + docs only, no code**). Updated
`rust/README.md` (perf-vs-literature + future-directions), this handoff, and the
`[[queens-game-cgt-references]]` memory.

**Verified the published baseline from Jenrich's actual QPGAME3 run-listing**
(arXiv:1312.5135, Turbo/Free Pascal, 1 GHz Pentium III). Exact sum-of-calls:

| n  | Jenrich calls   | our nodes  | distinct    | node-eff |
|----|-----------------|------------|-------------|----------|
|  8 |           2,266 |        629 |         625 |    3.6×  |
| 10 |         653,007 |     94,870 |      94,205 |    6.9×  |
| 12 |      11,334,613 |  1,069,880 |   1,060,823 |   10.6×  |
| 14 |   1,161,385,667 | 53,300,665 |  49,141,396 |   21.8×  |
| 16 |  71,461,975,237 | (unsolved) |  ~9.2B est  |     —    |

He uses **partial symmetry** (full on the first move + half-turn rotation when player 2
re-establishes it) but **no TT** — this corrects the old "no TT/symmetry" note in the
References block above. n=14 = 18m51s; n=16 = 22h56m **with a hand-built opening book**
for player 2's first two replies. Our node-efficiency vs his calls **grows with n** (the
TT + per-node dihedral canon advantage compounds). Verdicts match exactly; OEIS A344227
nimbers (≤ n=13) match too.

**Other implementations of this exact game** (none faster per-node for win/loss): **Max
Fan's general-graph Node-Kayles solver** (Rust, github.com/InnovativeInventor/node-kayles)
supplied OEIS terms 11–13 — i.e. it computed the **full nimber at n=13**, which our
`nimber` mode cannot (no-cutoff stall). Worth studying its canonical-subgraph memo for the
open full-nimber-n≥14 direction. Bardoe (Python torus) + the OEIS Haskell snippet are
educational. The n-queens *counting* records (Q27 / n=27) are a different (#P) problem,
not a baseline — they share only the bitmask move-gen.

**Two leads worth not losing (added to Progress as L1/L2):**
1. **Lockless TT** — slot is already a single `u64`; drop the per-shard `Mutex` for
   `Box<[AtomicU64]>` (fp self-validates → no lock/XOR-trick). High ROI, low effort; pair
   with software-prefetch + huge pages. Targets the DRAM-latency bottleneck (fact #5).
2. **Window by ply** — transpositions are strictly intra-ply, so a ply-layered +
   external-memory DDD solve (Korf; Zhou–Hansen) bounds the resident set and reframes
   Chunk 4 as freeze-solved-ply-into-BuRR. The structural route through the n=16 wall.

**Lower-priority lit ideas**: history/killer move ordering (cheap α-β node cut on top of the
static most-blocking order); graph-automorphism canon via nauty/bliss (more merges, pricier
per node — likely how Max Fan reached n=13); dynamic decomposition + small-component nimber
DB (prunes AND compresses where `mex` is cheap — the full board is biconnected but residual
graphs *fragment* in the endgame, which softens fact #3/key-fact "doesn't decompose");
free-involution detection for instant deep P-verdicts (generalises the odd-n pairing);
AVX-512 canon (minor per-node).

**Validation unchanged**: any TT/key change keeps `solver_lineage_agrees` (n≤9) + a fresh
`solve 12/14 --distinct` (distinct unchanged, re-exp ≈ 1.0×). The lockless swap is
behaviour-preserving (same slots, just no lock) — verify node count + verdict identical.

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
