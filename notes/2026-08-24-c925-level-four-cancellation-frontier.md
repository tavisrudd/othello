# C925: level four is the cancellation frontier

**Lane:** cubic-threefolds · **Task:** C925 · **Date:** 2026-08-24

## Result

Let \(X/\mathbf Q\) be either of the explicit type-\(I_1\) cubic threefolds
of Tschinkel--Zhang Proposition 5.1. C925 now proves

\[
X\times\mathbf P^5\quad\text{is rational}. \tag{1}
\]

Put \(Y=X\times\mathbf P^4\). Since
\(\mathbf P^4\times\mathbf A^1\) is birational to \(\mathbf P^5\), (1)
gives

\[
Y\times\mathbf A^1\quad\text{is rational}. \tag{2}
\]

Therefore level four has a sharp dichotomy:

\[
\boxed{
X\times\mathbf P^4\text{ is rational, or }
Y=X\times\mathbf P^4\text{ is nonrational while }Y\times\mathbf A^1
\text{ is rational}.}
\tag{3}
\]

Tschinkel--Zhang explicitly state that no nonrational variety with rational
one-fold affine stabilization is currently known. Thus a proof of
irrationality at \(m=4\) would solve that cancellation problem, while a proof
of rationality would lower the stabilization bound. This explains why the
next step is qualitatively different from the reductions (11\to10\to8\to
6\to5).

## Exact torus structure at level four

Let \(M\) be the rank-five type-\(I_1\) character lattice of the rational
torus \(T_0\). Exact calculation gives

\[
M^G=0,
\qquad
(M^\vee)^G=0. \tag{4}
\]

Hence there is no second split scalar after quotienting the anticanonical
direction. In particular, the projectivization mechanism which removed the
fifth stabilization cannot be iterated.

There are exactly three rank-one sign characters for the chosen two
generators, with signs

\[
(1,-1),\qquad(-1,1),\qquad(-1,-1). \tag{5}
\]

For each sign, let \(v\) be the primitive injection of the sign lattice into
\(M\), and let \(r:M\to\mathbf Z_{\mathrm{sign}}\) be the primitive quotient.
Their pairings are

\[
r(v)=-2,-2,-6, \tag{6}
\]

respectively. Thus none of the three rank-one directions splits integrally.
The obstruction is not absence of a rational four-dimensional quotient:
the three kernels of \(r\) have CARAT identifiers

\[
(4,76,3),\qquad(4,76,3),\qquad(4,78,3). \tag{7}
\]

The first two embed in Lemire's hereditarily rational maximal class
`[4,32,21,1]`, and the third embeds in `[4,20,22,1]`. Therefore all three
rank-four quotient tori are rational over every characteristic-zero base
field.

Equations (4)--(7) isolate the remaining issue. Both the rank-five torus and
all natural rank-four quotients are rational, but passing from
\(S\times T_0\) to \(S\times T_4\) asks for cancellation of one rational
variable from a rational total space. The lattice data alone cannot perform
that cancellation; the indices in (6) also rule out an integral product
decomposition as the missing shortcut.

## Exact certificates

Rank-one lattice enumeration:

- `notes/cubic-threefolds-tasks/c925-i1-level4-frontier-check.py`,
  4,669 bytes, SHA-256
  `6123694d4cd90fbccaf45e5dc91f4e16c04f45d2d45f8b70fd26bc292e2dff13`;
- `notes/cubic-threefolds-tasks/c925-i1-level4-frontier-check.json`,
  4,698 bytes, SHA-256
  `3b44f1cdaf0d9fddd221c63a84085e2563fda1ac5c486c5fe1e79c48990d6a0f`.

Replay from `/home/tavis/src/othello`:

    uv run --with sympy==1.14.0 python3 \
      notes/cubic-threefolds-tasks/c925-i1-level4-frontier-check.py \
      --check-certificate \
      notes/cubic-threefolds-tasks/c925-i1-level4-frontier-check.json

The certificate exhausts all four sign pairs, proves (4)--(6), constructs
saturated bases for all three rank-four kernels, and checks their integral
group actions.

CARAT and hereditary-rationality check:

- `notes/cubic-threefolds-tasks/c925-i1-level4-quotient-carat-check.g`,
  1,852 bytes, SHA-256
  `6489413101f12cc2b94bc983d6fb1a9202e298205256b34b63650ced180bfc63`;
- `notes/cubic-threefolds-tasks/c925-i1-level4-quotient-carat-check.txt`,
  171 bytes, SHA-256
  `5fabb5873f942cc05c83090a88d0a876100a41f894972230e81d955464cd937d`.

Use the same pinned `RatProbAlgTori-2018.05.22.zip` as the level-five CARAT
check. From its extracted `RatProbAlgTori/` directory, run:

    nix shell nixpkgs#gap-full -c gap -q -c \
      'RequirePackage:=LoadPackage;; Read("RatProbAlgTori.gap"); \
       Read("/home/tavis/src/othello/notes/cubic-threefolds-tasks/c925-i1-level4-quotient-carat-check.g");' \
      | rg '^quotient_' \
      | diff -u \
          /home/tavis/src/othello/notes/cubic-threefolds-tasks/c925-i1-level4-quotient-carat-check.txt -

The checker verifies (7) and independently searches the subgroup conjugacy
classes of all eight maximal hereditarily rational groups in Lemire's
Theorem 4.13.

## Sources and read depth

This report names three sources; none was read at full-text depth for this
bounded result.

- Yuri Tschinkel and Zhijia Zhang, *Universal torsors over quartic del Pezzo
  surfaces and stable rationality*, arXiv:2608.20029v1.
  **Read depth: partial** — Lemma 4.2, the levels paragraph, the cancellation
  sentence immediately before Section 5, and Proposition 5.1. Shared-cache
  key `arXiv:2608.20029`, PDF SHA-256
  `be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.
- Nicole Lemire, *Four-Dimensional Algebraic Tori*, arXiv:1511.00315.
  **Read depth: partial** — Remark 4.12, Theorem 4.13, and the maximal
  hereditarily rational group list. Shared-cache key `arXiv:1511.00315`, PDF
  SHA-256
  `f93ae35ef1abefdb8cc0dd3ead8ae2742d40fb0141e728398534733632875b5c`.
- Akinari Hoshi and Aiichi Yamasaki, *RatProbAlgTori for GAP 4*, version
  2018.05.22.
  **Read depth: partial (software source)** — the CARAT convention and
  subgroup-conjugacy functions used by the exact replay.

## Mystery ledger

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | A second split-scalar quotient is impossible. | Both invariant ranks in (4) vanish. |
| settled | Every rank-one sign direction is nonsplit. | Complete sign enumeration and indices (2,2,6). |
| settled | All three natural rank-four quotient tori are rational. | CARAT IDs and Lemire hereditary containers. |
| settled | \(Y=X\times\mathbf P^4\) has rational \(Y\times\mathbf A^1\). | The level-five theorem and elementary birational dimension bookkeeping. |
| open | Is \(Y\) rational? | This is exactly the \(m=4\) bound; a negative answer supplies the cancellation example stated open by Tschinkel--Zhang. |
| open | Can a nonsplit quotient of the projectivized torsor be rationalized geometrically? | Requires control of the associated one-dimensional torus torsor, not another character-lattice decomposition. |

## EJ+TT checkpoint

The level-four obstruction is no longer “the torus might be nonrational”:
every torus visible in the rank-one quotient diagram is rational. The missing
operation is cancellation itself. This sharply separates the successful
block-kernel optimization from the next geometric problem and prevents a
formal iteration from silently claiming a solution to a major open question.

**Resume line:** go C925 cubic-threefolds — analyze the three nonsplit
one-dimensional torsors on the projectivized universal torsor, with the
level-four cancellation dichotomy as the acceptance boundary.
