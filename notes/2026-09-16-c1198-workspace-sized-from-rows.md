# C1198 — demand workspace sized from rows: zero-sentinel tables and lazy page commit

**Lane**: `ergodis`
**Date**: 2026-09-16
**Status**: QUEUED. C1192 successor; the report names this "the largest single product-path
defect the lane has" (mystery ledger item 7, remaining gap 4). Independent of C1193–C1196; C1195's
default-bound rows are meaningless until it lands.

## Why

Every workspace structure is sized from the caller's row bound, not from the program: row and
witness columns, the sparse hash tables and the direct offsets array all take `max_rows` (default
2^24), and `fill(NONE)`/`fill(0)` before every evaluation touches all of it, 64 MiB per table at
the default bound. Measured cost: `cycle` at N = 4,096 reserves 1,131,440 KiB against 23,872 KiB
with a sized bound (×47); against compiled Soufflé the whole-process ratio is 3.24 at the default
bound and 0.98 sized, with evaluation unchanged and preparation 123 ms → 21 ms. C1191 recorded the
same effect from the Rel route (`--max-rows 16777216` alone reserved 1.6 GB on `columns3`).
Zero-filled `calloc` pages are already committed lazily by the kernel; the explicit `NONE` fill
and the eager sizing are what defeat that.

## Deliverable (all within `PERFORMANCE.md`: presized, never grows in the loop, bounded exit)

1. **Zero is the empty sentinel.** Hash heads, chain `next`, membership heads and bitmaps store
   `index + 1` so a fresh zero page is already empty. No `fill(NONE)` at preparation; the first
   evaluation touches only the pages it uses.
2. **Reset touches only what was used.** Between evaluations clear by high-water mark (rows
   derived, slots written) or re-map the region, never by capacity.
3. **Reserve, do not allocate.** Large stores are anonymous `MAP_NORESERVE` mappings (`libc`)
   sized to the presized capacity, with `MADV_HUGEPAGE` on large tables; reservation is O(1) in
   `max_rows`, commit follows touch; one owned mapping type with a `SAFETY` comment and a measured
   benefit. Reuse the C1170 cold-start method to prove coldness (faults per iteration equal the
   pages touched; `/proc/self/stat` agrees; no touch loop in the disassembly).
4. **Capacity from the program where a bound exists**: input relations from their fact counts;
   derived relations `min(universe, max_rows)` as now, with the per-column domain product when the
   C1191 closing pass supplies it; the caller's `max_rows` remains the ceiling, not the size.
5. `MAX_WORKSPACE_BYTES` becomes a bound on reservation, and a separate reported figure on
   commit (peak RSS), both in the CLI/report.

## Acceptance

- Allocation regression at zero in the loop under every `Policy`; kernel-scoped profile (no
  `memset` in preparation above the touched pages); the C1170 coldness proof.
- Closure digests, certificates and both checkers byte-identical to C1192's on every fixture,
  cohort and the property corpus; C1189 differential zero; parity digest unchanged or explained.
- A/B against `closure_ballpark-b7921a0` (derivation loop) and `ergodis-tools-f12e27b`
  (frontend/backend): instructions in the loop unity; preparation read from faults and wall;
  peak RSS at the default bound within a small factor of the sized bound on `cycle`, `mutual`,
  `closure/blocks` and the C1191 boundary cohorts; the Soufflé table re-run at the default bound
  with the expectation that it matches the sized-bound column.
- Report in the playbook's shape with Mystery ledger; independent read-only audit.

## Out of scope

Growing tables inside a round (violates the allocation-free rule); the n-ary join (C1193);
a resumable mid-round budget exit (record as an alternative if item 4 leaves a gap).
