# C201 closure — bounded even-field mechanism failure

**Lane:** `relconic`
**Date:** 2026-07-16
**Verdict:** negative bounded gate; no infinite-field theorem promoted

## Question and answer

C201 asked whether the exceptional `GF(16)` quadratic-rank anatomy is the
first case of an infinite even-field theorem for near-minimal arcs complete
outside a prescribed conic.

The bounded answer is negative at the mechanism level.  The `GF(16)` anatomy
is real and sharply classified, but every tractable natural `GF(64)` route
fails at coverage or saturation before it reaches a nontrivial quadratic-rank
test.  Consequently C201 supplies no evidence strong enough to promote an
infinite theorem or to open the polarity/rank-stability follow-on C209.

This does **not** prove that the split-`Z3` family contains no suitable arc, nor
that the `GF(16)` phenomenon never extends.  It closes only the preregistered
bounded natural-family mechanisms.

## What was established

### `GF(16)` structural anatomy

The independent frozen-list analyzer reconstructed all `2630 + 3` leaves.
The three deficient leaves are exactly the lowest-defect leaves, have
quadratic rank five, and have a unique forced-hit quadratic with classified
type, intersection, stabilizer, orbit, secant spectrum, and defect.  No
full-rank leaf shares either deficient index/defect cell.  The kernel and
restricted-evaluation formulation is projectively invariant.

This is a complete finite structural statement, not yet an infinite pattern.

### `GF(64)` sizing

The corrected lower-bound candidate is size thirteen.  A rigorous
frame-normalized lower bound gives more than `10^18` projective twelve-arc
classes, so a full census is outside the bounded gate.

### Three natural-family probes

| Family | Exact or bounded result | Obstruction |
|---|---|---|
| `GF(8)` Baer conic plus two Frobenius pairs | All 207,144 arcs have quadratic rank six; ordinary-uncovered size 860--949 | Coverage fails; full rank is already forced by the elementary `2q+1` quadratic point bound |
| One conic-disjoint order-13 nonsplit-torus orbit | 310 arcs, all with spectrum `(1041,1560,1326,208,0,0,13)` | The conic nucleus is uncovered in every case |
| Nucleus plus four split-`Z3` orbits | Exact ternary index; 100,000 accepted arc draws; 500 exhaustive one-orbit descents; complete two-orbit neighborhood of the best witness | Best checked `|U|=805`, versus required `|U|<=65`; no global family exclusion claimed |

For the split-`Z3` route, `F=0` is exactly a bit lookup in the legal orbit
labels meeting nine mixed secants.  Each of the 730,380 compatible pairs
forbids only 171--179 of 1,302 possible third labels.  This makes the ternary
condition cheap but leaves the compatibility space far too large for blind
enumeration.  The best witness is one- and two-orbit locally optimal; a
three-orbit neighborhood is no longer a cheap bounded computation.

## Structural conclusion

The tested `q=64` symmetry mechanisms do not reproduce the low-defect
`q=16` regime.  Their primary failure is not an avoiding quadratic or a new
rank-five type; it is that their secants leave hundreds of ordinary points
uncovered.  In this range, saturation is the prerequisite bottleneck and
quadratic evaluation rank is downstream.

Thus defect/index anatomy from the exceptional `q=16` leaves cannot currently
be promoted field-uniformly.  A future construction program must first produce
high-coverage size-thirteen arcs by a mechanism not represented by these
Baer, transitive-torus, or small split-orbit families.  Only then is quadratic
rank a discriminating invariant.

## Claim boundary and follow-ons

- No infinite even-field theorem is claimed.
- No exhaustive exclusion of the split-`Z3` family is claimed.
- C209 remains dormant: C201 did not supply a stable feature across multiple
  bounded cells or a minimal failure with a simpler polarity dual.
- C210 may use the coverage-first obstruction as negative design data, but
  must not treat it as an infinite-family lower bound.
- The current manuscript receives a discovery result only; no theorem or Lean
  statement is added.

## Replay spine

The exact commands and SHA-256 hashes are recorded with each checked stage:

- [`2026-07-16-c201-gate1-q16-anatomy.md`](2026-07-16-c201-gate1-q16-anatomy.md)
- [`2026-07-16-c201-q64-baer-family.md`](2026-07-16-c201-q64-baer-family.md)
- [`2026-07-16-c201-q64-torus-family.md`](2026-07-16-c201-q64-torus-family.md)
- [`2026-07-16-c201-q64-z3-sizing.md`](2026-07-16-c201-q64-z3-sizing.md)
- [`2026-07-16-c201-q64-z3-index.md`](2026-07-16-c201-q64-z3-index.md)
- [`2026-07-16-c201-q64-z3-coverage.md`](2026-07-16-c201-q64-z3-coverage.md)

The append-only incidental-observation log is
[`2026-07-16-c201-discovery-track.md`](2026-07-16-c201-discovery-track.md).
