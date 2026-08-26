# Benchmark protocol

Run the versioned benchmark harness from the crate root:

```text
cargo run --locked --release --bin projective-reed-solomon-benchmark -- \
  --iterations 10 --extension-fields
```

It emits `projective-reed-solomon-benchmark-report-v1` JSON and separately
times the terminal selector, exact projective-locator oracle, structural
canonicalization, classification, and certificate replay. Candidate and
transport counts are reported alongside timings so machine speed is not
confused with the proved operation bounds.

The initial recorded environment used Rust 1.93.1 on an AMD Ryzen AI 9 HX 370,
with ten single-threaded iterations. Those measurements are reference data, not
worst-case complexity claims. The exact bounds are recorded in `complexity.md`
and `terminal-hyperplane-solver.md`.
