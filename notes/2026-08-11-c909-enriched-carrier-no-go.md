# C909 — What an enriched carrier invariant must retain

**Date:** 2026-08-11  
**Lane:** `clebsch`  
**Status:** bounded source-level extraction; no manuscript, PDF, mirror, Lean edit, or commit.

## Verdict

The ordinary KKPYY chemical formula cannot carry a nontrivial Tate-level,
exceptional-position, or Serre-block refinement.  Its coordinates are abstract
\(G\)-atom classes and their total multiplicities.  Any additive refinement
factoring through that formula is uniquely a weight assigned to each abstract
atom; the projective-bundle and blowup identities then force every copy of a
given atom to have the same weight.

This gives a precise no-go, with an important scope boundary.  An arbitrary
set-theoretic function of the full chemical formula can of course inspect the
whole multiplicity vector.  What it cannot do is split the several copies of
one abstract atom into canonical Tate levels, Euler branches, or a unipotent
Serre block.  A refinement capable of obstructing \(X\times\mathbf P^2\) must
therefore enlarge the atom object before taking the chemical formula; it cannot
be a relabelling or additive statistic of ordinary \(\operatorname{CF}_G\).

For the cubic atom \(\alpha_X\), ordinary atoms give

\[
 [\alpha_X]\operatorname{CF}_G(X\times\mathbf P^2)=3,
 \qquad [\alpha_X]\operatorname{CF}_G(X)=1.
\]

The three copies have no canonical order in the abstract quotient.  C907's
candidate Tate/Rees or enriched Serre length distinguishes an endpoint block
of length three from a codimension-two center block of length one, but that
distinction is precisely the information KKPYY's present atom equivalences
discard.  This note does not revisit C907's analytic/Stokes comparison gate.

## What KKPYY retain and discard

KKPYY's A-model \(F\)-bundle has a connection on a disc with coordinate \(u\),
the Euler multiplication operator, and the grading operator.  At a suitable
basepoint the spectral decomposition produces generalized Euler eigenspace
\(F\)-bundles.  Their source-level formulas contain more local data than the
final abstract atom.

Three source statements determine the boundary.

1. The introduction explicitly says that the A-model \(F\)-bundle is built on
   the **\(\mathbf Z/2\)-weighted** Hodge structure.  Its footnote says that
   this folds the cohomological \(\mathbf Z\)-grading to \(\mathbf Z/2\), or
   equivalently works with Hodge structures modulo Tate twists.  Absolute Tate
degree is therefore not part of the \(G\)-atom input.
2. The classical blowup model still displays the lost information:

   \[
   H^\bullet(\operatorname{Bl}_Z Y,\mathbf Q)
   \simeq H^\bullet(Y,\mathbf Q)\oplus
      \bigoplus_{i=1}^{c-1} H^\bullet(Z,\mathbf Q)[-2i].
   \]

   The shifts \([-2i]\) are all even and are collapsed when the atom theory
passes to its Tate-quotiented, \(\mathbf Z/2\)-weighted input.
3. Definition 5.16 identifies the blowup with \(Y\sqcup(c-1)Z\) and a rank-
   \(R\) projective bundle with \(R\) copies of \(Y\).  The chemical formulas
   are consequently

   \[
   \operatorname{CF}_G(\operatorname{Bl}_Z Y)
     =\operatorname{CF}_G(Y)+(c-1)\operatorname{CF}_G(Z),
   \qquad
   \operatorname{CF}_G(\mathbf P_Y(E))=R\operatorname{CF}_G(Y).
   \tag{C909.8}
   \]

The local \(F\)-bundle and its spectral cover can still be used to define a
geometric refinement.  Proposition 5.22 only maps abstract atoms to
geometric atomic \(F\)-bundle classes; the abstract chemical formula does not
retain the local branch, its limiting Euler eigenvalue, or its Tate shift.

## Classification of additive refinements through the chemical formula

Let

\[
 \mathcal A=\operatorname{Atoms}^{K}_G,
 \qquad
 \operatorname{CF}_G(Y)\in\mathbf Z_{\ge0}^{(\mathcal A)}.
\]

Consider an additive refinement with values in an abelian group \(M\):

\[
 I(Y)=\Phi(\operatorname{CF}_G(Y)),
 \qquad
 \Phi:\mathbf Z_{\ge0}^{(\mathcal A)}\longrightarrow M,
 \quad
 \Phi(a+b)=\Phi(a)+\Phi(b).
\]

Then there is a unique weight function

\[
 w:\mathcal A\longrightarrow M,
 \qquad
 w(\alpha)=\Phi(\delta_\alpha),
\]

and

\[
 I(Y)=\sum_{\alpha\in\mathcal A}m_\alpha(Y)w(\alpha).
 \tag{C909.9}
\]

Thus integer gradings, vector-valued multiplicities, Hodge-polynomial
weights, and any finite collection of additive atom statistics are all the
same kind of refinement: a weight on an abstract atom coordinate.  Formula
(C909.8) forces

\[
 I(\operatorname{Bl}_Z Y)=I(Y)+(c-1)I(Z),
 \qquad
 I(\mathbf P_Y(E))=R I(Y).
 \tag{C909.10}
\]

No copy index occurs in (C909.9) or (C909.10).

The same statement gives a sharper Tate no-go.  Suppose one tries to add a
formal shift \(L\) and wants the projective bundle to retain the Leray--Hirsch
levels:

\[
 \widetilde I(\mathbf P_Y(E))
   =\sum_{j=0}^{R-1}L^j\widetilde I(Y),
 \tag{C909.11}
\]

while also requiring \(\widetilde I=\Phi\circ\operatorname{CF}_G\) for an
additive \(\Phi\).  The ordinary formula gives the left side as
\(R\widetilde I(Y)\).  For a nonzero atom weight \(v\), rank two already
forces

\[
 2v=v+Lv,
 \qquad\text{hence}\qquad Lv=v
 \tag{C909.12}
\]

in any cancellative grading group.  All \(L^jv\) therefore coincide.  The
blowup version has the same obstruction:

\[
 \widetilde I(\operatorname{Bl}_Z Y)
   \stackrel{\text{desired}}{=}
   \widetilde I(Y)+\sum_{i=1}^{c-1}L^i\widetilde I(Z),
\]

but (C909.10) supplies only \((c-1)\widetilde I(Z)\), forcing the same
collapse.  A non-cancellative target can hide this equation, but then it does
not provide a usable additive grading or length obstruction.

This is the classification/no-go needed here: every additive refinement that
factors through ordinary chemical formula is a weight map, and every attempt
to attach a nontrivial Tate shift to the copies contradicts the rank-two
projective-bundle relation.

## Candidate refinements in the KKPYY source

### Tate or absolute cohomological degree

The source explicitly removes it by passing to \(\mathbf Z/2\)-weighted Hodge
structures modulo Tate twists.  The shifts \([-2i]\) in the classical blowup
decomposition are useful evidence for the missing datum, not an invariant of
the abstract atom.  Restoring them changes (C909.8) to a refined formula of
the form (C909.11), so it necessarily leaves the ordinary atom quotient.

### Hodge \(p-q\) degree

This one does survive as an abstract Hodge-atom enhancement.  KKPYY
Proposition 5.23 makes the \(G\)-representation of a geometric atom
independent of its representative; Definition 5.26 packages the Hodge case
as the polynomial \(P_\alpha(t)\), whose exponent is the \(p-q\) degree.
It is a legitimate weight \(w(\alpha)=P_\alpha(t)\), but it is not an
absolute Tate degree.  The three copies of \(\alpha_X\) in
\(X\times\mathbf P^2\) all receive the same \(P_{\alpha_X}(t)\), so this
enhancement cannot distinguish endpoint positions from center positions.

### Euler eigenvalue or spectral degree

The Euler spectrum is available locally: the reduced spectral cover and its
connected components define local atoms.  It is not a canonical grading of an
abstract atom.  In the blowup model the limiting Euler eigenvalues separate
the base block from the \(c-1\) exceptional branches, but Definition 5.16
then identifies those branches with copies of the center atom.  Theorem 4.11
similarly identifies the rank-\(R\) projective bundle with \(R\) copies of the
base atom over connected analytic domains.  Branch labels can also be
permuted by continuation.  Retaining them would replace the abstract atom
set by a branch- or sector-enhanced set, not refine (C909.8) inside it.

### Multiplicity

Multiplicity is exactly what the chemical formula retains.  A rank-\(R\)
projective bundle multiplies every atom coordinate by \(R\), while a blowup
adds \(c-1\) copies of the center formula.  This is positive and useful for
the one-step height obstruction, but cannot distinguish \(3\) copies of one
atom in \(X\times\mathbf P^2\) by their would-be levels.  C907's self-carrier
balances show that the cubic-coordinate arithmetic has no contradiction once
the stabilization reaches \(m=2\); this note does not assert that those
centers occur together in one weak factorization.

### Serre operator or Jordan length

No such refinement is present in KKPYY's current atom theory.  The source
explicitly lists atoms enhanced with topological (K)-theory, Mukai pairings,
or Serre automorphisms as future work.  The abstract chemical formula has no
operator whose nilpotence index could record the endpoint length three.  An
enriched pair consisting of an atom and a unipotent operator could do so, but
it is an enlargement of the atom category and must prove strict compatibility
with blowups; it is not a factor of ordinary \(\operatorname{CF}_G\).

## The (X\times\mathbf P^2) consequence

For the cubic zero atom, the ordinary formula gives

\[
 [\alpha_X]\operatorname{CF}_G(X\times\mathbf P^2)=3,
\]

and every additive factor through \(\operatorname{CF}_G\) gives the same
threefold copy as (3w(\alpha_X)).  The self-carrier calculation owned by
C907 has (m=2), (t=1), and exceptional multiplicity

\[
 w_1=t(m-t)=1,
 \qquad 3w_1=m+1=3.
\]

Consequently no additive atom weight, Hodge polynomial, or other coordinate
wise chemical-formula statistic can rule out the (m=2) copy balance.  A full
nonlinear function of all atom coordinates is not covered by this claim; no
full-chemical-formula equality for a common resolution has been proved.  The
precise no-go is that ordinary atoms cannot split the repeated cubic coordinate
into the three integral positions needed by the Tate polynomial

\[
P_2(L)=1+L+L^2.
\]

In C907's notation the same comparison is \(P_2(L)\) for the endpoint versus
\(B_{2,1}(L)=L\) for the self-carrier threefold contribution.  The displayed
polynomials are an enriched target, not an identity in ordinary
\(\operatorname{CF}_G\).

The enriched carrier object required by C907 must therefore retain at least:

1. the abstract or geometric cubic-isotypic atom;
2. an integral/Rees/Tate position or an equivalent unipotent operator \(U=I+N\)
   whose Jordan length is visible;
3. strict associated-graded additivity under each blowup and projective-bundle
   comparison; and
4. enough analytic/Stokes gluing data to prevent semiorthogonal extensions from
   joining shorter center blocks.

Items 2--4 are not supplied by KKPYY's ordinary atom equivalences.  They are
the exact kind of enhancement C907 is testing, and this note treats them only
as requirements rather than attempting their proof.

## `ej` + `tt` closeout / mystery ledger

The cheap upgrade is the rank-two equation (C909.12): it proves directly that
any nontrivial Tate shift collapses if the refinement factors through the
ordinary projective-bundle formula.  The hostile checks were:

* Hodge \(p-q\) degree survives, but is only an atom weight and therefore does
  not distinguish repeated copies.
* Euler branch data survives locally, but not as an abstract branch label;
  the source's equivalence deliberately replaces branches by copies.
* Serre length is the right kind of extra datum, but KKPYY explicitly place
  Serre-enhanced atoms in future work.
* The no-go is deliberately restricted to additive or coordinate-wise
  refinements through \(\operatorname{CF}_G\); an arbitrary nonlinear function
  of the full chemical formula is not ruled out without a full ledger equality.

Settled: ordinary chemical formula admits no canonical Tate-level or Serre
length refinement, and all additive factors are atom weights.  Remaining
mystery: whether C907's enriched cubic-isotypic object can be made intrinsic
and strictly composable through weak factorization.  That is C907's gate, not
a new C909 source task.

## Source pinpoints

All checks used the cached KKPYY v2 PDF, arXiv:2508.05105,
SHA-256 `2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64`:

* Introduction pp. 2--3 and its footnote: the \(\mathbf Z/2\)-weight convention
  folds the \(\mathbf Z\)-grading and works modulo Tate twists; the blowup
  cohomology decomposition displays the shifts \([-2i]\).
* Definition 3.1 p. 17 and the A-model connection discussion pp. 18--19:
  \(F\)-bundles carry the \(u\)-disc, connection, Euler operator, and grading
  operator.
* Theorem 4.5 p. 44: blowup decomposition and exceptional spectral branches.
* Theorem 4.11 p. 47: rank-\(R\) projective-bundle decomposition into \(R\)
  copies.
* Definition 5.10, §§5.2.3--5.2.6, and Proposition 5.17 pp. 51--55:
  abstract atoms, their chemical formulas, elementary equivalences, and the
  dimension-filtration criterion.
* Proposition 5.22 and Proposition 5.23 pp. 59--60: geometric atomic
  \(F\)-bundles and the representative-independent \(G\)-representation.
* Definition 5.26 pp. 61--62: Hodge polynomial \(P_\alpha(t)\) records only
  \(p-q\) degree.
* Introduction pp. 6--7: Serre-automorphism and Mukai-pairing enhancements are
  explicitly deferred to future work.

For the endpoint length and the exact C907 analytic boundary, see
`notes/2026-08-10-c907-quantum-monodromy-stabilization.md` and
`notes/cubic-threefolds-tasks/c907-solver-dossier.md`.
