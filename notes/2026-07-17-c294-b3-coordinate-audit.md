# C294 B3 E0: coloured-Cayley coordinate audit

**Date:** 2026-07-18  
**Lane:** `crowns`  
**Status:** E0 passed; recommend the bounded typed-context pilot `R`, while retaining one exactly
threshold-qualified type-0 transfer direction as a fallback

## Result

The seven hard `PGL2(5)` scars have been reconstructed as three-coloured 120-vertex Cayley graphs
and audited without game recursion. The determinant character gives two sheets of 60 vertices in
every case. Types `0,1,2,3,7` have colour transition word `001`; types `9,11` have `011`. Every
reported coloured adjacency reconstructs the pinned uncoloured graph exactly.

For each colour pair `ij`, the corresponding component is a left coset of
`<s_i,s_j>`, is one alternating cycle of length `2 ord(s_i s_j)`, and the third colour is a perfect
matching between those blocks. The primary audit obtains the blocks by coloured graph traversal;
the replay obtains them independently as explicit subgroup cosets and checks equality by canonical
hash.

The table records `order / subgroup size / block count / greedy whole-block live-boundary width`.
The greedy order is discovery output, but the emitted order and its width are checked directly.

| type | determinant bits | colours `01` | colours `02` | colours `12` |
|--:|:--:|:--:|:--:|:--:|
| 0 | `001` | `5 / 10 / 12 / 26` | `2 / 4 / 30 / 16` | `4 / 8 / 15 / 20` |
| 1 | `001` | `5 / 10 / 12 / 26` | `2 / 4 / 30 / 16` | `6 / 12 / 10 / 28` |
| 2 | `001` | `5 / 10 / 12 / 26` | `6 / 12 / 10 / 24` | `4 / 8 / 15 / 20` |
| 3 | `001` | `5 / 10 / 12 / 26` | `4 / 8 / 15 / 26` | `6 / 12 / 10 / 28` |
| 7 | `001` | `3 / 6 / 20 / 22` | `6 / 12 / 10 / 28` | `4 / 8 / 15 / 26` |
| 9 | `011` | `6 / 12 / 10 / 28` | `4 / 8 / 15 / 20` | `2 / 4 / 30 / 16` |
| 11 | `011` | `6 / 12 / 10 / 28` | `4 / 8 / 15 / 20` | `3 / 6 / 20 / 26` |

This retains both mandatory distinctions. Types 2 and 3 have the same sorted pair orders
`(4,5,6)` but attach orders 4 and 6 to different named colour pairs. Types 7 and 11 have the same
sorted pair orders `(3,4,6)` but different determinant words, `001` and `011`.

## Type-0 coordinate certificate

For type 0, the three pair systems have the following directly checked block-cut widths:

| pair | canonical order | identity-BFS order | greedy order |
|:--:|--:|--:|--:|
| `01` | 36 | 40 | 26 |
| `02` | 28 | 26 | **16** |
| `12` | 40 | 20 | 20 |

The `02` system is therefore the sole type-0 direction that meets the preregistered transfer gate
of at most 16 live vertex ports. It consists of 30 alternating four-cycles. Its third-colour
matching has 60 distinct block pairs of multiplicity one and no edge internal to a block. The
other two systems have 30 block pairs of multiplicity two and no internal third-colour edge.

The certificate also records the identity follower's four deleted vertices in raw group-index,
determinant-sheet, and all three `(block, alternating-cycle position)` coordinates. The full
colour-preserving automorphism group is the right-regular action: a colour-preserving map is fixed
by the image of the identity because a coloured path determines every image. The setwise
stabilizer of the initial four-vertex defect is trivial in all seven cases. Consequently the
reported stabilizer-orbit counts are respectively the literal block, matching-edge, and four
deleted-vertex counts; there is no hidden initial symmetry reduction.

## Routing decision

E0 recommends `R`, the preregistered scar-restricted typed contextual-equivalence pilot, as the
next bounded experiment. The audit supplies exactly the generator colour, determinant sheet,
cycle orientation, and local block constructors needed to state its typed grammar, while the
trivial initial-defect stabilizer warns against betting first on a small symmetry-frame automaton.

The type-0 `02` order makes `T` eligible, but only exactly at its 16-port cutoff and only for a
heuristically selected whole-block order. E0 has not measured interface diversity on the fixed
prefix, so this does not yet dominate `R` or authorize a transfer solver. Retain `T(02)` as the
single bounded fallback if `R` fails its 1% genuine-merger gate and `A` does not close a response
language. No other type-0 transfer direction passes the width gate.

## Certificate and independent replay

From `/home/tavis/src/othello` with Python 3.13.12:

```sh
python3 notes/2026-07-17-c294-b3-coordinate-audit.py \
  --check notes/2026-07-17-c294-b3-coordinate-audit.json
python3 notes/2026-07-17-c294-b3-coordinate-audit-replay.py \
  notes/2026-07-17-c294-b3-coordinate-audit.json
sha256sum -c notes/2026-07-17-c294-b3-coordinate-audit.sha256
```

The generator enumerates the determinant sheets by coloured graph propagation and the pair blocks
by restricted-colour connected components. It checks subgroup sizes, coset equality, alternating
cycle closure, coloured-to-uncoloured adjacency reconstruction, matching structure, stabilizer
actions, and every emitted width.

The replay shares only the pinned graph constructor and the mathematical conventions. It rebuilds
pair blocks from explicit subgroup cosets, follows alternating cycles independently, propagates and
checks determinant transitions, reconstructs the uncoloured graph, rebuilds the third-colour block
quotients, and directly replays every emitted elimination order. Its terminal result is
`{"cases_checked": 7, "status": "passed"}`.

| artifact | bytes | SHA-256 |
|:--|--:|:--|
| `2026-07-17-c294-b3-coordinate-audit.py` | 12,719 | `8c129f4cc0ac984104f11ba8492dfedce03b396d02faf0124647749702c1e909` |
| `2026-07-17-c294-b3-coordinate-audit-replay.py` | 5,567 | `de94df020ed93d383438b850cb198bad6a6c440709e09af3f03a7fef60059950` |
| `2026-07-17-c294-b3-coordinate-audit.json` | 59,815 | `ba0e62b400cea606d978357940147e85eba6b8364518037a47d0284ec30643ae` |

Enumeration is deterministic and has no random seed. The trusted boundary is the pinned
prime-field permutation model, exact finite-group generation, integer bit-set graph arithmetic,
and Python's JSON/SHA-256 implementations. The two checkers deliberately share the pinned graph
constructor; they do not independently establish that the mathematical scar model is the intended
one.

## Boundary

E0 performs no Node--Kayles recursion and certifies no nimber, P/N outcome, contextual quotient,
response strategy, or transfer compression. A block-cut width counts live vertices adjacent to
already eliminated *whole blocks*; it is not a treewidth claim and does not bound the number of
distinct game interfaces. The greedy order is not proved optimal. The exact result is only that
the emitted order has the checked width, including one type-0 order at the promotion threshold.

The 100,000-state and ten-million-state gates remain closed. The next `R` pilot must use only the
existing q=3 and q=5 fixed prefixes, remove at least 850 classes beyond the 943 known graph-
isomorphism removals with zero nimber conflicts, and prove closure under its typed scar grammar
before any live integration.
