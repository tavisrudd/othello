# C925: uniform level four via cubic-orbit tangent slices

**Lane:** cubic-threefolds · **Task:** C925 · **Date:** 2026-08-24

## Theorem

Let \(K\) be a characteristic-zero field and let \(S/K\) be a stably
rational smooth quartic del Pezzo surface. Then

\[
\boxed{S\times\mathbf A^4\text{ is }K\text{-rational}.} \tag{1}
\]

Consequently, every cubic hypersurface in both Tschinkel--Zhang families
(Propositions 5.1 and 5.2), in every dimension at least three, satisfies

\[
\boxed{X\times\mathbf P^4\text{ is }\mathbf Q\text{-rational}.} \tag{2}
\]

For either explicit cubic threefold family, the certified stabilization
interval is therefore

\[
\boxed{2\le s(X)\le4}. \tag{3}
\]

This improves Tschinkel--Zhang's displayed level eleven uniformly and the
earlier C925 level-five bound. The proof uses a projective quotient slice,
not cancellation.

## Cubic-orbit slice

This construction is a special case of the later adjacent-weight OADP
quotient theorem in
`2026-08-24-c925-adjacent-weight-oadp-quotient-theorem.md`: the stable
boundary space removes weights zero and three, leaving the adjacent window
of weights one and two.

It suffices to prove (1) for the maximal type-\(I_3\) action: the types
\(I_0,I_1,I_2\) are subgroups of \(I_3\), and a rational surface is
trivial. Choose a universal torsor with a point and write

\[
Z=\mathbf P(\mathcal U)\subset\mathbf P^{15}
\]

for its projective Cox closure. Tschinkel--Zhang Lemma 3.2 and Theorem 2.4
show that projection from \(T_zZ\simeq\mathbf P^7\), for general
\(z\in Z(K)\), is birational to \(\mathbf P^7\).

Let \(T_0\) be the rank-five Neron--Severi torus modulo the anticanonical
scalar. The full type-\(I_3\) cocharacter lattice contains the primitive
sign line

\[
v=(0,0,1,1,0), \tag{4}
\]

which defines a one-dimensional subtorus \(L\subset T_0\). Its lift to the
Picard cocharacter lattice is \((0,0,0,1,1,0)\). Exact pairing with the 16
Cox-coordinate classes gives projective weights

\[
0^2,\quad1^6,\quad2^6,\quad3^2. \tag{5}
\]

Thus the closure of a general geometric \(L\)-orbit is the rational normal
cubic

\[
[s^3x_0:s^2t x_1:st^2x_2:t^3x_3]. \tag{6}
\]

The two boundary points lie in the fixed projective space

\[
B=\mathbf P(V_0\oplus V_3)
 =\mathbf P\langle E_3,E_4,L_{34},Q\rangle\simeq\mathbf P^3. \tag{7}
\]

Although the sign action may exchange the two extreme weight spaces, their
sum is Galois-stable, so \(B\) is defined over \(K\).

Choose a general hyperplane \(H\subset\mathbf P^{15}\) containing both
\(T_zZ\) and \(B\). Such hyperplanes exist because their span has dimension
at most eleven. Tangent projection restricts birationally to

\[
H\cap Z\dashrightarrow\mathbf P^6. \tag{8}
\]

On the orbit cubic (6), the equation of \(H\) vanishes at \(s=0\) and
\(t=0\) because \(H\supset B\); the remaining linear factor cuts exactly
one point of the open orbit. Hence \(H\cap Z\) is a rational one-point slice
for the \(L\)-action, and

\[
Z/L\quad\text{is rational}. \tag{9}
\]

The universal torsor splits over \(K(S)\) by Tschinkel--Zhang Remark 2.2,
so

\[
Z/L\sim_K S\times(T_0/L). \tag{10}
\]

The actual character lattice of \(T_0/L\) has CARAT class `(4,99,3)`.
The exact GAP replay embeds it in Lemire's hereditarily rational maximal
class `[4,20,22,1]`. Therefore \(T_0/L\) is rational, and (9)--(10) prove
(1). Restricting the same construction proves the result for all four
types. The generic-fibre argument of Tschinkel--Zhang Section 5 proves (2).

## Exact evidence

Full type-\(I_3\) sign line, Cox weights, stable boundary, and quotient
character actions:

- `notes/cubic-threefolds-tasks/c925-i3-level4-cubic-slice-check.py`,
  5,114 bytes, SHA-256
  `0df32f93dcb09e9d56bdc4bf452d01098128da05c4fd922214d6143240ff6c5e`;
- `notes/cubic-threefolds-tasks/c925-i3-level4-cubic-slice-check.json`,
  1,817 bytes, SHA-256
  `62ecfc1f22baec4d0cbbb51a869b9bd62c2628598592f60e4fff166247225215`.

Replay:

    uv run --with sympy==1.14.0 python3 \
      notes/cubic-threefolds-tasks/c925-i3-level4-cubic-slice-check.py \
      --check-certificate \
      notes/cubic-threefolds-tasks/c925-i3-level4-cubic-slice-check.json

Rank-four character CARAT class and hereditary container:

- `notes/cubic-threefolds-tasks/c925-i3-level4-quotient-carat-check.g`,
  1,465 bytes, SHA-256
  `16c5a09a5ec887b40e1011fa6fe92da861ea2c4d786706a60cdd3dd4c4c4a2fc`;
- `notes/cubic-threefolds-tasks/c925-i3-level4-quotient-carat-check.txt`,
  89 bytes, SHA-256
  `57e3e868cd9a13ce457c23bc538c1cce3a0c090055da133c59e5226d1cf5256a`.

From the extracted `RatProbAlgTori/` directory:

    nix shell nixpkgs#gap-full -c gap -q -c \
      'RequirePackage:=LoadPackage;; Read("RatProbAlgTori.gap"); \
       Read("/home/tavis/src/othello/notes/cubic-threefolds-tasks/c925-i3-level4-quotient-carat-check.g");' \
      | rg '^i3_' \
      | diff -u \
          /home/tavis/src/othello/notes/cubic-threefolds-tasks/c925-i3-level4-quotient-carat-check.txt -

The GAP checker consumes the actual quotient character matrices, not the
cocharacter matrices.

## Sources and scope

- Yuri Tschinkel and Zhijia Zhang, *Universal torsors over quartic del Pezzo
  surfaces and stable rationality*, arXiv:2608.20029v1.
  **Read depth: partial** — Remark 2.2, Proposition 2.3, Theorem 2.4,
  Lemma 3.2, Theorem 3.4, Corollary 3.5, Lemma 4.2, and Propositions
  5.1--5.2. Shared-cache PDF SHA-256
  `be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.
- Nicole Lemire, *Four-Dimensional Algebraic Tori*, arXiv:1511.00315.
  **Read depth: partial** — Remark 4.12 and Theorem 4.13. Shared-cache PDF
  SHA-256
  `f93ae35ef1abefdb8cc0dd3ead8ae2742d40fb0141e728398534733632875b5c`.
- Akinari Hoshi and Aiichi Yamasaki, *RatProbAlgTori for GAP 4*, version
  2018.05.22. **Read depth: partial (software source)** — exact CARAT and
  subgroup-conjugacy routines.

## Mystery ledger

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | The full type-\(I_3\) sign orbit is a cubic with two controlled boundary points. | Exact weight pattern (5) and stable space (7). |
| settled | Its quotient of the OADP torsor closure is rational. | Tangent hyperplane through the boundary space gives a one-point slice. |
| settled | The residual rank-four torus is rational. | Character class `(4,99,3)` lies in a hereditary rational class. |
| settled | Every stably rational quartic del Pezzo has level at most four. | Type classification and subgroup restriction. |
| settled | Both Tschinkel--Zhang cubic families have level at most four. | Generic-fibre function-field passage. |
| open | Can the bound drop to three? | Natural invariant rank-two orbits are quadric surfaces; the boundary rulings do not descend individually in type \(I_1\). |

## EJ+TT checkpoint

This is the priority-judo formulation: Tschinkel--Zhang's OADP theorem does
more than make the universal torsor rational. Combined with the sign-weight
geometry already present in their \(I_3\) lattice, it supplies a quotient
slice that uniformly cuts the displayed stabilization level from eleven to
four. The cubic orbit is essential: its two extreme points fit in a small
Galois-stable linear space, leaving one open-orbit intersection.

**Resume line:** go C925 cubic-threefolds — attack level three through the
rank-two quadric-orbit quotient; the uniform certified interval is now
\(2\le s(X)\le4\).
