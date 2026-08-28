# C985 original application benchmark rerun

The six original headline application benchmarks were rerun on the Ergodis
side at `6eae5ec22`.  Each current row is the median of eleven pinned-core
samples in rotated order.  The historical comparison point is the last
committed Rust median in `evidence/benchmarks.json`.  Timing includes input
compilation.  A negative time delta is an improvement.

| Application | Recorded | Current | Time delta | Recorded RSS | Current RSS | RSS delta |
| :-- | --: | --: | --: | --: | --: | --: |
| Ceph XOR | 102.220 us | 119.202 us | +16.61% | 2,236 KiB | 2,528 KiB | +292 KiB |
| Azure LRC | 28.031 ns | 31.215 ns | +11.36% | 2,244 KiB | 2,360 KiB | +116 KiB |
| Repair DAG | 2.439 us | 2.963 us | +21.51% | 2,392 KiB | 2,468 KiB | +76 KiB |
| QC-LDPC | 1.517 ms | 1.563 ms | +3.03% | 4,080 KiB | 4,108 KiB | +28 KiB |
| Vector node span | 10.322 us | 10.518 us | +1.90% | 2,292 KiB | 2,452 KiB | +160 KiB |
| GPU MDS | 100.136 us | 98.390 us | -1.74% | 3,732 KiB | 3,832 KiB | +100 KiB |

Exact result checksums and deterministic work counts agree in all 66 samples.
The geometric-mean time ratio is 1.084x current/recorded (7.8% lower
throughput); the geometric-mean RSS ratio is 1.052x.  The machine and kernel
are unchanged, but this is a historical-baseline comparison rather than a
saved-binary interleave.  Several sub-microsecond rows are consequently
sensitive to host and process noise.  The QC-LDPC and vector rows are closest
to flat; GPU MDS improves slightly; Ceph, Azure, and Repair DAG warrant a
saved-binary A/B before attributing their larger deltas to code changes.

Reproduce and check with:

```text
CARGO_TARGET_DIR=/home/tavis/.cache/ergodis-c985-original-rerun \
  cargo build --release --all-features --bin bench_kernels
python3 python/rerun_original_rust_benchmarks.py \
  --binary /home/tavis/.cache/ergodis-c985-original-rerun/release/bench_kernels \
  --output evidence/c985-original-rust-rerun.json --rounds 11 --cpu 2
python3 python/check_original_rust_rerun.py \
  evidence/c985-original-rust-rerun.json
```
