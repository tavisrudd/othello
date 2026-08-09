# C756 aligned anisotropic branch: common-torus normal form

**Lane:** `clebsch` · **Date:** 2026-08-09 · **Scope:** nonsaturated
continuation of EJ3; no manuscript edit

## Verdict

In the aligned anisotropic branch \(K\sim C|_{r_0}\), all eleven arrangement
directions lie in one norm coset.  After scaling their line equations, their
normal coefficients have the form
\[
 \alpha_i=\alpha_0u_i,
 \qquad N(u_i)=1,                                         \tag{1}
\]
with the \(u_i\) distinct modulo sign.  The residual covariance Gram is then
the explicit rank-two torus kernel
\[
 B_{ij}=\frac{\nu}{2}
 \left(\frac{u_i}{u_j}+\frac{u_j}{u_i}\right),
 \qquad \nu=N(\alpha_0)\text{ nonsquare}.                 \tag{2}
\]

The conic can simultaneously be written as a translated norm circle.  Its
passant-line and internal-node conditions become exact scalar formulas in
the torus variables, line offsets, and the displacement \(\xi\) from the star
centroid to the conic center.  This isolates why covariance/conic alignment
does not collapse immediately: the common direction torus does not determine
\(\xi\).

The aligned branch is now a bounded two-torus system coupled to the EJ2
critical equations.  There is no free square-class contradiction.  The next
high-value test is whether the critical equations determine the offset
variables strongly enough to violate one of the 55 internal-node characters.

## 1. Common quadratic-extension coordinates

Work over \(L=\mathbf F_{53^2}\), with conjugation \(x\mapsto x^q\),
\(q=53\), trace \(\operatorname{Tr}\), and norm \(N\).  Identify the affine
plane over \(\mathbf F_{53}\) with the additive group of \(L\).  The star
centroid is the affine origin.

Because covariance is anisotropic and aligned with the conic restriction at
infinity, scale the common binary form so that its value on a direction
vector \(w\in L\) is \(N(w)\).  A rational affine line has an equation
\[
 r_i:\quad \operatorname{Tr}(\alpha_i x)+c_i=0,
 \qquad \alpha_i\in L^*,\quad c_i\in\mathbf F_{53}.       \tag{3}
\]
Its direction is the trace-orthogonal line to \(\alpha_i\).  If \(\tau\) is
a fixed nonzero trace-zero element, a direction vector is
\(w_i=\tau/\alpha_i\), and
\[
 N(w_i)=\frac{N(\tau)}{N(\alpha_i)}.                      \tag{4}
\]
Here \(N(\tau)=-\tau^2\) is a nonsquare because \(-1\) is a square in
\(\mathbf F_{53}\).  The arrangement directions are internal, hence have
square common-form value.  Equation (4) therefore gives
\[
 \chi(N(\alpha_i))=-1                                    \tag{5}
\]
for every \(i\).

Multiplying a line equation by \(\lambda_i\in\mathbf F_{53}^*\) changes
\(N(\alpha_i)\) by the square \(\lambda_i^2\).  All eleven nonsquare norms
can therefore be normalized to one fixed nonsquare \(\nu\).  Choose
\(\alpha_0\) with \(N(\alpha_0)=\nu\); then (1) follows.  Distinct
arrangement directions say \(u_i\ne\pm u_j\).

## 2. Covariance Gram and the EJ2 partition function

For the residual covariance form \(K=M/2\), the bilinear Gram entry of two
line normals is
\[
 B_{ij}=\tfrac12\operatorname{Tr}(\alpha_i\alpha_j^q).
\]
Substitution of (1) gives (2), while \(B_{ii}=\nu\).  Thus the aligned branch
has constant nonsquare diagonal, and every off-diagonal entry is the first
Chebyshev function of the torus ratio \(u_i/u_j\).

The matching expansion of the EJ2 partition function uses twice these
entries:
\[
 2B_{ij}=\nu
 \left(u_i/u_j+u_j/u_i\right).                            \tag{6}
\]
Consequently
\[
 \nabla\mathcal Z(c)=0                                   \tag{7}
\]
is now an explicit system in \((u_i,c_i)\), with
\(u_i^{q+1}=1\).  The separator Hessian condition remains
\[
 \partial_i\partial_j\mathcal Z(c)\ne0\qquad(i\ne j).    \tag{8}
\]

This inserts the covariance descent into \(\mathcal Z\) without any generic
rank-two elimination.

## 3. The conic as an offset norm circle

In the same affine coordinate, write the fixed conic as
\[
 \mathcal C:\quad N(x-\xi)=d,
 \qquad \xi\in L,\quad d\in\mathbf F_{53}^*.             \tag{9}
\]
Its line at infinity is the anisotropic norm form, as required.  The vector
\(\xi\) is the displacement from the star centroid to the conic center.

Translate (3) to the conic center and put
\[
 s_i=c_i+\operatorname{Tr}(\alpha_i\xi).                  \tag{10}
\]
On the line \(r_i\), the variable \(y=\alpha_i(x-\xi)\) has fixed trace
\(-s_i\), while a conic point would have norm \(dN(\alpha_i)=d\nu\).
The resulting quadratic has discriminant
\[
 \Delta_i=s_i^2-4d\nu.                                   \tag{11}
\]
For the norm-circle convention, a line is passant exactly when
\(\Delta_i\) is a nonzero square.  Hence the eleven passant conditions are
\[
 \chi(s_i^2-4d\nu)=+1.                                   \tag{12}
\]

Equation (12) itself has a one-dimensional torus parametrization.  If
\(p_i^2=s_i^2-4d\nu\) and \(\rho^2=4d\nu\) in the quadratic closure, then
\[
 s_i=\frac{\rho}{2}(v_i+v_i^{-1}),
 \qquad
 p_i=\frac{\rho}{2}(v_i-v_i^{-1}).                        \tag{13}
\]
If \(4d\nu\) is square, choose \(\rho\in\mathbf F_{53}\) and then
\(v_i\in\mathbf F_{53}^*\).  If it is nonsquare, choose
\(\rho^q=-\rho\); then \(v_i^q=-v_i\), so the \(v_i\) lie in the nonzero
trace-zero coset.  Thus the aligned branch carries the norm-one direction
torus \(u_i\) and a split-or-trace-zero offset parametrization \(v_i\).

## 4. Exact internal-node numerator

Let \(x_{ij}=r_i\cap r_j\) and define
\[
 T_{ij}=\operatorname{Tr}(\alpha_i\alpha_j^q),
 \qquad
 D_{ij}=\alpha_i\alpha_j^q-\alpha_j\alpha_i^q.           \tag{14}
\]
Distinct directions give \(D_{ij}\ne0\), and
\[
 D_{ij}^2=T_{ij}^2-4\nu^2.                               \tag{15}
\]
Solving the two trace equations in (3), after translating by \(\xi\), gives
\[
 N(x_{ij}-\xi)=
 \frac{-\nu(s_i^2+s_j^2)+s_is_jT_{ij}}{D_{ij}^2}.         \tag{16}
\]
Therefore
\[
 \boxed{
 D_{ij}^2Q(x_{ij})=
 -\nu(s_i^2+s_j^2)+s_is_jT_{ij}-dD_{ij}^2,}               \tag{17}
\]
where \(Q(x)=N(x-\xi)-d\) is the conic quadratic.

All 55 nodes are internal, so the right side of (17), after accounting for
the fixed character of \(D_{ij}^2\), must have one prescribed square class
for every pair.  In torus variables,
\[
 T_{ij}=\nu(u_i/u_j+u_j/u_i),
 \quad
 D_{ij}^2=\nu^2(u_i/u_j-u_j/u_i)^2.                       \tag{18}
\]
Equations (12), (17), and (18) are the full conic input missing from the
critical system (7).

## 5. Exact elimination of the conic-center offset

The displacement \(\xi\) need not be eliminated by a general resultant.  Put
\[
 \eta=\alpha_0\xi.
\]
Since \(\alpha_i=\alpha_0u_i\) and \(u_i^q=u_i^{-1}\), equation (10) becomes
\[
 \boxed{
 s_i-c_i=\eta u_i+\eta^q u_i^{-1}.}                       \tag{19}
\]
Thus the eleven-component offset vector \((s_i-c_i)_i\) lies in the
two-dimensional Laurent evaluation code spanned by \((u_i)_i\) and
\((u_i^{-1})_i\).  Equivalently, for every triple of indices,
\[
 \det\!\begin{pmatrix}
 s_i-c_i&u_i&u_i^{-1}\\
 s_j-c_j&u_j&u_j^{-1}\\
 s_k-c_k&u_k&u_k^{-1}
 \end{pmatrix}=0.                                         \tag{20}
\]
Because the directions are distinct modulo sign, two suitable rows recover
\(\eta,\eta^q\); all remaining equations are compatibility tests.

The conic scale is equally simple.  Put
\[
 A=4d\nu.
\]
The passant conditions can be written
\[
 p_i^2=s_i^2-A,
 \qquad p_i\ne0,                                          \tag{21}
\]
so elimination of \(d\) is exactly
\[
 s_i^2-p_i^2=s_j^2-p_j^2\qquad\text{for all }i,j.         \tag{22}
\]
Conversely, any \((\eta,A,s_i,p_i)\) satisfying (19), (21) recovers
\(\xi=\eta/\alpha_0\) and \(d=A/(4\nu)\).  Hence (19)--(22) lose no
solutions.

Using the offset-torus parametrization (13), the same compatibility is
\[
 \frac{\rho}{2}(v_i+v_i^{-1})-c_i
 =\eta u_i+\eta^q u_i^{-1},                               \tag{23}
\]
with one common \(\rho^2=A\).  This is a coupling of two rank-two torus
evaluation codes, not an unrestricted system in eleven offsets.

## 6. What alignment does and does not buy

Alignment has three genuine consequences:

- all direction normals lie on the single norm coset (1);
- the covariance Gram is the explicit torus kernel (2); and
- there are no triple fibres, since the common form is anisotropic.

It does **not** identify the star centroid with the conic center.  The
critical equations use \(c_i\), while the conic characters use
\[
 s_i=c_i+\operatorname{Tr}(\alpha_i\xi).                  \tag{24}
\]
The two coordinates of \(\xi\) are precisely the surviving translation
freedom.  Ignoring (24) would manufacture a false common-origin
contradiction.

The system is nevertheless bounded: eleven norm-one variables \(u_i\),
eleven offset-torus variables \(v_i\), the two-coordinate displacement
\(\xi\), and one conic scale \(d\), modulo the common torus and affine
normalizations.  No coefficient of degree 16 or higher is required.

## Stop and acceptance conditions

The affine displacement and conic scale are already eliminated by
(19)--(22).  The next pass should combine the rank-two compatibility minors
(20) or the two-torus equations (23) with \(\nabla\mathcal Z=0\), then insert
the surviving offsets into the pair characters (17).

Stop if the elimination expands to an unrestricted 11-variable system or
if the offset \(\xi\) is silently set to zero.  The latter is not licensed by
centroid normalization.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Arrangement direction normalization | settled | one nonsquare norm coset (1) |
| Covariance Gram | settled | torus kernel (2) |
| Passant-line condition | settled | square discriminants (12) |
| Internal-node condition | settled | numerator (17) |
| Why alignment does not instantly close | settled | unknown center displacement \(\xi\) |
| Full contradiction | open | combine (7)--(8) with (12), (17) |
| Elimination of \(\xi,d\) | settled | rank-two Laurent code (19)--(22) |
| Cheapest next test | identified | combine code compatibility with \(\nabla\mathcal Z=0\) |

## Next action

Combine three critical derivative equations with the rank-two minors (20),
using two rows to solve for \(\eta\).  Express the remaining \(s_i\) through
the offset torus (23), and test whether the internal-node numerators (17)
force a relation incompatible with the remaining critical equations or the
nonzero separator Hessian.
