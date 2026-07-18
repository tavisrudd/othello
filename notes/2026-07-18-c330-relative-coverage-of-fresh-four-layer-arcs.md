# C330: relative coverage of fresh four-layer arcs

**Lane:** `relconic`

**Date:** 2026-07-18

**Status:** queued; final construction-facing consumer of C329 before the C299 drafting gate.

## Objective

Determine whether C329's collision-free `Delta_R=0` four-layer family covers every point of the
prescribed conic by a surviving secant over every sufficiently large odd-tower field.  A positive
result must hold on the same six-trace and joint-pentic-derangement survivor used for
collision-freeness; a coverage theorem on a disjoint parameter open is insufficient.

## Closed inputs

- C329 supplies an explicit nonempty skeleton open, the degree-`64` rational Artin--Schreier cover,
  the joint `S5 times S5` pentic cover, exact deletions, and collision-free points for `Q>=2^45`.
- C317 proves that the four no-root gates are exactly collision-freeness and explicitly separates
  that property from relative coverage.
- C302 supplies the carrierwise secant-defect and deletion-stability identities and the warning
  that collision scarcity does not imply coverage.
- C315--C316 supply the exact `E4` reconstruction, layer supports, common-height freedom, quotient
  data, and prescribed-conic deletions.

## First packet

For a prescribed-conic point `c`, write the exact secant equations against all six unordered layer
pairs on C329's `Delta_R=0` skeleton.  Quotient the free simultaneous translation before counting,
separate coincidences and tangencies scheme-theoretically, and determine whether failure to cover
`c` is a proper divisor (uniformly in `c`) on the six-trace/pentic survivor.  Any global count must
track the common-height choice and every C315/C316 deletion rather than union-bound unspecified
bad sets.

## Exit gates

C330 closes with one of:

1. a uniform effective theorem that some C329 collision-free configuration covers every
   prescribed-conic point, yielding a `C`-complete `O(sqrt(q))` arc on an explicit odd-tower tail;
2. an exact structural obstruction showing that the `Delta_R=0` survivor necessarily leaves a
   prescribed-conic point uncovered, together with the precise interface to a generic
   `Delta_R!=0` fallback; or
3. a bounded negative theorem for both coincidence and generic routes.

An average coverage count, a fixed-target result without simultaneous uniformity, or a finite-field
census is not an exit.
