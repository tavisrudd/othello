# C294 B3: exact labelled-high-two-core isomorphism compression

**Date:** 2026-07-18  
**Lane:** `crowns`  
**Status:** diagnostic high-core compression is real, but the fixed 100,000-state live-quotient
gate fails to move the value frontier materially

## Result

On the exact q=5 type-0 100,000-state traversal already fixed by the predecessor B3 bundle,
11,031 completed absolute high-two-core classes collapse to 10,088 classes modulo exact
isomorphism of the two-core with B1 attachment-interface labels. This removes 943 classes, or
8.55% of the targeted high-core layer. All 943 identifications preserve the already computed
nimber. The canonicalizer visits 56,497 individualization/refinement search nodes in total; its
hardest input needs only 15 nodes and 8 discrete leaves.

The live-quotient pilot confirms only a small effective gain. It encounters 10,897 absolute
high-core keys, completes 10,186 canonical high-core classes, and serves 693 cache hits on a new
absolute key. High-key requests fall from 84,032 to 79,279 (5.66%), but total decompositions fall
only from 1,946,240 to 1,941,400 (0.249%). The solver still spends the full 100,000 connected
states, stops at a 24-vertex unseen node, and returns no follower nimber. Total completed quotient
classes fall by only 61, from 84,964 to 84,903, because the quotient changes the depth-first
traversal.

This does not clear the material live gate. A second ten-million-state run is not justified. The
next structural diagnostic should measure repeated pieces behind one- and two-vertex separators
inside these canonical high cores before investing in a two-port boundary algebra; exact whole-
core isomorphism is now closed as the missing compression mechanism on this prefix.

The q=3 control completes with follower nimber 1. Its 9 absolute high-core classes collapse to 6
isomorphism classes, again with no value conflict. Optimized and
AddressSanitizer/UndefinedBehaviorSanitizer builds emit byte-identical q=3 JSON.

## Exact quotient statement

For a connected residual `X`, prune leaves to obtain its two-core `C(X)`. Label each core vertex
by the sorted multiset of exact B1 one-port interfaces of the rooted trees incident outside the
core. If two such labelled cores are isomorphic, then the residuals have equal Node--Kayles
nimbers.

Indeed, transport one core to the other through the labelled-core isomorphism. The transported
core, all other attachments, and all closed components form an admissible context for each rooted
attachment in turn. Equality of its B1 label permits replacement by the B1 congruence theorem.
After finitely many replacements the residuals are isomorphic, so their nimbers agree.

The C++ canonicalizer implements this relation exactly. It starts from core degree and complete
interned B1 label, repeatedly refines each vertex by the multiset of neighbour colours, and
individualizes a vertex in the first nonsingleton colour cell until the partition is discrete.
The lexicographically least complete labelled adjacency encoding is the key. It stores and
compares complete vectors; hashing is only bucket selection.

## Fixed-prefix measurement

In diagnostic mode, `notes/2026-07-17-c294-b3-high-core-isomorphism.cpp` deliberately retains the
predecessor's absolute high-core key as its live recursion cache. It computes the isomorphism key
only after an absolute high-core class finishes. Thus the q=5 run exactly reproduces the old traversal:
100,000 connected states, 1,946,240 decompositions, 1,708,125 quotient-cache hits, 84,964 total
quotient classes, and the same first unseen 24-vertex node. The displayed 943 mergers compare the
two keys on the same completed classes rather than on a quotient-altered search order.

In `--live` mode, the same exact canonical key replaces the absolute high-core key. The separate
tracked live outputs record the q=3 control and q=5 bounded negative summarized above.

The first new q=5 merger comprises two 32-vertex residuals whose labelled two-cores each have 23
vertices and nimber 1. The independent Python replay constructs an explicit 23-vertex bijection,
checks adjacency and complete structural B1 labels under that bijection, evaluates both residuals
by direct mex/xor recursion, and rejects both a single-vertex perturbation and a wrong nimber.

## Replay

From `/home/tavis/src/othello`:

```sh
g++ -O3 -std=c++20 -Wall -Wextra -Werror \
  notes/2026-07-17-c294-b3-high-core-isomorphism.cpp \
  -o /tmp/c294-b3-high-core-isomorphism
python3 notes/2026-07-17-c294-exact-value-gate.py --q 3 --type 0 --emit-graph \
  | /tmp/c294-b3-high-core-isomorphism 1000000 /tmp/c294-b3-iso-q3.json
cmp /tmp/c294-b3-iso-q3.json \
  notes/2026-07-17-c294-b3-high-core-isomorphism-q3.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 3 --type 0 --emit-graph \
  | /tmp/c294-b3-high-core-isomorphism 1000000 /tmp/c294-b3-iso-q3-live.json --live
cmp /tmp/c294-b3-iso-q3-live.json \
  notes/2026-07-17-c294-b3-high-core-isomorphism-q3-live.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | /tmp/c294-b3-high-core-isomorphism 100000 /tmp/c294-b3-iso-q5.json
cmp /tmp/c294-b3-iso-q5.json \
  notes/2026-07-17-c294-b3-high-core-isomorphism-q5-100k.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | /tmp/c294-b3-high-core-isomorphism 100000 /tmp/c294-b3-iso-q5-live.json --live
cmp /tmp/c294-b3-iso-q5-live.json \
  notes/2026-07-17-c294-b3-high-core-isomorphism-q5-100k-live.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | python3 notes/2026-07-17-c294-b3-high-core-isomorphism-replay.py \
      notes/2026-07-17-c294-b3-high-core-isomorphism-q5-100k.json \
  > /tmp/c294-b3-iso-replay.json
cmp /tmp/c294-b3-iso-replay.json \
  notes/2026-07-17-c294-b3-high-core-isomorphism-replay.json
sha256sum -c notes/2026-07-17-c294-b3-high-core-isomorphism.sha256
```

Enumeration is deterministic and uses no random seed. The graph conventions remain
lexicographically ordered permutations of `P1(q)`, type-0 generators of orders `(2,3,4)` at q=3
and `(2,4,5)` at q=5, edges `h--s*h`, and closed-neighbourhood deletion. The tested compiler is
GCC 14.3.0 and the replay uses Python 3.13.12.

## Trusted boundary and scope

The primary trusted boundary is the predecessor prime-field graph generator; B2 component,
skeleton, and B1-interface implementation; leaf pruning; individualization/refinement
canonicalizer; mex/xor recurrence; and complete-vector equality. The independent replay shares
the emitted graph and mathematical B1 definition, but not the primary IDs, canonical encoding,
or symmetry search: it searches directly for a bijection and independently evaluates the witness.

The live run records 693 new-absolute-key hits, not 943 saved connected states: recursive order
changes prevent that interpretation. The experiment gives no evidence that its small gain persists
to ten million states. It returns no q=5 follower value, classifies none of the other six hard
types, and proves no q-uniform bound.

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| `2026-07-17-c294-b3-high-core-isomorphism.cpp` | 20,550 | `beb8922ec2f3cda632364e759db39871a263e924bdfac7a7ed8a77b88927c125` |
| `2026-07-17-c294-b3-high-core-isomorphism-replay.py` | 8,716 | `06c3199407edee45a97f4fcc9a0f3a880e65040b4783c102b186cf55c897471d` |
| `2026-07-17-c294-b3-high-core-isomorphism-q3.json` | 999 | `d709775a79bc8548562f69d2322c4f843a1c10b7d418347de5891fa8f9158cdf` |
| `2026-07-17-c294-b3-high-core-isomorphism-q3-live.json` | 886 | `23bef575cb89c575ee1583c0c9b83f13df5fbf8d6e7fc5a67e843269667b72ef` |
| `2026-07-17-c294-b3-high-core-isomorphism-q5-100k.json` | 1,110 | `1f552041ade3b6ad8a2d43279d99cc595e4683294e8765da33e7b9fbf63258a3` |
| `2026-07-17-c294-b3-high-core-isomorphism-q5-100k-live.json` | 941 | `36fb4dc9ff502671d96e592440dfcd17921bb3f4128ff715d6e49edbba1c1727` |
| `2026-07-17-c294-b3-high-core-isomorphism-replay.json` | 375 | `9baf8d19d364011bf7d237c2e7e80f95c308b8d1e24a1f259db1378e5e9af5a0` |
