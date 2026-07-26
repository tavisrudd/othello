# C80 — history-marked torus obligation rewrite

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.

## Verdict

The first history-marked algebraic rewrite is projectively natural but fails
both coverage and soundness.

For a certified repair edge `(o,p)`, retain the full cyclic generator

```text
H = ι_o ι_p
```

of the two induced conic involutions. For a later legal opponent `x`, admit
every distinct geometric reply `y` in the symmetric-square orbit
`<H>.x` such that `x,y` are jointly legal and strictly lower `Ω`. This uses
the marked repair history, not merely the current unmarked state, and keeps
the whole equivariant correspondence rather than selecting a power.

On every q17 repair target the projected relation has 14 edges:

```text
6 P + 8 N,
21/32 legal moves covered,
15/22 terminal-graph isolates covered,
8/22 isolates incident to a P edge.
```

Seven isolates have no legal strict history-orbit reply at all. Another seven
have an orbit reply but no P reply. Thus the marked torus cannot absorb the
isolate locus, and retaining every equivariant choice is value-impure.

The q19 control is worse:

```text
11 edges = 2 P + 9 N,
20/51 legal moves covered.
```

The relation and its generator commute exactly with the full order-four
stabilizer at both orders. This is a substantive falsifier of the most
canonical history-only rewrite, not a normalization failure.

## Candidate correspondence

Let `T=S+o+p` be the repair target. The tested relation is

```text
R_H(T,x,y) :=
  x,y legal moves from T
  ∧ x≠y
  ∧ ∃k, y=Sym²(H^k)x
  ∧ T+x+y valid
  ∧ Ω(T+x+y)<Ω(T).
```

Power witnesses are projected away. The certificate counts distinct
geometric edges `{x,y}`, so exponent multiplicity cannot inflate coverage or
abundance.

At q17, `H` has order 18. Every admitted edge absorbs immediately to
`Ω=0`, but overload-zero is not a value theorem: six targets satisfy the
structural copycat boundary and are P, while eight are N. At q19, `H` has
order 10; the target overload histogram is

```text
Ω=0: 7 edges,
Ω=1: 3 edges,
Ω=2: 1 edge,
```

yet only two of the eleven targets are P. Neither torus orbit membership nor
rank descent proves the target safe.

## Exact q17 isolate failure

The terminal-reply graph at a q17 repair target has 22 isolates. Relative to
the history-torus relation they split as:

```text
8  isolates have at least one P orbit edge;
7  isolates have orbit edges, all N;
7  isolates have no orbit edge.
```

This is stronger than a failed deterministic selector. The entire cyclic
correspondence misses seven obligations and is unsound on seven more. Adding
all powers, allowing both orientations, and eliminating exponent gauge does
not repair it.

All four coordinate copies give the same counts. For the representative,
the full Klein-four transport sends the 14 projected edges through `56/56`
matching transported edges. At q19 the corresponding check is `44/44`.
The generators themselves satisfy

```text
H(g o,g p)=g H(o,p) g^-1
```

for all eight tested stabilizer elements.

## Review of the later-results snapshot

The read-only snapshot
`notes/2026-07-26-results-summary-snapshot.md` contributes two useful
structures and several guardrails.

### Full continuation complex: exact language for the isolate locus

For a selected cap `K`, the full continuation complex has minimal nonfaces
of two kinds:

1. pair conflicts on tangents through a selected point; and
2. collinear triples on lines avoiding `K`.

Therefore the terminal-reply graph used in this C80 thread has an exact
intrinsic description:

```text
its edges are the maximal two-element faces of the continuation complex.
```

A terminal-graph isolate is a legal vertex contained in no maximal
two-element face. In the snapshot's tangent-code coordinates, a legal pair
`x,y` has no tangent-coordinate agreement, and terminality means every third
legal codeword is killed either by a tangent agreement with `x` or `y`, or
by the triple line `xy`. This is the correct algebraic coverage object. The
continuation graph alone is insufficient because it forgets the triple
minimal nonfaces; the full complex is required.

This reframes the next q17 task cleanly. Instead of searching another orbit
selector, describe the 22 isolates as a marked maximal-face/coverage locus
in tangent tuples plus the line `xy`, then seek a bounded algebraic rewrite
of that locus.

### Matching quotient: a possible intensional proof carrier

Clebsch Paper II's quotient

```text
(P_M-P_M0)/Q
```

stores a matching of marked conic points as a bounded-degree algebraic
configuration, with four-endpoint Plücker switches giving direct updates.
This is exactly the anti-packing pattern C80 needs: carry a pairing
obligation without listing `Θ(q)` edges or choosing a matching gauge.

It is not yet a C80 theorem. The current response pairing lives on the full
legal-move locus, including intruders, while the Clebsch quotient directly
encodes matchings of conic points. It becomes applicable only if the marked
continuation-complex obligations can be pushed to conic secant factors—for
example through the intruder-induced conic involutions. The correct next
test is that bridge, not importing the quotient by analogy.

### Guardrails from the snapshot

- The tangent-code model is exact and canonical, but distance data alone
  omit triple conflicts. Use the full continuation complex.
- Four-frame semilinear rigidity at q17 removes coordinate ambiguity, but it
  does not prove response soundness.
- The robust-completion collision identities may later count candidate
  redundancy, but they are static abundance tools; they cannot replace the
  C80 P-certificate.
- Cubic orientation is the first surviving memory in the Clebsch matching
  quotient. It suggests that a linear or quadratic state profile may be too
  weak, consistent with the earlier C80 profile collisions, but supplies no
  direct value classifier here.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_history_torus_obligation_rewrite.py
python3 rust/scripts/c80_history_torus_obligation_rewrite.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_history_torus_obligation_rewrite.py` | 13,224 | `6a1e005cd4aa962ab628c6c92b1185a15557563e9e260ff8fc4926a8bd029d00` |
| `notes/2026-07-25-c80-history-torus-obligation-rewrite.json` | 34,095 | `f22699f8d2df1eecd8054bec8ed4bc7f139fddad97d84e2b2d36aa1cf5249b0c` |

The generator enumerates every legal move and every power of the marked
history generator, projects power witnesses to distinct reply edges, and
records exact finite values. On every tested orbit image, engine pair
legality is independently compared with direct projective determinants.
Canonical generator conjugacy and the complete projected relation are
recomputed under the full selected-six-set stabilizer.

Exact P/N values, `Ω`, and copycat-survivor membership retain the established
normalized-grid trust boundary. There is no second full game solver. The
searched domain is exactly the four q17 repair targets and marked q19
control, not all history edges or other odd orders.

The JSON is canonical sorted data. `--check` regenerates it in a temporary
directory and requires byte equality.

## `ej` + `tt` closeout

The cheap `ej` upgrade projected away exponent witnesses, audited exact P/N
on every edge, separated the q17 isolate population into `8+7+7`, and added
q19 as a cross-order control. This closes three possible rescues at once:
choose another torus power, retain all powers, or treat the power as proof
data. None gives opponent completeness or purity.

The snapshot review supplies the unexpected positive residue. The q17
terminal graph is not an ad hoc diagnostic: it is the maximal-edge graph of
the full continuation complex. This gives a canonical algebraic target for
the isolate locus and explains why pair-conflict or tangent-code data alone
were incomplete—the triple minimal nonfaces are load-bearing.

The Tao-style correction is to stop asking a group orbit to *be* the
strategy. History should instead carry an intensional algebraic proof object
that updates under local switches. The Clebsch Plücker quotient is a credible
model for such a carrier only after a bridge from full legal-move
obligations to conic secant matchings is proved. The highest-EV next scout is
therefore a bounded bridge test on the q17 `K2` plus ramified tree: can its
nonisolated reply edges and 22 isolates be recovered from tangent-code/triple
coverage together with one conic-matching quotient?

No incidental discovery-track item arose. The snapshot intake is directly
responsive to the active C80 proof-object search.

## Mystery ledger

- **[SETTLED negative] Does the marked cyclic torus cover the q17 isolate
  locus?** No: only `15/22` isolates have any edge.
- **[SETTLED negative] Are its admitted q17 edges sound?** No:
  `6 P + 8 N`; only eight isolates touch a P edge.
- **[SETTLED negative] Does q19 improve the schema?** No: `20/51` moves are
  covered and the edge split is `2 P + 9 N`.
- **[SETTLED] Is the failure caused by power gauge or normalization?** No.
  Powers are projected to geometric edges, and all conjugacy/transport checks
  pass.
- **[SETTLED snapshot intake] What intrinsic object is the terminal-reply
  graph?** The graph of maximal two-element faces of the full continuation
  complex.
- **[SETTLED snapshot intake] Can the continuation graph alone recover it?**
  No. Collinear-triple minimal nonfaces are essential.
- **[OPEN — C80] Can tangent-code plus triple-line coverage define the q17
  isolate locus by bounded algebraic equations?**
- **[OPEN — C80] Can the Clebsch secant-product quotient encode the resulting
  pairing obligation without an explicit edge list?** Only after a bridge
  from legal-move obligations to conic matchings.
- **[OPEN — C80/C82 gate] Can that proof datum update locally and remain
  opponent-complete?** Unknown; C82 remains gated.

## Vibe

The history-torus idea fails cleanly, but the snapshot review upgrades the
next target from “find a clever rewrite” to a specific algebraic bridge:
maximal faces of the continuation complex into a Plücker-updatable conic
matching carrier.

go C80 cap test the continuation-complex-to-conic-matching bridge on the q17 obligation tree
