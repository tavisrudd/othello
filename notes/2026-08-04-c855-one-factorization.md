# C855 — the one-factorization at equality: step 5 of the second Dye axiom

**Date:** 2026-08-04
**Lane:** `clebsch` (Paper I stream)
**Task:** C855, checklist item "Eliminate the two ad hoc Dye axioms".
**Plan:** `notes/2026-08-04-c855-dye-axiom-elimination-plan.md`, step 5.
**Deliverable:** `lean/RelativeConicArcs/SixArcOneFactorization.lean`.

## What the equality case now gives, formally

For a six-arc `A` in the projective plane over a field in which two is invertible, with exactly ten
triple-concurrence points, three theorems in
`RelativeConicArcs.SixArcOneFactorization` describe the chord matchings that are *not* concurrent:

- `card_filter_mem_nonconcurrentMatchings` — every chord of `A` lies in exactly one chord matching
  that is not concurrent;
- `card_nonconcurrentMatchings` — there are exactly five such chord matchings;
- `disjoint_of_mem_nonconcurrentMatchings` — distinct ones share no chord.

Together these say that the non-concurrent chord matchings partition the fifteen chords into five
perfect matchings: they are a one-factorization of the arc's chords, and every chord matching
outside it is concurrent. This is the combinatorial half of Dye's equality classification.

## The counting route, and why it replaces the plan's route

The plan reached the five-plus-one structure through transitivity of concurrence on the six
one-factorizations, using the double-perspectivity theorem, followed by a finite argument on class
sizes. A shorter route does the same work using only counting, and that is what landed:

each concurrent chord matching has three chords; each of the fifteen chords lies in at most two
concurrent chord matchings, which is exactly the per-secant bound of
`SixArcConcurrence.card_triplePoints_on_secant_le_two` transported along the chord-pairing
bijection; and ten concurrent matchings contribute thirty chord–matching incidences, which is
`2 × 15`. The bound is therefore attained at every chord, so every chord lies in exactly two
concurrent matchings. Since each chord lies in exactly three chord matchings in total, exactly one
matching through each chord fails to be concurrent, and the count of five follows from
`5 × 3 = 15`.

The triple-perspectivity theorem is therefore not needed for the partition. An adversarial review
recorded in `notes/2026-08-04-c855-dye-formalization-review.md` establishes further that it is not
needed for the remaining labelling step either: a chord matching is concurrent exactly when it is
not one of the five factors, so no perspectivity argument appears anywhere in the remaining chain.
`SixArcPerspectivity` stands as an independent theorem.

## New combinatorial content

- `card_filter_mem_matchings` — each chord of a six-element point set lies in exactly three chord
  matchings. The proof names the four points `a`, `b`, `c`, `d` off the chord and identifies the
  three matchings as those pairing `a` with `b`, `c` or `d` and joining the two points left over.
  Both inclusions are proved: a matching containing the chord contains the chord of `a` with some
  further point off the chord, and its third chord is then forced to be the complement.
- `sum_card_filter_mem` — the two ways of counting chord–matching incidences agree.
- `card_filter_mem_concurrentMatchings` — the concurrent chord matchings containing a fixed chord
  correspond to the triple-concurrence points on that chord's line, by the same chord-pairing
  bijection restricted to that line.
- `SixArcChordMatchings.eq_of_pairsThrough_eq` is new in the neighbouring module: distinct
  triple-concurrence points carry different chord matchings. It was previously inline in the
  bijection proof and is now a named theorem used in both places.

## Validation state

`RelativeConicArcs.SixArcOneFactorization` builds through the guarded build queue with no errors and
no warnings, as does the edited `RelativeConicArcs.SixArcChordMatchings`. `#print axioms` for
`card_filter_mem_matchings`, `card_filter_mem_nonconcurrentMatchings`,
`card_nonconcurrentMatchings` and `disjoint_of_mem_nonconcurrentMatchings` reports exactly `propext`,
`Classical.choice` and `Quot.sound`. Neither module is reached by a gate yet, so neither appears in
an axiom audit.

## What the second Dye axiom still needs

`dye1991_equality_classification` remains declared. Steps 2, 5, 6 and 7 of the plan are formalized.
What is left is the labelling and the order-eleven identification, in the simplified form the review
established:

- from the one-factorization, take two factors; their union is a six-cycle, which fixes a hexagonal
  labelling `p1 … p6` in which those two factors are `{p1p2, p3p4, p5p6}` and `{p1p6, p2p3, p4p5}`.
  Composing with the relabelling `q4 = p5`, `q5 = p6`, `q6 = p4` carries the four matchings that
  `GoldenHexagonNormalForm.golden_normal_form_of_concurrent_matchings` consumes off the
  one-factorization. Each of the four images shares a chord with one of the two chosen factors while
  differing from it, so `disjoint_of_mem_nonconcurrentMatchings` alone shows it is not a factor,
  hence concurrent. The three remaining factors never have to be identified.
- discharging that theorem's seven non-collinearity hypotheses and `p2 ≠ x` from the arc condition
  together with the concurrences already assumed: a concurrence point on a side of the coordinate
  triangle is forced to be a vertex, which the arc condition excludes. `x ∉ A` is already proved as
  `SixArcChordMatchings.notMem_of_concurrentAt`.
- at order eleven the two golden roots four and eight each admit an explicit projectivity carrying
  the golden hexagon onto `Examples.q11Witness`, so the branch on the root is closed by one matrix
  each with no normalization step. Witness matrices and their independent replay are recorded in
  `notes/2026-08-04-c855-dye-formalization-review.md`.
