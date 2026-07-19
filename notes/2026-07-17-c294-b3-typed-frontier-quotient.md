# C294 B3 E2: transition-stable typed-frontier quotient

**Date:** 2026-07-18
**Lane:** `crowns`
**Status:** bounded negative; E2 fails its fixed 850-merger promotion gate and routes next to E3

## Result

The typed `02` square coordinate has substantial static headroom but almost none of it survives
value-blind transition closure. On the unchanged q=5 type-0 completed prefix, successive refinement
has class counts

```text
28,505 -> 84,958 -> 84,963 -> 84,963.
```

The stable partition merges exactly one pair of distinct absolute classes. The two 16-vertex
residuals are non-isomorphic and both have exact nimber `1`, so this is one genuine typed-transition
merger with zero observed value conflicts. It is far below the preregistered requirement of 850
genuine removals beyond the 943 separately known graph-isomorphism removals. Combining the two sound
relations therefore has a lower bound of only 944 total removals, 943 old and one new. E2 closes
negatively; no live replay, larger cap, transfer run, or all-seven value run is authorized.

The q=3 control remains discrete: its 49 starting classes refine to 49 stable classes with no
conflict. The q=5 run reproduces 100,000 started connected evaluations, 84,964 completed absolute
classes, 1,946,240 decompositions, and the unknown follower value. No state beyond the E1 prefix is
generated.

## Exact finite transition theorem

For each completed connected class, the checker records the full set of legal typed transitions.
A transition retains:

- determinant sheet and alternating-square orientation of the played vertex;
- the live `02` square word, live-neighbour colour bits, and the incident third-colour square word;
- every rank-at-least-two connected child as a symbolic successor class; and
- the exact xor of detached path, tree, and unicyclic components.

Starting from the E1 typed-square coordinate, refinement repeatedly splits classes by these complete
transition records. State nimbers are not used. All symbolic children are smaller and all 1,792,961
q=5 symbolic successor terms resolve inside the completed universe; the missing-successor count is
zero. Equality at the stable partition is therefore value preserving on this finite typed grammar:
induct on live vertices, use equal successor classes for every symbolic component, xor the identical
detached bank, and then take mex of the equal option-value sets. The 2,334,577 unique q=5 typed
transitions are checked directly. Known q=3/q=5 nimbers are applied only afterward as a falsifier and
produce zero conflicts.

This proves closure for every completed use in the fixed prefixes. It does not prove a finite
quotient for unseen q=5 states or uniformly in `q`; that would require the same constructor closure
on the enlarged reachable universe.

## First genuine merger and replay

The first and only stable q=5 merger is

```text
prior   (hi,lo) = (9007216570941475, 1176851552699154432), nimber 1
current (hi,lo) = (9007216602382499, 1176851552699154432), nimber 1.
```

The independent Python replay reconstructs the pinned coloured `PGL2(5)` graph, evaluates both
16-vertex masks by a direct component/mex Node--Kayles recursion, and checks non-isomorphism with a
separately organized exact backtracker. It recovers nimbers `1,1` and reports `isomorphic=false`.
It also checks the q=3 discrete control and the emitted gate arithmetic. The replay does not
independently recompute all 2.33 million transition records; the complete stable-partition counts
remain inside the primary C++ refinement trusted boundary.

## Replay

From `/home/tavis/src/othello` with GCC 14.3.0 and Python 3.13.12:

```sh
g++ -O3 -std=c++20 -Wall -Wextra -Werror -fno-access-control \
  notes/2026-07-17-c294-b3-typed-frontier-quotient.cpp \
  -o /tmp/c294-b3-typed-frontier-quotient
python3 notes/2026-07-17-c294-b3-relevance-ledger-input.py --q 3 --type 0 \
  | /tmp/c294-b3-typed-frontier-quotient 1000000 1000000 /tmp/c294-e2-q3.json
cmp /tmp/c294-e2-q3.json \
  notes/2026-07-17-c294-b3-typed-frontier-quotient-q3.json
python3 notes/2026-07-17-c294-b3-relevance-ledger-input.py --q 5 --type 0 \
  | /tmp/c294-b3-typed-frontier-quotient 100000 1000000 /tmp/c294-e2-q5.json
cmp /tmp/c294-e2-q5.json \
  notes/2026-07-17-c294-b3-typed-frontier-quotient-q5-100k.json
python3 notes/2026-07-17-c294-b3-typed-frontier-quotient-replay.py \
  notes/2026-07-17-c294-b3-typed-frontier-quotient-q3.json \
  notes/2026-07-17-c294-b3-typed-frontier-quotient-q5-100k.json \
  /tmp/c294-e2-replay.json
cmp /tmp/c294-e2-replay.json \
  notes/2026-07-17-c294-b3-typed-frontier-quotient-replay.json
sha256sum -c notes/2026-07-17-c294-b3-typed-frontier-quotient.sha256
```

Enumeration is deterministic and uses no random seed. Graph conventions remain lexicographically
ordered permutations of `P1(q)`, edges `h--s_i h`, the type-0 generators `(2,3,4)` for q=3 and
`(2,4,5)` for q=5, and closed-neighbourhood deletion. The primary trusted boundary is the pinned
graph generator, E1 exact recursion/canonical classes, typed local-label construction, exact
component xor, deterministic partition refinement, and exact graph-isomorphism backtracking used to
separate genuine mergers. The replay shares only the pinned graph constructor and the emitted
aggregate certificate.

## Artifacts

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| `2026-07-17-c294-b3-typed-frontier-quotient.cpp` | 20,257 | `c34bcf1a846b31cbf0655619c8307b72a28ce1f4272d2ca71c1c27be3f1f4126` |
| `2026-07-17-c294-b3-typed-frontier-quotient-replay.py` | 6,253 | `3843e4fe972c81fd2c50f779f7882ad89a0d04abf58c1114315bec701803f49a` |
| `2026-07-17-c294-b3-typed-frontier-quotient-q3.json` | 906 | `8a2fc890e8f7669b291f60f776cdb8e726e6623c3d4f14104b5d2106ed04c5e9` |
| `2026-07-17-c294-b3-typed-frontier-quotient-q5-100k.json` | 1,310 | `bd9fe982bc037fffd39732380740e01f03aded09d4de1289d600257eabc98780` |
| `2026-07-17-c294-b3-typed-frontier-quotient-replay.json` | 224 | `3ead065a77b877ab15bc7e4ce1b02b3c405607bc34d8e033ec165119dd372a30` |

## Boundary and next gate

E2 certifies neither the q=5 follower value nor a live speedup. The static headroom from E1 was
real, but almost every candidate merger is distinguished by one round of typed transitions. This
is evidence against over-strong universal typed-frontier equality on the present coordinate, not
against a direct outcome strategy.

The serial experiment queue therefore advances to E3: freeze and test an adaptive bulk-pairing and
response-debt automaton against the existing type-0/four-ply corpus. E4 transfer remains gated
behind the E2/E3 decision, and the 100,000-new-state replay and ten-million-state cap remain closed.
