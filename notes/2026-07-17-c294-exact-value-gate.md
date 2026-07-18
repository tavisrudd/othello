# C294 exact-value gate: four-ply pairing closure fails before the value frontier

**Date:** 2026-07-18
**Lane:** `crowns`
**Status:** exact bounded pairing obstruction and exact-solver feasibility gate. The seven hard
`PGL2(5)` root values remain unknown.

## Finite obstruction

For each of the seven mixed `PGL2(5)` conjugacy types with no two-ply pairing certificate, fix the
canonical 116-vertex follower obtained by playing the identity in its regular Cayley graph. Exhaust
every residual mask reachable by at most three further legal moves. None of those residual graphs
has a fixed-point-free nonadjacent involutory abstract graph automorphism.

| type | determinant classes | pair orders | distinct residual masks tested | paired masks |
|---:|:---:|:---:|---:|---:|
| 0 | `001` | `(2,4,5)` | 240,750 | 0 |
| 1 | `001` | `(2,5,6)` | 240,750 | 0 |
| 2 | `001` | `(4,5,6)` | 240,918 | 0 |
| 3 | `001` | `(4,5,6)` | 240,918 | 0 |
| 7 | `001` | `(3,4,6)` | 240,918 | 0 |
| 9 | `011` | `(2,4,6)` | 240,750 | 0 |
| 11 | `011` | `(3,4,6)` | 240,918 | 0 |

The union has 1,685,922 distinct type-labelled masks. The recursion also reuses 3,325,904
previously classified state-depth pairs. The displayed counts include the follower itself and all
residuals at distances one, two, and three; masks are counted separately in different group types.

Consequently no hard follower has a **four-ply pairing certificate**: there is no first reply for
which every counter-move has a response landing in an involutively paired P-position. This is
strictly stronger than the predecessor's two-ply obstruction, and it is uniform across all seven
mandatory types. It does not rule out a deeper history-dependent strategy or determine any
follower's P/N outcome.

Two separately organized exact pairing kernels reproduce the census. The primary kernel builds
involution pairs while checking adjacency compatibility against assigned pairs. The independent
kernel assigns paired images and rechecks the full induced adjacency matrix after every extension.
Both begin with the same stable one-dimensional Weisfeiler--Leman partition, but their
backtracking state and compatibility predicates are distinct. Every positive witness would be
rechecked as a permutation, involution, fixed-point-free nonadjacent map, and automorphism; the
census contains no positive witness.

## Connected-K-set solver gate

The second experiment implements the exact connected-component nimber recursion of
Bodlaender--Kratsch--Timmer, [*Exact algorithms for Kayles*](https://doi.org/10.1016/j.tcs.2014.09.042).
For a connected residual `W`, it memoizes its nimber; after a move it splits the residual into
connected components and xors their independently computed nimbers. This visits only connected
Kayles sets rather than all induced subgraphs, but its general upper bound remains exponential.

The Python reference and an independently written C++ bit-mask engine agree exactly on the direct
`PGL2(3)` control:

| case | follower nimber | connected states | cache hits | component decompositions |
|:--|--:|--:|--:|--:|
| `(2,3,4)` `PGL2(3)`, after identity | `1` | 758 | 9,809 | 3,413 |

This independently recovers the predecessor fact needed for root value zero: the vertex-transitive
root has the single nonzero follower option value.

On the hard `(2,4,5)` `PGL2(5)` follower, both engines agree on the first 100,000 cached connected
states: 5,701,081 cache hits and 1,838,251 component decompositions before the fixed state cap.
The optimized engine then reaches a cap of ten million cached connected states, with 726,417,826
cache hits and 240,891,510 component decompositions; the first unseen state at the cap has 42 live
vertices. It still has not returned a follower nimber. This is a bounded stop result, not evidence
of a lower bound or intractability. In particular, the ten-million-state run certifies no game
value.

The combined message is sharp. Pairing restoration does not appear anywhere in the complete
four-ply neighbourhood, while the best general exact recursion spends ten million connected states
below the 42-vertex frontier without evaluating the 116-vertex follower. The next attack must use
game-aware structure before generic recursion: an actual P/N congruence, a causal history matching,
or a proved boundary composition rule. Enlarging either the pairing depth or the unstructured
K-set cap is not the next theorem mechanism.

## Scope and trusted boundary

The group and Cayley graphs are reconstructed from the pinned
`2026-07-17-c294-mixed-scar-obstruction.py` and
`2026-07-17-c294-recursive-defective-mirror.py` kernels. Vertex indices are lexicographically
ordered permutations of `P1(q)`, edges are `h--s*h`, and a Node--Kayles move deletes its closed
neighbourhood. Enumeration is deterministic and uses no random seed.

The pairing theorem exhausts only residuals at distance at most three from the seven canonical
followers. The K-set cap covers only type 0, and only its deterministic depth-first prefix at the
stated cap. Neither computation classifies a hard `PGL2(5)` follower, proves periodicity or finite
contextual equivalence, or extrapolates to larger fields.

The trusted boundary is prime-field permutation arithmetic, regular Cayley adjacency, stable-colour
refinement, the two exact pairing searches, and the two connected-component/mex implementations.
Python is version 3.13.12; the optimized engine is compiled by GCC 14.3.0 with
`-O3 -std=c++20 -Wall -Wextra -Werror`.

## Evidence and replay

From `/home/tavis/src/othello`:

```sh
python3 notes/2026-07-17-c294-exact-value-gate.py \
  --hard-types --depth 3 --jobs 4 --kernel primary \
  --check notes/2026-07-17-c294-exact-value-gate-primary.json
python3 notes/2026-07-17-c294-exact-value-gate.py \
  --hard-types --depth 3 --jobs 4 --kernel independent \
  --check notes/2026-07-17-c294-exact-value-gate-independent.json
g++ -O3 -std=c++20 -Wall -Wextra -Werror \
  notes/2026-07-17-c294-kset-nimber.cpp -o /tmp/c294-kset-nimber
python3 notes/2026-07-17-c294-exact-value-gate.py --q 3 --type 0 --emit-graph \
  | /tmp/c294-kset-nimber 1000000 /tmp/c294-kset-q3.json
cmp /tmp/c294-kset-q3.json notes/2026-07-17-c294-kset-q3.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | /tmp/c294-kset-nimber 100000 /tmp/c294-kset-q5-100k.json
cmp /tmp/c294-kset-q5-100k.json notes/2026-07-17-c294-kset-q5-bounded-100k.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | /tmp/c294-kset-nimber 10000000 /tmp/c294-kset-q5-10m.json
cmp /tmp/c294-kset-q5-10m.json notes/2026-07-17-c294-kset-q5-bounded.json
sha256sum -c notes/2026-07-17-c294-exact-value-gate.sha256
```

The independent Python K-set outputs are
`2026-07-17-c294-kset-q3-independent.json` and
`2026-07-17-c294-kset-q5-independent-bounded.json`; the latter deliberately stops at 100,000
connected states. The checksum manifest records every load-bearing source and output.

| New artifact | Bytes | SHA-256 |
|:--|--:|:--|
| `2026-07-17-c294-exact-value-gate.py` | 8,482 | `e6b6f27152bc27aafa476ae4a96501b56de05a6511d78738ac08969cd1f9f23d` |
| `2026-07-17-c294-kset-nimber.cpp` | 5,556 | `b33f055c655b7ee6ec6f08317275f6a4b6a02e1c14ffa97e4f475b35f30efbe7` |
| `2026-07-17-c294-exact-value-gate-primary.json` | 2,847 | `d5fee41c4cab4598c81dae66cf9c2b9f3405a2f801063204100cb017ce984f82` |
| `2026-07-17-c294-exact-value-gate-independent.json` | 2,879 | `982df40b3ce1bea297e7fd8f8799fd308f9e6d95dd895b4d64e82b9d7b465d12` |
| `2026-07-17-c294-kset-q3.json` | 220 | `cf402ee30f4114d73c461283c39561c4695db51fcea0cb2a68288b4a6bd074c9` |
| `2026-07-17-c294-kset-q3-independent.json` | 290 | `2c0da2cbb3089c5ef23ac28ba4d2c8d8a50cbf7ebc19c2312e7909a659b8d533` |
| `2026-07-17-c294-kset-q5-bounded-100k.json` | 228 | `8fb42bc876f9425284b97ea5e659b9287d4aa832ad5c4d070eedbe6e8fc73335` |
| `2026-07-17-c294-kset-q5-independent-bounded.json` | 301 | `c1456c5ec9ad686ebc60a75413060618ff0bafdaea60949a592ac48a1b788659` |
| `2026-07-17-c294-kset-q5-bounded.json` | 236 | `1e1d0631aebad726f22fc35e047e9b9cef71974a9f1b9c5ccf5915413a2e2742` |

## Revised frontier

The seven exact values are still the mandatory C294 gate. Do not spend the next run extending the
pairing radius or raising the generic K-set cap. Use the exact q=3 values and bounded q=5 followers
to define a coarser game-aware interface whose composition law is proved locally; only then return
to the 116-vertex followers. Any candidate must pass all seven types, including the two
order-colliding `(4,5,6)` rows and the determinant-distinguished `(3,4,6)` rows.
