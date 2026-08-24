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

For uniformity in the quartic-del-Pezzo moduli, the primary checker repeats
the construction at three symbolic pairs of torsor points while leaving the
standard Cox parameters \(a,b\) free. The three four-hyperplane evaluation
determinants generate the ideal

\[
(a-1,b-1). \tag{11}
\]

Their only common zero is therefore \((a,b)=(1,1)\), where the fifth blown-up
point \((1:a:b)\) equals \((1:1:1)\); this is outside the smooth quartic del
Pezzo moduli. Hence at least one witness is nonzero for every smooth geometric
surface. Rank and nonvanishing are open and Galois-invariant conditions.
Density of rational points on the universal torsor, together with rationality
of the relevant Grassmannian of three-planes, supplies the required general
\(K\)-defined tangent section on every twist in the stated setting.

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

Finally, the C925 \(m=1\) theorem says that
\(X_{\mathbf C}\times\mathbf P^1\) is irrational, so \(Y\) is nonrational
already over \(\mathbf Q\). On the other hand,

\[
\mathbf Q(Y\times\mathbf A^1)
=\mathbf Q(X)(u,t)
=\mathbf Q(X\times\mathbf P^2), \tag{15}
\]

which is purely transcendental by (2). This proves (5).

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
  3a685d8bb66d908ee4df0b1d68220b3278740d784ba7385c4956ef8e6abd016e;
- certificate
  notes/cubic-threefolds-tasks/c925-i1-rank3-boundary-peeling-exhaustion.json,
  SHA-256
  67ac08dfe16bdfd972235fbfd101b5afdc4bc7db9cd094186b67dab8e3b82841.

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
| settled | Smooth-moduli coverage | Three symbolic determinants have common ideal \((a-1,b-1)\), outside the smooth locus. |
| settled | Residual torus | Rank two, hence rational. |
| settled | Type-\(I_1\) threshold | \(s(X)=2\). |
| open | Manuscript-level priority | Full novelty and forward-citation audit. |
