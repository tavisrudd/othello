# C294 B3: simultaneous multi-piece live quotient

**Date:** 2026-07-18
**Lane:** `crowns`
**Status:** first independently checked cross-exact full cache collision; no collision yet uses more
than one selected piece, and the material quotient gate remains closed

## Result

The live high-core key can soundly replace several vertex-disjoint two-port pieces at once. The
bounded implementation greedily chooses at most four compatible separator sides, removes their
interiors, and canonically encodes the remaining exact context with one oriented two-vertex gadget
per complete transition interface. It minimizes over all interface orientations.

On the unchanged q=5 type-0 100,000-connected-state prefix, 4,042 positions use at least two
pieces and the maximum is three. The traversal selects 14,931 pieces across 10,897 high-core
requests. It also exposes the first full cache-key collision attributable to different exact
piece classes. The independently checked witness has:

- two non-isomorphic residual graphs;
- port-preservingly isomorphic exact contexts;
- two non-isomorphic 16-vertex pieces, under both fixed and swapped ports;
- equal complete two-port interfaces; and
- closed nimber `2` for both pieces.

Thus repeated two-port replacement really reaches equality of complete live positions, not only
an isolated interface-table merger. This is the transition-specific full collision requested by
the preceding bounded gate.

The gain is still immaterial. Exactly one cross-exact full collision occurs, and both sides of
that first collision select only one piece. No collision in the fixed prefix requires multiple
selected pieces. Quotient classes remain `84,903`, decompositions remain `1,941,396`, and the
follower value is not returned. The one-million interface cap is not reached: the run uses
289,185 combined boundary and closed states. These are the cross-class seeker's prior live counts,
so simultaneous greedy composition adds no measured recursion reduction.

The complete q=3 control returns follower nimber `1` with 105 connected states and 657
decompositions. Its nine high-core requests each select one piece, so it supplies no multi-piece
positive or conflict.

## Exactness

For each selected piece the key records its complete ordered transition node. The artificial
gadget is only a canonical serialization: its two differently labelled ends attach to the two
actual context ports. Equality of serialized keys therefore gives a port- and interface-
preserving context isomorphism. Replace equal interfaces one at a time using the proved two-port
replacement theorem, then apply graph-isomorphism invariance to the remaining context. This
preserves the exact Grundy value.

Selection history and greedy ordering can change which sound decomposition represents a position,
but cannot make unequal keys equal. The construction makes no minimality or canonical
decomposition-tree claim.

## Independent replay

`2026-07-17-c294-b3-multi-piece-live-replay.py` is separate from the C++ context canonicalizer. It
feeds the emitted pieces to the independently organized transition replay, then performs its own
colour-refinement/backtracking isomorphism searches on the full residuals and on the contexts with
fixed and swapped port colours. It returns

```json
{"context_isomorphic_fixed_ports":true,"context_isomorphic_swapped_ports":false,"field_order":5,"full_residuals_isomorphic":false,"piece_interface_equal":true,"piece_isomorphic_fixed_ports":false,"piece_isomorphic_swapped_ports":false,"piece_nimbers":[2,2],"piece_vertices":[16,16],"type_index":0}
```

This checks the first complete collision, not the full 100,000-state traversal. The primary
recursion remains responsible for the prefix counts.

## Replay

From `/home/tavis/src/othello`:

```sh
g++ -O3 -std=c++20 -Wall -Wextra -Werror -fno-access-control \
  notes/2026-07-17-c294-b3-multi-piece-live.cpp \
  -o /tmp/c294-b3-multi-piece-live
python3 notes/2026-07-17-c294-exact-value-gate.py --q 3 --type 0 --emit-graph \
  | /tmp/c294-b3-multi-piece-live 1000000 1000000 /tmp/c294-multi-q3.json
cmp /tmp/c294-multi-q3.json \
  notes/2026-07-17-c294-b3-multi-piece-live-q3.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | /tmp/c294-b3-multi-piece-live 100000 1000000 /tmp/c294-multi-q5.json
cmp /tmp/c294-multi-q5.json \
  notes/2026-07-17-c294-b3-multi-piece-live-q5-100k.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | python3 notes/2026-07-17-c294-b3-multi-piece-live-replay.py \
      notes/2026-07-17-c294-b3-multi-piece-live-q5-100k.json \
      /tmp/c294-multi-replay.json
cmp /tmp/c294-multi-replay.json \
  notes/2026-07-17-c294-b3-multi-piece-live-replay.json
sha256sum -c notes/2026-07-17-c294-b3-multi-piece-live.sha256
```

Enumeration is deterministic and uses no random seed. Graph conventions remain lexicographically
ordered permutations of `P1(q)`, type-0 generators `(2,3,4)` at q=3 and `(2,4,5)` at q=5, edges
`h--s*h`, and closed-neighbourhood deletion. The q=5 game cap is exactly 100,000 connected states;
the interface cap is one million combined boundary and closed states. The tested compiler is GCC
14.3.0 and the replay uses Python 3.13.12.

## Boundary and next gate

The computation does not evaluate the q=5 follower, reduce the quotient-class count, show that a
multi-piece replacement itself causes a collision, or justify a ten-million-state run. Greedy
parallel selection is now a bounded negative for material gain. The next design must canonicalize
a recursive separator tree, so that nested and parallel pieces have a decomposition-independent
normal form; require a quotient-class reduction on this same prefix before any larger value run.

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| `2026-07-17-c294-b3-multi-piece-live.cpp` | 21,459 | `97cc8b67a0f69e95e65be8b53c13189e925f042ad987302092943a00e3725c9f` |
| `2026-07-17-c294-b3-multi-piece-live-replay.py` | 6,275 | `27e661482ed8f1e8eba089cc26bb30c23235191569a4669d181b24eead223f26` |
| `2026-07-17-c294-b3-multi-piece-live-q3.json` | 833 | `54828f2af318aa383eb33016f717e6f738be5c66768d96f5d1610a034784d54c` |
| `2026-07-17-c294-b3-multi-piece-live-q5-100k.json` | 1,520 | `3b0726d4ab27b66e3669626c69351d0f51ba5da5a2076630a4f5db6bfbbd9cbd` |
| `2026-07-17-c294-b3-multi-piece-live-replay.json` | 298 | `74427dffc71ef09e4b4bc32513fd30e4a54946c69a7647e5961ae3d33911efcb` |
