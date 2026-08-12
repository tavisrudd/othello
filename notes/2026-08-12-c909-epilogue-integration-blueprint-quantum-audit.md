# C909 — hostile quantum/editorial audit of integration blueprint c42079dd

Date: 2026-08-12  
Status: blueprint audit only; no manuscript, PDF, mirror, or blueprint edit

## Verdict

**MINOR for the ν6 birational and one-ℙ¹ statements once their hypotheses are
printed; MAJOR for the unqualified (\nu_6(V_{14})=2) headline and any abstract
claim before the Kuznetsov/quantum comparison is source-closed.**

The blueprint's Section 4 step 4 already notices the central issue: the current
cubic calculation supplies a sixth-root block and hence
\(ν_6(X)\ge2\), not the equality \(ν_6(X)=2\).  The headline hierarchy in
§2(D), the abstract suggestion in §3, and the synthesis table must obey that
gate rather than merely repeat the desired equality.

## 1. Birational-invariance statement

The honest theorem is:

> Assume the KKPYY blowup/projective-bundle chemical-formula identities and
> the low-dimensional spectral lemma that every atom represented by a smooth
> projective variety of dimension at most two has no primitive sixth-root
> formal monodromy.  Then the integer ν6 is a birational invariant of smooth
> projective complex varieties of each fixed dimension (d\le4).

The fixed-dimension phrase matters.  Weak factorization uses smooth centers of
codimension at least two, so a (d\)-fold has centers of dimension at most
`d-2`; for (d\le4) these are points, curves, or surfaces.  The blowup
formula adds Tate-shifted copies of center atoms.  Integral Tate shifts do not
change formal monodromy, and the low-dimensional lemma makes their ν6 zero.
Blowdowns are the inverse relations.  Projective space has only integral
formal powers, hence a rational smooth (d\le4)-fold has ν6 zero.

Blueprint §2(D)(1) is therefore correct only with this source/hypothesis
clause.  A bare sentence “ν6 is birationally invariant” hides both the
atom-level definition and the dimension-four center bound.

## 2. One-ℙ¹ stabilization

For a rank-two bundle (E\to X), the projective-bundle formula gives
\[
 \nu_6(\mathbf P_X(E))=2\nu_6(X),
 \tag{1}
\]
because the two projective summands differ only by integral Tate shifts.  In
particular 
\(\mathbf P_X(\mathcal O_X^{\oplus2})\cong X\times\mathbf P^1\).
If (X\times\mathbf P^1) and (Y\times\mathbf P^1) are birational smooth
fourfolds, dimension-four birational invariance gives
\[
 2\nu_6(X)=2\nu_6(Y).
\]
Cancellation is legitimate because ν6 takes values in the torsion-free
group ℤ; the proof must not divide an atom class or use a mod-two target.

Blueprint §4, item 2 is mathematically salvageable, but its wording “a
projective bundle is birational to (Y\times\mathbf P^1)” needs two
qualifications:

* a general ℙ¹-bundle is not isomorphic to a product;
* over an integral base it is only noncanonically birational to the product,
  after choosing a basis over (K(Y)).

No such generic trivialization is needed for the actual theorem: use the
trivial rank-two bundle directly.  If the manuscript mentions birational
projectivizations, state the integral-base and noncanonical-basis caveat.

Thus the exact safe formulation is “ν6 is invariant under one trivial
ℙ¹-stabilization of smooth projective threefolds,” with the rank-two
projective-bundle identity as its proof.

## 3. (V_{14}) source and normalization gate

The blueprint correctly lists three gates but does not consistently enforce
them in its headline hierarchy:

1. The source must apply to every smooth genus-eight prime Fano threefold
   (V_{14}) being quantified, not merely a generic member or a special
   period sublocus.
2. The comparison must land in the smooth cubic quantum/F-bundle setting used
   by the ν6 proof, with the parity-fixed zero atom identified.
3. A Kuznetsov/derived equivalence alone is insufficient: it must preserve the
   maximal A-model atom and formal-monodromy block, or a separate theorem must
   supply that transport.
4. “Normalization” of a parameter curve does not itself prove this atom
   identification or a birational map between the relevant projectivizations.

Until these are source-closed, the body should say:

> On the exact Kuznetsov comparison locus, the identified cubic sixth-root
> block transfers to (V_{14}), so ν6(V_{14})>0; consequently
> (V_{14}\times\mathbf P^1) is irrational.

The stronger equality ν6(V_{14})=2 requires a full-atom upper bound.  The
current cubic proposition records only the two known eigenvalues, hence
ν6(≥2).  If the exact comparison transports only that block, the safe
conclusion is nonvanishing, which is already sufficient for irrationality.
The equality should be promoted only after a proof that no additional
primitive sixth-root multiplicity lies in the same atom.

The abstract should therefore omit (V_{14}) until the gates close, or say
“a conditional (V_{14}) corollary on the exact comparison locus” without the
numerical equality.  The phrase in §2(D)(3), “for every smooth ... (V_{14}),”
is currently stronger than the verified record.

## 4. Placement and page burden

The proposed one-page “Further birational consequences” is enough for the
birational lemma and the trivial-ℙ¹ corollary if it contains:

* the formal-monodromy definition of ν6;
* the dimension-(le2) center lemma;
* the weak-factorization sentence;
* the rank-two projective-bundle equation and ℤ-cancellation.

Adding the (V_{14}) application at theorem strength costs a separate source
paragraph: exact comparison locus, atom transport, normalization, and the
nonvanishing/equality distinction.  The 18–20-page target is credible only if
that material is a conditional final corollary or a short remark.  If the
paper prints a proof for every smooth (V_{14}), a one-page quantum subsection
is not enough without compressing away the trust boundary.

Recommended editorial order:

1. Prove the fourfold birational ν6 lemma and one-ℙ¹ consequence immediately
   after the existing cubic quantum proof.
2. State the (V_{14}) result as conditional, with ν6>0, in the body only
   after the exact comparison citation is verified.
3. Keep (V_{14}) out of the abstract and headline theorem surface until the
   all-smooth-locus and full-atom upper-bound gates are actually closed.

## Bottom line

The quantum/editorial architecture is coherent after weakening the noncubic
claim to a conditional nonvanishing statement and making ℤ-cancellation and
the low-dimensional center hypothesis explicit.  The exact equality
ν6(V_{14})=2 and the universal quantifier “every smooth (V_{14})” remain
MAJOR pending source/normalization and full-atom audits; they should not be
allowed to enter the abstract merely because the blueprint labels them a
planned theorem.

