# C910 — the Section 5 framed-germ rows in Lean

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-m1/`.
**Date:** 2026-08-18.  **Authority commits:** `1a7b649d3`, `092f4d29b`.
**Predecessor:** the local-chart pass
`2026-08-18-c910-local-chart-lift-and-unit-summand.md`, whose closing note named
the Section 5 framed rows as the cheapest genuine coverage left.

Three rows that were absent now carry terminals: formal-germ rigidity of an
isolated rank-two packet (`prop:ranktwo-framed-germ`), the multiplicity-one Euler
block lemma (`lem:simple-euler-block`), and formal-germ persistence of the cubic
packet (`cor:cubic-formal-germ`).  A fourth, the product formula for a product
with a projective space (`prop:projective-product-nu`), came with them from the
closeout pass.  Coverage moved from 10 absent, 21 fragmentary, 18 conditional to
6 absent, 23 fragmentary, 20 conditional over 233 reviewer terminals.

## Formal-germ rigidity of the rank-two packet

`Quantum/RankTwoClusterGermRigidity.lean` proves the manuscript's argument as
matrix algebra over a multivariate formal power-series ring, in the four steps
the human proof takes.

The regularity step is a commutant calculation.  A two-by-two matrix whose entry
in position `(0, 1)` is invertible has commutant `B·I ⊕ B·N` over any commutative
ring: reading the two upper entries of the commutation identity and dividing by
that unit produces the two coefficients.  No Jordan form is chosen and no
localization is needed, which is slightly more than the manuscript's phrasing —
it uses regularity of `U₀` over the local ring, and only invertibility of one
off-diagonal entry is consumed.

The trace step identifies the scalar coefficient with the derivative of the
eigenvalue.  Compressed flatness in a chosen frame reads
`(∂λ)·I + ∂N + [Γ, N] = pI + qN + q[N, grading]`; both commutator terms are
traceless and `N` is traceless, so twice the scalar parts agree, and `2` is
cancellable in a power-series ring over a characteristic-zero field.  Subtracting
leaves `∂N + [Γ, N] = qN + q[N, grading]`.

The determinant step is Jacobi's formula in rank two,
`∂ det M = trace M · trace(∂M) − trace(M ∂M)`, proved here by an entry
computation; in rank two the adjugate is `trace M · I − M`, which is why the
formula takes that shape.  Against a traceless `N` the two commutator terms have
vanishing trace, and `trace(N²) = (trace N)² − 2 det N`, so the evolution becomes
the logarithmic equation `∂ₐ d = 2 qₐ d` for `d = det N`.  The already formalized
power-series vanishing theorem — a series all of whose formal partial derivatives
are multiples of itself and whose constant coefficient vanishes is zero — then
gives `det N = 0`, and with vanishing trace the rank-two Cayley-Hamilton identity
gives `N² = 0`.  The unit entry keeps `N` nonzero, so the cluster stays a single
nonzero Jordan block over the whole germ.

The residue statement reuses the same trace calculus.  Modified flatness makes
each formal partial derivative of the residue a commutator with a regular matrix;
the trace of a commutator vanishes, and both terms of Jacobi's formula vanish for
a commutator, so the trace and the determinant are constant series and the
characteristic polynomial is the one attached to two scalars of the coefficient
field.

The cyclotomic consequence is separated from the germ: two blocks whose exponents
have the same monic split polynomial contribute the same framed primitive-sixth
multiplicity, because the exponent multiset is recovered from that polynomial as
its multiset of roots and framed monodromy attaches to each exponent the
eigenvalue of one turn of the unramified loop coordinate.

## The multiplicity-one Euler block

`Quantum/SimpleEulerBlock.lean` proves the three algebraic steps of the lemma.

On a rank-one block the compressed pairing is a single scalar, nonzero because
generalized eigenspaces of distinct eigenvalues of an operator self-adjoint for a
nondegenerate pairing are orthogonal.  Anti-self-adjointness of the grading
operator on that line then reads twice that scalar times the grading value, so
the grading value vanishes.

The gauge term of the order-`z` coefficient vanishes for a structural reason
rather than a computation: a projector that commutes with Euler multiplication
and annihilates the first gauge coefficient on both sides annihilates the
compression of their commutator.  Combining the two, the whole order-`z`
coefficient of the scalar block vanishes.

What is left is the scalar equation with no term of order `z`.  Removing the
irregular exponential factor leaves `v' = h·v`, and over a field of
characteristic zero that equation has exactly one formal power-series solution
with constant coefficient one.  Existence is the point: the solution is built
from its coefficient recursion `(n+1)vₙ₊₁ = Σ hᵢ vₙ₋ᵢ`, so the regular factor is
an ordinary power series in the original loop coordinate — no logarithm and no
fractional power — and the framed regular monodromy on the block is the identity.
A block whose framed monodromy is the identity has characteristic polynomial a
power of `X − 1`, and neither primitive sixth root is a root of it, so the block
contributes nothing to the count.

## Persistence of the cubic packet, and the product formula

`Applications/CubicFormalGermPacket.lean` assembles the corollary.  A point of
the germ carries a framed monodromy matrix and the exponent multiset of the
rank-two zero cluster; the premises are that the framed characteristic polynomial
splits at every point as the exponential polynomial of that cluster times the
unit power contributed by the rank-one clusters, that the exponent polynomial is
the same at every point as at the closed point, and that at the closed point the
framed characteristic polynomial is the displayed four-factor polynomial of the
cubic packet.  Multiplicity is additive over the factorization, the unit power
contributes nothing, and the closed-point value is the already proved value two,
so the multiplicity is two at every point.  The closed-point value is taken from
the packet terminal rather than assumed.

The closeout pass added the product formula as an exact deduction in
`Applications/ProjectiveProductMultiplicity.lean`.  Its premise is the conclusion
of the manuscript's Levelt--Turrittin computation for a product with a projective
space — that the framed characteristic polynomial of the product is the
`(m+1)`-st power of that of the base — which is exactly where the
multiplicity-one lemma is used, since the `m+1` rank-one blocks at the distinct
eigenvalues of quantum multiplication by the first Chern class must contribute
trivial framed regular monodromy.  From that premise the count multiplies by
`m+1`.  The formula had entered the two product corollaries as a raw typed
premise; it is now a Lean deduction from a strictly weaker one.

## Validation

All library targets and the axiom audit were built through the guarded queue.
`make check` and the axiom-log check pass over 120 sources and 233 reviewer
terminals; each new terminal reports `propext, Classical.choice, Quot.sound`.
The manuscript changed only in the coverage and terminal annotations of the four
statements, and the tracked PDF rebuilds byte-identically at 49 pages.

## Scope

Nothing geometric or analytic was added.  Lean constructs no quantum connection,
Euler operator, Poincare pairing, spectral projector, elementary modification, or
Levelt--Turrittin solution algebra.  The germ is a multivariate formal
power-series ring, not an analytic or rigid-analytic germ, and the corollary's
germ is an arbitrary type with a distinguished point, so the identification of
its supplied rigidity with the theorem proved over the power-series model is not
formalized.  The passage from residue eigenvalues to the exponents of framed
monodromy, and from the scalar equation to a framed monodromy matrix, remain
outside the terminals: both take the exponent data as given.  The remark that the
proposition proves the local mechanism behind Hypothesis 5.7R rather than the
hypothesis at a reconstruction value is unaffected — nothing here substitutes a
Laurent-Novikov reconstruction value into a formal bulk variable.

## Mystery ledger

- Settled by this pass: the manuscript's separation hypothesis on the other Euler
  eigenvalues does not enter the rigidity argument at all.  It is consumed
  entirely upstream, in the existence of the formal spectral projector, which
  Lean does not construct; every step after the compression uses only the two
  compressed identities.  That locates the exact seam of the fragment.
- Settled by this pass: the grading operator plays no role in persistence.  The
  rigidity terminal holds for an arbitrary matrix in that slot, because both
  commutator terms die against a traceless `N` under the trace.  Only the
  commutator shape of the evolution matters, not what it is a commutator with.
- Settled by this pass: the manuscript's "lowest-homogeneous-term argument" for
  `d = 0` needs no new machinery.  It is the power-series vanishing theorem
  already in the package, applied to the determinant with logarithmic derivative
  `2q`.
- Open, and small: the rigidity terminal is stated over a characteristic-zero
  field only because `2` must be cancellable and the vanishing theorem wants a
  domain; a characteristic-zero domain would do.  Evidence gap: none — the
  generalization is available and unused, since the manuscript's coefficient ring
  is a field.  Owner: none allocated; it changes no manuscript claim.
- Open: the order-`z` vanishing and the normalized solution are proved as
  separate statements and joined only in prose.  Bridging them requires modelling
  the irregular factor `exp(-u/z)` and the substitution that removes it, which
  needs a Laurent or twisted module the package does not have.  Evidence gap: no
  formal object carrying the scalar equation `z²y' = (u + z²h)y` itself.  Owner:
  the same successor that would formalize Levelt--Turrittin.
- Open: `prop:direct-specialized-lowdim`, the last consumer of the
  multiplicity-one lemma, remains absent.  Its three cases need the `g`-filtration
  weight calculation, nilpotency of the residue, and the parity correction, which
  is a genuine piece of work rather than a composition of formalized algebra.
  Owner: a successor in this lane.

## Next

The remaining absent rows are the four separation corollaries
(`cor:voisin-separation`, `cor:fermat-separation`, `cor:coprime-separation`,
`prop:A5-nonseparated`), `lem:exact-low-degree-shifts`, and
`prop:direct-specialized-lowdim`.  The separation corollaries are the cycle-side
cluster and depend on the relative six-axis geometry rather than on more quantum
algebra; `prop:direct-specialized-lowdim` is the one remaining row whose proof is
self-contained algebra plus a filtration argument, and is the cheapest of the six.

## Export status

Exported.  The standalone paper repository
`~/src/math-papers/cubic-stabilization-m1` was synchronized from authority
`092f4d29b` with a zero-finding coupling audit, and its own `make check`, pinned
Lean build, and axiom-log replay agree with the authority over 233 reviewer
terminals.
