# C201 — even-field quadratic-rank structural upgrade

**Lane:** `relconic`

**Date:** 2026-07-16
**Status:** ACTIVE — Gate 1 closed; full `q=64` census rejected at sizing; orbit-family probe next

## Objective

Determine whether the `GF(16)` uncovered-quadratic obstruction is the first
case of an infinite even-field theorem.  A successful result must connect the
defect/incidence restrictions on a near-minimal complete-outside-conic arc to
one of the two evaluation alternatives:

1. the ordinary-uncovered locus imposes six independent conditions on
   quadrics; or
2. every quadric through that locus is forced to meet the arc.

The second alternative includes the rank-five/unique-quadratic anatomy of the
three exceptional `GF(16)` leaves.

## Existing infrastructure—do not reprove

- `EvaluationDichotomy.lean` gives the sharp finite-field avoidance theorem.
- `EvaluationObstruction.lean` supplies the injective/span formulations.
- `Q16QuadraticAvoidance.lean` and `Q16Result.lean` kernel-check the complete
  `2630 + 3` split and its relative-conic consequence.
- The defect and stability package bounds the candidate incidence profiles.

## Current result

Gate 1 and the `q=64` sizing gate are recorded in
[`2026-07-16-c201-gate1-q16-anatomy.md`](2026-07-16-c201-gate1-q16-anatomy.md).
The independent frozen-list analyzer reconstructs the three deficient leaves,
their quadratic types, intersections, stabilizers, orbits, secant spectra,
and defects.  They are exactly the three lowest-defect leaves; no full-rank
leaf shares either deficient index/defect cell.  The projectively invariant
kernel/restricted-evaluation formulation is explicit.

At `q=64`, the corrected lower-bound candidate is `k=13`, but a rigorous
frame-normalized counting lower bound already gives more than `10^18`
projective twelve-arc classes.  The full census is therefore closed by the
sizing stop condition.

**Next:** choose and test only a natural symbolic or group-orbit family at
`q=64`.  Do not generate arbitrary arcs.  Promote C201 only if that family
supports a field-uniform geometric criterion or gives a minimal falsifying
counterexample to the `q=16` low-defect mechanism.

The phrase “symbolic rank criterion” therefore means a **geometric criterion
for forcing rank/forced-hit behavior**, not the already-proved linear-algebra
dichotomy.

## Work plan

### Gate 1 — symbolic anatomy

- Express the quadratic kernel `K_A` and the restrictions `ev_a |_ K_A` in
  projectively invariant terms.
- Identify which defect/index statistics constrain `dim K_A`, and record
  counterexamples if those statistics alone do not determine it.
- Reconstruct the three rank-five `GF(16)` leaves and classify the unique
  quadratic by type, arc intersection, stabilizer orbit, and secant-index
  profile.
- Separate equality cells from first-excess cells relative to the corrected
  defect bound; do not use “stability” for an unclassified histogram.

### Gate 2 — q=64 sizing and falsification

- Compute the corrected lower-bound candidate size(s) before generating arcs.
- Estimate the frame-normalized search space and reject a full census if it is
  not credibly bounded.
- Test only symbolically reduced or orbit-defined candidate families first.
- Record ordinary-uncovered size, quadratic rank/nullity, forced-hit status,
  defect, index spectrum, and stabilizer data—not only relative completeness.
- Use an independent implementation and coordinate/relabel invariance checks.

### Gate 3 — theorem extraction

Promote only one of the following:

- an infinite even-field theorem;
- a theorem for a natural infinite family of candidate arcs;
- a structural equality/first-excess theorem explaining all deficient-rank
  cells; or
- a precise obstruction showing why the `GF(16)` mechanism cannot extend.

Any promoted mathematics must receive a strict-trust Lean statement.  Finite
orbit data may remain generated only when a small kernel checker validates the
complete implication used by the theorem.

## Stop conditions

- Stop a full `q=64` enumeration at the sizing gate if it is not bounded.
- Do not publish another isolated `rho_C(q)` value as the C201 outcome.
- Do not claim an even-field pattern from `q=16,64` alone.
- If rank is independent of all available defect/index invariants, report that
  separation explicitly and hand the resulting geometric feature to C209.

## Completion gate

Produce a replayable report with exact commands/hashes and either a proved
family route or a falsified mechanism with a minimal counterexample.  Only a
concise structural theorem is eligible for the current manuscript.
