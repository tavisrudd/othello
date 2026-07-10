# C38 report: tablebase strategy distillation

Date: 2026-07-09.

## Summary

Implemented a native `s4gdistill` mode in `notes/2026-07-06-grid-cap-solver.rs`.

Parity/value convention used throughout:

```text
true Grundy g = 0  <=>  P-position
true Grundy g > 0  <=>  N-position
winning moves from an N node = children with true Grundy 0
forced node = N node with exactly one such child
```

The mode only consumes exact `GCAPGRD1` raw Grundy dumps.  It rejects aborted dumps and reports
`missing_states` / `missing_children`; all runs below have `seen == records` and no missing child
values.

Main result: forced moves are not a tiny exceptional layer.  In the exact q=17 bucket corpus,
487,302 of 1,074,873 N nodes are forced (45.34%).  In the q=19 root, 815,846 of 1,908,007 N nodes
are forced (42.76%).  The forced skeleton is therefore large enough to constrain any strategy
distillation, but not small enough to be the whole proof by itself.

## Code / data artifacts

- Solver mode: `s4gdistill <q> <t1,t2,t3,t4> --grundy <raw> [--forced-out <rows>]`.
- Manual updated: `notes/2026-07-08-s4-memo-dump-query-manual.md`.
- Output directory: `rust/s4-dumps/2026-07-09/c38-forced/`.
- q=17 exact Grundy dumps generated for all 10 full-PGL bucket representatives plus the two C31
  score-9 representative roots `3,4,5,8` and `13,14,15,16`.

## Commands

Build:

```bash
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap
```

Generate q=17 Grundy roots:

```bash
./target/gridcap s4gdump 17 <t4> --out s4-dumps/2026-07-09/c38-forced/<name>.grundy.raw
```

Distill roots:

```bash
./target/gridcap s4gdistill <q> <t4> \
  --grundy <raw> \
  --forced-out s4-dumps/2026-07-09/c38-forced/<name>.forced.rows \
  > s4-dumps/2026-07-09/c38-forced/<name>.distill.out
```

## Exactness / scale

```text
corpus                                roots  records    seen       missing  N nodes    forced   forced/N  terminals  max ply
q=9 root 1,2,3,4                      1      17         17         0/0      9          5        0.5556    3          8
q=13 root 1,2,3,4                     1      1,117      1,117      0/0      719        353      0.4910    263        12
q=17 full-PGL buckets 00-09           10     1,537,648  1,537,648  0/0      1,074,873  487,302  0.4534    264,239    16
q=17 score-9 representative roots     2      279,188    279,188    0/0      194,292    87,743   0.4516    47,952     16
q=19 root 1,2,3,4                     1      2,691,979  2,691,979  0/0      1,908,007  815,846  0.4276    395,848    18
```

Verbatim final row for the largest run:

```text
S4GDDONE q=19 t4=[1, 2, 3, 4] records=2691979 seen=2691979 missing_states=0 missing_children=0 p_nodes=783972 n_nodes=1908007 forced_nodes=815846 terminal_nodes=395848 max_ply=18 elapsed=28.552
```

## Freedom distribution

Combined q=17 full-PGL bucket corpus:

```text
winning_moves:nodes
1:487302 2:305402 3:150804 4:64532 5:30860 6:14684 7:10827 8:4986
9:2555 10:1340 11:756 12:265 13:373 14:44 15:52 16:30 17:34
18:1 20:9 21:6 24:4 25:7
```

So the median N node is forced or nearly forced, but high-freedom nodes exist and are not just
noise.

## Forced move geometry

```text
corpus                         ext       int       on
q=13 root                      234       67        52
q=17 full-PGL buckets           250,647   180,630   56,025
q=17 score-9 representative     44,965    32,211    10,567
q=19 root                      412,740   326,165   76,941
```

Forced moves are mostly off-conic intruders (`ext` + `int`), but on-conic forced moves remain a
substantial minority.  A proof rule that only searches intruders would miss many forced nodes.

## Conic-emptying forced moves

Rows here count forced nodes with `live_on_before > 0` and `live_on_after = 0`.

```text
corpus                         ext      int      on       total
q=13 root                      27       22       52       101
q=17 full-PGL buckets           40,112   31,737   53,524   125,373
q=17 score-9 representative     7,403    5,687    10,150   23,240
q=19 root                      67,207   55,775   73,252   196,234
```

This supports the C31 repair reading: conic-emptying replies are a large forced subfamily, not an
isolated score-9 accident.  But they are only about a quarter of all forced q=17/q=19 nodes, so
they are a base-law/repair component, not the whole invariant.

## Ply concentration

Combined q=17 full-PGL bucket corpus forced nodes by ply:

```text
ply:forced
5:63 6:2524 7:49366 8:228870 9:198873 10:6990 11:606 15:10
```

The forced skeleton is concentrated at plies 7-9: 477,109 of 487,302 forced nodes (97.91%).
This is exactly the S4/S5/S6 repair window where C31/C35 were pointing.

## C31 guard cross-reference

The old C31 repair-mining artifacts record orbit-normal state descriptions, not solver canonical
keys for the post-opponent repair nodes, so a literal key-by-key subset check is not available
from the durable files.

However, the two reported score-9 guard patterns do occur directly in the forced rows:

```text
t4=3,4,5,8:    62 forced rows with x=1,8, xgeom=int, live_on_before=1, live_on_after=0
t4=13,14,15,16: 76 forced rows with x=6,12, xgeom=int, live_on_before=1, live_on_after=0
```

Example row:

```text
FORCED q=17 t4=3,4,5,8 ply=7 key=058ef59a31c64c4177aae5401870b427 g=3 legal=9 winning=1 x=1,8 xgeom=int child_g=0 live_on_before=1 live_on_after=0 conic_emptying=1 ...
```

Verdict: the C31 score-9 guard-intruder phenomenon is inside the corpus-wide forced skeleton in
the intended geometric form.  A one-to-one audit would need the C31 miner to emit the same
`Board::canon` keys for the `S + opponent_move` nodes.

## Interpretation

The forced skeleton is proof-relevant but too broad for a single local rule:

- q=17/q=19 forced fractions stay around 43-45% of N nodes.
- Most forced moves are off-conic, but on-conic forced moves are too frequent to ignore.
- Conic-emptying forced replies are common and align with the repair-intruder program, but they are
  only a subfamily.
- The actionable next mining target is to split forced nodes by the true Grundy value `g` and by
  the conic/zone support signatures in the emitted `.forced.rows` files, then compare a proposed
  maintenance selector against the forced subset at plies 7-9.

