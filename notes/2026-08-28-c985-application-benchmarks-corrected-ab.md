# C985 corrected README and paper application benchmarks

**Date:** 2026-08-28  
**Scope:** eight bounded workloads previously highlighted by the ergodis README
or the complete-ports paper  
**Status:** seven-round broad comparison and three-round long-control extension
complete

## Result

The earlier application table mixed highly repeated Rust processes with
single-shot controls.  The corrected experiment starts a fresh process for
every sample, gives both implementations the same number of solves, rotates
their order, and uses external wall time as the primary metric.  Sixteen
profiles were checked: one cold solve and an eight-solve warm batch for each of
eight workloads.  Twelve profiles completed on both sides.  Four direct
CP-SAT profiles exceeded the ten-second process limit and therefore give lower
bounds, not exact ratios.

| workload | cold wall/solve | cold ratio | warm wall/solve | warm ratio |
|---|---:|---:|---:|---:|
| Ceph recursive XOR | 3.014 ms vs 101.628 ms | 33.71x | 0.547 ms vs 12.598 ms | 22.94x |
| represented GF(4) tower | 4.589 ms vs timeout | >2179.32x | 1.097 ms vs timeout | >1139.39x |
| Azure LRC batch | 2.886 ms vs 462.015 ms | 160.45x | 0.368 ms vs 58.533 ms | 160.21x |
| repair DAG | 2.983 ms vs 500.139 ms | 167.12x | 0.337 ms vs 92.712 ms | 275.15x |
| QC-LDPC word exclusion | 6.983 ms vs 1339.715 ms | 190.45x | 4.191 ms vs 166.037 ms | 39.72x |
| vector node span | 2.854 ms vs 216.151 ms | 75.72x | 0.456 ms vs 29.553 ms | 64.90x |
| Hamming-outer LRC | 260.733 ms vs timeout | >38.35x | 257.190 ms vs timeout | >4.86x |
| GPU MDS checkpoint | 3.803 ms vs 393.213 ms | 102.42x | 0.682 ms vs 70.449 ms | 103.23x |

The cold completed-pair geometric mean is 104.16x with instance-log
`t = 44.80`; the warm completed-pair geometric mean is 81.48x with
`t = 34.80`.  Per-case paired log-ratio t-scores are stored in the summary;
the smallest magnitude among the twelve is `39.60`.  The broad run does not
support the former exact 344,300x tower or 432x Hamming ratios: its ten-second
stop condition supports only the displayed lower bounds.

### Long-control extension

Three fresh-process rounds raised the tower and Hamming timeout to 400 seconds.
All three tower controls timed out: the cold bound is >87,743.54x and the
equal eight-solve warm-batch bound is >45,103.05x.  All three cold Hamming
controls finished in 299.81, 270.94, and 243.95 seconds.  Their paired median
speedup is 657.88x with log-ratio `t = 49.09`.  All three eight-solve Hamming
controls timed out, giving a warm-batch bound >196.50x.  Thus the corrected
protocol supports a larger exact cold Hamming ratio than the former 432x
single-run headline, while the tower claim remains a lower bound rather than
an extrapolated completion time.

## Protocol and trust boundary

- CPU 3; `performance` governor; boost disabled; user-confirmed quiet host.
- Seven rounds, rotated order, one fresh process per sample.
- Cold profile: one solve per process.  Warm profile: eight solves per process
  on both sides; wall time is divided by eight.
- `/usr/bin/time` supplies external wall time and peak RSS.  Dependency setup is
  completed before measurement, while interpreter, model, and solver startup
  remain inside the measured process.
- The Rust and Python programs return the same normalized checksum for every
  completed pair.  The checker independently reconstructs record order,
  classifications, checksums, paired ratios, geometric means, t-scores, lower
  bounds, and artifact hashes.
- A timeout proves only that the complete equal-size batch exceeded ten
  seconds.  It does not identify the eventual completion time.

The raw JSONL is written line-buffered as each process finishes.  The runner
does not retain an evidence transcript in memory; only the bounded per-case
sample records needed for statistics remain resident.

## Replay

From `papers/complete-repair-ports/ergodis`:

```sh
ROUNDS=7 TIMEOUT_S=10 scripts/application-readme-ab.sh
```

The script creates or reuses
`/home/tavis/.cache/ergodis/application-ab-venv`, installs the pinned
Graphillion 2.1, OR-Tools 9.14.6206, SciPy 1.16.1, and pycryptosat 5.14.7
controls, runs the benchmark, and invokes the independent checker.  Expected
checker output is:

```text
verified=8; completed_pairs=12; timeout_lower_bounds=4
```

The long controls use the same working directory and pinned Python environment:

```sh
python3 python/run_application_long_controls.py \
  --ergodis target/release/bench_kernels \
  --python /home/tavis/.cache/ergodis/application-ab-venv/bin/python \
  --raw-jsonl evidence/c985-application-long-cold.raw.jsonl \
  --output evidence/c985-application-long-cold.json \
  --profile cold --repetitions 1 --rounds 3 --timeout 400 --cpu 3
python3 python/run_application_long_controls.py \
  --ergodis target/release/bench_kernels \
  --python /home/tavis/.cache/ergodis/application-ab-venv/bin/python \
  --raw-jsonl evidence/c985-application-long-warm.raw.jsonl \
  --output evidence/c985-application-long-warm.json \
  --profile warm_batch --repetitions 8 --rounds 3 --timeout 400 --cpu 3
```

Replay each summary with `python/check_application_long_controls.py`; expected
outputs are respectively `verified=2; completed_pairs=1;
timeout_lower_bounds=1` and `verified=2; completed_pairs=0;
timeout_lower_bounds=2`.

## Artifact ledger

| artifact | bytes | SHA-256 |
|---|---:|---|
| `python/run_application_readme_ab.py` | 13,451 | `1a82bbced885ca54fb1475add225f15e6a5aacd9ed0efb3d9074914d41b0cc39` |
| `python/check_application_readme_ab.py` | 7,621 | `fe30fa20d41e8c900c20f6c47a7259fe0bef0e3bf98ac82d33719fbc260c38f3` |
| `scripts/application-readme-ab.sh` | 1,221 | `f83f9667b31328277e8f6d4701c753f263360b97243c9ad859d233653e88fee6` |
| `evidence/c985-application-readme-ab.raw.jsonl` | 185,604 | `14622b6522a24c84321e14c8f551ac2e02d0d09dbc420197e942f8b4a8032d87` |
| `evidence/c985-application-readme-ab.json` | 34,523 | `1b780b30b463a58bb463517e00734866a12eb332681feaaacb97ac67e0bf95a1` |
| `python/run_application_long_controls.py` | 7,270 | `06d0d3c5585039c5e4d780b8ccaf7b24596437f281d57aafef94849c0460b0c7` |
| `python/check_application_long_controls.py` | 6,169 | `d2aa92e21e841f1f90fde6ce4c2347085a867ff74d607011ae79491b4cdfa60f` |
| `evidence/c985-application-long-cold.raw.jsonl` | 9,096 | `381e6bead6f0cd8c7bc81a891153c1fd4c3dfdd749f080bf47c8f18a55c0fe8f` |
| `evidence/c985-application-long-cold.json` | 9,778 | `f86fd6ba06d6caec811c2945a9c3744b50585f1c8033a687df6391f055f56745` |
| `evidence/c985-application-long-warm.raw.jsonl` | 8,162 | `3b1bd1234ffece2703a0ddb76cdafeffb5dfb1066e238a69e137dc22268be3fb` |
| `evidence/c985-application-long-warm.json` | 9,464 | `3120be53d07e18a6a5748994ac0e26aca90870a017fc4b7ac0d98cfdfdb3c71d` |

## Boundary

These measurements compare the declared implementations on eight fixed
instances.  They are not universal solver rankings.  Cold and warm-batch
figures answer different deployment questions and must not be mixed.  The
historical benchmark table is superseded by this corrected evidence.
