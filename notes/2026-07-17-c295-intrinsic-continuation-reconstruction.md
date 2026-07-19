# C295: intrinsic continuation reconstruction

**Lane:** `crowns`

**Verdict:** `THEOREM; STABLE FRAME FULL-FAITHFULNESS AND EXACT q=11 TWO-SHEET RECOVERY`

## Main result

C272's four-frame theorem upgrades from automorphism equality to an explicit
reconstruction statement.

**Stable-frame reconstruction theorem.** Let `K` and `J` be projective frames
in `PG(2,q)` and `PG(2,q')`, with `q,q'>=13`. From the abstract uncoloured
continuation graph `G_K` one can recover:

1. `q`, from `|V(G_K)|=(q-2)(q-3)`;
2. the tangent traces, as the maximal cliques of size greater than `9`;
3. their four selected-centre classes, as the maximal cliques of size greater
   than `4` in the trace-disjointness graph;
4. the four-coordinate incidence word of every continuation vertex; and
5. the standard Desarguesian plane, frame, and associated projective-column
   code up to semilinear/monomial equivalence.

Moreover, every graph isomorphism `G_K -> G_J` forces `q=q'` and extends
uniquely to a semilinear collineation carrying `K` to `J`.

The last assertion is not an automorphism-group paraphrase. Vertex count first
recovers the field order. A projectivity identifies `J` with `K`; composing it
with the supplied graph isomorphism gives an automorphism of `G_K`, to which
C272 applies. Conversely every semilinear frame equivalence induces a graph
isomorphism. Thus the continuation-graph construction is fully faithful on the
groupoid of Desarguesian four-point frames in the stable range. A concrete
recovery algorithm outputs the canonical `PG(2,q)` and standard frame and then
uses the recovered trace/centre predicates to transport the input graph into
the four-coordinate model. The punctured and shifted isotopy lemmas make the
transport unique up to `S_4` and Frobenius.

This proves the promised geometry/code reconstruction for the N1 object class.
It uses C272 read-only and neither widens its range nor edits its manuscript.
The associated code statement is only projective-column/code equivalence; no
game value is inferred.

## The q=11 Clebsch pilot

Take the six Clebsch parity-check columns and their twelve projective deep-hole
directions, the points of the standard conic in `PG(2,11)`. A pair of directions
is joined when its line contains one of the six selected columns. With the C272
edge convention this is the **conflict graph**.

Each selected column gives five disjoint conflict edges and has two tangent
ports. The six blocks partition the graph's thirty edges, while the six port
pairs partition the twelve vertices. Direct incidence gives a 5-regular graph
with distance-regular intersection array

```text
{5,2,1;1,2,5},
```

hence the icosahedron graph. Its six port pairs are exactly its six antipodal
pairs and are therefore intrinsic.

Call a graph-only decomposition **admissible** when it partitions the thirty
edges into six five-edge matchings, one omitting each antipodal pair. Exact
enumeration gives:

| quantity | exact value |
|---|---:|
| all five-edge matchings, with arbitrary two ports | 1,482 |
| five-edge matchings with antipodal ports | 132 |
| admissible six-block decompositions | 636 |
| `Aut(G)` | 120 |
| decomposition orbits under `Aut(G)` | 12 |
| orbit sizes | `2,12,24,24,24,30,40,60,60,120,120,120` |

The geometric Clebsch decomposition lies in the unique orbit of size two. Its
stabilizer has order `60`, exactly the projective `A5` stabilizer. Consequently
the uncoloured graph canonically recovers an **unordered two-sheet set** of
matching/port decompositions. It cannot select one sheet: the other half of the
icosahedral automorphism group exchanges them. This is the exact intrinsic
boundary, not a generic appeal to symmetry.

In the fixed standard conic coordinates, the six chords in a candidate block
may be tested for concurrence. Among all 636 admissible decompositions, the
numbers having respectively `0,1,2,6` concurrent blocks are

```text
488, 132, 15, 1.
```

The sole fully concurrent decomposition is the displayed Clebsch one and
recovers its six centres. This coordinate test selects a sheet because the
fixed conic embedding supplies structure that the uncoloured graph forgot.
Intrinsically, the correct output remains the canonical two-sheet orbit; either
sheet gives the same promised unmarked Clebsch code class.

## Exact WL dimension

The q=11 uncoloured continuation graph has Weisfeiler--Leman dimension exactly
two.

- One-dimensional WL fails: the icosahedron and `K_(6,6)` minus a perfect
  matching are nonisomorphic 5-regular graphs on twelve vertices, so colour
  refinement leaves one vertex colour on both.
- Stable two-dimensional WL on the icosahedron has exactly the four ordered-pair
  colours given by distances `0,1,2,3` and recovers the displayed intersection
  array. That array identifies the graph. Around a vertex, the two five-point
  distance layers are 2-regular and hence 5-cycles, and the final layer is one
  antipode. Each second-layer vertex is indexed by its two adjacent neighbours
  in the first 5-cycle; adjacent first-layer pairs have exactly one such
  second-layer common neighbour. The second 5-cycle is then forced to be the
  line graph of the first. This reconstructs the icosahedron uniquely.

Thus `2` is both an upper and a lower bound. This exact claim is only for the
q=11 graph; no field-uniform WL dimension is asserted.

## C339 simultaneous-extension interface

The twelve vertices are exactly the admissible one-column MDS extensions of
the Clebsch `[6,3,4]_11` projective code. Since a nonsingular conic has no
collinear triple, a subset of these directions extends the six-arc precisely
when it contains no conflict edge. Therefore the simultaneous-extension
complex is the independence complex of `G`, equivalently the clique complex of
its complement. Its exact face counts by cardinality are

```text
size 0: 1
size 1: 12
size 2: 36
size 3: 20
```

and no face has size four. This corrects the convention-sensitive shorthand
“clique complex of the continuation graph”: with C272's conflict-edge
convention it is the **independence** complex. Separately, the linear code
generated by all twelve conic directions is the `[12,3,10]_11` extended GRS
deep-hole transform recorded by the C339 Stage-A specification. The face
complex classifies simultaneous column extensions; it does not say that all
twelve columns can be adjoined to the source MDS code at once.

## Reproduction and trusted boundary

Run from the repository root:

```text
python3 notes/2026-07-17-c295-intrinsic-continuation-reconstruction.py --check
python3 notes/2026-07-17-c295-intrinsic-continuation-reconstruction-replay.py
sha256sum -c notes/2026-07-17-c295-intrinsic-continuation-reconstruction.sha256
```

The main checker constructs all 133 points of `PG(2,11)`, the conic, the six
Clebsch matching blocks, the uncoloured graph, all admissible decompositions,
its full automorphism group, orbit decomposition, concurrency census, face
complex, and canonical JSON. It uses only Python's standard library.

The independent replay parameterizes the conic directly, generates candidate
blocks by all five-edge combinations rather than recursive matching extension,
counts exact covers one antipodal port pair at a time, and checks a SHA-256 root
of the complete canonical 636-decomposition set. It independently computes
the stable 2-WL colours, intersection array, one-WL foil, and face complex. The
checksum manifest records hashes and byte counts for both programs and the
JSON certificate.

The finite checker proves the stated q=11 census. The stable `q>=13` theorem is
a conventional deduction from the committed C272 proof, not a computational
extrapolation. No novelty is claimed for the icosahedron, its classical
distance-regular description, or its independence polynomial. The new
program-facing content is the full-faithfulness corollary, the exact two-sheet
matching-recovery boundary, and the convention-correct C339 interface.

## Handoff

C295 clears Crown II for the four-frame stable class and closes its bounded
q=11 pilot with a sharp two-sheet result. It does not clear C296 by itself:
Crown III still requires a value theorem on the same reconstructed object
class that actually consumes this recovered data.
