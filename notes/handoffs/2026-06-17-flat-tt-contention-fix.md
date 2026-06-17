# Flat-TT contention fix — mirror the burr-store #2 fix into `tt.rs`

**Date**: 2026-06-17
**Created by**: 2026-06-17--3 (`26d18a84-a65c-480a-a941-cd01a638a803`)
**Purpose**: Remove the per-node cross-CCX atomics from the flat `QueensTt` so `incremental`
and `parallel` get the same coherence/contention fix the burr store already has.

---

## Context

This session landed a contention fix on the **BurrStore** (commit `49bba47`, used by
`burr`/`iso-burr`/`fused`): the per-node `nodes`/`fill` atomics and the per-`get` HLL
`fetch_max` were moved into a **thread-local accumulator** (no atomics or shared writes in
the hot loop), flushed to the shared atomics + HLL **~once a second** (node-count gated),
with a `rayon::broadcast` drain at search end to keep the final counts exact. On the
heterogeneous HX 370 (4 Zen5 + 8 Zen5c, two CCXs) those per-node shared atomics bounced
across the Infinity Fabric and were a measured throughput drag all-cores.

The **flat `QueensTt`** (`tt.rs`) — used by `incremental`, `parallel`, `memo`, `symmetry` —
**did not** get this fix and still has the same per-node contention. `incremental` and
`parallel` are rayon-parallel, so they pay it exactly like the burr solvers did; `memo`/
`symmetry` are sequential (no benefit, but must keep passing).

This is a near-mechanical **mirror** of the validated burr-store change.

## Scope

- **In:** thread-local node + HLL accumulation in `QueensTt::bump`/`get`; flush ~1/s; a
  drain at the `incremental`/`parallel` search entry points.
- **Out:** the burr store (already done); any `fill`/freeze logic (flat TT has no LSM, so
  **nodes + HLL only**, no freeze trigger); `memo`/`symmetry` behavior change beyond
  inheriting the new `bump`/`get`.

## Work Items

1. **Thread-local accumulator in `tt.rs`.** Eliminate the per-node atomics:
   - `tt.rs:328` — `self.nodes.fetch_add(1, Relaxed)` (per-node bump).
   - `tt.rs:389` — `c.feed(key)` → `Hll::add` → `registers[idx].fetch_max` (per-`get`, under
     `--distinct`).
   - Also check the **second** `nodes.fetch_add` at `tt.rs:699` (a second struct in the
     file — confirm what it is and whether it's hot).
   - Use the same shape as `store.rs`: a `thread_local! { static ACC: RefCell<Acc> }` with
     `Acc { nodes, hll }` (no `fill`), incremented plain in `bump`/the `get` feed, flushed to
     the shared `nodes` atomic + shared HLL once per ~`FLUSH_NODES` nodes. The HLL helpers
     **already exist** in `count.rs` (`Hll::add_local` / `merge_from` / `register_count`) —
     reuse them verbatim.

2. **Drains at the search entry points.** Mirror `burr.rs`/`fused.rs`: `drain_local()` after
   the sequential `wins`, `drain_all()` (a `rayon::broadcast`) after the parallel
   `first_player_wins`, in `incremental.rs` and `parallel.rs`. Without this the ~1/s flush
   loses each worker's final-second tail → undercounted `nodes` → re-exp reads low.

3. **Validate the gate.** `solver_lineage_agrees` + `solve 12 --distinct` (exact
   **1,060,823**) + `solve 14 --distinct` (≈49.3M; incremental's established **~1.08×**
   re-exp) + verdicts unchanged (second-player win). Then an interleaved all-cores n=14 A/B
   (tmpfs or Zen5-pin) of `incremental` before/after to confirm the contention win.

## Codebase Reference

| What | Where |
|------|------|
| Validated version to mirror | commit `49bba47`: `store.rs` (`Acc`, `bump`/`get`/`flush_acc`/`drain_all`/`drain_local`), `count.rs` (`add_local`/`merge_from`) |
| Flat-TT per-node atomics | `rust/src/queens/tt.rs:328` (bump), `:389` (HLL feed), `:699` (second struct?) |
| Drain sites | `rust/src/queens/solver/incremental.rs` + `parallel.rs` `wins`/`first_player_wins` |
| Checkpoint reads `nodes` | `rust/src/queens/tt.rs:196` |

## Principles / Constraints

- **Wrinkle:** the flat TT's `nodes` is written into checkpoint images (`tt.rs:196`); a
  mid-search checkpoint will capture a ~1-s-stale count unless drained first. Fine for
  progress — just note it (don't add a drain to the checkpoint hot path).
- Per-node path must stay **atomic-free** (thread-local plain ops only); flush is the only
  place that touches the shared atomics/HLL.
- Run/bench in tmux session `queens`; trust timing only from tmpfs or Zen5-pin (bench
  hygiene — cross-CCX × placement is ±3× otherwise).

## Delegation

- **Can delegate to sub-agent?** Yes.
- **Model**: Sonnet — it's a mechanical mirror of an already-validated change.
- **Notes**: read `49bba47` first; the pattern is fully worked out there.
