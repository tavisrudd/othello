# C910 — block diagonality for an arbitrary splitting and nondegeneracy on the even part

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-m1/`.
**Date:** 2026-08-18.  **Authority commit:** `ad5a9b87d`.
**Predecessor:** the pairing-horizontality report
`2026-08-18-c910-pairing-horizontality.md`, whose mystery ledger left the
even-part refinement of `lem:orthogonal` open.

`lem:orthogonal` is now a conditional deduction rather than a fragment.  Until
this pass Lean proved the Sylvester step and the order-by-order induction for
*two* factors, and recorded nondegeneracy only as the determinant identity for a
two-block matrix; assembling many factors into one pairing, transporting
nondegeneracy through that assembly, and the parity refinement that gives
nondegeneracy on the even part were all missing.  All three are now proved, and
the separation hypothesis is shown to be indispensable.

## Nondegeneracy on an orthogonal set of coordinates

`Quantum/OrthogonalRestrictionNondegeneracy.lean` proves the transport step in
the form the argument actually uses.  Let a pairing be a square matrix over a
field on a finite type of coordinates and let a predicate single out a set of
them.  Call that set orthogonal to its complement when every entry with row
outside the set and column inside it vanishes.  Then a pairing with nonzero
determinant restricts to a matrix with nonzero determinant on that set: a
nonzero kernel vector of the restriction, extended by zero, is a kernel vector of
the whole pairing, because rows inside the set reproduce the kernel equation and
rows outside it are annihilated entrywise.

Both uses in the manuscript are instances.  With a factor label on the
coordinates, block diagonality makes each fiber orthogonal to its complement, so
the restriction to one spectral factor is nondegenerate.  With a parity in
addition, the Poincare form pairing only equal parities makes the even
coordinates of one factor orthogonal to everything else, so the restriction to
the even part of a factor is nondegenerate.  Transport along any bijection
`Fin rank ≃ (the even coordinates of a factor)` preserves nonvanishing of the
determinant, which is exactly the invertibility hypothesis that the rank-two
rigidity theorem consumes for an even rank-two factor.

## Block diagonality for an arbitrary labelled splitting

`Quantum/BlockDiagonalHorizontalPairing.lean` supplies the assembly.  A
splitting is a label on the coordinates; a block-diagonalizing frame is the
hypothesis that the residue and every regular coefficient of the connection
vanish on entries whose row and column carry different labels.  The block of a
product with a block-diagonal left factor is the product of the diagonal block
on the row label with the block of the other factor, and symmetrically on the
right; transposition, addition, subtraction, scalar multiplication, and finite
sums are entrywise.  Hence the block of the horizontality coefficient between
two labels *is* the two-factor horizontality coefficient of the corresponding
blocks.

Feeding that into the existing Sylvester induction gives the manuscript's
conclusion for arbitrarily many factors at once: with pairwise distinct leading
eigenvalues, and the residue on each factor equal to its eigenvalue plus a
nilpotent matrix, every coefficient of the pairing vanishes on every entry whose
row and column carry different labels.  Combined with the restriction step, the
leading pairing coefficient is then nondegenerate on each factor and on the even
part of each factor.

Making this possible, `Quantum/SeparatedSpectralPairing.lean` and
`Quantum/PairingHorizontality.lean` were generalized from factors indexed by
`Fin rank` to factors indexed by arbitrary finite types with decidable equality.
The proofs are unchanged; only the index types moved.  This is what lets the
fibers of a label serve as the two factors.  Every previously landed statement
survives as an instance, and no terminal changed its name.

## The separation hypothesis is indispensable

For any scalar there are two one-dimensional factors with that same scalar
residue, vanishing regular part, and a constant pairing with invertible leading
coefficient, satisfying every coefficient of the horizontality identity while the
pairing between them is nonzero.  The two residue terms cancel because the
residues are equal scalars, and every remaining term contains a vanishing regular
or pairing coefficient.  So distinctness of the leading eigenvalues cannot be
dropped from the conclusion; it is what makes the Sylvester operator invertible.

Three reviewer terminals were added:
`separatedSpectralFactors_labelledPairing_blockDiagonal_of_horizontality`,
`separatedSpectralFactors_evenPart_pairing_nondegenerate`, and
`separatedSpectralFactors_equalEigenvalues_admit_nonzero_horizontalPairing`.

## Coverage

One row moved: `lem:orthogonal` from fragment to conditional deduction, now
carrying five terminals.  The snapshot is 50 claims and 46 machinery rows over
201 terminals: 16 absent, 15 fragmentary, 18 conditional, 1 complete.

## Gates

All green at `ad5a9b87d`.  Each new module was elaborated singly and the two
library targets were built through the guarded queue against the standalone
package; `make check` and the axiom-log check pass over 111 sources, and each new
terminal reports `propext, Classical.choice, Quot.sound`.  No manuscript source
was edited; the tracked PDF is unchanged at 49 pages.

## Scope

Lean still constructs no `F`-bundle, spectral cover, connection, quantum
product, cohomological grading, or Poincare pairing.  Three inputs remain
hypotheses rather than constructions, and each is geometric or analytic rather
than algebraic:

- existence of a regular block-diagonalizing frame, that is, the local splitting
  itself.  Lean assumes the connection is block diagonal for the label; the
  manuscript obtains that frame from the unramified spectral cover.
- the identification of the supplied parity function with cohomological degree
  modulo two, and with it the statement that the Poincare form pairs only equal
  parities.  In Lean this is a hypothesis about a matrix.
- nondegeneracy of the full Poincare pairing, which is supplied as nonvanishing
  of a determinant.

## Mystery ledger

- Nondegeneracy transports without symmetry.  The restriction argument uses
  neither symmetry of the pairing nor two-sided orthogonality: only that entries
  with row outside and column inside the chosen set vanish.  That matters here
  because the pairing in play is sesquilinear rather than symmetric, so the
  manuscript's symmetry of the leading coefficient is not needed for this step.
  Settled by this pass.
- The parity refinement never uses that there are two parities.  The argument
  applies verbatim to any grading whose pieces are mutually orthogonal, so the
  even part is nondegenerate for the same reason any orthogonal summand is.  The
  restriction to the integers modulo two in the formal statement is a matter of
  naming the geometric case, not of the proof.  Settled by this pass.
- Block diagonality remains independent of nondegeneracy at every order; the
  determinant hypothesis enters only in the restriction step.  Carried over from
  the predecessor report and unchanged by the multi-factor generalization.
- Separation is indispensable, and sharply so at the leading order.  The witness
  above shows the conclusion fails when the two eigenvalues agree.  What remains
  unexamined is the intermediate case of equal scalars with different nilpotent
  parts, where the Sylvester operator is nilpotent rather than invertible and the
  off-diagonal pairing is constrained but not obviously zero.  Evidence gap: no
  formal or informal analysis of that case.  It gates nothing: the manuscript
  applies the lemma only to factors with distinct eigenvalues.
- Open: the existence of the block-diagonalizing frame.  Every statement here is
  conditional on the connection being block diagonal for the label, which is the
  manuscript's choice of frame on a component of the unramified spectral cover.
  Evidence gap: no spectral cover or splitting exists in the package.  Owner: the
  geometric-input rows, not this one.

## Next

From the gap audit, still open: the absent geometric rows `lem:hodge-base` and
`lem:euler-sign`, which carry the Hodge-theoretic base and the Euler-field sign
convention of the atomic route, and the disposition of the orphaned machinery
themes.

## Export status

Exported.  The standalone paper repository
`~/src/math-papers/cubic-stabilization-m1` was synchronized from authority
`ad5a9b87d` at its commit `8019404`, the export manifest verifies over 141
tracked files, and the repository's own `make check`, pinned Lean build, and
axiom-log replay agree with the authority over 201 reviewer terminals.
