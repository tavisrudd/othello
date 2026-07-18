# C294 B3: exact two-port transition algebra

**Date:** 2026-07-18
**Lane:** `crowns`
**Status:** local replacement theorem proved; fixed-prefix compression gate passes before its
independent interface-state cap

## Result

There is an exact finite transition-DAG semantics for a graph piece behind two boundary vertices.
It is a congruence for gluing to every finite two-port Node--Kayles context, up to a specified
bijection of the two ports. On the unchanged q=5 type-0 separator census, the first one million
combined boundary and closed states process 37,726 of the 350,951 exact two-port piece classes with
at least eight internal core vertices. Those classes collapse to 37,690 transition classes: 36
non-isomorphic mergers and zero closed-value conflicts.

This is a bounded positive for the missing contextual algebra, not a value result. The interface
cap stops while constructing the next piece, whose core side has 14 vertices. It does not process
the remaining 313,225 exact piece classes, integrate the quotient into the connected-position
solver, or return the hard q=5 follower nimber.

The complete q=3 control processes all 47 meaningful exact piece classes. It produces 47 transition
classes, no mergers, no conflicts, and the already certified follower nimber `1`.

## Boundary states and transition object

Let `H` be a finite context with distinct distinguished vertices `p_1,...,p_k`, where `k` is one
or two. A boundary state is a finite graph `T`, disjoint from `H`, together with incidence sets
`N_i subset V(T)`; gluing adds exactly the edges `p_i--v` for `v in N_i`. Components of `T` that
touch no live incidence set are closed and compose by nimber xor.

For each live state, the canonical record contains two tables.

1. For every nonempty set `D` of ports deleted by a context move, record separately the event in
   which no deleted port was selected and every event in which one `s in D` was selected. Selecting
   `s` also deletes `N_s` from `T`; merely deleting a port does not delete its internal neighbours.
   The result is the closed nimber offset and the recursively interned state on the surviving ports,
   or the closed nimber of the whole remainder when no port survives.
2. For every internal move `v`, label it by the exact set
   `K(v)={i : v in N_i}` of boundary ports it kills. Delete the closed neighbourhood of `v`, split
   off components touching no surviving port, and record their xor offset together with the
   recursively interned lower-boundary state. If all ports die, record the closed remainder nimber.
   Duplicate options within each `K`-labelled set are discarded.

The recursion is finite. An internal move reduces `|T|`; an external event represented in the
record reduces the number of live ports. Node equality is complete-record equality after child
nodes have themselves been interned. The implementation computes both port orientations and treats
pieces as equal up to a chosen port bijection when either orientation agrees.

## Local replacement theorem

**Theorem (two-port replacement).** Suppose two one- or two-port states have equal transition
records under a fixed bijection of their live ports. Gluing them through that bijection to any
finite context gives equal Node--Kayles Grundy values. Consequently replacement preserves both the
nimber and the P/N outcome.

**Proof.** Fix the context and use strong induction on the total number of context and internal
vertices. A context move that deletes no port leaves the same live record in a smaller context, so
the induction hypothesis applies. Every context move that deletes at least one port has a unique
label `(D,s)`, where `s` is the selected boundary port or is absent; equal external tables give the
same closed offset and equal lower-boundary successor. Every internal move has a unique killed-port
label `K(v)`; equal internal tables give the same set of offset/successor pairs for the corresponding
context residue `H-K(v)`. The induction hypothesis equates every live successor, while disjoint
closed components contribute the recorded xor offset. Thus the two glued positions have identical
sets of option nimbers and therefore the same mex. QED.

The distinction between selecting a port and deleting it as a neighbour is load-bearing. Selecting
`p_i` deletes `N_i`; a different context move that deletes `p_i` leaves `N_i` alive. Likewise an
internal move must retain the complete killed-port subset because each subset leaves a different
context residue.

## Fixed finite gate

The primary checker inherits the predecessor's exact traversal and separator census without
changing either state cap. For each exact census class it expands the core side by every residual
tree attachment rooted at an internal core vertex. Attachments rooted at the separator vertices
remain in the context. Classes are processed in lexicographic order of their exact canonical piece
keys, so the interface stop prefix is deterministic.

| domain | exact classes `>=8` | processed | transition classes | mergers | conflicts | interface states | stop |
|:--|--:|--:|--:|--:|--:|--:|:--|
| q=3 type 0 | 47 | 47 | 47 | 0 | 0 | 6,689 | complete |
| q=5 type 0 | 350,951 | 37,726 | 37,690 | 36 | 0 | 1,000,000 | next core side has 14 vertices |

The q=5 interface states split into 941,462 live boundary states and 58,538 independently memoized
closed states, producing 504,317 distinct transition nodes. The game traversal itself remains the
fixed 100,000 connected-state prefix with 1,946,240 decompositions and no follower value.

## Independent first-merger replay

The first primary merger expands to two 16-vertex pieces. The independently organized Python
replay reconstructs both two-cores and their attached forests directly from the emitted q=5 graph,
implements its own mex/xor recursion and transition interner, and performs an exact
boundary-preserving isomorphism backtrack. It reports:

```json
{"current_interface_id":132,"current_nimber":2,"current_vertices":16,"field_order":5,"interface_equal":true,"interface_nodes":176,"isomorphic_fixed_ports":false,"isomorphic_swapped_ports":false,"prior_interface_id":132,"prior_nimber":2,"prior_vertices":16,"type_index":0}
```

The replay's node IDs are local and need not equal the primary checker's IDs. Equality within the
independent interner certifies identical complete records. The pieces have nimber `2` and are not
isomorphic under either possible boundary bijection, so this is a genuine transition merger rather
than another exact-piece isomorphism hit.

## Replay

From `/home/tavis/src/othello`:

```sh
g++ -O3 -std=c++20 -Wall -Wextra -Werror -fno-access-control \
  notes/2026-07-17-c294-b3-two-port-transition.cpp \
  -o /tmp/c294-b3-two-port-transition
python3 notes/2026-07-17-c294-exact-value-gate.py --q 3 --type 0 --emit-graph \
  | /tmp/c294-b3-two-port-transition 1000000 1000000 /tmp/c294-b3-two-port-q3.json
cmp /tmp/c294-b3-two-port-q3.json \
  notes/2026-07-17-c294-b3-two-port-transition-q3.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | /tmp/c294-b3-two-port-transition 100000 1000000 /tmp/c294-b3-two-port-q5.json
cmp /tmp/c294-b3-two-port-q5.json \
  notes/2026-07-17-c294-b3-two-port-transition-q5-100k.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | python3 notes/2026-07-17-c294-b3-two-port-transition-replay.py \
      notes/2026-07-17-c294-b3-two-port-transition-q5-100k.json \
  > /tmp/c294-b3-two-port-replay.json
cmp /tmp/c294-b3-two-port-replay.json \
  notes/2026-07-17-c294-b3-two-port-transition-replay.json
sha256sum -c notes/2026-07-17-c294-b3-two-port-transition.sha256
```

Enumeration is deterministic and has no random seed. Graph conventions remain lexicographically
ordered permutations of `P1(q)`, type-0 generators `(2,3,4)` at q=3 and `(2,4,5)` at q=5, edges
`h--s*h`, and closed-neighbourhood deletion. The primary checker uses GCC's
`-fno-access-control` only to read the predecessor census's private completed-piece map without
modifying that predecessor bundle.

## Trusted boundary and next gate

The primary trusted boundary is the predecessor graph generator, B1 attachment semantics, exact
high-core and separator canonicalization, the fixed mex/xor traversal, expansion of each census
piece by its actual attached forests, and the two-port transition interner. The independent replay
shares only the emitted graph, the recorded first-witness masks, and the mathematical transition
definition; its component reconstruction, nimber recursion, interning code, and isomorphism search
are separate.

This computation does not prove that the transition quotient is finite uniformly in `q`, process
the whole q=5 prefix, evaluate the 116-vertex follower, or justify raising the generic ten-million
game-state cap. The next bounded step is live integration on the unchanged 100,000-state q=5
prefix, with a measured decomposition/hit-rate gate before any larger run. Exact transition nodes
must be computed only for separator pieces actually requested by the live decomposition.

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| `2026-07-17-c294-b3-two-port-transition.cpp` | 16,172 | `dd99c563e47d3e2610544e724ac4d8d44439e18187edcfe9ff29ea6bc2a6476c` |
| `2026-07-17-c294-b3-two-port-transition-replay.py` | 8,918 | `3f3d78a972fb4779fce5026753987c2fa914ae4004d806bf0cda424882b64686` |
| `2026-07-17-c294-b3-two-port-transition-q3.json` | 656 | `b189a4b276c7740a6645264677d64eaa90a57c1f7cf0094a5792ddba553e373c` |
| `2026-07-17-c294-b3-two-port-transition-q5-100k.json` | 971 | `184a8eea7e819025bbdf4a9cab299fa6537f1b47ca075f031b3a6806f5b41e77` |
| `2026-07-17-c294-b3-two-port-transition-replay.json` | 272 | `359a5a9e8aa3cc101be25e9462d42729816ad58767bb399196e8857e9ab88353` |
