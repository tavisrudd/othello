# C1048 and C1052 work cards — Ergodis core performance work

**Lane**: `complete-ports`

These two task specifications were written into the live queue and have no other home. They are
moved here so the queue rows can go back to being one-line routing entries. Both tasks are open,
both are core work under `ergodis-contrib/PERFORMANCE.md`, and the code now lives in `~/src/ergodis`.

## C1048 — subset-sum width frontier

Queued; core kernel work under the performance contract. Report context: C1038 §4.2.

The C1038 ladder shows a flat ~4x margin over CP-SAT up to a hard-coded cap
(`MAX_SUBSET_SUM_WIDTH = 2^20`, also clamped at line 409 of `bounded_subset_sum.rs`), then a cliff.
Deliver:

1. the cap as a caller bound, with the hard clamp raised or removed and memory stated per width;
2. the ladder extended past `2^20` until a real crossover or memory limit appears, with the retained
   pre-change binary as control;
3. a structural route that removes width dependence — residue-class splitting of the sum axis, or
   meet-in-the-middle on the item set — with parity and certificate replay;
4. where only reachability is needed, a bitset in place of the `u64` count per sum (64x smaller
   state, cap to `2^26` for free), with memory reported per width;
5. a certificate from every declined instance stating the bound it exceeded; and
6. retirement of classifier entry N3 as a loss predictor, since the ladder shows no degradation
   before the cap.

Items 4 through 6 were rolled in from the C1038 extra-juice pass. Full counter A/B and
zero-allocation gates per the performance contract.

## C1052 — scheduler dense-lattice backend

Queued, after C1049 merges; core performance work under the performance contract. Target:
`scheduler.rs::solve_impl`.

Port the existing `WeightedRepairWorkspace` pattern so the per-layer `updated`, the `packed_states`
clone, `compact_loads`, and the unpresized `FxHashMap` allocations disappear — survey item T1, which
closes a stated allocation-invariant violation on three headline rows. Then hoist the per-layer
`prefix_best` buffer and narrow it to `u16` — survey items M1 and M2, worth up to 64 MiB per layer
today.

One A/B and RSS measurement covers all three changes; require parity on every scheduler test and
scenario row.
