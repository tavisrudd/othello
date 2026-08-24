# C925: type-I1 quartic del Pezzo surfaces have level at most four

**Lane:** cubic-threefolds · **Task:** C925 · **Date:** 2026-08-24

> **Broadened later on 2026-08-24.** The full type-\(I_3\) cubic-orbit
> construction proves the same level-four bound uniformly for all four
> types; see `2026-08-24-c925-uniform-level-four-rationality.md`.

## Result

Let \(K\) be a characteristic-zero field and let \(S/K\) be a smooth
quartic del Pezzo surface with a \(K\)-point whose geometric Picard action
has Tschinkel--Zhang type \(I_1\). Then

\[
\boxed{S\times\mathbf A^4\text{ is }K\text{-rational}.} \tag{1}
\]

Consequently, every type-\(I_1\) cubic hypersurface in
Tschinkel--Zhang Proposition 5.1, in every dimension at least three,
satisfies

\[
\boxed{X\times\mathbf P^4\text{ is }\mathbf Q\text{-rational}.} \tag{2}
\]

For their explicit cubic threefolds this sharpens the certified interval to

\[
\boxed{2\le s(X)\le4}. \tag{3}
\]

The proof combines their one-apparent-double-point construction with a
one-dimensional torus slice. It is not a cancellation argument and does not
assert level four for the type-\(I_3\) family.

## Linear-orbit tangent-slice lemma

The following elementary quotient mechanism is the geometric step.

**Lemma.** Let \(Z\subset\mathbf P(V)\) be a geometrically integral
\(n\)-fold over an infinite field \(K\). Assume:

1. \(Z(K)\) is dense, and projection from \(T_zZ\) at a general
   \(z\in Z(K)\) is birational from \(Z\) to \(\mathbf P^n\);
2. a one-dimensional \(K\)-torus \(L\) acts generically freely on \(Z\)
   through the ambient projective representation; and
3. the closure of a general geometric \(L\)-orbit is a line.

Then \(Z/L\) is \(K\)-rational.

Indeed, choose \(z\) as in (1) and a general hyperplane
\(H\supset T_zZ\). Tangent projection restricts to a birational map

\[
H\cap Z\dashrightarrow\mathbf P^{n-1},
\]

because \(H\) is the inverse image of a hyperplane in the projection
target. A general orbit line is not contained in \(H\), hence meets \(H\)
once. Thus \(H\cap Z\) is a rational slice and is birational to \(Z/L\).

## Application to the universal torsor

Choose a universal torsor \(\mathcal T\to S\) with a rational point, as in
Tschinkel--Zhang Corollary 3.5. Let

\[
Z=\mathbf P(\mathcal U)\subset\mathbf P^{15}
\]

be the projective Cox closure used in their proof. Their Lemma 3.2 and
Theorem 2.4 say precisely that \(Z\) satisfies hypothesis (1) of the slice
lemma, with \(n=7\). The projectivized torsor is a dense open subset of
\(Z\).

Let \(T_0\) be the rank-five Neron--Severi torus after quotienting the
anticanonical scalar. Its cocharacter lattice has a primitive type-\(I_1\)
sign line generated, in the exact certificate's \(D_5\) basis, by

\[
v=(0,0,0,1,1). \tag{4}
\]

It defines a one-dimensional \(K\)-subtorus \(L\subset T_0\). A lift of
\(v\) to the full Picard cocharacter lattice is

\[
\widetilde v=(1,0,0,0,1,0) \tag{5}
\]

in the basis \(H,E_1,\ldots,E_5\). Pairing (5) with the 16 exceptional-curve
classes indexing the Cox coordinates gives only two projective weights:

\[
0^8,\quad 1^8. \tag{6}
\]

Over a splitting field, the orbit of a general point therefore has the form
\([x_0+t x_1]\), with both components nonzero. Its closure is a line. Since
\(Z\) is a \(T_0\)-torsor over a dense open of \(S\), the action is
generically free. The slice lemma proves that \(Z/L\) is rational.

The stable-permutation identity for \(\operatorname{Pic}(\bar S)\) makes
the universal torsor generically split, as recorded in Tschinkel--Zhang
Remark 2.2 and Proposition 2.3. Hence

\[
Z/L\sim_K S\times(T_0/L). \tag{7}
\]

The actual character lattice of the rank-four quotient \(T_0/L\) has CARAT
class

\[
(4,76,4). \tag{8}
\]

The exact GAP replay embeds it in Lemire's hereditarily rational maximal
class `[4,31,7,1]`. Thus \(T_0/L\) is rational, and (7) proves (1).
The generic-fibre function-field passage in Tschinkel--Zhang Proposition
5.1 then proves (2).

There is a second sign subtorus with the same \(8+8\) linear-orbit pattern
and the same rank-four character class. This independently duplicates the
slice construction.

## Exact certificates

Cox weights and integral quotient actions:

- `notes/cubic-threefolds-tasks/c925-i1-level4-linear-slice-check.py`,
  6,158 bytes, SHA-256
  `2a63a1345ff370fcaeb2acce0f7da7730887ea970e25f9496013e9858c109b9f`;
- `notes/cubic-threefolds-tasks/c925-i1-level4-linear-slice-check.json`,
  5,406 bytes, SHA-256
  `0e71715985ec687e34091bf36c28d1b61875898e91e1ba484b19972d07223e94`.

Replay from `/home/tavis/src/othello`:

    uv run --with sympy==1.14.0 python3 \
      notes/cubic-threefolds-tasks/c925-i1-level4-linear-slice-check.py \
      --check-certificate \
      notes/cubic-threefolds-tasks/c925-i1-level4-linear-slice-check.json

The checker reconstructs the \(D_5\) character and cocharacter actions,
enumerates all sign subtori, lifts them integrally to Picard cocharacters,
pairs them with all 16 Cox-coordinate classes, and constructs the actual
rank-four quotient character actions.

CARAT and hereditary rationality:

- `notes/cubic-threefolds-tasks/c925-i1-level4-subtorus-quotient-carat-check.g`,
  2,044 bytes, SHA-256
  `3df22bb3b551daf7f297701e79ca2ed79ceaf43c590c5a7a68d67d65abf666cd`;
- `notes/cubic-threefolds-tasks/c925-i1-level4-subtorus-quotient-carat-check.txt`,
  259 bytes, SHA-256
  `87267bbeb70e6db65bca09c1436de81300cdb6d17b62e45610accd70a1a58f0f`.

From the extracted `RatProbAlgTori/` directory used by the level-five
certificate, run:

    nix shell nixpkgs#gap-full -c gap -q -c \
      'RequirePackage:=LoadPackage;; Read("RatProbAlgTori.gap"); \
       Read("/home/tavis/src/othello/notes/cubic-threefolds-tasks/c925-i1-level4-subtorus-quotient-carat-check.g");' \
      | rg '^subtorus_' \
      | diff -u \
          /home/tavis/src/othello/notes/cubic-threefolds-tasks/c925-i1-level4-subtorus-quotient-carat-check.txt -

The GAP checker dualizes the computed cocharacter quotients before the
CARAT lookup, avoiding the character/cocharacter convention trap.

## Sources and read depth

- Yuri Tschinkel and Zhijia Zhang, *Universal torsors over quartic del Pezzo
  surfaces and stable rationality*, arXiv:2608.20029v1.
  **Read depth: partial** — Remark 2.2, Proposition 2.3, Theorem 2.4,
  Lemma 3.2, Theorem 3.4, Corollary 3.5, Lemma 4.2, and Proposition 5.1.
  Shared-cache PDF SHA-256
  `be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.
- Nicole Lemire, *Four-Dimensional Algebraic Tori*, arXiv:1511.00315.
  **Read depth: partial** — Remark 4.12 and Theorem 4.13.
  Shared-cache PDF SHA-256
  `f93ae35ef1abefdb8cc0dd3ead8ae2742d40fb0141e728398534733632875b5c`.
- Akinari Hoshi and Aiichi Yamasaki, *RatProbAlgTori for GAP 4*, version
  2018.05.22. **Read depth: partial (software source)** — CARAT lookup and
  subgroup-conjugacy routines used by the replay.

## Mystery ledger

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | The first two type-\(I_1\) sign subtori have line orbit closures. | Exact \(0^8,1^8\) Cox-weight calculation. |
| settled | The quotient of the OADP torsor closure by either subtorus is rational. | Tangent-hyperplane rational slice. |
| settled | The residual rank-four torus is rational. | Actual character class `(4,76,4)` lies in Lemire's hereditary class. |
| settled | Every type-\(I_1\) quartic del Pezzo surface with a point has level at most four. | Equation (7) and the preceding three rows. |
| settled | Every Tschinkel--Zhang Proposition 5.1 cubic has level at most four. | Generic-fibre passage. |
| open | Can the same construction lower the bound to three? | Every invariant rank-two cocharacter subspace has four Cox weights; its generic orbit closure is a quadric surface, not a linear plane. |
| open | Does level four hold for type \(I_3\)? | The proof uses type-\(I_1\) sign subtori and does not extend formally. |

## EJ+TT checkpoint

The missing geometric operation was not cancellation. The OADP tangent
projection already rationalizes every hyperplane through its tangent center,
and the type-\(I_1\) sign subtorus supplies orbit lines meeting such a
hyperplane once. The next dimension has a visible structural cutoff: the
rank-two orbit closures are quadrics of degree two, so a codimension-two
linear slice is generically a two-section rather than a rational section.

**Resume line:** go C925 cubic-threefolds — analyze the invariant rank-two
quadric-orbit quotient for a rational ruling or a nonlinear one-point slice,
with the certified type-\(I_1\) interval \(2\le s(X)\le4\).
