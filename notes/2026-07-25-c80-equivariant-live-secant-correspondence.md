# C80 — equivariant live-secant reply correspondence

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.

## Verdict

One projectively natural bounded-degree reply correspondence has been tested
and rejected as the C80 proof object.

For a selected six-set `S`, marked opponent `o`, and jointly legal strict
overload reply `p`, admit `(o,p)` when

1. `o` and `p` are off-conic and their joining line is external to the
   distinguished conic; and
2. there are two distinct conic points still legal after `S+o+p` whose chord
   contains `p`.

Equivalently, the conic involution induced by `p` retains at least one
two-cycle on the live conic. This is one bounded-degree incidence schema:
conic membership is quadratic and the chord condition is a collinearity
determinant. It stores no matching, exception list, or coordinate selector.

The relation contains all five certified repairs and commutes exactly with
the full order-four stabilizer at q=17 and q=19. Edgewise soundness nevertheless
fails sharply:

| domain | projected fibre degree | P replies | N replies |
| --- | ---: | ---: | ---: |
| each of four q17 Klein-four marked fibres | 23 | 1 | 22 |
| marked q19 control fibre | 47 | 39 | 8 |

At q=17 the unique P edge in each 23-edge fibre is exactly the known
`Ω=40` repair. At q=19 the known `Ω=169` repair is one of 39 P edges, but
eight edges satisfying the same correspondence are N. Thus the candidate
passes the transport/naturality gate and fails the nonrecursive-soundness
gate. It cannot be released to C82 for abundance counting.

## Correspondence and transport check

Write `L(S,o,p)` for the conic points legal after the exchange. The tested
relation is

```text
R_live(S,o,p) :=
  joint legality
  ∧ Ω(S+o+p) < Ω(S)
  ∧ line(o,p) external
  ∧ ∃ u≠v ∈ L(S,o,p), collinear(u,p,v).
```

Every clause is invariant under projective transport preserving the conic,
and the last clause is a relation rather than a chosen reply. The certificate
also checks naturality computationally rather than relying on that observation
alone.

For the normalized six-set

```text
{∞,0,-1,-2,-3,-4},
```

the full conic-set stabilizer has order four at both tested orders. At q=17 it
transports the representative marked opponent `(4,0)` through exactly

```text
(4,0), (5,0), (8,14), (11,9),
```

and maps the complete 23-reply fibre bijectively onto the recomputed fibre at
each mark: `92/92` transported edges agree. At q=19 it produces four marked
fibres and gives `188/188` agreeing transported edges. Hence the losing edges
cannot be removed by changing normalized coordinates or by retaining all
stabilizer-symmetric choices instead of selecting one.

The projected degrees `23` and `47` count distinct geometric replies, not
proof-data representations. No gauge multiplicity is present.

## Exact finite result

The four q17 fibres have identical value histograms:

```text
R_live fibre = 1 P + 22 N.
```

The stabilizer transports the unique P reply through the four known repairs

```text
(4,0)  -> (7,1)
(5,0)  -> (4,10)
(8,14) -> (4,10)
(11,9) -> (7,1).
```

This is a stronger negative than failure to select the repair uniquely. The
relation admits the repair equivariantly, but nearly every other symmetric
choice is an exact losing reply.

For the q19 control

```text
root {15,16,17,18}, opponent (4,0),
```

the relation has degree 47 with value split `39 P + 8 N`; the certified
reply `(0,2)` is present. The improved P density does not repair soundness:
C80 requires every accepted edge to carry a direct lower-ranked proof datum,
whereas these eight N edges cannot carry any sound P certificate.

The searched domain is exactly the four q17 marked fibres in the
Klein-four defect orbit and the one normalized q19 marked control fibre,
plus the stabilizer transports of the representative fibres. This is not a
q19 root census and proves no statement for other odd orders.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_equivariant_live_secant_correspondence.py
python3 rust/scripts/c80_equivariant_live_secant_correspondence.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_equivariant_live_secant_correspondence.py` | 9,272 | `5c8a200983f50a97a6034b8706dc3b3c2117eb71c376e37e2f4764b7115d8783` |
| `notes/2026-07-25-c80-equivariant-live-secant-correspondence.json` | 35,578 | `a235a2932f2ba5935a9e838f8a4a44391668cd1c051d757fcfa47bdf101a8124` |

The generator enumerates the complete strict-external reply domain in each
marked fibre and records every accepted geometric reply. Exact P/N values use
the established normalized prime-grid solver. There is no second complete
projective-plane game implementation in this bundle.

Two independent checks cover the new content. First, on the entire searched
strict-external domain, the conic-involution test for a surviving two-cycle
is required to agree with a direct projective determinant test for a live
chord. Second, the reply relation is transported by every element of the
full selected-six-set stabilizer and compared with a fresh recomputation at
the transported marked opponent. Both checks pass exactly. The finite values,
`Ω`, and the q19 control retain the trust boundary of the imported C80
certificates.

The JSON output is canonical sorted data. `--check` regenerates it in a
temporary directory and requires byte equality.

## `ej` + `tt` closeout

The cheap `ej` upgrades were the full projected-fibre value audit, the
determinant-level replay of the defining equation, and full stabilizer
transport rather than checking only the five named repair edges. They turn a
mere numerical fit into a clean falsifier: the schema is genuinely intrinsic,
contains every target repair, and still accepts losing edges.

The q17 packet has an unexpected sharp shape. Its unique P edge is the repair,
so `R_live` is an equivariant *carrier* of the desired reply but not a sound
reply correspondence. At q19 the same carrier becomes P-dense without becoming
pure. This makes the missing object more precise: a successor needs an
additional proof-producing algebraic datum that distinguishes the q17 unique
edge while excluding the q19 eight N edges. Merely retaining a live conic
secant is too weak.

The Tao-style lesson is that equivariance is not the hard gate here. This
candidate clears normalization, stabilizer, projected-counting, and
anti-selector concerns, yet fails game semantics immediately. Increasing
fibre degree to respect symmetry is useful only after edgewise soundness is
proved. C82 therefore remains gated; it must not count the 23 or 47 carrier
edges.

No incidental discovery-track item arose. The carrier-packet observation and
its failure are direct C80 deliverables.

## Mystery ledger

- **[SETTLED] Does one natural equivariant correspondence contain all q17 and
  q19 repairs?** Yes. `R_live` contains all five.
- **[SETTLED] Does it commute with projective transport?** Yes: `92/92` q17
  and `188/188` q19 transported edge checks agree over the full order-four
  stabilizers.
- **[SETTLED] Is its projected degree inflated by proof-witness gauge?** No.
  The degrees `23` and `47` count distinct reply points.
- **[SETTLED negative] Is every accepted edge sound?** No. Each q17 fibre has
  22 N edges and the q19 control has eight.
- **[SETTLED `ej`] Is the q17 repair at least isolated by value inside the
  carrier?** Yes. It is the unique P edge in each 23-edge fibre, but value is
  not a nonrecursive defining equation.
- **[OPEN — C80] What bounded algebraic proof datum cuts the live-secant
  carrier down to sound edges?** The evidence gap is a direct rank update or
  obligation rewrite distinguishing the unique q17 repair and excluding the
  eight q19 N edges without calling minimax or `F_cc`.
- **[OPEN — C80/C82 gate] Can a sound subcorrespondence remain
  opponent-complete uniformly?** Unknown. No abundance claim is licensed by
  this test.

## Vibe

This is a clean negative with real diagnostic value: symmetry and transport
work exactly as hoped, but the game-value gate fails overwhelmingly at q=17.
The search should now focus on proof-producing rank transport, not on making
the reply packet more equivariant or larger.

go C80 cap construct a nonrecursive rank-carrying subcorrespondence of the live-secant carrier
