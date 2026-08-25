# Initial dependency audit

Audit date: 2026-08-25. The initial manifest keeps network, FFI, finite-field,
parallel-search, graph-library, and benchmark dependencies out of the runtime
closure.

| crate | role | license policy | feature policy |
|---|---|---|---|
| `serde`, `serde_json` | strict versioned artifacts | MIT OR Apache-2.0 | derive only; no preserve-order dependency |
| `thiserror` | typed library errors | MIT OR Apache-2.0 | default |
| `clap` | thin CLI | MIT OR Apache-2.0 | derive only |
| `indexmap` | deterministic schema maps when adapters need them | MIT OR Apache-2.0 | serde only |
| `blake3` | artifact identities, never proof evidence | CC0-1.0 OR Apache-2.0 OR Apache-2.0 WITH LLVM-exception | default; hashing stays outside search |
| `tracing` | cold-path diagnostics | MIT | default; no subscriber in the core |
| `proptest` | development-only invariance/corruption tests | MIT OR Apache-2.0 | dev dependency only |

The lockfile is authoritative for resolved versions. Before a release, rerun a
machine-readable license audit over the lockfile and record advisories and
maintenance status. `rayon`, `criterion`, `fixedbitset`, `petgraph`, and an
exact finite-field crate are deferred until a measured or adapter-specific need
exists; adding any of them reopens this audit.

