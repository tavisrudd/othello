# Zone-repair geometry mining

Date: 2026-07-08.

## Result

The high-cost q = 17 one-pair repairs have a concrete geometric shape.

For every score-9 repair transition in the q = 17 sample:

- the opponent move is an external intruder with exactly one played tangency;
- the repair is an internal intruder with no played tangencies;
- the repair is already a legal internal intruder in the pre-opponent P-state;
- exactly one conic parameter is live before the repair;
- the repair kills that last live conic parameter;
- the repaired state is clean: empty conic residual, `defxor = 0`, zone Grundy 0;
- among all legal intruder replies, there is exactly one clean P-valued conic-killing reply, and
  it is the selected optimal repair.

This is sharper than the previous "repair intruder" target.  In the worst cases, the target is:

```text
Find the unique internal clean intruder that kills the last live conic parameter.
```

The negative result is also useful: this repair is not characterized by a single product order or
line type between the opponent move and the repair.  Score-9 repairs split between external
opponent-repair lines of order 18 and secant opponent-repair lines of order 16.

## Script

Added:

```text
notes/2026-07-08-zone-repair-geometry.py
```

Validation command:

```bash
env PYTHONDONTWRITEBYTECODE=1 python3 notes/2026-07-08-zone-repair-geometry.py \
  --qs 17 --high 8 --top 12 --json-out /tmp/c31-zone-repair-geometry-q17.json
```

Smoke tests after local-date renaming:

```bash
env PYTHONDONTWRITEBYTECODE=1 python3 notes/2026-07-08-zone-steering-census.py \
  --qs 13 --limit 1 --spotcheck 0

env PYTHONDONTWRITEBYTECODE=1 python3 notes/2026-07-08-zone-descent-miner.py \
  --qs 13 --high 7 --top 1

env PYTHONDONTWRITEBYTECODE=1 python3 notes/2026-07-08-zone-repair-geometry.py \
  --qs 13 --high 8 --top 1
```

All three ran successfully.  As before, `python3 -m py_compile` is not useful in this sandbox
because `notes/__pycache__` is read-only.

## Score-9 Geometry

There are 28 selected score-9 transitions.

Line type and product order of the opponent-repair pair:

```text
24: external line, order 18
 4: secant line,   order 16
```

Tangency type, formatted as

```text
(score, tau(move), played-tangencies(move), tau(reply), played-tangencies(reply), clean): count
```

is pure:

```text
(9, 2, 1, 0, 0, True): 28
```

Conic kill count, formatted as

```text
(score, live-before, killed-by-reply, live-after, clean): count
```

is also pure:

```text
(9, 1, 1, 0, True): 28
```

Candidate-set count, formatted as

```text
(score, live-before, legal-intruders, conic-killing-intruders,
 P-valued conic-killers, clean conic-killers, internal intruders,
 internal clean conic-killers, selected-kills, selected-clean,
 selected-internal-clean): count
```

is:

```text
(9, 1, 14,  9, 1, 1, 6, 1, True, True, True): 24
(9, 1, 14, 11, 1, 1, 6, 1, True, True, True):  4
```

So in every worst case there are many legal intruders and many that kill the last live conic point,
but exactly one legal intruder is simultaneously:

```text
P-valued
clean
internal
conic-killing
```

and that is the optimal repair.

There is an even stronger state-level pattern.  The 28 score-9 transitions come from 14 starting
states:

```text
states with score-9 transitions: 14
score-9 opponent moves per state: exactly 2
distinct score-9 repairs per state: exactly 1
repair was already legal before the opponent move: 14/14
repair was already internal before the opponent move: 14/14
```

So the worst-case repair may be selectable before the opponent move.  In each score-9 state there
is a distinguished internal "guard" intruder `r`; the two worst opponent moves leave two different
single live conic parameters, and the same `r` kills whichever one remains.

Repair-cell frequency in the normalized q = 17 representatives:

```text
(6,12): 4 states
(1,8):  3 states
(10,14): 3 states
(12,11): 3 states
(1,6):  1 state
```

The killed conic parameter is not always killed through the same played point.  Among the 28
score-9 kills, the played conic witness is:

```text
18: one of the four finite t4 parameters
 6: infinity
 4: zero
```

So there is no fixed "always use infinity" or "always use zero" chord rule.

## Score-8 Contrast

Score-8 repairs are close but not identical:

```text
(8, live-before=0, killed=0, live-after=0, clean=True):  8
(8, live-before=1, killed=0, live-after=1, clean=False): 6
(8, live-before=1, killed=1, live-after=0, clean=True): 52
(8, live-before=2, killed=2, live-after=0, clean=True):  2
```

Thus 62/68 score-8 repairs are already clean conic-killing or conic-empty repairs.  The six
exceptions are the same single-path-defect cases found in the previous mining pass; they leave one
live conic defect but still have recursive `Z <= 2`.

Score-8 line types are mixed:

```text
45: intruder -> intruder, external line, clean
13: intruder -> intruder, tangent line, clean
 2: intruder -> intruder, secant line, clean
 2: conic    -> intruder, non-ii, clean
 6: intruder -> intruder, external line, not clean
```

Again, product order alone is not the repair rule.

## Proof Implication

The next useful theorem target should be local and geometric:

```text
Guard-intruder repair lemma:
    In the high-cost regime, before the opponent move there is a legal internal guard intruder r
    such that whenever a worst opponent move leaves a single live conic parameter u:
      sigma_r sends some played conic parameter to u,
      the conic becomes empty,
      the resulting off-conic zone has Grundy value 0,
      and the repaired state is P.
```

For a uniform proof, this should be paired with:

```text
Small-Z base law:
    Once the repair lands in empty-conic zoneG=0, or in the bounded Z <= 2 family,
    the remaining game is P.
```

The computation does not yet explain how to construct `r` from field data.  The plausible next
mining question is whether the unique internal clean repair can be expressed by a small algebraic
condition on the last live conic parameter, the current intruder set, and the six played conic
parameters.

## Polarity Check

The obvious polarity identities do not explain the guard.  In the normalized conic model
`XY = Z^2`, the polar of `(A,B,C)` is

```text
B X + A Y - 2 C Z = 0.
```

Across all 28 score-9 transitions:

```text
guard on polar of live point:       0/28
guard is pole of live-witness chord: 0/28
opponent on polar of live point:    0/28
live point is opponent tangency:    0/28
```

The opponent is always external with exactly one played tangency and one unplayed tangency, but the
unplayed tangency is not the last live conic parameter.

## Two-Orbit Certificate

The 14 score-9 starting states collapse to two orbits under the conic-preserving `PGL(2,17)` action:

```text
state orbits:                    2, sizes 12 and 2
state + guard orbits:            2, sizes 12 and 2
state + guard + worst moves:     2, sizes 12 and 2
```

Representatives:

```text
Orbit 1:
  canon=(0,1,2,3,6,14), t4=[3,4,5,8]
  x=(9,3), y=(11,4), guard=(1,8)
  worst moves=(2,5), (7,16), leaving live parameters 16 and 2

Orbit 2:
  canon=(0,1,2,3,4,inf), t4=[13,14,15,16]
  x=(3,7), y=(9,14), guard=(6,12)
  worst moves=(5,2), (7,0), leaving live parameters 10 and 1
```

This makes the score-9 layer a good candidate for a tiny finite certificate rather than a uniform
polarity lemma.
