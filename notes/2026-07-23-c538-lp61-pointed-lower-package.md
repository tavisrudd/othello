# C538 — closure of the pointed lower package `LP(6,1)`

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** proved

## Result

The pointed redundancy-seven lower package `LP(6,1)` is valid.  More
precisely, let
\[
 f=(a_0,\ldots,a_6),\qquad
 W_f=\ker\begin{pmatrix}
 a_0&a_1&a_2&a_3&a_4&a_5\\
 a_1&a_2&a_3&a_4&a_5&a_6
 \end{pmatrix}
\]
and fix a marker \(x\in\mathbf P^1(\mathbf F_q)\).  Outside the persistent
rank-two carrier, the characteristic-two central point, and the closed
fixed-marker boundary on which every member of \(W_f\) vanishes at \(x\),
every \(q\ge43\) admits a split squarefree quintic in \(W_f\) avoiding
\(x\).

The proof supplies the missing scheme-level recursive strata.  Its only
positive-genus cover is C491's geometrically integral off-diagonal
\((2,2)\) curve on the geometric-\(S_3\) stratum.  Its normalization has
genus at most one and its three-marker deletion degree is
\[
 \delta=4+8+3\cdot6=30.
\]
All cyclic, wild, inseparable, gcd, branch, and marker-collision cases are
either explicit closed pullbacks or are treated directly.  Thus the
redundancy-eight theorem is unconditional for \(q\ge43\).

## 1. Universal recursive equations

For an affine contraction parameter \(r\), put
\[
 b_i(r)=a_{i+1}-r a_i\qquad(0\le i\le5).
\]
For a second parameter \(s\), put
\[
 c_i(r,s)=b_{i+1}(r)-s b_i(r)\qquad(0\le i\le4).
\]
The identities
\[
 (t-r)g\in W_f\Longleftrightarrow g\in W_{b(r)},\qquad
 (t-s)h\in W_{b(r)}\Longleftrightarrow h\in W_{c(r,s)}
\]
are coefficient identities over \(\mathbf Z\).  The old marker \(x\), the
new marker \(r\), and the bottom marker \(s\) are kept ordered and distinct.

For \(c=(c_0,\ldots,c_4)\), define
\[
 H_c=\begin{pmatrix}c_0&c_1&c_2&c_3\\
                     c_1&c_2&c_3&c_4\end{pmatrix}.
\]
Choose a basis \(p_0,p_1\) of \(\ker H_c\), viewed as binary cubics.
The off-diagonal ordered-root equation is
\[
 G_c(u,v)=
 \frac{p_0(u)p_1(v)-p_1(u)p_0(v)}{[u,v]}=0.                 \tag{1}
\]
It is intrinsic up to a nonzero scalar and has bidegree \((2,2)\).

The complete lower stratification is given by the following equations.

1. The rank-at-most-two secant carrier (which contains the gcd-two and
   rank-drop boundary strata) is
   \[
   D(c)=\det\begin{pmatrix}
   c_0&c_1&c_2\\c_1&c_2&c_3\\c_2&c_3&c_4
   \end{pmatrix}=0.                                        \tag{2}
   \]
   After substituting \(c(r,s)\), this has degree at most three in \(s\).
2. The exact-gcd-one incidence with common root \(z\) is
   \[
   \operatorname{rank}
   \begin{pmatrix}H_c\\1&z&z^2&z^3\end{pmatrix}\le2,        \tag{3}
   \]
   with the homogeneous endpoint obtained by using \((0,0,0,1)\).
   Thus it is cut out by the displayed \(3\times3\) minors.  For fixed
   \(z\), substitution of \(c(r,s)\) makes every such minor quadratic in
   \(s\).
3. Away from (2) and (3), the pencil has gcd zero.  Its degree-three map
   is inseparable, cyclic, or has geometric monodromy \(S_3\).  The
   inseparable equations are the derivative minors of \(p_0,p_1\).
   In characteristic three their gcd-zero solution is the nucleus
   \(e_2\), contained in the wild cone (5); the remaining Hankel
   degenerations lie on (2).
4. In characteristic different from two and three, the cyclic closure is
   the projected Veronese surface
   \[
   \mathcal V=\{[u^2:2uv:v^2+2uw:2vw:w^2]\}
   \quad\text{in }z_i=\binom4i c_i;
                                                               \tag{4}
   \]
   equivalently it is the elimination of the five displayed coordinate
   equations in \(u,v,w\).  It has degree four and contains no line.
   In characteristic three the cyclic/wild closure is
   \[
   \mathcal W_3=\operatorname{Join}(e_2,C_4)
   =\{[\lambda e_2+\mu\,\nu_4(u,v)]\},                       \tag{5}
   \]
   again with the displayed incidence equations; it has degree four and
   its only lines are its rulings.  No ruling is a consecutive-Hankel
   polar line.  In characteristic two the closure is
   \[
   \Pi_{\rm cyc}=\mathbf P\langle e_1,e_2,e_3\rangle,
   \qquad c_0=c_4=0,                                        \tag{6}
   \]
   and its unique contained polar-line component is the already declared
   nucleus line \(\mathcal N_3=\mathbf P\langle e_2,e_3\rangle\).
5. On the rank-two-kernel chart of (1), the diagonal is \([u,v]=0\).
   The branch scheme is the scheme-theoretic image of
   \[
   p_0'p_1-p_0p_1'=0.                                      \tag{7}
   \]
   The different has degree four.  Each non-squarefree cubic contributes
   at most two off-diagonal ordered pairs, so branch deletion costs at
   most eight.

The ideals and incidence schemes in (2)--(7) are stable under \(\PGL_2\):
changing coordinates changes kernel bases and mixes the displayed
generators.  The reversed homogeneous chart supplies the equations at
infinity.  They therefore define the required closed bad carrier and its
recursive pullbacks, rather than only their finite-field points.

## 2. The three-marker bottom cover

Off (2)--(6), the cubic map is separable and noncyclic.  Its geometric
monodromy is therefore \(S_3\).  This group is transitive on ordered pairs
of distinct roots, so (1) is geometrically integral.  Its arithmetic genus
is one; hence its normalization has genus at most one.  This also proves
that the identity-Frobenius twist has no hidden constant-field component.

The diagonal has intersection degree four and (7) costs at most eight.
For a marker \(m\), deleting every ordered pair above the unique cubic
fiber containing \(m\) costs at most six.  With the ordered markers
\((x,r,s)\),
\[
 \delta\le4+8+6+6+6=30.                                   \tag{8}
\]
Thus
\[
 \#\widetilde G_c(\mathbf F_q)\ge q+1-2\sqrt q>30
\]
for every prime power \(q\ge43\).  Every surviving point gives a split
squarefree cubic avoiding \(x,r,s\).

On an exact-gcd-one bottom stratum, write the cubic pencil as
\(\ell_z Q\), where \(Q\) is a basepoint-free pencil of quadratics.  If
its degree-two map is separable, its deck involution \(\iota\) is defined
over \(\mathbf F_q\).  The graph of \(\iota\) has \(q+1\) rational points.
At most two are fixed, and at most two ordered graph points involve each
of \(z,x,r,s\).  Thus for \(q\ge43\) a pair
\((u,\iota(u))\) remains with all three roots distinct and outside the
markers.  The inseparable degree-two case is already on the rank/boundary
carrier.  All cyclic and wild cases are removed wholesale by the explicit
carriers (4)--(6).

## 3. Two-old-marker quartic lemma

Let \(W\) be a trivial-gcd Hankel net of quartics, let \(x,y\) be distinct
markers, and suppose \(W\notin\mathcal N_3\) in characteristic two.
For \(s\in\mathbf P^1\), contraction gives the polar line \(c(s)\).
The following closed exceptional divisors on the \(s\)-line suffice:

| divisor | equation | degree |
|---|---|---:|
| rank two | \(D(c(s))=0\) | \(3\) |
| cyclic/wild closure | pullback of (4), (5), or (6) | \(4\) (or \(1\) in characteristic two) |
| gcd root \(s\) | ramification of the moving \(g^2_4\) | \(6\) |
| gcd root \(x\) or \(y\) | minors (3) with \(z=x,y\) | \(2+2\) |
| marker diagonals | \(s=x,y\) | \(2\) |

The rank carrier cannot contain the whole polar line: the Cauchy--Binet
identity for \(D(c(s))\) says that this happens exactly when the original
net has quadratic gcd.  The degree-four carrier contains no polar line in
the stated domain; the characteristic-two contained line is exactly
\(\mathcal N_3\).  For a fixed marker, not all minors in (3) can vanish
identically: if they did, every quartic in \(W\) would vanish at that
marker, contradicting trivial gcd.  Choose one nonzero quadratic minor to
bound the common zero scheme.  Explicitly, simultaneous vanishing for
dense \(s\) would give
\(W\cap\ker(\operatorname{ev}_s)\subseteq
W\cap\ker(\operatorname{ev}_x)\); equality of these hyperplanes for dense
\(s\) would make the evaluation map of \(W\) constant unless
\(\operatorname{ev}_x|_W=0\), the excluded fixed-factor case.

For self-collision, take a generic pencil projection of the moving
\(g^2_d\), \(d\le4\).  It is separable.  In characteristic two the only
dimension-three equality case is the pure-square space
\(\langle1,t^2,t^4\rangle\), and the consecutive Hankel overlap equations
force the original syndrome to be zero; all other \(p\)-power spaces have
smaller dimension.  Riemann--Hurwitz gives degree at most \(2d-2\le6\),
and every self-collision maps into that ramification divisor.

The total exceptional degree is at most
\[
 3+4+6+2+2+2=19<q+1.                                      \tag{9}
\]
Choose \(s\) outside it.  If the bottom pencil has gcd zero, it is on the
geometric-\(S_3\) stratum and (8) gives a split cubic avoiding \(x,y,s\).
If it has exact gcd one with root away from the markers, the direct
bidegree argument of Section 2 does the same.  Multiplication by
\(\ell_s\) proves:

> **Two-old-marker lemma.**  For \(q\ge43\), every trivial-gcd quartic
> Hankel net outside \(\mathcal N_3\) contains a split squarefree quartic
> avoiding any two prescribed distinct points.

## 4. Pointed redundancy-seven package

Return to \((f,x)\).  Choose \(r\ne x\).  The pullback of the lower
rank-two carrier has degree at most three.  In characteristic two the
lower nucleus line contributes at most one further point unless the whole
polar line is the central component.  If the contracted quartic net has
exact gcd \(\ell_z\), two additional closed collision schemes matter:

- \(z=r\) is ramification of the moving \(g^3_5\), of degree at most eight;
- \(z=x\) is cut out by (3), with the \(2\times5\) quartic Hankel matrix
  and the fixed evaluation row \((1,x,\ldots,x^4)\); its \(3\times3\)
  minors have degree at most two in \(r\).

Neither scheme is the whole line.  Not all fixed-evaluation minors can
vanish identically unless \(x\) is a fixed root of the whole series; choose
one nonzero quadratic minor.  This is the same evaluation-hyperplane
argument as in Section 3.  A generic pencil projection of the moving
\(g^3_d\), \(d\le5\), is separable because a four-dimensional series
cannot lie in the \(p\)-th-power subspace.  Riemann--Hurwitz gives
ramification degree at most \(2d-2\le8\), and every self-collision maps
into it.  Including the old-marker diagonal, the outer
exceptional budget is therefore
\[
 3+1+8+2+1=15.                                             \tag{10}
\]
This is the internal pointed-R7 budget.  It is distinct from C513's
top-level budget \(3+1+10=14\): at the top level there is no old marker,
whereas inside `LP(6,1)` the parameter \(r\) must also avoid the existing
marker \(x\).  Both are far below the claimed field threshold.

If the contracted net has trivial gcd, the two-old-marker lemma applies
with markers \(x,r\).  If it has exact gcd \(\ell_z\) with
\(z\notin\{x,r\}\), write the residual cubic hyperplane as
\(\ker\lambda\).  The bad equations in the ordered-pair construction now
have three bidegrees \((1,1)\), for \(w=z,x,r\), and two bidegrees
\((2,1),(1,2)\), for \(w=u,v\).  They cover at most \(12(q+1)\) pairs,
while \((q-2)(q-3)>12(q+1)\) for \(q\ge43\).  Thus a split squarefree
quartic avoiding \(x,r\) exists.  Multiplying it by \(\ell_r\) gives a
split squarefree quintic in \(W_f\) avoiding \(x\).

This proves `LP(6,1)`.  The equations exhaust the possible failures:
Hankel gcd has degree zero, one, or at least two; a separable gcd-zero
degree-three map has geometric monodromy \(S_3\) or \(C_3\); and the only
remaining degeneration is inseparability.  Each case is one of
(2)--(7), the direct gcd-one argument, or the declared persistent/modular
boundary.

## 5. Trust boundary and checks

No finite-field regression is used as a geometric-integrality or monodromy
proof.  The C513 certificate remains responsible only for its Lucas
supports, modular witnesses, threshold arithmetic, and numerical collision
checks.  The present proof uses the integral contraction identities, the
explicit C491 cubic-cover stratification, the C498 polar-line carrier
equations, and elementary divisor and bidegree bounds.

Two independent adversarial reads checked the proof paragraph by paragraph.
Their first pass found and the revision repaired a dimensionally incorrect
bottom gcd-one formulation, missing binomial rescaling in the cyclic
coordinates, the characteristic-three inseparable placement, an
individual-minor/nonzero-ideal confusion, and incomplete
small-characteristic ramification justifications.  Both reread the repaired
proof and returned `PASS` with no remaining load-bearing defect.

The paper warning gate passes with:

```text
cd papers/beyond4_prs
make check
```

The internal pointed-R7 budget is \(15\), including the old-marker
diagonal; the separate top-level C513 budget remains \(14\).  Both satisfy
the rational-parameter inequality in the claimed range.  The
load-bearing Hasse--Weil inequality remains
\(q+1-2\sqrt q>30\), whose first prime-power solution is \(43\).

## Extra-juice and Tao closeout

The closeout separated the parameter budgets compressed in the earlier
synopsis: the two-old-marker quartic recursion costs at most \(19\), the
pointed-R7 recursion costs at most \(15\), and C513's top-level choice costs
at most \(14\).  All three are strictly dominated by the bottom
identity-twist inequality, so no threshold is hidden in a transverse count.

The Tao-style stress test asked where a constant-field component or a
nonclassical small-characteristic ramification divisor could enter.  The
first occurs only on the explicit cyclic/wild carriers: off them the
geometric group is \(S_3\), so the identity twist is geometrically
integral.  The second is removed by generic separable pencil projection
and Riemann--Hurwitz; the only dimension-equality square space is excluded
by the consecutive Hankel overlap equations.  Thus the proof does not
silently use a classical Wronskian in a degenerate order sequence.

There is no free uniform improvement below \(q=43\).  The divisor budgets
have slack, but the genus-one lower bound does not beat the three-marker
deletion degree at the preceding prime power \(41\).  Any improvement
would require overlap information among branch and marker fibers.

## Mystery ledger

- **Settled:** the apparent extra monodromy problem is not a new cover.
  After the explicit gcd/cyclic/wild pullbacks are removed, the only curve
  is C491's geometric-\(S_3\) \((2,2)\) identity twist.
- **Settled:** two old markers add two quadratic common-root pullbacks and
  marker fibers; they do not create a new contained component.
- **Settled:** the internal recursion has budget \(15\), including
  \(r=x\); the top-level budget remains \(14\).  Neither affects the
  threshold.
- **No remaining `LP(6,1)` mystery:** every stratum has an equation,
  monodromy or direct treatment, genus bound, deletion bound, and lift.
  R8's other contained components were already closed by `CC(7,1)`.
