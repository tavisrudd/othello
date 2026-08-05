# C855 — the plane-level assembly: from the one-factorization to the golden normal form

**Date:** 2026-08-04
**Lane:** `clebsch` (Paper I stream)
**Task:** C855, checklist item "Eliminate the two ad hoc Dye axioms".
**Plan:** `notes/2026-08-04-c855-dye-axiom-elimination-plan.md`, with the simplifications settled in
`notes/2026-08-04-c855-dye-formalization-review.md`.
**Deliverable:** `lean/RelativeConicArcs/SixArcGoldenNormalForm.lean`, theorem
`RelativeConicArcs.SixArcGoldenNormalForm.exists_golden_frame`.

## Statement proved

Let `K` be a finite field in which two is invertible and let `A` be a six-arc of the projective
plane over `K` with exactly ten triple-concurrence points. Then there is a basis `u₀, u₁, u₂` of
`K³` and a scalar `φ` with `φ² = φ + 1` such that

```
A = {(1:0:0), (φ:1:1), (0:1:0), (1:φ:1), (0:0:1), (1:1:2−φ)}
```

in the frame `u`. The conclusion carries the linear independence of `u`, the golden relation, the
six nonvanishing proofs, and the set equality, so a consumer can read off the frame, the root, or
the point list. In particular the ground field contains a golden root whenever such an arc exists.

This is the whole of the equality classification except its final order-eleven step: identifying
the golden hexagon with the displayed witness `Examples.q11Witness`.

## How the four concurrences are produced

The three inputs were already in place. Equality in the ten-point bound makes the chord matchings
that are *not* concurrent five in number and pairwise chord-disjoint, so they partition the fifteen
chords (`SixArcOneFactorization`). Two chord matchings with no common chord close a hexagon
(`SixArcHexagonalOrder`). Four labelled concurrences force the golden normal form
(`GoldenHexagonNormalForm.golden_normal_form_of_concurrent_matchings`).

The assembly picks two of the five factors — distinct ones exist because there are five — and
applies the hexagonal labelling to them, producing a listing `p₁ … p₆` of `A` in which the two
factors are `{p₁p₂, p₃p₄, p₅p₆}` and `{p₂p₃, p₄p₅, p₆p₁}`. The golden labels are then the
relabelling that sends the last three points to `p₅, p₆, p₄`, so that the four matchings the normal
form consumes are, in the hexagonal listing,

```
{p₁p₂, p₃p₅, p₄p₆},  {p₁p₅, p₂p₃, p₄p₆},  {p₁p₃, p₂p₆, p₄p₅},  {p₁p₅, p₂p₆, p₃p₄}.
```

Each of these shares a chord with one of the two chosen factors while containing a chord that
factor does not have. A chord matching sharing a chord with a factor and differing from it cannot
itself be a factor, because distinct factors share no chord; and every chord matching outside the
five factors is concurrent by definition. That is `exists_concurrentAt_of_shared_chord`, and it is
the only step that consumes the one-factorization. The remaining three factors are never
identified, so the prism-uniqueness argument of the earlier plan does not appear, and neither does
the double-perspectivity theorem.

## Discharging the non-degeneracy hypotheses

The normal form asks for ten non-collinearities and one point inequality. Seven of the ten are
triples of distinct points of `A` and follow from the arc condition. The remaining three involve
the frame-defining concurrence point `x`, and follow from one lemma: if `x` lies off the arc on the
line of a chord `e`, then an endpoint of `e`, a point of the arc outside `e`, and `x` are not
collinear, because the line joining that endpoint to `x` is `e`'s own line, which meets the arc only
in `e`'s two endpoints. The inequality `p₂ ≠ x` is `x ∉ A`, already proved as
`SixArcChordMatchings.notMem_of_concurrentAt`.

Incidence collinearity is converted to the coordinate predicate through
`ProjectiveBridge.collinear_iff_projective_collinear` in both directions, by the two private
bridging lemmas `projectiveCollinear_of_chord` and `not_projectiveCollinear_of_arc`.

## Elaboration cost

The proof elaborates in about four seconds under the default heartbeat limit. One tactic had to be
moved to earn that: closing the final set equality by `ext` and `tauto` inside the coordinate
context exceeded a million heartbeats in `whnf`, because the ambient `Fintype` and `DecidableEq`
instances on projective points are classical and non-reducing. Stating the same six-element
reordering as `sextuple_cycle_last_three` over a bare type with decidable equality, and applying it,
costs nothing. No other step in the module is near the limit; the twenty-two-argument application of
the normal form and all of the chord bookkeeping together account for well under a second.

## Validation state

`RelativeConicArcs.SixArcGoldenNormalForm` elaborates through the guarded single-file entry point
with no errors and no warnings, against the compiled artifacts of its three imports.
`#print axioms exists_golden_frame` reports exactly `propext`, `Classical.choice` and `Quot.sound`:
no Dye axiom, no `sorry`, no compiled evaluation. The module is not reached by a gate yet, so it
does not appear in an axiom audit.

## What the second Dye axiom still needs

`RelativeConicArcs.ClebschDye.dye1991_equality_classification` remains declared. Exactly one step is
left: at order eleven, `φ * φ = φ + 1` over the field of eleven elements forces `φ = 4` or `φ = 8`,
and each root admits an explicit projectivity carrying its golden hexagon onto `Examples.q11Witness`
— matrices `(2,0,10; 9,9,7; 0,3,4)` for `φ = 4` and `(1,7,9; 10,6,9; 0,5,8)` for `φ = 8`, acting on
column vectors mod eleven, recorded and independently replayed in
`notes/2026-08-04-c855-dye-formalization-review.md`. The Lean work is a linear equivalence from the
golden frame to the standard basis composed with the explicit matrix, six projective-point
equalities with explicit scalars, and the `Finset.map` bookkeeping reaching `clebschWitness`. After
that, the axiom becomes a theorem, the permitted-axiom entry in `lean/trust/areas/relconic.toml` is
deleted, and the six new modules need a gate that reaches them.
