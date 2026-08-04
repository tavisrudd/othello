# C855 — eliminating the two Dye axioms: Lean formalization plan

**Date:** 2026-08-04
**Lane:** `clebsch` (Paper I stream)
**Task:** C855, checklist item "Eliminate the two ad hoc Dye axioms ... formalize the required Dye
results from definitions in the Paper I closure".

The mathematics is already proved on paper in `notes/2026-08-03-c855-structural-exclusions.md`
(the bound, for every odd order) and `notes/2026-08-03-c855-dye-orbit-uniqueness.md` (the equality
classification, for every field of odd characteristic). This plan records how those proofs map onto
the existing Paper I Lean API, and in what order the pieces land.

## Target statements

Both axioms live in `lean/RelativeConicArcs/Q11DyeAxioms.lean`, in namespace
`RelativeConicArcs.ClebschDye`, and both are consumed by `Q11DyeConsequences` and
`Q11RigiditySpine`, which the gate `RelativeConicArcs.Gates.ClebschRigidityTrust` imports. The
statements stay byte-identical so no consumer changes; only `axiom` becomes `theorem`.

```
dye1991_brianchon_bound : Arc A → A.card = 6 → (brianchonPoints A).card ≤ 10
dye1991_equality_classification : Arc A → A.card = 6 → (brianchonPoints A).card = 10 →
  IsClebschHexagon A
```

Here `brianchonPoints A` is the off-arc points meeting exactly three secants of `A`, and
`IsClebschHexagon A` is projective equivalence to the displayed witness `clebschWitness`.

## Available API this builds on

- `RelativeConicArcs.Arc`, `Secant`, `secants`, `pointIndex` in `Arc.lean`, stated for any
  projective plane in Mathlib's `Configuration.ProjectivePlane` vocabulary.
- `RelativeConicArcs.ProjectiveBridge` in `ProjectiveBridge.lean`: points and dual lines are both
  `Projectivization K (Fin 3 → K)`, incidence is orthogonality, and incidence collinearity agrees
  with the projectivization predicate.
- `RelativeConicArcs.ProjectiveTripleNormalization.exists_mapEquiv_ordered_triple`: ordered
  projective transitivity on noncollinear triples, recording the three images pointwise.
- `ProjectiveCap.Projective.quad_normal_form`: the four-point normal form, which is what the landed
  route actually uses for the quadrangle step.

## Step 1 — the secant count of a six-arc

For an arc, distinct pairs span distinct lines, so a six-arc has exactly fifteen secants. Pure
incidence geometry, using the unique-line axiom; no coordinates.

## Step 2 — the chord pairing at a Brianchon point

For an arc `A` and a point `x` off `A`, every secant through `x` meets `A` in exactly two points,
and two distinct secants through `x` meet `A` in disjoint pairs — a shared point together with `x`
would determine both lines. So the secants through `x` induce a partial matching on `A`, and when
`A` has six points and `x` lies on three secants the matching is perfect. This is the whole content
of the one-factor dictionary, and it needs no coordinates either.

## Step 3 — the Fano bound, the one genuinely geometric input

Fix a secant `l` of a six-arc `A`, meeting `A` in `u, v`. A Brianchon point on `l` lies on `l`
itself plus two further secants, which must pair up the four remaining points, so it is a diagonal
point of the complete quadrangle `A \ {u,v}`. Distinct Brianchon points on `l` realize distinct
pairings, since two points sharing a pairing would force two chords to coincide and put four arc
points on a line. A quadrangle has three pairings, and in odd characteristic its three diagonal
points are not collinear, so at most two Brianchon points lie on `l`.

The non-collinearity is the classical Fano statement. Two candidate routes, to be settled by
whichever elaborates more cheaply:

- *Normalization.* Send three quadrangle vertices to the standard triangle with the ordered-triple
  transitivity theorem; the fourth is `(p : q : r)` with `pqr ≠ 0`; the three diagonal points are
  `(p:q:0)`, `(p:0:r)`, `(0:q:r)`, whose determinant is `-2pqr`.
- *Identity.* Express each diagonal point as a cross product of cross products and prove the
  polynomial identity that the determinant of the three equals a fixed nonzero multiple of
  `det(a,b,c) det(a,b,d) det(a,c,d) det(b,c,d)`, with the factor two making it vanish exactly in
  characteristic two.

## Step 4 — the bound

Count incidences between the fifteen secants and the Brianchon points in two ways. Each Brianchon
point lies on exactly three secants, and each secant carries at most two Brianchon points by step 3,
so `3 |B| ≤ 30` and `|B| ≤ 10`. This is the first axiom, and it holds for every arc in a plane over
a field of odd characteristic, not only at order eleven.

## Step 5 — the equality structure

Equality forces every secant to carry exactly two Brianchon points, so the five non-concurrent
one-factors partition the fifteen chords: they form a one-factorization. This is the combinatorial
half of the classification and is finite once the dictionary of step 2 is in place.

## Step 6 — double perspective implies triple perspective

Two disjoint concurrent one-factors force the third one-factor of their synthetic triangle to be
concurrent. In coordinates, with the first triangle standard and the first centre `(1:1:1)`, the two
concurrence determinants are `xyz - 1` and `1 - xyz`, so each condition implies the other. Three
cross products and two determinants; the argument is field-generic.

## Step 7 — the golden normal form and the orbit

Transitivity makes concurrence an equivalence relation on the six one-factorizations, and the
equality case is the partition into a five-element and a one-element class. Normalizing as in step 6
reduces the ten concurrence conditions to `x = y`, `x + z = 2`, `xyz = 1`, hence
`(x - 1)(x² - x - 1) = 0`; the root `x = 1` is excluded because it collapses the arc. So the
configuration is projectively the golden hexagon, and at order eleven, where the golden roots are
four and eight, its equivalence with `clebschWitness` is a finite check. That is the second axiom.

## Lean shape of the classification steps

Steps 5 to 7 need a labelling and some finite combinatorics, and the following shape keeps both
small.

Label the arc by a bijection from a six-element index type, obtained from its cardinality. The
fifteen chords are then the two-element index subsets, and the fifteen perfect matchings of the
index set are explicit finite data, as are the six one-factorizations; every statement about them
is decidable, so the combinatorial bookkeeping can be discharged by evaluation rather than by
developing a theory of one-factorizations.

Call a matching *concurrent* when its three chords share a point. The chord-pairing map already
proved for triple-concurrence points sends each such point to a concurrent matching, and it is
injective because two of them sharing a matching would put two distinct chords through two distinct
points. It is surjective by definition, so the number of concurrent matchings is the number of
triple-concurrence points, and the equality case says exactly that ten of the fifteen matchings are
concurrent.

The double-perspective identity is the only further geometric input: if two disjoint matchings are
concurrent then so is the third matching disjoint from neither, which in frame coordinates is the
statement that the two concurrence determinants are negatives of each other. With the
frame-coordinate determinant criterion in place this is a computation on three explicit coordinate
triples.

That identity makes concurrence transitive on the six one-factorizations, so the concurrent
matchings form a disjoint union of complete graphs on them, with no perfect matching by the
quadrangle result. Which partitions of six can occur is then a finite check: the class sizes must
sum to six, at least one must be odd, and the number of concurrent matchings is the sum of the
binomial coefficients of the sizes. Ten forces five plus one, and the five non-concurrent matchings
are the one-factorization indexed by the singleton class.

Fixing a hexagonal ordering compatible with that partition puts the arc in the frame of step 7, and
at order eleven the identification of the golden normal form with the displayed witness is a single
explicit projectivity, checkable by evaluation.

## Order of work and validation

Steps 1, 2, 4, and 5 are incidence and counting arguments and land first. Step 3 is the geometric
crux and gates step 4's final form. Steps 6 and 7 are the classification and land last.

Each landed module is elaborated singly through the guarded entry point; the focused gate
`RelativeConicArcs.Gates.ClebschRigidityTrust` and its axiom audit run only in a build window, and
the axiom audit is the acceptance evidence: after the replacement, neither Dye name may appear in
any terminal's axiom set.

## What changes outside Lean when this lands

The manuscript's Dye citation block becomes an attribution rather than a dependency, which the
approved C855 manuscript triage already anticipates. The trust registry entries for the two Dye
axioms in `lean/trust/areas/relconic.toml` are then deleted rather than re-anchored, and the
build-system audit recorded in `notes/2026-08-04-c864-dye-audit-and-anchor-review.md` is superseded
on exactly that point.
