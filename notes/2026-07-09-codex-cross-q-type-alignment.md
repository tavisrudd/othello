# C36 report: cross-q combinatorial-type value alignment

Date: 2026-07-09.

## Verdict

The intended q-blind coarse shape is still too coarse: it has a within-q mixed-value collision
after adding conic-defect and coarse zone signatures.  A stricter normalized-coordinate type passes
the mandatory self-consistency gate and produces a concrete obstruction table:

- known S5/S6 rows: 19,163 (`q=17`: 5,272; `q=19`: 3,748; `q=23`: 10,143);
- strict shared types in at least two q columns: 1,364;
- strict nonconstant shared types: 281;
- all nonconstant strict types are S5/S6, with only two S5 cases; the rest are S6.

Output files:

- `rust/s4-dumps/2026-07-09/c36-logs/*.depth2.out`
- `rust/s4-dumps/2026-07-09/c36-analysis/summary.md`
- `rust/s4-dumps/2026-07-09/c36-analysis/coarse-collisions.tsv`
- `rust/s4-dumps/2026-07-09/c36-analysis/nonconstant-strict-types.tsv`

Script:

- `rust/scripts/projcap_cross_q_type_alignment.py`

## Type definitions

Coarse shape key:

```text
t4 root parameters
ply
conic defect signature:
  conic off-selected count
  dead-on-conic count
  conic Node-Kayles known/xor fields
  path/cycle/other component sizes, exact up to 6 and large bucketed by parity
coarse zone signature recomputed from cells:
  legal off-conic zone vertex count
  row/column support
  bucketed row/column occupancy
  bucketed conflict-degree histogram
```

Strict normalized-coordinate key:

```text
t4 root parameters
ply
selected-cell signature:
  on-conic cells as C<t> where t is the conic parameter r with r*c = 1
  off-conic cells as O<r>:<c> in the normalized affine chart
```

The strict key is intentionally not the solver's canonical key.  It is a reproducible normalized
query signature.  It is finer than the requested coarse combinatorial type, but it is the first
tested type here that passes the self-consistency gate.

## Commands and outputs

Bucket list used to generate the missing q=17 exact raw roots:

```text
$ target/gridcap s4bucketlist 17
S4BUCKETLIST q=17 raw=1820 pgl=4896 buckets=10 size-hist=20:1,40:1,80:1,120:2,240:4,480:1 enum-elapsed=0.288
BUCKETREP q=17 idx=0 canon=[0,1,2,3,4,5] size=240 rep=[1,2,3,9]
BUCKETREP q=17 idx=1 canon=[0,1,2,3,4,6] size=480 rep=[1,2,3,5]
BUCKETREP q=17 idx=2 canon=[0,1,2,3,4,7] size=240 rep=[1,2,3,6]
BUCKETREP q=17 idx=3 canon=[0,1,2,3,4,8] size=240 rep=[1,2,5,6]
BUCKETREP q=17 idx=4 canon=[0,1,2,3,4,9] size=120 rep=[1,2,6,8]
BUCKETREP q=17 idx=5 canon=[0,1,2,3,4,10] size=240 rep=[1,2,3,8]
BUCKETREP q=17 idx=6 canon=[0,1,2,3,4,17] size=120 rep=[1,2,3,4]
BUCKETREP q=17 idx=7 canon=[0,1,2,3,5,9] size=80 rep=[1,3,7,8]
BUCKETREP q=17 idx=8 canon=[0,1,2,3,6,14] size=20 rep=[1,2,5,14]
BUCKETREP q=17 idx=9 canon=[0,1,2,3,10,17] size=40 rep=[1,2,3,10]
```

Exact q=17 S4 dumps:

```text
$ target/gridcap s4dump 17 <bucket-rep> --cap 1000000 --out rust/s4-dumps/2026-07-09/c36-q17-raw/<file>
S4DUMP q=17 t4=[1, 2, 3, 9] status=OK value=N records=5568 cap=1000000
S4DUMP q=17 t4=[1, 2, 3, 5] status=OK value=N records=35421 cap=1000000
S4DUMP q=17 t4=[1, 2, 3, 6] status=OK value=N records=9916 cap=1000000
S4DUMP q=17 t4=[1, 2, 5, 6] status=OK value=N records=13066 cap=1000000
S4DUMP q=17 t4=[1, 2, 6, 8] status=OK value=P records=66777 cap=1000000
S4DUMP q=17 t4=[1, 2, 3, 8] status=OK value=N records=5842 cap=1000000
S4DUMP q=17 t4=[1, 2, 3, 4] status=OK value=P records=64728 cap=1000000
S4DUMP q=17 t4=[1, 3, 7, 8] status=OK value=P records=26894 cap=1000000
S4DUMP q=17 t4=[1, 2, 5, 14] status=OK value=P records=21902 cap=1000000
S4DUMP q=17 t4=[1, 2, 3, 10] status=OK value=P records=26197 cap=1000000
```

Depth-2 mining command shape:

```text
$ target/gridcap s4mine <q> <t4> --raw <raw-file> --depth 2 --state-rows --max-states 100000
```

Mining corpus summary:

```text
C36_MINE_START commands=45 out=s4-dumps/2026-07-09/c36-logs
C36_MINE_ALL_DONE elapsed=71.31s
```

Analysis command:

```text
$ python3 scripts/projcap_cross_q_type_alignment.py s4-dumps/2026-07-09/c36-logs --out-dir s4-dumps/2026-07-09/c36-analysis
```

Analysis output:

```text
known_s5_s6_rows: 19163
known_rows_by_q: q=17:5272, q=19:3748, q=23:10143
coarse_shape_q_types: 14895
coarse_shape_self_consistency_collisions: 1
strict_coordinate_q_types: 19163
strict_coordinate_self_consistency_collisions: 0
strict_shared_types_ge2q: 1364
strict_nonconstant_types: 281
strict_shared_by_qset: 17/19:87, 17/19/23:131, 17/23:198, 19/23:948
strict_nonconstant_by_qset: 17/19:34, 17/19/23:47, 17/23:87, 19/23:113
```

Pycompile check:

```text
$ python3 -m py_compile scripts/projcap_cross_q_type_alignment.py
```

No output, exit code 0.

## Self-consistency gate

Coarse shape fails with exactly one within-q collision:

```text
q=19 values=N/P count=2 source=q19-bucket05-1-2-3-5.depth2.out
t4=1,2,3,5 ply=6 cells=C1,C2,C3,C5,O0:0,O15:7
key=t4=1,2,3,5 || ply=6 || off=2|dead=9|nk=1:3|path=2,3|cycle=-|other=- ||
    v=44|rows=13|cols=13|row_sizes=2:2,3:6,4:3,5:2|
    col_sizes=2:2,3:6,4:3,5:2|deg=17+:44
```

Strict normalized-coordinate type passes:

```text
strict_coordinate_self_consistency_collisions: 0
```

## Nonconstant strict types

Distribution:

```text
ply=5 17:P/23:N: 2
ply=6 17:N/19:N/23:P: 11
ply=6 17:N/19:P: 30
ply=6 17:N/19:P/23:N: 2
ply=6 17:N/19:P/23:P: 33
ply=6 17:N/23:P: 84
ply=6 17:P/19:N: 4
ply=6 17:P/19:P/23:N: 1
ply=6 17:P/23:N: 1
ply=6 19:N/23:P: 92
ply=6 19:P/23:N: 21
```

Representative rows:

```text
values=17:N,19:N,23:P t4=1,2,3,10 ply=6 cells=C1,C2,C3,C10,C12,O0:0
  legal=17:31,19:51,23:117
  conic_sizes=17:2,2,2 19:2,2,2,2 23:2,2,2,2,2,2

values=17:P,23:N t4=1,2,3,5 ply=5 cells=C1,C2,C3,C5,O9:16
  legal=17:62,23:184
  conic_sizes=17:2,2,2 23:2,2,2,2,2,2,2

values=17:N,19:P,23:P t4=1,2,3,4 ply=6 cells=C1,C2,C3,C4,C11,O0:0
  legal=17:29,19:52,23:118
  conic_sizes=17:2,2,2 19:2,2,2,2 23:2,2,2,2,2,2
```

The full obstruction table is `rust/s4-dumps/2026-07-09/c36-analysis/nonconstant-strict-types.tsv`.

## Interpretation

This is not evidence for a simple finite q-independent type-to-value table at the S5/S6 layer.
Even after exact normalized-coordinate refinement, shared states can flip value across q.  The
flips are mostly in S6 descendants and often show the expected q-dependent conic bulk growth in
`conic_sizes` and legal move counts.

The useful localization is therefore negative but sharp: a uniform proof cannot treat these shared
normalized states as q-constant atoms.  It needs either a q-parameterized law for the growing conic
bulk/zone coupling, or a further invariant that explains the 281 strict nonconstant rows rather
than erasing them.
