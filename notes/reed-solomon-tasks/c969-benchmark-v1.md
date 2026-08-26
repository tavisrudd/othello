# C969 classifier/decoder benchmark v1

## Reproduction

Build and run the standalone harness from the repository root:

```text
cargo build --release --manifest-path rust/prs_classifier/Cargo.toml --bin c969_benchmark
rust/prs_classifier/target/release/c969_benchmark --iterations 10
rust/prs_classifier/target/release/c969_benchmark --iterations 10 --extension-fields
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
| 12-point terminal selector | 7 | 5 | 6,429 | 1 |
| projective locator oracle | 7 | 5 | 54,371 | 409 |
| 12-point terminal selector | 17 | 6 | 16,632 | 1 |
| projective locator oracle | 17 | 6 | 16,529,830 | 89,067 |
| 12-point terminal selector | 7 | 7 | 4,567 | 1 |
| projective locator oracle | 7 | 7 | 8,296,680 | 20,017 |
| tangent semilinear canonicalization | 17 | 6 | 504,884 | 272 transports |
| rootless sigma semilinear canonicalization | 7 | 5 | 56,005 | 48 transports |
| simple-root sigma semilinear canonicalization | 17 | 6 | 89,065 | 16 transports |
| end-to-end tangent classification | 17 | 6 | 719,086 | -- |
| positive tangent deep-certificate replay | 17 | 6 | 717,723 | -- |

The optional polynomial-basis extension-field pass adds:

| operation | q | redundancy | ns / iteration | candidates/transports |
|---|---:|---:|---:|---:|
| 12-point terminal selector | 8 | 5 | 122,916 | 1 |
| projective locator oracle | 8 | 5 | 789,781 | 594 |
| explicit semilinear canonicalization | 8 | 5 | 19,275,349 | 1,512 |
| end-to-end classification | 8 | 5 | 19,618,460 | -- |
| positive deep-certificate replay | 8 | 5 | 19,085,015 | -- |

The terminal fixtures are respectively the R5 tangent, R6 tangent, and frozen
R7 sporadic representative. Their one-prefix selector outcomes are favorable
instances, not worst-case claims. The proved operation bounds come from
`c969-terminal-hyperplane-solver.md`, not these timings.

## Interpretation boundary

The benchmark separates four costs which must not be conflated:

1. fixed-grid terminal completion after streamed prefix selection;
2. the generic exact projective-locator oracle;
3. exact tangent `mq(q-1)`, rootless-sigma `m(q^2-1)`, and simple-root-sigma
   `O(mrq)` semilinear canonicalization; the two sigma charts are exhaustive,
   while the explicit `m(q^3-q)` fallback remains defensive and serves other
   families; and
4. independent certificate replay, which intentionally repeats canonical
   transport before checking family and radius evidence.

No timing is a novelty or state-of-the-art claim. Nonpersistent
canonicalization still uses an honest group-scale fallback. Its remaining
formula-speed canonicalizers, a wider q/field/redundancy benchmark grid beyond
the first GF(8) fixture, bit-operation accounting, and comparison with external
decoder software remain open benchmark work.
