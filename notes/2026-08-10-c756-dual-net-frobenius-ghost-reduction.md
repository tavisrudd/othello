# C756 dual-net Frobenius-ghost reduction

**Lane:** `clebsch` · **Date:** 2026-08-10 · **Scope:** structural
extension-field reduction; no fixed-field census and no manuscript edit

## Verdict

The coherent dual 3-net admits a characteristic-free reduction to one split
polynomial of degree \((q-3)/2\).  In coordinates adapted to the involution
exchanging the two affine components, every hypothetical saturated-internal
configuration has the form
\[
 \mathcal A=\{(x,S(x)):x\in\Omega\},\qquad
 \mathcal B=\{(x,-S(x)):x\in\Omega\},                       \tag{1}
\]
after one harmless scaling, where
\[
 RS=X^q-X,\qquad
 \Omega=\{x\in\mathbb F_q:S(x)\ne0\},qquad
 \deg R=\frac{q+3}{2},\quad \deg S=\frac{q-3}{2}.          \tag{2}
\]
Both \(R\) and \(S\) are monic and split with simple roots over
\(\mathbb F_q\).

The desired conic conclusion is exactly
\[
 \boxed{R\mid S^2-H\quad\text{for some }H\in\mathbb F_q[X],
                         \ \deg H\le2.}                    \tag{3}
\]
Equivalently, the middle band of the ordinary cube of \(S\) vanishes:
\[
 \boxed{[X^j]S^3=0\qquad
        \frac{q+3}{2}\le j\le q-1.}                       \tag{4}
\]

The dual-net factorization proves (4) outside an explicit Frobenius-ghost
set.  Write \(p=\operatorname{char}\mathbb F_q\) and
\(n=(q+3)/2\).  If
\[
 \frac{S^3}{X^q-X}=A(X)+\sum_{r\ge1}c_rX^{-r},             \tag{5}
\]
then
\[
 r(r+1)c_r=0\qquad(1\le r\le n-3).                        \tag{6}
\]
Thus every required coefficient vanishes except possibly the two residue
classes
\[
 \boxed{r\equiv0,-1\pmod p.}                              \tag{7}
\]
If \(q=p^e\), the interval \(1\le r\le(q-3)/2\) contains exactly
\[
 \left\lfloor\frac{q-3}{2p}\right\rfloor+
 \left\lfloor\frac{q-1}{2p}\right\rfloor
 =p^{e-1}-1=\frac qp-1                                  \tag{35}
\]
such slots.  Thus the first divided coefficient reduces a
\((q-3)/2\)-dimensional conic gap to a \(q/p-1\)-dimensional Frobenius
module.
For prime fields there are no such indices in the relevant range, recovering
the structural prime-field theorem.  Over proper extensions, (7) is the
entire first obstruction: the old vague statement that Newton identities
"cross the characteristic" has become a two-slot \(p\)-typical Laurent
tail.  The next theorem must kill these ghosts using the higher odd divided
coefficients of the same completely reducible pencil; no additional census
is relevant.

The higher power rungs now have a denominator-free ordinary-linear model:
their common kernel is \(\ker\mathbb M_R\) for the stacked
Cartier--Toeplitz matrix (74).  Row count forces a kernel only at the live
parameters \(q=25,27,81\); elsewhere kernel existence is an explicit
determinantal rank condition.  The first non-shadow equation is a mixed
quadratic/cubic bundle in characteristics three and five.  For \(p\ge7\),
all conic--ghost cross terms vanish and it descends to a pure quadratic map
on \(\ker\mathbb M_R\).  This is the current exact structural gate.

## 1. Completely reducible pencil identity

Put \(n=(q+3)/2\), \(h=n-1=(q+1)/2\), and identify
\(AG(2,q)\) with \(\mathbb F_{q^2}=\mathbb F_q(\delta)\), where
\(\delta^2=d\) is nonsquare and conjugation sends \(\delta\) to
\(-\delta\).  The involution has affine form
\((x,y)\mapsto(x,-y)\).  The coherent dual 3-net therefore has components
\[
 \mathcal A=\{(x_i,y_i):1\le i\le n\},\qquad
 \mathcal B=\{(x_i,-y_i):1\le i\le n\}.                   \tag{8}
\]
The trace-zero direction is vertical.  Its net lines join
\((x_i,y_i)\) to \((x_i,-y_i)\), and contain no second component point;
hence the \(x_i\) are distinct.  Also \(y_i\ne0\), since the original
quadratic points are internal.

Let \(c=(-1)^h\), and let \(D\) be the \(h\) finite directions whose
quadratic character is \(-c\).  For every \(m\in D\), the two projection
multisets agree:
\[
 \{mx_i-y_i:i\}=\{mx_i+y_i:i\}.                            \tag{9}
\]
Consequently the two Redei products
\[
 P_\pm(U,V,W)=\prod_{i=1}^n(U+Vx_i\pm Wy_i)                \tag{10}
\]
satisfy
\[
 \boxed{P_+-P_-=\gamma WQ_D(V,W)}                         \tag{11}
\]
for some \(\gamma\in\mathbb F_q^*\), where \(Q_D\) is the
degree-\(h\) binary form cutting out \(D\).  Indeed, every coefficient of
\(U^{n-r}\) in the difference has degree at most \(r\) in the slope and
vanishes on all \(h=n-1\) directions.  Its leading slope coefficient is also
zero, because it is the same elementary symmetric function of the common
\(x_i\)'s on both sides.  Thus its degree is at most \(r-1\), and it is zero
for \(r<n\).  For \(r=n\) it is a scalar multiple of the direction
polynomial.  Homogeneity supplies the extra vertical factor \(W\).

This direction polynomial is explicit.  If \(s=-c\), then, up to a nonzero
ground-field scalar,
\[
 Q_D(V,W)=
 \begin{cases}
 (W-\delta V)^h-s(W+\delta V)^h,&s=-1,\\[2mm]
 \delta^{-1}\bigl((W-\delta V)^h-s(W+\delta V)^h\bigr),&s=1.
 \end{cases}                                               \tag{12}
\]
For a direction vector \(1+m\delta\), the norm-one ratio is
\((1-m\delta)/(1+m\delta)\); raising it to \(h\) is precisely its
\(\mathbb F_{q^2}\) quadratic character.  This proves (12) and also shows
directly that its roots are simple and equal to \(D\).

Equation (11) is stronger than equality of ordinary moments: it retains all
divided coefficients in every characteristic.  It describes a pencil with
three completely reducible fibers, one of them concurrent, and an involution
exchanging the other two.

## 2. The one-odd-coordinate coefficient

For \(0\le a\le n-2\), the coefficient of
\(U^{n-a-1}V^aW\) on the right of (11) is zero.  On the left it gives
\[
 \sum_{i=1}^n y_i e_a(x_1,\ldots,\widehat{x_i},\ldots,x_n)=0. \tag{13}
\]
The elementary identity
\[
 e_a(\widehat{x_i})=
 \sum_{r=0}^a(-1)^r e_{a-r}(x_1,\ldots,x_n)x_i^r           \tag{14}
\]
makes (13) triangular with leading coefficient \((-1)^a\).  Induction gives
the characteristic-free moment string
\[
 \sum_i x_i^a y_i=0\qquad(0\le a\le n-2).                 \tag{15}
\]

Let
\[
 R(X)=\prod_{i=1}^n(X-x_i).                               \tag{16}
\]
The Vandermonde matrix in (15) has a one-dimensional nullspace, generated by
the barycentric weights \(1/R'(x_i)\).  Hence
\[
 y_i=\frac{\kappa}{R'(x_i)}                               \tag{17}
\]
for a fixed \(\kappa\ne0\).

Because every \(x_i\) is rational, \(R\mid X^q-X\).  Define the monic
complement
\[
 S(X)=\frac{X^q-X}{R(X)},qquad \deg S=q-n=n-3.            \tag{18}
\]
Differentiating (18) at \(x_i\) gives
\[
 -1=R'(x_i)S(x_i).                                        \tag{19}
\]
Thus \(y_i=-\kappa S(x_i)\).  Scaling the \(y\)-coordinate absorbs
\(-\kappa\) and proves (1)--(2).  This derivation is valid over every odd
prime power and uses no power-sum division.

## 3. Exact conic criterion

Suppose a conic contains all points \((x_i,\pm S(x_i))\).  Subtracting its
equations at the two signs shows that its \(xy\) and \(y\) coefficients
vanish: \(S(x_i)\ne0\), and the \(x_i\) are distinct.  The coefficient of
\(y^2\) cannot vanish, since then a nonzero quadratic in \(x\) would vanish
at \(n>2\) points.  Therefore the conic has equation
\[
 y^2=H(x),qquad \deg H\le2,                              \tag{20}
\]
which is equivalent to (3).  The converse is immediate.

There is also a useful barycentric form.  A function \(v_i\) on the roots of
\(R\) is represented by a polynomial of degree at most two exactly when
\[
 \sum_i\frac{x_i^a v_i}{R'(x_i)}=0
 \qquad(0\le a\le n-4).                                  \tag{21}
\]
Taking \(v_i=S(x_i)^2\) and using \(1/R'(x_i)=-S(x_i)\)
turns (21) into
\[
 \sum_{x\in\mathbb F_q}x^aS(x)^3=0
 \qquad(0\le a\le n-4),                                  \tag{22}
\]
because \(S\) vanishes on the complement of \(\Omega\).

The degree of \(x^aS^3\) is below \(2(q-1)\).  Summing monomials over
\(\mathbb F_q\) therefore extracts only the coefficient of \(X^{q-1}\).
As \(a\) ranges through (22), this proves the equivalence with the band
(4).

## 4. The first Frobenius-ghost equation

Let \(H_2\) be the remainder of \(S^2\) modulo \(R\), so \(\deg H_2<n\),
and put
\[
 F(Z)=\frac{H_2(Z)}{R(Z)}
     =\sum_i\frac{S(x_i)^2}{R'(x_i)(Z-x_i)}
     =-\sum_i\frac{S(x_i)^3}{Z-x_i}.                      \tag{23}
\]
The sign is immaterial.  Equivalently, \(F\) is the proper Laurent part of
\(S^3/(X^q-X)\), which gives (5).

Now set \(a_i=S(x_i)/(Z-x_i)\).  The coefficient of three odd coordinates
in (11) says that the third elementary symmetric function
\(e_3(a_1,ldots,a_n)\) is \(O(Z^{-n})\) at infinity.  The same is true for
\(e_1\), while the even elementary functions have their ordinary orders.
Newton's identity
\[
 p_3-e_1p_2+e_2p_1-3e_3=0                               \tag{24}
\]
therefore yields
\[
 p_3(a_1,ldots,a_n)=O(Z^{-n}).                           \tag{25}
\]
This remains valid in characteristic three: then \(p_3=e_1^3\).

On the other hand, the second Hasse derivative of (23) is
\[
 D_Z^{(2)}F=\sum_i\frac{S(x_i)^3}{(Z-x_i)^3}=p_3(a_i),     \tag{26}
\]
up to the fixed sign convention.  If
\(F=\sum_{r\ge1}c_rZ^{-r}\), then
\[
 D_Z^{(2)}F=\sum_{r\ge1}\binom{r+1}{2}c_rZ^{-r-2}.        \tag{27}
\]
Equations (25)--(27) give (6).  Since \(p\) is odd,
\(\binom{r+1}{2}=0\) exactly when \(r\equiv0,-1\pmod p\).

Finally, \(\deg H_2\le2\) is equivalent to
\(c_1=\cdots=c_{n-3}=0\).  Thus (7) is precisely the residual failure of
the conic conclusion, not merely a sufficient-condition artifact.

## 5. Translation stability is not an extra equation

The reduction is stable under every translation \(x\mapsto x+a\):
\(R_a(X)=R(X-a)\), \(S_a(X)=S(X-a)\), and the translated rational tail is
\[
 F_a(Z)=F(Z-a).                                           \tag{31}
\]
This does **not** shrink (7).  If \(r\equiv0\pmod p\), then
\[
 (Z-a)^{-r}=Z^{-r}(1-a^pZ^{-p})^{-r/p}
\]
has only exponents congruent to \(r\) modulo \(p\).  If
\(r\equiv-1\pmod p\), then
\[
 (1-aZ^{-1})^{-r}
 =(1-aZ^{-1})(1-a^pZ^{-p})^{-(r+1)/p},
\]
so only the two residues \(-1,0\pmod p\) occur.  Hence the Laurent ghost
space in (7) is translation-stable.

This also marks a useful stop rule: one may not transfer the residue
restriction on the Laurent coefficients of \(H_2/R\) to the ordinary
monomial support of \(H_2\).  The denominator \(R\) mixes those coefficients.
Affine translations and scalings preserve the ghost module; a successful
argument must use multiplication among the higher remainders or a genuinely
projective/Cartier invariant.

## 6. Higher odd divided ghosts

The first ghost space has an intrinsic Cartier description.  Up to the
precision required for the conic criterion, (6)--(7) say exactly that
\[
 F(Z)=A(Z^{-p})+ZB(Z^{-p})+O(Z^{-(n-2)})                 \tag{37}
\]
for Laurent polynomials \(A,B\) with no terms producing nonnegative powers
of \(Z\).  In other words, the surviving tail is the rank-two
\(\mathbb F_q(Z^p)\)-module
\[
 \ker D_Z^{(2)}=\mathbb F_q(Z^p)+Z\mathbb F_q(Z^p)       \tag{38}
\]
at the relevant truncation.  This is the precise Cartier/Frobenius meaning
of the two residues \(0,-1\pmod p\).

Equivalently, move infinity to the formal origin by setting \(t=Z^{-1}\)
and introducing reciprocal polynomials
\[
 R^\vee(t)=t^nR(t^{-1}),\qquad
 H_2^\vee(t)=t^{n-1}H_2(t^{-1}).                         \tag{41}
\]
Since \(R^\vee(0)=1\), the first ghost condition is precisely the
two-component Frobenius--Pade congruence
\[
 \boxed{
 \frac{tH_2^\vee(t)}{R^\vee(t)}
 \equiv A_0(t^p)+t^{p-1}C(t^p)\pmod {t^{n-2}}.}          \tag{42}
\]
Here \(A_0(0)=0\); the constant term of \(C\) accounts for the first possible
index \(p-1\).  Multiplying by the unit \(R^\vee\) makes (42) a finite
linear congruence.  Thus the extension seam can also be viewed as a
rank-two Frobenius--Pade numerator problem for a reciprocal polynomial that
splits completely after returning to the \(Z\)-coordinate.  The nonlinear
conditions below impose the missing compatibility with
\(H_2\equiv S^2\pmod R\).

This congruence has an exact finite-dimensional excess quotient.  Define
\[
 \mathcal V_R=\left\{H:\deg H<n,
   D_Z^{(2)}(H/R)=O(Z^{-n})\right\},\qquad
 \mathcal C_R=\{H:\deg H\le2\}.                         \tag{46}
\]
The first \(n\) Laurent coefficients of \(H/R\) are triangular coordinates
on the \(n\)-dimensional numerator space.  Among the first \(n-3\), exactly
\(q/p-1\) ghost coordinates survive.  Therefore
\[
 \boxed{
 \dim\mathcal V_R=\frac qp+2,\qquad
 \dim\mathcal C_R=3,\qquad
 \dim(\mathcal V_R/\mathcal C_R)=\frac qp-1.}            \tag{47}
\]
The last quotient is the finite saturated ghost module.  It is the precise
analogue of the defect module in the nonsaturated branch: conic containment
means that the class of the actual remainder \(H_2\) vanishes in (47).

There is a root-set realization of this quotient that removes all polynomial
division from the higher equations.  Put
\[
 w_i=\frac1{R'(x_i)}=-S(x_i),\qquad h_i=H_2(x_i).
\]
For any numerator \(H\) of degree less than \(n\), partial fractions give
\[
 \frac{H(Z)}{R(Z)}
 =\sum_{i=1}^n\frac{H(x_i)w_i}{Z-x_i},
 \qquad
 [Z^{-r}]\frac HR
 =\sum_{i=1}^n H(x_i)w_ix_i^{r-1}.                       \tag{50}
\]
Evaluation on the roots identifies the numerator space with
\(\mathbb F_q^n\).  Under this identification, \(\mathcal C_R\) is the
degree-two Reed--Solomon evaluation code, while \(\mathcal V_R\) is obtained
by deleting exactly the \(q/p-1\) ghost parity checks from its barycentric
dual checks.

More generally, because \(H_{2j}(x_i)=h_i^j\), equation (28) has the exact
syndrome form
\[
 c_{j,r}=\sum_{i=1}^n h_i^jw_ix_i^{r-1}.                 \tag{51}
\]
For the actual complementary-factor remainder,
\(h_i=S(x_i)^2=w_i^2\), so define the Lucas-visible exponent set
\[
 \mathscr E_j=\left\{m:0\le m\le n-2j-2,
   \binom{m+2j}{2j}\ne0\pmod p\right\}.                 \tag{52}
\]
Then the whole odd hierarchy is equivalent to the root-set moment system
\[
 \boxed{
 \sum_{i=1}^n w_i^{2j+1}x_i^m=0
 \qquad(m\in\mathscr E_j,\ 2j+1<n).}                    \tag{53}
\]
Thus the saturated all-\(q\) theorem can be stated without \(H_{2j}\):
classify the \(n\)-subsets of \(\mathbb F_q\) whose barycentric weights
satisfy (53), and prove that their squared weight vector
\((w_i^2)\) lies in the degree-two evaluation code.  The Frobenius--Cartier
tower is the subfamily \(j=p^a\); the first useful additional rung is
specified in (58).

The root-set form also reveals a Frobenius reflection between different
rungs.  For a positive exponent define its reduction as a function on the
whole field by
\[
 \rho_q(d)=1+((d-1)\bmod(q-1)),\qquad \rho_q(0)=0.       \tag{54}
\]
If the \(j=p^a\) moment in (53) vanishes, raise it to
\(p^{e-a}\).  Since every \(w_i\ne0\) and
\(w_i^{2q}=w_i^2\), this gives
\[
 \boxed{
 \sum_i w_i^{p^{e-a}+2}
          x_i^{\rho_q(mp^{e-a})}=0.}                     \tag{55}
\]
The weight exponent in (55) is \(2j^\vee+1\), where
\[
 j^\vee=\frac{p^{e-a}+1}{2}.
\]
For every \(1\le a\le e-1\), this reflected rung satisfies
\(2j^\vee+1<n\).  Hence each available power rung contributes a rotated
set of generally high monomial exponents to a native non-power rung.  At
\(q=25\), the three visible \(j=5\) exponents \(m=0,1,2\) reflect to the
\(j^\vee=3\) exponents \(0,5,10\); at \(q=27\), the visible \(j=3\)
exponents reflect to the \(j^\vee=5\) exponents \(0,9,18\).  These are
structural digit rotations, not field censuses.  They identify the first
extra checks to combine with the first non-shadow rung on the forced kernels.

There is also a uniform family of shadow rungs that must be removed from the
route.  Whenever \(p^b<n\), set
\[
 j_b=\frac{p^b-1}{2},\qquad 2j_b+1=p^b.
\]
Lucas' theorem gives
\[
 \binom{m+p^b-1}{p^b-1}\ne0\pmod p
 \quad\Longleftrightarrow\quad m\equiv0\pmod {p^b}.     \tag{56}
\]
Writing \(m=p^bt\), the corresponding equation in (53) is merely
\[
 \sum_iw_i^{p^b}x_i^{p^bt}
 =\left(\sum_iw_ix_i^t\right)^{p^b}=0,                   \tag{57}
\]
the Frobenius image of the standard barycentric identity.  Thus every rung
with \(2j+1\) a pure power of \(p\) is tautological.  In characteristic
three this includes \(j=1,4,13,\ldots\); in characteristic five it includes
the quadratic rung \(j=2\).  Consequently the first useful additional
non-shadow rung after the tower constraints is
\[
 j=2\quad(p=3\text{ or }p\ge7),
 \qquad j=3\quad(p=5).                                   \tag{58}
\]
For \(q=25\), the native \(j=3\) visible exponents are
\(\{0,1,2,3,5,6\}\), and reflection adds \(10\).  For \(q=27\), the
native \(j=2\) visible exponents are \(\{0,1,3,4,9\}\), while the reflected
\(j=5\) rung supplies \(\{0,9,18\}\).  These are the correct first kernel
tests.  The row-budget theorem (77)--(78) below reveals one further forced
seam, \(q=81\).  There the native \(j=2\) set is
\[
 \{0,1,3,4,9,10,12,13,18,19,21,22,27,28,30,31,36\}.
\]
The \(j=9\) power rung reflects into the successor \(j=5\) and adds
\(\{0,9,18,27,36,45,54,63,72\}\); the \(j=3\) rung reflects into
\(j=14\) and adds
\(\{0,3,6,9,27,30,33,36,54,57,60,63\}\).
Thus all dimension-forced low-characteristic kernel tests are explicit.

Reflection always lands immediately after one of these shadows.  If
\(b=e-a\), put
\[
 j_b^- =\frac{p^b-1}{2},
 \qquad
 j_b^+ =\frac{p^b+1}{2}=j_b^-+1.                         \tag{65}
\]
The \(j=p^a\) power rung reflects into the successor \(j_b^+\), while
\(j_b^-\) is the tautological shadow.  Their interpolants obey
\[
 \boxed{
 P_{j_b^+}\equiv H_2P_{j_b^-}\pmod R,
 \qquad
 P_{j_b^-}(x_i)=w_i^{p^b-1}\ne0.}                        \tag{66}
\]
Thus every available digit level probes the same unknown \(H_2\) as the
ratio of a reflected successor and a canonical nowhere-zero shadow.  The
two smallest forced seams are the first instances:
\((j_b^-,j_b^+)=(2,3)\) at \(q=25\), and \((4,5)\) at \(q=27\); at
\(q=81\) the reflected pairs are \((4,5)\) and \((13,14)\).  A uniform
proof may therefore be
organized as rigidity of the shadow--successor ratios (66), rather than as
unrelated higher powers.

The consecutive part of every syndrome set has a closed digit formula.  Put
\[
 L_j=n-2j-2,
 \qquad s_j=v_p(j),
 \qquad d_j\equiv\frac{2j}{p^{s_j}}\pmod p,
 \quad 1\le d_j\le p-1.                                  \tag{59}
\]
By Kummer's carry criterion, the first carry in adding \(m\) to \(2j\)
occurs at \(m=p^{s_j}(p-d_j)\).  Hence the largest initial interval contained
in \(\mathscr E_j\) is
\[
 \boxed{
 \{0,1,\ldots,D_j\}\subseteq\mathscr E_j,
 \qquad
 D_j=\min\{L_j,\ p^{s_j}(p-d_j)-1\}.}                   \tag{60}
\]

Let \(P_j\) be the degree-less-than-\(n\) interpolant of the vector
\((w_i^{2j})_i\); thus \(P_j=H_{2j}\).  The standard barycentric duality
\[
 \left(\operatorname{RS}_{D_j}\right)^\perp
 =w\,\operatorname{RS}_{n-D_j-2}
\]
turns the prefix in (60) into the exact degree bound
\[
 \boxed{\deg P_j\le\nu_j:=n-D_j-2.}                     \tag{61}
\]
The non-prefix elements of \(\mathscr E_j\), together with the reflected
set (55), are additional linear checks on this bounded interpolant.

Finally the interpolants form one multiplication orbit:
\[
 P_0=1,
 \qquad P_1=H_2,
 \qquad P_{j+1}\equiv H_2P_j\pmod R.                    \tag{62}
\]
This orbit has an exact cyclic closure that is useful once reduction modulo
\(R\) begins.  Put \(N=(q-1)/2\).  Since
\(H_2(x_i)=w_i^2\in(\mathbb F_q^*)^2\),
\[
 \boxed{
 P_N=1,
 \qquad P_{j+N}=P_j,
 \qquad P_jP_{N-j}\equiv1\pmod R.}                      \tag{62a}
\]
There is also a semilinear rotation of the index circle.  If
\(\Phi_b(\sum_ra_rX^r)=\sum_ra_r^{p^b}X^{rp^b}\), and
\([u]_N\) denotes the residue in \(\{0,\ldots,N-1\}\), then
\[
 \boxed{
 P_{[p^bj]_N}\equiv\Phi_b(P_j)\pmod R.}                 \tag{62b}
\]
Indeed, both sides take the value \(w_i^{2p^bj}\) at every root of \(R\).
Thus the wrapped problem is finite: it is a cyclic Krylov orbit of length
dividing \(N\), equipped with the permutation \(j\mapsto[pj]_N\) and the
degree flags (61) on the available half of the indices.  In particular,
the inverse of every flagged state is another named orbit state, rather than
an unrelated polynomial.  A common-kernel classification may therefore be
made orbit-by-orbit under multiplication by \(p\) on \(\mathbb Z/N\mathbb Z\),
then intersected with the carry and sparse syndrome checks.  This is the
finite wrapped counterpart of the no-wrap sieve (67)--(68).
For \(e\ge2\), multiplication by \(p\) has order exactly \(e\) modulo
\(N\): one has \(p^e\equiv1\pmod N\), whereas
\(0<p^b-1<N\) for \(0<b<e\).  Hence every index orbit in (62b) has length
dividing \(e\), and Burnside gives the field-independent inventory
\[
 \boxed{
 \#\bigl((\mathbb Z/N\mathbb Z)/\langle p\rangle\bigr)
 =\frac1e\sum_{b=0}^{e-1}\gcd(N,p^b-1).}                \tag{62c}
\]
The semilinear compatibility of the wrapped states is therefore local on
cycles of at most the extension degree, even though the polynomial carrier
has size on the scale of \(q\).

Thus the saturated extension theorem is equivalently a **carry-flag
rigidity statement**: if multiplication by \(H_2\) drives the orbit (62)
through all digit bounds (61) and all sparse/reflected checks, then
\(\deg H_2\le2\).  This formulation separates the universal mechanism
(multiplication by one residue class) from the characteristic dependence
(the explicit carry profile \(D_j\)).

The top Frobenius rung already gives a uniform degree gap.  Assume
\(p\ge5\), put \(s=q/p=p^{e-1}\), and take \(j=s\).  This rung is available,
and its first-carry threshold is \(s(p-2)\), larger than
\(L_s=n-2s-2\).  Hence \(D_s=L_s\), so (61) gives
\[
 \deg P_s\le2s.                                          \tag{63}
\]
If \(3\le d:=\deg H_2\le(p-1)/2\), then \(sd<n\), so no reduction modulo
\(R\) occurs in \(P_s=H_2^s\).  Therefore
\(\deg P_s=sd>2s\), contradicting (63).  Consequently
\[
 \boxed{
 \deg H_2\le2
 \quad\text{or}\quad
 \deg H_2\ge\frac{p+1}{2}\qquad(p\ge5).}                \tag{64}
\]
Thus every proper-extension counterexample outside the conic branch must
start at characteristic-scale degree; no bounded low-degree ghost family can
survive as \(p\) grows.

The same argument is not tied to the top rung.  If
\(d=\deg H_2\) and \(jd<n\), then the multiplication orbit has not yet
wrapped modulo \(R\), so
\[
 P_j=H_2^j,
 \qquad \deg P_j=jd.
\]
Combining this identity with (61) gives the universal no-wrap test
\[
 \boxed{
 jd<n\quad\Longrightarrow\quad jd\le \nu_j.}           \tag{67}
\]
Equivalently, every integer degree in
\[
 \boxed{
 \mathfrak D_{p,e}
 =\bigcup_{2j+1<n}
   \left\{d:\ \nu_j<jd<n\right\}}                      \tag{68}
\]
is structurally forbidden.  The set (68) is determined solely by the
base-\(p\) digits of \(j\), through (59)--(61); it involves no choice of a
field model or root subset.  Formula (64) is the single-rung interval
obtained from \(j=q/p\), while (68) retains every carry interval at once.
It is the exact degree-level front end of the carry-flag problem: only the
complement of \(\{0,1,2\}\cup\mathfrak D_{p,e}\) can require the genuinely
wrapped multiplication and sparse/reflected checks.

There is a small characteristic-three gain that the \(p\ge5\) top-rung
statement does not see.  For \(q=3^e\), \(e\ge3\), put \(s=q/9\) and take
\(j=s\).  Here the first carry occurs at \(s\), so
\[
 D_s=s-1,
 \qquad \nu_s=n-s-1=\frac{7s+1}{2}.
\]
If \(d=4\), then \(4s<n=(9s+3)/2\), but
\(4s>(7s+1)/2\) because \(s>1\), contradicting (67).  Hence
\[
 \boxed{
 \deg H_2\ne4\qquad(q=3^e,\ e\ge3).}                   \tag{69}
\]
Degree three remains a genuine wrapped/sparse seam and is not excluded by
this argument.

The same pencil supplies a hierarchy, not just (6).  For
\(b=2j+1<n\), let \(H_{2j}\) be the degree-\(<n\) remainder of
\(S^{2j}\) modulo \(R\), and write
\[
 \frac{H_{2j}(Z)}{R(Z)}=\sum_{r\ge1}c_{j,r}Z^{-r}.         \tag{28}
\]
The coefficient of \(W^{2j+1}\) in (11), together with the lower odd
coefficients, gives
\[
 D_Z^{(2j)}\left(\frac{H_{2j}}R\right)=O(Z^{-n}),          \tag{29}
\]
and hence
\[
 \boxed{\binom{r+2j-1}{2j}c_{j,r}=0
        \qquad(1\le r\le n-2j-1).}                       \tag{30}
\]
This is the divided-power replacement for the broken high-degree moment
argument.  Lucas' theorem makes every blind digit pattern in (30) explicit.
The coupling among the remainders is itself an exact Laurent identity.
Since \(H_2=RF\) and \(H_{2j}\equiv H_2^j\pmod R\),
\[
 \boxed{
 \frac{H_{2j}}R
 =\operatorname{pr}_{<0}\!\left(R^{j-1}F^j\right),}      \tag{39}
\]
where \(\operatorname{pr}_{<0}\) denotes the proper Laurent part at
infinity.  Thus (30) is one nonlinear Cartier system on the single
rank-two tail (37), not a family of independent ghost supports.

For example, the first new equation is
\[
 \frac{H_4}R=\operatorname{pr}_{<0}(RF^2),
 \qquad
 \binom{r+3}{4}[Z^{-r}]\operatorname{pr}_{<0}(RF^2)=0.
                                                               \tag{40}
\]
For \(p\ge5\), its blind residues are
\(r\equiv0,-1,-2,-3\pmod p\).  The point of (40) is not that this larger
blind set alone helps, but that multiplication by the fixed split factor
\(R\) forces the square of the two-residue tail (37) into it.  Higher
\(j\) impose the analogous constraints on
\(\operatorname{pr}_{<0}(R^{j-1}F^j)\).

The distinguished uniform rung is \(j=p\).  It is available when
\(2p+1<n\), equivalently \(q>4p-1\).  This holds for every proper extension
field in the live branch: for \(p\ge5\), already \(p^2>4p-1\), while for
\(p=3\) the only exception is the separately closed field \(q=9\).  At this
rung, (39) becomes
\[
 \boxed{
 \frac{H_{2p}}R
 =\operatorname{pr}_{<0}(R^{p-1}F^p),\qquad
 F^p=\sum_{r\ge1}c_r^pZ^{-pr}.}                          \tag{43}
\]
The corresponding multiplier is
\(\binom{r+2p-1}{2p}\).  Since \(2p\) has base-\(p\) digits \((2,0)\),
Lucas' theorem says that this multiplier is nonzero exactly when the
\(p\)-digit of \(r+2p-1\) is at least two.  Thus (43) is the first canonical
equation that couples the two-residue first tail to the next base-\(p\)
digit.  It supplies a uniform all-extension schedule: use the quadratic
rung (40) for local multiplicative pressure and the Frobenius rung (43) for
digit propagation.

In fact (43) is the first member of a Frobenius--Cartier tower.  Whenever
\(2p^a+1<n\), take \(j=p^a\) in (39).  Then
\[
 \frac{H_{2p^a}}R
 =\operatorname{pr}_{<0}\!\left(R^{p^a-1}F^{p^a}\right),
 \qquad
 F^{p^a}=\sum_{r\ge1}c_r^{p^a}Z^{-p^ar}.                \tag{44}
\]
Let \(\Pi_a\) retain, in the range of (30), precisely those Laurent indices
for which the \(a\)-th base-\(p\) digit of
\(r+2p^a-1\) is at least two.  Lucas' theorem rewrites the whole rung as
\[
 \boxed{
 \mathcal L_{R,a}(F):=
 \Pi_a\operatorname{pr}_{<0}
       \!\left(R^{p^a-1}F^{p^a}\right)=0.}               \tag{45}
\]
The map \(\mathcal L_{R,a}\) is \(p^a\)-semilinear in \(F\).  Thus these
rungs are finite semilinear constraints in \(F\), for fixed \(R\), not
higher-degree polynomial searches.  Moreover, if \(H\in\mathcal C_R\), then
\(H^{p^a}/R\) begins at Laurent order at least
\(n-2p^a\), just beyond the constrained range in (30).  Hence every
\(\mathcal L_{R,a}\) annihilates \(\mathcal C_R\) and descends to a
\(p^a\)-semilinear map on the \(q/p-1\)-dimensional ghost quotient (47).

Their availability is uniform.  If \(q=p^e\) and \(p\ge5\), (44)--(45)
exist for every \(0\le a\le e-1\), since
\(p^e>4p^a-1\).  If \(p=3\), they exist for
\(0\le a\le e-2\); the smallest proper extension \(q=9\) is independently
closed.  Hence the live extension problem carries a semilinear equation at every base-
\(p\) digit for \(p\ge5\), and at every non-top digit in characteristic
three.  What remains is to exploit their simultaneous dependence on the
same completely split factor \(R\), together with the genuinely nonlinear
quadratic rung (40).

This yields a sharp intermediate carrier.  Write
\(\mathcal G_R=\mathcal V_R/\mathcal C_R\), and let
\(I_{p,e}\) be the available digit levels above.  Each map in (45) descends
to \(\overline{\mathcal L}_{R,a}\) on \(\mathcal G_R\).  Therefore
\[
 \boxed{
 \bigcap_{a\in I_{p,e}}
 \ker\overline{\mathcal L}_{R,a}=0}                       \tag{48}
\]
for every complementary split factor \(R\mid X^q-X\) would by itself prove
the special-direction conic lemma in any parameter range where it holds.  It
cannot be the universal theorem without a kernel clause.  Indeed, at
\(q=25\) the ghost quotient has dimension four, while the only nontrivial
Frobenius rung \(a=1\) has just three visible coefficients
\((1\le r\le3)\), so its kernel has dimension at least one.  At \(q=27\)
the quotient has dimension eight and the \(a=1\) rung has only the three
visible indices \(r=1,2,3\), so its kernel has dimension at least five.
These are dimension deductions, not census results.

Thus the universal object is
\[
 \mathcal K_R=\bigcap_{a\in I_{p,e}}
   \ker\overline{\mathcal L}_{R,a}.                       \tag{49}
\]
This common kernel has an explicit ordinary-linear determinantal model.
Write
\[
 R(Z)=\sum_{k=0}^nr_kZ^k,
 \qquad r_n=1,
 \qquad
 \mathscr G=\{u:1\le u\le n-3,\ u\equiv0,-1\pmod p\}.
                                                               \tag{70}
\]
The set \(\mathscr G\) has size \(q/p-1\).  For
\(g=(g_u)_{u\in\mathscr G}\), choose the canonical representative of its
ghost class by defining its Laurent coefficients through
\[
 c_s(g)=
 \begin{cases}g_s,&s\in\mathscr G,\\0,&1\le s\le n,
                                      \ s\notin\mathscr G,
 \end{cases}
 \qquad
 c_{n+t}(g)=-\sum_{k=0}^{n-1}r_kc_{k+t}(g)\quad(t\ge1). \tag{71}
\]
The three final zeros among \(c_1,\ldots,c_n\) fix the degree-at-most-two
ambiguity, and the recurrence is just the vanishing of the negative part of
\(R\sum_{s\ge1}c_sZ^{-s}\).  Hence there are coefficients
\(T_{s,u}(R)\) such that
\[
 c_s(g)=\sum_{u\in\mathscr G}T_{s,u}(R)g_u.             \tag{72}
\]

Fix an available power rung \(j=p^a\), and write
\(A^{(a)}_\ell=[Z^\ell]R^{j-1}\), with this coefficient understood to be
zero outside the polynomial's support.  For every Lucas-visible Laurent
index
\[
 \mathscr R_a=\left\{r:1\le r\le n-2j-1,
             \ \binom{r+2j-1}{2j}\ne0\pmod p\right\},
\]
the coefficient of \(Z^{-r}\) in \(R^{j-1}F^j\) is
\[
 \sum_sA^{(a)}_{js-r}c_s(g)^j
 =\sum_{u\in\mathscr G}M_a(R)_{r,u}g_u^j,
 \qquad
 M_a(R)_{r,u}
 =\sum_sA^{(a)}_{js-r}T_{s,u}(R)^j.                    \tag{73}
\]
All sums are finite from the support of \(R^{j-1}\).  Thus the \(a\)-th
power rung is exactly
\(M_a(R)g^{[p^a]}=0\).  Raising this equation to
\(p^{e-a}\) removes the Frobenius twist because \(g^{p^e}=g\).  Therefore,
under the ghost-coordinate identification,
\[
 \boxed{
 \mathcal K_R=\ker\mathbb M_R,
 \qquad
 \mathbb M_R=
 \operatorname{stack}_{a\in I_{p,e}}
       M_a(R)^{[p^{e-a}]},
 \qquad
 \dim\mathcal K_R=\frac qp-1-\operatorname{rank}\mathbb M_R.} \tag{74}
\]
Here the bracketed exponent on a matrix means entrywise Frobenius.  Formula
(74) replaces the common semilinear-kernel problem by the rank stratification
of one explicit Cartier--Toeplitz matrix over the coefficient space of
completely split factors \(R\mid X^q-X\).  It also isolates the nonlinear
work, but with one important qualification.  No fixed field or choice of
roots enters the construction.
The recurrence (71), the coefficients of \(R^{p^a-1}\), and hence every
entry of \(\mathbb M_R\) are polynomials in \(r_0,\ldots,r_{n-1}\); no
denominator is introduced.  Consequently the locus
\(\dim\mathcal K_R\ge h\) is cut out by the
\((q/p-h)\)-minors of \(\mathbb M_R\).  The saturated theorem has therefore
been reduced to a determinantal stratification on the completely split
factor locus, followed only on positive-kernel strata by the first
non-shadow equations.  This gives a uniform elimination target without
enumerating the split factors.

The row budget of this matrix is also digit-explicit.  For \(a\ge1\), put
\(P=p^a\) and \(L_a=n-2P-2\).  In the range \(r=1,\ldots,L_a+1\), Lucas'
criterion says that a row is visible exactly when the \(a\)-th digit of
\(r-1\) lies in \(\{0,\ldots,p-3\}\).  If
\[
 L_a+1=b_ap^{a+1}+c_a,
 \qquad 0\le c_a<p^{a+1},
\]
the exact number of rows is therefore
\[
 \boxed{
 m_a=b_a(p-2)p^a+\min\{c_a,(p-2)p^a\}.}                 \tag{75}
\]
The \(a=0\) rung defines the first ghost space and contributes zero rows on
the quotient.  Consequently
\[
 \boxed{
 \dim\mathcal K_R\ge
 \kappa_{p,e}:=
 \max\!\left\{0,\frac qp-1-
       \sum_{\substack{a\in I_{p,e}\\a\ge1}}m_a\right\}.} \tag{76}
\]
This bound is independent of \(R\).  It recovers \(\kappa_{5,2}=1\) and
\(\kappa_{3,3}=5\) immediately, while distinguishing uniformly the
parameters where the power tower is dimensionally capable of full rank from
those where a nonlinear non-shadow equation is mandatory.  Rank defects
beyond \(\kappa_{p,e}\) are precisely the determinantal special strata of
(74).

The arithmetic in (75)--(76) can be evaluated uniformly.  In
characteristic three the available nontrivial levels are
\(1\le a\le e-2\), and
\[
 m_a=\frac{q-3^{a+1}}6,
 \qquad
 \sum_{a=1}^{e-2}m_a=\frac{q(2e-5)}{12}+\frac34.
\]
For \(p\ge5\), the first nontrivial level alone has enough rows except at
\((p,e)=(5,2)\): for \(e=2,p\ge7\), (75) gives
\(m_1=(p^2-4p+1)/2\ge p-1\); for \(e\ge3\), counting at most \(2p\)
invisible positions per block of length \(p^2\) gives the same inequality
for \(p\ge7\), and for \(p=5,e\ge4\), while \(p=5,e=3\) gives
\(m_1=33>24\) directly.  Hence the complete dimension-forced list is
\[
 \boxed{
 \begin{array}{c|c}
 (p,e)&\kappa_{p,e}\\ \hline
 (3,2)&2\\
 (3,3),(3,4)&5\\
 (5,2)&1\\
 \text{all other }p\text{ odd},\ e\ge2&0.
 \end{array}}                                           \tag{77}
\]
The \(q=9\) row is independently closed.  Thus the only live parameters at
which the power tower is *forced by row count* to leave a kernel are
\[
 \boxed{q=25,\quad q=27,\quad q=81.}                    \tag{78}
\]
This does not assert full rank outside those fields: it says that every
additional kernel there lies on the determinantal rank-drop locus of
\(\mathbb M_R\).  Proving that this locus is proper on the completely split
factor locus is part of the remaining theorem.  Conversely, at the three
seams in (78), the nonlinear
non-shadow test is logically unavoidable regardless of \(R\).

Unlike the power rungs, a non-shadow rung does **not** in general descend to the ghost
quotient: mixed binomial terms remember the degree-at-most-two part of
\(H_2\).  Let
\(s_R:\mathcal G_R\to\mathcal V_R\) be the canonical section specified by
(71), and write
\[
 H=C+s_R(g),
 \qquad C\in\mathcal C_R,
 \qquad g\in\mathcal K_R.                               \tag{79}
\]
For the first non-shadow index \(j_0\) in (58), let
\(\mathcal Q_{R,j_0}(C,g)\) be the vector of Lucas-visible coefficients of
the proper part of
\[
 \frac{H^{j_0}}R
 =R^{j_0-1}\left(\frac HR\right)^{j_0}.                 \tag{80}
\]
Then \(\mathcal Q_{R,j_0}\) is a homogeneous polynomial map of degree
\(j_0\) in \((C,g)\), and
\[
 \mathcal Q_{R,j_0}(C,0)=0                              \tag{81}
\]
for every conic numerator \(C\).  The exact strong rigidity target is the
set-theoretic equality
\[
 \boxed{
 \left\{(C,g)\in\mathcal C_R\oplus\mathcal K_R:
        \mathcal Q_{R,j_0}(C,g)=0\right\}
 =\mathcal C_R\oplus\{0\}.}                             \tag{82}
\]
It is enough, but stronger than necessary, because the actual complementary
factor selects one specific pair \((C(R),g(R))\).  At \(q=25\), (82) is a
cubic system over a kernel forced to have dimension at least one; at
\(q=27,81\) it is a quadratic system over a kernel forced to have dimension
at least five.  The reflected shadow--successor rows constrain the same
mixed \((C,g)\) system.  This is the precise nonlinear bundle over the
determinantal strata (74), and avoids the false claim that the non-shadow
equation is intrinsically defined on \(\mathcal G_R\).

The first normal obstruction along the conic locus is linear again.  If
\(G=s_R(g)\), polarization of (80) gives
\[
 \boxed{
 D_g\mathcal Q_{R,j_0}(C,0)[g]
 =j_0\,\Pi_{j_0}\operatorname{pr}_{<0}
       \left(\frac{C^{j_0-1}G}{R}\right),}              \tag{83}
\]
where \(\Pi_{j_0}\) retains the Lucas-visible rows.  The scalar \(j_0\) is
nonzero in the relevant characteristics.  After inserting the recurrence
matrix \(T(R)\) from (72), (83) is another denominator-free matrix
\(\mathbb N_R(C)\) on \(\mathcal K_R\).  Hence
\[
 \boxed{
 \ker\mathbb M_R\cap\ker\mathbb N_R(C)=0}              \tag{84}
\]
is the exact infinitesimal rigidity criterion at the conic numerator \(C\).
Failure of (84) is again determinantal, now on the product of the split-factor
locus with the three-dimensional conic space.  Proving (84) eliminates every
nonconic component tangent to the conic locus; the remaining global task is
to exclude isolated or disjoint zeros of the full quadratic/cubic map (82).

This linear criterion has a sharp characteristic boundary.  If \(p\ge7\),
then \(j_0=2\), and (83) vanishes identically on the first ghost space.
Indeed, the coefficient of \(Z^{-r}\) in \(CG/R\), with \(\deg C\le2\),
uses only \(c_r,c_{r+1},c_{r+2}\).  Since the nonzero initial coefficients
of \(G/R\) have indices \(0,-1\pmod p\), a contributing output index has
residue
\[
 r\equiv0,-1,-2,-3\pmod p.
\]
These are exactly the blind residues of
\(\binom{r+3}{4}\) when \(p\ge7\).  Therefore
\[
 \boxed{
 \mathbb N_R(C)=0
 \qquad(p\ge7,\ j_0=2).}                                \tag{85}
\]
So a special rank-drop kernel in characteristic at least seven has
second-order contact with the conic locus, and must be attacked by the
quadratic normal cone itself.  In fact the cancellation is stronger.  Since
the pure conic term also vanishes, expansion of \((C+G)^2\) and (85) gives
\[
 \boxed{
 \mathcal Q_{R,2}(C,g)=\mathcal Q_{R,2}(0,g)
 =\Pi_2\operatorname{pr}_{<0}\left(\frac{G^2}{R}\right)
 \qquad(p\ge7).}                                        \tag{86}
\]
Thus in characteristic at least seven the first non-shadow equation *does*
descend, by this extra residue cancellation, to a homogeneous quadratic map
on \(\mathcal G_R\).  The exact rank-drop target there is simply
\[
 \{g\in\ker\mathbb M_R:\mathcal Q_{R,2}(0,g)=0\}=\{0\}.
\]
In characteristics three and five, digit
carries allow (83) to be nonzero; these are exactly the characteristics of all
three dimension-forced seams (78).  There the determinantal transversality
test (84) is a genuine first subgate before the global quadratic/cubic
analysis.  Formulas (85)--(86) replace a futile uniform tangent-space
strategy by the correct characteristic split.

At the three forced seams the normal row budgets are already dimensionally
sufficient to permit transversality on the minimum kernel stratum:
\[
 \boxed{
 \begin{array}{c|c|c|c}
 q&j_0&\kappa_{p,e}&\#\text{ native normal rows}\\ \hline
 25&3&1&6\\
 27&2&5&5\\
 81&2&5&17.
 \end{array}}                                           \tag{87}
\]
Thus the minimal \(q=27\) seam is especially sharp: after choosing bases,
(84) is the nonvanishing of one \(5\times5\) determinant.  At \(q=25\) it
is the nonvanishing of a six-component column, and at \(q=81\) it is full
column rank of a \(17\times5\) matrix.  If \(\mathbb M_R\) has a larger
rank defect, the same statements use the appropriate maximal minors.  These
are theorem-shaped determinant gates on coefficient strata, not searches
over field configurations.

The correct theorem target is to determine \(\mathcal K_R\) uniformly,
prove it zero where dimensions permit, and show that every nonzero class in
the forced low-characteristic seams violates the first non-shadow rung in
(58), together with its reflected checks.  This is independent of a fixed
search window.

## 7. Structural consequences and routing

### 7.1 Full-field norm lift

The complementary factor permits a global reformulation with no deleted
domain.  Let
\[
 C_S(U,V)=\prod_{a:S(a)=0}(U+Va)
\]
be the binary homogenization of the root divisor of \(S\), and define the
two full-field norm forms
\[
 \mathcal N_\pm(U,V,W)
 =\prod_{x\in\mathbb F_q}(U+Vx\pm WS(x))
 =\operatorname{Res}_X(X^q-X,U+VX\pm WS(X)).              \tag{32}
\]
At a root of \(S\), the two factors agree.  Splitting the product into the
roots and nonroots of \(S\), then applying (11), gives
\[
 \boxed{\mathcal N_+-\mathcal N_-
        =\gamma WQ_D(V,W)C_S(U,V).}                       \tag{33}
\]
All three terms have total degree \(q\), while the right side has
\[
 \deg_U C_S=\deg S=\frac{q-3}{2}.                         \tag{34}
\]
Thus two degree-\(q\) norm polynomials, each completely split in \(U\) for
every fixed \((V,W)\), differ only in their bottom \((q-1)/2\)
\(U\)-coefficients.  At \(W=0\), both specialize to the Moore form
\[
 \prod_{x\in\mathbb F_q}(U+Vx)=U^q-UV^{q-1}.
\]

Equation (33) is an exact generalized lacunary-polynomial interface.  A
theorem proving that such an involution-odd norm deformation must have
\(R\mid S^2-H_2\), \(\deg H_2\le2\), would close every extension field.
Existing prime-field lacunary theorems do not directly apply because the
degree blocks here are governed by \(q=p^e\), not by a single degree-\(p\)
block.  The hierarchy (30) is the coefficientwise Hasse shadow of (33).

There is a nearby but strictly stronger permutation-polynomial interface.
For \(m\in D\), the maps \(mx+S(x)\) and \(mx-S(x)\) have the same image on
the nonroot set \(\Omega\), and each restriction is injective.  They become
permutations of all \(\mathbb F_q\) only if this common image is disjoint
from
\[
 m\,Z(S)=\{ma:S(a)=0\}.                                  \tag{36}
\]
That root/nonroot separation is **not** supplied by the dual-net axioms.
If it were proved for many \(m\), the finite-field direction theorem could
force the graph of \(S\) into a subfield-linear or boundary family.  Until
then, one must not replace the norm equality (33) by a permutation claim.

The reduction changes the extension-field problem in six ways.

1. The unknown is no longer an arbitrary \((q+3)/2\)-point configuration.
   It is the complementary split factor \(S\) of \(X^q-X\).
2. Conic containment is the concrete divisibility (3), or equivalently the
   lacunarity band (4).
3. The first divided ghost kills all but two residue classes modulo the
   characteristic, uniformly in \(q\).
4. The first ghost module is affine-stable, so coordinate translation alone
   gives no further constraint.
5. Every higher odd coefficient supplies the Lucas-controlled relation
   (30), coupled explicitly by the nonlinear Laurent identity (39).  The
   Frobenius rungs \(j=p^a\) form the digitwise semilinear tower (45).
6. Equivalently, one may classify the completely split lacunary norm
   deformation (33), which packages all higher couplings at once.

This is the correct purely structural extension gate.  A fixed-field search
would only sample choices of the split divisor \(S\) and would not address
the p-typical coupling.

## 8. Literature alignment and trust boundary

The use of iterated derivatives of a Redei--Szonyi polynomial to retain
direction multiplicities is established in Luca Ghidelli, *On rich and poor
directions determined by a subset of a finite plane*, arXiv:1903.03881,
especially Proposition 3.7 and the lacunary-polynomial discussion.  Cached
PDF SHA-256:
`85666f153e5aa3f350877efaeb8cfc30373807dd37b2705c911e3157c79aa8b9`.
That paper works over a prime plane in a different rich/poor-direction
regime; it does not state (1)--(7), the involution-odd factorization (11), or
the quotient-algebra hierarchy (30).  It supports the derivative/lacunarity
interface, not the C756 conclusion.

The adjacent full-graph classification is Simeon Ball, *The number of
directions determined by a function over a finite field*, JCTA 104 (2003),
341--350, DOI `10.1016/S0097-3165(03)00116-0`; cached PDF SHA-256
`1cc24411ed40d8f20c0ea0c32323938d0610ea9199c39a59dd13814d1625a78a`.
It becomes applicable only after the extra separation (36), so it is not
used as a premise of the present reduction.

All displayed deductions here are exact polynomial identities over an
arbitrary odd prime power.  The note does **not** claim that the ghost
coupling has been completed or that proper extension fields are closed.

## EJ + TT closeout

**EJ.**  The free coefficient was the term linear in the involution-odd
coordinate.  It converts the entire affine component into barycentric
weights, and finite-field complementation then reconstructs it from a single
factor \(S\).  The exceptional conic is exactly the assertion that the
square of those weights has interpolation degree two.

**TT.**  Do not describe the extension obstruction as generic failure of
Newton identities.  It is the rank-two Cartier tail (37), with the nonlinear
divided-power system (39)--(40) behind it.  The next attempt should prove
that no nonzero two-residue tail is compatible with the split factor \(R\)
through enough of those equations.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Can the conjugate components be coordinatized uniformly? | settled | equations (1)--(2) |
| What does the linear odd coefficient force? | settled | barycentric identity (17) |
| What is conic containment algebraically? | settled | divisibility (3), equivalent band (4) |
| Which first moments are genuinely lost in characteristic \(p\)? | settled | only Laurent indices \(0,-1\pmod p\) in (7) |
| Does translation invariance shrink the ghost space? | settled negative | the residues \(0,-1\pmod p\) form an affine-stable Frobenius module |
| Is there a finite structural model for the first ghost space? | settled | two-component Frobenius--Pade congruence (42) |
| What is its exact excess dimension modulo conics? | settled | \(q/p-1\), quotient (47) |
| Is there a division-free root-set form? | settled | barycentric Reed--Solomon syndrome system (53) |
| Do the power rungs couple to non-power rungs? | settled | Frobenius reflection and exponent rotation (55) |
| Is every odd rung informative? | no | all \(2j+1=p^b\) are tautological Frobenius shadows (57) |
| Where do reflected checks land? | settled | immediately after a shadow, with ratio identity (66) |
| What controls the useful degree bound at each rung? | settled | first-carry formula (60) and Reed--Solomon bound (61) |
| How are those degree bounds coupled? | settled | single multiplication orbit (62) |
| What happens after the orbit wraps? | settled structurally | cyclic closure and Frobenius index cycles (62a)--(62c) |
| Which degrees are excluded without wrap? | settled arithmetically | all-rung forbidden set (68), including degree four in characteristic three (69) |
| Can a nonconic ghost have bounded small degree? | no for \(p\ge5\) | top-rung gap (64) forces degree at least \((p+1)/2\) |
| Is there more information beyond the first ghost? | settled | nonlinear Cartier hierarchy (39) from every odd divided coefficient |
| Which higher equations are uniform across all live extensions? | settled | digitwise Frobenius--Cartier tower (45) |
| Can the common semilinear kernel be linearized explicitly? | settled | stacked Cartier--Toeplitz matrix \(\mathbb M_R\), formula (74) |
| Where is a tower kernel forced dimensionally? | settled | exactly the live seams \(q=25,27,81\), formula (78) |
| Does the non-shadow rung descend to the ghost quotient? | no | mixed conic--ghost terms require the bundle map (79)--(82) |
| What matrix statement would close the extension branch? | open, exact | control the determinantal rank strata of \(\mathbb M_R\), then prove nonlinear bundle rigidity (82) |
| Is there a global carrier for all ghost couplings? | settled | the full-field norm identity (33) |
| Are the full-field maps permutations in the permitted directions? | not implied | requires root/nonroot separation (36) |
| What remains to prove? | open | couple the ghost supports under \(H_{2j}\equiv H_2^j\pmod R\) and force \(\deg H_2\le2\) |

## Next action

Analyze the determinantal rank strata of the explicit matrix
\(\mathbb M_R\) in (74), then analyze the mixed conic--ghost map
\(\mathcal Q_{R,j_0}\) in (79)--(82) over its nullspaces.  The exact theorem
target is a uniform classification of
the common kernel \(\mathcal K_R\) in (49) on the
\(q/p-1\)-dimensional quotient (47), with
the forced \(q=25,27,81\) kernel dimensions as boundary tests.  Apply \(j=3\)
at \(q=25\), and \(j=2\) at \(q=27,81\), retaining the compatibility
\(RS=X^q-X\) and \(H_2\equiv S^2\pmod R\).
Equivalently, work directly with the barycentric weights and prove from the
Lucas-visible moment system (53) that \((w_i^2)\) is a quadratic evaluation
vector.  On the forced \(q=25,27,81\) seams, use the native-plus-reflected
exponent sets recorded after (58).  Uniformly, prove carry-flag rigidity for
the multiplication orbit (62).
In parallel, test the exact theorem-shaped
alternative: classify completely split norm pairs satisfying the lacunarity
identity (33), using iterated Redei--Szonyi derivatives rather than ordinary
Newton moments.
