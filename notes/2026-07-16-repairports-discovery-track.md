# Repair ports discovery track

**Lane:** `repairports`

Append-only catchment for incidental observations and musings encountered during C215--C220 work,
under [`discovery-track-conventions.md`](discovery-track-conventions.md). Entries are leads, not lane
obligations or task allocations.

When they arise incidentally, preserve algorithmic implications of the repair-port theory here:
search-space reductions, reusable data structures, parameterized or output-sensitive algorithms,
extraction opportunities, and complexity questions. This is a watch lens, not a queued algorithms
deliverable.

### 2026-07-16 — pointed syndrome tables suggest multiobjective decoding algorithms

**Provenance:** C215 prior-art audit comparing the cached evaluator with induced quotient weights
and classical syndrome/coset-leader tables.
**Was I looking for this?:** no — the audit was deciding the novelty boundary, not designing an
algorithm family.
**Observed / musing:** the C215 cache is a syndrome table augmented with, for every syndrome and
inner coordinate, the best representative forced nonzero at that coordinate. Computing all pointed
columns simultaneously is a multiobjective syndrome-decoding problem. Orbit compression,
trellis/state-space methods, or incremental updates across coordinates may avoid rebuilding one
table per target and may expose output-sensitive algorithms for symmetric inner codes.
**Why it may matter / strongest question:** for which represented inner codes can the complete
pointed table be computed in time polynomial in the number of syndromes and coordinates, rather
than the ambient `|F|^|K|` traversal?
**Evidence:** REASONED; the ordinary-table identification is source-checked and the pointed cache is
LEAN, but no improved algorithm or complexity bound is proved.
**Status:** open lead
