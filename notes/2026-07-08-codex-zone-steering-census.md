# C31 report: recursive zone-steering ceiling

Date: 2026-07-08.

## Result

C31 supports the zone-steering proof shape through q = 17.

For each C20 P reply-state `S`, I computed the recursive steering ceiling

```text
Z(S) = 0 if S is terminal, else
       max over opponent moves m
       min over winning replies r
       max(zone(S+m+r), Z(S+m+r)).
```

Here `zone(T)` is the C20 off-conic legal-move count.  This is the size of the intruder zone P2
can force never to exceed from `S`, assuming optimal steering replies.

Main table:

| q | C20 P rows | unique P states | initial zone range | Z distribution | max Z |
|---:|---:|---:|---|---|---:|
| 13 | 950 | 485 | 0..10 | `0:398 1:19 2:68` | 2 |
| 17 | 4951 | 2662 | 16..38 | `0:9 2:127 3:269 4:1156 5:672 6:310 7:59 8:46 9:14` | 9 |

So the one-ply zone can be large, but recursively steerable ceilings are much smaller.  In
particular, q = 17 has initial zones up to 38, yet every tested P reply-state can be steered under
ceiling 9.

This does **not** prove a uniform odd-q theorem, but it keeps the most plausible proof lane alive:

```text
steering lemma -> bounded-zone terminal/endgame law -> on-conic escape theorem
```

## Script

Added:

```text
notes/2026-07-08-zone-steering-census.py
```

The script imports the existing C20 prime-field engine from
[`2026-07-08-intrusion-census.py`](2026-07-08-intrusion-census.py), reconstructs masks from
`notes/data/c20-q13-q17-states.jsonl.gz`, deduplicates equal P reply-states, and computes `Z`.

It also has an independent `NaiveSteering` recursion for spot checks.  That path deliberately does
not call `game.value` or the fast `Steering.z`; it computes outcome and `Z` together from
`legal_mask` only.

## Commands

Small validation:

```bash
env PYTHONDONTWRITEBYTECODE=1 python3 notes/2026-07-08-zone-steering-census.py \
  --qs 13 --limit 20 --spotcheck 5
```

Full q = 13:

```bash
env PYTHONDONTWRITEBYTECODE=1 python3 notes/2026-07-08-zone-steering-census.py \
  --qs 13 --spotcheck 10 --json-out /tmp/c31-q13-v2.json
```

Full q = 17:

```bash
env PYTHONDONTWRITEBYTECODE=1 python3 notes/2026-07-08-zone-steering-census.py \
  --qs 17 --spotcheck 0 --json-out /tmp/c31-q17-v2.json
```

Independent q = 17 spot check:

```bash
timeout 1800s env PYTHONDONTWRITEBYTECODE=1 python3 notes/2026-07-08-zone-steering-census.py \
  --qs 17 --limit 10 --spotcheck 10 --json-out /tmp/c31-q17-spot.json
```

Note: `python3 -m py_compile` was not useful in this sandbox because it attempted to write
`notes/__pycache__`, which is read-only in the Codex mount view.  The script was syntax-checked by
the successful runs above.

## Validation Gates

P/N overlap gate:

- q = 13: all 950 C20 P rows reconstructed as P by the engine; 485 unique masks after dedup.
- q = 17: all 4951 C20 P rows reconstructed as P by the engine; 2662 unique masks after dedup.

Independent recursion spot checks:

- q = 13: 10/10 independent `NaiveSteering` checks matched fast `Z`.
- q = 17: 10/10 independent `NaiveSteering` checks matched fast `Z`.

q = 17 spot-check sample:

```text
fast_z=6 naive_z=6 t4=[3,4,5,8] x=[0,12] y=[1,0]
fast_z=5 naive_z=5 t4=[3,4,5,8] x=[0,9]  y=[1,1]
fast_z=5 naive_z=5 t4=[3,4,5,8] x=[0,8]  y=[1,4]
fast_z=3 naive_z=3 t4=[3,4,5,8] x=[0,0]  y=[1,10]
fast_z=6 naive_z=6 t4=[3,4,5,8] x=[0,1]  y=[1,10]
fast_z=4 naive_z=4 t4=[3,4,5,8] x=[0,8]  y=[1,12]
fast_z=5 naive_z=5 t4=[3,4,5,8] x=[0,10] y=[2,0]
fast_z=6 naive_z=6 t4=[3,4,5,8] x=[0,16] y=[2,0]
fast_z=5 naive_z=5 t4=[3,4,5,8] x=[2,0]  y=[1,1]
fast_z=4 naive_z=4 t4=[3,4,5,8] x=[0,10] y=[2,1]
```

## q = 13

Initial-zone distribution:

```text
0:3 1:5 2:60 3:41 4:137 5:67 6:91 7:44 8:19 9:14 10:4
```

Recursive steering ceiling:

```text
Z=0:398 Z=1:19 Z=2:68
max Z = 2
```

Per-bucket maxima:

```text
(0, 1, 2, 3, 4, 5): 1
(0, 1, 2, 3, 4, 6): 2
(0, 1, 2, 3, 5, 11): 2
(0, 1, 2, 3, 5, 6): 1
(0, 1, 2, 4, 5, 8): 2
```

Run counters:

```text
processed_unique_p_states=485
z_cache=1318
zone_cache=1318
value_cache=2965
seconds=0.0206
```

## q = 17

Initial-zone distribution:

```text
16:9 17:1 18:15 19:6 20:97 21:64 22:226 23:61 24:342 25:279
26:346 27:315 28:345 29:262 30:160 31:74 32:47 33:1 34:11 38:1
```

Recursive steering ceiling:

```text
Z=0:9 Z=2:127 Z=3:269 Z=4:1156 Z=5:672 Z=6:310 Z=7:59 Z=8:46 Z=9:14
max Z = 9
```

Per-bucket maxima:

```text
(0, 1, 2, 3, 10, 'inf'): 8
(0, 1, 2, 3, 4, 'inf'): 9
(0, 1, 2, 3, 4, 10): 7
(0, 1, 2, 3, 4, 5): 8
(0, 1, 2, 3, 4, 6): 8
(0, 1, 2, 3, 4, 7): 7
(0, 1, 2, 3, 4, 8): 7
(0, 1, 2, 3, 4, 9): 7
(0, 1, 2, 3, 5, 9): 8
(0, 1, 2, 3, 6, 14): 9
```

Run counters:

```text
processed_unique_p_states=2662
z_cache=163951
zone_cache=163951
value_cache=792283
seconds=6.10
```

Example max-Z line from q = 17:

```text
Z=9 state:
  t4=[3,4,5,8], first intruder x=[9,3], reply y=[11,4], y_kind=intruder
  initial zone=29
  worst opponent move=[2,5]
  steering reply=[1,8]
  child zone=9
  child Z=2
```

## Interpretation

C31 is a positive result for the dynamic proof direction.  The dead snapshot laws fail because the
raw zone can be large and feature-mixed, but the recursive ceiling is much smaller than the raw
zone.  This suggests the proof should not try to classify every large intruder zone statically.
Instead it should prove that P2 has a repair/steering reply that lands in a bounded-zone terminal
family.

The next useful mathematical target is a bounded-zone theorem:

```text
If an on-conic S4 follower is P and its reply-state lies in the C20 intrusion regime,
then P2 can force the off-conic legal zone into a bounded family B.
For q <= 17, B = 9 suffices in the tested normalized bucket states.
```

The obvious caution is that `B=9` is empirical and only tested on q = 13,17 C20 reply-states.  It
may grow for larger q.  Still, the large drop from initial zone 38 to ceiling 9 at q = 17 is strong
evidence that zone steering is real enough to formalize at least as a finite terminal certificate
schema.
