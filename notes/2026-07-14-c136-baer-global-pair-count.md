# C136 — global Baer legal-pair count

**Date:** 2026-07-14
**Lane:** `baer`
**Status:** REPORTED

## Goal

Define the global finset of legal quadratic-Frobenius conjugate pairs, prove that unique mate-line
decomposition identifies its cardinality with `PairExtensionData.legalCount`, and synchronize the
paper's formalization boundary.

## Result

`RelativeConicArcs.QuadraticGlobalCount` defines `globalLegalPairs` semantically: its members are
fresh nonfixed Frobenius pairs whose union with the old set is an arc. The checked chain proves:

- `candidate_carrier_unique`: a conjugate candidate has only one fixed carrier;
- `mateLine_mem_emptyFixedLines_of_arc_union`: every semantic fresh pair extension has an empty
  mate line;
- `globalLegalPairs_eq_carrierwiseLegalPairs`: the semantic finset equals the pairwise-disjoint
  union of the existing local candidate-minus-forbidden finsets;
- `card_globalLegalPairs_eq_legalCount`: its cardinality is exactly the existing
  `PairExtensionData.legalCount` used by the quantitative theorem.

Thus the manuscript's global count no longer relies on a prose-only mate-line bridge.

## Validation

```text
choom -n 1000 -- nix develop --command lake build RelativeConicArcs.QuadraticGlobalCount
```

The build completed successfully (`3280` jobs). A source scan finds no `sorry`, `admit`, custom
`axiom`, `unsafe`, or `native_decide`. `#print axioms` on the four declarations above reports exactly
`[propext, Classical.choice, Quot.sound]`.
