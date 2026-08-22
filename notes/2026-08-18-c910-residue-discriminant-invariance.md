# C910 — invariance of the residue discriminant: frame change, factor gluing, and the formal germ

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-m1/`.
**Date:** 2026-08-18.  **Authority commit:** `44fc8b1ff`.
**Predecessor:** the even-part orthogonality report
`2026-08-18-c910-even-part-orthogonality.md`.

This pass targets the residue-discriminant invariance cluster rather than the
next row in file order, because that cluster carries the most novel weight per
line in the unconditional route and had the thinnest formal coverage: the
atomic-invariant row and both rows its proof depends on were `absent`.  All
three are now fragments, and the algebra their proofs rest on is kernel checked.

## What the manuscript proof needs, and what is now proved

The residue discriminant `δ♯` is well defined on an ordinary Hodge atom for
three separate reasons, and each is now covered on its algebraic side.

- **An isomorphism of atomic `F`-bundles acts on the residue by conjugation and
  trace recentering.**  Conjugating a two-by-two matrix by mutually inverse
  matrices preserves its trace and its determinant, hence the discriminant of its
  characteristic polynomial; adding a scalar multiple of the identity afterwards
  changes nothing further.
- **The presentation of one factor is only defined up to a block-diagonal change
  of frame.**  Such a change restricts on each factor to conjugation by the
  diagonal blocks of the two matrices, and those blocks are again mutually
  inverse, so a rank-two factor's residue discriminant read through any frame is
  unchanged.
- **The value does not depend on the base point of the component.**  In a formal
  power-series model of the germ over a characteristic-zero domain, if each
  formal partial derivative of the residue is its commutator with a regular
  matrix — the modified flatness equation in each base direction — then every
  formal partial derivative of `δ♯` vanishes and `δ♯` is the constant series with
  its own constant coefficient.

## The derivation calculus that the third item needed

The package defined the coefficientwise formal partial derivative of a
multivariate formal power series but proved no calculus for it, so the existing
commutator lemma, which annihilates the residue discriminant for any additive
derivation satisfying the Leibniz rule, could not be applied to it.  Both laws
are now proved.  Additivity is immediate.  The Leibniz rule is the coefficient
identity obtained by writing the weight of the differentiated variable in a
monomial of a product as the sum of its weights in the two factors, and
reindexing each half of the resulting antidiagonal sum along the shift by one in
that variable; summands whose relevant component omits the variable carry weight
zero, which is what makes the two reindexings match.  Constancy then follows
because the coefficient of a formal partial derivative at a multi-index is a
positive integer multiple of a coefficient of the series one step higher in that
variable.

Three reviewer terminals were added:
`atomicResidueDiscriminant_invariant_under_frame_change`,
`atomicFactor_residueDiscriminant_invariant_under_blockDiagonal_frame_change`,
and `atomicResidueDiscriminant_constant_on_formal_germ`.

## Coverage

Three rows moved from absent to fragment: `prop:atom-invariant`,
`lem:factor-glue`, and `lem:crossing`.  The snapshot is 50 claims and 46
machinery rows over 204 terminals: 13 absent, 18 fragmentary, 18 conditional,
1 complete.

## Gates

All green at `44fc8b1ff`.  The new module was elaborated singly and the two
library targets were built through the guarded queue; `make check` and the
axiom-log check pass over 112 sources, and each new terminal reports
`propext, Classical.choice, Quot.sound`.  No manuscript source was edited; the
tracked PDF is unchanged at 49 pages.

## Scope

Every geometric and analytic ingredient of these three lemmas remains outside
Lean.  There is no ordinary Hodge atom, no atomic `F`-bundle and no isomorphism
of one, no elementary modification, no spectral cover and no connected component
of one.  In particular Lean does not prove that an isomorphism acts on the
residue by conjugation, that local factors over a component glue, that `δ♯`
extends meromorphically across the locus where the leading operator degenerates,
or that a connected normal rigid space is irreducible — the manuscript's route to
constancy on the component.  Constancy is proved on a formal power-series germ,
which is weaker than constancy on that component, and the formal model is not
identified with a geometric germ.

## Mystery ledger

- The three invariances are independent of each other and of nondegeneracy.
  Conjugation invariance uses only that trace and determinant are conjugation
  invariant; the factor statement uses only that a block-diagonal pair of
  mutually inverse matrices restricts to a mutually inverse pair on each factor;
  constancy uses only the commutator form of the derivative.  None of them needs
  the leading operator to be square-zero, nonzero, or rank two, although the
  manuscript states them for that case.  Settled by this pass.
- The Leibniz rule was the whole obstruction to the third item.  The commutator
  lemma had been available since the rank-two rigidity pass and applies to any
  additive derivation satisfying the Leibniz rule; what was missing was that the
  formal partial derivative is one.  Settled by this pass.
- Open: the gap between a formal germ and a connected component.  The manuscript
  concludes constancy on a component of the unramified spectral cover using
  normality, connectedness, and rigid-analytic irreducibility; the formal model
  gives constancy near one point only.  Evidence gap: no rigid-analytic geometry
  in the package, and no formalization of the spectral cover.  Owner: the
  geometric-input rows, not this one; nothing downstream in the formal artifact
  depends on the stronger statement, because the atom-invariant row is itself
  only a fragment.
- Open: the equivalence relation on ordinary Hodge atoms is not represented at
  all, so "well-defined invariant" is not a formal statement in the package —
  only its three ingredients are.  Evidence gap: the atom ledger models
  multiplicities, not atoms with isomorphisms.  Owner: a successor under the
  atom-invariant row.

## Next

The absent geometric rows `lem:hodge-base`, `lem:euler-sign`, and
`prop:cubic-atom` are the remaining Section 4 gaps, and the orphaned machinery
themes still need a disposition.

## Export status

Exported.  The standalone paper repository
`~/src/math-papers/cubic-stabilization-m1` was synchronized from authority
`44fc8b1ff`, the export manifest verifies over 142 tracked files, and the
repository's own `make check`, pinned Lean build, and axiom-log replay agree with
the authority over 204 reviewer terminals.
