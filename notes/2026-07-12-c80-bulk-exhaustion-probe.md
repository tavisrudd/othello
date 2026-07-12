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

## Reproduction

```bash
python3 -m py_compile scripts/c80_drain_rate.py
python3 scripts/c80_drain_rate.py 11 13 --maxsize 6
```
