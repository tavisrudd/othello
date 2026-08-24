# C925: type-I1 quartic del Pezzo surfaces are rational after six stabilizations

**Lane:** cubic-threefolds · **Task:** C925 · **Date:** 2026-08-24

## Result

Let (K) be a field of characteristic zero and let (S/K) be a smooth
quartic del Pezzo surface with a (K)-point whose geometric Picard action is
of Tschinkel--Zhang type (I_1). Then

\[
S\times\mathbf A^6\quad\text{is }K\text{-rational}.
\]

Consequently the (r=0) smooth cubic threefold (X/\mathbf Q) in
Tschinkel--Zhang Proposition 5.1 satisfies

\[
\boxed{X\times\mathbf P^6\quad\text{is }\mathbf Q\text{-rational}.}
\]

This supersedes the level-eight result. Combined with the unconditional
one-stabilization irrationality theorem, the certified interval for this
explicit cubic is

\[
2\le s(X)\le6.
\]

## A quotient lemma

The proof uses the following elementary form of the no-name argument.

**Lemma.** Let a quasi-trivial (K)-torus (J) act generically freely on a
quasi-trivial torus (R_0), and let (Y) be a rational (J)-variety. If
(R_0/J) is rational, then

\[
(R_0\times Y)/J
\]

is rational.

Indeed, the generic (J)-torsor (R_0\to R_0/J) is trivial because
(H^1(F,J)=0) for every field extension (F/K). The generic fibre of the
displayed quotient is therefore (Y), without a twist.

We will also use the elementary fact that a torus with signed-permutation
character lattice is rational. Decompose a signed basis into orbits of its
unoriented lines. Each orbit gives the Weil restriction of a one-dimensional
torus from the stabilizer field, and every one-dimensional torus is rational.

## Proof

Let (T) be the rank-six Neron--Severi torus of (S), let
(\lambda:\mathbf G_m\to T) be the primitive anticanonical scalar, and put
(T_0=T/\lambda(\mathbf G_m)). Tschinkel--Zhang's proof of Theorem 3.4 makes
the projectivized universal torsor rational, with

\[
\mathbf P(U)\sim_K S\times T_0. \tag{1}
\]

Their Lemma 4.2, restricted to the type-(I_1) action, gives an isomorphism
of tori

\[
T\times Q_3\times Q_2\cong R, \tag{2}
\]

where (Q_d=\operatorname{Res}_{E_d/K}\mathbf G_m) is quasi-trivial of rank
(d), and (R) is quasi-trivial of rank eleven. Its type-(I_1) coordinate
orbits have sizes (6,4,1).

Let (\Delta_2\subset Q_2) be the diagonal scalar and set

\[
H=\lambda(\mathbf G_m)\times Q_3\times\Delta_2.
\]

Thus (H) is quasi-trivial of rank five. In the target permutation basis of
Lemma 4.2, the five cocharacter rows of (H) are

\[
\begin{pmatrix}
2&2&2&2&2&2&-3&-3&-3&-3&4\\
-1&-1&-1&0&-1&0&1&1&1&1&-1\\
0&-1&-1&-1&0&-1&1&1&1&1&-1\\
-1&0&0&-1&-1&-1&1&1&1&1&-1\\
-3&-3&-3&-3&-3&-3&4&4&4&4&-4
\end{pmatrix}. \tag{3}
\]

Split the target vector space into the (6+1) block (V_0) and the
four-dimensional block (V_1). On (V_0), the primitive cocharacter

\[
h_0=(-1,-4,-4,-4,2) \tag{4}
\]

is the whole kernel of the (H)-action. It is split, is trivial on (V_0),
and has scalar weight (-1) on every coordinate of (V_1). Hence

\[
(R\,/\,H_0)\sim_K R_0\times\mathbf P(V_1), \tag{5}
\]

where (R_0\subset V_0) is the dense coordinate torus.

The residual torus (\bar H=H/H_0) is quasi-trivial. In fact its character
lattice is the kernel of pairing with (4), and the coefficient (-1) in the
(\lambda)-position identifies that kernel with the degree-three permutation
lattice plus one fixed line. Explicitly, if (b_0,b_1,b_2,c) are its four
permutation coordinates, the missing character is

\[
a=-4(b_0+b_1+b_2)+2c. \tag{6}
\]

The action of (\bar H) on (R_0) is generically free. Its quotient
(C=R_0/\bar H) has rank three, and (3) gives the following saturated basis
of its character lattice:

\[
e_0-e_4,\qquad e_1-e_2,\qquad e_3-e_5. \tag{7}
\]

For the two type-(I_1) generators, the matrices on (7) are

\[
\begin{pmatrix}0&1&0\\1&0&0\\0&0&-1\end{pmatrix},
\qquad
\begin{pmatrix}0&0&1\\0&-1&0\\1&0&0\end{pmatrix}. \tag{8}
\]

Thus (7) is a signed-permutation basis and (C) is rational. Apply the
quotient lemma to (R_0), (\bar H), and
(Y=\mathbf P(V_1)\cong\mathbf P^3). Equations (5)--(8) prove that

\[
R/H\quad\text{is a rational rank-six torus}. \tag{9}
\]

Quotienting (2) by (H) identifies this torus as

\[
F_6:=T_0\times(Q_2/\Delta_2)\cong R/H. \tag{10}
\]

The second factor is a dense open in (\mathbf P^1), hence rational. From
(1) and (10),

\[
S\times F_6
\sim_K \mathbf P(U)\times(Q_2/\Delta_2)
\]

is rational. Since (F_6\sim_K\mathbf A^6), this proves
(S\times\mathbf A^6) rational.

For the cubic in Tschinkel--Zhang Proposition 5.1, projection from the
displayed plane has generic fibre birational to such an (S) over
(K=\mathbf Q(a)). Passing from the generic-fibre function field to the
total function field proves (X\times\mathbf P^6) rational over
(\mathbf Q).

## Exact certificate

Artifacts:

- `notes/cubic-threefolds-tasks/c925-i1-level6-rationality-check.py`,
  8,451 bytes, SHA-256
  `bfe43460ab7b2607e914791d0cc16f26f6533627386f19729b9d756dd9574fd6`;
- `notes/cubic-threefolds-tasks/c925-i1-level6-rationality-check.json`,
  2,366 bytes, SHA-256
  `6b2f3d515407d16ed2135b6c2deb1043586fcb0e8cc83b164fb2876cdd4aa0cf`.

Replay from `/home/tavis/src/othello`:

    uv run --with sympy==1.14.0 python3 \
      notes/cubic-threefolds-tasks/c925-i1-level6-rationality-check.py \
      --check-certificate \
      notes/cubic-threefolds-tasks/c925-i1-level6-rationality-check.json

The certificate checks the unimodular Lemma 4.2 basis, all five rows in (3),
the Smith factors and primitive kernel in (4), the permutation basis in (6),
the saturated kernel basis (7), and the signed action of every one of the
twelve group elements, including (8). As an independent invariant check, the
displayed three pair differences are verified directly against all group
elements and against the Smith-normal-form rank and saturation calculation.
The trusted geometric inputs are Tschinkel--Zhang Theorem 3.4, Lemma 4.2, and
Proposition 5.1.

## Source and read depth

- Yuri Tschinkel and Zhijia Zhang, *Universal torsors over quartic del Pezzo
  surfaces and stable rationality*, arXiv:2608.20029v1.
  **Read depth: partial** — Proposition 2.3, Theorem 3.4 and its proof,
  Lemma 4.2, the levels paragraph, and Proposition 5.1. Shared-cache key
  `arXiv:2608.20029`, PDF SHA-256
  `be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.

## Mystery ledger

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | The (6+1) quotient has a signed-permutation rank-three character lattice. | Exact basis (7), all twelve group actions, and Smith saturation. |
| settled | The remaining (4)-block contributes only a rational projective fibre. | The primitive split kernel (4) has scalar weight (-1). |
| settled | Every type-(I_1) surface with a point satisfies (S\times\mathbf A^6) rational. | The quotient lemma and Tschinkel--Zhang's rational projectivized torsor. |
| open | Is the rank-five torus (T_0) rational? | This is CARAT class `(5,232,15)`, still unresolved in the consulted five-dimensional torus literature. A positive answer gives level five. |
| open | What is the exact (s(X))? | Current certified interval (2\le s(X)\le6). |

## EJ+TT checkpoint

The improvement is nonlinear: it does not shorten the rank-eleven
stable-permutation identity. Instead, one scalar kernel projectivizes an
entire four-coordinate orbit, while the residual quotient collapses to a
signed-permutation torus. The same pattern applies whenever a
stable-permutation presentation has a blockwise scalar kernel and a
low-rank signed-permutation residual quotient.

**Resume line:** go C925 cubic-threefolds — decide rationality of the
type-I1 rank-five torus, which would lower the explicit cubic to level five.
