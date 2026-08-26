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
| 12-point terminal selector | 7 | 5 | 9,259 | 1 |
| projective locator oracle | 7 | 5 | 74,476 | 409 |
| 12-point terminal selector | 17 | 6 | 24,516 | 1 |
| projective locator oracle | 17 | 6 | 10,866,454 | 89,067 |
| 12-point terminal selector | 7 | 7 | 3,627 | 1 |
| projective locator oracle | 7 | 7 | 5,444,118 | 20,017 |
| tangent semilinear canonicalization | 17 | 6 | 149,895 | 272 transports |
| rootless sigma semilinear canonicalization | 7 | 5 | 39,982 | 48 transports |
| simple-root sigma semilinear canonicalization | 17 | 6 | 49,997 | 16 transports |
| structural tangent canonicalization | 13 | 11 | 221,151 | 156 transports |
| structural sigma canonicalization | 13 | 11 | 508,966 | 168 transports |
| structural multiple-root canonicalization | 13 | 13 | 177,498 | 12 transports |
| end-to-end tangent classification | 17 | 6 | 271,685 | -- |
| positive tangent deep-certificate replay | 17 | 6 | 278,259 | -- |

The optional polynomial-basis extension-field pass adds:

| operation | q | redundancy | ns / iteration | candidates/transports |
|---|---:|---:|---:|---:|
| 12-point terminal selector | 8 | 5 | 101,187 | 1 |
| projective locator oracle | 8 | 5 | 673,196 | 594 |
| maximal-root semilinear canonicalization | 8 | 5 | 653,862 | 42 |
| end-to-end classification | 8 | 5 | 741,621 | -- |
| positive deep-certificate replay | 8 | 5 | 717,238 | -- |
| Lucas-degenerate canonicalization | 9 | 5 | 1,267,369 | 144 |
| full-length structural canonicalization | 16 | 16 | 13,072,870 | 60 |
| characteristic-power structural canonicalization | 32 | 17 | 1,180,758,448 | 4,960 |

The terminal fixtures are respectively the R5 tangent, R6 tangent, and frozen
R7 sporadic representative. Their one-prefix selector outcomes are favorable
instances, not worst-case claims. The proved operation bounds come from
`c969-terminal-hyperplane-solver.md`, not these timings.

Semilinear action rows are evaluated by the exact recurrence
`R_(i+1)=(R_i/Y)X`, so one transport takes `O(r^2+r log q)` field operations
rather than rebuilding all symmetric-power rows independently. The recurrence
and full backend accounting are frozen in
`c969-canonicalization-complexity.md`.

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
Lucas-degenerate `O(m r q^2)` branch, while GF(16)/R16 exercises the `r=q`
structural boundary over a nonprime field. GF(32)/R17 exercises the first
beyond-R10 binary characteristic-power degree and skips the impossible
rootless scan. Comparison with external decoder software remains open benchmark
work.
