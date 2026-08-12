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
- KKPYY Claim 6.15 is dimension-free: every smooth nef-canonical projective
  variety has formal residue classes only `0` and `1/2`.  Thus every smooth
  nef-canonical threefold, including quintic and sextic hypersurfaces, has
  empty formal cubic packet; its identification with the enriched carrier
  invariant remains part of the analytic realization gate.
- For codimension two, Iritani (5.28) gives an exact basepoint matrix whose
  `t`-adic then exceptional-first associated graded is `I_Y \oplus I_Z`.
- The exact toric pilot `Bl_(P^3)P^5` has six ambient and four escaping
  critical values; after affine rescaling, the latter are the `P^3` mirror
  spectrum.  This closes the formal spectrum check, not the residual
  four-thimble Stokes cocycle.
- Its projective-bundle exceptional collection mutates explicitly into the
  `P^3` residual plus `P^5` ambient Orlov blocks.  Hence no finite Euler-lattice
  obstruction remains; the escaping-thimble identification is still open.

## Active frontier: `m=2`

The ordinary KKPYY carrier-height route is exhausted: the abstract cubic
`G`-atom already has the threefold carrier `X`, exactly the maximum center
dimension for a fivefold factorization.  The enriched length must first be
defined on geometric atomic `F`-bundles, pulled back along KKPYY Proposition
5.22 to abstract `G`-atoms, and proved invariant under the elementary
equivalences.  Ordinary atom multiplicity cannot distinguish the endpoint.

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

Freeze the phase/mutation-compatible Gamma/Rees realization of the cubic
length.  In parallel, compute the order-zero residual-center Stokes cocycle
for `Bl_(P^3)P^5` in the Orlov Gamma basis, and attack the non-nef threefold
carrier bound.  First-Novikov differentiation follows only after the
order-zero residual-center identification passes.

A Fano-threefold database is reconnaissance only; weak factorization permits
arbitrary Calabi--Yau and general-type threefold centers.

Exact pilot and replay:
`../2026-08-11-c907-toric-r2-pilot.md`.
Finite mutation audit:
`../2026-08-11-c907-double-presentation-mutation-audit.md`.

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
