# C518 — modular TRS trace-one global incidence

**Date:** 2026-07-23

**Lane:** `reed-solomon`

**Verdict:** binary fixed endpoints are uniformly shallow; the general Frobenius-alternant
component and its exact quadratic lifting torsor are the first global obstruction

## Result

Let \(q=p^m\), let \(p\mid k\), put \(s=q-k\), and retain C514--C515's normalized incidence
\[
 F_y(r,U)=\langle A_{-r}y,XQ_U(X)\rangle,\qquad
 |U|=s-1,\quad \sum U=1.                                      \tag{1}
\]
C518 completes the prescribed attacks through the first honest global obstruction.

First, every Lucas-fixed endpoint has an exact complement dual.  Put
\[
 W=\mathbb F_q\setminus U,\qquad |W|=k+1,\qquad \sum W=-1.
\]
If the endpoint is \(e_d(U)=0\), then
\[
 e_d(U)=(-1)^d h_d(W),                                        \tag{2}
\]
and, for distinct \(W=\{w_0,\ldots,w_k\}\),
\[
 h_d(W)=
 \frac{\det(w_i^{\,0},w_i^{\,1},\ldots,w_i^{\,k-1},w_i^{\,k+d})}
      {\det(w_i^{\,0},w_i^{\,1},\ldots,w_i^{\,k})}.            \tag{3}
\]
Thus the endpoint is not an opaque high-degree symmetric equation: it is the ordered-root
incidence of \(k+1\) points on one explicit Frobenius-monomial graph.

More precisely, write the base-\(p\) digits of \(s\) as \(s_i\).  The Lucas-maximal indices are
\[
 J_s=\{s\}\cup
 \left\{
   p^\ell\left\lfloor\frac{s}{p^\ell}\right\rfloor-1:
   s_\ell\ne0
 \right\}.                                                     \tag{4}
\]
The least such truncation is the standard direction \(s-1\).  For every additional endpoint,
put
\[
 b_\ell=k\bmod p^\ell,\qquad
 a_\ell=\left\lfloor\frac{k}{p^\ell}\right\rfloor .
\]
Then \(b_\ell\ne0\) and
\[
 d_\ell=p^\ell-b_\ell+1,\qquad
 k+d_\ell=(a_\ell+1)p^\ell+1=:N_\ell.                          \tag{5}
\]
Consequently its exact carrier is
\[
 \mathcal A_{k,\ell}:\quad
 \sum_{i=0}^k w_i=-1,\quad
 \det(1,w_i,\ldots,w_i^{k-1},w_i^{N_\ell})=0,\quad
 \prod_{i<j}(w_i-w_j)\ne0.                                   \tag{6}
\]

This gives two uniform shallow theorems.

1. If \(k\ge3\), \(g=\gcd(\ell,m)\), and \(p^g>k+1\), then
   \(\mathcal A_{k,\ell}(\mathbb F_q)\ne\varnothing\).  Choose \(k+1\) points in
   \(\mathbb F_{p^g}\), translate them so their sum is \(-1\), and note that
   \(w^{N_\ell}=w^2\) on this subfield.  The last column in (3) then repeats the quadratic
   column.
2. For the full binary modular family \(k=2\), every additional fixed endpoint is shallow over
   every \(\mathbb F_{2^m}\).  Here \(s=q-2\), the endpoints have
   \[
   d_\ell=2^\ell-1,\qquad 2\le\ell<m.
   \]
   If \(\lambda\) is primitive, set
   \[
   z=\frac{\lambda^{2^\ell}+1}{1+\lambda^{2^\ell-1}},\qquad
   a=(z+1+\lambda)^{-1},
   \]
   and
   \[
   W=\{az,\ a(z+1),\ a(z+\lambda)\}.                           \tag{7}
   \]
   All denominators are nonzero, the three entries are distinct, their sum is \(1=-1\), and
   the points \((w,w^{2^\ell+1})\) are collinear.  Equations (2)--(3) give the required
   endpoint zero.  This parametrization is exact.  If
   \[
   g_\ell=\gcd(\ell,m),\qquad h_\ell=\gcd(\ell-1,m),
   \]
   then the number of unordered endpoint-zero complements is
   \[
   \frac{q-2^{g_\ell}-2^{h_\ell}+2}{6}.                        \tag{7.1}
   \]
   Every such complement lies in \(\mathbb F_q^\times\).  Equivalently, every binary fixed-
   endpoint zero lies on C514's valid completion/support collision boundary \(0\in U\).

Second, the residual-quadratic attack has a characteristic-free exact normal form.  Fix
\[
 V\subset\mathbb F_q,\qquad |V|=s-3,\qquad
 A=1-\sum_{v\in V}v,
\]
and write the last two roots as \(x,z\), with \(x+z=A\) and \(B=xz\).  If
\(R_V(X)=\prod_{v\in V}(X-v)\), put
\[
\begin{aligned}
 C_y(r,V)&=
 \left\langle A_{-r}y,\,
 X R_V(X)(X^2-AX)\right\rangle,\\
 D_y(r,V)&=
 \left\langle A_{-r}y,\,X R_V(X)\right\rangle .
\end{aligned}                                                  \tag{8}
\]
Then
\[
 F_y(r,V\sqcup\{x,z\})=C_y(r,V)+B D_y(r,V).                    \tag{9}
\]
Off \(D=0\), the unique residual quadratic is
\[
 D Z^2-AD Z-C,                                                 \tag{10}
\]
with exact odd-characteristic branch numerator
\[
 K=A^2D^2+4CD.                                                 \tag{11}
\]
The last two roots are rational, distinct, and avoid \(V\) exactly when:

- in odd characteristic, \(K\) is a nonzero square;
- in characteristic two, \(A\ne0\) and
  \[
  \operatorname{Tr}_{q/2}\left(\frac{C}{A^2D}\right)=0;
  \]
- in both cases,
  \[
  \operatorname{Res}_Z(R_V(Z),DZ^2-ADZ-C)\ne0.                 \tag{12}
  \]

The divisor \(D=0\) is simultaneously the residual determinant and the point at infinity of the
projective \(B\)-line.  If \(D=0,C\ne0\), the slice is empty.  If \(C=D=0\), every finite \(B\)
solves the incidence equation, but a distinct pair still has to be chosen; in characteristic
two \(A=0\) makes that impossible.  Thus no point at infinity, double root, or fixed-root
collision has been counted as a support.

For a fixed endpoint \(e_d(U)=0\), (8) specializes without hidden signs to
\[
 C=e_d(V)+A e_{d-1}(V),\qquad D=e_{d-2}(V),                    \tag{13}
\]
so (10)--(12) reach the generic Lucas-fixed stratum exactly.  They do not automatically produce
a rational lift: the square class in odd characteristic and the displayed Artin--Schreier trace
class in characteristic two are the exact quotient-lifting torsors.

The first unresolved global object is therefore not the raw orbit norm and not its reduced
product.  It is the geometrically reduced ordered carrier \(\mathcal A_{k,\ell}\), together with
the Kummer/Artin--Schreier lift (10)--(12).  A rational point on the coefficient quotient is
insufficient unless this lift is trivial and the resultant deletion is avoided.  The Tao audit
below resolves the generic component whenever \(p^\ell>k\): it is rational, with exact
Vandermonde and consecutive-Schur exceptional divisors.  The remaining carrier gate is confined
to low Lucas levels, the high-level vertical Schur intersection, and rational avoidance/lifting.

This is exit gate 2.  The binary family and the stated subfield range are proved shallow, but
outside them no theorem-derived field bound follows from the seven attacks.  At high Lucas levels
ordered-root integrality is now explicit, but rational points must still avoid its Schur and
residual torsors; at low levels the component problem itself remains.  A contained/transverse
synthesis would have to assume these missing inputs.  The value-distribution fallback likewise
has to estimate their rational complement, rather than differences or moments of a simpler
function.  No field census and no all-TRS classification are asserted.

## 1. Lucas endpoints and complement duality

An integer \(j\le s\) is maximal for the Lucas order precisely when either \(j=s\), or at the
highest digit where it first drops below \(s\), all lower digits are \(p-1\).  This gives (4).
For \(j_\ell=p^\ell\lfloor s/p^\ell\rfloor-1\),
\[
 d_\ell=s-j_\ell=1+(s\bmod p^\ell).
\]
Because \(q\equiv0\pmod {p^\ell}\), a nonstandard endpoint has
\[
 s\bmod p^\ell=p^\ell-(k\bmod p^\ell),
\]
which proves (5).

The full-field elementary-symmetric series is
\[
 \prod_{a\in\mathbb F_q}(1+at)=1-t^{q-1}.
\]
Since \(d_\ell<q-1\),
\[
 \prod_{u\in U}(1+ut)
 =\frac{1-t^{q-1}}{\prod_{w\in W}(1+wt)}
 =\sum_{d\ge0}(-1)^d h_d(W)t^d
 \pmod {t^{q-1}}.
\]
This proves (2).  Formula (3) is the one-row Schur alternant identity; its denominator is the
nonzero Vandermonde of the distinct complement.

For the subfield construction, \(p^g>k+1\) implies \(p^\ell>k\), so \(a_\ell=0\) and
\(N_\ell=p^\ell+1\).  Translation of a \((k+1)\)-set changes its sum by
\((k+1)c=c\), because \(p\mid k\).  Hence any \(k+1\) distinct points of
\(\mathbb F_{p^g}\) can be translated inside that subfield to have sum \(-1\).  Frobenius
\(p^\ell\) fixes the subfield, so \(w^{N_\ell}=w^2\), proving the repeated-column claim.

For (7), primitivity gives
\[
 \lambda^{2^\ell-1}\ne1,\qquad
 \lambda^{2^\ell-2}\ne1,
\]
because both positive exponents are smaller than \(q-1\).  These are exactly the two
denominators in (7).  For \(f(t)=t^{2^\ell+1}\),
\[
\begin{aligned}
 f(z+1)+f(z)&=z^{2^\ell}+z+1,\\
 \frac{f(z+\lambda)+f(z)}{\lambda}
 &=z^{2^\ell}+\lambda^{2^\ell-1}z+\lambda^{2^\ell}.
\end{aligned}
\]
The definition of \(z\) makes the two slopes equal.  Scaling by \(a\) preserves collinearity,
and the sum of the three scaled abscissae is one.  The \(3\times3\) numerator in (3) therefore
vanishes.

There is no missing binary branch.  Given any ordered endpoint-zero complement
\((w_0,w_1,w_2)\), put
\[
 \rho=w_1-w_0,\qquad
 z=w_0/\rho,\qquad
 \lambda=(w_2-w_0)/\rho.
\]
The entries are distinct, so \(\rho\ne0\) and \(\lambda\notin\{0,1\}\).  Equality of the two
slopes on the Frobenius graph forces
\[
 (1+\lambda^{2^\ell-1})z=1+\lambda^{2^\ell}.                  \tag{7.2}
\]
If \(\lambda^{2^\ell-1}=1\), this equation would give \(\lambda=1\), so its denominator is
nonzero and \(z\) is exactly the value in (7).  The sum-one condition is soluble precisely when
\[
 z+1+\lambda\ne0
 \quad\Longleftrightarrow\quad
 \lambda^{2^\ell-2}\ne1.
\]
It then uniquely forces \(\rho=(z+1+\lambda)^{-1}\).  Thus ordered solutions are in bijection
with
\[
 \lambda\in\mathbb F_q^\times,\qquad
 \lambda^{2^\ell-1}\ne1,\qquad
 \lambda^{2^\ell-2}\ne1.                                     \tag{7.3}
\]
The two excluded subgroups have respective orders
\[
 2^{g_\ell}-1,\qquad 2^{h_\ell}-1
\]
and intersect only in \(1\).  Hence (7.3) has
\(q-2^{g_\ell}-2^{h_\ell}+2\) elements.  Every unordered three-set has six orderings, proving
(7.1).  Finally, \(z=0\), \(z=1\), or \(z=\lambda\) would force
\(\lambda=1\) or \(\lambda^{2^\ell}=1\), neither possible in (7.3).  Every complement is
therefore nonzero, so its support complement \(U\) contains zero.

## 2. Residual quadratic and all deletion divisors

The factorization
\[
 Q_U(X)=R_V(X)(X^2-AX+B)
\]
is linear in \(B\).  Pairing \(XQ_U\) with \(A_{-r}y\) gives (8)--(9).  When \(D\ne0\),
\(B=-C/D\), yielding (10).

In odd characteristic, the discriminant of the monic residual quadratic is
\[
 A^2+\frac{4C}{D}=\frac{K}{D^2}.
\]
Thus its rational distinct-root torsor is exactly the square class of \(K\), with \(K=0\)
the diagonal.  In characteristic two, division by \(A^2\) turns (10) into
\[
 T^2+T=\frac{C}{A^2D}.
\]
This proves the trace criterion, while \(A=0\) makes every split residual quadratic
inseparable and hence unusable.  Evaluation of (10) at every fixed root gives the resultant
(12).  These formulas also retain the valid completion collision \(0\in U\): zero may occur in
\(V\) or as one residual root, and only repeated roots are deleted.

## 3. Factorization monodromy and ordered-root fallback

At fixed \(r\), (1) is a hyperplane in the coefficient space of
\[
 X^{s-1}-X^{s-2}+c_2X^{s-3}+\cdots+c_{s-1}.
\]
The ordered-root cover over this hyperplane is the correct splitting family.  On a fixed
endpoint, complement duality identifies its ordered incidence with (6); passing to unordered
coefficients merely quotients by \(S_{k+1}\).  An \(\mathbb F_q\)-point of that quotient need
not lift to \(k+1\) rational roots, just as a rational \(B\) in (9) need not lift through the
quadratic torsor.

Therefore a monodromy computation alone would not close C518.  The ordered-root fallback removes
the quotient but initially leaves the same Frobenius-alternant component.  The Tao audit below
resolves its generic geometry at every high Lucas level \(p^\ell>k\); what remains is the
low-level component problem, the high-level vertical Schur intersection, and rational avoidance
of the ordering and residual-lifting divisors.

## 4. Tao audit — semilinearize the high Lucas levels

The high exponent in (6) should not be treated as an ordinary high-degree monomial.  Suppose
\[
 p^\ell>k,\qquad r=p^\ell-k>0.
\]
Then \(a_\ell=0\) in (5), so \(N_\ell=p^\ell+1\) and
\[
 x^{N_\ell}=x\,x^{p^\ell}
\]
is a semilinear quadratic.

For an ordered complement, normalize two roots by
\[
 w_i=\rho(z+t_i),\qquad t_0=0,\quad t_1=1,
\]
and put \(S=\sum_i t_i\).  Since \(p\mid k\),
\[
 \sum_iw_i=\rho((k+1)z+S)=\rho(z+S).                          \tag{T1}
\]
Translation acts triangularly on the lower columns \(1,x,\ldots,x^{k-1}\), while
\[
 (z+t)^{p^\ell+1}
 =z^{p^\ell+1}+z^{p^\ell}t+z t^{p^\ell}+t^{p^\ell+1}.         \tag{T2}
\]
The first two terms lie in the lower-column span.  Hence the endpoint alternant is exactly
\[
 zA(t)+B(t),                                                   \tag{T3}
\]
where
\[
\begin{aligned}
 A(t)&=\det(t_i^0,\ldots,t_i^{k-1},t_i^{p^\ell}),\\
 B(t)&=\det(t_i^0,\ldots,t_i^{k-1},t_i^{p^\ell+1}).
\end{aligned}                                                  \tag{T4}
\]
Writing \(\Delta(t)\) for the Vandermonde, the Schur alternant identity gives
\[
 A=\Delta h_r,\qquad B=\Delta h_{r+1}.                         \tag{T5}
\]
Off \(h_r=0\), equations (T1)--(T3) have the unique solution
\[
 z=-\frac{h_{r+1}}{h_r},\qquad
 \rho=-\frac{h_r}{S h_r-h_{r+1}},                              \tag{T6}
\]
and therefore
\[
 w_i=
 \frac{h_{r+1}-h_r t_i}{S h_r-h_{r+1}}.                       \tag{T7}
\]
Pieri's rule identifies the normalization denominator:
\[
 S h_r-h_{r+1}=s_{(r,1)}.                                    \tag{T8}
\]

Thus the generic ordered high-level carrier is birational, with explicit inverse, to
\[
 \operatorname{Conf}^{\mathrm{ord}}_{k-1}(\mathbb A^1\setminus\{0,1\})
 \setminus V\!\left(h_r\,s_{(r,1)}\right).                    \tag{T9}
\]
In particular it is geometrically integral and rational.  The exceptional strata are exact:

- \(h_r=0,\ h_{r+1}\ne0\): no normalized incidence point;
- \(h_r=h_{r+1}=0\): a vertical \(z\)-family, subject to \(z+S\ne0\);
- \(s_{(r,1)}=0\): the sum-normalization point at infinity;
- \(\Delta=0\): a repeated complement root.

This replaces the generic high-level component problem by the consecutive-Schur intersection
\[
 V(h_r,h_{r+1})                                               \tag{T10}
\]
and the arithmetic problem of finding an \(\mathbb F_q\)-point of (T9) that also clears the
residual Kummer/Artin--Schreier and resultant deletions.  Low levels \(p^\ell\le k\) retain
\((a_\ell+1)p^\ell+1\) in (5); their translated last column has higher \(z\)-degree and is not
covered by this semilinear-quadratic parametrization.

## 5. Exit obstruction

The seven attacks stop at the following exact gate:

> For each low Lucas pair \(p^\ell\le k\), determine a geometrically integral ordered component.
> For each high pair \(p^\ell>k\), classify the vertical consecutive-Schur intersection
> \(V(h_r,h_{r+1})\), find an \(\mathbb F_q\)-point on the rational generic component (T9) off
> the Vandermonde, normalization, and residual-resultant divisors, and prove that its Kummer or
> Artin--Schreier residual class is trivial.

This gate is intrinsic, finite, and falsifiable.  It is also genuinely prior to a C512-shaped
synthesis: declaring the orbit norm irreducible would ignore its translated-factor
decomposition, while declaring the quotient incidence sufficient would ignore the exact lift
torsor.  C518 consequently closes by obstruction rather than promoting a conditional universal
theorem.

## 6. Extra-juice closeout and mystery ledger

The first closeout adds two cheap upgrades after the obstruction gate was fixed.

First, complement duality lowers every fixed endpoint from \(s-1=q-k-1\) ordered support roots
to \(k+1\) complement roots.  This is a substantial dimension reduction when the code dimension
is fixed, and it exposes the exact Frobenius exponent \(N_\ell\) rather than a generic
degree-\(d_\ell\) symmetric hypersurface.

Second, the \(k=2\) carrier is not merely generically soluble: formula (7) supplies a support
over every field and at every extra Lucas level.  Thus the first possible persistent fixed
endpoint has \(k\ge3\), and any future component theorem can begin there.

A user-requested second extra-juice pass makes the binary result exact.  The primitive parameter
in (7) was stronger than necessary: all admissible cross-ratios are classified by (7.3), giving
the exact count (7.1).  More surprisingly, none of those complements contains zero.  Thus the
entire binary endpoint-zero carrier—not merely the displayed witnesses—is supported on the valid
`X^2 Q_V` completion-collision boundary.  C514's insistence on retaining that boundary is already
essential in the smallest modular dimension.

A requested second-order extra-juice pass globalizes that parametrization.  Over characteristic
two, the ordered binary carrier is the rational curve
\[
 \mathcal C_\ell=
 {\bf P}^1\setminus
 \left(
   \{0,\infty\}\cup
   \mu_{2^\ell-1}\cup
   \mu_{2^{\ell-1}-1}
 \right),                                                     \tag{17}
\]
where the union is reduced.  Its reduced deletion degree is
\[
 \delta_\ell=2^\ell+2^{\ell-1}-1.                             \tag{18}
\]
Indeed the second denominator from (7.3) has the scheme-theoretic equation
\[
 \lambda^{2^\ell-2}-1
 =\left(\lambda^{2^{\ell-1}-1}-1\right)^2,                    \tag{19}
\]
so its apparent degree carries a forced inseparable square.  Removing that square gives (17)--(18),
and
\[
 |\mathcal C_\ell(\mathbb F_{2^m})|
 =q-2^{\gcd(\ell,m)}-2^{\gcd(\ell-1,m)}+2,                    \tag{20}
\]
recovering six times (7.1) directly from the identity-Frobenius twist.

Reordering the three complement points gives the usual anharmonic \(S_3\)-action generated by
\[
 \lambda\longmapsto1+\lambda,\qquad
 \lambda\longmapsto\lambda^{-1}.                              \tag{21}
\]
It acts freely on \(\mathcal C_\ell\).  The involution fixed points are among
\(\{0,1,\infty\}\); the order-three fixed points satisfy
\(\lambda^2+\lambda+1=0\), and are deleted by
\(\mu_{2^\ell-1}\) when \(\ell\) is even and by
\(\mu_{2^{\ell-1}-1}\) when \(\ell\) is odd.  Hence
\[
 \mathcal C_\ell\longrightarrow\mathcal C_\ell/S_3            \tag{22}
\]
is an exact finite étale ordering torsor.  A coarse quotient coordinate is
\[
 J(\lambda)=
 \frac{(\lambda^2+\lambda+1)^3}
      {\lambda^2(\lambda+1)^2}.                               \tag{23}
\]
For an \(\mathbb F_q\)-point of the quotient, rational support lifting is exactly triviality of
its class in \(H^1(\mathbb F_q,S_3)\).  The three possible Frobenius classes act on the six
orderings with cycle types
\[
 1^6,\qquad 2^3,\qquad 3^2.                                  \tag{24}
\]
Only the identity class supplies an ordered rational complement.  Thus the binary endpoint
simultaneously models C518's two warnings: the unreduced equation has a forced characteristic-two
power, and a rational quotient point is not a rational split support without its ordering-torsor
lift.

Settled:

- **What are all fixed endpoint equations?** Equations (2)--(6) give the complete list and its
  complement alternant.
- **Can any extra fixed endpoint be proved uniformly shallow?** Yes: all \(k=2\) endpoints, and
  every \(k\ge3\) endpoint with \(p^{\gcd(\ell,m)}>k+1\).
- **Is the binary construction exhaustive, and where does it lie?** Yes.  Equation (7.3)
  parametrizes every ordered solution, (7.1) counts the unordered carrier, and every solution has
  \(0\in U\), exactly on the valid completion/support collision boundary.
- **What are the binary component, monodromy, and quotient lift?** The ordered component is the
  rational open curve (17), its reduced deletion degree is (18), and its free ordering cover is
  the \(S_3\)-torsor (22).  Quotient Frobenius has exactly the cycle types (24), with only the
  identity twist lifting to a rational support.
- **What is the generic high-level component for arbitrary \(k\)?** When \(p^\ell>k\), equations
  (T6)--(T9) give a rational parametrization with exact inverse.  Its two intrinsic exceptional
  equations are the consecutive Schur functions \(h_r\) and \(s_{(r,1)}\).
- **Does the residual-quadratic route retain infinity, diagonals, and completion collisions?**
  Yes.  Equations (8)--(12) separate the infinity/determinant, residual diagonal, fixed-root
  collision, and valid \(0\in U\) loci.
- **What is the exact rational lifting condition?** A Kummer square class in odd characteristic
  and the displayed Artin--Schreier trace class in characteristic two.
- **Can factorization monodromy or the ordered-root fallback bypass quotient lifting?** No.  Even
  on the rational high-level component, the ordering and residual torsors must be trivialized.

Open:

- **Are all remaining Lucas-fixed endpoints shallow?** Evidence gap: component geometry at low
  levels \(p^\ell\le k\); the vertical high-level intersection \(V(h_r,h_{r+1})\); and rational
  avoidance/lifting on the generic component (T9).  A future successor must own these exact
  carriers; C519 does not, because it owns the universal residual-discriminant base locus instead.
- **Which general Hasse strata admit a nondegenerate residual slice?** Evidence gap: a
  classification of syndromes for which every choice of \(V\) has \(D=0\), \(K=0\), or
  nontrivial lifting class.
- **Can value distribution close a carrier with no convenient component model?** Evidence gap:
  an estimate for zeros of the ordered alternant after the Vandermonde and resultant deletions.
  Finite differences do not supply it.

Vibe check: the semilinear viewpoint removes the generic high-level geometry entirely—it is
rational—but exposes the real residue cleanly: consecutive-Schur vertical strata and arithmetic
ordering/residual lifts, not another Hasse manipulation.
