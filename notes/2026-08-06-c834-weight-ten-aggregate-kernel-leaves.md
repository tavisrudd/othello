# C834 — the weight-ten aggregate's two own leaves, and the merge-sort verdict

**Lane:** `clebsch` · **Task:** C834 (Paper IV full Lean release closure) · **Date:** 2026-08-06

## The probe and its answer

The execution plan's first-stage probe asked whether the 595-element `List.mergeSort` in
`PassantCodeQ13.WeightTen.Aggregate` reduces in the kernel at acceptable cost. It does not reduce at
all, and the reason is not size: `List.mergeSort` is defined by well-founded recursion, so the kernel
cannot unfold it for any input whatever. The probe separates that cleanly from the data, which
reduces without difficulty — `secantNeighbors.length = 35` and both pair lists having 595 entries are
kernel-checked in seconds.

So the answer is the plan's second branch, and it is a property of the library function rather than a
threshold to be measured. No shard, index split, or larger limit reaches it.

## What replaced it

The module now defines its own insertion sort on lists of pairs, ordered by the encoding of a pair as
a natural number, and proves that repeated insertion permutes its input. Insertion recurses
structurally, so the kernel reduces it on the displayed data.

That also strengthens the theorem. `cycle_pair_partition` previously asserted an equality of two
merge-sorted lists of encodings; it now asserts

```text
List.Perm ((List.range 7).flatMap cyclePairs) (secantNeighbors.sublistsLen 2)
```

which is the claim its docstring always made — the seven residue shards contain exactly the unordered
pairs of secant neighbours, with the same multiplicity — stated on the pairs themselves rather than
on their encodings. Nothing is assumed about the order the encoding induces: the permutation follows
from the sort permuting its input, so the encoding needs no injectivity argument and the sorted form
is only a canonical meeting point.

The same round found that `local_partition`, the incidence partition at the base point, reduces in
the kernel outright. It carried a native decision that the data never required.

`cycle_pair_partition` is an audit terminal that no proof consumes, so restating it was free.
`local_partition` feeds `PassantCodeQ13.Gates.Main` and kept its statement.

## Validation

`PassantCodeQ13.Gates.Main` rebuilt in 27 seconds and `PassantCodeQ13.Gates.AxiomAudit` in 3, both
green, and the evidence verifier passes. The audit's 94 terminals now report 58 carrying only
`propext`, `Classical.choice` and `Quot.sound`, against 56 before this change and 53 at the start of
the day, with 36 still carrying a declaration-local native-evaluation axiom.

## What this leaves in the weight-ten packet

The fourteen syndrome-disjointness shards — seven isolated-profile fibres and seven cycle-profile
residues — are still native. They are genuine search over the reachability kernel's transition
layers, not an artifact of a library definition, and the plan's route for them is unchanged.

## Mystery ledger

- **Why these two leaves were native at all.** Settled for `cycle_pair_partition`: the merge sort
  blocked kernel reduction, and native evaluation was the only way to run it as written. Unexplained
  for `local_partition`, which reduces in seconds and appears never to have needed native evaluation;
  nothing on disk records a failed attempt at it. No evidence gap remains either way, since both are
  now kernel-checked.
- Nothing else in this round is unexplained.
