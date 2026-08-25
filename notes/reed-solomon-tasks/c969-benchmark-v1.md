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
| 12-point terminal selector | 7 | 5 | 15,586 | 1 |
| projective locator oracle | 7 | 5 | 146,560 | 409 |
| 12-point terminal selector | 17 | 6 | 43,712 | 1 |
| projective locator oracle | 17 | 6 | 32,436,418 | 89,067 |
| 12-point terminal selector | 7 | 7 | 11,549 | 1 |
| projective locator oracle | 7 | 7 | 16,975,901 | 20,017 |
| explicit semilinear canonicalization | 17 | 6 | 12,830,275 | 4,896 transports |
| end-to-end classification | 17 | 6 | 11,199,091 | -- |
| positive deep-certificate replay | 17 | 6 | 11,398,512 | -- |

The terminal fixtures are respectively the R5 tangent, R6 tangent, and frozen
R7 sporadic representative. Their one-prefix selector outcomes are favorable
instances, not worst-case claims. The proved operation bounds come from
`c969-terminal-hyperplane-solver.md`, not these timings.

## Interpretation boundary

The benchmark separates four costs which must not be conflated:

1. fixed-grid terminal completion after streamed prefix selection;
2. the generic exact projective-locator oracle;
3. explicit `m(q^3-q)` semilinear canonicalization; and
4. independent certificate replay, which intentionally repeats canonical
   transport before checking family and radius evidence.

No timing is a novelty or state-of-the-art claim. The current canonicalizer is
an honest group-scale fallback. Formula-speed canonicalizers, extension-field
matrices, a wider q/field/redundancy benchmark grid, bit-operation accounting,
and comparison with external decoder software remain open benchmark work.
