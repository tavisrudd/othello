# C904 theta normalization and Shen-relative circularity audit

**Date:** 2026-08-10
**Scope:** targeted primary-source audit; no manuscript, Lean, or commit change

## Executive verdict

There are two separate conclusions.

1. **The theta normalizations are compatible.**  After choosing a line
   \(\ell_0\), normalize the Fano Abel--Jacobi embedding by
   \(\phi(\ell)=AJ(\ell-\ell_0)\).  Then \(0=\phi(\ell_0)\in F\),
   Clemens--Griffiths gives
   \(\Theta=F-F\), and consequently
   \(F\subset\Theta\) and
   \(\operatorname{Sym}^2F\subset\operatorname{Sym}^2\Theta\).
   Voisin's theta for rational cubics is only fixed up to translation, so on
   an individual cubic it may be chosen to be this same \(F-F\).  No checked
   source blocks that convention.
2. **The asserted degree-one strict transform of Shen's specific \(\eta\) is
   not yet a theorem.**  The map
   \(\operatorname{Sym}^2F\to D_+\) is proper birational, so every component
   of \(\eta\) meeting its isomorphism locus has a degree-one unordered
   strict transform.  Shen does not prove that his existential cycle avoids
   the exceptional image, nor construct a global
   \(\bar\eta\in CH_1(\operatorname{Sym}^2F)\) with pushforward \(\eta\).
   Thus the inclusion into \(\operatorname{Sym}^2\Theta\) is valid once that
   lift is supplied, but does not itself supply the lift.

There is also a decisive logical obstruction: Shen obtains \(\eta\) by
assuming universal \(CH_0\)-triviality, equivalently a Chow-theoretic
decomposition of the diagonal in the step he uses.  His construction cannot
be used to prove the desired relative identity/decomposition without
circularity.  A common line fixes the torsor normalization; it does not
construct the conditional cycle.

## 1. Common-line normalization

Let \(X\) be a smooth cubic threefold and \(F=F(X)\).  Choose
\(\ell_0\in F\) and set

\[
 \phi:F\longrightarrow J(X),\qquad
 \phi(\ell)=AJ(\ell-\ell_0).
\]

Then \(\phi(\ell_0)=0\).  Clemens--Griffiths define the difference map

\[
 F\times F\longrightarrow J(X),\qquad
 (\ell_1,\ell_2)\longmapsto\phi(\ell_1)-\phi(\ell_2).
\]

Their extracted-text lines **5507--5523** say that its image is an even
divisor independent of the Abel--Jacobi basepoint, and lines **5532--5536**
(Theorem 13.4) identify its class with the principal polarization.  Hence it
is a theta divisor, which we may and will denote

\[
 \Theta:=F-F.
\]

Because \(0\in F\), every \(f\in F\) equals \(f-0\), so

\[
 F\subset F-F=\Theta.
\]

This immediately gives the closed inclusion

\[
 \operatorname{Sym}^2F\subset\operatorname{Sym}^2\Theta.
\]

This is an honest geometric inclusion, not merely a cohomology-class
identification.

## 2. Compatibility with Voisin's rational-cubic theta

Harris--Roth--Starr extracted-text lines **215--223** state the relevant
convention explicitly: choosing a different base cycle changes an
Abel--Jacobi morphism by a constant translation, and Abel--Jacobi is additive
under sums of cycle families.  Their Corollary 4.3, lines **660--667**, proves
that the rational-cubic map dominates **a translate** of the theta divisor and
is birationally a \(\mathbf P^2\)-bundle over it.

Voisin suppresses that harmless absolute translation in Section 2.  Her
extracted-text lines **497--513** call the rational-cubic image \(\Theta\), put
the two component values of \(D_{3,3}\) in
\(\operatorname{Sym}^2\Theta\), and use the sum map to \(J(X)\).

Therefore, on a fixed cubic, translate the degree-three Abel--Jacobi map so
that its image is the symmetric theta \(F-F\).  Translate the degree-six
target by twice the same constant.  Additivity is preserved, so Voisin's
factorization remains

\[
 D_{3,3}\dashrightarrow\operatorname{Sym}^2(F-F)
 \xrightarrow{+}J(X).
\]

There is no priority or convention conflict: HRS print “a translate,” and
Voisin's use of \(\Theta\) has already chosen such a translation.

## 3. Relative torsors and what the common line fixes

Voisin extracted-text lines **171--190** formulate degree-\(d\) Abel--Jacobi
values in the Deligne torsor \(J(X)_{d[\ell]}\), not canonically in \(J(X)\).
Lines **206--214** explicitly warn that fixed-fibre translations need not
globalize because relative torsors can be nontrivial.

If the marked family carries a genuine relative line
\(\ell_0\subset\mathcal X/B\), that warning is neutralized for the present
degrees: subtracting \(d\ell_0\) identifies every degree-\(d\) torsor with the
relative Jacobian.  The relative difference divisor

\[
 \Theta_B=\mathcal F-\mathcal F
\]

is then defined without choosing a theta characteristic and contains
\(\mathcal F\) through the zero section \(\ell_0\).

The rational-cubic image may initially be a relative translate
\(t+Theta_B\).  After shrinking the smooth base, its divisor line bundle and
the principal polarization determine the translation section \(t\); translating
the degree-three target by \(-t\) and the degree-six target by \(-2t\) restores
Voisin's additive diagram with \(\Theta_B=\mathcal F-\mathcal F\).

The primary sources establish the absolute translation freedom and the need
to track relative torsors.  The last relative alignment is a standard
relative-Picard inference, not a theorem stated verbatim in HRS or Voisin.  It
requires the relative cubic image divisor to be flat after shrinking; no
checked source presents an obstruction once the relative line exists.

## 4. Does Shen's \(\eta\) lift degree one to
\(\operatorname{Sym}^2F\)?

Shen Lemma 5.6 proves that

\[
 F\times F\xrightarrow{\phi_+}D_+=F+F
\]

has generic degree two.  Since swapping the two factors already gives two
generic preimages, the induced map

\[
 \bar\phi_+:\operatorname{Sym}^2F\longrightarrow D_+
\]

is proper birational.

This proves the proposed degree-one statement on the birational locus.  If an
integral component \(C\) of \(\eta\) is not contained in the exceptional image,
its strict transform \(\bar C\) satisfies

\[
 (\bar\phi_+)_*[\bar C]=[C].
\]

Then \(\bar C\subset\operatorname{Sym}^2F\subset
\operatorname{Sym}^2\Theta\), exactly as proposed.

But Proposition 5.7 defines \(\eta\) only through

\[
 (\phi_+)_*\widetilde\theta=2\eta.
\]

It gives no representative, positivity, mobility, or exceptional-locus
avoidance for \(\eta\).  A proper birational morphism need not push every
integral cycle supported in its exceptional image with coefficient one.
Consequently the unconditional source-faithful statement is:

> Shen's \(\eta\) has a degree-one unordered strict transform componentwise
> wherever it meets the birational locus; a global integral lift of the whole
> cycle to \(\operatorname{Sym}^2F\) remains an extra lemma.

If that lemma is proved, the inclusion into Voisin's
\(\operatorname{Sym}^2\Theta\) is immediate from the common-line
normalization.

## 5. Relative circularity

Shen Proposition 5.7 begins with the assumption that \(CH_0(X)\) is
universally trivial.  It invokes Theorem 5.1, whose threefold proof begins
with a Chow-theoretic decomposition of the diagonal and then uses universal
generation by lines to manufacture the symmetric cycle on \(F\times F\).
The minimal cycle \(\eta\) is the final output of that chain.

Hence the following proposed proof is circular:

\[
 \text{use Shen's }\eta
 \Longrightarrow \text{odd carrier in }D_{3,3}
 \Longrightarrow \text{relative identity/universal cubic cycle}
 \Longrightarrow \text{decomposition of the diagonal}.
\]

The first arrow already assumes the last conclusion.

Nor does fibrewise existence solve the relative problem:

- a cycle on one complex fibre does not spread across a non-isotrivial base;
- a decomposition over the geometric generic fibre spreads only after some
  finite base change;
- norm/descent back to the original function field multiplies the diagonal
  identity by the extension degree, whose parity is uncontrolled;
- Shen's choices of auxiliary curves and lifted correspondences are not
  canonical and are not assembled into a relative construction in the paper.

If a relative Chow decomposition were independently available, Shen's
construction could be repeated generically and spread after shrinking, but
then it would verify consequences of the desired identity rather than prove
it.

The noncircular high-EV target is therefore an explicit relative cycle
\(\bar\eta\subset\operatorname{Sym}^2\mathcal F\) constructed from the marked
geometry **without** invoking universal \(CH_0\)-triviality.  Shen can then be
used to recognize its pairing/class, not to establish its existence.

## 6. Source ledger

1. **C. Herbert Clemens and Phillip A. Griffiths, _The intermediate Jacobian
   of the cubic threefold_, Ann. of Math. 95 (1972), 281--356.**  Read depth:
   **claim-specific partial**, Section 13 through Theorem 13.4.  Cache key
   `10.2307/1970801`, SHA-256
   `6cfe96ecb81179ce2756cb114414d3db1eab46274665c96c582d7f42c7a60a60`.
2. **Joe Harris, Mike Roth and Jason Starr, _Abel--Jacobi maps associated to
   smooth cubic threefolds_, arXiv:math/0202080.**  Read depth:
   **claim-specific partial**, Abel--Jacobi normalization in Section 1 and
   Theorem 4.2/Corollary 4.3.  Cache SHA-256
   `fae17135016e77425060e8c0860c9938facda3144ac1cd091a853d34c337d3ec`.
3. **Claire Voisin, _Abel--Jacobi map, integral Hodge classes and
   decomposition of the diagonal_, arXiv:1005.5621.**  Read depth:
   **claim-specific partial**, Deligne torsors in the introduction and the
   \(D_{3,3}\) construction in Section 2.  Cache SHA-256
   `ca7103f6529128a24425dbfc1c87589402b17b12719329239fccdb590f74b547`.
4. **Mingmin Shen, _Rationality, universal generation and the integral Hodge
   conjecture_, arXiv:1602.07331.**  Read depth: **claim-specific partial**,
   Theorem 5.1, Lemma 5.6 and Proposition 5.7 with proofs.  Cache SHA-256
   `2e0f3a438379830b85e0e63fce9b6d85e621c3e3d1fbbe84a4a6117773c1007c`.

## 7. Mystery ledger

- **Settled:** \(F\subset F-F=\Theta\) after common-line normalization.
- **Settled:** Voisin's rational-cubic theta can be translated to this same
  divisor on each fibre; additivity merely translates the degree-six target
  twice.
- **Settled conditionally in families:** a relative line trivializes the
  degree torsors; the remaining relative theta translation is a Picard
  section after shrinking.
- **Open:** whether every component of Shen's existential \(\eta\) meets the
  birational locus of \(\operatorname{Sym}^2F\to D_+\), or otherwise has an
  integral degree-one lift.  This is not controlled by the sources.
- **Settled negatively:** Shen's construction cannot be the noncircular source
  of a relative identity; it assumes universal \(CH_0\)-triviality.
- **Open/high EV:** construct the needed unordered cycle directly from the
  marked \(A_5\) geometry and only then use Shen's pairing calculation as a
  recognition theorem.

**Vibe:** the normalization upgrade is real and useful, but it removes only a
translation/torsor nuisance.  It does not remove either the exceptional-locus
integrality gate or the fundamental circularity in sourcing \(\eta\) from
Shen.
