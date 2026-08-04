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

*Correction, established while formalizing this lemma:* the two displayed line triples are
exchanged relative to the prose. The triple `A₁B₂, A₂B₃, A₃B₁` is the conclusion matching
`{14, 25, 36}`, and `A₁B₃, A₂B₁, A₃B₂` is the hypothesis matching `{16, 23, 45}`. The displayed
determinants are correct for the triples as displayed, so the lemma and its proof stand. The Lean
statement and proof are derived from the lemma statement rather than from these displayed lines;
see `notes/2026-08-04-c855-triple-perspective.md`.

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

### What the order-thirteen argument actually uses

The companion's conceptual exclusion at order thirteen is a chain of three steps, and every one of
them is an equality between two functions of the order that happens to hold at thirteen only.

1. *All vertices are internal.* An eight-arc has seven chords at each vertex, all passant. An
   exterior point lies on `(q−1)/2` passants and an internal point on `(q+1)/2`. At order thirteen
   those are six and seven, so the exterior alternative is excluded by one line and every vertex is
   internal.
2. *The passant pencil at each vertex is saturated.* Seven chords fill all seven passants through an
   internal point. Consequently the lines through a vertex that are not chords — the arc's tangent
   lines at that vertex, in Segre's sense — are exactly the conic's secants through it. This is the
   equality `k − 1 = (q+1)/2` with `k = 8`, that is, `q = 2k − 3 = 13`.
3. *The Segre product becomes intrinsic to the conic.* Because of step 2, the tangent product
   `T_P` appearing in Segre's lemma of tangents is the product of the conic's secants through `P`,
   a function of the conic alone. The lemma then reads as the closed condition `h(P,Q,R) = 1` on
   triples of internal points, and the eight-arc becomes an eight-clique in a graph defined purely
   by the conic — the graph on the forty-two passant neighbours of a fixed internal point whose
   local clique number is five by the five-row unique-closure argument. Saturation also makes the
   arc's characteristic vector a weight-eight word of the order-thirteen passant code, which is the
   same fact stated in coding terms.

### What breaks at orders seventeen and nineteen

Step 1 fails: exterior points lie on `(q−1)/2 = 8` and `9` passants respectively, both at least the
seven chords an eight-arc needs, so vertices of either type are admissible and the arc can be of
mixed type. Every maximum example found at orders thirteen, seventeen, and nineteen is in fact of
mixed type, so this is not a removable inconvenience.

Step 2 fails: an internal vertex has `(q+1)/2 − 7 = 2` and `3` leftover passants, and an exterior
vertex has `(q−1)/2 − 7 = 1` and `2` leftover passants together with its two conic tangents. So the
arc's tangent product at a vertex is the conic-secant product multiplied by an uncontrolled
residual factor over the leftover passants — a factor that depends on the arc and not on the conic.

Step 3 therefore fails too: Segre's lemma still holds, but the relation it gives is no longer a
closed condition on the conic's own data, so there is no conic-defined graph in which the
hypothetical arc is a clique, and no code in which its characteristic vector is a word. The
five-row unique-closure lemma is a statement about that conic-defined graph at order thirteen; it
has no order-seventeen or order-nineteen counterpart to generalize to, because the graph itself does
not exist there. This is the precise sense in which the Segre lemma-of-tangents mechanism does not
generalize.

### The decisive obstruction: the statement is not uniform in the order

The target asked for a proof uniform in the order. No such proof exists, because the statement
being proved is false one order later.

**Exhaustive search result.** Enumerating every arc of off-conic points all of whose joins are
passant, in the plane of order `q` with conic `XZ = Y²`:

| order | arcs of size 2 | 3         | 4          | 5          | 6          | 7       | 8    | maximum |
|-------|----------------|-----------|------------|------------|------------|---------|------|---------|
| 11    | 3 630          | 24 475    | 23 210     | 264        | 22         | 0       | 0    | 6       |
| 13    | 7 098          | 71 526    | 123 123    | 15 288     | 546        | 0       | 0    | 6       |
| 17    | 20 808         | 390 048   | 1 555 296  | 913 104    | 50 184     | 0       | 0    | 6       |
| 19    | 32 490         | 782 325   | 4 301 220  | 3 962 412  | 395 124    | 0       | 0    | 6       |
| 23    | 69 828         | 2 565 926 | 23 759 230 | 45 114 960 | 13 197 492 | 568 744 | 6 072| **8**   |

At order twenty-three there are 6 072 eight-point arcs all of whose chords are passant. One of them
is

```
(1:0:1), (1:1:2), (1:2:15), (1:5:15), (1:7:20), (1:12:18), (1:13:11), (1:16:11)
```

verified independently of the search: all eight points are off the conic, all twenty-eight joins are
passant (the restricted discriminant `B(P,R)² − 4Q(P)Q(R)` is a nonzero non-square in every case,
for `Q = Y² − XZ` and `B` its polarization), and no three points are collinear. Its type profile is
six internal and two exterior points.

Randomized greedy search pushes the lower bound further at larger orders: it finds passant arcs of
size at least seven at order twenty-three, ten at twenty-nine, nine at thirty-one, nine at
thirty-seven, ten at forty-one, and nine at forty-three. These are lower bounds only — greedy
returns seven at order twenty-three where the true maximum is eight — and greedy reproduces the
exact value six at orders thirteen, seventeen, and nineteen. The maximum passant arc size therefore
grows with the order, and the value six is a small-order phenomenon confined to the window the
theorem is about.

**Consequence for any proof strategy.** A structural bound of the usual shape — a counting,
character-sum, or clique bound in which the order enters as a parameter — is monotone or at worst
eventually increasing in the order, so it cannot yield six at order nineteen while permitting eight
at order twenty-three. Any correct argument at orders seventeen and nineteen must therefore be
arithmetic in the individual order: it has to use a divisibility, quadratic-residue, or
subgroup-order coincidence that holds at thirteen, seventeen, and nineteen and fails at
twenty-three. That is exactly what the order-thirteen argument is — the coincidence `q = 2k − 3` —
and no analogous coincidence has been found at seventeen or nineteen.

### What the literature supplies, and its exact limit

Blokhuis, Seress, and Wilbrink's characterization, whose terminology the companion already cites,
is the natural published tool, and reading it pins down precisely how far it reaches. Their theorem:
a set of `(q+1)/2` **exterior** points of a nonsingular conic, pairwise joined by passants, consists
of the exterior points on a single passant line whenever `q ≡ 1 (mod 4)`. Their passant criterion is
the same cross-ratio criterion that makes the group model work: identifying an exterior point with
the pair of conic points whose tangents pass through it, the join of two such points is passant
exactly when the cross-ratio of the two pairs is a non-square.

Two limits keep this from closing the target.

- It is a statement about exterior points only, and every maximum passant arc at orders thirteen,
  seventeen, and nineteen is of mixed internal and exterior type. For a mixed set the pair attached
  to an internal point is a conjugate pair over the quadratic extension, the cross-ratio criterion
  survives, but the Paley-graph counting at the heart of their proof does not, since it is a count
  in the rational Paley graph.
- Even in the exterior-only case the bound it gives is `(q+1)/2 − 1`, that is, six at order thirteen
  but eight at order seventeen and nine at order nineteen. It reproduces the order-thirteen bound
  for exterior arcs and nothing sharper at the other two orders.

Their own final remarks are worth recording for the record: for `q ≡ 3 (mod 4)` nonlinear complete
exterior sets exist at orders seven, eleven, nineteen, twenty-three, twenty-seven, and thirty-one,
including the order-eleven six-arc — which is the Clebsch hexagon — and an order-thirty-one
configuration of a six-arc together with a ten-set carrying Petersen-graph structure. They state
that no further examples exist for orders forty-three through one hundred thirty-one and conjecture
that the linear ones are the only complete exterior sets beyond order thirty-one, adding that they
have no idea how to prove it. So the exterior-set classification is itself an open problem in the
regime the target would need.

### Verdict on Target 1

**Structurally blocked, with the blocker stated precisely: the maximum-passant-arc-size-six
statement is not uniform in the order — it fails at order twenty-three, where eight-point passant
arcs exist — so the requested uniform extension of the exterior-set/weight-eight argument cannot
exist.** The order-thirteen exclusion rests on the numerical coincidence that seven chords exactly
saturate the `(q+1)/2 = 7` passants through an internal point, that is, on `q = 2k − 3` with `k = 8`;
at orders seventeen and nineteen the pencils are unsaturated by two and three passants, exterior
vertices become admissible, and the Segre tangent product stops being a function of the conic, so
neither the weight-eight codeword step nor the five-row unique-closure clique mechanism has a
counterpart to generalize to.

Consequences for the C855 plan, in the memo's own terms:

- Family 2 is **not** deleted, and the fallback compressed checker of the memo is the correct route.
  The memo's ranking, which put this attempt first and the order-nineteen checker leaf third, should
  now advance the checker prototype to first place.
- The memo's compression A is confirmed independently: the search reports zero arcs of size seven at
  all three orders, so terminating the enumeration at level six is sound and no level-seven search is
  needed. Compression B, orbit completeness at levels two through six, remains the irreducible core.
- The Blokhuis–Seress–Wilbrink theorem yields no usable saving for the checker. At orders thirteen
  and seventeen, both `1 (mod 4)`, it bounds all-exterior passant arcs by `(q+1)/2 − 1`, that is by
  six and eight, which never bites below level six and says nothing about the mixed-type
  configurations that the search shows are the real content. It should be cited in the companion as
  context for the exterior-set terminology, not as a step in a proof.
- The acceptance-bar contingency the memo flagged is now live: `thm:small-k-conic-filling` at orders
  seventeen and nineteen will rest on a checker, so the go/no-go elaboration measurement for the
  order-nineteen root-edge leaf is the next decision point.

### Independent replay by-product

The search used here is a bitmask depth-first enumeration in increasing point order with no group
action, no canonical keys, and no orbit structure — a different program shape from all three
existing replays. Its arc counts at orders thirteen, seventeen, and nineteen agree exactly, size by
size, with the `labelled_arcs_by_size` figures recorded in the scoping memo for the root-edge orbit
DAG certificate: `[7098, 71526, 123123, 15288, 546]`, `[20808, 390048, 1555296, 913104, 50184]`, and
`[32490, 782325, 4301220, 3962412, 395124]`. That is a fourth independent replay of the certificate's
labelled domain, obtained for free. Script and replay command:

```
python3 notes/2026-08-03-c855-passant-arc-search.py 11 13 17 19 23
```

## Mystery ledger

- *Why does the maximum jump from six to eight between orders nineteen and twenty-three?* Settled
  only as an observation. The exhaustive counts show a smooth growth in the number of five- and
  six-arcs and then a sudden appearance of seven- and eight-arcs. Nothing in the counting or
  character-sum bounds available here predicts the threshold. Owning successor: none allocated; this
  is the sharpest open question the target raised, and it is also essentially the regime of
  Blokhuis, Seress, and Wilbrink's own open conjecture.
- *Why is the concurrence-type spectrum of six-arcs order-independent while the passant-arc maximum
  is not?* Settled by the Target 2 theorem: the concurrence spectrum is forced by two facts, Fano's
  axiom and the double-perspective identity, that are properties of the field rather than of its
  size. The passant condition, by contrast, is a quadratic-residue condition whose combinatorics
  genuinely depend on the order.
- *Does the class partition `3+3` fail to occur at orders eleven and seventeen for a reason?* Open.
  The type is realized at seven, thirteen, and nineteen but not eleven or seventeen, with no pattern
  modulo four visible. Evidence gap: no argument attempted; the theorem bounds which types are
  possible, not which are realized. Recording only, as descriptive census data.
- *Is the equality case of Dye's bound a single projective orbit?* Open and now isolated. The
  structural proof above gives the bound and the one-factorization structure at equality; the
  remaining orbit-uniqueness clause is the only part of that Dye axiom still unproved here.

## What this record does not establish

No Lean file was read for edit, no Lean build, generator, gate, or manifest was run, and no
manuscript was changed. The Target 2 theorem is a paper-grade human proof but has not been
formalized, and the manuscript and companion still state `thm:gap` and Dye's bound in their
certificate-backed form. The Target 1 finding is a negative result about proof strategy; it does not
affect the correctness of `thm:small-k-conic-filling`, whose orders-seventeen-and-nineteen clause the
search here independently confirms.
