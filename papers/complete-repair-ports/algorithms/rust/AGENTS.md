Read all of `../../../../AGENTS.md` in a dedicated command before doing anything.
Then read all of `../../../../notes/queens-othello-perf-playbook.md` before any
Rust design, implementation, optimization, or benchmark in this directory.

This is private C962 code-and-mathematics work. Do not export, synchronize,
publish, or commit it without explicit user authorization.

## Architecture gate

- This is a Rust-native optimizer, not a file-for-file Python port. Python is
  the exact differential oracle and certificate reference.
- Apply the playbook's Tiger-style rules to every per-state/per-transition
  record and loop: contiguous pools, range-sized integer IDs, explicit repr,
  compile-time size/alignment assertions, no raw pointers, and no owned dynamic
  containers inside hot records.
- Resolve run-constant choices once. Prefer const-generic monomorphization for
  field order and instrumentation. Do not read environment variables or branch
  on run-constant flags inside a hot loop.
- Separate hot state from cold indexes, errors, serialization, CLI, tuning,
  and evidence metadata.
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
