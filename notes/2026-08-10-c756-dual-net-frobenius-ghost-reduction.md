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
The remaining work is to couple the remainders
\(H_{2j}\equiv H_2^j\pmod R\), rather than treating their ghost slots
independently.

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

The reduction changes the extension-field problem in four ways.

1. The unknown is no longer an arbitrary \((q+3)/2\)-point configuration.
   It is the complementary split factor \(S\) of \(X^q-X\).
2. Conic containment is the concrete divisibility (3), or equivalently the
   lacunarity band (4).
3. The first divided ghost kills all but two residue classes modulo the
   characteristic, uniformly in \(q\).
4. The first ghost module is affine-stable, so coordinate translation alone
   gives no further constraint.
5. Every higher odd coefficient supplies the Lucas-controlled relation
   (30).  A proof should couple these relations through multiplication in
   \(\mathbb F_q[X]/(R)\).
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
Newton identities.  It is the explicit two-residue Laurent ghost (7), with a
full divided-power hierarchy (30) behind it.  The next attempt should work in
the quotient algebra \(\mathbb F_q[X]/(R)\) and prove that the ghost support
is incompatible with \(H_{2j}=H_2^j\) for enough \(j\).

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Can the conjugate components be coordinatized uniformly? | settled | equations (1)--(2) |
| What does the linear odd coefficient force? | settled | barycentric identity (17) |
| What is conic containment algebraically? | settled | divisibility (3), equivalent band (4) |
| Which first moments are genuinely lost in characteristic \(p\)? | settled | only Laurent indices \(0,-1\pmod p\) in (7) |
| Does translation invariance shrink the ghost space? | settled negative | the residues \(0,-1\pmod p\) form an affine-stable Frobenius module |
| Is there more information beyond the first ghost? | settled | hierarchy (30) from every odd divided coefficient |
| Is there a global carrier for all ghost couplings? | settled | the full-field norm identity (33) |
| Are the full-field maps permutations in the permitted directions? | not implied | requires root/nonroot separation (36) |
| What remains to prove? | open | couple the ghost supports under \(H_{2j}\equiv H_2^j\pmod R\) and force \(\deg H_2\le2\) |

## Next action

Analyze multiplication of a two-residue Laurent tail modulo the split
polynomial \(R\).  Start with \(H_4\equiv H_2^2\pmod R\) and the \(j=2\)
constraint in (30); determine whether Lucas support alone eliminates the
\(r\equiv0,-1\pmod p\) ghosts.  In parallel, test the exact theorem-shaped
alternative: classify completely split norm pairs satisfying the lacunarity
identity (33), using iterated Redei--Szonyi derivatives rather than ordinary
Newton moments.
