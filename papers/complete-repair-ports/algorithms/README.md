# ERGO-Comp

**Exact Recovery and Generalized-weight Optimization Compiler**

ERGO-Comp turns mathematical structure into exact recovery plans for linear
codes. When a problem exposes a quotient, conserved grading, generated-span
state, bounded moment alphabet, or reconstructible coefficient block,
ERGO-Comp compiles that structure into a smaller exact solver and sends only
the surviving core to a specialized enumerator or CP-SAT.

The result is more than an objective value. ERGO-Comp returns the helper
choices, local labels, resource loads, or obstruction certificate needed to
check and deploy the optimum.

## What it does

- **Hierarchical recovery compilation.** Compose labelled prescribed-coset
  costs through concatenated codes by exact min-plus substitution, retaining a
  local witness at every layer.
- **Exact confinement thresholds.** Compute generator- and syndrome-side
  thresholds with the target and recoverable sector kept explicit.
- **Capacitated batch repair.** Select the maximum simultaneously repairable
  demand set under helper, rack, link, or service capacities and return the
  complete assignment and load vector.
- **Generated-span reuse.** Compile duplicate, zero, and proportional columns
  once, then answer repeated recovery queries from the resulting span table.
- **Structured code search.** Compile orbit choices, modular syndromes,
  incidence constraints, and reconstructible coefficient blocks before a
  residual exact search.
- **Auditable exactness.** Use integer and finite-field arithmetic throughout,
  with deterministic tie-breaking, Python differential oracles, and replayable
  witnesses.

ERGO-Comp is not a universal replacement for CP-SAT. It is designed for exact
problems whose algebraic structure is expensive for a generic Boolean model to
rediscover. It can solve the compiled problem directly or act as a front end
that gives CP-SAT a smaller, stronger residual model.

## Sixty-second examples

The Rust package provides the `ergo-comp` command. It reads JSON and writes a
deterministic JSON result.

```sh
cd rust
cargo run --release --bin ergo-comp -- \
  schedule --input examples/data/schedule.json
```

The example has two repair demands, two unit-capacity resources, and two legal
helper-load choices per demand. ERGO-Comp returns a complete assignment:

```json
{
  "repaired_count": 2,
  "complete": true,
  "assignment": [
    {"demand": 0, "loads": [0, 1]},
    {"demand": 1, "loads": [1, 0]}
  ],
  "unmatched_demands": [],
  "total_loads": [1, 1],
  "backend": "dense-lattice",
  "transitions_examined": 8,
  "peak_pareto_states": 4
}
```

Hierarchical composition uses the same interface:

```sh
cargo run --release --bin ergo-comp -- \
  compose --input examples/data/compose.json
```

The output reports the exact cost, the compiled state and transition counts,
and the local label chosen in each outer block:

```json
{
  "feasible": true,
  "cost": 2,
  "local_labels": [{"rows": 1, "cols": 1, "data": [1]}],
  "compiled_labels": 2,
  "transitions_examined": 2
}
```

Matrix data is row-major and reduced modulo the declared prime. The composition
command currently dispatches prime fields of orders 2, 3, 5, 7, 11, and 13;
the library API can instantiate other prime orders at compile time.

## Why compilation matters

A generic solver sees variables and constraints. ERGO-Comp also sees the
mathematical reason many of those variables are equivalent or impossible.

For equal-mass concurrent repair, a positive grading proves that distinct
states at a fixed repair count cannot dominate one another. The scheduler can
therefore use an exact graded shell instead of maintaining a generic Pareto
frontier over the entire capacity box.

For repeated inner-code queries, the prescribed-coset cost depends only on a
generated image subspace. A single compiled span catalogue serves every label,
outer code, and later tower level. In the included cyclic binary family, the
catalogue remains at five generated spans while direct lift enumeration grows
through `2^128` candidates.

For orbit-structured code construction, ERGO-Comp quotients symmetry, packs
additive syndrome contributions, applies bounded moment and incidence gates,
and reconstructs coefficient blocks from small seed data. Only the residual
spatial constraints reach the final enumerator.

## Bounded comparison with CP-SAT

The benchmark suite contains both a raw Boolean CP-SAT model and a structured
CP-SAT control. The structured control receives the same feasibility filtering,
duplicate removal, Pareto canonicalization, positive-grading bound,
single-worker policy, and model reuse available without using ERGO-Comp's
specialized dynamic program. All solvers must agree on the optimum and retained
loads before timing is accepted.

An interleaved 11-round comparison on the frozen scheduler profiles measured:

| profile | ERGO-Comp | raw CP-SAT | structured CP-SAT | vs. raw | vs. structured |
|---|---:|---:|---:|---:|---:|
| shell large-box | 71.881 us | 178.630 us | 177.221 us | 2.485x | 2.465x |
| balanced | 3.710 us | 1.143 ms | 995.895 us | 308.036x | 268.441x |
| small-state | 7.304 us | 2.753 ms | 2.723 ms | 376.977x | 372.846x |
| large nonuniform | 52.849 us | 1.250 ms | 1.041 ms | 23.646x | 19.697x |

These are bounded results for the declared profiles, not a general solver
ranking. The exact machine, toolchain, inputs, repetitions, samples, checksums,
and peak-memory observations live in `rust/evidence/benchmarks.json`. The
rotated harness keeps model construction and reuse policies explicit.

Component benchmarks are reported separately from these end-to-end solver
comparisons. Nanosecond kernel timings do not constitute CP-SAT speedups.

## Architecture

The Rust engine is organized around compact, contiguous state:

- range-sized integer identifiers into arena-backed witness pools;
- row-major matrices and packed ternary syndromes;
- generated-span and min-plus tables with deterministic canonicalization;
- adaptive sparse-Pareto, dense-lattice, and graded-shell scheduling;
- transactional rollback elimination for incremental finite-field constraints;
- optional Rayon parallelism outside the narrow sequential kernels; and
- portable safe Rust in the core engine, with no raw-pointer hot-path design.

The Python package in `recovery_algorithms/` is the independent exact oracle.
It favors transparent enumeration and algebra over throughput. Rust fixtures
are generated from the Python implementation, then checked for costs,
witnesses, and helper loads.

## Validation

From `rust/`:

```sh
cargo fmt --check
cargo clippy --all-targets --all-features -- -D warnings
cargo test --all-features
```

From this directory:

```sh
python3 -m unittest -v test_algorithms.py
python3 generate_evidence.py --check
```

Release measurements use an explicit target flag rather than a repository-wide
Cargo override. The current reproducible x86-64 baseline is built with:

```sh
RUSTFLAGS="-C target-cpu=x86-64-v3" \
  cargo build --release --manifest-path rust/Cargo.toml --bin bench_kernels
```

Portable builds use Cargo's default target. A native or AVX-512-enabled build
is not assumed to be faster; it must win the same interleaved workload before
being reported.

## Evidence and trust boundary

`generate_evidence.py` produces canonical JSON and `SHA256SUMS`, and its
`--check` mode regenerates the claims without changing the tree. The evidence
records exact bounded computations and benchmark observations. It does not turn
a finite search into an unrestricted theorem or make program execution part of
the proof of a manuscript theorem.

The mathematical definitions, correctness statements, and complexity bounds
are given in *Exact Transfer of Bounded Linear Recovery and Relative Weight
Hierarchies*. The implementation is a companion for computing and checking the
paper's optimization objects.

## License

ERGO-Comp is released under the MIT License as part of the paper's companion
repository.
