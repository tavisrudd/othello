# Root Ordering for the n=16 Queens Search — measure first, then maybe reorder

**Date**: 2026-06-17
**Created by**: 2026-06-17--3 (`26d18a84-a65c-480a-a941-cd01a638a803`)
**Purpose**: Decide whether reordering the search roots cuts n=16 re-expansion/wall — via a
cheap offline measurement — before touching the hot loop.

---

## Context

The adversarial Non-Attacking Queens solver explores every symmetry-distinct **first move**
("root") of an even board. n=16 is a **second-player win**, so *every* root is refuted and
fully explored — root order changes **no verdict and triggers no cutoff** (`first_player_wins`
is `resolve(first) || rest.par_iter().any(resolve)` where every `resolve` is `false`). Order
affects only **cache warming** (the shared transposition store) and **parallel load balance**.

The intuition that prompted this: *prioritize roots that seed symmetries shared by many other
roots first, so their subtrees are cached before the roots that re-reach them.* An Opus
sub-agent analyzed it (2026-06-17). Findings that shape the task:

- **The current order is ALREADY ~most-central-first.** `distinct_first_moves`
  (`src/queens/mod.rs:199`) iterates `q.order`, which `geom.rs:67` sorts by **descending attack
  degree**; central squares fragment the board most ⇒ highest shared-transposition density. The
  sequential seed root (run alone before the parallel burst, via `split_first`) is already the
  highest-sharing root. So the intuition is largely in place.
- **The gain is bounded to single-digit % wall, and it's mostly the wrong channel.** The store
  already dedups, so order only moves (a) the parallel-race window — two workers first-expanding
  the same key before either caches it (µs; already inside the measured 1.15× re-exp at n=16),
  and (b) **which positions are frozen into the eviction-free tier before the cap latches**. At
  n=16 the store caps at ~48% of the key set, so **most of the 1.15× is post-cap eviction —
  structurally weakly coupled to root order**, NOT seed-warming.
- **Existing cross-root data bounds the upside** (`roadmap.md:555-592`): Σ/union plateaus ~2.0,
  **58% of positions are root-private, only 0.02% reached by all roots** — there is no big
  universal trunk for a seed to warm.

Net: don't reorder yet. Run the measurement; it gives the wall ceiling for *any* reorder
without an n=16 run.

## Scope

- **In:** read-only instrumentation of the existing `count --roots` tool; an offline replay to
  compute the order-sensitivity Δ; a *conditional*, gated loop change only if the Δ justifies it.
- **Out:** any speculative n=16 run; changing the canonical key; the cap/merge lever (separate,
  larger — that's the real sub-20-min item if this comes back negative).

## Work Items

**1. Instrument `roots_report` with proxies + shared-volume (read-only).**
   - File: `src/bin/queens.rs:1727-1872` (`roots_report`, the `count --roots` mode).
   - Per root, record proxies: first-move centrality `attack[sq].popcount()`; residual available
     popcount; and `iso_max_component_size`/component-count of the residual (`graph.rs:845` is
     ready to call). The cross-root multiplicity histogram already exists; add per-root
     **shared-volume contributed** = Σ over its positions of `(multiplicity − 1)` (how many other
     roots' re-expansions this root could save by seeding first).
   - Done: report prints, per root, the proxy values and shared-volume; Spearman of
     proxy-vs-shared-volume is computable. **Confirm/refute signal:** rank-correlation ≳ 0.7 ⇒
     proxy predicts sharing; flat ⇒ ordering can't help, stop.

**2. Offline capped-replay (the load-bearing number).**
   - Replay the recorded per-root key sets in (a) current order and (b) fragmentation-first; mark
     a position "frozen" (eviction-free) once cumulative inserts cross a `CAP`-equivalent count;
     count post-cap re-expansions in each order. **Δ(a,b) = the wall-clock ceiling for the
     reorder, measured WITHOUT an n=16 run.**
   - Done: a single Δ number at n=12 and n=14 (and an n=16-equivalent cap model if feasible).

**3. Decide + (conditionally) implement.**
   - If Δ **≳ 3-5% of nodes**: implement ordering **(3)** — keep the most-central sequential seed
     (`split_first` unchanged), order the parallel `rest` **biggest-subtree-first** (load-balance
     the long pole). A few lines in the three `first_player_wins` fns: `burr.rs:155` (Burr),
     `burr.rs:403` (IsoBurr), `fused.rs:183`. Sort `pending` with a per-root proxy **resolved
     once** outside any loop (36 evals, off the hot path — CLAUDE.md "resolve toggles once").
   - If Δ **< 3%**: record as an instructive negative; route energy to the **cap/merge** lever.

## Codebase Reference

| What | Where |
|------------------------------------|------------------------------------------------|
| Root loop to (maybe) reorder | `src/queens/solver/burr.rs:155` (Burr), `:403` (IsoBurr); `src/queens/solver/fused.rs:183` |
| Root enumeration + current order | `src/queens/mod.rs:199` (`distinct_first_moves`); `src/queens/geom.rs:67` (descending attack degree) |
| Best proxy (fragmentation) | `src/queens/graph.rs:845` (`iso_max_component_size`); iso key threshold `solver/mod.rs:158` (`KEY_MAX`) |
| Tool to extend | `src/bin/queens.rs:1727` (`roots_report`) |
| Shared store dedup + cap latch | `src/queens/store.rs:447` (`get`), `:531` (`maybe_freeze`/cap) |
| Cross-root data; cap binding | `notes/handoffs/2026-06-15-queens-memory-roadmap.md:555-592`; `2026-06-16-burr-live-implementation.md:80-111` |

## Principles / Constraints

- **Measure best on the iso key path** if targeting iso-burr — under iso the shared population
  *is* the recurring tiny components, so fragmentation is the right proxy; a D4-keyed measurement
  may not transfer.
- Verdict and distinct count are **order-invariant**, so the gate (`solver_lineage_agrees` +
  `solve 12 --distinct` = 1,060,823 @ re-exp ≈ 1.0× + `solve 14 --distinct` ≈ 49.3M) is a
  regression guard; the *wall* delta needs an interleaved n=14 A/B (cap doesn't bind at n=14, so
  it isolates the race channel) from tmpfs or Zen5-pin per the bench-hygiene rules.
- Don't undo `min_avail_for` (n≥15 deeper splitting, `mod.rs`) — it already mitigates the
  long-pole straggler independently of root order.

## Delegation

- **Can delegate to sub-agent?** Yes — items 1-2 (instrumentation + offline replay) are
  self-contained.
- **Model**: Sonnet for the instrumentation; Opus if re-deriving the analysis. The full Opus
  proposal is in this session's transcript (`26d18a84-…`) if deeper grounding is wanted.
- **Notes**: this is read-only instrumentation first; the loop change in item 3 is small and
  gated — do not implement it before the Δ measurement justifies it.
