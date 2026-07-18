# C294 B3: exact sparse-core boundary quotient

**Date:** 2026-07-18
**Lane:** `crowns`
**Status:** exact quotient theorem and independently checked compression witness; bounded negative
at the fixed ten-million-state type-0 value gate

## Exact quotient theorem

Let `X` be a connected residual of one fixed emitted Cayley graph and let `C(X)` be its two-core.
Every component of `X-C(X)` is a tree joined by exactly one edge to one core vertex. Replace each
such rooted tree by its exact B1 one-port transition interface, retaining at every core vertex the
sorted multiset of incident interfaces.

**Theorem.** If two residuals have the same absolute two-core and the same interface multiset at
every core vertex, then they have the same Node--Kayles Grundy value.

**Proof.** The common absolute core, with every other attachment included, is an admissible
one-port context for any selected attachment. Replace equal interfaces one attachment at a time.
The B1 replacement theorem preserves the Grundy value at each step, so the two complete residuals
have equal values. QED.

For cycle ranks two through four, the earlier exact cubic-multigraph skeleton canonicalizer may
also quotient by core isomorphism before applying the same interface labels. Its reconstruction
theorem identifies the core contexts, after which the preceding replacement argument applies.
Paths, cycles, trees, and unicyclic components retain their previously checked exact evaluators.

The transition system is therefore exact: canonical connected records are nodes; a move deletes a
closed neighbourhood, splits the result into connected records, xors their values, and mexes the
resulting option set. The high-rank record is sparse:

```text
(cycle rank, absolute two-core mask,
 sorted (core vertex, sorted incident one-port interfaces) for nonempty attachment sites).
```

The implementation stores complete integer vectors and uses exact vector equality. Hashing only
selects an unordered-map bucket and is not a trusted equality oracle. Interned interface IDs name
complete recursively interned B1 records; they are deterministic implementation references, not
an additional quotient.

## Fixed finite gate

`notes/2026-07-17-c294-b3-seven-skeleton-value.cpp` embeds the checked B2 source read-only and adds
the quotient recurrence above. The state limit counts newly evaluated connected quotient nodes;
paths and cycles are table lookups, and cached tree, unicyclic, low-cycle, and high-core records do
not consume another state. The q=5 type-0 run uses the card's fixed ten-million-state stop gate.

The 100,000-state prefix stops without the 116-vertex follower value at the first unseen
24-vertex connected quotient node. It has 84,964 cyclic quotient classes, 1,708,125 quotient-cache
hits, and 329 high-core cache-hit events in which the current absolute mask differs from the stored
representative. Thus the exact quotient has genuine high-core reuse; unlike B2's whole low-cycle
test, its equality gate is not vacuous. These are hit events, not a count of distinct merger pairs.

The first high-core merger consists of two 30-vertex residuals. The separately organized,
symmetry-free Python verifier reconstructs their absolute two-cores and full structural B1
interfaces without using C++ IDs, finds both records equal, and evaluates both masks directly to
nimber zero.

At the fixed ten-million-state gate the quotient still does not return the type-0 follower value.
It stops at the first unseen 30-vertex connected quotient node after 253,828,637 component
decompositions. The run creates 9,516,062 cyclic quotient classes and serves 299,919,005 quotient
cache hits. Of those, 2,998,831 high-core hit events use an absolute mask different from the
stored representative. It interns 67,595 absolute rooted attachments into 26,766 B1 interface
nodes, alongside 58,435 tree shapes and 425,481 unicyclic shapes.

This is the card's bounded negative: the sparse-core quotient is exact and demonstrably merges
high-core states, but under the unchanged ten-million connected-state stop condition it certifies
no type-0 nimber and therefore does not pass B3's local exit gate. The remaining six hard types
were not run, exactly as required by the card's sequencing rule.

## Independent checks

`notes/2026-07-17-c294-b3-seven-skeleton-value-replay.py` reads the emitted q=5 type-0 graph and
the primary JSON. It separately implements component splitting, direct mex/xor recursion,
iterated two-core pruning, and nested structural B1 interfaces, with no symmetry reduction. For
the primary run's first high-core merger it requires equal absolute cores, equal per-vertex
interface records, and equal direct nimbers. It also requires rejection of a single-vertex state
perturbation and a deliberately wrong nimber. Its canonical output is:

```json
{"current_nimber":0,"current_vertices":30,"field_order":5,"interface_records_equal":true,"prior_nimber":0,"prior_vertices":30,"single_vertex_mutation_rejected":true,"single_vertex_mutation_vertex":7,"two_cores_equal":true,"type_index":0,"wrong_nimber_mutation_rejected":true}
```

The q=3 `(2,3,4)` control returns follower nimber `1`, exactly matching both predecessor
connected-K-set engines and the component solver. Optimized and AddressSanitizer/UndefinedBehavior
Sanitizer builds produce byte-identical q=3 JSON.

## Replay

From `/home/tavis/src/othello`:

```sh
g++ -O3 -std=c++20 -Wall -Wextra -Werror \
  notes/2026-07-17-c294-b3-seven-skeleton-value.cpp \
  -o /tmp/c294-b3-seven-skeleton-value
python3 notes/2026-07-17-c294-exact-value-gate.py --q 3 --type 0 --emit-graph \
  | /tmp/c294-b3-seven-skeleton-value 1000000 /tmp/c294-b3-q3.json
cmp /tmp/c294-b3-q3.json \
  notes/2026-07-17-c294-b3-seven-skeleton-value-q3.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | /tmp/c294-b3-seven-skeleton-value 100000 /tmp/c294-b3-q5-100k.json
cmp /tmp/c294-b3-q5-100k.json \
  notes/2026-07-17-c294-b3-seven-skeleton-value-q5-100k.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | /tmp/c294-b3-seven-skeleton-value 10000000 /tmp/c294-b3-q5-10m.json
cmp /tmp/c294-b3-q5-10m.json \
  notes/2026-07-17-c294-b3-seven-skeleton-value-q5-10m.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | python3 notes/2026-07-17-c294-b3-seven-skeleton-value-replay.py \
      notes/2026-07-17-c294-b3-seven-skeleton-value-q5-10m.json \
  > /tmp/c294-b3-replay.json
cmp /tmp/c294-b3-replay.json \
  notes/2026-07-17-c294-b3-seven-skeleton-value-replay.json
sha256sum -c notes/2026-07-17-c294-b3-seven-skeleton-value.sha256
```

Enumeration is deterministic and has no random seed. The graph convention is unchanged:
lexicographically ordered permutations of `P1(q)`, type-0 generators of orders `(2,3,4)` at q=3
and `(2,4,5)` at q=5, edges `h--s*h`, and closed-neighbourhood deletion. The tested compiler is
GCC 14.3.0 and the independent replay uses Python 3.13.12.

## Trusted boundary and scope

The trusted boundary is the predecessor prime-field graph generator; the embedded B2 component,
skeleton, and exact interface implementation; sparse two-core serialization; mex/xor recurrence;
and equality of complete vector records. The Python replay does not use the primary solver's cache,
canonicalizer, interface IDs, or symmetry reduction, but it does share the emitted graph and the
Node--Kayles rules encoding. It is therefore evidence against an implementation or certificate
error in the first merger, not independent evidence against a graph-modeling error. This bundle
does not claim agreement of two independent solvers on a q=5 value: no q=5 value was returned. The
q=3 agreement is a control inherited from the predecessor bundle, not a strategy certificate.

The finite run does not by itself prove a quotient bounded uniformly in `q`, classify any other
hard type, or establish a q-general full-group value theorem. A stopped run certifies no follower
value. The first merger and its independent replay certify that the high-core quotient genuinely
identifies distinct absolute residuals; they do not imply that the compression is large enough to
cross the fixed value frontier.

The checksum manifest also pins the embedded B2 source and the graph generator as load-bearing
inputs.

| New artifact | Bytes | SHA-256 |
|:--|--:|:--|
| `2026-07-17-c294-b3-seven-skeleton-value.cpp` | 10,842 | `a1fdc1e6807a66cecc0b73695ad87c9eec5c90e266b4b7a486a937ae3b531cd6` |
| `2026-07-17-c294-b3-seven-skeleton-value-replay.py` | 5,320 | `d291091fd1fb34759665c1bdc3a79ef5dd40902434c08c9f3b1452a999e879c9` |
| `2026-07-17-c294-b3-seven-skeleton-value-q3.json` | 633 | `26bb7cc0971cdfe16b703322d77d135063dde75759406883f8aa3be1cf10b3d6` |
| `2026-07-17-c294-b3-seven-skeleton-value-q5-100k.json` | 809 | `e2a01300a947e95f217c90dcb1258986be59fa32645c31fa7f3be71db89cb6ba` |
| `2026-07-17-c294-b3-seven-skeleton-value-q5-10m.json` | 840 | `56f2f16f819d3637d83dd8b443855047e8cb625483908e6dccd330d62a270d2f` |
| `2026-07-17-c294-b3-seven-skeleton-value-replay.json` | 276 | `2a60eddbf7d9f21df797001337b5669c039cd9dead4c5c84f8f7bdbc011db29e` |
| `2026-07-17-c294-b3-seven-skeleton-value.sha256` | 955 | manifest |
