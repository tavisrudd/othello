# C509 — PRS(q−6) redundancy-seven entry geometry

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** literature gate and \(q\ge37\)
existence/orbit theorem complete; bounded-field orbit-reduced calibration open

## Entry verdict

The claim-specific audit
[`2026-07-23-c509-prs-redundancy-seven-literature-audit.md`](2026-07-23-c509-prs-redundancy-seven-literature-audit.md)
finds no pre-emption, subject to its explicit MathSciNet and toolkit-search caveats.  The scalar
covering radius is not the novelty target; the deep-syndrome and orbit classification is.

## Exact pointed polar reduction

Let \(f=(a_0,\ldots,a_6)\) be a binary sextic syndrome and
\[
H_f=\begin{pmatrix}
a_0&a_1&a_2&a_3&a_4&a_5\\
a_1&a_2&a_3&a_4&a_5&a_6
\end{pmatrix}.
\]
Its kernel \(W_f\) is a vector-space web of binary quintics.  For \(r\in\mathbf F_q\), multiply a
quartic \(g=\sum_{j=0}^4d_jt^j\) by \(t-r\).  Direct coefficient collection gives
\[
H_f((t-r)g)=H_{b(r)}g,\qquad
b(r)=(a_1-ra_0,\ldots,a_6-ra_5).                         \tag{1}
\]
At infinity the contraction is \(b(\infty)=(a_0,\ldots,a_5)\).  Hence the contractions trace
\[
\ell_f=\mathbf P\langle(a_0,\ldots,a_5),(a_1,\ldots,a_6)\rangle
\subset\mathbf P^5.                                      \tag{2}
\]

Equation (1) proves the pointed criterion:

> \(f\) is not deep if and only if some \(r\in\mathbf P^1(\mathbf F_q)\) has a totally split
> squarefree quartic in the C498 net \(W_{b(r)}\) which does not vanish at \(r\).

The final clause is essential: multiplying a quartic already containing \(r\) creates a repeated
root.  This is the exact new gate, not ordinary C498 split-member existence.

## Lines contained in the C498 secant closure

Form the sextic catalecticant
\[
C_f=\begin{pmatrix}
a_0&a_1&a_2&a_3&a_4\\
a_1&a_2&a_3&a_4&a_5\\
a_2&a_3&a_4&a_5&a_6
\end{pmatrix}.
\]
The C498 catalecticant of \(b(r)\) is
\[
C_{b(r)}=C_fM(r),
\]
where \(M(r)\) is the full-rank \(5\times4\) bidiagonal multiplication/contraction matrix.
If \(\operatorname{rank}C_f\le2\), every point of \(\ell_f\) lies in C498's catalecticant
rank-at-most-two secant closure.
Conversely, if \(\operatorname{rank}C_f=3\), its two-dimensional kernel would have to lie in
\(\operatorname{im}M(r)\) for every geometric \(r\).  The intersection of all these
factor hyperplanes is zero, a contradiction.  Therefore
\[
\ell_f\subset\{\text{C498 catalecticant rank at most two}\}
\quad\Longleftrightarrow\quad
\operatorname{rank}C_f\le2.                              \tag{3}
\]
Rank two has three rational forms: a secant through two rational NRC points, a tangent, or a
secant through a conjugate quadratic pair.  The first is shallow because its common quadratic
splits into two distinct rational factors; the latter two are exactly redundancy seven's
persistent quadratic-gcd deep stratum.  Thus the common quadratic remains quadratic at the next
redundancy, but one must remove both the rank-one NRC and the rational-split secants.  The total
number of persistent deep syndrome points is again
\[
\frac{q(q+1)^2}{2}.
\]

## Persistent orbit arithmetic

The C498 fifth-power law generalizes with the sextic degree \(6\).  On an irreducible-quadratic
fibre, let \(T\) be the norm-one torus and
\[
d=\gcd(6,q+1).
\]
The nonsplit torus acts through \(z\mapsto z^6\), so PGL orbits are inversion-orbits in
\(T/T^6\cong C_d\).  A class fixed by inversion gives
\[
(|O|,|\operatorname{Stab}|)=
\left(\frac{q(q^2-1)}{2d},\,2d\right),
\]
while a paired class gives
\[
(|O|,|\operatorname{Stab}|)=
\left(\frac{q(q^2-1)}d,\,d\right).
\]
There are \(1+\mathbf1_{2\mid d}\) fixed classes and the remaining classes pair, for a total of
\(\lfloor d/2\rfloor+1\) sigma orbits.  Frobenius acts by multiplication by \(p\) on \(C_d\),
followed by the same inversion quotient.

On the tangent fibre, the Borel translation term is multiplied by \(6\).  Thus it is transitive
when \(p\nmid6\), giving
\[
(q(q+1),q-1).
\]
In characteristics two and three it has a fixed point and a transitive nonzero part, giving
\[
(q+1,q(q-1)),\qquad(q^2-1,q).
\]
These formulas are the first cheap C509 theorem.  The independent replay enumerates the full
sextic catalecticant rank-two locus, removes the rational-split secants, closes the remainder under
\(PGL_2(q)\), and verifies every size, stabilizer, and Frobenius-cycle formula at
\[
q=4,5,7,8,9.
\]
These fields realize \(d=1,2,3,6\) and both modular characteristics.

## Pointed C498 upgrade on the trivial-gcd stratum

C498's \(q\ge29\) proof can absorb one additional forbidden root at a small cost.  Fix a
trivial-gcd quartic net \(W\) and a point \(x\).  Choose the prospective first factor \(s\ne x\).
On an \(S_3\) C491 fibre the lower bound is
\[
\#Y(\mathbf F_q)\ge q-2\sqrt q.
\]
C498's diagonal and branch deletion costs at most twelve ordered pairs, and excluding a cubic
through \(s\) costs at most six.  Excluding a cubic through the additional point \(x\) costs at
most six more.  Therefore
\[
q-2\sqrt q>24                                             \tag{4}
\]
produces a split squarefree quartic avoiding \(x\); (4) holds for every \(q\ge37\).

The lower exceptional-fibre budgets are unchanged: \(3+4+6=13\) in ordinary characteristic,
the same secant/wild/ramification budget in characteristic three, and \(3+1+6=10\) off
\(\mathcal N_3\) in characteristic two.  There is room to choose \(s\ne x\) throughout the
\(q\ge37\) range.  Hence:

> **Pointed trivial-gcd lemma.**  For \(q\ge37\), every trivial-gcd C498 net outside the
> characteristic-two nucleus line has a totally split squarefree quartic avoiding any prescribed
> point of \(\mathbf P^1(\mathbf F_q)\).

### The gcd-one pointed lemma

Suppose instead that a contracted net has exact gcd \(\ell_x\):
\[
W_{b(r)}=\ell_xU,\qquad \dim U=3,
\]
where \(U=\ker\lambda\) is a hyperplane of binary cubics.  If \(x=r\), every lift has a repeated
root and this parameter is genuinely bad.  If \(x\ne r\), put
\[
S=\mathbf P^1(\mathbf F_q)\setminus\{x,r\}.
\]
For each ordered distinct \(u,v\in S\), the expression
\[
\lambda(\ell_u\ell_v\ell_w)
\]
is linear in \(w\).  If it vanishes identically, any
\(w\in S\setminus\{u,v\}\) is a witness.  Otherwise it has a unique rational zero \(w\), which is
bad only when \(w\in\{x,r,u,v\}\).

The conditions \(w=x,r\) are nonzero divisors of bidegree \((1,1)\) in \((u,v)\); if either
vanished identically, \(U\) would have the corresponding common factor and \(W_{b(r)}\) would have
gcd at least two.  The conditions \(w=u,v\) have bidegrees \((2,1)\) and \((1,2)\), and cannot
vanish identically because the cubics with a double root span \(\operatorname{Sym}^3\).
A nonzero bidegree-\((a,b)\) form has at most \((a+b)(q+1)\) rational zeros.  Hence all four bad
sets cover at most
\[
2(q+1)+2(q+1)+3(q+1)+3(q+1)=10(q+1)
\]
ordered pairs.  Since
\[
(q-1)(q-2)>10(q+1)\qquad(q\ge16),
\]
some cubic in \(U\) has three distinct roots avoiding \(x,r\).  Multiplication by \(\ell_x\)
gives a split squarefree quartic avoiding \(r\).

Thus, for the \(q\ge37\) range, the only bad gcd-one parameter is \(x=r\).  Intrinsically this says
that every section of the \(g^3_5\) web \(W_f\) vanishing at \(r\) vanishes twice there: \(r\) is a
ramification point.  After removing any fixed divisor, the ramification degree is
\[
(3+1)(5-3)=8
\]
or smaller.  The moving series is separable in every characteristic: an inseparable
four-dimensional series of degree at most five would have to lie in the at-most-three-dimensional
space of \(p\)-th-power sections.  Therefore there are at most eight such marked self-collisions.

## Characteristic-two contained nucleus

C498's recurring cyclic component is
\(\mathcal N_3=\mathbf P\langle e_2,e_3\rangle\).  Requiring both consecutive sextic rows in (2)
to lie in \(\mathcal N_3\) forces
\[
a_0=a_1=a_2=a_4=a_5=a_6=0.
\]
Hence
\[
\ell_f\subset\mathcal N_3\quad\Longleftrightarrow\quad f=e_3.       \tag{5}
\]
So the C498 nucleus line contracts at redundancy seven to the central sextic nucleus point.  Its
web is
\[
W_{e_3}=\langle1,t,t^4,t^5\rangle.
\]
If \(m\) is odd, any split quintic would contract at one of its roots to a split quartic on the
deep C498 nucleus line, impossible.  If \(m\) is even, \(\mathbf F_4\subset\mathbf F_{2^m}\) and
\[
t^4+t
\]
has the four affine roots of \(\mathbf F_4\), plus the root at infinity as a binary quintic.
Therefore the central point is deep exactly when \(m\) is odd.  The replay checks both directions
at \(q=4,8\).

## High-field theorem

Assume first that \(\ell_f\) is not contained in the C498 secant closure and, in characteristic
two, is not the nucleus line.  At most three contraction parameters meet the secant closure, at
most eight are marked gcd-one ramification points, and at most one meets the characteristic-two
nucleus line.  Every remaining contraction has either trivial gcd, where the \(q\ge37\) pointed
lemma applies, or gcd one with a different common root, where the bidegree argument applies.
Since
\[
3+8+1=12<q+1,
\]
one parameter lifts to a split squarefree quintic.

If the line is contained in the secant closure, equation (3) applies.  Rank-one points and rational
split secants are shallow; tangent and conjugate-sigma points are exactly the persistent deep
stratum.  In characteristic two, the only line contained in the C498 nucleus is the central point
\(e_3\), already classified above.  Consequently:

> **Redundancy-seven high-field theorem.**  For every prime power \(q\ge37\), the deep syndromes of
> \(PRS(q-6)\) are exactly the persistent tangent/sigma stratum, together with the fixed central
> nucleus point \(e_3\) when \(q=2^m\) and \(m\) is odd.

Their number is
\[
\frac{q(q+1)^2}{2}
+\begin{cases}
1,&q=2^m,\ m\ {\rm odd},\\
0,&\text{otherwise}.
\end{cases}
\]
The complete high-field \(PGL_2/P\Gamma L_2\) orbit law is the \(T/T^6\) formula above, with the
central point as one additional fixed orbit when present.

## Successor forecast: redundancies eight and nine

The proof now iterates at high \(q\).  Redundancy eight has a first-polar line in C509 syndrome
space; redundancy nine has one in the eventual redundancy-eight space.  Each extra level adds one
forbidden chosen root to the bottom C491 \(S_3\) fibre, hence at most six ordered pairs.  The
provisional fibre inequalities are
\[
\begin{array}{c|c|c}
\text{redundancy}&\text{bottom deletion}&\text{first prime-power threshold}\\ \hline
8&12+3\cdot6=30&q\ge47,\\
9&12+4\cdot6=36&q\ge53.
\end{array}
\]
These are forecasts, not yet theorems: each level still needs its pointed gcd-one hyperplane lemma
and contained-polar classification.  The ramification degrees remain small:
\[
\deg R(g^4_6)=5(6-4)=10,\qquad
\deg R(g^5_7)=6(7-5)=12.
\]
The persistent orbit quotients are predicted without new invariant theory:
\[
T/T^7\quad(r=8),\qquad T/T^8\quad(r=9),
\]
modulo inversion and Frobenius, with modular tangent splitting when the characteristic divides
\(7\) or \(8\).

Thus high-field redundancy eight is the next plausible theorem after C509, and redundancy nine
should require one additional inductive layer.  Their all-field classifications are not yet cheap:
the bounded exceptional census grows in \(\mathbf P^7\) and \(\mathbf P^8\), so it must be
orbit-reduced rather than exhaustive.

## Next gate

C509's remaining work is bounded-field calibration below 37 and intrinsic compression of any
exceptional webs found there.  Orbit-reduced enumeration should now use the proven high-field
strata rather than scan all of \(\mathbf P^6\).

No full \(\mathbf P^6\) census is needed for these steps.

## Mystery ledger

Settled:

- **Does the persistent common-factor degree grow?** No.  After removing rational-split secants,
  catalecticant containment (3) again gives a quadratic common factor.
- **What replaces C498's fifth-power splitting?** The quotient \(T/T^6\), modulo inversion and
  Frobenius.
- **Does the C498 nucleus line lift to a large linear family?** No.  Consecutive-row overlap
  collapses it to the single central sextic point \(e_3\).
- **When is that central point deep?** Exactly over \(\mathbf F_{2^m}\) with odd \(m\); for even
  \(m\), \(t^4+t\) supplies the five roots \(\mathbf P^1(\mathbf F_4)\).
- **Can C498's theorem avoid one more prescribed root?** Yes on the trivial-gcd stratum for
  \(q\ge37\), by raising the fibre deletion budget from eighteen to twenty-four.
- **What happens on gcd-one contractions?** If the common root differs from the marked point, a
  bidegree union bound gives a split lift for \(q\ge16\).  Equality with the marked point is
  \(g^3_5\) ramification, of total degree at most eight.
- **Does this close all high fields?** Yes.  For \(q\ge37\), only the persistent tangent/sigma
  stratum and the odd-degree characteristic-two central point remain deep.

Open:

- **Small-field exceptions.** No search is authorized until the contained-line and pointed
  divisors reduce the orbit space.  Those reductions are now complete; owner: C509's
  orbit-reduced \(q<37\) calibration.

## Artifacts

- `2026-07-23-c509-prs-redundancy-seven.md` — this report.
- `2026-07-23-c509-prs-redundancy-seven-literature-audit.md` — claim-specific entry audit.
- `2026-07-23-c509-prs-redundancy-seven-replay.py` — independent persistent-orbit and central-point
  replay.
- `2026-07-23-c509-prs-redundancy-seven.sha256` — evidence manifest.
