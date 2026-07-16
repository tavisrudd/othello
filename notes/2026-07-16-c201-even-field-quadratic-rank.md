# C201 — even-field quadratic-rank structural upgrade

**Lane:** `relconic`

**Date:** 2026-07-16
**Status:** REPORTED — negative bounded gate; no infinite theorem promoted

Incidental observations are logged append-only in
[`2026-07-16-c201-discovery-track.md`](2026-07-16-c201-discovery-track.md).

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

The first such probe is closed in
[`2026-07-16-c201-q64-baer-family.md`](2026-07-16-c201-q64-baer-family.md).
All 207,144 Frobenius-stable thirteen-arcs obtained by adjoining two
conjugate pairs to the `GF(8)` subfield conic have full quadratic rank, but
their ordinary-uncovered loci have size 860–949.  Their rank is therefore
forced by the elementary `2q+1` quadratic point bound, and none can be
complete outside a 65-point conic.

**Refined next:** restrict every further family to the necessary prefilter
`|U(A)|<=65`.  Seek an orbit-defined high-coverage/saturating thirteen-arc
family; reject it before quadratic analysis if it fails this filter.

The conic-aligned transitive family is also closed in
[`2026-07-16-c201-q64-torus-family.md`](2026-07-16-c201-q64-torus-family.md).
Of the 315 conic-disjoint length-thirteen orbits of an order-13 nonsplit-torus
subgroup, 310 are arcs and all have the identical spectrum
`(1041,1560,1326,208,0,0,13)`.  The conic nucleus is uncovered in every case.
Thus a single exact-size conic-stabilizer orbit cannot supply the required
high-coverage family.

**Refined next:** the Baer/Frobenius and transitive torus families are both
closed.  Any remaining bounded route must use a union of smaller stabilizer
orbits while preserving total size thirteen and must prove or cheaply certify
coverage of the conic nucleus before full profile or rank work.

The first smaller-orbit shape is sized in
[`2026-07-16-c201-q64-z3-sizing.md`](2026-07-16-c201-q64-z3-sizing.md).
The nucleus plus four split-`Z3` orbits has more than 43 billion
pairwise-compatible orbit quadruples before mixed-orbit collinearity checks,
and more than 57 million even after the full normalizer bound.  Full union
enumeration is rejected.

The symbolic mixed-orbit condition is the nine-factor determinant norm
`F(P,Q,R)` recorded in the sizing report.  Pairwise compatibility plus
nonvanishing of `F` on the four orbit-label triples is exactly the full arc
condition.

The ternary relation is now indexed in
[`2026-07-16-c201-q64-z3-index.md`](2026-07-16-c201-q64-z3-index.md).
For each compatible orbit pair, the bad third labels are exactly the legal
orbits meeting its nine mixed secants, so `F=0` is one bitset lookup.  The
730,380 pair indices forbid only 171--179 of 1,302 labels each.  A deterministic
100,000-arc-draw probe found ordinary-uncovered sizes 824--1,055, far above the
necessary bound 65, but this is evidence rather than an exhaustive exclusion.

The coverage-directed probe is recorded in
[`2026-07-16-c201-q64-z3-coverage.md`](2026-07-16-c201-q64-z3-coverage.md).
Exhaustive one-orbit descent from 500 deterministic starts produced local
optima with ordinary-uncovered sizes 805--935; nine starts reached 805.  The
best checked result remains 740 points above the necessary gate, so quadratic
analysis was skipped.  This is strong bounded evidence, not a global family
exclusion.

The final synthesis is
[`2026-07-16-c201-bounded-mechanism-closure.md`](2026-07-16-c201-bounded-mechanism-closure.md).
C201 closes as a failure of the tested bounded natural-family mechanisms, not
as a theorem excluding the split-`Z3` family.  The best checked split-`Z3`
witness is one- and two-orbit locally optimal at `|U|=805`; a three-orbit
neighborhood is no longer cheap.  The `q=64` obstruction is
coverage/saturation before quadratic rank becomes informative.  C209 remains
gated; C210 inherits this conclusion only as negative construction guidance.

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
