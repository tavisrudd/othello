# C902 cold marking and architecture review

**Verdict: REPAIR REQUIRED (one localized mathematical sign defect).**

Scoped cold read: the uncommitted changes and necessary surrounding text in
`sections/03-orientation-source.tex` and `sections/05-golden-operator.tex`,
checked against the C733 relative-marking boundary and the C897
source--shadow--return architecture.  I did not read C902's wording packet or
another cold review.

## Defect

1. `sections/05-golden-operator.tex:349--355` gives the ordinary field norm
   with the wrong sign (and applies it before the determinant line has been
   scalarized).  The surrounding proved identities are
   \[
   \det[D_x,C_T]=16Z_T^2,
   \qquad Z_T=10\sqrt5\,\det B_T.
   \]
   With the displayed compatible orientations, therefore
   \[
   N_{E/\Q}(\det B_T)
     =N_{E/\Q}\!\left(\frac{Z_T}{10\sqrt5}\right)
     =-\frac{Z_T^2}{500},
   \]
   since \(N_{E/\Q}(\sqrt5)=-5\).  Thus the scalar identity is
   \[
   \det[D_x,C_T]=-8000\,N_{E/\Q}(\det B_T),
   \]
   not the printed \(+8000\) identity.  Alternatively the text may define a
   signed determinant-line contraction whose value is \(-N_{E/\Q}\), but it
   cannot call the current positive expression the ordinary field norm.

## Passed checks

- `sections/03-orientation-source.tex:90--95` is safe: after the explicitly
  transported identification, \(\Q[C]=\Q[-C]\) is literally the same unmarked
  quadratic subalgebra, while \(C\), \(Z_C\), the chart lift, and the attached
  relative source retain their marked signs.  It does not claim that the sheet
  reconstructs a marking.
- The recognition theorem's two signs are correctly the determinant character
  of the **signed label space**.  Switching fixes \(\mathcal T_A\) and multiplies
  \(\Phi_A\) by the switching determinant; an odd relabelling has the analogous
  effect.  By contrast \(A\mapsto-A\) negates both cubics, so deck/golden
  orientation reversal does not change the ratio.  The present wording keeps
  these signs distinct.
- The recognition proof is sound on its stated nonzero real locus.  Degree
  forces \(n=6\); translation invariance kills the off-diagonal entries of
  \(A^2\); commutation plus nonzero off-diagonal entries makes its diagonal
  scalar; and the equal-absolute-value specialization gives the pentagon
  conference class.  The weighted remainder is explicitly left unclassified.
- Placement after the shadow theorem makes recognition a bounded converse,
  not a replacement source.  The following navigation still sends the main
  argument to the harmonic return and labels the later spectral material as
  non-load-bearing.  The short reuse of the pentagon normalization is local
  proof closure, not architectural duplication or overload.

## Repair regrade

**Regrade: PASS.**  The repaired paragraph in
`sections/05-golden-operator.tex:344--357` now has the exact sign:
\[
N_{E/\Q}(\det B_T)
=N_{E/\Q}\!\left(\frac{Z_T}{10\sqrt5}\right)
=-\frac{Z_T^2}{500},
\qquad
-8000N_{E/\Q}(\det B_T)=16Z_T^2.
\]
Its odd-rank determinant-line contraction sentence accounts for the minus
sign before the ordinary quadratic field norm, and the oriented identity
\(Z_T=10\sqrt5\det B_T\) fixes the remaining square-root sign.

The marking and architecture checks remain green.  Deck exchange still
negates \((C,Z_C)\) while preserving the unmarked algebra \(\Q[C]\); the
recognition theorem's \(\pm4\) still records signed-label determinant
orientation rather than deck orientation; and the theorem remains a bounded
converse inside the shadow section before the explicitly signposted harmonic
return.  The OPER-1 trust row records the same \(-8000\) identity, includes the
determinant-line explanation, and lists the four-shadow formal artifacts for
the scalar-square and sign-locus recognition clauses.  No new defect found.

**Final compression regrade: PASS** — the compressed theorem, pointer, and norm prose preserve the accepted hypotheses, \(\pm4\) signed-label character, \(-8000\) ordinary-norm identity, and source--shadow--return hierarchy without changing mathematical or architectural meaning.
