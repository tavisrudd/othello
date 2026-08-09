# C756 aligned branch: node-resultant factorization

**Lane:** `clebsch` · **Date:** 2026-08-09 · **Scope:** nonsaturated
continuation of the aligned common-torus reduction; no manuscript edit

## Verdict

The aligned internal-node numerator is not an opaque quadratic.  After the
passant-offset substitution it factors into four torus collision factors, or
equivalently into two rational trace differences.  For
\[
 z_{ij}=u_i/u_j,
 \qquad t_{ij}=z_{ij}+z_{ij}^{-1},
\]
and offset parameters \(v_i,v_j\), put
\[
 a_{ij}=v_iv_j,
 \qquad b_{ij}=v_i/v_j.
\]
Then
\[
 \boxed{
 Q(x_{ij})=-d\,
 \frac{
 (z_{ij}-a_{ij})(z_{ij}-a_{ij}^{-1})
 (z_{ij}-b_{ij})(z_{ij}-b_{ij}^{-1})}
 {(z_{ij}^2-1)^2}.}                                      \tag{1}
\]
Both \(a_{ij}\) and \(b_{ij}\) belong to \(\mathbf F_{53}^*\), in either
offset descent branch.  Hence the same identity over the base field is
\[
 \boxed{
 Q(x_{ij})=-d\,
 \frac{
 \bigl(t_{ij}-a_{ij}-a_{ij}^{-1}\bigr)
 \bigl(t_{ij}-b_{ij}-b_{ij}^{-1}\bigr)}
 {t_{ij}^2-4}.}                                          \tag{2}
\]
The denominator is a nonzero square.  Thus each of the 55 internal-node
conditions is exactly a two-factor character condition.  This is also the
resultant criterion saying that the two passant lines share no conic point.

The factorization is a real compression, but not yet a contradiction.  The
next bounded gate is to combine these two-factor signs with the rank-two
Laurent offset code and the critical equations; no general node resultant is
needed.

## 1. Correct descent of the offset parameter

Retain the aligned notation
\[
 s_i=\frac{\rho}{2}(v_i+v_i^{-1}),
 \qquad
 p_i=\frac{\rho}{2}(v_i-v_i^{-1}),
 \qquad \rho^2=4d\nu,                                   \tag{3}
\]
where \(s_i,p_i\in\mathbf F_{53}\) and \(p_i\ne0\).

There are two descent cases.

- If \(4d\nu\) is square, take \(\rho\in\mathbf F_{53}\).  Then
  \(v_i=(s_i+p_i)/\rho\in\mathbf F_{53}^*\).
- If \(4d\nu\) is nonsquare, take \(\rho^q=-\rho\).  Then
  \[
   v_i^q=-v_i.                                            \tag{4}
  \]

The second case is a trace-zero coset, not a norm-one torus.  Nevertheless,
for every pair \(i,j\), equation (4) gives
\[
 v_iv_j\in\mathbf F_{53}^*,
 \qquad v_i/v_j\in\mathbf F_{53}^*.                     \tag{5}
\]
The same assertion is immediate in the split case.  These are precisely the
two rational pair invariants used in (2).

## 2. Algebraic factorization

Write
\[
 z=z_{ij},\quad t=z+z^{-1},\quad
 x=v_i,\quad y=v_j,
\]
and abbreviate
\[
 A_x=x+x^{-1},\qquad A_y=y+y^{-1}.                       \tag{6}
\]
The aligned common-torus formulas give
\[
 T_{ij}=\nu t,
 \qquad D_{ij}^2=\nu^2(t^2-4),                           \tag{7}
\]
and the exact node numerator is
\[
 D_{ij}^2Q(x_{ij})
 =-\nu(s_i^2+s_j^2)+s_is_jT_{ij}-dD_{ij}^2.              \tag{8}
\]
Substituting (3) and \(\rho^2=4d\nu\) into (8) yields
\[
 D_{ij}^2Q(x_{ij})=-d\nu^2 E(x,y,z),                    \tag{9}
\]
where
\[
 E=A_x^2+A_y^2-A_xA_yt+t^2-4.                            \tag{10}
\]
As a quadratic in \(t\), its discriminant is
\[
 (A_x^2-4)(A_y^2-4)
 =(x-x^{-1})^2(y-y^{-1})^2.                              \tag{11}
\]
Therefore
\[
 E=
 \bigl(t-xy-(xy)^{-1}\bigr)
 \bigl(t-x/y-y/x\bigr).                                 \tag{12}
\]
Using
\[
 z+z^{-1}-w-w^{-1}
 =\frac{(z-w)(z-w^{-1})}{z},                             \tag{13}
\]
equation (12) becomes
\[
 E=\frac{
 (z-xy)(z-(xy)^{-1})(z-x/y)(z-y/x)}{z^2}.                \tag{14}
\]
Dividing (9) by (7), and observing
\(z^2(t^2-4)=(z^2-1)^2\), proves (1) and (2).

## 3. Geometric meaning

The four zeros in (1) are exactly
\[
 z_{ij}\in
 \{v_iv_j,(v_iv_j)^{-1},v_i/v_j,v_j/v_i\}.              \tag{15}
\]
They are the four possible coincidences between the two conic-intersection
parameters of \(r_i\) and \(r_j\).  Thus
\[
 Q(x_{ij})=0
 \quad\Longleftrightarrow\quad
 \text{the two lines share a conic point}.               \tag{16}
\]
For a star node, \(z_{ij}\ne\pm1\), so the denominator of (1) is a nonzero
square.  If \(\epsilon_{\rm int}\) denotes the prescribed character of an
internal affine point in the chosen conic convention, the full node
condition is consequently
\[
 \chi\!\left(
  \bigl(t_{ij}-a_{ij}-a_{ij}^{-1}\bigr)
  \bigl(t_{ij}-b_{ij}-b_{ij}^{-1}\bigr)
 \right)
 =\epsilon_{\rm int}\chi(-d)                            \tag{17}
\]
for all \(i<j\), with both factors nonzero.

Equation (17) is strictly smaller than the original 55 quadratic evaluations:
it compares one direction trace with two rational offset traces.

## Stop and acceptance conditions

Continue only through the rational pair invariants \(a_{ij},b_{ij}\), the
rank-two compatibility
\[
 \frac{\rho}{2}(v_i+v_i^{-1})-c_i
 =\eta u_i+\eta^q u_i^{-1},                              \tag{18}
\]
and \(\nabla\mathcal Z(c)=0\).  Do not expand the four factors separately
over \(\mathbf F_{53^2}\); equation (12) already gives their rational
descent.  Stop if a proposed contradiction uses only (17), since arbitrary
torus data need not come from the star critical system.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Offset descent | corrected | split or trace-zero coset, equations (3)--(5) |
| Node numerator | factored | four collision factors (1) |
| Base-field form | settled | two rational trace differences (2) |
| Node on conic | settled | one of four torus collisions (15) |
| Internal-node character | compressed | two-factor sign (17) |
| Full contradiction | open | retain Laurent compatibility and criticality |

## Next action

Use two rows of (18) to recover \(\eta,\eta^q\), substitute the remaining
nine rows into the rational pair invariants of (17), and contract those
relations against three selected equations of \(\nabla\mathcal Z(c)=0\).
Seek a forced zero of one factor in (17) or a zero off-diagonal separator
Hessian entry.
