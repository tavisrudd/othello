# Frobenius-equivariant pair extension and robust repair of eight-arcs

**Title:** *Frobenius-equivariant pair extension and robust repair of
eight-arcs.*

## Headline

The paper studies arcs invariant under a quadratic Frobenius involution. It
proves an exact orbit-valued criterion for adjoining conjugate pairs, identifies
the invisible-center and collision corrections that make the count exact, and
turns the count into a robust orbit-replacement theorem.

Every invariant eight-arc in $\operatorname{PG}(2,25)$ has at least four
distinct legal conjugate pairs. In the two-fixed-point profile the exact minimum
is $32$; after normalization, equality is represented by five residual-group
orbits of sizes $200,400,400,200,400$. More generally, the certified profile
envelope gives at least $318$ alternate repairs after a selected orbit is
deleted, and the parameterized $(k+2)\to k$ theorem gives the corresponding
puncture-and-re-extend bound.

Under the arc--code correspondence these are Frobenius-compatible paired
two-column extensions and replacements of dimension-three MDS codes. The paper
remains finite-geometric in method: ``repair'' changes the generator-column
configuration rather than decoding an erasure in a fixed code.

The Clebsch specialization is secondary. After scalar extension to
$\operatorname{GF}(121)$, every $\operatorname{GF}(11)$-rational six-arc has
$4180$ legal paired extensions and $4179$ alternate repairs after one is
selected. This is a corollary of the general carrier count, not a separate
Clebsch theorem.

## Evidence and status

The quadratic criterion, semantic global count, collision correction, and
robust exchange theorem have human-scale Lean support.  The normalized finite
step in the $\operatorname{PG}(2,25)$ classification is pinned to a separate
Mathlib-only certificate package; the two projective normalizations and
semantic transport remain manuscript arguments.  The certificate's generic
and row-specific trust surfaces, the classical projective-geometry inputs, and
the bounded priority boundary are stated explicitly.

The directory contains the focused LaTeX manuscript, bibliography, PDF, and
verification surface. It is a staged paper release; publication identifiers,
final export choices, and submission remain author decisions.
