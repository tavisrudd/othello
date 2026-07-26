# C80 — sparse-complement Node--Kayles boundary lemma

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.

## Statement

Let `G` be a finite graph and let `F = complement(G)`. Consider normal-play
Node--Kayles on `G`: a move at `v` deletes the closed neighbourhood
`N_G[v]`, and the player with no move loses.

Write `g(G)` for its Sprague--Grundy value.

> **Sparse-complement lemma.** Suppose `F` is triangle-free.
>
> 1. If `V(G)` is empty, then `g(G)=0`.
> 2. If `F` has no edges and `V(G)` is nonempty, then `g(G)=1`.
> 3. If `F` has an edge and no isolated vertex, then `g(G)=0`.
> 4. If `F` has both an edge and an isolated vertex, then `g(G)=2`.

Equivalently, for a nonempty triangle-free complement, the Grundy value is
determined solely by whether `F` has an isolated vertex and whether it has a
nonisolated vertex:

| vertices present in `F` | option Grundy set | `g(G)` |
| --- | --- | ---: |
| isolated only | `{0}` | 1 |
| nonisolated only | `{1}` | 0 |
| both kinds | `{0,1}` | 2 |

The C80 certificate verifies the stronger hypothesis that all 105 relevant
complements are linear forests. The triangle-free formulation is the natural
theorem: acyclicity and the observed maximum path length are unnecessary.

## Proof

Fix `v ∈ V(G)`. The vertices surviving the Node--Kayles move at `v` are

```text
V(G) \ N_G[v].
```

Because `F` is the complement of `G`, a distinct vertex survives exactly when
it is adjacent to `v` in `F`. Thus the follower is

```text
G[N_F(v)].
```

Since `F` is triangle-free, no two vertices of `N_F(v)` are adjacent in `F`.
They are therefore pairwise adjacent in `G`, so the follower is the complete
graph

```text
K_{deg_F(v)}.
```

The empty graph has Grundy value 0. Every nonempty complete graph has Grundy
value 1, because every move deletes the whole graph and reaches the empty
position. Consequently the option at `v` has value

```text
0, if deg_F(v)=0;
1, if deg_F(v)>0.
```

The result follows by taking the mex of the option values.

- If `G` is empty, it has no options and value 0.
- If every vertex of `F` is isolated, the option set is `{0}`, hence
  `g(G)=mex{0}=1`.
- If every vertex of `F` is nonisolated, the option set is `{1}`, hence
  `g(G)=mex{1}=0`.
- If both kinds occur, the option set is `{0,1}`, hence
  `g(G)=mex{0,1}=2`.

This proves all four cases.

## Continuation-complex form

In a static Node--Kayles residual, `F` is the graph of pairs that can be
played together. Its cliques are precisely the legal continuation sets.
Therefore:

```text
F triangle-free
⇔ no legal three-move continuation exists;

F has no isolated vertex
⇔ every legal move has a legal mate.
```

The P-case of the lemma is exactly the earlier “pure one-dimensional
continuation complex” criterion:

> If every legal move has a mate and no legal triple exists, the position is
> P.

The proof above also supplies the two complementary N-cases. A universal
conflict vertex—an isolated vertex of `F`—gives an immediate move to the
empty follower; coexistence somewhere else supplies an option of value 1.

This is a boundary theorem. It applies to a cap residual only after the
`capOK`/no-active-triples reduction has proved that the continuation game is
static Node--Kayles. It does not turn an arbitrary positive-overload cap
residual into a graph game.

## Application to the C80 spoilers

The marked-secant comparison contains 106 strict spoiling candidates.

- For 105 candidates, `Ω=0`, so the residual is static Node--Kayles.
- Each nonconflict complement is a linear forest and hence triangle-free.
- Forty-seven complements have no edge, giving Grundy 1.
- Fifty-eight have both an edge and an isolated vertex, giving Grundy 2.

Thus all 105 positions are N by the lemma, without evaluating their game
trees.

The unique q19 candidate at `Ω=1` has four moves. Three reach `K₂`, whose
complement is two isolated vertices and whose Grundy value is 1. The fourth,
at `(14,8)`, reaches the empty graph and hence a P-position. The `Ω=1`
candidate is therefore N with a unique winning move.

This proves the finite spoiler values structurally. It does not supply the
missing positive-overload admissible-edge theorem: the q17 `Ω=40` and q19
`Ω=169` repairs still require a response-certificate transport operation
before they reach a boundary where this lemma can apply.

## Reproduction

The exact finite application is generated and checked by:

```text
cd /home/tavis/src/othello
python3 rust/scripts/c80_marked_secant_spoiler_repair_compare.py
python3 rust/scripts/c80_marked_secant_spoiler_repair_compare.py --check
```

The canonical evidence and its trust boundary are recorded in
`notes/2026-07-25-c80-marked-secant-spoiler-repair-compare.md` and the
adjacent JSON certificate. The graph lemma itself is elementary and does not
depend on the computation; the certificate checks that the 105 C80 residuals
satisfy its hypotheses.

## Tao-style continuation question

The proof singles out one structural coordinate rather than an arbitrary
feature score. Let

```text
μ(S) = min_x |{y : S+x+y is legal}|,
```

where `x` ranges over the legal moves from `S`. Thus `μ(S)>0` says that every
legal move has a mate.

The certified repairs have substantial mate surplus:

```text
q17 Ω=40 repairs: μ=8;
q19 Ω=169 repair: μ=17.
```

Every one of the 106 spoiling targets has `μ=0`. At `Ω=0`,
triangle-freeness is automatic from the absence of legal triples, and the
lemma says that the nonterminal condition `μ>0` is exactly the structural P
case within this sparse-complement family.

This suggests a sharper positive-overload target than another fitted edge
profile. Seek a geometrically defined family on which, for every opponent
move, one can choose a strict-`Ω` reply that preserves `μ>0`. Well-founded
descent would then end at the P boundary supplied by the lemma. Positive
`μ` alone does not prove a positive-overload state P, so the missing theorem
is closure under a concrete reply construction:

```text
μ(S)>0 and Ω(S)>0
⇒ for every legal o, there exists legal p such that
     Ω(S+o+p)<Ω(S) and μ(S+o+p)>0,
```

on an explicitly stated geometric survivor family. The next cheap
falsifier is to test this closure on the complete certified q13/q17 DAGs and
the marked q19 control before attempting a field-uniform incidence proof.
This is local mate coverage, not a perfect-matching or Tutte condition.

## Scope and provenance

This note packages an elementary Node--Kayles calculation for reuse in the
cap lane. It makes no novelty claim for the abstract graph lemma. The
project-specific content is its certified application to the three marked C80
spoiling types and its identification with the previously isolated
pure-one-dimensional cap boundary.

## Consequence

The useful boundary packet can be stated without a Grundy oracle:

```text
B_sparse(S):
  Ω(S)=0,
  the legal-pair graph is triangle-free,
  and every legal move has a mate.
```

Then `B_sparse(S)` implies that `S` is P. This is a reusable structural base
for a future reservoir-preserving exchange theorem. On the already certified
q13/q17/q19 survivor DAGs it does not enlarge the accepted boundary—`B_cc`
already covers every visited P boundary—but it gives a shorter proof for this
subfamily and a clean target for formalization.

## Vibe

The write-up converts a 105-row exact-value observation into a one-line mex
mechanism. It is a real conceptual compression, but it solves the boundary
semantics rather than the positive-overload transport problem.

go C80 cap construct a proof-producing reservoir-preserving exchange operation
