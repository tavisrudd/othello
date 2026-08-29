# C985 corrected-protocol VLSAT-2 / Kissat A/B

**Lane**: `complete-ports`

## Result

The first ten official VLSAT-2 rows were compared end to end against Kissat
4.0.4 (`8af8e56f174b778aef3aa45af9f739b2a5f492c2`).  Ergodis certified all nine
officially UNSAT rows.  Kissat completed seven paired rounds on four and reached
the ten-second timeout threshold on five.  The one officially SAT control was
a clean Ergodis theorem miss and also reached the Kissat threshold; it is not
included in a speedup statistic.

| Outcome stratum | Instances | Corrected-protocol result |
|---|---:|---:|
| Paired UNSAT | 4 | `381.13x` geometric mean; instance-log `t=22.56` |
| Timeout lower-bound UNSAT | 5 | lower bounds `>2078x` to `>2835x` |
| SAT control | 1 | clean theorem miss; no speedup claim |

The four paired instance speedups are `270.07x`, `290.67x`, `322.39x`, and
`833.68x`; their within-instance paired-log t-scores are `77.27`, `133.35`,
`94.86`, and `118.64`.  Ergodis fresh-process medians across the nine UNSAT
rows are 3.53--5.27 ms.  Median Ergodis RSS is 1,896--1,928 KiB; completed
Kissat medians are 5,992--9,748 KiB.

## Protocol

- Every sample starts a fresh native process; process launch, parsing, solving,
  Ergodis certificate construction, and result emission are timed.
- Both commands read the identical uncompressed CNF after the same SHA-256
  page-cache warmup.
- The order is rotated within each instance and round and independently checked
  from explicit `case_index` and `order_position` fields in the raw JSONL.
- Only the seven matching within-round pairs enter ratios and t-scores.  Eight
  extra Ergodis processes improve its marginal distribution only.
- A first Kissat timeout is retained as a lower-bound case.  Timeout rows enter
  neither the geometric mean nor a t-score.
- Kissat proof output is disabled while Ergodis witness construction and JSON
  output are included, favoring the baseline.  Every Ergodis witness is replayed
  outside the timed interval by the independent streaming checker.
- Raw records include external wall time, user/system CPU, context switches,
  sampled frequency, and process peak RSS.  Summaries contain min, inclusive
  quartiles, median, max, and unit-labelled RSS distributions.

The user confirmed the host was quiet and explicitly accepted running without
kernel CPU isolation.  The harness records that CPU 3 has SMT sibling 15 and
`physical_core_isolated=false`.  The hard host controls passed: the AMD Ryzen AI
9 HX 370 used the `performance` governor with boost disabled.  Both binaries
were pinned to CPU 3.  This limitation is visible in the evidence and is not
silently described as isolation.

## Replay and hashes

```sh
cd papers/complete-repair-ports/ergodis
ERGODIS_BENCH_CPU=3 scripts/vlsat2-prefix-ab.sh
```

The script builds Ergodis with explicit generic `x86-64` code generation,
matching Kissat's recorded generic `gcc -O3 -DNDEBUG` build.  The checked files
are:

- `evidence/c985-vlsat2-prefix-manifest.json`, SHA-256
  `59a92cc37222e73f83acae1fcd713d42c5230b4b3c71a9c901b72268fd17e919`;
- `evidence/c985-vlsat2-prefix.raw.jsonl`, SHA-256
  `f9848026223d7cb9fd913cd5676aed9c63736cfc563ed3176f087843f2f7dfd2`;
- `evidence/c985-vlsat2-prefix-ab.json`, SHA-256
  `87553d87fb55670bef69b21ef50fe242892acb7a3e9323b2ee67c8c206339b41`;
- Ergodis binary, SHA-256
  `e3fd9d83f84ecc5eef92cf915d607e8ae0069e4e27e75abccb1baa1beb4d6d1f`;
- Kissat binary, SHA-256
  `638b9d6a476c83ee30330bfe9f020af2cd4d2c9bb582b63ef96d9be988ebe6d4`.

The summary additionally pins the runner, independent checker, shared process
runner, toolchains, flags, CPU topology, and complete `lscpu -J` record.
