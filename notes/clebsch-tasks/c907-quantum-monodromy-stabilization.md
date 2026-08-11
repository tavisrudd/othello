# C907 — Quantum-monodromy stabilization test

**Lane:** `clebsch`

**Status:** active; exploratory research only; no Paper V or Lean promotion

**AA checkpoint:** the low-dimensional-carrier branch is positive.  KKPYY
Claim 6.15 forces every nef-canonical surface block to have fractional
exponents only `0` or `1/2`; ruled/rational surfaces reduce through
projective bundles and point blow-ups to curves and points with the same
restriction.  Since fourfold weak-factorization centers have dimension at
most two, the cubic `+/-1/6` block proves that `X x P^1` is irrational for
every smooth cubic threefold.  Full stable irrationality remains open from
`m=2`, where cubic self-carrier centers enter.  A source-level audit also
demotes the prime-power spectral-cycle idea: KKPYY's decomposition is local on
analytic germs and does not retain the global loop, while iterated rank-`p`
projective bundles give dimension-admissible local-copy/wreath counterpatterns.
The recursive gate has a sharp conditional numerical form: Serre dimension
`m+5/3` exceeds the center bound `m+1`, but the ordinary projective-bundle
decomposition splits this into `m+1` distributable copies.  Exploiting the gap
requires both a gluing-sensitive enhanced atom and a restricted fractional-CY
carrier theorem; general Serre-dimension monotonicity is false.  These are the
remaining live gates together with the integer/Tate-filtered atom.  The latter
now has a basis-independent exact form: the endpoint Beilinson Euler lattice
has one unipotent Serre block of length `m+1`, while every projective
self-carrier has length `m-1`.  A Γ-integral, Stokes-filtered blow-up theorem
preserving cubic-isotypic Serre width would turn this uniform gap two into the
full stable obstruction.  Iritani Theorem 1.1 preserves the formal connection
and Poincaré pairing, but Remark 1.5 explicitly places the non-orthogonal
Stokes/Γ gluing beyond that formal direct sum; the missing theorem is therefore
confirmed at source rather than inferred from the computation.

## Goal

Test whether Cai's formal-monodromy obstruction for cubic threefolds can be
made stable under products with projective spaces and therefore developed into
a stable-irrationality obstruction.  The computational work is classical and
exact; "quantum" refers to quantum cohomology.

## Scope

1. Reconstruct the cubic-threefold small quantum connection from the published
   formulas and certify its rank-two formal block and exponents
   `+1/6, -1/6` modulo integers.
2. Derive and certify the product connection for `X x P^m`, first for bounded
   `m` and then symbolically where the tensor/product formula permits it.
3. Encode the projective-bundle and blow-up decompositions used by the
   Hodge/quantum-atom formalism and search exact bounded instances for
   cancellation or reproduction of the cubic atom by admissible centers.
4. State the strongest surviving general cancellation lemma, or exhibit the
   first exact counterpattern.  A bounded search is evidence only on its stated
   range and is never promoted to a universal theorem.

## Evidence bundle

The first durable bundle will use the common stem
`notes/2026-08-10-c907-quantum-monodromy-stabilization` and contain:

- a dated mathematical report;
- an exact Sage generator/checker;
- a compact canonical JSON certificate;
- checksums and byte counts;
- an independent symbolic replay when feasible.

Every claim backed by computation must record its replay command, exact input
formulas and conventions, dependency versions, trusted boundary, and negative
search stop condition under `notes/research-reproducibility-conventions.md`.

## Acceptance gates

- The `+/-1/6` certificate is reproduced exactly from source formulas, not
  copied as an asserted input.
- Stabilization is checked in at least two independent ways on a nontrivial
  bounded range and reduced to an explicit general formula if possible.
- Blow-up-center cancellation tests distinguish formal identities from
  geometric realizability and state all dimension bounds.
- The closeout gives a precise verdict: stable obstruction proved, a named
  missing theorem isolated, or the proposed invariant refuted by a certified
  counterpattern.
- Run the required `ej` and `tt` closeout and maintain a Mystery ledger before
  completing the task.

## Boundaries

- Do not edit the frozen Paper V manuscript.
- Do not claim stable irrationality from finite computation.
- Do not start Lean work without a separately authorized formalization task.
- Literature and formulas are read from the shared cache first; any newly
  fetched source is added to that cache.
