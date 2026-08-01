# C754 — Lean formalization of the Golden proof spine

**Lane:** `golden`

**Status:** complete

## Objective

Formalize the reusable algebraic core of the Golden proof spine in Lean while
keeping the trust boundary exact.  The formal development must distinguish
kernel-checked polynomial and linear-algebra statements from imported
representation theory, invariant theory, and Luna-slice geometry.

## Work packages

1. Define the five noncrossing matching cubics on six labelled coordinates.
   Prove translation invariance, cubic scaling, affine covariance, and the
   exact representative three-plus-three collision value: four zero
   coordinates and the rainbow cube.
2. Define their explicit Jacobian and ordered four-by-four minors.  Prove the
   three generator-level off-node identities used for collision types
   `4+1+1`, `4+2`, and `5+1`, using symbolic kernel proofs rather than imported
   computer-algebra output.
3. Formalize the matching evaluation of an alternating matrix and connect the
   commutator Pfaffian to the matching cubics.  Keep any finite order-six sign
   normalization in small, auditable leaves.
4. Formalize the reusable corank-one adjugate/cofactor factorization to the
   strongest natural algebraic hypotheses supported by Mathlib.
5. Provide theorem interfaces that state exactly what remains imported for
   the Specht-module identification, scheme saturation, and Luna-slice
   passage.  Do not represent those imports as kernel-checked conclusions.

## Validation

Each source module must pass `lean/scripts/guarded-lean`.  The terminal module
will receive a Golden-owned import gate and an axiom audit after the leaves
are stable.  Referee-facing prose and names must contain only mathematical
content and the explicit verification boundary.

## Manuscript boundary

Do not edit the Golden manuscript during formalization.  The later compression
pass must preserve the Milnor--Serre conceptual route and explanatory geometry;
it may remove repetition and bookkeeping, not mathematical motivation.
