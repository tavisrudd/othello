# C294 B3: cross-class-seeking live two-port selector

**Date:** 2026-07-18
**Lane:** `crowns`
**Status:** fixed-prefix contextual-hit gate passes; gain is too small for a ten-million-state run

## Result

The exact two-port transition quotient now reaches genuinely different exact piece classes during
the unchanged q=5 type-0 100,000-connected-state traversal. The selector scans only genuine
two-separator sides with at least eight internal core vertices and at most 16 expanded vertices.
It chooses a side when its unordered transition class matches a previously selected side with a
different exact piece key; otherwise it uses the complementary largest-side, greatest-key order.

Among 334,868 inspected eligible occurrences, the selector makes two cross-exact-class selections.
Both become `nonisomorphic_interface_hits` in the live interface table. The first is independently
replayed: the two pieces each have 16 vertices and nimber `2`, have equal complete two-port
transition records, and are not isomorphic with either fixed or swapped ports.

This clears the B3 card's requested new contextual-hit gate, but it is not material acceleration:

| metric | prior smallest-side selector | cross-class seeker |
|:--|--:|--:|
| connected states | 100,000 | 100,000 |
| decompositions | 1,941,400 | 1,941,396 |
| quotient classes | 84,903 | 84,903 |
| live new-absolute-key hits | 1,492 | 1,522 |
| different-exact-piece interface hits | 0 | 2 |
| interface states | 9,323 | 289,185 |
| follower nimber | not returned | not returned |

The selector therefore proves that the offline transition mergers are reachable by a live
decomposition, but spends about 31 times as many interface states for four fewer decompositions.
It does not justify the ten-million-state value run or evaluation of the other six hard types.

The q=3 control remains complete with follower nimber `1`, 105 connected states, 657
decompositions, and no cross-class selections.

## Exactness

Every emitted connected cache key is still one exact transition record paired with one exact
port-labelled context key. Equality of such keys is sound by the proved two-port replacement
theorem. The search used to choose which valid decomposition to encode cannot create an unsound
equality: it changes only the selected representative of the same whole position.

The predecessor source gained compile-time selector hooks and a main-function guard. With neither
hook defined, its q=3 and q=5 outputs remain byte-identical to the tracked predecessor artifacts.
The new driver defines the cross-class-seeking hook and otherwise reuses the checked live kernel.

## Independent replay

The first live cross-class witness is fed to the independently organized predecessor transition
replay. That replay reconstructs both pieces from the emitted graph, computes closed nimbers and
complete transition records with its own Python interner, and runs an explicit boundary-preserving
isomorphism search. It confirms equal interfaces, nimber `2` for both pieces, and non-isomorphism
under both port alignments. It does not independently reproduce the full 100,000-state traversal
or prove that either live context collides with another full cache key.

## Replay

From `/home/tavis/src/othello`:

```sh
g++ -O3 -std=c++20 -Wall -Wextra -Werror -fno-access-control \
  notes/2026-07-17-c294-b3-two-port-seeking-live.cpp \
  -o /tmp/c294-b3-two-port-seeking-live
python3 notes/2026-07-17-c294-exact-value-gate.py --q 3 --type 0 --emit-graph \
  | /tmp/c294-b3-two-port-seeking-live 1000000 1000000 /tmp/c294-seeking-q3.json
cmp /tmp/c294-seeking-q3.json \
  notes/2026-07-17-c294-b3-two-port-seeking-live-q3.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | /tmp/c294-b3-two-port-seeking-live 100000 1000000 /tmp/c294-seeking-q5.json
cmp /tmp/c294-seeking-q5.json \
  notes/2026-07-17-c294-b3-two-port-seeking-live-q5-100k.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | python3 notes/2026-07-17-c294-b3-two-port-transition-replay.py \
      notes/2026-07-17-c294-b3-two-port-seeking-live-q5-100k.json \
  > /tmp/c294-seeking-replay.json
cmp /tmp/c294-seeking-replay.json \
  notes/2026-07-17-c294-b3-two-port-seeking-live-replay.json
sha256sum -c notes/2026-07-17-c294-b3-two-port-seeking-live.sha256
```

Enumeration is deterministic and uses no random seed. Graph conventions remain lexicographically
ordered permutations of `P1(q)`, type-0 generators `(2,3,4)` at q=3 and `(2,4,5)` at q=5, edges
`h--s*h`, and closed-neighbourhood deletion. The q=5 game cap is exactly 100,000 connected states;
the independent interface cap is exactly one million combined boundary and closed states. The
tested compiler is GCC 14.3.0 and the replay uses Python 3.13.12.

## Trusted boundary and next gate

The primary trusted boundary is the predecessor graph generator, component/high-core kernels,
separator detection, exact transition interner, context canonicalizer, mex/xor recurrence, and
complete-vector equality. The independent replay shares the emitted graph and mathematical
transition definition, but not the primary interner or isomorphism search.

The next bounded design should make the two-port quotient participate recursively in a
multi-piece context representation, rather than choosing one whole-position cut. Require a
measured reduction in quotient classes or at least one full cache-key collision attributable to
different exact piece classes on this same prefix. Do not enlarge either cap before that gate.

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| `2026-07-17-c294-b3-two-port-live.cpp` | 23,183 | `f0c18e9f9bbbfeb00cc9b56c7612d58944b55289e45cc99bb2512967bd64cd1a` |
| `2026-07-17-c294-b3-two-port-seeking-live.cpp` | 5,189 | `792f863c7bfd849d36abb56f6751608ac60656f0a7a09a3e2ebaea7fbdca8c8a` |
| `2026-07-17-c294-b3-two-port-transition-replay.py` | 8,918 | `3f3d78a972fb4779fce5026753987c2fa914ae4004d806bf0cda424882b64686` |
| `2026-07-17-c294-b3-two-port-seeking-live-q3.json` | 878 | `89d7c2288ec93e0e3fa1598c0dc05348d6be2a5998d3b695ed44d99e8d58c5b2` |
| `2026-07-17-c294-b3-two-port-seeking-live-q5-100k.json` | 1,228 | `f66ce6fc279a293db5530bdd06a6badee059e6be454309a9bc081a1fe2e660d5` |
| `2026-07-17-c294-b3-two-port-seeking-live-replay.json` | 272 | `def5823ef33f3a9c2550d9deb73683dcc169e0ee781d4b926caf813fbe2a9973` |
