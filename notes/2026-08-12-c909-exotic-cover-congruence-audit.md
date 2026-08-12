# C909 audit: the exotic quadratic cover as a congruence modular curve

## Verdict

Let $\rho_2:\Gamma_0(3)\to SL_2(\mathbf F_2)\simeq S_3$ be reduction modulo
$2$.  The exotic cover is exactly the modular curve for

$$
\Gamma_{\rm ex}:=\rho_2^{-1}(A_3).
$$

It has index $2$ in $\Gamma_0(3)$, index $8$ in $SL_2(\mathbf Z)$, exact
congruence level $6$, genus $0$, two cusps of widths $2$ and $6$, and two
elliptic points of order $3$.  With the existing $X_0(3)$ Hauptmodul $T$, its
compactified function field is

$$
\mathbf C(X(\Gamma_{\rm ex}))=\mathbf C(T,r),\qquad r^2=T.
$$

The degree-three $X_0(6)$ root cover and this degree-two cover are the two
nontrivial intermediate resolvents of the common degree-six full level-two
cover for $\Gamma_0(3)\cap\Gamma(2)$.

## Structural group calculation

Reduction is onto.  The two elements

$$
\begin{pmatrix}1&1\\0&1\end{pmatrix},\qquad
\begin{pmatrix}2&1\\3&2\end{pmatrix}\in\Gamma_0(3)
$$

reduce to two transpositions in $SL_2(\mathbf F_2)$ and generate $S_3$; the
second matrix has determinant $1$ and lower-left entry $3$.

Inside $SL_2(\mathbf F_2)$, the subgroup $A_3$ is

$$
A_3=\left\{\begin{pmatrix}a&b\\c&d\end{pmatrix}:b=c\right\}.
$$

Indeed, determinant $1$ and $b=c=0$ gives the identity, while $b=c=1$
gives the two matrices of order $3$.  Hence an explicit integral description
is

$$
\Gamma_{\rm ex}
 =\left\{\begin{pmatrix}a&b\\c&d\end{pmatrix}\in SL_2(\mathbf Z):
 c\equiv0\pmod 3,\ b\equiv c\pmod2\right\}.
$$

Therefore

$$
[\Gamma_0(3):\Gamma_{\rm ex}]=[S_3:A_3]=2,
\qquad [SL_2(\mathbf Z):\Gamma_{\rm ex}]=4\cdot2=8.
$$

The subgroup contains $\Gamma(6)$, so it is congruence of level dividing $6$.
The mod-$2$ condition is nontrivial, so $\Gamma(3)\not\subset\Gamma_{\rm ex}$;
the mod-$3$ condition is nontrivial, so $\Gamma(2)\not\subset\Gamma_{\rm ex}$.
Thus neither factor can be removed and the exact level is $6$.

## Cusps, branching, and genus

On the $T$-line, $T=0$ is the width-$1$ cusp of $X_0(3)$ and $T=\infty$
is the width-$3$ cusp.  Their standard parabolic generators reduce modulo
$2$ to

$$
\begin{pmatrix}1&1\\0&1\end{pmatrix},\qquad
\begin{pmatrix}1&0\\3&1\end{pmatrix},
$$

respectively.  Both are transpositions in $S_3$, hence both have nontrivial
sign under $S_3\twoheadrightarrow S_3/A_3\simeq C_2$.  The quadratic cover
therefore ramifies at both cusps, with one point above each and widths

$$
2\cdot1=2,\qquad 2\cdot3=6.
$$

The only elliptic stabilizer on $X_0(3)$ is order $3$.  Its reduction cannot
be the identity (a torsion element in $\Gamma(2)$ would contradict the
torsion-freeness of $\Gamma(2)$), so it reduces to an order-$3$ element of
$A_3$.  Consequently the cover is unramified at the elliptic point as an
orbifold cover and has two order-$3$ elliptic points upstairs.  There are no
order-$2$ elliptic points.

The cover of coarse curves is thus branched only at $T=0,\infty$.  Since
$X_0(3)\simeq\mathbf P^1_T$, the unique quadratic extension with this branch
divisor is $r^2=cT$; rescaling $r$ gives $r^2=T$.  Equivalently, this agrees
with the computed two-division discriminant square class.

The genus is $0$ either by this two-point Riemann--Hurwitz calculation or by
the modular formula

$$
2g-2=\frac{8}{6}-2-\frac{2\cdot2}{3}=-2.
$$

The cusp widths sum to $2+6=8$, as required by the index.

## Relation to the degree-three and full covers

Put

$$
K:=\Gamma_0(3)\cap\Gamma(2)=\ker(\rho_2).
$$

Then $[\Gamma_0(3):K]=6$ and $\Gamma_0(3)/K\simeq S_3$.  This is the full
level-two/splitting cover: it labels the complete two-torsion structure, and
its six sheets carry the regular $S_3$ action.

The classical three-root cover is the subgroup

$$
\Gamma_0(6)=\Gamma_0(3)\cap\Gamma_0(2),
$$

whose mod-$2$ image is the order-two stabilizer

$$
H_{\rm cl}=\left\{I,
\begin{pmatrix}1&1\\0&1\end{pmatrix}\right\}\subset S_3.
$$

Thus $[\Gamma_0(3):\Gamma_0(6)]=3$, giving the three nonzero two-torsion
points (the three classical slopes).  The degree-two exotic cover corresponds
to $A_3$.  Since

$$
A_3\cap H_{\rm cl}=\{1\},
$$

the normalization of the fiber product of the degree-two and degree-three
covers is $X(K)$, the connected degree-six full splitting cover.  In subgroup
language:

$$
K\subset\Gamma_{\rm ex},\qquad K\subset\Gamma_0(6),\qquad
\Gamma_{\rm ex}\cap\Gamma_0(6)=K.
$$

The degree-three cover has cusp passport $2+1$ over each base cusp and source
widths $1,2,3,6$.  The full degree-six cover has three points of ramification
index $2$ over each base cusp, hence three width-$2$ points over $T=0$ and
three width-$6$ points over $T=\infty$; its widths sum to $24$, the index of
$K$ in $SL_2(\mathbf Z)$.  It is torsion-free (being contained in
$\Gamma(2)$), has six cusps, and has genus $0$.

The rational normalization used in the existing calculation is consistent:

$$
y=-\frac{u^2+3}{4},\qquad
T=\frac{u^2(9-u^2)^2}{(1-u^2)^2},\qquad
r=\frac{u(9-u^2)}{1-u^2}.
$$

Substitution into

$$
T=-\frac{(4y+3)(y+3)^2}{(y+1)^2}
$$

gives the displayed $T(u)$ and satisfies $r^2=T(u)$ identically.  Thus the
two resolvents are genuinely the intermediate quotients of one $S_3$ cover;
the exotic cover is not $X_0(6)$.

## Audit cautions

* “Level $6$” means the exact congruence level of the subgroup, not that the
  exotic curve is one of the standard $X_0(N)$ curves.
* The $T$-cusp assignment is the one fixed by the existing Hauptmodul:
  $T=0$ has width $1$ and $T=\infty$ width $3$.  Reversing the coordinate
  swaps the labels but not the width multiset upstairs.
* The two order-$3$ points are stack/orbifold data; they are not additional
  branch points of the coarse equation $r^2=T$.

