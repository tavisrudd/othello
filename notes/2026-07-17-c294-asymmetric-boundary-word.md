# C294 asymmetric boundary word: the two-count rank is not a transfer state

**Date:** 2026-07-18
**Lane:** `crowns`
**Status:** exact bounded negative. The smallest asymmetric boundary is now encoded on the
alternating backbones, but neither immediate closure nor lexicographic descent of its two scalar
counts survives the mandatory `PGL2(5)` gates. The seven hard root values remain unevaluated.

## Result

Fix one of the right-regular involutory mirrors `tau` used in the C294 mixed-scar attack. For an
induced residual state `X`, define its **boundary rank**

```text
r_tau(X) = (number of tau-pairs with exactly one live endpoint,
            number of adjacent tau-pairs with both endpoints live),
```

ordered lexicographically. Rank `(0,0)` is a genuine P base: `tau` restricts to a fixed-point-free
nonadjacent involutory automorphism. The most economical proposed asymmetric recursion was:

1. answer a defect move by some legal response, producing `X`;
2. permit one opponent move in `X`; and
3. answer by either reaching `(0,0)` or strictly decreasing `r_tau`.

This language fails exactly at the required finite gates.

For the two certified `(2,4,5)` obstruction states, no defect response lets every next opponent
move receive a rank-decreasing reply. The best response for the six-defect, 100-vertex parent still
has 31 uncovered moves among 92; the best response for the five-defect, 58-vertex parent has six
uncovered moves among 51. More strongly, across all 151 defect responses and all 11,708 resulting
opponent moves, not one opponent move has a reply returning to rank `(0,0)`. Thus allowing exactly
one asymmetric round does not restore the original mirror anywhere in these two gates.

The same strict-rank rule already fails at the root of every one of the seven hard mixed
`PGL2(5)` conjugacy types:

| type | determinant classes | pair orders | best covered moves | uncovered moves |
|---:|:---:|:---:|---:|---:|
| 0 | `001` | `(2,4,5)` | 46/112 | 66 |
| 1 | `001` | `(2,5,6)` | 48/112 | 64 |
| 2 | `001` | `(4,5,6)` | 50/112 | 62 |
| 3 | `001` | `(4,5,6)` | 50/112 | 62 |
| 7 | `001` | `(3,4,6)` | 52/112 | 60 |
| 9 | `011` | `(2,4,6)` | 44/112 | 68 |
| 11 | `011` | `(3,4,6)` | 39/112 | 73 |

This exhausts 812 root defect responses and 90,986 opponent moves. The checker ranked 7,653,100
legal reply children there, stopping a covered move after its first decreasing reply but exhausting
every reply to the counter-move that proves a response is not universal. The two deeper obstruction
gates rank another 924,192 reply children exhaustively because no closure occurs.

The conclusion is deliberately narrow:

> The asymmetric transfer state cannot be only the two counts “unbalanced mirror pairs” and “live
> defect pairs,” and its induction cannot require either original-mirror closure after one round or
> strict lexicographic descent of those counts after every round.

This does not refute a finite linked boundary word, a non-monotone finite automaton, or contextual
nimber equivalence.

## The encoded boundary word

Choose the two generator colours other than the selected mirror generator and decompose the regular
Cayley graph into their alternating dihedral cycles. On every affected cycle, write

- `+` at a live vertex whose `tau`-mate is dead;
- `-` at a dead vertex whose `tau`-mate is live; and
- nothing at balanced pairs.

Each letter records the outgoing generator colour and the cyclic gap to the next letter. Quotient
each cycle word by rotation and reversal and sort the resulting multiset. This is the smallest
label-independent signed backbone word that retains positions along each two-colour residue. The
JSON records the word for every best near-miss response together with its exact state hash, first
uncovered opponent move, and the complete boundary-rank histogram of that move's legal replies.

The encoding is a contextual boundary projection, not yet a complete state invariant. In
particular it does not link a `+` endpoint to its `-` mirror endpoint across different backbones and
does not record the third-matching twist between affected cycles. Those are now load-bearing rather
than optional refinements: the scalar projection of the word has failed at all nine gates.

## Independent checks and conventions

The primary rank kernel applies `tau` to a 120-bit live mask through independently precomputed
15-bit chunk tables. It verifies every singleton image against the explicit pairing permutation.
For each best near-miss, a separate pair-oriented implementation recomputes both rank coordinates
by enumerating the 60 mirror orbits and independently confirms that every reply to the displayed
counter-move is nondecreasing. The number of signed letters is also checked to be exactly twice the
number of unbalanced pairs.

The group, graph, obstruction paths, and direct `(2,3,4)` `PGL2(3)` base are reconstructed from the
two pinned predecessor checkers. All enumeration is deterministic, uses Python's standard library,
and has no random seed. Vertex indices are the lexicographic order of the explicit permutations;
the JSON also records each displayed move as its full permutation.

The trusted boundary is prime-field projective arithmetic, exhaustive `PGL2(5)` generation and
conjugacy representatives, the pinned obstruction paths, regular Cayley adjacency, and ordinary
Node--Kayles closed-neighbourhood deletion. The computation does **not** evaluate any of the seven
120-vertex roots, compute their nimbers, prove that the signed word is contextually complete, or
extrapolate to larger fields.

## Evidence and replay

From `/home/tavis/src/othello` run:

```sh
python3 notes/2026-07-17-c294-asymmetric-boundary-word.py \
  --check notes/2026-07-17-c294-asymmetric-boundary-word.json
sha256sum -c notes/2026-07-17-c294-asymmetric-boundary-word.sha256
```

| Load-bearing artifact | Bytes | SHA-256 |
|---|---:|:---|
| `notes/2026-07-17-c294-asymmetric-boundary-word.py` | 15,908 | `de29c456994e8715ed6cd70b3881237c1e8a2e4464ddf048ff53da610fb4ad11` |
| `notes/2026-07-17-c294-asymmetric-boundary-word.json` | 368,404 | `2cab0d7943a71dc814ed5da23ef8ad9d6dd2f57a63ad27be6cd9faa80531a47a` |
| `notes/2026-07-17-c294-recursive-defective-mirror.py` | 13,198 | `2a4f7eb8e514b154a7be3fbcb18da6b6e182d7142d531266e7c62a477e8096e7` |
| `notes/2026-07-17-c294-mixed-scar-obstruction.py` | 15,652 | `d3e2743a1fe7a987ffab8e924f63affc7d8e952a77abfa8ec49ce14201adb113` |

## Revised frontier

The next state should retain the signed cyclic words but add the endpoint linkage and third-matching
twist. The smallest next falsifiable object is a linked diagram whose ports are the signed letters,
whose strands are `tau`-pairings and third-generator edges, and whose transition is allowed to be
non-monotone inside a finite contextual automaton. It should be minimized on the direct
`(2,3,4)` `PGL2(3)` base and all seven hard `PGL2(5)` roots before any uniform claim. A larger depth
bound on the two scalar counts is no longer a credible next attack.
