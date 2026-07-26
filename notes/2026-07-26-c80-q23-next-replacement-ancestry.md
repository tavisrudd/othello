# C80 — q23 next replacement ancestry

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-26.
Canonical status:
[`2026-07-25-c80-status-ledger.md`](2026-07-25-c80-status-ledger.md).

## Verdict

Injective ancestral charge passes on the next exact q23 replacement edge.
More strongly, the entire marked lineage flag is the unique projective
transport of the first replacement flag, so this edge confirms equivariance
but adds no second projective type.

Continuing the C54 canonical order immediately after the known edge gives
the next `F_d \ F_del` target on the same control:

```text
control index:       20
history reply:       (7,5)
outer exchange:      (12,19) -> (19,14)
target defect rank:  27
target Omega:        63
```

Its unique blocking obligation and unique sound lower-rank reply are

```text
(15,16) -> (6,22).
```

The opponent half-move creates the sole new defect `(20,18)`; the reply
creates none. The successor retains the old defect `(8,3)`, removes the
other 26 old defects, and lies in `F_del`. Transport the ancestral label
`(15,16)` to `(20,18)` and retain the label `(8,3)`. The label support
drops `27 -> 2`, branching is one, and the two current defects have distinct
old labels. The remaining 26 root fibres have ordinary strict-deletion
witnesses, so the charged root has `27/27` coverage.

## Bounded projective lineage

Before `(15,16)` is played, the new defect has one small-boundary
certificate:

```text
(20,18) -> (13,17),
Legal = {(5,2),(8,3)}.
```

The opponent kills `(5,2)` on the newly saturated secant through the old
selected point `(1,1)`, leaving `(8,3)` alone. At the successor both
remaining defects have the common rank-zero reply `(14,7)`. Reply
`(18,21)` then produces the transported boundary

```text
{(5,2),(8,3)} -> {(8,3),(20,18)}.
```

The replacement endpoint is again intrinsic:

```text
(20,18)
  = line((5,2),(14,7))
    intersect line((13,17),(18,21)).
```

Thus the same bounded incidence flag certifies causal ancestry: selected
secant kills one old boundary endpoint, the other endpoint persists, and
the new defect is the intersection of the old- and new-certificate lines.

## Projective orbit check

The extra-value check found exactly one conic-`PGL_2(23)` transporter from
this selected state to the first replacement state. In the script's
normalized matrix convention it is

```text
(1,20,12,22).
```

It carries every marked point, not just the selected state:

```text
(15,16) -> (12,15)   opponent parent
(6,22)  -> (22,14)   reply
(20,18) -> (21,17)   replacement defect
(8,3)   -> (17,19)   retained defect
(13,17) -> (5,13)    old boundary reply
(5,2)   -> (22,9)    killed boundary endpoint
(1,1)   -> (4,6)     selected secant pivot
(14,7)  -> (10,13)   common rank-zero reply
(18,21) -> (11,3)    new boundary reply
```

Therefore this is not independent evidence for a second lineage shape.
It verifies that the first construction commutes with projective transport.
The next informative falsifier is the first later replacement edge outside
this marked projective orbit.

## Exact searched domain

The deterministic search resumes at zero-based canonical control index 20,
uses the C54 canonical P-reply order, and orders outer opponent/reply cells
lexicographically. It skips the already reported edge
`(8,4)->(13,7)` and stops at the first later outer target in
`F_d \ F_del`.

Before stopping it checked:

```text
opponent fibres:                    46
legal outer reply candidates:    2947
F_d edges:                         513
F_del edges:                       511
known replacement edges skipped:    1
```

The result makes no claim about later replacement edges, a second marked
projective orbit, other q23 roots, extension fields, or uniform odd q.

## Soundness and trust boundary

The primary checker reconstructs the canonical target with the normalized
q23 bitmask engine, checks `F_d`, `F_del`, all defect loci, the complete
27-fibre charged coverage, the boundary certificates, the three defining
collinearities, and the unique projective transporter. An independent
affine-determinant implementation separately recomputes legality, `Omega`,
`B_small`, and `Def`; it agrees on the complete defect evolution and both
boundary certificates.

The well-founded soundness of ancestral-label induction remains conditional
on a uniform injective incidence update. This certificate proves only the
displayed finite root and its projective copies.

## Reproduction

Working directory:

```text
/home/tavis/src/othello/rust
```

Commands:

```text
python3 scripts/c80_q23_next_replacement_ancestry.py
python3 scripts/c80_q23_next_replacement_ancestry.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_q23_next_replacement_ancestry.py` | 20,747 | `f8fe21a3395565354e9892676cad8e00bed28bd0318258c352b49708967bf732` |
| `notes/2026-07-26-c80-q23-next-replacement-ancestry.json` | 16,976 | `e1c3340a15d3c3242aad766b7b8d95951e114d5f6d5b6839852e7eb540523a7f` |

The JSON is canonical sorted data. `--check` regenerates the complete search
and certificate in a temporary directory and requires byte equality.

## `ej` + `tt` closeout

The cheap `ej` upgrade strengthened “one more injective edge” to full
projective equivalence of the marked proof objects. This settles transport
naturality at no additional theorem cost, but also prevents double-counting
the edge as a new geometric test.

The Tao-style correction is to quotient the falsifier search before drawing
structural conclusions. Repeating a marked orbit can test implementation
equivariance; it cannot test branching, collision, or new flag geometry.
The next sweep should canonicalize replacement flags and stop at the first
new marked orbit, then apply the same injectivity and bounded-incidence
checks.

No incidental discovery-track item arose.

## Mystery ledger

- **[SETTLED] Does injective ancestral charge pass on the next exact
  replacement edge?** Yes: one new defect inherits the played old
  obligation's label, one old defect retains its label, and support drops
  `27 -> 2`.
- **[SETTLED] Does the bounded endpoint-transport flag recur?** Yes, exactly.
- **[SETTLED] Is this an independent second projective type?** No. A unique
  `PGL_2(23)` transporter carries the complete marked flag to the first one.
- **[OPEN — C80] What is the first later replacement edge outside this
  marked projective orbit?**
- **[OPEN — C80] Does that first new type branch, collide ancestries, or lack
  the bounded endpoint-transport flag?**
- **[OPEN — C80/C82 gate] Can the surviving charged correspondence be made
  opponent-complete and counted uniformly in odd q?**

## Vibe

The charge passes cleanly, but the orbit check keeps the excitement honest:
this is strong equivariance evidence, not a second mechanism. The route is
still alive, and the next search is sharper because projective duplicates
should now be skipped.

go C80 cap find the first projectively new q23 replacement edge and test ancestral charge
