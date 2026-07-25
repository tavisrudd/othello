# C605 — eight-point conic-filling exclusion

**Lane**: `clebsch`

**Status**: complete.

## Result

Let \(A\) be an eight-arc in \(\mathrm{PG}(2,q)\). For each
\(q\in\{13,17,19\}\), its uncovered locus cannot be the rational point set of
a nonsingular conic. In fact, after fixing a conic, the largest arc all of
whose chords are passant has size six in each of the three planes. Thus the
necessary condition for conic filling already fails at seven points.

Together with Paper I's universal conic-filling window, this completes the
classification for \(4\le k\le8\):
\[
  \mathcal U(A)=\mathcal Q(\mathbb F_q)
  \quad\Longleftrightarrow\quad
  (k,q)=(4,5)\ \text{or}\ (6,11),
\]
with a projective four-frame in the first case and a Clebsch hexagon in the
second.

## Complete normalized domain

Projective equivalence sends the target conic to
\(\mathcal Q: XZ=Y^2\). Its stabilizer is the symmetric-square image of
\(\operatorname{PGL}(2,q)\), of order \(q(q^2-1)\). A conic-filling arc is
disjoint from \(\mathcal Q\), and each of its chords misses every point of
\(\mathcal Q\). Hence it is an arc in the graph on the \(q^2\) off-conic
points whose edges are passant joins.

The primary search partitions every passant edge into its full
\(\operatorname{PGL}(2,q)\)-orbit. For one root in each orbit it extends all
partial arcs, identifying states under the setwise root stabilizer by the
lexicographically least sorted point list. This loses no candidate: every
putative eight-arc contains a passant edge, that edge maps to one listed
root, and every remaining vertex occurs among that root's extensions.

The exact domain and outcome are:

| \(q\) | raw off-conic points | raw passant edges | normalized edge roots | rooted stabilizer states by size \(2,\ldots,8\) | maximum size | filling eight-arc orbits |
|---:|---:|---:|---:|---|---:|---:|
| 13 | 169 | 7,098 | 10 | \(10,117,390,80,7,0,0\) | 6 | 0 |
| 17 | 289 | 20,808 | 13 | \(13,272,2044,1928,185,0,0\) | 6 | 0 |
| 19 | 361 | 32,490 | 15 | \(15,385,3974,5922,964,0,0\) | 6 | 0 |

The state counts are exact rooted-stabilizer quotient counts; a partial arc
can occur under more than one edge root. The final raw, normalized, and
projective-orbit counts of filling eight-arcs are all zero because no
seven-point state exists.

The forced \(n_i\) spectra from the task brief are encoded in every field
certificate. The generator checks their nonnegativity ranges and all three
identities
\[
 \sum_i n_i=q^2-8,\qquad
 \sum_i i n_i=28(q-1),\qquad
 \sum_i\binom{i}{2}n_i=210.
\]
It uses \(n_i=0\) for \(i\ge5\) as a partial-search multiplicity cut and
requires the full forced spectrum at every terminal eight-arc. The stronger
six-point maximum means no branch reaches that terminal check; the spectra
are consistency checks and cuts, not evidence for exclusion.

## Independent replay and trust boundary

The primary C++17 implementation tests passancy by incidence with all
conic points, forms edge orbits by a disjoint-set computation over the full
group, and deduplicates partial arcs under root stabilizers. The independent
Python replay instead:

1. tests passancy from the nonsquare discriminant of the line--conic
   intersection;
2. verifies directly that the listed edge orbits are disjoint and cover
   every passant edge; and
3. performs ordered bitset backtracking without stabilizer deduplication.

It visits respectively \(1,549\), \(12,478\), and \(33,711\) rooted nodes
and independently returns maximum size six and zero filling-eight-arc
orbits. Its certificate includes an explicit maximum six-arc in every
field.

No Lean bridge was added. A finite Lean table would re-encode, rather than
narrow, the terminal search; the residual trust is the C++17 and Python
runtimes, exact prime-field arithmetic, and the coordinate-to-projective
geometry correspondence stated above.

## Reproducibility bundle

From `papers/clebsch-rigidity/`, run:

```text
python3 verification/c605_verify.py
```

The driver compiles the primary source with
`g++ -O3 -std=c++17 -Wall -Wextra -pedantic`, regenerates all three primary
certificates in a temporary directory, requires byte equality with the
tracked files, runs the independent replay, and requires byte equality with
its tracked certificate. The run is deterministic and uses no randomness or
third-party package. The recorded environment was GCC 14.3.0 and
Python 3.13.12.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `verification/c605_search.cpp` | 17,693 | `1981788662daf5317e219049b2f634cd75ef9c72099d13e0a8391f607006436d` |
| `verification/c605_replay.py` | 9,496 | `a589c89a3dd81e5ca1e7661fb85a6f6e18cf21da5d38eedc16260a4cea676a9a` |
| `verification/c605_verify.py` | 2,711 | `42649017b9607ad8f8a07f1647817a2e3d929277013790cbc6c4e357d70f3ae4` |
| `verification/c605_q13.json` | 3,572 | `da42b60be2d6c47018c8d5975409eade9c4cea9f2084f2dd5b7e276fd09daf8c` |
| `verification/c605_q17.json` | 4,546 | `378dbbfe987a66cb771607468f2d1e923f13c52a6426d201dad9ee1beeefae75` |
| `verification/c605_q19.json` | 5,182 | `739390f2e9e4c62155582ec0dee0c65bd5295a80ec380ba86f173eda492fa814` |
| `verification/c605_independent.json` | 774 | `d725286565da0283c64a5eab064bb736fb143c9b662ebf2973c3b4f09d15a870` |

The stop condition is exhaustion of every arc extension from every passant
edge orbit representative, after which no size-seven state remains.
The certificates prove only the stated three prime fields and fixed conic;
projective equivalence supplies the passage to every nonsingular conic in
each plane.

## Paper I disposition

Paper I now states the complete classification through eight points. Its
proof records the normalization, raw edge counts, orbit-root counts,
canonicalization contract, completeness argument, maximum-size result, and
independent replay. The verification table, nineteen-row statement identity,
trust manifest, checker-output certificate, PDF, and release runner include
the new computation. The manuscript is warning-free and now has 19 pages.

## Extra-juice and Tao-style closeout

The closeout pass strengthened the task-owned conclusion from “no filling
eight-arc” to the exact maximum-six statement, retained explicit maximum
witnesses, and made the forced moment spectra machine-checked even though the
search stops earlier. The natural structural question is now visible:
whether the common maximum six follows from a uniform orthogonal-geometry or
association-scheme argument rather than three finite searches. That question
does not affect the exclusion or Paper I's trust gate.

## Mystery ledger

- **Why is the maximum exactly six in all three fields?** Settled
  computationally for \(q=13,17,19\), with independent maximum witnesses and
  exhaustive exclusion of size seven. What remains open is a conceptual
  theorem explaining the common value, possibly through the conic
  stabilizer's coherent configuration. No successor is allocated; this is
  not an acceptance gap for C605 or a blocker for C182.
- **Forced spectra versus the stronger obstruction.** Settled: the spectra
  are valid and checked, but no candidate reaches size seven, so the
  pairwise-passant arc obstruction strictly precedes them. No unexplained
  certificate gap remains.
