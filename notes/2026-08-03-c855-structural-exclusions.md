# C855 — structural exclusion attempts (families 2 and 4)

**Date:** 2026-08-03
**Lane:** `clebsch` (Paper I stream)
**Task:** C855 — Paper I Lean referee-artifact remediation, structural attempts 1 and 2 of the
scoping memo `notes/2026-08-03-c855-certificate-scoping.md`.
**Scope:** mathematics only. No Lean file was edited, no Lean build, generator, manifest, or gate
was run, and no manuscript was changed.

Two targets:

1. Family 2 — extend the exterior-set/weight-eight exclusion uniformly to orders seventeen and
   nineteen so that the maximum-passant-six-arc bound at orders thirteen, seventeen, and nineteen
   is structural rather than certified by the root-edge orbit DAGs.
2. Family 4 — prove that no six-arc over the field of eleven elements has off-vertex triple-chord
   concurrence count seven, eight, or nine, reducing `thm:gap` to a human proof.

*(This file is written incrementally as the work proceeds.)*

## Target 2 — the concurrence count of a six-arc

### Setup and the matching dictionary

Let `A` be a six-arc in the plane of order `q`, `q` odd, with vertex set labelled by
`{1,…,6}`. Its fifteen chords are the edges of the complete graph on the six vertices. Two chords
meet at a vertex exactly when they share a label, so an intersection point off the arc lies on a
set of pairwise disjoint chords, that is, on a partial matching of the complete graph on six
vertices. A matching of six vertices has at most three edges, so no off-vertex point lies on more
than three chords, and the points lying on exactly three chords correspond to the perfect
matchings — one-factors — of the complete graph on six vertices whose three chords are concurrent.
There are fifteen one-factors. Write `M` for the set of concurrent ones and `n₃ = |M|`; the
Brianchon-count identity gives uncovered size `22 − n₃` at order eleven.

### The Fano bound: `n₃ ≤ 10`, with the equality structure

For an edge `e = uv` of the complete graph, let `d(e)` be the number of one-factors in `M` that
contain `e`. Exactly three one-factors contain a given edge, obtained from the three ways of
matching the complementary four vertices, so `d(e) ∈ {0,1,2,3}`.

**Lemma (edge bound).** `d(e) ≤ 2` for every edge.

*Proof.* Let `e = uv` and let `Q = A ∖ {u,v}` be the complementary four points, a complete
quadrangle because `A` is an arc. Its three diagonal points are the three intersections
`wx ∩ yz`, `wy ∩ xz`, `wz ∩ xy` of pairs of opposite sides, and they are exactly the points where
the three one-factors through `e` would have to be concurrent: the one-factor `{uv, wx, yz}` is
concurrent precisely when the diagonal point `wx ∩ yz` lies on the line `uv`. So `d(uv)` is the
number of diagonal points of the complementary quadrangle lying on the line `uv`. If `d(uv) = 3`
the three diagonal points would be collinear, contradicting Fano's axiom, which holds in every
Desarguesian plane of odd order. ∎

Each diagonal point is distinct from every vertex of `A`, since a diagonal point equal to a vertex
would put three arc points on a line, so the count above is the honest incidence count.

**Theorem (Dye's Brianchon bound, structurally).** `n₃ ≤ 10`. Equality holds exactly when every
edge lies in exactly two concurrent one-factors, that is, exactly when the five non-concurrent
one-factors are pairwise disjoint and hence form a one-factorization of the complete graph on six
vertices.

*Proof.* Counting incident pairs `(e, M)` with `e ∈ M ∈ M` in two ways gives
`3 n₃ = Σ_e d(e) ≤ 2·15 = 30`, so `n₃ ≤ 10`. Equality forces `d ≡ 2`, so the complementary set of
five one-factors has every edge in exactly one of them: it is a one-factorization. ∎

This reproves, with no enumeration and for every odd order, the bound that Paper I currently takes
as one of the two declared Dye axioms, and it recovers the manuscript's own description of the
equality case ("the ten matchings are exactly those outside the five self-polar ones"). What the
argument does *not* give is the second half of the Dye axiom, that the equality configurations form
a single projective orbit.

### The outer automorphism turns the concurrence set into a graph

The fifteen one-factors of the complete graph on six vertices carry a second, dual, six-element
structure: there are exactly six one-factorizations — sets of five pairwise disjoint one-factors
partitioning the fifteen edges — and every one-factor lies in exactly two of them. Sending each
one-factor to the pair of one-factorizations containing it is a bijection from the fifteen
one-factors to the fifteen pairs drawn from a synthetic six-element set; this is the outer
automorphism of the symmetric group of degree six in its classical guise. Under it:

- two one-factors are **disjoint** exactly when their synthetic pairs **meet**;
- the three one-factors through a fixed edge of the arc's complete graph, which pairwise share that
  edge, map to three pairwise disjoint synthetic pairs, that is, to a **perfect matching** of the
  synthetic set (verified directly: the edge `{1,2}` gives the synthetic matching
  `{1,2},{3,4},{5,6}`);
- the alternating side-triples and the main-diagonal triple of a hexagonal ordering of the arc map
  to the three pairs of a **synthetic triangle** (verified directly for the ordering `1,…,6`: the
  one-factors `{12,34,56}`, `{23,45,61}`, `{14,25,36}` map to `{1,2}`, `{1,3}`, `{2,3}`).

So let `G` be the graph on the six one-factorizations whose edges are the *concurrent* one-factors.
Then `n₃` is the number of edges of `G`, and the two lemmas below say exactly that `G` is a
disjoint union of complete graphs with no perfect matching.

### Lemma A (no perfect matching): the Fano lemma restated

The edge bound `d(e) ≤ 2` proved above says precisely that the three one-factors through a common
arc edge are never all concurrent; under the dictionary that is the statement that **`G` contains
no perfect matching of the synthetic six-element set**.

### Lemma B (transitivity): double perspective implies triple perspective

**Lemma.** If two disjoint one-factors of a six-arc are both concurrent, so is the third one-factor
completing their synthetic triangle.

*Proof.* Label the arc so that the two given one-factors are `{12,34,56}` and `{23,45,61}`, which is
possible because two disjoint one-factors have union a six-cycle; take that six-cycle as the
hexagonal ordering `1,2,3,4,5,6`. The third one-factor of the synthetic triangle is then the main
diagonal triple `{14,25,36}`. Write the two triangles `A = (1,3,5)` and `B = (2,4,6)`. The first
hypothesis says `A` and `B` are perspective under the correspondence `1↦2, 3↦4, 5↦6`; the second
says they are perspective under `1↦6, 3↦2, 5↦4`. The conclusion says they are perspective under
`1↦4, 3↦6, 5↦2`. So the lemma is the classical statement that two triangles in double perspective
are in triple perspective, and over a field it has a three-line coordinate proof.

Take `A₁ = (1:0:0)`, `A₂ = (0:1:0)`, `A₃ = (0:0:1)` and the first centre of perspectivity
`P = (1:1:1)`; this is legitimate because the six points form an arc, so `P` is not a vertex and
lies on no side of `A` — if `P` were on the line `A₁A₂` it would equal the intersection of that
line with one of the other two lines of the first one-factor, hence be a vertex. Each `Bᵢ` lies on
the line `AᵢP`, so `B₁ = (x:1:1)`, `B₂ = (1:y:1)`, `B₃ = (1:1:z)` with `x, y, z` nonzero and not
equal to one. The lines of the second perspectivity are
`A₁B₂ = (0:-1:y)`, `A₂B₃ = (z:0:-1)`, `A₃B₁ = (-1:x:0)`, whose determinant is `xyz − 1`. The lines
of the third are `A₁B₃ = (0:-z:1)`, `A₂B₁ = (1:0:-x)`, `A₃B₂ = (-y:1:0)`, whose determinant is
`1 − xyz`. The two concurrence conditions are therefore the same equation `xyz = 1`, and each
implies the other. ∎

The argument uses only commutativity of the field, so it is valid in every Desarguesian plane over
a field, of any order, and it is short enough to formalize directly: three cross products, two
three-by-three determinants, and the observation that the two determinants are negatives of each
other.

### Theorem (the concurrence spectrum)

**Theorem.** Let `A` be a six-arc in the Desarguesian plane of odd order `q`. Then the graph `G` of
concurrent one-factors is a disjoint union of complete graphs on the six one-factorizations, none
of whose parts is a perfect matching; equivalently `G` is the graph of an equivalence relation on a
six-element set having at least one odd class. Consequently, if the class sizes are `a₁,…,a_k`,
then
```
n₃ = Σ C(aᵢ, 2),   Σ aᵢ = 6,   at least one aᵢ odd,
```
and therefore
```
n₃ ∈ {0, 1, 2, 3, 4, 6, 10}.
```
In particular `n₃ ∉ {5, 7, 8, 9}`, `n₃ ≤ 10`, and `n₃ = 10` occurs exactly for the class partition
`5+1`, whose five non-concurrent one-factors are the one-factorization indexed by the singleton
class.

*Proof.* Lemma B says the adjacency relation on the six one-factorizations defined by `G` is
transitive; it is symmetric by construction, so adding the diagonal makes it an equivalence
relation and `G` is the disjoint union of the complete graphs on its classes. A disjoint union of
complete graphs has a perfect matching exactly when every class has even size, so Lemma A forces
some class to be odd. Enumerating the partitions of six and discarding those with all parts even
(`6`, `4+2`, `2+2+2`) leaves
```
1+1+1+1+1+1 → 0    2+1+1+1+1 → 1    2+2+1+1 → 2    3+1+1+1 → 3
3+2+1      → 4    4+1+1     → 6    3+3     → 6    5+1    → 10
```
which is the stated set of values. ∎

### Status of Target 2

**Verdict: proved, and strictly stronger than the target.** The exclusion of concurrence counts
seven, eight, and nine is a corollary, so `thm:gap` reduces to a human proof: at order eleven the
Brianchon-count identity turns the spectrum into uncovered sizes `22 − n₃ ∈ {12,16,18,19,20,21,22}`,
the Clebsch class is the unique one with `n₃ = 10`, and every other class has uncovered size at
least sixteen. The census's role becomes descriptive — exhibiting that all seven values do occur at
order eleven — rather than evidentiary.

Three further consequences beyond the stated target:

- The count five is excluded as well, which the memo did not ask for; the partition `2+2+2` is
  killed by Lemma A, not by any size bound.
- **Dye's Brianchon bound of ten, one of the two declared Dye axioms of the Paper I Lean
  development, is proved here for every odd order, together with the equality structure** (the
  non-concurrent one-factors at equality form a one-factorization, matching the manuscript's five
  self-polar triangles). What remains of that axiom is only the assertion that the equality
  configurations form a single projective orbit, which is a separate statement.
- The classification is order-independent: the same eight equivalence types are the only possible
  ones in every Desarguesian plane of odd order. Orders seven, eleven, thirteen, seventeen, and
  nineteen were checked exhaustively against the theorem by the probe script, and every realized
  type is one of the eight.

### Computational corroboration (not the deliverable)

`notes/2026-08-03-c855-sixarc-concurrence-types.py` enumerates every four-frame-normalized six-arc
in the plane of order `q` for `q ∈ {7,11,13,17,19}`, records the set of concurrent one-factors,
canonicalizes it under the symmetric group of degree six, and reports the type. The realized types
are exactly the equivalence-relation graphs predicted above, and no run produced a concurrence count
of five, seven, eight, or nine. Replay:

```
python3 notes/2026-08-03-c855-sixarc-concurrence-types.py 7 11 13 17 19
```

Realized class partitions by order:

| order | realized partitions                                     | missing            |
|-------|---------------------------------------------------------|--------------------|
| 7     | `3+2+1`, `3+3`, `4+1+1`                                 | the five sparse ones |
| 11    | all but `3+3`                                           | `3+3`              |
| 13    | all but `5+1`                                           | `5+1`              |
| 17    | all but `3+3` and `5+1`                                 | `3+3`, `5+1`       |
| 19    | all eight                                               | none               |

The Clebsch type `5+1` occurring at orders eleven and nineteen but not thirteen or seventeen is
consistent with the manuscript's own three-regimes remark about the Clebsch family. At order eleven
the seven realized types are coarser than the fifteen projective classes: the type records only the
concurrence pattern, so several projective classes share a type.

## Target 1 — the maximum passant arc at orders thirteen, seventeen, and nineteen

*(in progress)*
