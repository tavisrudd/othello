# C855 — the hexagonal order in Lean: the labelling step of the second Dye axiom

**Date:** 2026-08-04
**Lane:** `clebsch` (Paper I stream)
**Task:** C855, checklist item "Eliminate the two ad hoc Dye axioms".
**Plan:** `notes/2026-08-04-c855-dye-axiom-elimination-plan.md`, with the simplifications settled in
`notes/2026-08-04-c855-dye-formalization-review.md`.
**Deliverable:** `lean/RelativeConicArcs/SixArcHexagonalOrder.lean`, theorem
`RelativeConicArcs.SixArcHexagonalOrder.exists_hexagonal_order`.

## Statement proved

For a six-element point set `A` and two chord matchings `M`, `N` of `A` with no chord in common, the
points of `A` can be listed as `p₁ … p₆`, with no repetition, so that

```
M = {p₁p₂, p₃p₄, p₅p₆},   N = {p₂p₃, p₄p₅, p₆p₁}.
```

The conclusion carries the six points, the six chords, the list-nodup fact, the equality
`A = {p₁, …, p₆}`, the six chord values, and the two matching equalities, so a consumer can read off
whatever it needs. Nothing about incidence, coordinates or arcs enters: the statement and proof are
about a six-element set, its two-element subsets, and two matchings of them.

## How the hexagon is closed

Fix a chord `p₁p₂` of `M` and follow the chords of `N` out of its two endpoints. Neither partner can
be the other endpoint of `p₁p₂`, since the chord of `N` joining them would be the chord `p₁p₂` of
`M`, and the two matchings share no chord. The two partners are distinct, because two chords of `N`
through one point would violate the disjointness inside `N`.

The one real step is that the two partners lie in different chords of `M`. If both lay in the same
chord of `M`, the two points left over would be joined by the third chord of `M`, and also by the
third chord of `N`, since the first two chords of `N` already cover the other four points. That
shared chord contradicts the hypothesis. In Lean this is
`not_partners_in_same_chord`, which identifies the third chord of `N` using
`SixArcChordMatchings.eq_triple_of_mem`.

With the partners in different chords of `M`, the walk
`p₁ —M— p₂ —N— p₃ —M— p₄ —N— p₅ —M— p₆ —N— p₁` visits all six points, and the
labelling is read off it. The case analysis is over which of the four points off the first chord is
each partner, sixteen branches: four are impossible because the partners are distinct, four are the
same-chord contradiction, and eight assemble the labelling through one shared packaging lemma
`hexagonal_order_of_partners`.

## Supporting lemmas and the refactor asked for by the review

The review of the previous two commits noted that the chord-level helpers were private in
`SixArcOneFactorization` and would need public homes. They are now in a new plane-free section of
`RelativeConicArcs.SixArcChordMatchings`, with docstrings, and `SixArcOneFactorization` imports them
instead of carrying its own copies:

- `exists_arcPair_val` — two distinct points of `A` are the endpoint pair of a chord;
- `ne_of_disjoint_val` — chords with disjoint endpoint pairs are distinct;
- `isChordMatching_triple` — three chords with pairwise disjoint endpoint pairs form a matching;
- `eq_triple_of_mem` — a matching of a six-element set containing two given chords consists of those
  two and the chord on the two remaining points;
- `exists_mem_val_pair` — the chord of a matching through a given point, with its partner.

New private helpers in the labelling module: `eq_six_of_chords` lists the six points of a matching
from its three chords, `pair_eq_sdiff_union` deletes two disjoint pairs from six distinct points, and
`nodup_of_toFinset_eq` turns "a six-entry list enumerates a six-element set" into a no-repetition
statement. Passing the matching data rather than a fixed enumeration of the six points to the two
main helpers is what keeps the sixteen branches short: each branch supplies chord values only, with
no set reordering.

## Validation state

`RelativeConicArcs.SixArcHexagonalOrder` builds through the guarded build queue with no errors and no
warnings, and `#print axioms exists_hexagonal_order` reports exactly `propext`, `Classical.choice`
and `Quot.sound`. The edited `SixArcChordMatchings` and `SixArcOneFactorization` also build clean.
None of these modules is reached by a gate yet.

## What the second Dye axiom still needs

`dye1991_equality_classification` remains declared. The remaining work is the plane-level assembly:

- apply the labelling to two factors of the one-factorization produced by
  `SixArcOneFactorization` — distinct factors exist because there are five, and they share no chord
  by `disjoint_of_mem_nonconcurrentMatchings`;
- relabel by `q4 = p5`, `q5 = p6`, `q6 = p4` and, for each of the four matchings that
  `GoldenHexagonNormalForm.golden_normal_form_of_concurrent_matchings` consumes, exhibit the chord it
  shares with one of the two chosen factors together with a chord it does not have, so that it is not
  itself a factor and is therefore concurrent;
- convert the concurrence data to `ProjectiveCap.Projective.Collinear` triples through
  `ProjectiveBridge`, and discharge the non-collinearity hypotheses from the arc condition;
- at order eleven, one explicit projectivity per golden root onto `Examples.q11Witness`.
