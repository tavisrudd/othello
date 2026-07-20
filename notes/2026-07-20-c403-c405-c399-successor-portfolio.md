# C403--C405 — C399 significance and bounded successor portfolio

**Lane:** `crowns`

**Date:** 2026-07-20

**Status:** queued behind C399 in descending expected-value order

## Significance ruling

Conditional on novelty closure, C399 is a potential programme-founding result rather than another
exceptional finite configuration.  Its theorem package has four conceptual layers:

1. all irreducible rank-three Coxeter types `A3`, `B3`, and `H3` obey one complement-code law,
   with Coxeter number `h=4,6,10`,

   ```text
   n = (q-h/2)(q-h+1),
   d = (q-h/2-1)(q-h+1);
   ```

2. the exact Singleton defect is `q-h-1`, so `q=h+1` is precisely the MDS transition;
3. at `q=h+1=5,7,11`, the complement is the full invariant conic and hence the
   `[q+1,3,q-1]_q` extended GRS code; and
4. the full conic child forgets its Coxeter parent through exact normalizer-index fibres of sizes
   `5,14,22`, while every irreducible rank-four continuation fails the necessary quadric point
   count.  For rank-four `A4`, `h+1=6` is not a field order; the other rank-four types fail the
   numerical identity at their actual candidate fields.

C398 supplies the global six-arc envelope: among non-GRS six-arcs over every finite field, the
`H3,q=11` member is the unique full-conic deepest-syndrome transform.  Thus C398 closes the
classification while C399 supplies the arithmetic mechanism and the exact information lost at the
maximally symmetric child.

The classical layers receive no novelty wording by themselves: Coxeter exponents, characteristic-
polynomial complement counts, conic automorphisms, the arc--MDS/GRS dictionary, and homogeneous-
space orbit counts.  The potentially flagship content is the uniform distance law, exact
conic--GRS transition, certified rank-four boundary, intrinsic parent-forgetting geometry, and the
C398 uniqueness composition.

The three successors below test whether C399 begins a reusable theory.  None is manuscript weight
unless it clears its stated theorem and literature gates.  Every paper-facing mathematical claim is
a Lean target under the Clebsch trust policy; exact certificates remain independent replay layers.

## C403 — rank-three arrangement-complement codes

### Target

Determine the weakest intrinsic hypotheses on an essential rank-three arrangement under which the
projective complement evaluation code has its length and minimum distance determined by
characteristic/flag-coboundary data.  Recover C399 from one theorem rather than from three Coxeter
tables.

The first candidate formulation starts with

```text
chi_A(t) = (t-1)(t-a)(t-b)
```

and asks when the projective complement code has

```text
n = (q-a)(q-b),
max_line_intersection = q-b,
d = n-(q-b).
```

The point count is classical finite-field-method data.  The research question is whether the
maximal line intersection, hence minimum distance, follows from a flag-Tutte/coboundary invariant
or from one short geometric condition that includes `A3/B3/H3`.

### Pilot and stop

1. Derive the complete line-intersection spectrum of the three C399 complements from their
   intersection lattices and flag data, without coordinate enumeration.
2. Test at least one nonreflection free arrangement and one arrangement sharing the ordinary
   characteristic polynomial but differing in flag data.
3. Decide exactly which invariant determines the distance and whether it also yields a useful
   weight enumerator or generalized-weight corollary.

Stop if ordinary or flag Tutte data does not determine the distance, if the required hypotheses
simply restate the line-intersection conclusion, or if arrangement-code literature states the same
specialization.  Audit arrangement evaluation codes, coboundary/flag-Tutte polynomials, critical
problems, and characteristic-polynomial finite-field methods before priority language.

## C404 — Coxeter parent fibres as coherent geometry

### Target

Turn the certified `5,14,22` normalizer-index fibres into an intrinsic theorem about decorations of
the full conic child.  For `A3/B3/H3`, identify the minimal child-side decoration that recovers the
parent, classify the intersection relations among decorations, and determine the full automorphism
group of the resulting coherent configuration.

The result succeeds only if one uniform construction explains all three types.  The H3 member must
recover C379's 22 matching-decorated parents and its two-sheet/biplane relations; bare coset-set
bijections and classical design names are not sufficient.

### Pilot and stop

1. Certify one canonical decoration and intrinsic recovery map in each of the `5,14,22` fibres.
2. Compute the orbital/intersection algebras and test whether one Coxeter/root-length rule gives all
   three.
3. Separate support, orientation/chirality, subgroup embedding, and normalizer quotient so the
   fibre count is not ambiguous; in particular explain why the A3 count uses the order-24
   normalizer rather than the raw order-12 rotation group.

Stop if the construction is only `PGL_2(q)/N` in new notation, if the three decorations have no
common intrinsic definition, or if the H3 incidence is only the already classical biplane/Witt
geometry.  A positive result must include intrinsic recovery and at least one uniform intersection
formula not forced by transitivity alone.

## C405 — rational-normal-curve deepest-syndrome pilot

### Target

Test the first bounded extension of the C398 classification from conics in `PG(2,q)` to twisted
cubics in `PG(3,q)`: classify, in a rigorously field-bounded pilot, non-GRS codimension-four
projective MDS parents whose complete maximum-distance syndrome locus is nonempty and contained in
a rational normal curve, and determine when that locus is the full curve/GRS child.

This is a high-upside gate, not an asserted programme.  It should consume the existing twisted-
cubic, PRS deep-hole, evaluation-dichotomy, and apolar-transfer results without reopening their
closed scopes.

### Pilot and stop

1. Derive a field/length bound from secant-plane coverage before any classification census.
2. Choose the smallest nontrivial parent length/codimension for which the bound leaves a finite
   semilinear search, and run only that search.
3. Audit redundancy-four RS/PRS deep-hole classifications and twisted-code extension results before
   calling any survivor new.

Stop if no small field bound follows, if the quotient is not computationally bounded, if ordinary
GRS/PRS theory subsumes the locus, or if more than a small explicit exception list survives.  Do
not escalate to arbitrary rational normal curves, quadrics in higher dimension, or a general
variety-valued deep-hole conjecture from one pilot.

## Priority and manuscript boundary

Run C403 first, then C404, then C405.  C403 has the greatest chance to turn C399 into reusable
arrangement-code theory; C404 tests whether parent forgetting has geometry beyond group indices;
C405 is the high-upside falsifier for the larger variety-valued deep-hole programme.

At most one successor enters the Clebsch grand paper, and only if it is mathematically inseparable
from C399's proof.  Other positive outcomes are companions.  Negative outcomes remain exact
boundaries and do not diminish the C398--C399 flagship.
