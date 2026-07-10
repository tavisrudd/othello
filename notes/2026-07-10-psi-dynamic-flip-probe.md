# C69 follow-up: Psi as a dynamic discriminator of the arc-depleted flip (negative)

Date: 2026-07-10 (Claude).  Fable steering correction 3.

## Motivation

All three Cluster-1 mechanism candidates (C55 group-side, C64 extremal-side, C69 algebraic-side)
returned negative on *static* invariants of the 6-point on-conic configuration.  C64's own finding —
"the value lives in the full tree, not the terminal layer" — argues the flip mechanism is *dynamic*.
The C63 amortized potential `Psi = reservoir_slack + 6·defect_components − 4·interface_intruders −
2·[conic_xor=0]` is the program's only *validated* dynamic quantity, and it postdates all three dead
candidates (the "levers compound" rule: re-test gated levers after a new instrument lands).  So:
does `Psi`, or any of its components, discriminate the flipping configs from matched controls where
the static invariants could not?

## Method (convention-safe)

New solver mode `s4potentialprobecells <q> r,c …` (commit `4a32a80`) computes the `Psi` feature
vector from the **actual on-conic board cells** of a config — it fits the conic through the arc and
transports it to the root hyperbola `xy=1` internally (affine grid symmetry; `Psi` is
PGL-invariant), so no external param-convention translation is trusted.  Calibration: the `xy=1`
root `{1,2,3,4}` given as cells reproduces `s4potentialprobe` exactly (`c63_candidate=96`), and the
q=19 corpus config `(0,0),(1,1),(2,3),(3,9)` transports to params `[15,16,17,18]` → `96`.

`rust/scripts/c69_psi_flip_probe.py` reuses the C55 corpus/`value_table`/`cohorts` machinery, then
per depleted/full pair computes `Psi` and each component at `qd` and `qf` for the flip cohort
(N@`qd`, P@`qf`) and the control cohort (same value at both), and asks whether flip and control
occupy **disjoint ranges** on any order or on the per-config jump `delta = Psi(qf) − Psi(qd)`.

Pairs and cohorts (from the C55 corpus): `11/13` flip=11 control=17; `17/19` flip=100 control=30.

## Result — NEGATIVE

The only disjoint-range separations are:

| pair  | feature                 | where       | flip vs control            |
|-------|-------------------------|-------------|----------------------------|
| 17/19 | `c63_candidate` (Psi)   | q17 only    | `[85,86]` vs `[82,84]`     |
| 17/19 | `reservoir_slack_total` | q17 only    | `[15,16]` vs `[12,14]`     |
| 17/19 | `zone_v`                | q17 only    | `[93,94]` vs `[90,92]`     |

Every other feature/order/pair overlaps.  In particular:

- **The coupled/dynamic core of `Psi` does NOT separate at all.**  `defect_components`,
  `interface_intruders`, and `conic_xor_zero` are byte-identical between flip and control at every
  order and pair (e.g. q17: defect=12, intruders=0, xor_zero=1 for both cohorts).  The separation
  lives entirely in the reservoir/zone **size** term.
- **The separation is value-confounded, not flip-specific.**  Every control is `P@qd` (there is no
  config that is N at a depleted order and non-flipping — stable-N does not occur here), so the q17
  split is N-flip vs P-control at a single order — the *within-order* N-vs-P size correlate C55
  already reported ("N children carry MORE than P within an order"), not a cross-q dictionary.
- **It does not survive the value-neutral tests.**  No separation on the per-config jump `delta`
  (flip and control jump by the same amount: Psi +12, zone +42), and none at `qf` where *both*
  cohorts are P.  A genuine flip mechanism would show at `qf` or on `delta`; a value correlate
  shows only at the order where the values differ.
- **It does not reproduce across pairs.**  The `11/13` pair shows NO separation on any feature at
  any order — the same "q=11 is the smallest arc-depleted order, its invariants disperse" pattern
  that dissolved the C64/C69 near-hits, here as a value correlate too weak to resolve at q=11.

## Verdict

`Psi` does **not** encode the arc-depleted dichotomy.  The negative extends from the static
invariants to the program's dynamic ledger: even the coupled potential, evaluated as a snapshot on
the config, carries no flip-specific signal — its only discriminating term is a size proxy for the
qd value.  This hardens the A5-only conclusion (Cluster-1 mechanism search de-prioritized in favor
of the q-dependent A5 arc-depletion arithmetic).

Scope, kept explicit (this is a *snapshot* dynamic test, not a full trajectory): `Psi` here is
evaluated on the config's root S4, not integrated along optimal play — the corpus lacks Grundy
dumps for these 100+ roots, so a full `Delta Psi`-along-play trajectory is not available without
solving each.  The snapshot already shows the coupled features are flip-blind; a trajectory test
would be the stronger form if a batch of these roots is ever solved.  Re-entry condition for
Cluster-1 (per the queue/handoff) is unchanged.

Artifacts: `rust/scripts/c69_psi_flip_probe.py`, solver mode `s4potentialprobecells` (`4a32a80`).
