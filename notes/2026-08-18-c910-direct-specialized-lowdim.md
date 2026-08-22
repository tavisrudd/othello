# C910 — direct specialized low-dimensional vanishing in Lean

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-m1/`.
**Date:** 2026-08-18.  **Authority commits:** `cbbdfefc9`, `e9e9c4d28`.
**Predecessor:** the framed-germ pass `2026-08-18-c910-framed-germ-rows.md`,
whose closing note named this row as the last absent row whose proof is
self-contained algebra.

`prop:direct-specialized-lowdim` is now a conditional deduction.  Coverage moved
from 6 absent, 23 fragmentary, 20 conditional over 233 reviewer terminals to
5 absent, 23 fragmentary, 21 conditional over 241.  The five remaining absent
rows are the four separation corollaries of the cycle side and
`lem:exact-low-degree-shifts`.

## The nef-canonical case

`Quantum/ParityCorrectedUnipotentMonodromy.lean` proves the three steps of the
manuscript's spectral argument, all as complex matrix algebra.

The grading operator enters only through the integers it assigns to a basis: a
weight function on the index type of a matrix.  A matrix *raises the weight* when
every nonzero entry sits in a row whose weight exceeds its column's by at least
one.  Weight-raising matrices are closed under sums, so the residue is
weight-raising once each coefficient of Euler multiplication in an effective
class of vanishing first Chern number is, and the same closure covers the grouped
summands a noninjective specialization produces — the case the manuscript
flags in one sentence after the gauge computation.  The `k`-th power of a
weight-raising matrix moves the weight up by at least `k` in every nonzero entry,
by induction through the matrix product, so on a finite index type the matrix is
nilpotent: the spread of finitely many integer weights is bounded, and the power
one above that spread has no nonzero entry.

Nilpotence of the residue gives unipotence of the regular monodromy by an
argument Mathlib does not carry.  If `N ^ k = 0`, the exponential series has only
its first `k` terms, that finite sum is `1 + N * S` with `S` a polynomial in `N`,
and a product of commuting factors one of which is nilpotent is nilpotent.  So
`exp N - 1` is nilpotent for every nilpotent complex matrix `N`.

Undoing the half-parity correction multiplies by an operator whose square is the
identity, because the parity operator has integral eigenvalues.  If that operator
commutes with the regular monodromy — the manuscript's observation that the
transformed residue preserves parity — then the square of the framed monodromy is
the square of the unipotent factor, which differs from the identity by a
nilpotent matrix.  An eigenvector for a characteristic root `λ` is then an
eigenvector of that nilpotent difference for `λ ^ 2 - 1`, and an eigenvalue of a
nilpotent operator vanishes, so `λ ^ 2 = 1`.  Neither primitive sixth root has
square one, so the count vanishes.

## The projective line and plane

`Quantum/ProjectiveSpaceEulerSpectrum.lean` supplies the separability
calculation.  The specialized small quantum relation makes the characteristic
polynomial of Euler multiplication `X ^ (m + 1) - a`, and strict Novikov
admissibility keeps `a` nonzero, so the polynomial is separable.  Two
consequences are recorded: every root is simple, hence — through the
identification of algebraic multiplicity with the dimension of the maximal
generalized eigenspace — every spectral block of Euler multiplication has rank at
most one; and over the complex numbers the polynomial has exactly `m + 1`
distinct roots, which are the manuscript's displayed eigenvalues up to the
scaling by `m + 1`.

`Applications/DirectSpecializedVanishing.lean` closes the case.  Its premise is
the conclusion of the multiplicity-one Euler block lemma in the form actually
used: if every generalized eigenspace has dimension at most one, the framed
monodromy is the identity.  Lean proves the hypothesis of that implication and
concludes that a characteristic polynomial which is a power of `X - 1`
contributes nothing.

## The ruled surface over a curve of positive genus

The same module assembles the third clause twice.  The plain form takes the
intrinsic projective-bundle formula, vanishing for the base curve, and equality
of the specialized and intrinsic framed characteristic polynomials — the
manuscript's identification of the two one-variable modules after scalar
extension to a common algebraically closed overfield — and concludes vanishing.
The composite form replaces the base curve's vanishing by its proof: the
canonical class of a curve of positive genus is nef, so the spectral argument of
the first clause applies to it, and the reviewer terminal is stated with the
base's weight, parity, and residue data in place.

## Validation

The three new modules, the reviewer interface, and the axiom audit were built
through the guarded queue.  `make check` and the axiom-log check pass over 123
sources and 241 reviewer terminals; each new terminal reports `propext,
Classical.choice, Quot.sound`.  The manuscript changed only in the coverage and
terminal annotations of this proposition, and the tracked PDF rebuilds
byte-identically at 49 pages.

## Scope

Lean constructs no target variety, quantum connection, Euler multiplication,
grading operator, Novikov specialization, or Levelt--Turrittin decomposition.
The factorization of the framed monodromy as a parity correction times the
exponential of `2πi` times a weight-raising residue is a hypothesis, as is the
characteristic polynomial of Euler multiplication for a projective space, the
conclusion of the multiplicity-one Euler block lemma, the projective-bundle
formula, and the identification of the specialized ruled-surface module with the
intrinsic one.  Strict Novikov admissibility appears formally only through
nonvanishing of the line coefficient in the projective cases.

## Mystery ledger

- Settled by this pass: the manuscript's remark that a noninjective `χ` grouping
  several numerical classes changes nothing needs no separate argument.  It is
  closure of the weight-raising condition under finite sums, which the residue
  already requires, and it is now a reviewer terminal.
- Settled by this pass, negatively: `lem:exact-low-degree-shifts` cannot be
  closed by re-pointing the existing string-gauge and divisor-substitution
  terminals at it.  Those sit in the machinery bucket with a recorded reason
  saying the manuscript now proves the string and divisor shifts directly from
  the String and Divisor Equations, so its lemma is not the finite-level matrix
  packet Lean holds.  Closing that row needs the quantum connection and those two
  equations, not a bookkeeping change.
- Settled by this pass: nefness of the canonical class enters the first clause
  only through `m_β ≥ 1`, and strict Novikov admissibility does not enter it at
  all.  The Lean statement makes both visible, since its only hypothesis on the
  residue is that it raises the weight and its only hypothesis on the
  specialization is none.  The manuscript says the second of these in a closing
  sentence; the formal statement is where the first becomes checkable.
- Open: the identification of a geometric framed monodromy with a parity
  correction times the exponential of `2πi` times the residue.  This is the
  regular-singular normal form together with the passage from residue to
  monodromy, the same seam left open by the block-reduction and framed-germ
  passes.  Evidence gap: no formal object carrying the `z`-connection or its
  Levelt--Turrittin decomposition.  Owner: the successor that formalizes that
  decomposition.
- Open: the projective case still consumes the multiplicity-one Euler block
  lemma as an implication rather than applying it block by block.  Bridging it
  needs a spectral decomposition of the framed monodromy indexed by the
  eigenvalues of Euler multiplication, which the package does not have.  Evidence
  gap: no formal block decomposition of a framed monodromy matrix.  Owner: the
  same successor.
- Open, and geometric: the ruled-surface clause assumes that every genus-zero
  stable map to a curve of positive genus is constant, in the form of the
  projective-bundle formula and the module identification.  Evidence gap: no
  moduli of stable maps in the package.  Owner: the quantum-instantiation
  priority of the backlog.

## Next

The remaining absent rows are the four separation corollaries
(`cor:voisin-separation`, `cor:fermat-separation`, `cor:coprime-separation`,
`prop:A5-nonseparated`) and `lem:exact-low-degree-shifts`.  The separation
corollaries are the cycle-side cluster and depend on the relative six-axis
geometry; `lem:exact-low-degree-shifts` depends on the String and Divisor
Equations for an actual quantum connection.  Neither is a composition of
formalized algebra, so the cheapest remaining coverage work is no longer a
self-contained algebraic row.

## Export status

Exported.  The standalone paper repository
`~/src/math-papers/cubic-stabilization-m1` was synchronized from authority
`e9e9c4d28` with a zero-finding coupling audit, its tracked tree verifies against
the export manifest, and its own `make check`, pinned Lean build, and axiom-log
replay agree with the authority over 241 reviewer terminals.
