# Reconstructing projective frames from their continuation graphs

Tavis Rudd — first draft, September 2026.

## Read the paper

[**Open the paper (PDF) →**](continuation_graph_rigidity.pdf)

Choose four points in a finite projective plane, with no three on a line.
Keep the points that can be added without creating a collinear triple, and
join two of them when they cannot both be added. Now erase the plane, the
chosen points, and all labels. Can the remaining graph recover the geometry?

The paper answers this question for four-point projective frames over finite
fields of order at least 13. The graph determines the field order and the
plane with its frame, up to semilinear equivalence. Every graph isomorphism
extends uniquely to an equivalence of the underlying planes carrying one
frame to the other.

## Main result

Let `K` be a projective frame in `PG(2,q)`, where `q = p^e ≥ 13`. Its
**continuation graph** `G_K` has one vertex for each point that can be added
to `K` while preserving the no-three-collinear condition. Two vertices are
adjacent when they cannot both be added.

As permutation groups on these vertices,

```text
Aut(G_K) = Stab_{PΓL(3,q)}(K),        |Aut(G_K)| = 24e.
```

Here `PΓL(3,q)` consists of projective linear transformations together with
field automorphisms; the stabilizer may permute the four frame points.
The factor 24 comes from those permutations, and the factor `e` from the
field automorphisms.

The extension statement controls each individual graph isomorphism. It also
leads to a polynomial-time recognition algorithm: given an arbitrary graph
and a finite field of order at least 13, the algorithm either rejects or
returns coordinates that certify a frame-graph representation.

## How the graph recovers the geometry

A tangent is a line meeting the frame in exactly one point. Its legal
continuation points form a clique, called its **tangent trace**. The proof
recovers the information lost when those cliques became unlabelled edges:

1. **Recover the traces.** Tangent traces have `q−3` vertices. For `q ≥ 13`,
   a clique spread across several tangents is smaller, so the graph identifies
   the traces by their size.
2. **Recover the four classes.** Traces through the same frame point partition
   the vertices. A second clique argument, now using disjointness of traces,
   recovers these four partitions.
3. **Recover the field action.** In suitable coordinates the vertices are
   pairs `(x,y)` with `x,y ∉ {0,1}` and `x ≠ y`, represented by the words

   ```text
   (x, y, x/y, (x−1)/(y−1)).
   ```

   Adjacency means equality in one coordinate position. Preserving the four
   recovered partitions forces compatible permutations of these coordinate
   values; the two quotient expressions force a single field automorphism.

For example, over `F_13`, the points `(2,3)` and `(2,4)` give the words
`(2,3,5,7)` and `(2,4,7,9)`. Their first coordinates agree, so they are
adjacent. The reconstruction recovers the coordinate positions from adjacency
alone. This also describes the graph as a length-four nonlinear code: distinct
words have Hamming distance three when adjacent and four otherwise.

## Small fields

An exact finite census settles the remaining orders studied in the paper:

| Field order | Resolutions into four parallel classes | Graph symmetries |
|---|---:|---|
| 5, 8 | 2 | The semilinear subgroup has index two |
| 7, 9, 11 | 1 | Every automorphism is semilinear |

A parallel class partitions the graph's vertices into `q−2` cliques of size
`q−3`. A resolution consists of four such classes whose clique edges partition
all graph edges. At order 5, the two resolutions use the same cliques but group
them differently; at order 8, they share no cliques. These exceptions show
where the graph fails to distinguish the original geometric resolution.

## Proof and evidence boundary

The uniform theorem for `q ≥ 13` and the recognition algorithm are proved in
the manuscript independently of the finite census. No theorem is claimed to
be Lean-formalized.

The small-order results are exact computations. Sage constructs the graphs
from incidence; a separate Python implementation constructs them from
coordinate equality and uses nauty to check full automorphism-group orders.
Both enumerate the resolutions to exhaustion. The two routes share the
exact-cover recursion. The certificate records the resolutions, group
generators, and exceptional automorphisms. See the
[verification guide](verification/README.md) for the precise trust boundary.

## Recognition software

[`verification/recognize.py`](verification/recognize.py) implements the
reconstruction and returns a coordinate certificate. Checking the certificate
requires comparing every pair of vertices, independently of the search that
found it. The paper gives an `O(n^6)` recognition bound and an `O(n²)`
certificate check for a graph with `n` vertices over a supplied field.

The reference recognizer is tested on relabelled graphs at orders 13, 17 and
19, together with corrupted coordinates and edges. Its implemented field
models do not cover all extension fields allowed by the theorem. The recorded
prototype is slower than the generic graph-isomorphism control at these three
orders; it demonstrates reconstruction rather than a performance advantage.

## Verification

With Nix installed, run from this directory:

```sh
nix develop --command make check
nix develop --command python3 verification/check_manuscript_build.py
```

The first command checks statement and artifact integrity, replays the finite
census, and tests recognition and certificate rejection. The second builds the
manuscript twice and requires both builds to match the tracked PDF.

To refresh the PDF after a manuscript edit, use
`nix develop --command make pdf`. To regenerate and compare the finite census,
use `make boundary`. Full commands, field encodings, toolchain details and
benchmark instructions are in the [verification guide](verification/README.md).

## Files

- [Manuscript PDF](continuation_graph_rigidity.pdf) and
  [LaTeX source](continuation_graph_rigidity.tex).
- [`verification/`](verification/) contains the recognizer, exact census,
  independent replay, tests, benchmarks, and claim/evidence maps.
- `flake.nix` and `flake.lock` specify the reproducible development environment.
- [`CITATION.cff`](CITATION.cff) and `.zenodo.json` contain citation and deposit
  metadata.

## Scope and citation

The reconstruction theorem concerns four-point frames in Desarguesian planes.
Larger arcs and reconstruction of the full continuation complex remain outside
its scope. The graph records pairwise incompatibility; it does not by itself
assert that every independent set can be adjoined simultaneously.

This is a first draft. Citation metadata is provided in
[`CITATION.cff`](CITATION.cff); no DOI is assigned in that metadata.
The repository is `tavisrudd/continuation-graph-rigidity` on GitHub.

## License

The manuscript is licensed under the Creative Commons Attribution 4.0
International License (CC BY 4.0); see [LICENSE](LICENSE). The accompanying
software is separately licensed under the [MIT License](LICENSE-MIT).
