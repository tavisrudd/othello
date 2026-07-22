# C80 — game-side bulk-mechanism probe (exhaustion / abundance / descent)

**Date:** 2026-07-12. Lane: game-side attack on the C79 bulk-quotient spec ("compress
many genuinely active, edge-disjoint intruder matchings behind a bounded interface").
Companion measurement: [C83 bisimulation quotient](2026-07-12-c83-bisimulation-quotient.md);
the residual-graph structure: [conic-involution residual graphs](2026-07-12-conic-involution-residual-graphs.md).

Design rule (from the queue): tune the generic mechanism on **nondepleted** orders
(q=13/19) and treat depleted q=11/17 as certificate territory.

## (c) Drain resource — the conic move as closed-neighborhood removal

Conic-only play is Node-Kayles on the live-conic graph `G_live` (join `u,v` when a selected
center lies on chord `P_u P_v`), so selecting a live point `t` removes exactly its closed
neighborhood. Stated in game coordinates for use as a descent resource:

Let `S` be a legal residual position, `I(S)` its off-conic centers, `L(S)` the live conic
parameters. Center `x` induces the involution `σ_x` on the conic (`σ_x(s)=t` iff `x ∈ P_s P_t`;
tangent points fixed).

**Exact drain.** Selecting a live point `t` deletes exactly `1 + k_t(S)` live conic points,
where `k_t(S) = #{x ∈ I(S) : σ_x(t) ≠ t, σ_x(t) ∈ L(S)}` is the number of centers active at
`t`. *Proof.* `t` leaves `L`; a live `u ≠ t` leaves iff the chord `P_t P_u` gains a second
selected point besides the new `P_t` — necessarily an off-conic center `x` with `σ_x(t)=u`.
The dying points are `{σ_x(t) : x active at t}`, and these are distinct: a coincidence
`σ_x(t)=σ_y(t)` (`x≠y`) would put two centers on chord `P_t P_{σ_x(t)}`, saturating it (cap
capacity 2) and making `t` illegal, contradicting `t` live. So the count is `1 + k_t`. ∎

This is the capacity-2 Node-Kayles move specialized to the conic; the residual→Node-Kayles
transition itself is Huggan–Huntemann–Stevens. What it gives the program:

- **`|L(S)|` is a computable well-founded measure**, dropping by `1 + k_t` per conic move
  (`|L| ≤ q+1` at the root). It supplies an induction order and proves termination — but not
  value: absent a value invariant/parity/uniform bound it discharges nothing about who wins.
  It is scaffolding for (b), not a theorem.
- **The drop grows with the number of active centers at `t`**, feeding the global edge-density
  bound `|E(G_live)| ≥ Σ_x max(0, (q+1−f_x)/2 − d)` (`d` = dead conic points) — the raw
  material for a minimax exhaustion potential.
- Matches the observed play: C79's score-9 states are the `|L| = 1` regime, where one conic
  move drives `|L| → 0` (all four score-9 base candidates kill the conic).

### Verification

`rust/scripts/c80_drain_rate.py` BFS-enumerates all legal residual positions up to a size cap
and checks, exhaustively over every (position, live conic point): the exact drain
`|L(S)| − |L(S∪{P_t})| = 1 + k_t`, the distinctness of live partners, and the ≤1-shared-edge
bound between two centers. **q=11, all positions up to size 6** (4,799,063 positions with a
center and a live conic point; 7,024,950 checks): all three hold with zero exceptions.
Active-center degree per live point `{0:4204720, 1:2160160, 2:597060, 3:62030, 4:980}` (max 4);
per-move drain is this distribution shifted by 1.

## (a) Abundance profile — PLANNED

Per (root R, opponent move x) at nondepleted q (13/19): winning-reply fraction, and whether
the winning set contains an entire bounded-condition packet (all D-generic on-conic replies
minus an explicit bad-fiber list). Target theorem shape: at nondepleted q **every** packet
member wins — existence by counting, no selector.

## (b) Descent / class preservation — PLANNED

Which lexicographic residual measure some winning reply always strictly decreases
(candidates: conic defect type, `|live conic|`, edge-density budget `Σ_x max(0,(q+1−f_x)/2−d)`,
zone complexity); and whether some winning reply re-enters the balanced/normal-form class. The
exact drain makes `|live conic|` a validated component of any such measure; the missing step
is upgrading a greedy drain move to a minimax potential.

## 2026-07-22 — C447/C460 cloud packet: exact partial `12+5+5` law

C447's two matchings are nonconcurrent, so they are not themselves cap moves or global reply maps.
C460 supplies the type-correct point object: each matching has a 15-point Frégier cloud of interior
points, and the clouds of C447's shared-edge cross-sheet pair meet in exactly five points.
Transporting that intersection through C447's certified projectivity gives a canonical five-cell
off-conic packet at each q=11 knife edge:

```text
class 4: {(4,10),(5,6),(6,2),(7,9),(8,5)},
class 7: {(2,10),(5,2),(6,3),(9,6),(10,7)}.
```

The exact game test covers both endpoints of both P edges, hence all four pointed representatives.
Every representative has 22 legal opponent moves and the identical packet-reply distribution:

| opponent branches | legal packet replies | P-valued packet replies |
|---:|---:|---:|
| 12 | 0 | 0 |
| 5 | 2 | 0 |
| 5 | 2 | 2 |

The square `C5` kernel of the cap-frame `D10` partitions the 22 opponent moves into orbit sizes
`1,1,5,5,5,5`.  The five good branches and five live-but-bad branches are whole `C5` orbits; the
twelve packet-killing branches are two further five-orbits plus the two fixed moves.  Thus the
cloud packet is not a winning strategy and does not complete C80(a), but its failure is highly
structured: whenever the packet is live, its two surviving replies have the same value, and the
good/bad distinction is exactly orbit-valued rather than a hidden orientation choice.

There is an exact quotient explanation.  Send the unordered P-edge endpoints `a,b` to
`0,infinity` by `t=(w-a)/(w-b)`, and write an opponent point in the induced conic coordinates as
`[X:Y:Z]`.  The quantity

```text
u = XZ/Y^2
```

is independent of rescaling `t` and of exchanging `a,b`, hence is intrinsic to the unordered edge.
On all four pointed states the branch law is

```text
u = 8 (nonsquare): two packet replies, both P,
u = 9 (square):    two packet replies, both N,
u in {0,1,∞}:      no packet reply remains legal.
```

Thus C449's split-torus Legendre blocks become literal game information: the two live `C5` orbits
are separated by square class on the one-dimensional edge quotient.  This is stronger and simpler
than the provisional cubic separator suggested by the raw `5+5` split.

The `ej` closeout then evaluates the complete first-response relation, not just the five-point
packet.  On the 22 legal opponent moves, join `x,y` when the pair is legal over the chosen P child
and the resulting size-six grandchild is P.  In every one of the four pointed states this graph is
connected with 22 vertices, 41 edges, degree histogram

```text
1^1 2^10 4^5 6^1 7^5,
```

and exactly **two** perfect matchings.  The quotient edge counts are

```text
0--infinity: 1,   1--1: 10,   1--8: 5,   1--9: 5,
1--infinity: 5,   8--9: 5,    8--infinity: 10.
```

The two perfect matchings share six forced edges: the unique `0--infinity` edge and the five
`1--9` edges.  Their symmetric difference is the 10-cycle between the cloud packet at infinity
and the good `u=8` orbit; its two alternating matchings are the only remaining choice.  Equivalently,
the formerly killed conic boundary `u=1` is exceptionally generous: after any of its five moves,
all four other `u=1` moves are legal P replies.

The symmetry action identifies exactly what the residual binary choice means.  The square `C5`
kernel fixes each perfect matching separately, while every nonsquare element of the cap-frame
`D10` swaps the two P-edge endpoints and swaps the two matchings.  Hence the response rules form a
two-point calibration torsor: choosing one costs the same orientation bit obstructed in C448, but
the unordered response correspondence—and therefore P-existence—needs no such choice.

### Orbital proof compression

The `C5` action gives a shorter proof of the matching statement.  The 22 vertices are two fixed
points and four free five-orbits, labelled by the edge quotient as

```text
0[1], infinity[1], 1[5], 8[5], 9[5], infinity[5].
```

The 41 winning edges split into one fixed edge and eight five-edge `C5` orbitals.  Every perfect
matching contains the fixed `0[1]--infinity[1]` edge and the unique `1[5]--9[5]` orbital.  The
remaining ten vertices support exactly two `8[5]--infinity[5]` orbitals.  Their union is the
10-cycle, and each orbital separately is a perfect matching.  Thus matching existence follows
from the group action without enumerating all matchings; enumeration is retained as an independent
check.

This exposes a reusable C80 lemma.  If a finite group acts transitively on equal-size opponent and
reply orbits and the value-correct response relation is invariant and nonempty, its bipartite
orbital graph is regular on both sides and has a perfect matching by Hall.  For free equal torsors,
a single edge orbital is already an equivariant bijection.  Consequently the generic task is not
to select a reply: it is to prove that one equal-orbit response relation is nonempty and P-pure.
C449 supplies the torus orbits, C452 supplies difference-set/intersection-number technology for
their edge counts, and C82 can own the eventual character-sum abundance bound.

For the P-value theorem even that is stronger than necessary.  If `H` stabilizes a parent state,
take one representative `x` from each `H`-orbit of opponent moves and exhibit one legal descending
P reply `y` after `x`.  For `x'=h x`, the transported move `h y` is a reply with the same value;
neither a well-defined transporter nor injectivity among replies is required.  Thus P-purity of an
edge orbital follows from one representative by value invariance, and equal orbit sizes/Hall are
needed only when one wants a fixed pairing certificate.

At this q=11 gate the 22 opponent moves form six `C5` orbits.  Their quotient winning graph has a
unique minimum three-relation cover

```text
0[1]--infinity[1],  1[5]--9[5],  8[5]--infinity[5].
```

The last relation has two edge-orbital lifts, producing the two perfect matchings.  Therefore the
two-match calibration torsor is extra certificate structure: the P proof itself consists of only
three orbit-representative response checks.

The uniform caveat is decisive.  Here `C5` genuinely stabilizes the pointed parent.  A generic C80
state may have trivial stabilizer, so its opponent branches do not collapse this way.  The
generalization must either produce a genuine symmetry of the bounded interface or work covariantly
over a family of normalized states and prove the response fibre nonempty for every parameter.
Merely observing torus coordinates or an association scheme does not create a game symmetry.

Nor can an aggregate parity or Fourier sum replace the representative P checks.  Such a count may
prove that a candidate orbital fibre is nonempty; normal-play recursion still requires an actual
P-valued reply after every opponent orbit.  Character sums address abundance, while C80(b)'s
descent induction supplies value.

There is no intrinsic QR label on the two q=11 connection orbitals.  Writing their offsets requires
a generator of `C5`; inversion preserves the square class of their separation, but the roof Galois
change `g -> g^2` swaps square and nonsquare.  Thus QR coordinates are useful after a frozen
Coxeter calibration, while the cap theorem should retain only the generator-free facts: two
distinct nonempty orbitals and one connected 10-cycle.

The two calibrations also have an exact homological reading.  Once the forced edges are removed,
their symmetric difference is the generator of `H_1(C10,F_2)`.  The C448 advice bit is therefore
the orientation of a one-dimensional cycle-space class at this q=11 gate.  This realizes the
C465/C471 kernel/image analogy locally, but does not yet prove that the much larger C80 residual
has bounded homology or that its cycle quotient carries game value.

Thus either perfect matching is a fixed first-ply response rule landing in certified P
grandchildren.  This corrects the interpretation of the earlier certificate audit: the emitted
reply book was not a node-zero matching, but that was never a proof that no such matching exists.
The new pairing is only a first-response compression; it does not claim that the same involution or
matching controls deeper nodes.

This is the first causal game information extracted from the C447/C460 bridge.  It refutes the
strong cloud-packet cover but replaces it with a complete q=11 first-response correspondence.
The sharper gate is now to generalize the edge-quotient/Legendre response graph beyond this H3
knife edge.  Cubic information may still be required once several noncommuting matching packets interact: C79's `tr(B^3)` separates
the generic score-9 tie after `tr(B^2)` fails, and C77's contextual `Q3` separates the last q17
feature twin.  But the single-packet q=11 gate is already quadratic.  A q-independent nonempty-
fibre count would feed C82; structured failures remain C81's characteristic-5/7 branch.

The primary checker uses the committed `PrimeGridGame` legality/value recursion.  The independent
replay rebuilds the residual grid rule directly from row, column, and affine-collinearity tests and
uses a separate normal-play recursion.  Both reconstruct the two 15-point clouds, their five-point
intersection, all four pointed states, every opponent branch, and the `C5` orbit partition.

## Reproduction

```bash
python3 -m py_compile scripts/c80_drain_rate.py
python3 scripts/c80_drain_rate.py 11 13 --maxsize 6
python3 rust/scripts/c80_c447_cloud_packet.py --check
python3 rust/scripts/c80_c447_cloud_packet_replay.py
sha256sum -c notes/2026-07-22-c80-c447-cloud-packet.sha256
```
