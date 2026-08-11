# C904: the $M_9$/Bridgeland anticanonical route has a class obstruction

Date: 2026-08-11

Status: theorem-grade negative gate and conditional index lemma; quarantined
Paper V research only; no manuscript or Lean change

Scope: Voisin's classical charge-three moduli space, the primitive
Kuznetsov-component moduli spaces of Li--Lin--Pertusi--Zhao, the determinant
canonical line on the fine bundle locus, and the proposed fourth
self-intersection shortcut

## Executive verdict

There is no ``fine primitive Bridgeland model of $M_9$'' to which the Fano
fibre theorem of Li--Lin--Pertusi--Zhao can presently be applied.  The
obstruction is numerical, not terminological.

For an elliptic sextic $C\subset X$, Voisin's Serre bundle $A$ satisfies

\[
  0\longrightarrow {\cal O}_X\longrightarrow A
    \longrightarrow I_C(2h)\longrightarrow0,
  \qquad \operatorname {ch}(A)=(2,2h,0,-2p).
\]

Its normalized charge-three twist is

\[
             E=A(-h),\qquad \operatorname {ch}(E)=(2,0,-3l,0).
\]

Li--Lin--Pertusi--Zhao's own table sends the elliptic-sextic ideal object
$I_C(2h)$ to the **nonprimitive** Kuznetsov class $-3\alpha$.  Projection
kills ${\cal O}_X$, so the same is true of $A$.  More decisively, every
Kuznetsov class $v=n\alpha+m\beta$ has

\[
 -\chi(v,v)=n^2+nm+m^2\equiv0\text{ or }1\pmod 3.
\]

A smooth stable-object moduli space has dimension $1-\chi(v,v)$.  Hence no
Kuznetsov numerical class has a nine-dimensional smooth stable moduli space:
that would require $n^2+nm+m^2=8\equiv2\pmod3$.  In particular the
nine-dimensional classical $M_9$ cannot be identified with an LLPZ
primitive moduli space.  The nearby primitive spaces of classes
$2\alpha+\beta$ and $\alpha+2\beta$ have dimension eight and general
Abel--Jacobi fibre dimension three; LLPZ identify the former fibre
birationally with a genus-eight Fano threefold.  They are not the classical
fourfold fibre.

There is a second, independent obstruction.  On the fine smooth locus of the
classical charge-three moduli, integral GRR gives an intrinsic canonical
determinant line, but its rational first Chern class comes entirely from the
Abel--Jacobi variation and restricts to zero on every smooth Abel--Jacobi
fibre.  Thus it supplies no anticanonical polarization whose fourth power can
be counted.  A nonzero $(-K)^4$ belongs to a chosen proper boundary
compactification; it is not an invariant of Voisin's open $M_9$ or of its
universal bundle.

Consequently the requested fourth self-intersection is not presently an
unknown number attached to a known intrinsic line.  The proposed input
object has been conflated from two different moduli problems.  This kills the
GRR shortcut as framed.  It does **not** kill an explicit compactification
route: one may choose a proper charge-three sheaf compactification, prove its
generic fibre smooth (or control its singularities), compute its boundary
discrepancies, and then calculate the anticanonical volume there.

## 1. Exact classical class calculation

Let $X\subset\mathbf P^4$ be a smooth cubic threefold.  Write $h$ for the
hyperplane class, $l$ for a line and $p$ for a point, so

\[
                     h^2=3l,\qquad h l=p,\qquad h^3=3p.
\]

For a degree-six genus-one curve $C$, Riemann--Roch on $X$ gives

\[
 \operatorname {ch}({\cal O}_C)=6l-6p,
 \qquad
 \operatorname {ch}(I_C)=1-6l+6p.
\]

Indeed, if $\operatorname {ch}_3({\cal O}_C)=ap$, then

\[
 0=\chi({\cal O}_C)=\int_X(6l\cdot h+ap)=6+a.
\]

Multiplication by $e^{2h}$ yields

\[
               \operatorname {ch}(I_C(2h))=(1,2h,0,-2p).
\]

Voisin's Serre sequence then gives

\[
 \operatorname {ch}(A)=(2,2h,0,-2p),
 \qquad
 \operatorname {ch}(A(-h))=(2,0,-3l,0).
\]

Thus $E=A(-h)$ is the normalized rank-two charge-three class.  Also

\[
 \operatorname {td}(X)=1+h+2l+p,
 \qquad
 \chi(E)=\int_X(2-3l)(1+h+2l+p)=-1.
\]

The determinant-weight ideal is therefore the unit ideal: the classical
charge-three stable-bundle locus is fine.  Fineness, however, does not put
the bundle into $\operatorname {Ku}(X)$.

LLPZ use

\[
 \alpha=(2,-h,-l/2,p/2),\qquad
 \beta=(1,0,-l,0)
\]

as a basis of $K_{\rm num}(\operatorname {Ku}(X))$.  Their Section 8.2
table records

\[
        (d,g,t)=(6,1,2)\quad\longmapsto\quad
        [\operatorname {pr}_{\rm Ku} I_C(2h)]=-3\alpha.
\]

Since $\operatorname {pr}_{\rm Ku}({\cal O}_X)=0$, the Serre sequence also
gives $[\operatorname {pr}_{\rm Ku}A]=-3\alpha$.  Divisibility three is
preserved by every integral autoequivalence of the numerical lattice, so a
rotation or mutation cannot turn this class into a primitive one.

Finally, LLPZ's Euler form gives

\[
 \chi(n\alpha+m\beta,n\alpha+m\beta)=-(n^2+nm+m^2).
\]

Values of the Eisenstein norm $n^2+nm+m^2$ are $0$ or $1$ modulo
three.  This proves the dimension obstruction above.  There is a harmless
but relevant typo in the extracted proof of their Corollary 6.17: the
$2\alpha+\beta$ case is called $\chi=-8$ there, whereas the corollary's
statement, the displayed Euler form, and the paper's geometric example all
give $\chi=-7$, hence total dimension eight.

## 2. Integral determinant line and the cancellation on an AJ fibre

Let $S$ be a smooth fine locus of normalized charge-three bundles and let
${\cal E}$ be a universal rank-two bundle on $X\times S$.  Put
$p_S:X\times S\to S$.  On the unobstructed stable locus the canonical line
is the integral determinant-of-cohomology line

\[
       K_S=\det Rp_{S*}R{\cal H}om({\cal E},{\cal E}).
\]

Using trace-free endomorphisms changes this only by the determinant of the
constant complex $R\Gamma({\cal O}_X)$, so it does not change its first
Chern class.

Set

\[
                     q=c_1({\cal E})^2-4c_2({\cal E}).
\]

The Chern-root identity is exact:

\[
 \operatorname {ch}(R{\cal H}om({\cal E},{\cal E}))
       =4+q+\frac{q^2}{12}+\cdots .
\]

Since $\operatorname {td}_2(X)=2l$, GRR gives the following rational
cohomology identity for the **integrally defined** line $K_S$:

\[
       c_1(K_S)=p_{S*}\left(\frac{q^2}{12}+2lq\right).
       \tag{2.1}
\]

This display keeps the only denominator; integrality follows from the
determinant-of-cohomology construction, not from termwise divisibility in
the displayed rational expansion.

Decompose the degree-four Kunneth class as

\[
 q=-12l+h\boxtimes a+\delta+1\boxtimes b,
 \qquad
 \delta\in H^3(X,\mathbf Q)\otimes H^1(S,\mathbf Q).
\]

Only two kinds of terms contribute to $H^2(S)$.  The
$(-12l)(h\boxtimes a)$ cross-term in $q^2/12$ contributes $-2a$, while
$2l(h\boxtimes a)$ contributes $+2a$.  They cancel exactly.  Therefore

\[
                     c_1(K_S)=\frac1{12}p_{S*}(\delta^2).
                     \tag{2.2}
\]

The class $\delta$ is the $H^3(X)\otimes H^1(S)$ Kunneth component of
the discriminant of the universal bundle.  Up to the visible factor $-4$,
it is the component of $c_2({\cal E})$ defining the Abel--Jacobi map
$\Phi:S\to J(X)$.  Hence (2.2) is pulled back from the polarization class
on $J(X)$.  If $i:V\hookrightarrow S$ is a smooth fibre of $\Phi$, then

\[
                         i^*c_1(K_S)=0
                         \quad\text{in }H^2(V,\mathbf Q).
\]

Where $\Phi$ is smooth, $K_V=i^*K_S$, since $K_J\simeq{\cal O}_J$.
Thus the canonical determinant is rationally numerically trivial on the
classical open fibre.  There is no hidden fourth power to compute from
(2.1): it is zero on that open fibre.

This does not contradict rational connectedness.  Voisin's $M_9$ is the
open moduli of locally free stable bundles and her MRC/Abel--Jacobi map is
used birationally.  A proper compactification adds boundary.  On a log-smooth
model $(\overline V,B)$, the line visible on the open is
$(K_{\overline V}+B)|_V$, not $K_{\overline V}|_V$.  Boundary classes and
discrepancies can therefore create a nonzero anticanonical volume, but that
volume depends on the specified compactification.

## 3. What an odd fourth power would prove, conditionally

The intended index argument is valid once a particular smooth proper model
and line have actually been constructed.

> **Conditional odd-volume lemma.**  Let $K=\mathbf C(J(X))$, let
> $\overline V/K$ be a smooth proper model of the classical generic
> charge-three fibre, and suppose a $K$-line bundle $L$ on
> $\overline V$ has odd fourth self-intersection.  If the known boundary
> carrier gives a degree-two zero-cycle on $\overline V$, then
> $\operatorname {ind}(\overline V)=1$.  In particular this applies if
> $L=-K_{\overline V}$ and $(-K_{\overline V})^4$ is odd.

Indeed, $c_1(L)^4\in CH_0(\overline V)$ has its displayed odd degree, so
the index divides that odd integer.  It also divides two; hence it is one.
No positivity or Fano theorem is needed for this implication.

Let $Y/K$ be a smooth proper model of the generic fibre of
$\operatorname {Sym}^2\Theta\to J$, and let $D$ be Voisin's
type-$(3,3)$ incidence.  The degree-fifteen packet and the
$\operatorname {Sym}^2(E_3)$ relay give

\[
 \operatorname {ind}(V)\mid\operatorname {ind}(D)\mid15\operatorname {ind}(V),
 \qquad
 \operatorname {ind}(Y)\mid\operatorname {ind}(D)\mid3\operatorname {ind}(Y).
\]

Thus $V$ and $Y$ are 2-equivalent and

\[
                  v_2(\operatorname {ind}V)
                    =v_2(\operatorname {ind}Y).
\]

Since the visible constructions bound both indices by two, an odd fourth
power on a specified $\overline V$ would force both endpoint indices to be
one.  After moving a degree-one zero-cycle into the fine bundle locus, the
universal charge-three bundle and restriction--corestriction give a
codimension-two cycle whose Abel--Jacobi value is the generic point of
$J$; spreading produces the desired relative identity correspondence on
an open base.  This is a sufficient implication.  The $D_{3,3}$
2-equivalence by itself transports only two-primary index; it does not
transport anticanonical lines, intersection numbers, or an isomorphism of
motives.

## 4. Exact remaining geometric task

The anticanonical route can be revived only after the following data are
fixed and proved:

1. a specific projective charge-three sheaf compactification
   $\overline M_9\to J$, with extension of the Abel--Jacobi map;
2. a smooth generic fibre, or a controlled terminal/Q-factorial model on
   which $K$ and intersection products are defined;
3. the complete boundary divisor and discrepancy formula relating the
   determinant line (2.1) to $K_{\overline V}$;
4. enough Chow/intersection theory on $\overline M_9$ to compute the fourth
   power integrally.

Fineness alone supplies none of items 1--4.  LLPZ's primitive Fano theorem
supplies them for a different numerical moduli problem and cannot be used as
a compactification theorem for $M_9$.

## 5. Source ledger

Zero sources were newly read cover-to-cover.  Two primary sources were read
at claim-specific depth.

- Claire Voisin, *Abel--Jacobi map, integral Hodge classes and decomposition
  of the diagonal*, arXiv:1005.5621, printed pp. 9--14: Theorem 2.1, the
  Serre construction, the definition and dimension of $M_9$, the
  $\mathbf P^3$ section fibre, and the $D_{3,3}$ dominance argument.
  Cached PDF SHA-256
  `ca7103f6529128a24425dbfc1c87589402b17b12719329239fccdb590f74b547`;
  extracted text SHA-256
  `305c9f19cad5167e3dbe1660bf6bcafda96984330f649d85e19bbb97aae47aa3`.

- Chunyi Li, Yinbang Lin, Laura Pertusi and Xiaolei Zhao, *Higher
  dimensional moduli spaces on Kuznetsov components of Fano threefolds*,
  arXiv:2406.09124, printed pp. 5, 25--26, 48, 55 and 59--61: numerical
  basis and Euler form, dimension formula, Corollary 6.17, Theorem 7.10,
  the elliptic-sextic row of the Section 8.2 table, and Question 8.10.
  Cached PDF SHA-256
  `c1aa5d752c9c081827d0aa2cec4ab6408e3868449ef3f7e7ba11a7f936bbdb25`;
  extracted text SHA-256
  `c1bc12604b67471034ff07e7ff31ffd16e5deafd6343193750c94f82102d1a63`.

## 6. Dead/live ledger

- **Dead:** identify Voisin's $M_9$ with an LLPZ primitive Bridgeland
  moduli space.
- **Dead:** compute an intrinsic nonzero $(-K)^4$ on the classical open
  fibre from its universal bundle.  Its determinant canonical class is
  pulled back from $J$.
- **Dead:** use LLPZ's primitive Fano theorem to fill the classical boundary;
  the numerical class and dimension disagree.
- **Live:** construct and analyze one explicit proper charge-three
  compactification, including all boundary discrepancies.
- **Live:** attack the unordered-theta index/Chow-half obstruction directly;
  the degree-fifteen $D_{3,3}$ packet still transfers its two-primary
  answer exactly to the classical charge-three side.

## 7. Bounded replay

From the repository root:

~~~bash
python3 notes/2026-08-11-c904-m9-class-obstruction-replay.py
~~~

Expected output is frozen in
notes/2026-08-11-c904-m9-class-obstruction-replay.out.  The replay checks
the Chern-character arithmetic, the weight-one Euler characteristic, the
mod-three norm obstruction, and the exact GRR cancellation.  It is a bounded
arithmetic certificate, not a substitute for the geometric argument that the
$H^3\otimes H^1$ Kunneth component defines the Abel--Jacobi map.
