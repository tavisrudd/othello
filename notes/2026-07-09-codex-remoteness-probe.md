# C39 report: remoteness / suspense probe

Date: 2026-07-09.

## Summary

Implemented `s4gremote` in `notes/2026-07-06-grid-cap-solver.rs`.

Definition used:

```text
terminal state: remoteness = 0
N state:        1 + min remoteness among P children
P state:        1 + max remoteness among N children
```

All runs below use exact `GCAPGRD1` Grundy dumps and have `seen == records`,
`missing_states = missing_children = remote_missing = 0`.

Main verdict: remoteness is a useful "suspense" diagnostic, but not a new proof monovariant by
itself.  The tail is very short: in the q=17 full-PGL S4 bucket corpus, only 19,710 / 1,537,648
states have remoteness at least 4, and only 105 states have remoteness 10.  However, computing it
already uses the exact P/N labels, parity is automatic (`P` even, `N` odd), and the C31-style
`zone_v` / `defxor` features stratify the averages without becoming a decision law.

## Artifacts

- Solver mode: `s4gremote <q> <t1,t2,t3,t4> --grundy <raw>`.
- Manual updated: `notes/2026-07-08-s4-memo-dump-query-manual.md`.
- Output directory: `rust/s4-dumps/2026-07-09/c39-remoteness/`.

## Commands

Build:

```bash
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap
```

Probe:

```bash
./target/gridcap s4gremote <q> <t4> --grundy <raw> \
  > s4-dumps/2026-07-09/c39-remoteness/<name>.remote.out
```

## Exactness / Scale

```text
corpus                         roots  records    P nodes  N nodes    terminals  max ply  max rem  root rem
q=13 root 1,2,3,4              1      1,117      398      719        263        12       6        4
q=17 full-PGL buckets 00-09    10     1,537,648  462,775  1,074,873  264,239    16       10       N roots: 5; P roots: 6 or 8
q=17 score-9 representatives   2      279,188    84,896   194,292    47,952     16       10       6 or 8
q=19 root 1,2,3,4              1      2,691,979  783,972  1,908,007  395,848    18       10       6
```

q=19 is an optional scale check from the existing exact dump, not the main C39 target.

## Remoteness Distribution

q=17 full-PGL bucket corpus:

```text
remoteness  all nodes  P nodes  N nodes
0           264,239    264,239  0
1           865,460    0        865,460
2           186,323    186,323  0
3           201,916    0        201,916
4           8,178      8,178    0
5           3,965      0        3,965
6           2,747      2,747    0
7           3,060      0        3,060
8           1,183      1,183    0
9           472        0        472
10          105        105      0
```

Tail sizes:

```text
rem >= 4:   19,710  (1.282%)
rem >= 8:   1,760  (0.115%)
rem >= 10:    105  (0.0068%)
```

Parity check:

```text
q=17 P nodes: rem_even=462,775 rem_odd=0
q=17 N nodes: rem_even=0       rem_odd=1,074,873
```

This is expected by induction from the normal-play recurrence, so it is not an independent
strategy invariant.

## Optimal-Move Geometry

Rows count nodes where a geometry appears among optimal remoteness moves; `edges` counts all
optimal tied moves of that geometry.

q=17 full-PGL bucket corpus:

```text
from  geom  nodes    edges
N     ext   716,390  1,040,432
N     int   569,892    760,789
N     on    217,486    263,159
P     ext   175,338    495,216
P     int   152,419    353,933
P     on     84,383    137,674
```

Optimal play is geometrically mixed.  External and internal intruders dominate by volume, but
on-conic moves remain too common to discard.

## C31 Feature Correlation

Here `defxor` is the exact live-conic Node-Kayles xor used in the C31 defect-spectrum vocabulary.
`residual` in the raw output is `true_grundy XOR defxor`.

q=17 full-PGL buckets by `defxor`:

```text
defxor  states     P nodes  N nodes  rem avg  rem max
0       1,109,681  395,767  713,914  1.076    10
1         411,292   65,270  346,022  1.729     9
2          12,213    1,480   10,733  2.505     6
3           4,462      258    4,204  3.086     6
```

Higher `defxor` raises average suspense, but `defxor=0` still contains both values and the longest
tail.  So `defxor` is a useful stratifier, not a selector.

q=17 selected `zone_v` buckets:

```text
zone_v  states   P nodes  N nodes  rem avg  rem max
0       305,694  269,914   35,780  0.289     8
1       274,545   10,638  263,907  1.048     4
4       146,301   33,205  113,096  1.300     9
8        27,981    5,346   22,635  2.139     9
12       32,879    3,923   28,956  2.685     5
16        2,218      130    2,088  2.935     5
24        2,425      245    2,180  3.180    10
94            1        0        1  5.000     5
```

Average remoteness tends to rise with zone size through the medium buckets, but there is no clean
cutoff: q=17 remoteness-10 states occur around `zone_v = 18,20,23,24`, while the optional q=19 root
already has remoteness-10 states in small zone buckets.  Zone size alone is not the dynamic law.

## Interpretation

Remoteness supports the steering picture but does not replace it:

- It gives a compact way to rank how long optimal play can keep a state alive.
- The q=17/q=19 exact data have a very short tail, with maximum observed remoteness 10.
- The C31 features correlate with tail length, especially `defxor` and medium zone size, but they
  do not decide value or remoteness.
- A proof target should still be a concrete repair/steering lemma plus bounded-zone base law, not
  a standalone remoteness-parity or zone-size monovariant.
