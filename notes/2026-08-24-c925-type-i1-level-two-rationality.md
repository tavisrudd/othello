# Type-\(I_1\) level-two rationality and birational \(\mathbf A^1\)-cancellation

Date: 2026-08-24  
Task: C925 (cubic-threefolds)

## Result

Let \(K\) be an infinite field of characteristic zero and let \(S/K\) be a
smooth quartic del Pezzo surface in the type-\(I_1\) Tschinkel--Zhang setting,
with a universal torsor having a \(K\)-point. Then

\[
\boxed{S\times\mathbf A^2\text{ is }K\text{-rational}.} \tag{1}
\]

Consequently, if \(X/\mathbf Q\) is one of the smooth cubics constructed from
the type-\(I_1\) generic fibre in Tschinkel--Zhang Proposition 5.1, then

\[
\boxed{X\times\mathbf P^2\text{ is }\mathbf Q\text{-rational}.} \tag{2}
\]

For the cubic threefold this is the explicit smooth hypersurface

\[
X=\left\{
(x_4-2x_3)x_1^2+3(x_4+2x_3)x_2^2
+3x_3^2x_4-x_4^3+x_5^3=0
\right\}\subset\mathbf P^4. \tag{2a}
\]

For their cubic threefold and the C925 \(m=1\) theorem this identifies the
exact stabilization threshold:

\[
s(X)=\min\{m:X\times\mathbf P^m\text{ is rational}\}=2. \tag{3}
\]

In particular

\[
Y=X\times\mathbf P^1 \tag{4}
\]

is a smooth projective nonrational variety over \(\mathbf Q\), while

\[
Y\times\mathbf A^1\text{ is }\mathbf Q\text{-rational}. \tag{5}
\]

Thus the construction gives one explicit birational
\(\mathbf A^1\)-cancellation counterexample, rather than the earlier
three-member finite disjunction.

## Saturation correction

Let \(T_0\) be the rank-five projective Neron--Severi torus. The three
type-\(I_1\) sign lines were initially written with generators

\[
v_1=(0,0,0,1,1),\quad
v_2=(0,0,1,0,1),\quad
v_3=(0,0,1,1,0). \tag{6}
\]

That is not a basis of the cocharacter lattice of the image subtorus: its
maximal-minor gcd is \(2\), and

\[
u=\frac{v_1+v_2+v_3}{2}=(0,0,1,1,1) \tag{7}
\]

is integral. The actual saturated three-sign subtorus \(T_3\subset T_0\)
has basis \(v_1,v_2,u\); the gcd of its maximal minors is \(1\). Hence the
previous apparent degree-two orbit slice was the projective
\(\boldsymbol\mu_2\)-kernel of nonsaturated coordinates, not a geometric
double cover of the quotient.

## The unimodular weight window

Pairing the saturated basis with the 16 Cox coordinates gives the following
Galois-stable four-block window:

| weight | Cox block |
|---|---|
| \((0,0,1)\) | \(E_1,E_2,E_5\) |
| \((0,1,1)\) | \(L_{14},L_{24},L_{45}\) |
| \((1,0,1)\) | \(L_{13},L_{23},L_{35}\) |
| \((1,1,2)\) | \(L_{12},L_{15},L_{25}\) |

The three differences from \((0,0,1)\) have determinant \(1\), so these
weights form a unimodular affine tetrahedron in \(X^*(T_3)\). Every other
weight block lies in the Galois-stable linear space

\[
B=\mathbf P\langle E_3,E_4,L_{34},Q\rangle. \tag{8}
\]

At the exact tangent specialization
\((a,b,z_1,z_2,z_3)=(2,5,1,3,7)\), three tangent hyperplanes containing
\(B\), evaluated at the independent torsor point recorded in the
certificate, restrict to the four blocks as

\[
\begin{pmatrix}
-77/15&17/84&0&-19/660\\
-77/3&0&0&1/2\\
-11&0&2/15&0
\end{pmatrix}. \tag{9}
\]

Its four maximal minors are

\[
-17/1260,\quad119/270,\quad-187/168,\quad187/270. \tag{10}
\]

They are all nonzero. Thus the kernel has no zero coordinate and the rank is
three.

For uniformity in the quartic-del-Pezzo moduli, the primary checker uses four
symbolic pairs of points while leaving the standard Cox parameters \(a,b\)
free. A witness is counted only when both its four-hyperplane evaluation
determinant \(D_i\) and its displayed tangent smoothness minor \(M_i\) are
nonzero. This corrects the weaker determinant-only check in the first
certificate.

Put \(\Delta=ab(a-1)(b-1)(a-b)\). On the smooth open \(\Delta\ne0\), the
eight choices obtained from \(D_iM_i=0\), for \(i=1,2,3\), have only two
surviving branches. Both force \(3a-b-2=0\), and their remaining equations
are

\[
 Q_0(b)=31223016b^2-435944529b+1306078948=0
\]

and

\[
 (3b-26)(3b-13)=0. \tag{11}
\]

On the line \(3a-b-2=0\), the primitive numerator of the fourth product is

\[
 -(b-1)^4(4b-17)(16b-85)
 (83246b^2-872181b+2185995). \tag{11a}
\]

It is coprime to the product of the two polynomials in (11). A short exact
check is supplied by

\[
\begin{aligned}
Q_0(17/4)&=69121705/4,&Q_0(85/16)&=-4117757269/32,\\
Q_4(26/3)&=7918133/9,&Q_4(13/3)&=-272530/9,\\
\operatorname{Res}(Q_0,Q_4)&=-48353381094689774718359510,
\end{aligned}
\]

where \(Q_4=83246b^2-872181b+2185995\). Thus the four corrected witnesses
cover every smooth geometric fibre.

For a fixed geometric surface, goodness is open in the tangent centre, the
three-plane of tangent equations, and the orbit test point. The corrected
cover makes this open nonempty on every geometric fibre. Its projection to
the tangent-centre factor contains a nonempty open. The projective
universal-torsor closure has dense \(K\)-points by Tschinkel--Zhang Lemma 2.1,
so this open contains \(p\in Z(K)\). For that \(p\), good frames form a
nonempty \(K\)-open in an affine frame space, hence have a \(K\)-point because
\(K\) is infinite. This supplies the required \(K\)-defined tangent section
on every twist without assuming that a particular split-coordinate witness
descends.

The higher-rank unimodular-window OADP quotient theorem in
notes/2026-08-24-c925-adjacent-weight-oadp-quotient-theorem.md now applies:
the descended tangent codimension-three slice meets a general geometric
\(T_3\)-orbit exactly once. Therefore

\[
Z/T_3\text{ is }K\text{-rational}, \tag{12}
\]

where \(Z\) is the projective Cox closure of the universal torsor.

## The residual torus and the surface

Appending the first two standard basis vectors to \(v_1,v_2,u\) gives a
unimodular basis of the ambient cocharacter lattice. In that basis the two
type-\(I_1\) generators act on the residual rank-two quotient by

\[
\begin{pmatrix}-1&1\\0&1\end{pmatrix},\qquad
\begin{pmatrix}0&-1\\-1&0\end{pmatrix}. \tag{13}
\]

Every two-dimensional torus over a characteristic-zero field is rational by
Voskresenskii. The stable-permutation identity used by Tschinkel--Zhang makes
the universal torsor generically split, so

\[
Z/T_3\sim_K S\times(T_0/T_3). \tag{14}
\]

Equations (12)--(14) prove (1). Passing to the generic quartic-del-Pezzo
fibre in Proposition 5.1 proves (2).

The splitting in (14) is equivariant. Let \(\mathcal T\to S\) be the
universal torsor and let \(T\) be its Neron--Severi torus. Tschinkel--Zhang
Remark 2.2 gives \(H^1(F,T)=0\) for every extension \(F/K\), in particular
for \(F=K(S)\). A section over the generic point gives the \(T\)-equivariant
birational map

\[
 S\times T\dashrightarrow\mathcal T,\qquad (s,t)\longmapsto\sigma(s)t.
\]

Quotienting the anticanonical scalar gives a \(T_0\)-equivariant
birationality \(Z\sim_K S\times T_0\). Quotienting this identity by the
descended subtorus \(T_3\) proves (14). Thus (14) does not follow merely from
an abstract birationality of the total space.

## Explicit quotient map

The quotient part of the parametrization can be written without elimination.
Let \(\lambda_1,\lambda_2,\lambda_3\) be the three \(K\)-defined tangent
equations of a good slice. Over a separable closure, write a point as
\(q=q_B+q_0+q_1+q_2+q_3\) according to the boundary block and the four
unimodular weight blocks, and set

\[
 A(q)_{ij}=\lambda_i(q_j),\qquad
 \kappa_j(q)=(-1)^j\det A(q)_{\widehat j}. \tag{16}
\]

On the certified open all \(\kappa_j\) are nonzero. There is a unique
\(t(q)\in T_3\) satisfying

\[
 \chi^{w_j-w_0}(t(q))=\frac{\kappa_j(q)}{\kappa_0(q)},
 \qquad j=1,2,3. \tag{17}
\]

The determinant-one weight matrix makes (17) a Laurent-monomial formula,
with no root extraction. Cramer's identity gives
\(t(q)q\in\Lambda\cap Z\). Uniqueness makes the construction Galois
equivariant, so it descends to \(K\) and is constant on \(T_3\)-orbits.

Choose five linear forms \(\rho_0,\ldots,\rho_4\) completing the three
\(\lambda_i\) in the conormal space at the tangent centre. The birational
quotient map is

\[
 [q]\longmapsto
 [\rho_0(t(q)q):\cdots:\rho_4(t(q)q)]\in\mathbf P^4. \tag{18}
\]

Its inverse is the inverse tangent projection on \(\Lambda\cap Z\); it is
uniquely characterized by the twenty displayed Cox quadrics, the equations
\(\lambda_i=0\), and the five projective coordinates in (18). Formulae
(16)--(18) extract the one-point quotient and all torus coordinates. What
remains unexpanded is this final quadratic elimination and the Hilbert-90
section needed for a single coordinate parametrization of the nonsplit cubic
(2a).

Finally, the C925 \(m=1\) theorem says that
\(X_{\mathbf C}\times\mathbf P^1\) is irrational, so \(Y\) is nonrational
already over \(\mathbf Q\). On the other hand,

\[
\mathbf Q(Y\times\mathbf A^1)
=\mathbf Q(X)(u,t)
=\mathbf Q(X\times\mathbf P^2), \tag{15}
\]

which is purely transcendental by (2). This proves (5).

## Proof-audit gates

- **Descent of the subtorus.** The saturated lattice is preserved by both
  type-\(I_1\) Galois generators, with integral action matrices recorded in
  the certificate. It therefore defines a \(K\)-subtorus, not merely a
  geometric subtorus.
- **Descent of the slice.** The boundary space, tangent conormal space, and
  good Grassmannian open are \(K\)-defined. Their geometric nonemptiness is
  uniform on the smooth moduli by (11); density over infinite \(K\) supplies
  a \(K\)-defined three-plane of equations.
- **Generic freeness and quotient.** The projectivized universal torsor is a
  \(T_0\)-torsor on a dense open, so its restriction to \(T_3\) is generically
  free. The one-point slice is therefore birational to the Rosenlicht
  quotient \(Z/T_3\).
- **Surface product identity.** Tschinkel--Zhang Remark 2.2 gives a section
  over \(K(S)\), hence a \(T_0\)-equivariant generic splitting. Quotienting
  the split torus factor by \(T_3\) yields the displayed residual product.
- **Cubic passage.** Over the function field of the projection base, (1)
  makes the generic fibre rational after two variables. Hence
  \(\mathbf Q(X)(u,v)\) is purely transcendental over \(\mathbf Q\), which is
  exactly rationality of \(X\times\mathbf P^2\).

## Priority relation and scope

Tschinkel--Zhang explicitly single out the construction of a nonrational
variety \(Y\) for which \(Y\times\mathbf A^1\) is rational as open. Their
type-\(I_1\) cubic supplies the input; the saturated OADP quotient and the
\(m=1\) obstruction identify \(Y=X\times\mathbf P^1\). This is a direct
nontrivial consequence of their construction, while the unimodular-window
quotient theorem is a more general mechanism under which their torsor
argument sits as an application.

The rationality theorem (1)--(2) does not use the C925 quantum \(m=1\)
theorem. The exact threshold (3), nonrationality in (4), and cancellation
conclusion (5) do use it. This note makes no claim that arbitrary smooth
cubic threefolds have rational \(m=2\) stabilization. A full novelty and
forward-citation audit is still required before a manuscript-level priority
claim.

## Reproducibility

Primary exact reconstruction:

- notes/cubic-threefolds-tasks/c925-i1-rank3-boundary-peeling-exhaustion.py,
  SHA-256
  ead9ec015efd2a3fe74f8bb809ab449d53d651e3ef47e592ffd12387d20636cd;
- certificate
  notes/cubic-threefolds-tasks/c925-i1-rank3-boundary-peeling-exhaustion.json,
  SHA-256
  5f4ff4d6e6dc06e308b791198635f956cf6c6f8dd9a6ee5992875078be9a4dff.

Replay from /home/tavis/src/othello:

    uv run --with sympy==1.14.0 python3 \
      notes/cubic-threefolds-tasks/c925-i1-rank3-boundary-peeling-exhaustion.py \
      --check-certificate \
      notes/cubic-threefolds-tasks/c925-i1-rank3-boundary-peeling-exhaustion.json

Independent stdlib replay:

- notes/cubic-threefolds-tasks/c925-i1-level2-saturation-independent-check.py,
  SHA-256
  85ebf753e8a245e8599193077301a81c31f077f60fac1e321e25c773d41a4cd4;
- certificate
  notes/cubic-threefolds-tasks/c925-i1-level2-saturation-independent-check.json,
  SHA-256
  a1852ad510eb1a6d7065a784bbf8ae38e2ed32b65866f2937493b6fe48fec49e.

Replay:

    python3 \
      notes/cubic-threefolds-tasks/c925-i1-level2-saturation-independent-check.py \
      --check-certificate \
      notes/cubic-threefolds-tasks/c925-i1-level2-saturation-independent-check.json

The independent replay does not import SymPy or the primary certificate. It
checks the saturation indices, Galois actions, unimodular window, ambient
completion, residual quotient action, and the four slice minors directly.
The primary checker additionally verifies the symbolic smooth-moduli cover.

## Mystery ledger

| status | feature | evidence or remaining gate |
|---|---|---|
| settled | Apparent index-two slice | Nonsaturated-basis artifact. |
| settled | Smooth-moduli coverage | Four determinant--smoothness products cover \(\Delta\ne0\); (11)--(11a) give a compact exact certificate. |
| settled | Equivariant generic splitting | The generic section from Remark 2.2 gives \(Z\sim S\times T_0\) equivariantly. |
| settled | Residual torus | Rank two, hence rational. |
| settled | Type-\(I_1\) threshold | \(s(X)=2\). |
| open | Manuscript-level priority | Full novelty and forward-citation audit. |
| partial | Explicit parametrization | The quotient retraction and monomial torus coordinates are (16)--(18); inverse tangent elimination and a nonsplit Hilbert-90 section remain unexpanded. |
