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

## Powered saved-binary head-to-head

A follow-up comparison builds the evidence-landing revision `82751420d` and
HEAD with the same compiler and runs 101 independent paired rounds. Baseline
and candidate processes are adjacent, their order alternates, and the case
order rotates. Every process retains the original row's repetition count.
Short rows use an odd number of fresh processes per pair and the pair median,
rather than increasing in-process repetitions and accidentally amortizing
one-time construction. All result checksums and work counts agree.

The primary effect is the geometric mean of the paired candidate/baseline
ratios. Values below one favor HEAD. The primary t-score is a paired t-test on
log ratios; the raw-difference t-score is also shown. Both have 100 degrees of
freedom, and the unadjusted two-sided 5% critical magnitude is 1.984.

| Application | HEAD/base ratio (95% CI) | Change | Raw t | Log-ratio t | 80% MDE |
| :-- | --: | --: | --: | --: | --: |
| Ceph XOR | 1.00295 [1.00130, 1.00460] | 0.295% slower | +3.562 | +3.557 | 0.235% |
| Azure LRC | 1.00299 [0.99932, 1.00668] | unresolved | +1.593 | +1.617 | 0.524% |
| Repair DAG | 0.98338 [0.97887, 0.98791] | 1.662% faster | -6.443 | -7.231 | 0.657% |
| QC-LDPC | 0.98477 [0.97912, 0.99045] | 1.523% faster | -5.061 | -5.296 | 0.822% |
| Vector node span | 1.01042 [1.00639, 1.01446] | 1.042% slower | +5.102 | +5.147 | 0.571% |
| GPU MDS | 1.00721 [0.99834, 1.01617] | unresolved | +1.283 | +1.612 | 1.268% |

The first historical rerun's double-digit Ceph/Azure/Repair-DAG deltas were
therefore environmental noise, not reproducible regressions. The powered
head-to-head resolves four small effects and leaves Azure and GPU compatible
with no change at this power. The four resolved rows have log-ratio t-score
magnitudes above 3.55, so their classification also survives a conservative
six-test Bonferroni threshold; Azure and GPU do not cross even the unadjusted
threshold.

There is one provenance limitation. The historical JSON's recorded source
hash is not reachable in Git, so its exact historical binary cannot be rebuilt.
The auditable baseline here is the revision that landed that evidence,
`82751420d`; the evidence records both revision and saved-binary hashes.

Reproduce and check with:

```text
CARGO_TARGET_DIR=/home/tavis/.cache/ergodis-c985-original-rerun \
  cargo build --release --all-features --bin bench_kernels
python3 python/rerun_original_rust_benchmarks.py \
  --binary /home/tavis/.cache/ergodis-c985-original-rerun/release/bench_kernels \
  --output evidence/c985-original-rust-rerun.json --rounds 11 --cpu 2
python3 python/check_original_rust_rerun.py \
  evidence/c985-original-rust-rerun.json
python3 python/head_to_head_original_rust_benchmarks.py \
  --baseline-binary /home/tavis/.cache/ergodis-c985-h2h-baseline-target/release/bench_kernels \
  --candidate-binary /home/tavis/.cache/ergodis-c985-original-rerun/release/bench_kernels \
  --baseline-revision 82751420da5952f1354432e3c6144bacbf107167 \
  --output evidence/c985-original-rust-head-to-head.json --rounds 101 --cpu 2
python3 python/check_original_rust_head_to_head.py \
  evidence/c985-original-rust-head-to-head.json
```
