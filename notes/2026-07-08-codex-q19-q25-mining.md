# q=19 mining extension and q=25 sizing

Date: 2026-07-08.

## Result

The q=19 on-conic intrusion mining is complete and keeps the odd-plane conjecture alive:

```text
full-PGL on-conic buckets: 13
bucket labels: P=13, N=0
legal first intruders across representatives: 1747
intruded child values: N=1747, P=0
```

So q=19 is cleaner than q=17 at the on-conic layer.  Every legal first intrusion from every
bucket representative is losing for the player who tries it; no off-conic first intrusion flips an
on-conic S4 into an N-position.

The q=19 recursive steering census is also complete:

```text
unique P reply states: 63479
raw initial zone range: 34..57
max recursive steering ceiling Z: 16
```

This extends the zone-steering picture but also shows the bound is growing:

```text
q=13: max Z = 2
q=17: max Z = 9
q=19: max Z = 16
```

The useful invariant is still dynamic steering, not a static snapshot law.  The q=19 data has
96,674 violations of the old q=11-style necessity law `P => defXOR = 0 and zone even`.

## Data

Durable outputs:

```text
notes/data/c20-q19.json
notes/data/c20-q19-states.jsonl.gz
notes/data/c31-q19.json
```

The uncompressed q=19 state rows were 65 MB in `/tmp`; only the 2.4 MB gzip copy is kept in
`notes/data`.

Summary extraction:

```text
c20 buckets 13 Counter({'P': 13})
total intruders 1747
total P reply states 119566
necessity violations 96674
max zone 57

c31 max_z 16
row_counts {'p_rows': 119566, 'rows': 163568, 'unique_p_states': 63479}
seconds 440.50066590309143
```

Recursive steering distribution:

```text
Z=5: 13
Z=6: 132
Z=7: 1921
Z=8: 12378
Z=9: 22192
Z=10: 15874
Z=11: 6987
Z=12: 2878
Z=13: 825
Z=14: 220
Z=15: 46
Z=16: 13
```

Bucket max-Z values:

```text
(0,1,2,3,11,inf): 13
(0,1,2,3,4,inf): 16
(0,1,2,3,4,11): 15
(0,1,2,3,4,5): 13
(0,1,2,3,4,6): 14
(0,1,2,3,4,7): 15
(0,1,2,3,4,8): 15
(0,1,2,3,4,9): 16
(0,1,2,3,6,10): 15
(0,1,2,3,6,16): 15
(0,1,2,3,6,7): 14
(0,1,2,3,6,8): 15
(0,1,2,3,6,9): 14
```

## Speed Work

`notes/2026-07-08-intrusion-census.py` now has a `--jobs` option.  It parallelizes by full-PGL
on-conic bucket, with each worker using an independent private memo.  This keeps the already
reviewed feature code and avoids a premature rewrite.

Smoke test:

```bash
PYTHONDONTWRITEBYTECODE=1 python3 notes/2026-07-08-intrusion-census.py \
  notes/data/codex-feat13-c15.out \
  --qs 13 --limit-buckets 2 --jobs 2 \
  --json-out /tmp/c20-par-smoke.json \
  --states-jsonl /tmp/c20-par-smoke-states.jsonl
```

Output:

```text
loaded buckets=2 qs=[13]
bucket counts by q={13: 2} labels={(13, 'P'): 2}
parallel jobs=2
SUMMARY buckets=2 necessity_violations=206
SUMMARY q=13 buckets=2 labels=Counter({'P': 2})
```

The q=19 full C20 pass with `--jobs 4` took about three minutes wall for 13 buckets.  The q=19
steering pass is still single-process and took about 7.3 minutes wall.

## q=23 and q=25 S4 Sizing

I added a narrow Rust `s4` sizing mode to `notes/2026-07-06-grid-cap-solver.rs`:

```text
s4 <q> t1,t2,t3,t4 [--cap <slots>]
```

It solves the normalized on-conic root

```text
{(t, 1/t) : t in {t1,t2,t3,t4}}
```

using the existing GF(q) backend and private canonical memo.  This is mainly for prime-power
sizing, especially q=25, where the Python C20 miner is prime-field only.

Sanity check:

```bash
/tmp/gridcap-s4 s4 17 1,2,3,4 --cap 1000000
```

Output:

```text
S4 q=17 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 9), (3, 6), (4, 13)] value=P peak-memo=64728 cap=1000000 elapsed=0.123
```

Early-break q=23 sizing:

```bash
/tmp/gridcap-s4 s4 23 1,2,3,4 --cap 20000000
```

Output:

```text
S4 q=23 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 12), (3, 8), (4, 6)] value=P peak-memo=12572289 cap=20000000 elapsed=49.118
```

Early-break q=25 sizing:

```bash
/tmp/gridcap-s4 s4 25 1,2,3,4 --cap 20000000
```

Output:

```text
S4 q=25 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 3), (3, 2), (4, 4)] status=ABORTED peak-memo=20000000 cap=20000000 elapsed=90.272
```

With a larger cap:

```bash
/tmp/gridcap-s4 s4 25 1,2,3,4 --cap 50000000
```

Output:

```text
S4 q=25 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 3), (3, 2), (4, 4)] value=P peak-memo=26305294 cap=50000000 elapsed=120.199
```

Interpretation:

- q=23 bucket-label solves are feasible but memory-heavy.  The earlier bucket-first Python sweep
  found all 22 q=23 buckets P.
- q=25 first S4 representative is also P, so no new counterexample signal appears there.
- q=25 is feasible for bucket-label sizing one representative at a time, but full C20-style
  feature mining needs a GF(25)-aware miner.  The current Python miner handles only prime fields.

## Rust or Go Rewrite?

Do not start with a full rewrite.  The fastest safe path is:

1. Keep the bucket-parallel Python C20 miner for prime q.
2. Add Rust modes for prime-power bucket enumeration and S4-rooted labels where Python lacks GF(q).
3. Only port the full feature miner to Rust if q=23/q=25 feature extraction, not label solving,
   becomes the bottleneck.

The work decomposition is already parallel:

```text
full-PGL bucket representative -> independent private game solve -> independent feature rows
```

So multiprocessing is the correct first acceleration.  Rust/Go helps most if we need GF(25)
feature rows or many q=23/q=25 representatives, not for the q=19 extension.
