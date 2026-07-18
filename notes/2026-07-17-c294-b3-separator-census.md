# C294 B3: repeated labelled pieces behind high-core separators

**Date:** 2026-07-18
**Lane:** `crowns`
**Status:** fixed-prefix diagnostic passes the reuse gate; design a two-port boundary algebra next

## Result

The unchanged q=5 type-0 100,000-state traversal contains substantial exact reuse of labelled
pieces behind one- and two-vertex separators in its canonical high two-cores. The signal remains
large after discarding pieces with fewer than eight internal vertices and after counting reuse only
across distinct canonical high-core classes.

For genuine two-port pieces with at least eight internal vertices, 976,693 of 1,313,230 occurrences
(`74.37%`) belong to a class seen in at least two distinct canonical cores. There are 61,220 such
cross-core classes among 350,951 exact piece classes, and the largest reused piece has 29 internal
vertices. One-port pieces show the same phenomenon: 101,842 of 141,446 occurrences (`72.00%`)
belong to 6,096 cross-core classes, with reused pieces as large as 28 vertices.

This clears the B3 card's separator-census gate. A conservative materiality test of at least 1,000
cross-core classes, at least half of meaningful-size occurrences covered, and a reused piece of at
least 16 vertices is passed by both interfaces. The next bounded design task is therefore an exact
two-port transition algebra and local replacement theorem. This result does not implement that
algebra, return the hard follower value, or justify another ten-million-state run.

## Exact census object

The diagnostic observes only completed high-rank (`rho >= 5`) absolute classes in the predecessor's
fixed traversal. It first canonicalizes each high two-core with the exact B1 attachment-interface
label at every core vertex and censes only the first representative of each canonical labelled
core. Thus the 943 already known whole-core isomorphism duplicates cannot inflate piece reuse.

For a cut vertex `a`, every component of `C-a` is a one-port piece. For a separating pair `{a,b}`,
every component of `C-{a,b}` that touches both `a` and `b` is a genuine two-port piece. The exact
piece key contains:

- the induced component graph;
- the complete B1 attachment-interface label on every internal vertex; and
- one or two artificial boundary vertices joined exactly to their incident internal vertices.

The two artificial ports receive the same distinguished label, so their order is immaterial while
their separate incidence is preserved. The edge between `a` and `b`, their own attachment labels,
and the rest of the core are context, not part of the piece. Equality is complete-vector equality
after individualization/refinement canonicalization; hashing selects buckets only.

`occurrences` counts separator sides. `classes` counts exact canonical piece keys.
`cross_core_classes` counts keys present in at least two distinct canonical high cores, and
`occurrences_in_cross_core_classes` is the corresponding occurrence coverage. Repetition confined
to several cuts of one core is reported separately and is not the design gate.

## Fixed q=5 census

| interface and minimum internal size | occurrences | exact classes | cross-core classes | cross-core occurrence coverage | largest cross-core piece |
|:--|--:|--:|--:|--:|--:|
| one port, `>=1` | 214,875 | 46,312 | 6,664 | 174,899 | 28 |
| one port, `>=4` | 188,863 | 46,171 | 6,589 | 148,953 | 28 |
| one port, `>=8` | 141,446 | 45,372 | 6,096 | 101,842 | 28 |
| two ports, `>=1` | 1,966,561 | 354,294 | 63,341 | 1,628,647 | 29 |
| two ports, `>=4` | 1,613,231 | 353,892 | 63,153 | 1,275,537 | 29 |
| two ports, `>=8` | 1,313,230 | 350,951 | 61,220 | 976,693 | 29 |

The 10,088 canonical high cores contain 106,700 articulation sites and 1,925,275 separating-pair
sites. The latter yield 4,420,787 sides, of which 1,966,561 touch both ports. The high-core and
traversal invariants reproduce the predecessor exactly: 11,031 completed absolute high-core
classes collapse to 10,088 canonical classes with 943 duplicates; the run uses 100,000 connected
states, 1,946,240 decompositions, 84,964 quotient classes, and 1,708,125 quotient-cache hits before
stopping at the same unseen 24-vertex node. It returns no follower nimber.

The q=3 control returns follower nimber `1` with 108 connected states and 680 decompositions, and
again reproduces the predecessor's `9 -> 6` canonical high-core collapse. Optimized and
AddressSanitizer/UndefinedBehaviorSanitizer builds emit byte-identical q=3 JSON.

## Independent witness replay

The primary q=5 certificate includes deterministic cross-core witnesses with eight internal
vertices for both interface arities. The separately organized Python replay reconstructs the
two-core and structural B1 records directly from the emitted graph, verifies that each component
is a side of the stated separator and touches every claimed port, and performs an explicit
boundary-preserving labelled-isomorphism search. It uses no C++ interface IDs, canonical keys, or
symmetry search.

The one-port witness has a nine-vertex augmented mapping and the two-port witness a ten-vertex
mapping. Both preserve adjacency and complete structural labels. Deliberately changing one
internal structural label makes both searches fail. The replay also pins the fixed traversal
counts above against the predecessor certificate.

## Replay

From `/home/tavis/src/othello`:

```sh
g++ -O3 -std=c++20 -Wall -Wextra -Werror \
  notes/2026-07-17-c294-b3-separator-census.cpp \
  -o /tmp/c294-b3-separator-census
python3 notes/2026-07-17-c294-exact-value-gate.py --q 3 --type 0 --emit-graph \
  | /tmp/c294-b3-separator-census 1000000 /tmp/c294-b3-separator-census-q3.json
cmp /tmp/c294-b3-separator-census-q3.json \
  notes/2026-07-17-c294-b3-separator-census-q3.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | /tmp/c294-b3-separator-census 100000 /tmp/c294-b3-separator-census-q5.json
cmp /tmp/c294-b3-separator-census-q5.json \
  notes/2026-07-17-c294-b3-separator-census-q5-100k.json
python3 notes/2026-07-17-c294-exact-value-gate.py --q 5 --type 0 --emit-graph \
  | python3 notes/2026-07-17-c294-b3-separator-census-replay.py \
      notes/2026-07-17-c294-b3-separator-census-q5-100k.json \
  > /tmp/c294-b3-separator-census-replay.json
cmp /tmp/c294-b3-separator-census-replay.json \
  notes/2026-07-17-c294-b3-separator-census-replay.json
sha256sum -c notes/2026-07-17-c294-b3-separator-census.sha256
```

Enumeration is deterministic and uses no random seed. Graph conventions remain lexicographically
ordered permutations of `P1(q)`, type-0 generators of orders `(2,3,4)` at q=3 and `(2,4,5)` at
q=5, edges `h--s*h`, and closed-neighbourhood deletion. The tested compiler is GCC 14.3.0 and the
replay uses Python 3.13.12.

## Trusted boundary and scope

The primary trusted boundary is the predecessor prime-field graph generator; B2 component,
skeleton, and exact B1-interface implementation; two-core extraction; separator enumeration;
individualization/refinement canonicalization; mex/xor recurrence; and complete-vector equality.
The independent replay shares the emitted graph and mathematical B1 definition but separately
implements structural interfaces, separator validation, and explicit isomorphism search.

The census measures recurrence of exact boundary-labelled graph pieces, not contextual equivalence
of their games. It neither proves that a finite two-port interface exists nor that replacing equal
future two-port transition objects preserves value. It covers only the fixed q=5 type-0 prefix and
does not classify any hard follower or imply q-uniform compression.

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| `2026-07-17-c294-b3-separator-census.cpp` | 26,891 | `f57f4c084d7b2fbad500e8642615d78cab9e1ef3a24634d55f83edcd02318588` |
| `2026-07-17-c294-b3-separator-census-replay.py` | 9,887 | `5f1ec7266025edd0766b4403363d028a034a3c44cbe051dbe2f3e7716b843428` |
| `2026-07-17-c294-b3-separator-census-q3.json` | 2,796 | `4fe9517fea41a5b7ffede70c3911e6c2c523f8e69d398d8ee4a997e1a29929fd` |
| `2026-07-17-c294-b3-separator-census-q5-100k.json` | 4,211 | `e82ceb8763b7fca406c33fe2df689bd3b165d68c87a06d11fde59764f2eef246` |
| `2026-07-17-c294-b3-separator-census-replay.json` | 368 | `5c0566c272104d5ca2dd1d6ecbf66ee12536c6ba1387ce6a2456caa0a63e7536` |
