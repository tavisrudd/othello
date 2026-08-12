# C907 — Quantum-monodromy stabilization

**Lane:** `clebsch`

**Status:** active research.  `X x P^1` irrational is closed and imported into
C904's geometric epilogue.  Full stable irrationality is open.  No Paper V or
Lean promotion.

**Load next:** `c907-solver-dossier.md`.

**Execution plan:** `../2026-08-11-c907-moonshot-attack-plan.md`.

**Detailed closed work:**
`../2026-08-10-c907-quantum-monodromy-stabilization.md`.
Historical task-card state:
`c907-quantum-monodromy-stabilization-archive.md`.

## Goal

Prove, beginning with `m=2`, that

\[
X\times\mathbf P^m
\]

is irrational for every smooth cubic threefold `X`.  The full endpoint for all
`m` would settle stable irrationality.

## Closed inputs

- The cubic quantum connection has a rank-two formal block with exponents
  `+/-1/6` modulo integers.
- `X x P^m` has exactly `m+1` copies with unchanged fractional exponents.
- Points, curves, and surfaces have fractional exponents only `0` or `1/2`;
  hence `X x P^1` is irrational.
- Coarse atom multiplicity cannot work from `m=2`: explicit self-carrier
  balances reproduce the endpoint count.
- The surviving Tate polynomial is `1+T+...+T^m`.  Equivalently, the endpoint
  has enriched unipotent length `m+1`, while projective self-carriers have
  length at most `m-1`.
- Iritani's local Fourier lattice recovers the consecutive Tate levels, and
  the associated-graded formula passes transverse and nested two-blow-up
  exchanges.
- The full cubic hypergeometric module is irregular-Hodge and irreducible.
  Cai's rank-two atom is its local middle zero-exponential Stokes graded piece,
  not a global subobject.

## Active frontier: `m=2`

For the fivefold `X x P^2`, prove both:

1. **Analytic gate.**  The codimension-two blow-up comparison is strict on the
   cubic-isotypic Stokes/Rees filtration and compatible with the Gamma lattice
   and composition:
   \[
   gr_{1/6}A(Bl_ZY)=gr_{1/6}A(Y)\oplus T\,gr_{1/6}A(Z).
   \]
2. **Carrier gate.**  Every smooth projective threefold `Z` has
   cubic-isotypic enriched length `ell_(1/6)(Z) <= 1`.

The endpoint has length three; lower-dimensional centers have no cubic atom;
threefold centers have codimension two and contribute one shift.  These gates
therefore imply `X x P^2` irrational.

## Next bounded pass

Freeze the phase/mutation-invariant enriched cubic length.  Then run in
parallel: prove the nef-canonical exclusion with quintic/sextic hostile tests;
and specialize Iritani (5.28) to codimension two, extend the strict basepoint
comparison to first Novikov order, and compute the explicit
Stokes/mutation-system obstruction class.

A Fano-threefold database is reconnaissance only; weak factorization permits
arbitrary Calabi--Yau and general-type threefold centers.

## Gold architecture after `m=2`

To reach every `m`, prove:

- an intrinsic cubic-isotypic Stokes/Gamma Rees object;
- strict additive blow-up composition in every codimension;
- product compatibility by Thom--Sebastiani; and
- the universal carrier bound `width <= dim-3`.

The exact polynomial identities are already closed.  The remaining work is
analytic functoriality and the carrier theorem, not further finite
bookkeeping.

## Acceptance

- **Silver:** both `m=2` gates above, followed by a complete weak-factorization
  proof of `X x P^2` irrational.
- **Gold:** the all-codimension strict theory and universal carrier bound,
  proving irrationality for every `m`.
- **Negative progress:** an exact counterexample to either gate, with the
  minimum missing datum or corrected invariant identified.

## Boundaries

- Do not edit the frozen Paper V manuscript.  Only the closed `m=1` theorem
  belongs in its epilogue.
- Do not infer a universal theorem from finite computation.
- Do not start Lean work without separate authorization.
- Follow the literature-cache and reproducibility conventions for new source
  or computational claims.
- The queued one-step abstraction/Fano reconnaissance remains behind the
  active gold-architecture pass unless the author reorders it.
