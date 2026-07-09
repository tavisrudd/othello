# C31 follow-up: repair-move mining

Date: 2026-07-09.

## Result

The C31 one-pair descent data has a stronger interpretation:

```text
high-cost q=17 repairs are mostly conic-killing intruder replies,
and the worst score-9 repairs are entirely clean zero-Grundy empty-conic zone games.
```

This suggests that the uniform proof target should not be "classify every large intruder zone."
It should be:

```text
after an opponent move, find a legal repair intruder that kills or neutralizes the conic
and leaves a small-Z / zero-Grundy off-conic zone game.
```

## Script

Added:

```text
notes/2026-07-09-zone-descent-miner.py
```

The script imports the C31 steering engine and C20 grid/intrusion features.  For every C20 P
reply-state `S` and every legal opponent move `m`, it enumerates all winning replies `r` from
`S + m`, selects the score-optimal replies under

```text
score(S+m+r) = max(zone(S+m+r), Z(S+m+r)),
```

and records:

- move/reply kind: conic or intruder;
- selected score, immediate zone, and child `Z`;
- whether tied best replies include a clean empty-conic reply:
  `spectrum = []`, `defxor = 0`, and `zone_grundy = 0`;
- high-score feature rows.

Commands:

```bash
env PYTHONDONTWRITEBYTECODE=1 python3 notes/2026-07-09-zone-descent-miner.py \
  --qs 13 --high 7 --top 8 --json-out /tmp/c31-zone-descent-miner-q13.json
```

```bash
env PYTHONDONTWRITEBYTECODE=1 python3 notes/2026-07-09-zone-descent-miner.py \
  --qs 17 --high 7 --top 12 --json-out /tmp/c31-zone-descent-miner-q17.json
```

## q = 13

q = 13 is completely small in this diagnostic:

```text
unique P reply-states: 485
opponent-move transitions: 2587
selected childZ: 0:2587
selected score: 0:2327 1:62 2:198
selected score equals immediate zone: true
score >= 7 rows: none
```

Move/reply kinds:

```text
conic -> conic:       28
conic -> intruder:   256
intruder -> conic:   148
intruder -> intruder: 2155
```

So q = 13 never needs a recursive repair above the `Z = 0` family.

## q = 17

Full q = 17 pass:

```text
unique P reply-states: 2662
opponent-move transitions: 77764
selected childZ: 0:77276 1:194 2:294
selected score equals immediate zone: true
```

The equality of selected score and immediate zone is important: in these data, recursion never
dominates the chosen repair.  The high cost is a visible one-pair zone cost, not hidden long-game
complexity.

Selected score distribution:

```text
0:22442 1:7472 2:27467 3:11351 4:7104 5:1243 6:530 7:59 8:68 9:28
```

Move/reply kinds:

```text
conic -> conic:        1556
conic -> intruder:     7019
intruder -> conic:     6088
intruder -> intruder: 63101
```

Best-reply kind sets:

```text
only conic best replies:     5744
conic and intruder tied:     5000
only intruder best replies: 67020
```

So the descent strategy is overwhelmingly intruder-repair driven.

## High-Score Structure

For q = 17, there are only 155 selected transitions with score at least 7:

```text
score 7: 59
score 8: 68
score 9: 28
```

High-score feature rows, formatted as

```text
(score, zone, childZ, move-kind, reply-kind, defxor, zone_grundy, spectrum): count
```

are:

```text
(7, 7, 0, conic,    intruder, 0, 0, []):                 2
(7, 7, 0, intruder, conic,    1, 0, [(path,1)]):        20
(7, 7, 0, intruder, intruder, 0, 0, []):                26
(7, 7, 0, intruder, intruder, 0, 3, []):                11

(8, 8, 0, conic,    intruder, 0, 0, []):                 2
(8, 8, 0, intruder, intruder, 0, 0, []):                26
(8, 8, 2, intruder, intruder, 0, 0, []):                34
(8, 8, 2, intruder, intruder, 1, 0, [(path,1)]):         6

(9, 9, 2, intruder, intruder, 0, 0, []):                28
```

Consequences:

- Every score-9 repair is intruder -> intruder.
- Every score-9 repair empties the conic residual (`spectrum = []`).
- Every score-9 repair has `defxor = 0` and zone Grundy 0.
- 62/68 score-8 repairs have a clean empty-conic best reply.
- The only score-8 exceptions are six single-best rows with one remaining path-1 defect; they
  still have `childZ = 2`.
- Score-7 rows are less uniform, but all have `childZ = 0`.

The score-9 transitions come from only two bucket families:

```text
4 transitions:
  canon=(0,1,2,3,4,inf), t4=(13,14,15,16), stateZ=9, score=9, childZ=2

24 transitions:
  canon=(0,1,2,3,6,14), t4=(3,4,5,8), stateZ=9, score=9, childZ=2
```

These are transitions, not distinct starting states: each high-Z state can contribute more than one
opponent move at the maximum score.

## Interpretation

This changes the proof attack in a useful way.

The important local statement is likely a **repair-intruder lemma**:

```text
Given a C20 P reply-state S and a legal opponent move m,
there exists a legal reply r such that:
  1. S+m+r is P;
  2. Z(S+m+r) <= 2;
  3. in the high-cost cases, r can be chosen as an intruder that empties the conic
     and leaves a zero-Grundy off-conic zone game.
```

The hard part should be geometric existence of `r`, not recursive minimax.  The data says that once
the repair is found, the residual is either already `Z = 0` or falls into the small `Z <= 2` base
family.

For the odd-q plane program, the next mathematical split should be:

```text
on-conic escape into C20 P reply-state regime
+ repair-intruder / one-pair descent lemma
+ small-Z base law, especially empty-conic zoneG=0 cases
=> odd projective-plane theorem
```

This is still empirical and only covers q = 13 and q = 17 C20 states.  It should not be stated as a
theorem yet.  But it gives a much more concrete proof object than a generic bounded-zone law.
