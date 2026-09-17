# C1201 — the static join index's build cost: a rule for its representation

**Lane**: `ergodis`
**Date**: 2026-09-17
**Status**: QUEUED. Allocated from the C1193 closeout's largest measured effect
(`2026-09-17-c1193-nary-bodies-report.md`, "What is surprising, and what it opens"; replayed by
the audit `2026-09-17-c1193-nary-bodies-audit.md`).

## Why

`Policy::Auto` chooses a direct counting-sorted CSR for every static index whose key space fits
`MAX_DIRECT_KEYS`, whatever the relation's size. On `triangle` at N = 4,096 the fully bound third
atom keys on both columns, a key space of `domain²` = 2^24, and the offsets array is 64 MiB of
eagerly allocated and fully touched memory in the **plan**, invisible to `workspace_bytes()`.
Measured on the shipped binary (`closure_ballpark-cb11550`, replayed by the audit):

| `--index` | preparation | peak RSS | evaluation |
| --- | ---: | ---: | ---: |
| `auto` | 27 ms | 71 MB | 0.87 ms |
| `sparse-indexes` | 3.5 ms | 6 MB | 2.39 ms |

Preparation is thirty times the evaluation, and it is what puts the evaluator at 1.92 times
compiled Soufflé on `triangle` while it is 0.35 times on `path4`. C1192's recorded deviation 5 gave
the static index no density rule because the counting-sorted bucket beats a binary search at every
density; that priced the **probe** and never the **build**. C1198 made the workspace lazy and left
the plan's CSR eager.

## Deliverable

- A representation decision for a static index that prices the build as well as the probe: a rule
  on key-space size against row count (density), or a lazy `Pages`-style reservation for the
  offsets array so untouched key ranges cost nothing, or both; chosen by measurement, with the
  crossover stated and tested.
- The two-atom and n-ary kernels read the chosen kind through the existing `KIND_*` dispatch; no
  new kernel.
- `Policy::Auto` is the only policy whose choice changes; `Direct`, `Sparse`, `SparseIndexes` keep
  their meaning.

## Acceptance

- `triangle` at 4,096 and 16,384 under `Policy::Auto`: preparation and peak RSS at or near the
  sparse row, evaluation at or near the direct row; Soufflé `compare.py` row re-run.
- Every C1192 and C1193 cohort under `Policy::Auto`: instruction ratio against the retained control
  within the A/A null on cohorts whose chosen kind does not change; kind changes listed per cohort
  with the rule that made them.
- Exactness: the C1189 differential and both checkers, the `demand_nary` and `demand_prepared`
  suites, and the C1192 collision cases; work counts (probes, candidates) unchanged where the kind
  is unchanged.
- Performance-contract validation per `PERFORMANCE.md`; the retain from a tree whose
  `git status --short` is empty, checked before the recipe runs (C1193 audit finding 1); report
  with Mystery ledger; audit.

## Out of scope

Dynamic (growing) indexes, whose representation C1192 decided by reset traffic; the checkers'
`datalog_store.rs` eager commit (a separate open frontier); join ordering.
