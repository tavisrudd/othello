# C855 — the chord-pairing bijection in Lean: steps 2 and 5 of the second Dye axiom

**Date:** 2026-08-04
**Lane:** `clebsch` (Paper I stream)
**Task:** C855, checklist item "Eliminate the two ad hoc Dye axioms".
**Plan:** `notes/2026-08-04-c855-dye-axiom-elimination-plan.md`, the chord-pairing dictionary of
steps 2 and 5.
**Deliverable:** `lean/RelativeConicArcs/SixArcChordMatchings.lean`, theorem
`RelativeConicArcs.SixArcChordMatchings.card_concurrentMatchings_eq_card_triplePoints`.

## Statement proved

For a six-arc `A` in an arbitrary finite projective plane, in Mathlib's
`Configuration.ProjectivePlane` vocabulary and with no coordinates and no characteristic hypothesis,

```
(concurrentMatchings A).card = (SixArcConcurrence.triplePoints A).card
```

Here a *chord matching* of `A` is a `Finset (ArcPair A)` of three chords whose endpoint pairs are
pairwise disjoint, `concurrentMatchings A` is the finite set of those whose three lines share a
point of the plane, and `triplePoints A` is the already-formalized set of off-arc points lying on
three secants. The bijection realizing the equality sends a triple-concurrence point `x` to
`pairsThrough A x`, the chords of `A` through `x`.

This is the dictionary the equality case of the Dye classification consumes: the hypothesis
`(brianchonPoints A).card = 10` becomes the statement that ten chord matchings of `A` are
concurrent, which is what the finite one-factorization argument ranges over.

## The four component statements

- `isChordMatching_pairsThrough` — the chords through a triple-concurrence point form a chord
  matching: their number is the point's secant index, three, and their endpoint pairs are pairwise
  disjoint because a shared endpoint together with the point would determine both chords.
- `biUnion_eq_of_isChordMatching` — three disjoint pairs exhaust a six-arc, so a chord matching
  partitions `A`.
- `notMem_of_concurrentAt` — a point at which a chord matching is concurrent lies off the arc. If it
  were an arc point it would lie in exactly one of the three pairs, and its incidence with a second
  chord would put three distinct arc points on one line.
- `triplePoint_of_concurrentAt` — a chord matching concurrent at `x` is exactly the set of chords
  through `x`, and `x` is a triple-concurrence point. The matching is contained in the chords
  through `x`; the previous statement makes `x` external, so the general bound of `|A|/2` secants
  through an external point of an arc caps that containment at three and forces equality.

Injectivity of `x ↦ pairsThrough A x` is the remaining ingredient: two distinct points carrying the
same matching would put two of its chords through both of them, so those two chords would share the
line joining the points, contradicting injectivity of the chord-to-line map on an arc.

## Validation state

`RelativeConicArcs.SixArcChordMatchings` elaborates through the guarded single-file entry point with
no errors and no warnings, and `#print axioms` for the bijection theorem reports exactly `propext`,
`Classical.choice` and `Quot.sound`. Single-file elaboration against last-built dependencies is a
smoke test, not a gate; the module is not yet reached by a gate, so it does not appear in an axiom
audit. Its only import is `RelativeConicArcs.SixArcConcurrence`, which the rigidity gate already
compiles.

## What the second Dye axiom still needs

`dye1991_equality_classification` remains declared. Against the plan's step list, steps 2, 5, 6 and
7 are now formalized — the chord-pairing dictionary here, the double-perspective identity in
`SixArcPerspectivity`, and the golden normal form in `GoldenHexagonNormalForm`. What is left is the
passage from the count to a labelled hexagon, and the order-eleven identification:

- transitivity of concurrence on the six one-factorizations of the fifteen chords, derived from the
  triple-perspectivity theorem, and the finite argument that a sum of binomial coefficients
  `Σ C(aᵢ,2) = 10` over class sizes summing to six forces the partition `5 + 1`;
- the choice of a hexagonal labelling compatible with that partition, which supplies the four
  concurrences `GoldenHexagonNormalForm` consumes and discharges its non-collinearity hypotheses
  from the arc condition;
- at order eleven, where the golden roots are four and eight, the explicit projectivity carrying the
  normal form to `Examples.q11Witness`, a finite check.
