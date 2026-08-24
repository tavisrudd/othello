# C925: the type-I1 Neron--Severi torus is rational

**Lane:** cubic-threefolds · **Task:** C925 · **Date:** 2026-08-24

## Result

Let (K) be a field of characteristic zero and let (S/K) be a smooth
quartic del Pezzo surface with a (K)-point whose geometric Picard action is
of Tschinkel--Zhang type (I_1). Let (T_0) be its rank-five
Neron--Severi torus after quotienting by the primitive anticanonical scalar.
Then

\[
\boxed{T_0\text{ is }K\text{-rational}.} \tag{1}
\]

Consequently

\[
S\times\mathbf A^5\quad\text{is }K\text{-rational}. \tag{2}
\]

For the (r=0) smooth cubic threefold (X/\mathbf Q) in
Tschinkel--Zhang Proposition 5.1, this gives

\[
\boxed{X\times\mathbf P^5\quad\text{is }\mathbf Q\text{-rational}.} \tag{3}
\]

Thus the certified interval for this explicit cubic is now

\[
2\le s(X)\le5.
\]

## Quotient mechanism

We use two standard facts. First, every two-dimensional algebraic torus over
a characteristic-zero field is rational, by Voskresenskii. Second, if a
quasi-trivial torus (J) acts generically freely on a torus (R_0), then the
generic (J)-torsor over (R_0/J) is trivial. Hence for any rational
(J)-variety (Y),

\[
(R_0\times Y)/J
\]

is rational whenever (R_0/J) is rational.

## Proof

Let (T) be the rank-six Neron--Severi torus of (S), let
(\lambda:\mathbf G_m\to T) be the primitive anticanonical scalar, and put
(T_0=T/\lambda(\mathbf G_m)). Tschinkel--Zhang's proof of Theorem 3.4 makes
the projectivized universal torsor rational, with

\[
\mathbf P(U)\sim_K S\times T_0. \tag{4}
\]

Their Lemma 4.2, restricted to the type-(I_1) action, gives

\[
T\times Q_3\times Q_2\cong R, \tag{5}
\]

where (Q_d=\operatorname{Res}_{E_d/K}\mathbf G_m) is quasi-trivial of rank
(d), while (R) is quasi-trivial of rank eleven with coordinate orbits of
sizes (6,4,1).

Set

\[
H=\lambda(\mathbf G_m)\times Q_3\times Q_2.
\]

This is quasi-trivial of rank six, and quotienting (5) gives

\[
R/H\cong T_0. \tag{6}
\]

In the target permutation basis of Lemma 4.2, the six cocharacter rows of
(H) are

\[
\begin{pmatrix}
2&2&2&2&2&2&-3&-3&-3&-3&4\\
-1&-1&-1&0&-1&0&1&1&1&1&-1\\
0&-1&-1&-1&0&-1&1&1&1&1&-1\\
-1&0&0&-1&-1&-1&1&1&1&1&-1\\
-2&-1&-2&-1&-1&-2&3&1&1&3&-2\\
-1&-2&-1&-2&-2&-1&1&3&3&1&-2
\end{pmatrix}. \tag{7}
\]

Split the target vector space into the (6+1) block (V_0) and the
four-dimensional block (V_1). The primitive cocharacter

\[
h_0=(-1,-4,-4,-4,2,2) \tag{8}
\]

is the whole kernel of the (H)-action on (V_0). It is split, is trivial
on (V_0), and acts with scalar weight (-1) on all four coordinates of
(V_1). If (R_0\subset V_0) is the dense coordinate torus, then

\[
R/H_0\sim_K R_0\times\mathbf P(V_1). \tag{9}
\]

The residual torus (\bar H=H/H_0) is quasi-trivial. Its character lattice
is the kernel of pairing with (8). Since the coefficient of the
anticanonical character is (-1), that kernel is exactly the sum of the
degree-three and degree-two permutation lattices. Explicitly,

\[
a=-4(b_0+b_1+b_2)+2(c_0+c_1). \tag{10}
\]

The action of (\bar H) on (R_0) is generically free. The quotient
(C=R_0/\bar H) has rank two; a saturated basis of its character lattice is

\[
e_0+e_3-e_4-e_5,\qquad e_1-e_2-e_3+e_5. \tag{11}
\]

Therefore (C) is rational by the two-dimensional torus theorem. Since
(\bar H) is quasi-trivial, its generic torsor over (C) is trivial.
Applying the quotient mechanism to (9) and
(\mathbf P(V_1)\cong\mathbf P^3) proves that

\[
R/H\sim_K C\times\mathbf P^3
\]

is rational of dimension five. By (6), this proves (1).

Equation (4) and the rationality of (T_0) now give (2). For the cubic in
Tschinkel--Zhang Proposition 5.1, projection from the displayed plane has
generic fibre birational to such an (S) over (K=\mathbf Q(a)). Passing
from the generic-fibre function field to the total function field proves
(3).

## Exact certificate

Artifacts:

- `notes/cubic-threefolds-tasks/c925-i1-level5-rationality-check.py`,
  7,828 bytes, SHA-256
  `12fff4c8866fedbbd66f45b85ea420c7a90f8fca6ae37466e7d8743165d9ecad`;
- `notes/cubic-threefolds-tasks/c925-i1-level5-rationality-check.json`,
  2,339 bytes, SHA-256
  `ea3c54677625d028723174812f091c0e525bcc27dfca1ced69e36ab4cb2d973a`.

Replay from `/home/tavis/src/othello`:

    uv run --with sympy==1.14.0 python3 \
      notes/cubic-threefolds-tasks/c925-i1-level5-rationality-check.py \
      --check-certificate \
      notes/cubic-threefolds-tasks/c925-i1-level5-rationality-check.json

The certificate checks the unimodular Lemma 4.2 basis, every row in (7), the
Smith factors and primitive kernel in (8), the permutation-lattice
identification (10), the saturated basis (11), and the integral action of all
twelve type-(I_1) group elements on that rank-two lattice. As an independent
invariant check, (11) has a determinant-one minor and is verified directly
against the complementary Smith rank. The trusted geometric inputs are
Tschinkel--Zhang Theorem 3.4, Lemma 4.2, and Proposition 5.1; the only external
birational input is Voskresenskii's two-dimensional torus theorem.

## Sources and read depth

- Yuri Tschinkel and Zhijia Zhang, *Universal torsors over quartic del Pezzo
  surfaces and stable rationality*, arXiv:2608.20029v1.
  **Read depth: partial** — Proposition 2.3, Theorem 3.4 and its proof,
  Lemma 4.2, the levels paragraph, and Proposition 5.1. Shared-cache key
  `arXiv:2608.20029`, PDF SHA-256
  `be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.
- V. E. Voskresenskii, *On two-dimensional algebraic tori. II*, Math.
  USSR-Izv. **1** (1967), 691--696,
  DOI `10.1070/IM1967v001n03ABEH000580`.
  **Read depth: theorem/abstract** — Theorem 2 states that every
  two-dimensional algebraic torus is rational over its field of definition.

## Literature implication

The character lattice in (1) was identified in the exploratory CARAT audit
with the dual (z)-class customarily labelled `(5,232,15)`. Jamshidpey's
2017 dissertation lists that five-dimensional stably rational class among
the rationality cases still unresolved there. Thus (1) appears to settle
that individual class, once the CARAT convention match is promoted to its
own durable replay and the post-2017 forward literature check is closed.
This priority statement is deliberately not yet promoted beyond that exact
remaining audit.

## Mystery ledger

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | The rank-five type-(I_1) torus is rational. | Split scalar kernel (8), quasi-trivial residual actor (10), and the rank-two quotient (11). |
| settled | Every type-(I_1) quartic del Pezzo surface with a point satisfies (S\times\mathbf A^5) rational. | Rational projectivized torsor and (1). |
| settled | The explicit Tschinkel--Zhang cubic satisfies (X\times\mathbf P^5) rational. | Generic-fibre function-field passage. |
| open | Is `(5,232,15)` still open in the post-2017 literature? | Requires durable CARAT convention replay and forward-citation audit before a priority claim. |
| open | Can the cubic bound be lowered below five? | Requires cancellation beyond rationality of (T_0), or a smaller rational quotient of the projectivized universal torsor. |
| open | What is the exact (s(X))? | Current certified interval (2\le s(X)\le5). |

## EJ+TT checkpoint

The full auxiliary quotient is easier than the intermediate one: adding the
second quadratic cocharacter lowers the residual torus from rank three to
rank two, where unconditional rationality is classical. This turns
Tschinkel--Zhang's stable-permutation resolution into an actual rationality
proof for the rank-five torus, not merely a smaller stable-rationality level.

**Resume line:** go C925 cubic-threefolds — audit the `(5,232,15)` priority
claim and seek a four-dimensional quotient of the rational projectivized
universal torsor.
