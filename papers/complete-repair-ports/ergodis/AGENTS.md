Read all of `../../../AGENTS.md` in a dedicated command before doing anything.
Before editing anything under `src/`, or doing any Ergodis Rust design,
implementation, optimization, profiling, or benchmarking, read all of
`PERFORMANCE.md`. This is mandatory for every agent, including agents making
changes that are not described as performance work. `PERFORMANCE.md` in turn
requires the shared performance playbook where applicable.

`AGENTS.md` and `PERFORMANCE.md` are private monorepo contributor contracts.
Never include either file in a public export, release manifest, standalone
synchronization, package, or published documentation. `Cargo.toml` excludes
both explicitly; every non-Cargo exporter must do the same.

This is private code-and-mathematics work. Do not export, synchronize,
publish, or commit it without explicit user authorization.

All Ergodis work that is domain-specific, task-specific, experimental, private,
or not demonstrably reusable belongs in the repository-top-level
`ergodis-private/` package, not in this public core. The dependency direction
is one way: `ergodis-private` may depend on Ergodis; Ergodis must not depend on
or name private adapters, fixtures, campaigns, or research process.

## Architecture gate

- This is a Rust-native optimizer, not a file-for-file Python port. Python is
  the exact differential oracle and certificate reference.
- Apply the playbook's Tiger-style rules to every per-state/per-transition
  record and loop: contiguous pools, range-sized integer IDs, explicit repr,
  `#[repr(C, align(64))]` for cache-line records, compile-time size/alignment
  assertions, no raw pointers, and no owned dynamic containers inside hot
  records.
- Resolve run-constant choices once. Prefer const-generic monomorphization for
  field order and instrumentation. Do not read environment variables or branch
  on run-constant flags inside a hot loop.
- Separate hot state from cold indexes, errors, serialization, CLI, tuning,
  and evidence metadata.
- The solve hot loop is completely allocation-free. Allocate and size every
  worker workspace before entering it, and enforce this with a regression test.
- Search-tree traversal is iterative; recursion over the search tree is
  forbidden regardless of the expected instance depth.
- Every change that touches a solve hot loop or hot struct requires a before
  and after profile plus an interleaved A/B with hardware performance counters;
  functional correctness alone is not an acceptance gate.
- Search threads must not contend with one another, including through false
  sharing. Validate affected solve changes in both single-thread and parallel
  modes with identical exact results and recorded work counts.
- Fermi-estimate the expected leverage before a performance rewrite. Optimize
  representation, memory traffic, and state count before instruction shaving.

## Validation gate

Before reporting a coherent change:

1. `cargo fmt --check`;
2. `cargo clippy --all-targets --all-features -- -D warnings`;
3. `cargo test --all-features`;
4. exact differential agreement with the Python oracle on the bounded fixture
   corpus, including costs, witnesses, and helper loads; and
5. for performance claims, a release benchmark with an interleaved A/B design,
   deterministic inputs, state/transition counts, wall time, and peak memory.

Use the repository's Nix toolchain. Benchmark output is noncanonical until the
Python parity gate passes. Never call a measured value a floor or hard limit.
