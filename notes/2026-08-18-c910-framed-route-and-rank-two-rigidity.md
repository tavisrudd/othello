# C910 — the framed route end to end and the rank-two rigidity algebra

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-m1/`.
**Date:** 2026-08-18.  **Authority commit:** `2d187bc43`.
**Predecessors:** the gap audit `2026-08-18-c910-post-restructure-gap-audit.md`
(priorities 0b and 0d), the block-reduction report
`2026-08-18-c910-block-reduction.md`, and the hearts and product-corollary
report `2026-08-18-c910-hearts-and-product-corollaries.md`.

Two pieces landed: the framed-monodromy route to one-step irrationality is now
assembled on the product-formula signature, and the rank-two algebra behind the
atomic route is kernel checked.

## The framed route on the product-formula signature

The earlier assembly of `thm:every-cubic-conditional` assumed three numerical
facts outright: that the cubic threefold has framed count two, that the count
doubles on multiplication by a projective line, and that the count vanishes on
projective four-space.  All three are now proved, in
`Applications/CubicFramedOneStep.lean`, from the product-formula premises landed
earlier in the day.  What remains supplied is the product formula itself,
involutivity of the framed monodromy of a point, the passage from the exponents
of the reduced small even system to framed formal monodromy, the birational
input carrying weak factorization with vanishing center contributions, the
dimension bound on the stabilized fourfold, and the birational comparison that
rationality provides.

The bridge is a packet-data instance built from the framed sixth-root count and
a supplied dimension function, so the existing telescope in
`Quantum/BirationalDeduction.lean` applies unchanged.

## The rank-two rigidity algebra

`Quantum/RankTwoResidueRigidity.lean` formalizes the matrix algebra of the
atomic route's rank-two step.

- Rank-two Cayley-Hamilton, and the consequence that over a field a square-zero
  two-by-two matrix has vanishing trace and determinant.
- The sandwich identity `N * A * N = trace (A * N) • N` for any `A` whenever `N`
  is square-zero.  It holds whenever `N` has vanishing determinant, and it is
  what makes the rank-two argument purely scalar.
- `lem:A0preserve`.  From self-adjointness of the square-zero part `N` for the
  invertible leading pairing coefficient and the constant coefficient of
  horizontality, Lean proves `N * A₀ * N = 0`, equivalently that the regular
  coefficient carries the image of `N` back into its kernel.  The proof is the
  manuscript's: sandwiching the horizontality equation between two copies of
  `Nᵀ` and `N` kills the two terms containing `P₁`, the surviving terms make the
  scalar `trace (A₀ * N)` both self-adjoint and anti-self-adjoint for an
  invertible pairing, and so that scalar is zero.
- The pole step of `prop:rank2-rigidity`.  In the adapted frame the only
  possible pole of the base connection after the modification is a multiple of
  the lower-left matrix unit, and the order minus-one coefficient of flatness
  forces that multiple to vanish because the upper-right entry of the residue is
  the unit coming from `N`.
- The rigidity conclusion.  Modelling a base derivation as an additive map of
  the coefficient ring satisfying the Leibniz rule, applied entrywise to a
  matrix, Lean proves that if the derivation carries the residue to its
  commutator with a regular matrix then it annihilates the residue discriminant.
  The proof goes through the trace form `2 trace(R²) - (trace R)²` of the
  discriminant, which is the identity that makes both pieces visibly
  conjugation-invariant.
- The second assertion of `prop:residue-discriminant-exponents`: the
  discriminant is the squared separation of the residue eigenvalues, and is
  unchanged by a scalar shift of the residue.

## Coverage

Four rows moved.  `thm:every-cubic-conditional` gained the assembled framed
route as a third terminal.  `lem:A0preserve` went from absent to a conditional
deduction; `prop:rank2-rigidity` and `prop:residue-discriminant-exponents` went
from absent to fragments.  The coverage snapshot is now 50 claims and 46
machinery rows over 184 terminals: 22 absent, 14 fragmentary, 13 conditional,
1 complete.

## Gates

All green at `2d187bc43`.  Each new module was elaborated singly, then built
through the guarded queue with `PaperInterface` and `Verification.AxiomAudit`
after it.  `make check` and the axiom-log check pass over 102 sources, and every
new terminal reports `propext, Classical.choice, Quot.sound`.  The manuscript
was not edited, so the tracked PDF is unchanged at 49 pages.

## Scope of the rank-two formalization

Three restrictions are worth stating plainly.  Lean does not construct the
`A`-model `F`-bundle, the spectral cover, the atomic factor, the Poincare
pairing, or the elementary modification, so the horizontality coefficients enter
as hypotheses on matrices.  The commutant computation identifying the leading
base coefficient as a multiple of `N` is not formalized, so the pole step
assumes the pole's shape rather than deriving it.  And the completed-local-ring
argument that upgrades a vanishing derivative to local constancy on a chart is
not formalized; Lean proves the derivative vanishes.

## Mystery ledger

- The sandwich identity needs only vanishing determinant, not square-zero.  That
  is why the rank-two argument reduces to one scalar: any rank-at-most-one
  leading operator would do, and the square-zero condition is used only to kill
  the `P₁` terms and to make the image and kernel the same line.  Settled by
  this pass; no open question.
- The rigidity proof needs no hypothesis on the base at all.  Constancy of the
  discriminant is a statement about a single derivation, so the manuscript's
  restriction to a smooth rigid chart is used only for the final step from
  vanishing derivatives to constancy.  This is why that last step, and not the
  Lax equation, is the piece left unformalized.
- Still open and owned by a successor: `lem:orthogonal`, whose content is
  invertibility of a Sylvester operator with separated leading eigenvalues,
  followed by an induction over the pairing coefficients.  The operator is
  a scalar plus a nilpotent endomorphism of the matrix space, so the algebra is
  standard; the induction needs a formal-series model of the pairing that this
  package does not yet have.
- `lem:horiz` remains absent, and there is a reason not to force a terminal for
  it.  At the level of matrices its content is the substitution of
  self-adjointness of quantum multiplication and anti-self-adjointness of the
  grading into the connection formula, which is an identity with no work in it
  once both are hypotheses.  Its mathematical content is the Frobenius property
  of quantum multiplication, which is geometry this package does not construct.
- Nothing else about the landed statements is unexplained.

## Next

From the gap audit, still open: `lem:disc` and `lem:spectrum-transfer`, the
missing unconditional half of `cor:v14-one-step`, `lem:orthogonal` and the
pairing induction, the order comparison that selects the exotic gluing in
`prop:principal-gluing-packet`, terminals for `prop:no-curve` and
`prop:no-surface` sliced out of the atom-route exclusion, and the disposition of
the four orphaned machinery themes.

## Export status

Not exported.  The paper repository under `~/src/math-papers/` is now six
commits behind the authority.
