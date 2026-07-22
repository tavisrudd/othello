# C462 — `Z/4` Galois-torsor structure of the four M3 companions

**Context:** parallel and non-blocking; must not displace a battery-chain slot. C443/C461 proved the
sharp M3 negatives; the exploratory memo
[`../2026-07-21-c443-torsor-hunch-check.md`](../2026-07-21-c443-torsor-hunch-check.md) then confirmed
computationally that the four companion orbits carry a `Z/4` Galois-torsor structure equivariant
with the four primes of `Z[zeta_5]` above 11. This card promotes that memo to a certified evidence
bundle and states the descent obstruction as a theorem.

## Inputs

- C443 report, checker, and JSON (frozen companion labeling, reduction table, discrepancy hashes)
- C461 report and JSON (descended weight lattice, lower-moment ranks)
- the torsor hunch memo and its scratch scripts (recompute; do not cite scratch as evidence)
- C458 golden-sheet freeze; C440 conventions
- C448 report only for the selector/one-bit framing sentence
- C459, if closed by then, read-only for the `Q`-form/Hilbert-90 language; C462 must not block on it

## Task

Certify, under the frozen conventions:

1. `sigma: zeta_5 -> zeta_5^2` maps the golden 12-point configuration to a projectively equivalent
   conic point-set, with the correcting projectivity well-defined exactly up to the order-60 golden
   `A5` normalizer;
2. the induced companion permutation is canonical (independent of the correcting map), is a
   4-cycle, and squares to the frozen `kappa = (0 3)(1 2)`;
3. the companion-to-residue reduction bijection intertwines that 4-cycle with `z -> z^2` on the
   residues `{3,4,5,9}` mod 11, up to the orientation ambiguity, and sends `kappa`-pairs to the
   residue pairs `{3,4}` and `{5,9}`;
4. the degree-1 pair-average discrepancy vector is identical on both `kappa`-pairs, hence
   Galois-invariant.

Then state the two consequences exactly: the equivariant sheet assignment defines one object over
`Z[zeta_5, 1/N']` for an explicit denominator set `N'`, and its descent to `Z[phi]` is obstructed
precisely by the free `kappa`-action — the obstruction M3a measured. Phrase the candidate
replacement for paper 1's cut tensor clause (base-changed statement plus proved obstruction) as a
recommendation for C445/Phase 3; do not edit the manuscript.

Boundaries: no CRT interpolation beyond the equivariant statement, no new weight-line search (C461
closed it), no claim that the induced rank-4 module satisfies any M3a acceptance item. A failed
recomputation of any memo claim is a stop-and-report blocker, not a repair.

## Acceptance

Canonical JSON must contain: the sigma-image vertex correspondence and correcting-map count; the
canonical companion 4-cycle and its square; the companion-to-residue table with sheet labels and
golden primes; both pair discrepancy vectors with hashes tied to the C443 JSON; and the exact
`Z[zeta_5, 1/N']` statement data. Standard bundle: dated report, checker, JSON, checksum manifest,
independent replay.
