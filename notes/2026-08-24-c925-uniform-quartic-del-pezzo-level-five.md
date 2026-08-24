# C925: uniform level five for stably rational quartic del Pezzo surfaces

**Lane:** cubic-threefolds · **Task:** C925 · **Date:** 2026-08-24

## Result

Let (K) be a field of characteristic zero and let (S/K) be a stably
rational quartic del Pezzo surface. Then

\[
\boxed{S\times\mathbf A^5\text{ is }K\text{-rational}.} \tag{1}
\]

If (S) is already rational this is immediate. In every nonrational case,
Tschinkel--Zhang's classification places the geometric Picard action in one
of the types (I_0,I_1,I_2,I_3). The proof below works for the full type
(I_3) group and therefore for all four types simultaneously.

Consequently every smooth cubic hypersurface (X/\mathbf Q) constructed in
Tschinkel--Zhang Propositions 5.1 and 5.2 satisfies

\[
\boxed{X\times\mathbf P^5\text{ is }\mathbf Q\text{-rational}.} \tag{2}
\]

This sharpens their existence theorem from unspecified stable rationality,
with a displayed level-eleven construction, to a uniform level-five bound.
For their cubic threefolds, the unconditional one-stabilization irrationality
theorem gives the interval (2\le s(X)\le5).

## Block-kernel rationality criterion

The mechanism is useful beyond this example.

**Proposition.** Let (R) and (H) be quasi-trivial (K)-tori, with
(H\subset R). Suppose a permutation representation containing (R) as its
dense coordinate torus splits as (V_0\oplus V_1), and:

1. the kernel (H_0) of the action on (V_0) is a split one-dimensional
   torus;
2. (H_0) acts on (V_1) through one primitive scalar weight;
3. (\bar H=H/H_0) is quasi-trivial; and
4. the torus (R_0/\bar H), where (R_0\subset V_0) is the dense coordinate
   torus, has dimension at most two.

Then (R/H) is rational.

Indeed, quotienting the scalar action gives

\[
R/H_0\sim_K R_0\times\mathbf P(V_1).
\]

The generic (\bar H)-torsor over (R_0/\bar H) is trivial because
(\bar H) is quasi-trivial. Hence (R/H) is birational to the product of
(R_0/\bar H) with a projective space. The former is rational by
Voskresenskii's theorem in dimension two, and trivially so in lower
dimension.

## Application to all four quartic-del-Pezzo types

Use the type-(I_3) stable-permutation basis in Tschinkel--Zhang Lemma 4.2:

\[
\operatorname{Pic}(\bar S)\oplus
\mathbf Z[w_0,w_1,w_2,q_0,q_1]\cong\mathbf Z[b_1,\ldots,b_{11}]. \tag{3}
\]

Let (T) be the rank-six Neron--Severi torus, let
(\lambda:\mathbf G_m\to T) be the anticanonical scalar, put
(T_0=T/\lambda(\mathbf G_m)), and let (Q_3,Q_2,R) be the quasi-trivial
tori dual to the permutation lattices in (3). Then

\[
T\times Q_3\times Q_2\cong R,
\qquad
T_0\cong R/H,
\quad
H=\lambda(\mathbf G_m)\times Q_3\times Q_2. \tag{4}
\]

The coordinate orbits of (R) have sizes (6,4,1). Put the (6+1) block
in (V_0) and the four-block in (V_1). Exact multiplication by the six
cocharacter rows in the basis (3) shows that

\[
h_0=(-1,-4,-4,-4,2,2) \tag{5}
\]

is the full primitive kernel on (V_0), while its weight on every coordinate
of (V_1) is (-1). The quotient (\bar H=H/H_0) is quasi-trivial: its
character lattice is the direct sum of the three-point and two-point
permutation lattices, with the eliminated character

\[
a=-4(b_0+b_1+b_2)+2(c_0+c_1). \tag{6}
\]

Finally, (R_0/\bar H) has the saturated rank-two character basis

\[
e_0+e_3-e_4-e_5,
\qquad
e_1-e_2-e_3+e_5. \tag{7}
\]

For the full type-(I_3) generators, the matrices on (7) are

\[
\begin{pmatrix}0&1\\1&0\end{pmatrix},
\qquad
\begin{pmatrix}0&-1\\1&-1\end{pmatrix}. \tag{8}
\]

The group they generate on the ambient lattice has order (24), as required
for (C_3\rtimes D_4). Thus the proposition applies and proves that (T_0)
is rational for type (I_3). Tschinkel--Zhang observe that (I_0,I_1,I_2)
are subgroups of (I_3), so the same lattice proof applies after restriction.

Their Theorem 3.4 makes the projectivized universal torsor rational and
birational to (S\times T_0). This proves (1). For every cubic in their two
families, the generic quartic-del-Pezzo fibre over the rational base has one
of these types. The function-field passage proves (2), in every dimension
(n\ge3).

## Five-dimensional torus corollary

The exact convention check identifies the type-(I_1) character lattice as
CARAT class

\[
(5,232,15), \tag{9}
\]

while its root-lattice dual is `(5,232,14)`. Therefore the proof also gives:

**Corollary.** Every characteristic-zero algebraic torus whose character
lattice has CARAT class `(5,232,15)` is rational.

Jamshidpey's 2017 dissertation lists `(5,232,15)` in Table B.2 among 109
cases, out of 311 indecomposable stably rational five-dimensional tori, whose
rationality was unknown there. The corollary supplies a solution for that
listed case. This is a comparison with the 2017 table, not yet a claim that no
independent post-2017 solution exists.

## Exact certificates

General type-$I_3$ extension:

- `notes/cubic-threefolds-tasks/c925-dp4-level5-generalization-check.py`,
  5,512 bytes, SHA-256
  `c12e9df32e831e34997d57eb1e672e6272f9dd1ba102456d62e288e50660cec5`;
- `notes/cubic-threefolds-tasks/c925-dp4-level5-generalization-check.json`,
  1,015 bytes, SHA-256
  `bf083f42aa14e140e537d66edeac7128ad2f5c4f8e2fdf191bcf96dbb2e65809`.

Replay from `/home/tavis/src/othello`:

    uv run --with sympy==1.14.0 python3 \
      notes/cubic-threefolds-tasks/c925-dp4-level5-generalization-check.py \
      --check-certificate \
      notes/cubic-threefolds-tasks/c925-dp4-level5-generalization-check.json

The checker pins the SHA-256 of the type-$I_1$ base certificate, verifies
(5)--(8), checks equivariance of all six weight rows, and checks every element
of the full order-24 type-$I_3$ group.

CARAT convention:

- `notes/cubic-threefolds-tasks/c925-i1-level5-carat-check.g`,
  1,066 bytes, SHA-256
  `e7981c3287d945e4f93544a03075fe40d2c8691a0a749227ed571f3d99f7e9b8`;
- `notes/cubic-threefolds-tasks/c925-i1-level5-carat-check.txt`,
  79 bytes, SHA-256
  `13f921bdb208d074c0eb1f073168a309cdf6e71dd5dbc3d9f12a61d6be498248`.

The replay uses Hoshi--Yamasaki's `RatProbAlgTori-2018.05.22.zip`,
6,965,383 bytes, SHA-256
`7b77a6a4258f66898c9faaffd6e178d0d8c8e2bbecb7429795056c5b030737ea`,
downloaded from their official algorithm page. After extracting it, run from
its `RatProbAlgTori/` directory:

    nix shell nixpkgs#gap-full -c gap -q -c \
      'RequirePackage:=LoadPackage;; Read("RatProbAlgTori.gap"); \
       Read("/home/tavis/src/othello/notes/cubic-threefolds-tasks/c925-i1-level5-carat-check.g");' \
      | rg '^(root_lattice|character_lattice)' \
      | diff -u \
          /home/tavis/src/othello/notes/cubic-threefolds-tasks/c925-i1-level5-carat-check.txt -

## Sources and read depth

This report names four sources; none was read at full-text depth for this
bounded result.

- Yuri Tschinkel and Zhijia Zhang, *Universal torsors over quartic del Pezzo
  surfaces and stable rationality*, arXiv:2608.20029v1.
  **Read depth: partial** — Theorem 3.4 and its proof, Proposition 4.1,
  Lemma 4.2 and its displayed bases, Corollary 4.3, the levels paragraph, and
  Propositions 5.1--5.2. Shared-cache key `arXiv:2608.20029`, PDF SHA-256
  `be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.
- V. E. Voskresenskii, *On two-dimensional algebraic tori. II*, Math.
  USSR-Izv. **1** (1967), 691--696,
  DOI `10.1070/IM1967v001n03ABEH000580`.
  **Read depth: theorem/abstract** — Theorem 2 is the load-bearing
  two-dimensional rationality statement.
- Akinari Hoshi and Aiichi Yamasaki, *RatProbAlgTori for GAP 4*, version
  2018.05.22.
  **Read depth: partial (software source)** — `caratnumber.gap`, its CARAT
  tables, and the load path used by the convention checker.
- Armin Jamshidpey, *Algebraic Tori: A Computational Approach*, PhD thesis,
  Western University, 2017.
  **Read depth: partial** — Appendix B, especially Table B.1 and Table B.2.
  The relocated institutional repository currently rejects automated access;
  the text was reached through an Internet Archive copy, PDF SHA-256
  `baa6b16e2d2e75984b7f4c584b6403342bdfd2bbf098349ef84dfa4bd7723d6e`.

## Mystery ledger

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | The level-five proof works for the full type-(I_3) group. | Order-24 exact replay and matrices (5)--(8). |
| settled | Every stably rational quartic del Pezzo surface has level at most five. | Tschinkel--Zhang's four-type classification plus the block-kernel criterion. |
| settled | Every cubic hypersurface in Tschinkel--Zhang's two families has level at most five. | Generic-fibre passage in every dimension. |
| settled | CARAT `(5,232,15)` is rational. | Durable convention check and the type-(I_1) specialization. |
| open | Is the CARAT corollary new after 2017? | Exact-ID searches found no later solution, but a priority claim requires a dedicated forward literature audit. |
| open | Can the uniform bound drop to four? | The type-(I_1) rank-five lattice has no invariant cocharacter after removing (-K); a second split-scalar quotient is impossible. A nonsplit quotient or a new cancellation theorem is required. |

## EJ+TT checkpoint

The extra quadratic cocharacter is the decisive feature: it reduces the
residual quotient to dimension two uniformly for the maximal (I_3) action.
The proof therefore does more than optimize one cubic threefold. It replaces
the level-eleven output of the stable-permutation resolution by level five
for the entire stable-rationality classification and for both cubic families.

**Resume line:** go C925 cubic-threefolds — test nonsplit rank-one quotients
of the projectivized torsor for level four, and close the post-2017 priority
audit for CARAT `(5,232,15)`.
