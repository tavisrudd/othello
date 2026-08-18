# C910 — the order-by-order pairing equations from horizontality

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-epilogue/`.
**Date:** 2026-08-18.  **Authority commit:** `cd680f413`.
**Predecessors:** the framed-route and rank-two rigidity report
`2026-08-18-c910-framed-route-and-rank-two-rigidity.md` and the highest-risk
items report `2026-08-18-c910-highest-risk-items.md`.

The link between `lem:horiz` and `lem:A0preserve` is closed.  Until now the two
matrix equations that the rank-two argument consumes — self-adjointness of the
square-zero residue for the leading pairing coefficient, and the four-term
constant relation — entered Lean as hypotheses with no formal connection to
horizontality of the pairing.  They are now derived, as the first two
coefficients of the horizontality identity, from a formal-coefficient model of
the pairing that the package previously lacked.  The same model supplies the
order-by-order equations of `lem:orthogonal`, which were also hypotheses.

## The coefficient model

`Quantum/PairingHorizontality.lean` represents

  `D P(u) + A(u)ᵀ P(u) + P(u) A(-u) = 0`

coefficientwise, for a connection with a simple pole
`A(u) = u⁻¹ residue + regular 0 + u regular 1 + ⋯`, a pairing
`P(u) = pairing 0 + u pairing 1 + ⋯`, and a direction whose derivation acts on
the pairing coefficients by a supplied family `derivative`.  Substituting `-u`
in the right factor is what puts the residue there with the opposite sign and
multiplies the regular coefficient of order `m` by `(-1)^m`; that is the whole
arithmetic content of the sesquilinearity convention `ψ(s,t) = (s(u), t(-u))`.

Two factors are allowed to differ, so the same definition carries the pairing of
a factor with itself and the off-diagonal pairing between two factors of a local
splitting.  The loop direction is the specialization whose derivative family is
`order • pairing order`; a base direction is any family, and for a constant
pairing it is zero.

Index `0` is the coefficient of `u⁻¹` and index `order + 1` is the coefficient
of `u ^ order`, so the two equations of the manuscript proof are the
coefficients at `0` and at `1`.

## What is now derived

- The coefficient of `u⁻¹` vanishing is *exactly* `residueᵀ * pairing 0 =
  pairing 0 * residue`, the manuscript's self-adjointness of `N` for `P₀`.
- The coefficient of `u⁰` vanishing is *exactly*
  `(regular 0)ᵀ P₀ + P₀ (regular 0) + residueᵀ P₁ - P₁ residue = 0`, the
  manuscript's constant relation, for any direction whose derivation kills `P₀`;
  the loop direction qualifies because it multiplies `P₀` by zero.
- Chaining those into the rank-two rigidity algebra gives `lem:A0preserve`
  directly from horizontality: square-zero nonzero residue, invertible leading
  pairing coefficient, and vanishing of the first two loop coefficients imply
  `residue * regular 0 * residue = 0` and its vector form.
- For two factors whose residues have distinct scalar parts and nilpotent
  remainders, each coefficient equation is the Sylvester equation for one
  pairing coefficient with a remainder built from strictly earlier coefficients.
  The remainder vanishes once all earlier coefficients do, so the existing
  induction kills the whole pairing between the factors.  This is the derivation
  that `lem:orthogonal` was missing; its hypothesis on the direction is only
  that the derivation annihilates a vanishing coefficient.
- `lem:horiz` moved from absent to a fragment.  A pairing constant in the frame
  is horizontal — in the loop direction and in every direction whose derivation
  annihilates it — as soon as the residue is self-adjoint and the regular part
  is an anti-self-adjoint operator in degree zero with nothing above it.  That is
  the substitution the manuscript performs, with the Frobenius property of
  quantum multiplication and anti-self-adjointness of the grading operator as
  matrix hypotheses.  The claim map states plainly that this terminal carries no
  mathematical content beyond those hypotheses; the content of the manuscript
  lemma is the geometry that supplies them, which is not formalized.

Three reviewer terminals were added:
`quantumPairing_horizontality_of_selfAdjoint_multiplication`,
`atomicRankTwo_pairingEquations_of_loopHorizontality`, and
`separatedSpectralFactors_pairing_eq_zero_of_horizontality`.

## Coverage

Two rows moved.  `lem:horiz` went from absent to fragment; `lem:orthogonal` and
`lem:A0preserve` kept their coverage class and each gained a terminal, with the
"does not derive the order-by-order equations from horizontality" caution
removed from both.  The snapshot is 50 claims and 46 machinery rows over 189
terminals: 20 absent, 16 fragmentary, 13 conditional, 1 complete.

## Gates

All green at `cd680f413`.  The new module was elaborated singly, then built
through the guarded queue with `PaperInterface` and `Verification.AxiomAudit`
after it.  `make check` and the axiom-log check pass over 105 sources, and each
new terminal reports `propext, Classical.choice, Quot.sound`.  No manuscript
source was edited; the tracked PDF is unchanged at 49 pages.

## Scope

Lean constructs no `F`-bundle, spectral cover, connection, quantum product, or
Poincare pairing.  Horizontality is a property of matrix coefficient families,
not of a geometric connection, and the identification of those families with
the geometric objects is not formalized.  Nondegeneracy of the restriction of a
horizontal pairing to one factor is still stated as the determinant identity for
a block-diagonal matrix; assembling the factor pairings into one block matrix
and transporting nondegeneracy through that assembly is not done, and neither is
the parity refinement that gives nondegeneracy on the even part.

## Mystery ledger

- The equations need no nondegeneracy.  Both displayed equations are pure
  coefficient extraction; invertibility of `P₀` enters only in the rank-two
  conclusion, where it converts a vanishing scalar times `P₀ N` into a vanishing
  scalar.  Settled by this pass.
- Block diagonality is direction-independent.  The Sylvester induction uses the
  residues alone; the regular coefficients and the direction's derivation only
  enter the remainder, which vanishes for formal reasons.  So the same argument
  applies verbatim in every base direction, not only in the loop direction, and
  needs no relation between the two factors' regular parts.  Settled by this
  pass; it explains why the manuscript can choose any regular
  block-diagonalizing frame.
- The constant-order equation holds in any direction whose derivation kills the
  leading pairing coefficient.  The loop direction qualifies for an arithmetic
  reason — scaling multiplies the leading coefficient by zero — and a base
  direction qualifies whenever the pairing is constant.  Settled by this pass.
- Open: the even-part refinement of `lem:orthogonal`.  Nondegeneracy on the even
  part uses that the Poincare form pairs only equal parities, which needs a
  parity decomposition of the factor and the assembly of block pairings into one
  matrix.  Evidence gap: no parity model in the package.  Owner: a successor
  under the same claim row.
- Nothing else about the landed statements is unexplained.

## Next

From the gap audit, still open: `lem:disc` and `lem:spectrum-transfer`, the
missing unconditional half of `cor:v14-one-step`, terminals for `prop:no-curve`
and `prop:no-surface` sliced out of the atom-route exclusion, the even-part
refinement above, and the disposition of the orphaned machinery themes.

## Export status

Not exported.  The paper repository under `~/src/math-papers/` is behind the
authority.
