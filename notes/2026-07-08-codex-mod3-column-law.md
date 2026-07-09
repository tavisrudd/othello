# C29 report: mixed-column mod-3 law

Date: 2026-07-08.

## Result

The proposed column law is **refuted** at the first new test field.

Prediction under test:

```text
mixed on-conic PGL(2,q) columns occur exactly when q == 2 mod 3
```

The prediction said `q=23` should be mixed.  The bucket-first q=23 census found:

```text
q=23 full-PGL on-conic buckets: 22
labels: P=22, N=0
```

So q=23 is all-P at the on-conic bucket layer.  This is not a falsification of the odd-plane
program; it is a falsification of the proposed mod-3 explanation for which fields have N-valued
on-conic buckets.

Because the law already failed at q=23, I stopped there rather than spending the remaining C29
budget on q=25/29/31.  q=25 also needs a GF(25)-aware bucket solver, while the current direct
S4-rooted Python engine is prime-field only.

## Existing-data mechanism check

Input:

```text
notes/data/c20-q13-q17-states.jsonl.gz
```

Command:

```bash
python3 - <<'PY'
import gzip,json,collections
rows=[]
with gzip.open('notes/data/c20-q13-q17-states.jsonl.gz','rt') as f:
    for line in f:
        if line.strip(): rows.append(json.loads(line))
def sig_class(spec):
    if not spec: return 'empty'
    has_c6=any(k=='cycle' and n==6 for k,n in spec)
    has_cycle=any(k=='cycle' for k,n in spec)
    has_path=any(k=='path' for k,n in spec)
    if has_c6 and not has_path and not any(k=='cycle' and n!=6 for k,n in spec): return 'free_C6_only'
    if has_c6 and has_path: return 'C6_plus_path'
    if has_cycle and has_path: return 'cycle_plus_path'
    if has_cycle: return 'cycle_other_only'
    if has_path: return 'path_only'
    return 'other'
for q in sorted({r['q'] for r in rows}):
    rs=[r for r in rows if r['q']==q]
    print(f'q={q} rows={len(rs)} buckets={dict(collections.Counter(r["bucket_label"] for r in rs))}')
    print('orders='+str(dict(collections.Counter(r['order'] for r in rs).most_common())))
    tab=collections.Counter((r['bucket_label'],sig_class(r.get('spectrum',[])),r['reply_state_value'],r['winning_reply']) for r in rs if r.get('order')==3)
    print('ord3_total='+str(sum(tab.values())))
    for k,v in sorted(tab.items()): print('  '+repr(k)+' '+str(v))
PY
```

Output:

```text
q=13 rows=2670 buckets={'P': 2670}
orders={7: 910, 14: 850, None: 440, 2: 202, 13: 82, 3: 66, 6: 56, 12: 52, 4: 12}
ord3_total=66
  ('P', 'empty', 'N', False) 30
  ('P', 'empty', 'P', True) 18
  ('P', 'path_only', 'N', False) 4
  ('P', 'path_only', 'P', True) 14
q=17 rows=53827 buckets={'P': 27082, 'N': 26745}
orders={9: 13165, 18: 12786, None: 5814, 16: 4622, 3: 4398, 6: 4191, 2: 2891, 8: 2427, 17: 2312, 4: 1221}
ord3_total=4398
  ('N', 'C6_plus_path', 'N', False) 12
  ('N', 'C6_plus_path', 'P', True) 2
  ('N', 'empty', 'N', False) 10
  ('N', 'empty', 'P', True) 4
  ('N', 'free_C6_only', 'N', False) 6
  ('N', 'free_C6_only', 'P', True) 2
  ('N', 'path_only', 'N', False) 2020
  ('N', 'path_only', 'P', True) 130
  ('P', 'C6_plus_path', 'N', False) 20
  ('P', 'empty', 'N', False) 46
  ('P', 'empty', 'P', True) 30
  ('P', 'free_C6_only', 'N', False) 96
  ('P', 'free_C6_only', 'P', True) 24
  ('P', 'path_only', 'N', False) 1630
  ('P', 'path_only', 'P', True) 366
```

Interpretation: the order-3 mechanism story was already too clean.  `q=17` does have free C6
components, but most order-3 rows are path-only, and both P and N bucket labels occur across several
spectrum classes.  Order-3 split/elliptic behavior remains useful diagnostic vocabulary, but it is
not a bucket-label law.

## Bucket-first q=17 validation

This gate reimplemented the bucket-first enumeration by canonicalizing six-sets via normalized
PGL triples, then solved one S4 root per bucket with the C20 prime-field engine.

Output:

```text
q 17 bucket-count 10 hist {20: 1, 40: 1, 80: 1, 120: 2, 240: 4, 480: 1}
BUCKET 0 six (0, 1, 2, 3, 4, 'inf') size 120 t4 (1, 2, 3, 4) label P memo 67800 elapsed 0.31
BUCKET 1 six (0, 1, 2, 3, 5, 'inf') size 480 t4 (1, 2, 3, 5) label N memo 101653 elapsed 0.47
BUCKET 2 six (0, 1, 2, 3, 6, 'inf') size 240 t4 (1, 2, 3, 6) label N memo 110725 elapsed 0.51
BUCKET 3 six (0, 1, 2, 3, 8, 'inf') size 240 t4 (1, 2, 3, 8) label N memo 115750 elapsed 0.54
BUCKET 4 six (0, 1, 2, 3, 9, 'inf') size 240 t4 (1, 2, 3, 9) label N memo 120556 elapsed 0.56
BUCKET 5 six (0, 1, 2, 3, 10, 'inf') size 40 t4 (1, 2, 3, 10) label P memo 166436 elapsed 0.81
BUCKET 6 six (0, 1, 2, 5, 6, 'inf') size 240 t4 (1, 2, 5, 6) label N memo 178599 elapsed 0.87
BUCKET 7 six (0, 1, 2, 5, 14, 'inf') size 20 t4 (1, 2, 5, 14) label P memo 215579 elapsed 1.04
BUCKET 8 six (0, 1, 2, 6, 8, 'inf') size 120 t4 (1, 2, 6, 8) label P memo 283427 elapsed 1.43
BUCKET 9 six (0, 1, 3, 7, 8, 'inf') size 80 t4 (1, 3, 7, 8) label P memo 337536 elapsed 1.69
label-counts {'P': 5, 'N': 5} elapsed 1.69
```

This reproduces the known C15/C20 q=17 result: 10 buckets, 5 P and 5 N.

## q=23 bucket census

Command shape:

```bash
python3 - <<'PY'
# inline driver:
# - enumerate six-set buckets of {inf,0,t1,t2,t3,t4} up to full PGL(2,23);
# - skip bucket 0 after the separate sizing run;
# - solve one S4-root per remaining bucket in a fresh subprocess with 8 GiB RLIMIT_AS;
# - use notes/2026-07-08-intrusion-census.py::PrimeGridGame for the prime-field S4-rooted game.
PY
```

Initial q=23 sizing run:

```text
q 23 bucket-count 22 hist {55: 1, 110: 3, 165: 4, 330: 9, 660: 5}
REP 0 six (0, 1, 2, 3, 4, 'inf') size 165
REP 1 six (0, 1, 2, 3, 5, 'inf') size 660
REP 2 six (0, 1, 2, 3, 6, 'inf') size 330
REP 3 six (0, 1, 2, 3, 7, 'inf') size 660
REP 4 six (0, 1, 2, 3, 8, 'inf') size 660
REP 5 six (0, 1, 2, 3, 10, 'inf') size 330
REP 6 six (0, 1, 2, 3, 11, 'inf') size 660
REP 7 six (0, 1, 2, 3, 12, 'inf') size 330
SOLVE_START q 23 idx 0 six (0, 1, 2, 3, 4, 'inf') size 165 t4 (1, 2, 3, 4)
GAME_BUILT elapsed 14.811
SOLVE_DONE q 23 idx 0 label P memo 12657594 elapsed 118.809 maxrss_kb 5012740
```

Full bucket sweep:

```text
DRIVER q 23 bucket-count 22 hist {55: 1, 110: 3, 165: 4, 330: 9, 660: 5}
SKIP idx=0 already_solved label=P memo=12657594 elapsed=118.809 maxrss_kb=5012740
RUN idx=1 six=(0, 1, 2, 3, 5, 'inf') size=660 elapsed_driver=0.0
SOLVE_DONE q=23 idx=1 six=(0, 1, 2, 3, 5, 'inf') size=660 t4=(1, 2, 3, 5) label=P memo=12390414 elapsed=112.527 maxrss_kb=4931920
RUN idx=2 six=(0, 1, 2, 3, 6, 'inf') size=330 elapsed_driver=124.5
SOLVE_DONE q=23 idx=2 six=(0, 1, 2, 3, 6, 'inf') size=330 t4=(1, 2, 3, 6) label=P memo=11806570 elapsed=107.825 maxrss_kb=4908668
RUN idx=3 six=(0, 1, 2, 3, 7, 'inf') size=660 elapsed_driver=243.5
SOLVE_DONE q=23 idx=3 six=(0, 1, 2, 3, 7, 'inf') size=660 t4=(1, 2, 3, 7) label=P memo=13153834 elapsed=119.776 maxrss_kb=5159188
RUN idx=4 six=(0, 1, 2, 3, 8, 'inf') size=660 elapsed_driver=375.6
SOLVE_DONE q=23 idx=4 six=(0, 1, 2, 3, 8, 'inf') size=660 t4=(1, 2, 3, 8) label=P memo=13227261 elapsed=121.130 maxrss_kb=5178872
RUN idx=5 six=(0, 1, 2, 3, 10, 'inf') size=330 elapsed_driver=509.2
SOLVE_DONE q=23 idx=5 six=(0, 1, 2, 3, 10, 'inf') size=330 t4=(1, 2, 3, 10) label=P memo=12755566 elapsed=116.766 maxrss_kb=5039380
RUN idx=6 six=(0, 1, 2, 3, 11, 'inf') size=660 elapsed_driver=638.0
SOLVE_DONE q=23 idx=6 six=(0, 1, 2, 3, 11, 'inf') size=660 t4=(1, 2, 3, 11) label=P memo=12387336 elapsed=113.060 maxrss_kb=4933472
RUN idx=7 six=(0, 1, 2, 3, 12, 'inf') size=330 elapsed_driver=762.8
SOLVE_DONE q=23 idx=7 six=(0, 1, 2, 3, 12, 'inf') size=330 t4=(1, 2, 3, 12) label=P memo=13765457 elapsed=126.131 maxrss_kb=5337860
RUN idx=8 six=(0, 1, 2, 3, 13, 'inf') size=55 elapsed_driver=902.0
SOLVE_DONE q=23 idx=8 six=(0, 1, 2, 3, 13, 'inf') size=55 t4=(1, 2, 3, 13) label=P memo=12563540 elapsed=115.684 maxrss_kb=4988572
RUN idx=9 six=(0, 1, 2, 5, 6, 'inf') size=330 elapsed_driver=1029.3
SOLVE_DONE q=23 idx=9 six=(0, 1, 2, 5, 6, 'inf') size=330 t4=(1, 2, 5, 6) label=P memo=14307355 elapsed=127.676 maxrss_kb=5493236
RUN idx=10 six=(0, 1, 2, 5, 7, 'inf') size=165 elapsed_driver=1170.8
SOLVE_DONE q=23 idx=10 six=(0, 1, 2, 5, 7, 'inf') size=165 t4=(1, 2, 5, 7) label=P memo=11995201 elapsed=109.311 maxrss_kb=4907640
RUN idx=11 six=(0, 1, 2, 5, 10, 'inf') size=330 elapsed_driver=1291.6
SOLVE_DONE q=23 idx=11 six=(0, 1, 2, 5, 10, 'inf') size=330 t4=(1, 2, 5, 10) label=P memo=12020341 elapsed=109.070 maxrss_kb=4904692
RUN idx=12 six=(0, 1, 2, 5, 11, 'inf') size=660 elapsed_driver=1412.1
SOLVE_DONE q=23 idx=12 six=(0, 1, 2, 5, 11, 'inf') size=660 t4=(1, 2, 5, 11) label=P memo=13067664 elapsed=122.919 maxrss_kb=5132520
RUN idx=13 six=(0, 1, 2, 5, 15, 'inf') size=330 elapsed_driver=1547.4
SOLVE_DONE q=23 idx=13 six=(0, 1, 2, 5, 15, 'inf') size=330 t4=(1, 2, 5, 15) label=P memo=12796292 elapsed=115.359 maxrss_kb=5059028
RUN idx=14 six=(0, 1, 2, 5, 18, 'inf') size=165 elapsed_driver=1674.8
SOLVE_DONE q=23 idx=14 six=(0, 1, 2, 5, 18, 'inf') size=165 t4=(1, 2, 5, 18) label=P memo=12299756 elapsed=114.068 maxrss_kb=4957916
RUN idx=15 six=(0, 1, 2, 6, 8, 'inf') size=330 elapsed_driver=1800.5
SOLVE_DONE q=23 idx=15 six=(0, 1, 2, 6, 8, 'inf') size=330 t4=(1, 2, 6, 8) label=P memo=13067078 elapsed=118.826 maxrss_kb=5131416
RUN idx=16 six=(0, 1, 2, 6, 10, 'inf') size=110 elapsed_driver=1931.5
SOLVE_DONE q=23 idx=16 six=(0, 1, 2, 6, 10, 'inf') size=110 t4=(1, 2, 6, 10) label=P memo=12638701 elapsed=113.807 maxrss_kb=5009452
RUN idx=17 six=(0, 1, 2, 6, 14, 'inf') size=330 elapsed_driver=2057.3
SOLVE_DONE q=23 idx=17 six=(0, 1, 2, 6, 14, 'inf') size=330 t4=(1, 2, 6, 14) label=P memo=11896293 elapsed=109.796 maxrss_kb=4915900
RUN idx=18 six=(0, 1, 2, 6, 19, 'inf') size=165 elapsed_driver=2178.2
SOLVE_DONE q=23 idx=18 six=(0, 1, 2, 6, 19, 'inf') size=165 t4=(1, 2, 6, 19) label=P memo=13004415 elapsed=119.901 maxrss_kb=5166220
RUN idx=19 six=(0, 1, 3, 4, 9, 'inf') size=110 elapsed_driver=2310.3
SOLVE_DONE q=23 idx=19 six=(0, 1, 3, 4, 9, 'inf') size=110 t4=(1, 3, 4, 9) label=P memo=12995439 elapsed=119.734 maxrss_kb=5116040
RUN idx=20 six=(0, 1, 3, 4, 11, 'inf') size=330 elapsed_driver=2442.4
SOLVE_DONE q=23 idx=20 six=(0, 1, 3, 4, 11, 'inf') size=330 t4=(1, 3, 4, 11) label=P memo=12884106 elapsed=118.363 maxrss_kb=5077856
RUN idx=21 six=(0, 1, 3, 7, 10, 'inf') size=110 elapsed_driver=2572.8
SOLVE_DONE q=23 idx=21 six=(0, 1, 3, 7, 10, 'inf') size=110 t4=(1, 3, 7, 10) label=P memo=12602582 elapsed=113.524 maxrss_kb=4995632
DRIVER_DONE elapsed=2698.3
```

## Consequences

- The bucket-first route is viable at q=23: one representative per full-PGL six-set bucket is much
  cheaper than the old size-3-rooted `esc` run.
- q=23 is not a falsification frontier for the on-conic bucket mechanism.  It is all-P at this
  layer.
- The mixed-column mod-3 law should be dropped.  The next useful law has to explain:
  `q=11` mixed, `q=13` all-P, `q=17` mixed, `q=19` all-P, `q=23` all-P.
- A plausible replacement direction is not a residue class of q alone, but a finer defect/zone
  steering statement over intruder reply subgames.  C31 is now higher value than further C29
  arithmetic speculation.

## Scope notes

- Prime-field S4-rooted solves used the existing C20 engine in
  [`2026-07-08-intrusion-census.py`](2026-07-08-intrusion-census.py).
- No Rust solver source was changed.
- No q=25 result is claimed.  GF(25) needs a GF(q)-aware bucket/S4-rooted engine or a new Rust mode.
