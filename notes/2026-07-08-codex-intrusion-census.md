# C20 intrusion census report

Date: 2026-07-08

## Result

C20 is complete for q = 13 and q = 17.  Per the task amendment, I did not redo
the q = 11 Fable spot-test.

Main result: the amended q = 11 necessity law

```text
P reply state => defXOR = 0 and zone size even
```

does **not** extend.  It is already false in q = 13 and fails heavily in q = 17.

First q = 13 counterexample:

```text
bucket canon=(0,1,2,3,4,5)
x=(0,0), y=(3,12), y_kind=intruder
reply state value=P
defXOR=1, defect spectrum=[path 1], zone_size=3
zone_edges=2, zone_NK_grundy=2
```

This kills the joint snapshot hypothesis in its stated necessary form.

## Files

- Script: `notes/2026-07-08-intrusion-census.py`
- Aggregate run output: `/tmp/c20-q13-q17.json`
- Per-reply-state feature rows: `/tmp/c20-q13-q17-states.jsonl` (56,497 rows, 22 MB)
- q=9 gate output: `/tmp/c20-q9-gate.out`

## Gates

q = 9 gate reproduced exactly by:

```text
python3 ../notes/2026-07-07-q9-intrusion-probe.py > /tmp/c20-q9-gate.out
```

Key q=9 lines:

```text
raw normalized on-conic S4 configs=70
full PGL(2,9) S4 classes=2
global legal first moves (conic,intruder) histogram={(4, 0): 10, (4, 4): 60}
global intrusion types (tau_x,tau_played)={(2, 2): 240}
all S4 P=True
all intruded children N=True
all intruded children have a terminal P2 reply=True
failures=0
```

Overlap with C15/C5 feat data: the C20 script parses the same feat logs, rebuilds full-PGL
six-set buckets, and exact-solves each chosen representative.  It exits on any bucket-label
mismatch.  The q = 13/q = 17 run had no mismatches:

```text
bucket counts by q={13: 5, 17: 10}
labels={(13, P): 5, (17, N): 5, (17, P): 5}
```

## q = 13

All five q = 13 buckets are P-valued.  For the chosen representatives:

```text
buckets=5
legal first intruders=156
intruded child values: N=156
P reply states=950
necessity-law violations=468
max zone size=10
```

In the `(defXOR=0, zone even)` slice, zone-conflict NK Grundy is almost decisive but not
clean:

```text
zoneG 0: P=480
zoneG 1: N=61
zoneG 2: N=231
zoneG 3: P=2
```

Zone size is mixed:

```text
zone 2: P=90, N=16
zone 4: P=220, N=173
zone 6: P=137, N=70
zone 8: P=22, N=33
```

## q = 17

The ten q = 17 buckets split 5 P / 5 N.  For the chosen representatives:

```text
buckets=10
legal first intruders=919
intruded child values: N=891, P=28
S4 winning moves in N buckets: intruder=28, conic=0
P reply states=4951
necessity-law violations=3455
max zone size=38
```

So q = 17 N-buckets are visible at the first-intrusion layer: all winning first moves found
among the representatives are intrusions, not conic moves.

The shallow type key `(tau_x, tau_played, M parity)` fails within buckets at q = 17:

```text
type groups=40
mixed P/N groups=10
examples:
  canon=(0,1,2,3,4,10), type=(0,0,1): N=38, P=2
  canon=(0,1,2,3,4,10), type=(2,0,0): N=12, P=2
  canon=(0,1,2,3,4,10), type=(2,1,0): N=28, P=2
```

In the `(defXOR=0, zone even)` slice, zone-conflict NK Grundy is not decisive:

```text
zoneG 0: N=1834, P=907
zoneG 1: N=950,  P=86
zoneG 2: N=2360, P=166
zoneG 3: N=20,   P=10
zoneG 4: N=368,  P=28
zoneG 5: N=4967, P=209
zoneG 6: N=796,  P=90
```

Zone size is also mixed across the main bands:

```text
zone 20: N=142,  P=139
zone 22: N=835,  P=183
zone 24: N=1934, P=301
zone 26: N=3404, P=349
zone 28: N=3039, P=268
```

## Commands

Syntax check:

```text
python3 -B -c 'import py_compile; py_compile.compile("../notes/2026-07-08-intrusion-census.py", cfile="/tmp/c20-census.pyc", doraise=True)'
```

Main run:

```text
time -p python3 ../notes/2026-07-08-intrusion-census.py \
  --qs 13,17 \
  --json-out /tmp/c20-q13-q17.json \
  --states-jsonl /tmp/c20-q13-q17-states.jsonl \
  /tmp/codex-feat13-c15.out /tmp/codex-feat17.out
```

Timing:

```text
real 66.94
user 66.61
sys 0.16
```

## Adversarial review

Game-semantics reviewer: the solver is the full grid-cap game with A,B pre-played, not the
restricted conic game.  Legality is determinant-based over `PG(2,q)` and memoized by affine
cell bitmask.

Symmetry reviewer: representatives are one normalized S4 per full-PGL bucket, recovered from
the C18/C15 feat logs using the same six-set canonicalization.  This assumes the already
checked full-PGL invariance of the on-conic value.

Hypothesis reviewer: q = 13 falsifies the stated necessity law immediately, so downstream
discriminator hunting is diagnostic only.  At q = 17, both zone Grundy and zone size are
strongly mixed even inside the defXOR-zero/zone-even slice.

Scope reviewer: q = 11 was intentionally not rerun, per the C20 amendment.  q = 19 was not
run; q = 13 already supplies counterexamples and q = 17 supplies the mixed-bucket failure
mode.

## Next

C21 is next in the queue: q=23 esc single-class sizing probe.
