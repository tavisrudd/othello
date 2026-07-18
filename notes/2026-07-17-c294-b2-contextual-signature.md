# C294 B2: exact contextual-signature gate

**Date:** 2026-07-18
**Lane:** `crowns`
**Status:** bounded pass with no whole-component compression; B3 activated

## Result

The B1 one-port transition DAG has been implemented as an exact canonical signature on the fixed
q=3 control and corrected 100,000-state q=5 prefix. Equal contextual keys never receive unequal
nimbers. The mandatory old-triple witness is separated, and an independently organized Python
replay recovers its nimbers and a strictly weaker boundary-label distinction.

The pass is conceptually mixed. The interface does compress repeated rooted states, but after the
interfaces are placed on the exact low-cycle skeleton it merges no completed component shapes:

| domain | absolute rooted states | interface nodes | low-cycle shapes | contextual classes | mergers | value conflicts |
|:--|--:|--:|--:|--:|--:|--:|
| q=3 `(2,3,4)` | 45 | 6 | 40 | 40 | 0 | 0 |
| bounded q=5 type 0 `(2,4,5)` | 3,132 | 1,393 | 73,911 | 73,911 | 0 | 0 |

Thus the finite congruence gate passes, but the whole-component equality test is vacuous: there are
no equal contextual keys among distinct completed low-cycle shapes in either mandatory domain.
This is a bounded negative for compression by the exact B1 interface on the present skeleton key,
not a failure of the replacement theorem. Per the fixed slice gate, zero conflicts activate B3;
the counts give no reason to expect this interface alone to accelerate its hard follower value.

## Checker

`notes/2026-07-17-c294-b2-contextual-signature.cpp` retains the corrected component solver and
replaces only the old three-nimber attachment label. For each absolute rooted tree it recursively
interns the B1 record

```text
(free, cut, sorted_unique (closed_offset, child_id), singleton kill_value).
```

The empty interface is node zero. The boundary recursion has its own absolute-state memo and its
own structural interning table; it does not read or write the primary connected-position cache or
alter the 100,000-state stop condition. At each core vertex the checker records the sorted multiset
of incident interface IDs, retaining the exact topology and suppressed-path construction from the
corrected component kernel.

The q=5 run visits the same 100,020 uncached connected masks, stops at the same first unseen
27-vertex state, and reproduces the predecessor component counts: 2,274 trees, 12,743 unicyclic
shapes, 73,911 rank-two-through-four shapes, 1,635,750 low-cycle cache hits, and seven core topology
classes. This is an invariant check that the diagnostic signature did not perturb the primary
recursion or its prefix.

## Mandatory witness and independent replay

The C++ contextual keys of the recorded 15- and 19-vertex masks both have length 27 and first differ
at entry 25. Therefore the exact B1 interface distinguishes the conflict before any larger
enumeration.

`notes/2026-07-17-c294-b2-contextual-signature-replay.py` is independently organized. It implements
direct mex/xor Node--Kayles recursion, leaf-pruned two-cores, and structural nested B1 interfaces;
it does not use the C++ canonical skeleton or either C++ memo. It returns

```json
{"boundary_label_multisets_equal":false,"current_nimber":1,"current_vertices":19,"field_order":5,"prior_nimber":4,"prior_vertices":15,"type_index":0}
```

The weaker multiset of `(core degree, incident structural interfaces)` already differs, independently
confirming separation without duplicating the primary skeleton canonicalizer.

## Replay

From `/home/tavis/src/othello`:

```sh
g++ -O3 -std=c++20 -Wall -Wextra -Werror \
  notes/2026-07-17-c294-b2-contextual-signature.cpp \
  -o /tmp/c294-b2-contextual-signature
python3 notes/2026-07-17-c294-exact-value-gate.py --q 3 --type 0 --emit-graph \
  | /tmp/c294-b2-contextual-signature 1000000 /tmp/c294-b2-q3.json
cmp /tmp/c294-b2-q3.json \
  notes/2026-07-17-c294-b2-contextual-signature-q3.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | /tmp/c294-b2-contextual-signature 100000 /tmp/c294-b2-q5.json
cmp /tmp/c294-b2-q5.json \
  notes/2026-07-17-c294-b2-contextual-signature-q5-bounded.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | python3 notes/2026-07-17-c294-b2-contextual-signature-replay.py \
  > /tmp/c294-b2-replay.json
cmp /tmp/c294-b2-replay.json \
  notes/2026-07-17-c294-b2-contextual-signature-replay.json
sha256sum -c notes/2026-07-17-c294-b2-contextual-signature.sha256
```

Enumeration is deterministic and has no random seed. Inputs and graph conventions are unchanged:
lexicographically ordered permutations of `P1(q)`, edges `h--s*h`, type 0 generators `(2,3,4)` at
q=3 and `(2,4,5)` at q=5, and closed-neighbourhood deletion. The q=5 primary recursion is stopped
at 100,000 cached connected states; signature and witness diagnostics do not consume that cache.

## Trusted boundary and scope

The primary trusted boundary is the inherited prime-field graph generator, mex/xor recursion,
component splitting, two-core/skeleton canonicalization, the B1 transition implementation, and
equality of complete vector keys. Since all mandatory graphs have at most 128 vertices, every mex
is at most 128 and fits the checker's `uint8_t` storage. The independent replay shares only the
emitted graph and mathematical Node--Kayles/B1 definitions; its direct witness recursion and
structural tuples are separate code.

The computation does not evaluate the hard q=5 follower, prove useful compression beyond this
prefix, prove that the interface has bounded size as q grows, or establish any q-general value
theorem. In particular, 3,132 absolute rooted states collapsing to 1,393 interfaces does not induce
a merger among the 73,911 completed contextual skeleton keys.

## Artifacts

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| `2026-07-17-c294-b2-contextual-signature.cpp` | 37,349 | `da021f424d3f2585d55fa2d538ebc56f2727fe9a88a47af3c7c61b4d2bf6d8e6` |
| `2026-07-17-c294-b2-contextual-signature-replay.py` | 3,852 | `cb270fb4e40cb8b05cd72ca96c5bec5d8af5e1cc9079fd2cadb383c94675eaa0` |
| `2026-07-17-c294-b2-contextual-signature-q3.json` | 827 | `a10b4d321235156374388f92926d4aa2fcf910c2e45abd4da70771ef06f41959` |
| `2026-07-17-c294-b2-contextual-signature-q5-bounded.json` | 972 | `2815d7a04cc1f312fef1699231f13d3c6b9390173459aa79b3d2c1fbf04cd107` |
| `2026-07-17-c294-b2-contextual-signature-replay.json` | 150 | `188c462638cae552db5667b9632b73709a924ccf34f2a52787570adbc91f54a4` |
