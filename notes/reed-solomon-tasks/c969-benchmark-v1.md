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
| 12-point terminal selector | 7 | 5 | 9,248 | 1 |
| projective locator oracle | 7 | 5 | 76,073 | 409 |
| 12-point terminal selector | 17 | 6 | 23,767 | 1 |
| projective locator oracle | 17 | 6 | 10,508,051 | 89,067 |
| 12-point terminal selector | 7 | 7 | 3,970 | 1 |
| projective locator oracle | 7 | 7 | 6,034,364 | 20,017 |
| tangent semilinear canonicalization | 17 | 6 | 397,000 | 272 transports |
| rootless sigma semilinear canonicalization | 7 | 5 | 63,948 | 48 transports |
| simple-root sigma semilinear canonicalization | 17 | 6 | 100,792 | 16 transports |
| structural tangent canonicalization | 13 | 11 | 942,758 | 156 transports |
| structural sigma canonicalization | 13 | 11 | 1,182,996 | 168 transports |
| end-to-end tangent classification | 17 | 6 | 539,730 | -- |
| positive tangent deep-certificate replay | 17 | 6 | 540,651 | -- |

The optional polynomial-basis extension-field pass adds:

| operation | q | redundancy | ns / iteration | candidates/transports |
|---|---:|---:|---:|---:|
| 12-point terminal selector | 8 | 5 | 111,781 | 1 |
| projective locator oracle | 8 | 5 | 721,025 | 594 |
| maximal-root semilinear canonicalization | 8 | 5 | 877,721 | 42 |
| end-to-end classification | 8 | 5 | 1,054,199 | -- |
| positive deep-certificate replay | 8 | 5 | 1,037,706 | -- |
| Lucas-degenerate canonicalization | 9 | 5 | 1,930,036 | 144 |

The terminal fixtures are respectively the R5 tangent, R6 tangent, and frozen
R7 sporadic representative. Their one-prefix selector outcomes are favorable
instances, not worst-case claims. The proved operation bounds come from
`c969-terminal-hyperplane-solver.md`, not these timings.

## Interpretation boundary

The benchmark separates four costs which must not be conflated:

1. fixed-grid terminal completion after streamed prefix selection;
2. the generic exact projective-locator oracle;
3. exact tangent `mq(q-1)`, rootless `m(q^2-1)`, and simple-/multiple-root
   `O(mrq^2)` semilinear canonicalization (usually `O(mrq)` off their degenerate
   successor strata); the charts exhaust all
   binary forms, while explicit `m(q^3-q)` enumeration remains a defensive
   oracle; and
4. independent certificate replay, which intentionally repeats canonical
   transport before checking family and radius evidence.

No timing is a novelty or state-of-the-art claim. The R11 rows exercise only
dimension-independent structural canonicalization; they do not assert an R11
covering radius or coding verdict. The q=8 maximal-root chart reduces the old
explicit 1,512-transport path to 42 exact transports. A wider q/field/redundancy
grid remains open, but the q=9 row separately exercises the simultaneous
Lucas-degenerate `O(m r q^2)` branch. Bit-operation accounting and comparison
with external decoder software also remain open benchmark work.
