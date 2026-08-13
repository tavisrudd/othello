# C907 — formal point-covector frame gap

Date: 2026-08-13

Status: hostile audit; the proposed unconditional point-covector theorem
does **not** follow from Iritani's formal blow-up decomposition.  No stable
irrationality claim is made here.

## The tempting argument

For a blow-up \(\widetilde Y=\operatorname{Bl}_Z Y\), the pullback of the
point class from a point outside \(Z\) restricts trivially to \(Z\).  In
Iritani's initial-condition formula (5.44), all center Fourier terms and all
ambient corrections are linear in this restriction.  Consequently the
point class is pure in the initial matrix \(\Psi^\circ\): it goes to the
ambient point class and has zero center coordinates.

It is tempting to conclude that the intrinsic point flat section is also
pure, pair it with the primitive-sixth formal sector, and obtain an invariant
under every smooth blow-up.

## Fatal frame mismatch

The conclusion about the intrinsic flat section is not supplied by the
formal theorem.

1. Iritani explicitly declares \(q\) to be the class of an effective line in
   the exceptional divisor (Introduction, (1.1), and Remark 5.19).
2. The decomposition of Theorem 5.18 is defined after passage to
   \(\mathbf C[z]((q^{-1/s}))[[Q,\widetilde\tau]]\).  Its initial matrix is an
   expansion at the exceptional Laurent cusp, with corrections in negative
   powers of \(q\).
3. In Section 5.8.2 Iritani constructs a new fundamental solution \(M'\)
   normalized by \(M'|_{t=s=Q=0}=\mathrm{id}\).  The reconstruction is stated
   in the \((t,s,Q)\)-directions while explicitly disregarding the \(q\)- and
   \(z\)-directions.  This is a cusp-normalized formal frame.
4. The intrinsic Gamma point section used in the cubic Barnes calculation is
   normalized by the ordinary large-radius fundamental solution, at the
   effective-Novikov boundary \(q=0\).  The blow-up paper does not identify
   that frame with \(M'\).  Inverting \(q\) removes the normalization point,
   and the large-radius descendant series need not be an element of the
   \(q^{-1/s}\)-Laurent solution ring.

The distinction is visible inside Section 5.8.2 itself.  The ambient and
center fundamental solutions \(M_Y\) and \(M_Z\) are pushed through their
ring extensions to construct \(M\); no intrinsic \(M_{\widetilde Y}\) is
pushed through.  Instead \(M'=(\Psi^\circ)^{-1}M\Psi\) is manufactured and
normalized at the Laurent cusp.  In the graded solution completion, the
large-radius exceptional series can contain arbitrarily high positive powers
of \(q\), compensated by negative powers of \(z\).  Such a series is not a
Laurent series in \(q^{-1/s}\), whose \(q\)-powers are bounded above.  The
connection module survives the base change; its canonical large-radius
horizontal frame need not.

Therefore formula (5.44) proves only

\[
  \text{point purity in the exceptional-cusp frame}.
\]

The desired identity

\[
 \Psi\bigl(s^{\mathrm{LR}}_{\widetilde Y}(\mathrm{pt})\bigr)
 =s^{\mathrm{LR}}_Y(\mathrm{pt})\oplus0
\]

requires the connection matrix between the large-radius Gamma frame and the
exceptional-cusp frame.  Its center entries are not determined by (5.44).
This is precisely an analytic-continuation/Stokes/Gamma compatibility datum.

Remark 1.5 confirms the boundary: the general decomposition is formal, an
analytic lift is expected rather than proved, and compatibility with Orlov
through the Gamma-integral structure is cited only in toric settings.

## What survives

- Exact cohomological point purity of \(\Psi^\circ\) is a valid local theorem.
- The missing global datum has been compressed to the center part of one
  connection matrix between two asymptotic frames.
- The split-nef Kummer calculations prove this center coefficient vanishes in
  their covered cases, but they do not establish it for an arbitrary normal
  bundle or arbitrary weak-factorization center.
- The cubic Barnes coefficients still prove nonvanishing at the cubic
  endpoint once the large-radius Gamma framing is fixed.

## Audit rules extracted

**AA.** Never identify a cohomology vector in \(\Psi^\circ\) with an intrinsic
flat section without naming the fundamental solution and its normalization
boundary.

**EJ.** Formula (5.44) is the exact regression boundary: any proposed repair
must calculate or annihilate the center entries of the large-radius-to-cusp
connection matrix.

**TT.** When a comparison uses two asymptotic ends, label both coefficient
rings and both frames.  Flatness inside one formal neighborhood does not
transport a normalization through an inverted Novikov variable.

## Publishable stepping stone

The cusp lemma by itself is a sharp reading of Iritani's formulas, not yet a
standalone paper.  A credible short-note or substantial manuscript-section
package is:

1. **Formal Laurent-cusp point purity.**  For every smooth blow-up, the
   Gamma/top-class point column at a fixed exceptional Laurent cusp maps to
   the ambient point column with zero center columns.  Prove this from (5.44),
   the Birkhoff reconstruction, and avoidance of a point off the exceptional
   divisor by purely exceptional stable maps.
2. **Two-completion obstruction.**  There is no canonical continuous map from
   the large-radius solution completion to the exceptional-infinity Laurent
   solution completion.  The legal degree-zero tail
   \(\sum_{n\ge0}(q/z^{r-1})^n\) is an explicit witness: after
   \(x=q^{-1/s}\), its \(x\)-exponents are unbounded below.
3. **One-row reduction.**  Stable birational transport needs only the center
   row of the large-radius-to-cusp central connection matrix, not the full
   analytic Gamma--Orlov correspondence.  State the exact commutative
   point-column square and prove that its validity on the factorization
   arrows gives the desired telescope.
4. **Verified family.**  Add the split-nef rank-two Kummer theorem, where the
   relevant algebraic coefficient is killed by a reciprocal Gamma zero, and
   the birational normal-splitting reduction showing exactly what remains for
   arbitrary rank-two normal bundles.

This package has independent value because it separates a proved universal
formal theorem from a genuinely analytic one-row conjecture and supplies a
nontrivial verified class.  Its strongest natural placement is presently a
major section or companion note to the cubic-stabilization paper; standalone
publication strength depends on either extending the verified family beyond
split-nef centers or producing the first explicit nonzero frame-change
coefficient.

## AA — alternative attacks on the one-row gate

1. **Degeneration of the one row (highest value for `m=2`).**  Use the landed
   birational splitting of a rank-two normal bundle and prove that only the
   point-column center coefficient is invariant under deformation to the
   split normal cone.  The split endpoint is already zero by the Kummer
   calculation.  This avoids constructing a full analytic blow-up map.
2. **Partial Gamma/second-structure theorem for \(\mathcal O_p\).**  Prove
   only that the central-connection image of the point object respects the
   Orlov ambient summand.  The categorical orthogonality
   \(\chi(\mathcal O_p,i_*F)=0\) for \(p\notin Z\) predicts the required zero
   center row.  This is conceptually clean but still requires a new analytic
   identification for one K-class.
3. **One-column Borel summability.**  Seek Gevrey bounds and sectorial
   uniqueness only for the point column of Iritani's formal Fourier map.
   Exact zero of its formal center columns would then survive summation.
   This is much weaker than analytifying the entire decomposition, but the
   paper's general non-analyticity warning makes the estimates substantive.
4. **Relative oscillatory-cycle construction.**  Realize the point functional
   by a rapid-decay cycle supported away from the center and prove that it has
   zero projection to exceptional critical points.  This could construct the
   needed row directly without an integral structure on the full QDM.  Its
   weakness is the absence of a general global mirror model.
5. **Cusp-groupoid invariant.**  Define an invariant from all exceptional-cusp
   point rows and prove independence under changing cusps.  This is attractive
   formally but likely repackages the same Stokes matrix; treat it as a
   falsification target, not the primary route.
6. **Compute the first hostile example.**  Calculate the large-radius-to-cusp
   point row for a simple nontoric blow-up, or first reproduce it for
   \(\operatorname{Bl}_p\mathbf P^2\).  A nonzero center entry would kill the
   universal one-row conjecture; a structural zero would reveal the missing
   proof mechanism.  This is the cheapest decisive experiment.

## Mystery ledger

- **Settled by AA/EJ/TT:** the apparent Gold proof did not fail in weak
  factorization, Kunneth, or the cohomological point calculation.  It failed
  at the unnamed change from the large-radius Gamma frame to the exceptional
  Laurent-cusp frame.
- **Open — universal zero or first counterexample:** whether the center row of
  the central connection matrix always kills the point column.  Owner: the
  explicit hostile blow-up computation and the one-column analytic routes
  above.
- **Open — degeneration invariance:** whether that row is preserved when an
  arbitrary rank-two normal bundle is birationally split and deformed to its
  associated graded.  Owner: the C907 `m=2` point-purity gluing lemma.
- **Open — publication strength:** the universal cusp lemma plus the
  two-completion obstruction is a solid section; a standalone note should add
  either a larger verified geometric family or an explicit nonzero
  frame-change coefficient.  No stronger novelty claim has been made.

## Sources

- Hiroshi Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3,
  especially (1.1), Remark 1.5, Remark 5.10, Theorem 5.18, (5.44), and
  Section 5.8.2.  Cached text SHA-256 prefix: `c16f56`; exact cache audit
  recorded on 2026-08-13.
- Hiroshi Iritani, *Gamma classes and quantum cohomology*,
  arXiv:2307.15938v1, Section 1.2.  Cached text SHA-256 prefix: `462f`.
