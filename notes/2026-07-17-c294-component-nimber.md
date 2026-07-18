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
- For `rho=2` or `rho=3`, iterated leaf removal gives the unique two-core. Suppressing its
  degree-two paths gives a cubic multigraph on respectively two or four branch vertices. The
  canonical key records the rooted forest at every core vertex and the ordered attachment word on
  every suppressed path, minimized over all branch-vertex permutations and path reversals.

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
758 connected absolute masks. The new solver visits 114 uncached absolute masks and uses 16 tree,
39 unicyclic, and 30 rank-two/three canonical shapes. Thus the root again has its required sole
option nimber `1` and root value zero.

On the hard type-0 `(2,4,5)` `PGL2(5)` follower, a deterministic 100,000-state cap does not return
a value. The first 100,019 uncached connected masks have cycle-rank histogram

```text
rho 0..9: 1853, 12675, 25998, 28057, 20890, 8154, 2035, 314, 28, 2
```

with 15 additional masks at larger ranks. Hence 68,583/100,019 uncached masks have `rho<=3`, and
89,473/100,019 have `rho<=4`. The implemented quotient records 54,055 rank-two/three shapes and
serves 1,436,003 rank-two/three cache hits, in addition to 499,638 tree and 1,231,338 unicyclic
hits. It stops at the first unseen 30-vertex connected state.

This is positive evidence that the recursion produces many repeated low-cycle boundary pieces,
but it is not yet compression of the hard connected core: every first-seen rank-at-most-three mask
in this traversal has a new canonical shape. A naive rank-four extension that serialized all
`6!` branch permutations was also rejected as an implementation route after exceeding the bounded
pilot window; it produced no tracked result and supports no mathematical negative claim.

## Boundary and next theorem

The computation does not determine any hard `PGL2(5)` value, certify that cycle rank stays bounded,
or prove a finite quotient for the full scar. It shows that exact component isomorphism is a useful
composition kernel but is not itself the missing contextual congruence.

The next kernel should retain this verified component layer and add a compact rank-four/core
representation using interned rooted-tree and skeleton IDs rather than factorial string
serialization. Its falsification test is sharp: either it returns an exact hard follower value or
it must report whether repeated canonical core shapes continue to dominate before another state-cap
increase is considered. No larger generic K-set cap is justified by this result.

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
| `2026-07-17-c294-component-nimber.cpp` | 21,143 | `970c192eff7256cb2fa8f81068f2fa3973446fb846a7341dc4f69287b0253dba` |
| `2026-07-17-c294-component-nimber-q3.json` | 509 | `24d2575f19852c8073bafe5c42f1d60a4487e86b4a1556d1ac28dde79583d418` |
| `2026-07-17-c294-component-nimber-q5-bounded.json` | 565 | `8b4c19c60f95ae8049cfe09e4b68e470e25fdddf0b3375c07868717381f042af` |

