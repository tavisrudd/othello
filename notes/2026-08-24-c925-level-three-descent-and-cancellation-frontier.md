# C925: the exact level-three descent and cancellation frontier

**Lane:** cubic-threefolds · **Task:** C925 · **Date:** 2026-08-24

## Outcome

The certified Tschinkel--Zhang stabilization bound remains

\[
\boxed{X\times\mathbf P^4\text{ is rational},\qquad 2\le s(X)\le4.} \tag{1}
\]

No level-three rationality or irrationality claim is made here. Instead, an
exact calculation isolates the entire remaining obstruction for the explicit
type-\(I_1\) cubic:

* the relevant residual rank-three torus is rational;
* the desired tangent slice exists over the splitting field;
* it fails to descend by the most direct linear construction because Galois
  exchanges its chosen boundary ruling with the opposite ruling; and
* resolving this last step in either direction has a sharp cancellation
  consequence.

Thus the level-three gate is geometric descent, not torus rationality and not
a missing Cox-lattice calculation.

## A reusable OADP quotient principle

The level-four result is an instance of the following boundary-forced tangent
slice principle.

**Cubic-orbit OADP lemma.** Let \(K\) be an infinite field, let
\(Z\subset\mathbf P(V)\) be a geometrically integral \(n\)-fold with dense
\(K\)-points, and assume that tangent projection from \(T_zZ\) at a general
\(z\in Z(K)\) is birational to \(\mathbf P^n\). Let a one-dimensional
\(K\)-torus \(L\) act generically freely through \(V\). Suppose that:

1. the closure of a general geometric \(L\)-orbit is a rational normal cubic;
2. its two extreme boundary points lie in a fixed \(K\)-linear subspace
   \(B\subset\mathbf P(V)\); and
3. \(\langle T_zZ,B\rangle\ne\mathbf P(V)\) for general \(z\).

Then \(Z/L\) is \(K\)-rational.

Indeed, a general hyperplane \(H\) through \(T_zZ\) and \(B\) has rational
section \(H\cap Z\), because tangent projection maps it birationally to a
hyperplane in \(\mathbf P^n\). On each orbit cubic, \(H\) contains the two
extreme points; the third intersection is one reduced point of the open
orbit. Hence \(H\cap Z\dashrightarrow Z/L\) is birational.

This lemma is not specific to del Pezzo surfaces. Whenever an OADP Cox closure
has such a cubic sign orbit and the residual quotient torus is rational, it
turns rationality of the quotient into a stable-rationality bound one less
than the anticanonical quotient-torus rank. Tschinkel--Zhang's quartic del
Pezzo OADP theorem, their type classification, and the exact full-\(I_3\)
weight \(0^2,1^6,2^6,3^2\) give the uniform level-four theorem (1) as a
direct corollary of this principle.

## The rank-two level-three candidate

For type \(I_1\), take the two saturated sign cocharacters

\[
v_1=(0,0,0,1,1),\qquad v_2=(0,0,1,0,1). \tag{2}
\]

Their lifts to \(H,E_1,\ldots,E_5\) are

\[
(1,0,0,0,1,0),\qquad(1,0,0,1,0,0). \tag{3}
\]

The sixteen Cox coordinates split into four weight blocks:

| weight | coordinates |
| --- | --- |
| \((0,0)\) | \(E_1,E_2,E_5,L_{34}\) |
| \((0,1)\) | \(E_3,L_{14},L_{24},L_{45}\) |
| \((1,0)\) | \(E_4,L_{13},L_{23},L_{35}\) |
| \((1,1)\) | \(L_{12},L_{15},L_{25},Q\) |

Thus a general rank-two orbit closure is a Segre quadric

\[
[x_{00}:t_2x_{01}:t_1x_{10}:t_1t_2x_{11}]. \tag{4}
\]

The quotient character lattice has generator matrices

\[
\begin{pmatrix}-1&0&0\\1&1&-1\\0&0&-1\end{pmatrix},\qquad
\begin{pmatrix}0&-1&0\\-1&0&0\\0&0&-1\end{pmatrix}, \tag{5}
\]

and CARAT class \((3,25,2)\). This class is absent from Kunyavskii's complete
list of fifteen nonrational rank-three tori. Therefore the residual torus is
\(K\)-rational. If \(Z/L_2\) can be shown rational, the universal-torsor
identity immediately gives \(S\times\mathbf A^3\) rational and hence
\(X\times\mathbf P^3\) rational.

## The split-field tangent slice works

Consider the boundary ruling \(t_1=0\). Its ambient coordinate space is

\[
W_0=\langle E_1,E_2,E_5,L_{34},E_3,L_{14},L_{24},L_{45}\rangle. \tag{6}
\]

At the exact dense family of Cox points obtained by setting \(e_i=1\),
\(l_{ij}=f_{ij}(z_1,z_2,z_3)\), and \(q=f_Q(z_1,z_2,z_3)\), the restriction
of the \(20\times16\) Cox Jacobian to the eight columns in (6) has generic
rank six. One nonzero \(6\times6\) minor factors as

\[
z_3(bz_1-z_3)\bigl(
abz_1z_2-abz_1z_3+az_1z_3-az_2z_3-bz_1z_2+bz_2z_3
\bigr). \tag{7}
\]

Consequently, the affine tangent space meets \(W_0\) in dimension two.
Over the splitting field one can choose a tangent hyperplane \(H_1\)
containing \(\mathbf P(W_0)\), followed by a second general tangent
hyperplane \(H_2\). On (4), \(H_1\) cuts the chosen boundary ruling plus one
residual ruling; \(H_2\) cuts one point on each. The first point is boundary
and the second is a unique open-orbit point. Meanwhile
\(Z\cap H_1\cap H_2\) is rational by tangent projection. This is exactly the
desired one-point quotient slice geometrically.

## Why this slice does not descend linearly

The two type-\(I_1\) generators act on the square of weight blocks by

\[
(i,j)\longmapsto(i,1-j),\qquad
(i,j)\longmapsto(1-i,j). \tag{8}
\]

In particular, the second generator exchanges \(W_0\) with the opposite
boundary-ruling space

\[
W_1=\langle E_4,L_{13},L_{23},L_{35},L_{12},L_{15},L_{25},Q\rangle. \tag{9}
\]

The spaces \(W_0\) and \(W_1\) are complementary and span all sixteen Cox
coordinates. Any \(K\)-defined linear hyperplane containing \(W_0\) would
have to contain its Galois conjugate \(W_1\), hence all of \(\mathbf P^{15}\),
which is impossible. The split tangent slice therefore cannot descend by
averaging or by replacing its chosen ruling with a Galois-stable linear
span.

This does not prove that \(Z/L_2\) is nonrational. A nonlinear descended
slice, an explicit invariant-field parametrization, or a different
rank-two quotient could still prove level three.

## Exhaustion of linear rank-two slices

The phrase “different rank-two quotient” can be narrowed exactly. Over
\(\mathbf Q\), the type-\(I_1\) cocharacter representation is the
multiplicity-free sum of three distinct sign characters and one irreducible
two-plane. By Maschke's theorem, its invariant two-planes are therefore
exactly the three pairwise sums of sign lines and the irreducible plane.

Their Cox weight polygons, orbit-surface degrees, boundary-edge orbit sizes,
and residual character-torus classes are:

| invariant plane | polygon | degree | boundary-edge orbits | residual CARAT | residual rationality |
| --- | --- | ---: | --- | --- | --- |
| two linear sign lines | unit square | 2 | \(2+2\) | `(3,25,2)` | rational |
| linear + cubic sign I | \(1\times3\) rectangle | 6 | \(2+2\) | `(3,19,2)` | rational |
| linear + cubic sign II | \(1\times3\) rectangle | 6 | \(2+2\) | `(3,19,2)` | rational |
| irreducible plane | root hexagon | 6 | \(3+3\) | `(3,6,3)` | not retract rational |

For a proper descended codimension-two linear section, the total geometric
intersection degree is the normalized area in the third column. Boundary
points occur in Galois orbits generated by the boundary-component orbits in
the fourth column. In the first three cases the boundary degree and hence the
remaining open degree are even. In the hexagon case both are divisible by
three; independently, its residual torus is one of Kunyavskii's fifteen
non-retract-rational rank-three classes. Thus

\[
\boxed{\text{no type-}I_1\text{ invariant rank-two subtorus gives a descended
linear one-point OADP slice}.} \tag{10}
\]

This turns “nonlinear descent” from a description of one failed choice into
an exhaustive structural requirement. It does not rule out a nonlinear
slice or a direct invariant-field parametrization.

## Cancellation dichotomy

The uniform level-four theorem makes level three a genuine cancellation
frontier. Put

\[
Y=X\times\mathbf P^3.
\]

Since \(X\times\mathbf P^4\) is rational and
\(\mathbf P^3\times\mathbf P^1\) is birational to \(\mathbf P^4\),

\[
Y\times\mathbf A^1\quad\text{is rational}. \tag{11}
\]

Therefore exactly one of the following advances occurs:

1. \(Y\) is rational, lowering the Tschinkel--Zhang cubic bound to
   \(s(X)\le3\); or
2. \(Y\) is nonrational, giving a nonrational variety whose product with
   \(\mathbf A^1\) is rational—the cancellation phenomenon that
   Tschinkel--Zhang explicitly record as having no known example.

Thus an irrationality proof at \(m=3\) would not merely improve the lower
bound; it would solve the adjacent cancellation problem. This explains why
the final step is qualitatively different from levels five and four.

There is also an unconditional finite-list consequence. Let

\[
Y_i=X\times\mathbf P^i,\qquad i=1,2,3.
\]

The already proved bounds give \(s(X)\in\{2,3,4\}\). For
\(i=s(X)-1\), the variety \(Y_i\) is nonrational, while

\[
K(Y_i\times\mathbf A^1)
 =K(X)(t_1,\ldots,t_{i+1})
\]

is a rational field. Hence

\[
\boxed{\text{at least one of }Y_1,Y_2,Y_3\text{ is a rationality-cancellation counterexample}.} \tag{12}
\]

This is a three-candidate certificate, not an identification of a single
candidate: if \(s(X)=2,3,4\), the boundary example is respectively
\(Y_1,Y_2,Y_3\). It therefore does not by itself close the construction
problem as Tschinkel--Zhang phrase it, but it cuts their explicit search to
three named smooth projective varieties. Any decision at \(m=2\) or \(m=3\)
identifies the first one-step cancellation example.

## Exact evidence

Rank-two weights, Galois action, Cox Jacobian rank/minor, and residual
character matrices:

- `notes/cubic-threefolds-tasks/c925-i1-level3-descent-frontier-check.py`;
- `notes/cubic-threefolds-tasks/c925-i1-level3-descent-frontier-check.json`.

The Python file is 9,587 bytes with SHA-256
`94b843967572b15f46ed8c581010ed8181a8a4b6f5416e4c5f5fc46d376bdb1b`;
the JSON is 2,556 bytes with SHA-256
`5c2a6b4c50c9e222828d518cd84f99dda81fef2b4fa42536855f49fa080b9384`.

Replay:

    uv run --with sympy==1.14.0 python3 \
      notes/cubic-threefolds-tasks/c925-i1-level3-descent-frontier-check.py \
      --check-certificate \
      notes/cubic-threefolds-tasks/c925-i1-level3-descent-frontier-check.json

CARAT class and Kunyavskii-list exclusion:

- `notes/cubic-threefolds-tasks/c925-i1-level3-quotient-carat-check.g`;
- `notes/cubic-threefolds-tasks/c925-i1-level3-quotient-carat-check.txt`.

The GAP file is 1,093 bytes with SHA-256
`4ef9c57640f132553b7d5eb2ee11182ab1b88acba59a518f429607ca3a2539f7`;
the expected output is 94 bytes with SHA-256
`9b70921e1ec830d440b5764345d5d13fc9e1053e5e9cc45bc860385fb2e55e77`.

From the extracted `RatProbAlgTori/` directory:

    nix shell nixpkgs#gap-full -c gap -q -c \
      'RequirePackage:=LoadPackage;; Read("RatProbAlgTori.gap"); \
       Read("/home/tavis/src/othello/notes/cubic-threefolds-tasks/c925-i1-level3-quotient-carat-check.g");' \
      | rg '^rank_three_' \
      | diff -u \
          /home/tavis/src/othello/notes/cubic-threefolds-tasks/c925-i1-level3-quotient-carat-check.txt -

Complete invariant-rank-two enumeration, weight polygons, normalized degrees,
boundary-edge orbits, residual character matrices, and CARAT replay:

- `notes/cubic-threefolds-tasks/c925-i1-rank2-linear-slice-exhaustion.py`,
  10,982 bytes, SHA-256
  `bb391a2bb2a3a8fd5a6f91f766c05ec5fff0337350fcd0c708f2a266b303ac4a`;
- `notes/cubic-threefolds-tasks/c925-i1-rank2-linear-slice-exhaustion.json`,
  9,649 bytes, SHA-256
  `cf9e54f1b4fc36de4d90c3bd6458084723d9d7cd849e74370f8b753e087ede0f`;
- `notes/cubic-threefolds-tasks/c925-i1-rank2-linear-slice-exhaustion-carat-check.g`,
  1,274 bytes, SHA-256
  `ee5393a9061e0be30220836942a9606116b736ccfd11e15cd7903a81a5966bb0`;
- `notes/cubic-threefolds-tasks/c925-i1-rank2-linear-slice-exhaustion-carat-check.txt`,
  152 bytes, SHA-256
  `c2655fe69848ade77bc5b0391241fdccb79af0e488eae167355ded6f75e2ec7c`.

Replay the Python certificate as above, replacing the script and JSON names.
Replay the GAP certificate from `RatProbAlgTori/` with:

    nix shell nixpkgs#gap-full -c gap -q -c \
      'RequirePackage:=LoadPackage;; Read("RatProbAlgTori.gap"); \
       Read("/home/tavis/src/othello/notes/cubic-threefolds-tasks/c925-i1-rank2-linear-slice-exhaustion-carat-check.g");' \
      | rg '^rank2_' \
      | diff -u \
          /home/tavis/src/othello/notes/cubic-threefolds-tasks/c925-i1-rank2-linear-slice-exhaustion-carat-check.txt -

## Sources and scope

- Yuri Tschinkel and Zhijia Zhang, *Universal torsors over quartic del Pezzo
  surfaces and stable rationality*, arXiv:2608.20029v1. **Read depth:
  partial** — Theorem 2.4, Section 3, Proposition 4.1, Lemma 4.2, the
  “Levels of stable rationality” paragraph, and Proposition 5.1. Shared-cache
  PDF SHA-256
  `be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.
- Akinari Hoshi and Aiichi Yamasaki, *Rationality problem for algebraic tori*,
  Mem. Amer. Math. Soc. 248 (2017), no. 1176. **Read depth: partial** —
  Theorem 1.2 and Example 5.3, including the exact conversion of
  Kunyavskii's fifteen exceptions to CARAT identifiers. Shared-cache PDF
  SHA-256 `775759f276b06afb754c73ca9f4be69b3c6db23ec1c75b536873395cc8ff6b48`.

## Mystery ledger

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | Rank-two orbit closure | Four exact \(4\)-coordinate weight blocks give a Segre quadric. |
| settled | Split-field one-point slice | Jacobian rank six and factorized nonzero minor (7). |
| settled | Residual rank-three torus | Character CARAT class \((3,25,2)\), rational by Kunyavskii. |
| settled | Direct linear descent fails | Opposite conjugate ruling spaces span all \(\mathbf P^{15}\). |
| settled | All invariant rank-two linear slices fail | Four-plane exhaustion; open intersection degree is divisible by two or three. |
| open | Level three | Requires a nonlinear descended slice or direct invariant-field parametrization. |
| open | Cancellation outcome | Irrational level three would yield \(Y\not\sim\mathbf P\) but \(Y\times\mathbf A^1\sim\mathbf P\). |
| settled | Finite cancellation certificate | One of \(X\times\mathbf P^i\), \(1\le i\le3\), is nonrational with rational \(\mathbf A^1\)-stabilization. |

**Resume line:** go C925 cubic-threefolds — the certified interval is
\(2\le s(X)\le4\); attack the nonlinear descent of the rank-two Segre-orbit
slice, knowing that the residual torus is rational and a negative answer is
an \(\mathbf A^1\)-cancellation counterexample.
