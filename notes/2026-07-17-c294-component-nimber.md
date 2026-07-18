# C294 component nimber algebra: an exact low-cycle quotient

**Date:** 2026-07-18  
**Lane:** `crowns`  
**Status:** exact composition theorem and bounded feasibility gate. The direct `PGL2(3)` follower
nimber is independently recovered; the first hard `PGL2(5)` follower remains unevaluated.

## Exact composition theorem

Every residual of the three-generator Cayley graphs has maximum degree at most three. For a
connected residual `X`, let

```text
rho(X) = |E(X)| - |V(X)| + 1
```

be its cycle rank. The checker implements the following exact canonical quotient.

- Paths and cycles use the ordinary Node--Kayles recurrences. A move in `P_n` leaves two paths,
  so its option value is `g(P_a) xor g(P_b)`; a move in `C_n` leaves `P_(n-3)`.
- Trees use the AHU rooted-tree code at their one or two centres.
- A unicyclic graph uses the dihedral canonical word of the rooted trees attached to its unique
  cycle.
- For `2<=rho<=4`, iterated leaf removal gives the unique two-core. Suppressing its
  degree-two paths gives a cubic multigraph on respectively two, four, or six branch vertices. The
  canonical key records the rooted forest at every core vertex and the ordered attachment word on
  every suppressed path. The implementation first canonicalizes the tiny cubic-multigraph topology,
  interns exact rooted-forest labels, and minimizes attachment data only over the topology's
  canonical labelings and path reversals.

For maximum-degree-three connected graphs in these four classes, two keys agree if and only if the
graphs are isomorphic. The forward direction follows because leaf pruning, the two-core, and path
suppression are intrinsic. The recorded rooted forests and oriented path words reconstruct the
original graph; minimization removes exactly branch relabelling and undirected path orientation.
The converse is immediate from invariance of each construction.

Node--Kayles Grundy value is invariant under graph isomorphism, and disjoint union is nimber xor.
It is therefore exact to evaluate one representative of each key and reuse its nimber in every
absolute location. This is a game-aware composition law, not a heuristic pruning rule.

## Finite results

On the direct `(2,3,4)` `PGL2(3)` follower the component solver returns nimber `1`. This agrees
with both independent connected-K-set engines in the predecessor exact-value gate, which visited
758 connected absolute masks. The new solver visits 104 uncached absolute masks and uses 16 tree,
39 unicyclic, and 40 rank-two/three/four canonical shapes. Thus the root again has its required sole
option nimber `1` and root value zero.

On the hard type-0 `(2,4,5)` `PGL2(5)` follower, a deterministic 100,000-state cap does not return
a value. The first 100,018 uncached connected masks have cycle-rank histogram

```text
rho 0..9: 1853, 12743, 26429, 28923, 18934, 8606, 2156, 331, 28, 2
```

with 15 additional masks at larger ranks. Hence 69,948/100,018 uncached masks have `rho<=3`, and
88,882/100,018 have `rho<=4`. The implemented quotient records 74,285 completed rank-two/three/four
shapes and serves 1,644,303 low-cycle cache hits, in addition to 500,265 tree and 1,230,438
unicyclic hits. It stops at the first unseen 26-vertex connected state.

This is positive evidence that the recursion produces many repeated low-cycle boundary pieces,
but it is not yet compression of the hard connected core. The 96 labelled low-cycle skeletons
collapse to only seven cubic-multigraph topology classes, while the attachment words still produce
74,285 completed exact shapes. Thus topology reuse is strong and exact attached-graph reuse among
first-seen states is negligible. A preliminary rank-four serializer that rebuilt strings across all
`6!` branch permutations exceeded the bounded pilot window; the tracked topology-first interning
kernel supersedes it and supports the displayed exact result.

## Boundary and next theorem

The computation does not determine any hard `PGL2(5)` value, certify that cycle rank stays bounded,
or prove a finite quotient for the full scar. It shows that exact component isomorphism is a useful
composition kernel but is not itself the missing contextual congruence.

### Lean certificate shape

The structural theorem should not intrinsically produce a large Lean proof tree. A reusable
formalization can separate four small generic lemmas: Grundy value is invariant under graph
isomorphism; disjoint union is nimber xor; the displayed canonical decompositions reconstruct their
connected graphs; and equal canonical keys therefore have equal Grundy values. Lean can then check
canonical keys and reconstruction witnesses without unfolding the full Node--Kayles game tree. The
direct `PGL2(3)` instance should likewise admit a small finite certificate.

The bounded `PGL2(5)` search has a different certificate risk. Its first 100,018 uncached connected
masks already produce 74,285 completed rank-two/three/four shapes. Translating the recursion literally
would create a large proof tree or table. If an exact value is eventually returned, the appropriate
architecture is a compact externally generated DAG/certificate plus a small Lean checker built on
the generic structural lemmas. No such q=5 value certificate exists yet, because the present run
stops before evaluating the follower.

### Generalization in `q`

The decomposition theorem itself is independent of `q`: it applies to every maximum-degree-three
graph, hence to residuals of every three-generator Cayley scar in this family. Its usefulness is
not yet uniform in `q`. Nothing here proves bounded cycle rank, finitely many canonical core types,
eventual periodicity, or a bounded contextual interface as the field grows. The connected scar's
cycle rank can grow with the graph, while the current kernel compresses only low-cycle pieces that
split away from it.

Thus the q=5 cache-hit counts are evidence that low-cycle debris recurs heavily, not an asymptotic
or silver theorem. The missing q-general result is a bounded contextual interface or transfer law
for the growing high-cycle core; further formalization of the low-cycle quotient alone cannot
supply it.

The next theorem should retain this verified component layer but quotient the attachment words by
actual P/N or nimber context rather than exact graph isomorphism. The seven topology classes are a
small skeleton on which to test such a congruence. Its falsification test is sharp: equal proposed
attachment signatures must survive direct nimber gluing tests on the q=3 base and bounded q=5
followers before another state-cap increase is considered. No larger generic K-set cap is justified
by this result.

## Replay and trusted boundary

From `/home/tavis/src/othello`:

```sh
g++ -O3 -std=c++20 -Wall -Wextra -Werror \
  notes/2026-07-17-c294-component-nimber.cpp -o /tmp/c294-component-nimber
python3 notes/2026-07-17-c294-exact-value-gate.py --q 3 --type 0 --emit-graph \
  | /tmp/c294-component-nimber 1000000 /tmp/c294-component-nimber-q3.json
cmp /tmp/c294-component-nimber-q3.json \
  notes/2026-07-17-c294-component-nimber-q3.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | /tmp/c294-component-nimber 100000 /tmp/c294-component-nimber-q5.json
cmp /tmp/c294-component-nimber-q5.json \
  notes/2026-07-17-c294-component-nimber-q5-bounded.json
sha256sum -c notes/2026-07-17-c294-component-nimber.sha256
```

The graph generator and conventions are inherited unchanged from the pinned recursive-mirror and
mixed-scar checkers: lexicographically ordered permutations of `P1(q)`, edges `h--s*h`, and closed
neighbourhood deletion. Enumeration is deterministic and has no random seed. The trusted boundary
is the prime-field graph generator, component splitting, mex/xor recursion, leaf pruning, rooted
tree coding, and cycle-skeleton canonicalization. The independent check is the predecessor Python
and C++ q=3 result. No independent q=5 value check exists because this bounded run returns none.

| Artifact | Bytes | SHA-256 |
|:--|--:|:--|
| `2026-07-17-c294-component-nimber.cpp` | 25,834 | `5135aa81ce33f4551bab5ba5f17209e1204f642d0ce967bfed260942b8fc2fd7` |
| `2026-07-17-c294-component-nimber-q3.json` | 565 | `fe9c46f01f38613024df7cb3063005bb0a596cd2a84a6b7333b77d41a182f87f` |
| `2026-07-17-c294-component-nimber-q5-bounded.json` | 621 | `46d1363bdae4bb0739e6bf9bd6aa3f069499da17100dce455521949761596362` |
