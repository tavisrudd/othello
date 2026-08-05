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

The triple-perspectivity theorem is therefore not needed for the partition. It remains needed later,
to place the concurrences in the hexagonal labelling that the golden normal form consumes.

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
What is left is the labelling and the order-eleven identification:

- from the one-factorization, a hexagonal labelling `p1 … p6` of the arc in which the four matchings
  that `GoldenHexagonNormalForm.golden_normal_form_of_concurrent_matchings` consumes all avoid the
  one-factorization, hence are concurrent. Two of its factors have union a six-cycle, which fixes a
  hexagonal order in which the remaining three factors are determined; a further explicit
  relabelling then moves the required four matchings off the one-factorization.
- discharging that theorem's seven non-collinearity hypotheses and `p2 ≠ x` from the arc condition
  and the concurrence points being off the arc;
- at order eleven, where the golden roots are four and eight, the explicit projectivity carrying the
  normal form to `Examples.q11Witness`, a finite check.
