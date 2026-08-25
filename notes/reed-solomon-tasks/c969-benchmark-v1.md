# C969 classifier/decoder benchmark v1

## Reproduction

Build and run the standalone harness from the repository root:

```text
cargo build --release --manifest-path rust/prs_classifier/Cargo.toml --bin c969_benchmark
rust/prs_classifier/target/release/c969_benchmark --iterations 10
```

The program emits `c969-benchmark-report-v1` JSON. Each operation is timed in
its own loop, and selector/oracle rows expose their independently counted
locator candidates. The named oracle is `search_locator` through degree
`r-1`: increasing-degree enumeration of the full projective Hankel kernels,
followed by split-root and magnitude checks. It is an exact correctness oracle,
not a codeword scan and not the optimized selector.

## Recorded environment

- date: 2026-08-25;
- CPU: AMD Ryzen AI 9 HX 370, 12 cores / 24 threads;
- architecture: x86_64 Linux;
- Rust: `rustc 1.93.1 (01f6ddf75 2026-02-11)`;
- crate profile: release, optimized;
- harness iterations: 10, single-threaded;
- field backend: the crate's polynomial-basis integer encoding, with prime
  fields in these fixtures.

## Results

| operation | q | redundancy | ns / iteration | locator candidates |
|---|---:|---:|---:|---:|
| 12-point terminal selector | 7 | 5 | 6,794 | 1 |
| projective locator oracle | 7 | 5 | 57,226 | 409 |
| 12-point terminal selector | 17 | 6 | 17,961 | 1 |
| projective locator oracle | 17 | 6 | 16,018,546 | 89,067 |
| 12-point terminal selector | 7 | 7 | 4,441 | 1 |
| projective locator oracle | 7 | 7 | 7,212,734 | 20,017 |
| tangent semilinear canonicalization | 17 | 6 | 469,797 | 272 transports |
| end-to-end classification | 17 | 6 | 641,709 | -- |
| positive deep-certificate replay | 17 | 6 | 626,997 | -- |

The terminal fixtures are respectively the R5 tangent, R6 tangent, and frozen
R7 sporadic representative. Their one-prefix selector outcomes are favorable
instances, not worst-case claims. The proved operation bounds come from
`c969-terminal-hyperplane-solver.md`, not these timings.

## Interpretation boundary

The benchmark separates four costs which must not be conflated:

1. fixed-grid terminal completion after streamed prefix selection;
2. the generic exact projective-locator oracle;
3. exact tangent `mq(q-1)` semilinear canonicalization (with the explicit
   `m(q^3-q)` fallback still used outside that family); and
4. independent certificate replay, which intentionally repeats canonical
   transport before checking family and radius evidence.

No timing is a novelty or state-of-the-art claim. Sigma and nonpersistent
canonicalization still use an honest group-scale fallback. Their formula-speed
canonicalizers, extension-field matrices, a wider q/field/redundancy benchmark
grid, bit-operation accounting, and comparison with external decoder software
remain open benchmark work.
