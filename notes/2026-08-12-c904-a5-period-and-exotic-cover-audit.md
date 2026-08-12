# C904: \(A_5\) cubic period line and exotic marking cover

Date: 2026-08-12  
Scope: bounded audit of the cached exact certificates and primary-source
ledger; no manuscript, PDF, Lean, or commit change.

## Executive verdict

The exact modular picture has three different objects which must not be
collapsed:

1. the unmarked \(A_5\)-cubic parameter line is the coarse \(X_0(3)\) line
   for the rank-two elliptic multiplicity system;
2. the three classical two-primary slopes form the degree-three
   \(X_0(6)\to X_0(3)\) cover; and
3. the two exotic \(A_5\) slopes form a separate degree-two discriminant
   cover \(r^2=T\), branched at the two \(X_0(3)\) cusps.

Thus the exotic marking cover is **not** \(X_0(6)\). \(X_0(6)\) is the
classical three-slope resolvent. The two resolvents come from one \(S_3\)
two-division extension; their degree-six fibre product is rational.

The full polarized intermediate-Jacobian assertion needs one qualification:
the cached exact calculation proves the \(X_0(3)\) elliptic-factor/projective
period system and the formulas below. Hartlieb and van Geemen--Yamauchi supply
the \(A_5\) family and \(J(X)\sim E^5\), but do not by themselves identify the
integral principal-polarization local system with \(X_0(3)\). Calling the
full IJ period locus \(X_0(3)\) is therefore a theorem-grade conclusion only
after the integral \(A_5\)-symplectic lattice gate is written out.

## 1. The \(X_0(3)\) coordinate

Let \(t\) be the signed parameter in the \(A_5\)-invariant cubic pencil. The
outer normalizer fixes the power-sum generator and negates the second
invariant, so \(t\sim -t\) on the unmarked cubic moduli. Put

\[
 s=t^2,\qquad T=81s=81t^2.
\]

The exact Fourier/Prym computation in the cached A5 pencil certificate gives

\[
 J(T)=j(E_T)=\frac{(T+27)(T+3)^3}{T}
       =\frac{9(3s+1)(27s+1)^3}{s}.
\]

This is the standard Hauptmodul map \(X_0(3)\to X(1)\), realized by the Tate
normal form

\[
 E_T:\quad y^2+(T+27)xy+(T+27)^2y=x^3,
\]

with \(P=(0,0)\) of order three. The quotient by \(\langle P\rangle\) has

\[
 j(E_T/\langle P\rangle)
 =\frac{(T+27)(T+243)^3}{T^3}=J(729/T).
\]

Consequently:

- the signed \(t\)-line maps with degree \(2\) to the \(X_0(3)\) line;
- the unmarked \(s=t^2\) line maps with degree \(1\);
- \(J(T)\) itself has degree \(4=[\mathrm{SL}_2(\mathbf Z):\Gamma_0(3)]\)
  to the \(j\)-line.

The \(X_0(3)\) passport is

\[
\begin{array}{c|c}
\text{point on the \(T\)-line}&\text{behavior of \(J\)}\\ \hline
T=0&\text{cusp, pole order \(1\)}\\
T=\infty&\text{cusp, pole order \(3\)}\\
T=-27&j=0,\ \text{zero order \(1\)}\\
T=-3&j=0,\ \text{zero order \(3\)}\\
T^2+18T-27=0&j=1728,\ \text{ramification order \(2\) at each point}.
\end{array}
\]

The associated projective Picard--Fuchs equation is

\[
 f''+\frac1T f'-\frac{6}{T(T+27)^2}f=0,
\]

the pullback of the \({}_2F_1(1/3,2/3;1;T/(T+27))\) system. The actual Prym
system is the quadratic twist by

\[
 D(T)=(T+27)(T-729/5).
\]

The twist adds scalar \(-I\) at the chordal point \(T=729/5\). At the local
system level this changes the integral lift from \(\Gamma_1(3)\) to

\[
\langle\Gamma_1(3),-I\rangle=\Gamma_0(3),
\]

without changing the coarse \(X_0(3)\) curve. This is a stack/local-system
distinction, not a second coarse modular base.

## 2. Cubic boundary versus modular cusps

The exact \(T\)-boundary values of the cubic pencil are

\[
\begin{array}{c|c}
T&\text{cubic boundary}\\ \hline
\infty&\text{six singular points}\\
0&\text{ten singular points}\\
-27&\text{five \(A_2\) points}\\
729/5&\text{chordal cubic}.
\end{array}
\]

Only \(0\) and \(\infty\) are modular cusps of \(X_0(3)\). In particular,
\(T=-27\) is an interior stack/orbifold point for the elliptic system despite
being a cubic boundary value, and \(T=729/5\) is an interior point with scalar
\(-I\) Prym monodromy, not a cusp. The smooth Fricke partner \(T=5\) is also
interior. Fricke is

\[
 w_3(T)=729/T,
\]

and exchanges \(0\leftrightarrow\infty\), fixes \(-27\), and exchanges
\(729/5\leftrightarrow5\).

## 3. The exotic degree-two marking cover

At \(2\), the \(A_5\)-stable principal gluings are

\[
\mathbf P^1(\mathbf F_4)
 =\mathbf P^1(\mathbf F_2)\sqcup\{\omega,\omega^2\}.
\]

The first summand has three classical slopes and the second is the exotic
pair. Generic two-division monodromy is \(S_3=\mathrm{GL}_2(\mathbf F_2)\),
with orbit sizes \(3+2\). The exact two-division discriminant of the Tate
model is

\[
\operatorname{disc}(f_2)=16T(T+27)^8,
\]

so the square-class cover which marks one of the two exotic slopes is

\[
\boxed{r^2=T.}
\]

Its compactification is \(\mathbf P^1_r\to\mathbf P^1_T\), degree \(2\), with
ramification index \(2\) exactly over \(T=0\) and \(T=\infty\). These are
the two \(X_0(3)\) cusps. The pulled-back cusp widths are therefore \(2\)
over the width-one cusp \(T=0\), and \(6\) over the width-three cusp
\(T=\infty\). The interior cubic boundaries split unramifiedly:

\[
r=\pm\sqrt{-27}\quad(T=-27),\qquad
r=\pm\sqrt{729/5}\quad(T=729/5).
\]

This is the minimal cover that marks one exotic gluing. It is a quadratic
discriminant/resolvent cover, not a claim that the exotic family itself is a
new congruence modular curve.

## 4. The classical degree-three \(X_0(6)\) cover

The three rational slopes are the degree-three resolvent. In a rational
coordinate \(y\), the exact map is

\[
\boxed{T=-\frac{(4y+3)(y+3)^2}{(y+1)^2}.}
\]

It is the standard forgetful map \(X_0(6)\to X_0(3)\). Its four source
cusps and widths are

\[
\begin{array}{c|c|c|c}
y&T&\text{source width}&\text{ramification over \(T\)}\\ \hline
-3&0&2&2\\
-3/4&0&1&1\\
-1&\infty&6&2\\
\infty&\infty&3&1.
\end{array}
\]

Thus the map is branched only at the two base cusps, with type \(2+1\) over
each. The source cusp widths are \(1,2,3,6\), as required for \(X_0(6)\).
For the quartic parameter \(t_q\), the exact Hauptmodul change is

\[
y(t_q)=-\frac{2t_q+1}{6t_q-1},
\qquad
T(t_q)=-\frac{80}{3}
\frac{(t_q-\frac7{10})(t_q-\frac14)^2}
     {(t_q-\frac16)(t_q-\frac12)^2}.
\]

The \(X_0(6)\) interpretation is theorem-grade for the resolved
\(S_6\)-quartic period locus after the integral root--weight lattice
argument. It should not be transferred to the exotic cubic marking cover.

## 5. Common \(S_3\) splitting cover

The degree-two exotic and degree-three classical covers are the two resolvents
of the same two-division extension. Their fibre product is rational. With

\[
y=-\frac{u^2+3}{4},
\]

one has

\[
 T=\frac{u^2(9-u^2)^2}{(1-u^2)^2},
\qquad
 r=\frac{u(9-u^2)}{1-u^2}.
\]

This is a degree-six rational cover of the \(T\)-line. Over the two base
cusps it has three points of ramification index \(2\) each; in the pulled-back
elliptic widths this gives three width-\(2\) points over \(T=0\) and three
width-\(6\) points over \(T=\infty\). The \(3+2\) decomposition is the
resolvent decomposition of this \(S_3\) cover, not evidence that the cubic
period base is \(X_0(6)\).

## 6. Theorem-grade versus inference

**Theorem-grade in the cached record:**

- the exact \(j\)-formula and \(T=81t^2\) change, checked symbolically from
  the van Geemen--Yamauchi normal form;
- the universal order-three Tate model and explicit Vélu isogeny;
- the \(X_0(3)\) passport, Fricke map, and the exact \(D(T)\) twist;
- the \(2\)-division discriminant square class and cover \(r^2=T\);
- the degree-three root-cover formula and cusp ramification arithmetic;
- the \(X_0(6)\) period-locus identification for the \(S_6\)-quartic, subject
  to the stated integral root--weight lattice proof.

**Still a gate or inference:**

- identifying the *full polarized* \(A_5\)-cubic intermediate-Jacobian
  variation, rather than its rank-two elliptic/projective factor, with
  \(X_0(3)\);
- a canonical degree-\(3^5\) isogeny \(E^5\to J(X)\) over the whole pencil;
- interpreting the \(r^2=T\) cover as a geometric family of cubic
  threefolds with a globally chosen integral principal polarization;
- any claim that the exotic cover is itself \(X_0(N)\) for an unnamed level.

Hartlieb (arXiv:2304.03214) supplies the one-dimensional irreducible
\(A_5\) locus and \(J(X)\sim E^5\); van Geemen--Yamauchi
(arXiv:1506.05346) supply the Prym normal form and \(j\)-map; Carocca--
González-Aguilera--Rodríguez (arXiv:math/0503340) supply the classical
root/weight \(X_0(6)\) family; and Looijenga--Zi (arXiv:2109.01810) supply
the Winger \(\Gamma_1(3)\) comparison. None of these primary sources, as
recorded in the cached audit, states the full cubic \(X_0(3)\) or exotic-cover
identification in this exact form.

The bounded source search found no additional direct source for that
combination. This licenses only “no direct source located in the bounded
audit,” not an unconditional novelty or firstness claim.
