# C878 — the aligned-faithfulness theorem is independent of the graph reconstruction result

**Date:** 2026-08-05
**Task:** C878
**Lane:** `clebsch`
**Status:** exact research bundle; no manuscript changed yet — this settles the gate on a manuscript correction

## Why this was run

C876 found that Clebsch III's benchmark sentence is wrong.  The manuscript says
the closest literature benchmark for its four-local two-graph reconstruction is
size **five**, for arbitrary three-uniform hypergraphs.  The real benchmark is
**four, from seven points**: Dammak, Lopez, Pouzet and Si Kaddour reconstruct
graphs up to complementation for \(4\le k\le v-3\), which at \(k=4\) reads
\(v\ge7\).  Both numbers coincide with ours.

C876 flagged the question that has to be answered before the sentence is
rewritten, and it is mathematics rather than literature: does an unwritten
reduction make our theorem a corollary of theirs, or do the two statements
merely carry the same two numbers?  This bundle answers it.

## The theorem and its sharpness, checked independently

Write a two-graph on \(V\) as \(\tau:\binom V3\to\mathbf F_2\) with every
four-set's four triples summing to zero, and let \(\mathcal A(\tau)\) be the
four-sets on which \(\tau\) is constant.  Enumerating the whole space of
two-graphs — it is an \(\mathbf F_2\)-space of dimension \(\binom{|V|-1}2\) —
and grouping by aligned family gives

| Points | Two-graphs | Aligned families | Class sizes | Determines up to complement |
|--------|------------|------------------|-------------|------------------------------|
| 5      | 64         | 17               | 2, 6, 12    | no                           |
| 6      | 1,024      | 462              | 2, 4, 12    | no                           |
| 7      | 32,768     | 16,384           | 2           | yes                          |
| 8      | 2,097,152  | 1,048,576        | 2           | yes                          |

At seven and eight points every fibre has size exactly two — the two-graph and
its complement, nothing else — and the map is exactly two-to-one.  At five and
six points fibres of size up to twelve occur.  Seven is sharp.

This is an independent confirmation of the manuscript's theorem by direct
enumeration, obtained without reference to its Lean proof.

## Independence from the graph theorem

The two hypotheses are incomparable, and ours is satisfied by pairs theirs
excludes.

Their hypothesis is graph four-hypomorphy: for every four-set, the induced
four-vertex subgraphs are isomorphic — one of eleven types, so roughly three and
a half bits per four-set, about a *graph*.  Ours is one bit per four-set,
derived from the *two-graph*: aligned or not.

The separating witness is immediate.  Take the empty graph on seven vertices and
the star obtained by switching at one vertex.  They lie in one switching class,
so they have the same two-graph and therefore the same aligned family — our
hypothesis holds.  Their induced four-vertex types differ on 20 of the 35
four-sets, so they are not four-hypomorphic and the graph theorem says nothing
about them.

Consequently the graph theorem cannot be restricted to yield the two-graph one.
The shared numbers four and seven are not evidence of a shared mechanism: their
seven comes from the structural range \(k\le v-3\), while ours is the point at
which the aligned family stops collapsing, and the table above shows that
collapse happening at six.

**Verdict: independent statement, not a corollary.**  The theorem stands as the
paper's own, and the revision is to the benchmark sentence and the attribution,
not to the result.

## What the manuscript must now say

Two corrections, both from C876 and both unblocked by the above.

1. **Benchmark.** Replace the size-five hypergraph sentence.  Name the graph
   result with its four and its seven, state that the size-five result concerns
   the strictly larger class of arbitrary three-uniform hypergraphs, and locate
   the contribution in the two-graph observable being coarser — one derived bit
   per four-set rather than an induced isomorphism type — with the independence
   above as the reason the two do not reduce to each other.  The paper's own
   ledger row `OPER-4` already records the graph result correctly, so the
   current sentence contradicts the paper's own evidence map.
2. **Attribution.** The hypothesis that the four triangle values on every
   four-set sum to zero *is* the definition of a two-graph, and what the proof
   calls the two-graph equation is the standard descendant correspondence
   between two-graphs and switching classes.  Both belong to Higman, Taylor and
   Seidel and are set out in Brouwer and Van Maldeghem § 1.1.12.  All are
   currently uncited.

## Evidence and replay

From `/home/tavis/src/othello`, run

```sh
python3 notes/2026-08-05-c878-aligned-faithfulness-independence.py --check
sha256sum -c notes/2026-08-05-c878-aligned-faithfulness-independence.sha256
```

The checker builds the two-graph space from the single-edge generators and
asserts its dimension, computes every aligned family by direct evaluation,
asserts that faithfulness holds exactly at seven points and above, and
constructs the switching witness, asserting that the two graphs share a
two-graph and an aligned family while differing in induced type.  Standard
library only, no randomness.

## Mystery ledger

- **Settled — the theorem and its sharpness**, by enumeration independent of the
  Lean proof.
- **Settled — independence from the graph result.**  Incomparable hypotheses
  with an explicit separating witness.
- **Open — the manuscript edit itself**, which is a released paper and needs a
  decision before any change is made.
- **Open — Seidel's 1976 survey and the 1981 Seidel–Taylor second survey**,
  neither obtainable and neither carrying a review.  They are exactly where a
  competing reconstruction theorem would sit, so C876's negative is bounded by
  them and they remain could-not-access rather than searched.
