# C855 — the golden normal form in Lean: step 7 of the second Dye axiom

**Date:** 2026-08-04
**Lane:** `clebsch` (Paper I stream)
**Task:** C855, checklist item "Eliminate the two ad hoc Dye axioms".
**Plan:** `notes/2026-08-04-c855-dye-axiom-elimination-plan.md`, step 7.
**Deliverable:** `lean/RelativeConicArcs/GoldenHexagonNormalForm.lean`, theorem
`RelativeConicArcs.GoldenHexagonNormalForm.golden_normal_form_of_concurrent_matchings`.

## Statement proved

Over an arbitrary field `K` and a `K`-vector space `V` with `finrank K V = 3` — no characteristic
hypothesis and no finiteness — six projective points whose four matchings

* `{p1p2, p3p4, p5p6}` (concurrent at `x`),
* `{p1p4, p2p3, p5p6}` (concurrent at `q₁`),
* `{p1p3, p2p5, p4p6}` (concurrent at `q₂`),
* `{p1p4, p2p5, p3p6}` (concurrent at `q₃`)

are concurrent, and which satisfy seven non-collinearity conditions together with `p2 ≠ x`, admit a
frame `u` and a scalar `φ` with `φ * φ = φ + 1` in which

```
p1 = (1:0:0)   p2 = (φ:1:1)   p3 = (0:1:0)   p4 = (1:φ:1)   p5 = (0:0:1)   p6 = (1:1:2-φ)
```

as an equality of projective points, each stated in the `quad_normal_form` idiom
`∃ h : v ≠ 0, Projectivization.mk K v h = pᵢ`.

Two consequences come free with the statement. The ground field contains a root of `t² = t + 1`,
which is the existence half of Dye's condition that five is a square, and the configuration is
determined up to a projective change of frame by the four concurrences alone.

## How the three parameters are pinned

Normalizing `p1, p3, p5` to the coordinate triangle with unit point `x` forces the shapes
`p2 = (A : S : S)`, `p4 = (M : B : M)`, `p6 = (N : N : C)`; the six entries are nonzero, each from
one non-collinearity hypothesis. Each further concurrence is eliminated by expanding its three
collinearity determinants in frame coordinates and cancelling the concurrence point's coordinates:

- `{p1p4, p2p3, p5p6}` gives `B · S = M · A`, that is, the parameters of `p2` and `p4` agree;
- `{p1p4, p2p5, p3p6}` gives `A · B · C = M · S · N`, the triple-perspective identity `φφ'ψ = 1`;
- `{p1p3, p2p5, p4p6}` gives `A·B·C − M·C·S + M·N·S − M·N·A = 0`, which against the previous
  identity collapses to `φ + ψ = 2`.

Writing `φ = A / S` the three relations become `φ' = φ`, `ψ = 2 − φ` and `φ²(2 − φ) = 1`, hence
`(φ − 1)(φ² − φ − 1) = 0`. The root `φ = 1` puts `p2` at the perspectivity centre `x`, which
`p2 ≠ x` excludes, so `φ² = φ + 1`.

The cancellations need the concurrence points' coordinates to be nonzero, and each is forced
rather than assumed: a vanishing coordinate propagates through the two remaining relations to make
all three vanish, contradicting `FrameCoordinates.exists_coord_ne_zero`.

## Shared-module change

The five frame-coordinate helpers that `SixArcPerspectivity` carried privately — entrywise
`coordOf` of a scalar multiple and of a sum, `coordOf` of the frame vectors, the row-scaling
determinant identity, and the collinearity criterion whose third row is an explicit representative
— are promoted into `RelativeConicArcs.FrameCoordinates` with docstrings, and
`SixArcPerspectivity` now imports them. `exists_coord_ne_zero` is new there.

## Validation state

- `RelativeConicArcs.GoldenHexagonNormalForm` builds through the guarded queue, and its
  `#print axioms` line reports exactly `propext`, `Classical.choice`, `Quot.sound`.
- `RelativeConicArcs.SixArcPerspectivity` builds against the promoted helpers. This also closes the
  gap recorded in `notes/2026-08-04-c855-triple-perspective.md`: that module had been verified only
  in scratch form against a copy of its dependency's source, and it now compiles against the
  compiled `FrameCoordinates` artifact with no change to its theorem.
- Neither module is reached by a gate yet, so neither appears in an axiom audit.

## What the second Dye axiom still needs

`dye1991_equality_classification` remains declared. Against the plan's step list, steps 6 and 7 are
now formalized. What is left is the passage from the arc hypothesis to the four concurrences and
the identification of the normal form with the displayed witness:

- the chord-pairing bijection between triple-concurrence points and concurrent matchings, so that
  the count ten becomes "ten of the fifteen matchings are concurrent";
- transitivity of concurrence on the six one-factorizations from the triple-perspectivity theorem,
  and the finite argument that `Σ C(aᵢ,2) = 10` forces the class partition `5 + 1`;
- the choice of a hexagonal labelling compatible with that partition, which supplies exactly the
  four concurrences this theorem consumes, and discharges its non-collinearity hypotheses from the
  arc condition;
- at order eleven, where the golden roots are four and eight, the explicit projectivity carrying
  the normal form to `Examples.q11Witness`, which is a finite check.
