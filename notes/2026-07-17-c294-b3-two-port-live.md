# C294 B3: bounded live integration of the two-port quotient

**Date:** 2026-07-18
**Lane:** `crowns`
**Status:** exact live integration completed on the fixed prefix; no transition-specific gain, so
the ten-million-state gate remains closed

## Result

The exact two-port transition algebra has been integrated into the unchanged q=5 type-0
100,000-connected-state traversal. The live solver requests only genuine separator pieces with at
least eight internal core vertices and at most 16 expanded vertices, the envelope already completed
by the predecessor interface gate. It computes transition records lazily and never asks the
interface engine to expand the 112-vertex separator side at the initial follower.

The interface layer is heavily reused but adds no new quotient at this prefix:

| metric | q=3 control | q=5 fixed prefix |
|:--|--:|--:|
| live decomposition requests | 9 | 10,888 |
| distinct unordered interface classes | 6 | 162 |
| reusable-interface hits | 3 | 10,726 |
| hits joining different exact piece classes | 0 | 0 |
| live hits on a new absolute high-core key | 3 | 1,492 |
| connected states | 105 | 100,000 |
| decompositions | 657 | 1,941,400 |
| quotient classes | 46 | 84,903 |
| follower nimber | 1 | not returned |

The q=5 reusable-interface rate is `10,726 / 10,888 = 98.51%`, and the interface engine uses only
9,323 of its one-million-state budget. But all reuse is reuse of the same exact canonical piece
class. More importantly, the traversal lands exactly on the predecessor live high-core-isomorphism
metrics: 1,941,400 decompositions and 84,903 quotient classes. Relative to the unchanged separator
baseline, decompositions fall from 1,946,240 by 4,840 (`0.249%`), exactly the already reported
whole-core-isomorphism reduction. The transition quotient contributes no additional compression
and returns no q=5 follower value.

This is a bounded negative for the present one-piece live key, not for the two-port replacement
theorem. No ten-million-state run or run on the remaining six types is justified.

## Exact live cache key

For a connected high-cycle residual `X`, the solver selects the smallest expanded genuine
two-separator piece `T` in the validated size envelope. Let `H=X-T`, retaining the two separator
vertices as distinguished ports. It forms both port orientations of

```text
(exact ordered transition record of T,
 canonical isomorphism key of the full port-labelled context H)
```

and uses the lexicographically smaller orientation as the connected-position cache key. Equality
of two such keys supplies a port-preserving context isomorphism and equal transition records.
The predecessor two-port replacement theorem therefore gives equal Node--Kayles nimbers. The key
is exact; it is not heuristic pruning. Positions without a piece in the completed size envelope,
or positions reached after an interface-state stop, retain the predecessor absolute key.

`notes/2026-07-17-c294-b3-two-port-live.cpp` implements this key on top of the immutable separator
and transition semantics. The only change to the predecessor transition source is a behavior-neutral
`C294_TWO_PORT_TRANSITION_NO_MAIN` guard so the checked kernel can be included without its CLI
driver. Regenerated predecessor q=3, q=5, and replay outputs are byte-identical.

The later cross-class-seeking diagnostic adds behavior-neutral compile-time selector hooks and a
main-function guard to this source. With those hooks undefined, the same q=3 and q=5 artifacts are
again byte-identical; only this source file's hash and byte count change.

## Independent replay

The first q=5 full-position hit uses the same absolute 10-vertex piece and ports in two distinct
residual masks. `notes/2026-07-17-c294-b3-two-port-live-replay.py` independently constructs the
complete recursive transition records and performs its own colour-refined isomorphism backtrack.
It verifies equal fixed-port interface records, isomorphic fixed-port contexts, and isomorphic full
residual graphs. It rejects the swapped-port alignment. This replay does not call the primary
canonicalizer or use its node IDs.

The replay also exposes the limitation cleanly: the first live hit is already a graph-isomorphism
hit. Together with zero different-exact-piece interface hits over the complete fixed traversal,
there is no measured contextual merger for the live selector.

## Replay

From `/home/tavis/src/othello`:

```sh
g++ -O3 -std=c++20 -Wall -Wextra -Werror -fno-access-control \
  notes/2026-07-17-c294-b3-two-port-live.cpp -o /tmp/c294-b3-two-port-live
python3 notes/2026-07-17-c294-exact-value-gate.py --q 3 --type 0 --emit-graph \
  | /tmp/c294-b3-two-port-live 1000000 1000000 /tmp/c294-b3-two-port-live-q3.json
cmp /tmp/c294-b3-two-port-live-q3.json \
  notes/2026-07-17-c294-b3-two-port-live-q3.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | /tmp/c294-b3-two-port-live 100000 1000000 /tmp/c294-b3-two-port-live-q5.json
cmp /tmp/c294-b3-two-port-live-q5.json \
  notes/2026-07-17-c294-b3-two-port-live-q5-100k.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | python3 notes/2026-07-17-c294-b3-two-port-live-replay.py \
      notes/2026-07-17-c294-b3-two-port-live-q5-100k.json \
  > /tmp/c294-b3-two-port-live-replay.json
cmp /tmp/c294-b3-two-port-live-replay.json \
  notes/2026-07-17-c294-b3-two-port-live-replay.json
sha256sum -c notes/2026-07-17-c294-b3-two-port-live.sha256
```

Enumeration is deterministic and has no random seed. Graph conventions remain lexicographically
ordered permutations of `P1(q)`, type-0 generators `(2,3,4)` at q=3 and `(2,4,5)` at q=5, edges
`h--s*h`, and closed-neighbourhood deletion. The q=5 game cap is exactly 100,000 connected states;
the independent interface cap is exactly one million combined boundary and closed states. The
tested tools are GCC 14.3.0 and Python 3.13.12. An ASan/UBSan q=3 build emits byte-identical JSON.

## Trusted boundary and next design gate

The primary trusted boundary is the predecessor graph generator, component and high-core kernels,
separator detection, complete transition interner, exact full-context canonicalizer, mex/xor
recurrence, and complete-vector equality. The independent replay shares the emitted graph and the
mathematical transition definition, but not the primary cache key or isomorphism code.

The computation does not process pieces above 16 expanded vertices, prove a q-uniform interface,
evaluate the q=5 follower, or classify the other six hard types. The next B3 mechanism must expose
different exact piece classes to the live transition quotient without reproducing the already
failed whole-core-isomorphism traversal. It needs its own bounded compression gate before any
larger value run.

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| `2026-07-17-c294-b3-two-port-live.cpp` | 23,183 | `f0c18e9f9bbbfeb00cc9b56c7612d58944b55289e45cc99bb2512967bd64cd1a` |
| `2026-07-17-c294-b3-two-port-live-replay.py` | 8,103 | `7b4fbf26cf57f43ddd25a5b39efd1c4a6c7463ac5497082285fa08e231153f1a` |
| `2026-07-17-c294-b3-two-port-live-q3.json` | 1,500 | `cea21d4d444642afe627e52b84c97738ba79daef43e3f1c8955ae3f606fa43ee` |
| `2026-07-17-c294-b3-two-port-live-q5-100k.json` | 1,735 | `f5f8ec2f9032a293edaf607f45dd83b8580a5baf3a428c56af1c21aa4cfd104d` |
| `2026-07-17-c294-b3-two-port-live-replay.json` | 274 | `8da312e66f5d2a04b6c30c31f5fbab7ae965c7f5efee50ab72223f738447492d` |
