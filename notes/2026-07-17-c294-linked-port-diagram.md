# C294 linked port diagram: descriptive completeness without compression

**Date:** 2026-07-18
**Lane:** `crowns`
**Status:** exact finite structural theorem and compression obstruction. A radius-one linked cut
diagram determines the first causal reply-rank signature on all nine mandatory `PGL2(5)` contexts,
but its minimized quotient has 950 classes for 963 states. The direct `PGL2(3)` control has 19
structural classes but all 20 states have Grundy value zero. No new `PGL2(5)` value is computed.

## Finite theorem

Fix a right-regular involutory mirror `tau` and one of the nine mandatory contexts: the seven hard
mixed `PGL2(5)` root types, or either of the two certified recursive-mirror obstruction states. Make
the displayed defect move and let `X` range over every legal response state. There are 812 root
states and 151 deep states, hence 963 `q=5` states. The audit also includes all 20 response states
of the direct `(2,3,4)` `PGL2(3)` P base as an exact-value control.

For such an `X`, retain the boundary rank from the predecessor report,

```text
r_tau(X) = (unbalanced tau-pairs, live adjacent tau-pairs).
```

Define the **local causal signature** `Sigma(X)` to be the multiset, over every opponent move in
`X`, of the multiset of ranks of all legal reply children. Thus `Sigma` remembers the complete
one-opponent/one-response rank transition, not merely whether one decreasing reply exists. The
checker ranks 10,769,112 legal reply children exactly across the 983 states.

The linked diagram is built in four nested layers.

1. The **unlinked word** is the predecessor multiset of signed cyclic words on the alternating
   two-colour backbones.
2. The **linked port diagram** adds `tau` strands, third-generator strands, anchor positions, and
   the exact coloured cyclic gaps between ports.
3. The **linked cut diagram** also marks every live/dead transition endpoint on every cut backbone,
   records its live status, and adds its `tau` and third-generator anchors.
4. A **radius-r twist expansion** includes every vertex of the initially cut backbones and then `r`
   successive backbone layers reached through `tau` or the third matching, retaining their full
   coloured twist.

All diagrams are canonical coloured relational graphs: vertex colours record port sign, liveness,
cut-endpoint status, and segment length; relation colours record the two backbone generators,
`tau`, and the third generator. Canonicalization quotients vertex names, cycle rotations,
reflections, and component order.

Within each fixed group/trace context, the linked cut diagram already determines `Sigma` for eight
of the nine gates. The sole exception is type 9, with determinant classes `011` and pair orders
`(2,4,6)`:

| context | states | unlinked classes / ambiguous states | linked classes / ambiguous states | cut classes / ambiguous states |
|:--|--:|:--:|:--:|:--:|
| direct `PGL2(3)` base | 20 | 16 / 6 | 19 / 0 | 19 / 0 |
| root type 0 | 116 | 34 / 86 | 85 / 32 | 114 / 0 |
| root type 1 | 116 | 34 / 86 | 85 / 36 | 114 / 0 |
| root type 2 | 116 | 33 / 88 | 114 / 0 | 114 / 0 |
| root type 3 | 116 | 33 / 88 | 114 / 0 | 114 / 0 |
| root type 7 | 116 | 16 / 106 | 87 / 30 | 114 / 0 |
| root type 9 | 116 | 11 / 111 | 57 / 74 | 102 / 19 |
| root type 11 | 116 | 16 / 106 | 87 / 36 | 115 / 0 |
| deep mirror 2 | 96 | 22 / 83 | 68 / 32 | 96 / 0 |
| deep mirror 0 | 55 | 23 / 37 | 33 / 26 | 55 / 0 |

For type 9, the 19 ambiguous cut states form seven cut-diagram classes. Full twist on the four
initially cut backbones (radius zero) leaves eight states in four ambiguous classes. One backbone
expansion resolves them all: the 19 states become 19 classes. That expansion contains 15--18 of the
30 alternating backbones and produces diagrams with as many as 204 marker/segment nodes.

Consequently the hybrid within-context quotient—linked cut diagrams, with radius one only on the
seven exceptional type-9 classes—has exactly 950 classes for 963 states and no `Sigma` ambiguity.
It merges only 13 response states.

The `PGL2(3)` control shows why structural compression is the wrong target. Its 20 response states
occupy 19 linked-cut classes and have distinct local rank signatures whenever the table says they
are separated, yet independent direct recursion gives Grundy value zero for every one. Thus the
actual outcome quotient collapses all 20 states to a single P class while the structural quotient
merges only one pair.

## Interpretation

This is the first positive descriptive result for the asymmetric state: explicit linked cut data
does determine the complete first causal rank transition on the mandatory finite gate. But it is a
negative compression result. The quotient is 98.65% as large as the labelled response census, and
the one exceptional type needs half of its backbone system after only one expansion.

The natural structural diagram is therefore too fine to be the silver mechanism. Across all ten
contexts its hybrid quotient has 969 classes for 983 states; restricted to the unknown `q=5` gates
it has 950 for 963. Continuing to add
backbone layers would converge toward the original 120-vertex state rather than a small contextual
game algebra. The useful next invariant must forget most structural detail while preserving actual
P/N or nimber information—most plausibly a conserved charge, a causal history matching, or a
game-aware congruence learned from exact values.

The conclusion is bounded. It does not prove that the required radius grows with `q`, that no
eventually periodic algebra exists, or that 950 classes are necessary for P/N rather than for the
much finer signature `Sigma`. In particular, two states with different reply-rank multisets may
still have the same game value.

## Exact scope and independent checks

The state set is exhaustive after the fixed defect move in each context: 20 responses in the
direct `PGL2(3)` base, 116 responses for each of
seven roots, 96 responses in the six-defect deep state, and 55 in the five-defect deep state. The
local signature exhausts every opponent move and every legal reply child.

The primary rank kernel uses chunked 120-bit permutation tables. On the first response in every
context, an independent pair-oriented implementation recomputes both rank coordinates for every
reply to the first and last opponent moves. The diagram checker independently relabels selected
states by two centralizer right actions and requires the canonical form to remain identical at the
unlinked, cut, and every load-bearing twist radius. These are invariant replays, not a second graph
canonicalization package; the trusted boundary includes the individualization/refinement canonical
labeller itself.

The group, graph, obstruction paths, rank conventions, and direct `PGL2(3)` base are inherited from
the pinned predecessor scripts. Enumeration is deterministic, uses Python's standard library, and
has no random seed.

The computation does **not** evaluate a `PGL2(5)` root, compute any new Grundy value, prove
contextual equivalence under arbitrary gluing, or extrapolate beyond the displayed nine contexts.

## Evidence and replay

From `/home/tavis/src/othello` run:

```sh
python3 notes/2026-07-17-c294-linked-port-diagram.py \
  --check notes/2026-07-17-c294-linked-port-diagram.json
sha256sum -c notes/2026-07-17-c294-linked-port-diagram.sha256
```

| Load-bearing artifact | Bytes | SHA-256 |
|---|---:|:---|
| `notes/2026-07-17-c294-linked-port-diagram.py` | 27,009 | `53ed6508d0fc227f32c4c0bb668151e4e752202460858d0bad7f22ff3829c2c8` |
| `notes/2026-07-17-c294-linked-port-diagram.json` | 132,321 | `088538ca63270a87cfe711e81c55c223ad10db4ce2a7c6cd89c90e44619b255e` |
| `notes/2026-07-17-c294-asymmetric-boundary-word.py` | 15,908 | `de29c456994e8715ed6cd70b3881237c1e8a2e4464ddf048ff53da610fb4ad11` |
| `notes/2026-07-17-c294-recursive-defective-mirror.py` | 13,198 | `2a4f7eb8e514b154a7be3fbcb18da6b6e182d7142d531266e7c62a477e8096e7` |
| `notes/2026-07-17-c294-mixed-scar-obstruction.py` | 15,652 | `d3e2743a1fe7a987ffab8e924f63affc7d8e952a77abfa8ec49ce14201adb113` |

## Revised frontier

Do not enlarge the structural diagram again before obtaining game-value information. The next
finite task is to compute a coarser causal P/N signature on the direct `(2,3,4)` `PGL2(3)` base and
bounded followers of the seven hard `PGL2(5)` roots, then test whether that game-aware signature
collapses the 950 structural classes. If it does not, the three-centre silver route should be
narrowed rather than promoted into a uniform transfer claim.
