# Initial dependency audit

## Packaging order

The two crates are versioned together but have the normal registry publication
dependency: package or publish `sparse-shadow-core 0.1.0` before
`sparse-shadow-cli 0.1.0`. A local package dry run for the core succeeds. A CLI
package dry run is expected to fail closed until that exact core version exists
in the configured registry; the path dependency is not rewritten or vendored
to conceal this prerequisite. No publication was performed during C968.

The core archive includes its unit-test Paper-I fixture under `testdata/`; a
workspace test requires semantic equality with the public top-level fixture.
The full integration and benchmark suites remain workspace evidence and are
excluded from the registry archive because their calibrated, gated, and golden
fixtures live at the standalone workspace boundary. A fresh temporary
extraction of the actual `.crate` passes locked/offline unit and doc tests.

Audit date: 2026-08-25. The initial manifest keeps network, FFI, finite-field,
parallel-search, graph-library, and benchmark dependencies out of the runtime
closure.

| crate | role | license policy | feature policy |
|---|---|---|---|
| `serde`, `serde_json` | strict versioned artifacts | MIT OR Apache-2.0 | derive only; no preserve-order dependency |
| `thiserror` | typed library errors | MIT OR Apache-2.0 | default |
| `clap` | thin CLI | MIT OR Apache-2.0 | derive only |
| `blake3` | artifact identities, never proof evidence | CC0-1.0 OR Apache-2.0 OR Apache-2.0 WITH LLVM-exception | default; hashing stays outside search |
| `proptest` | development-only invariance/corruption tests | MIT OR Apache-2.0 | dev dependency only |
| `stats_alloc` | development-only hot-loop allocation assertion | MIT | dev dependency only; wraps the system allocator outside production |
| `criterion` 0.7 | statistically sampled representative end-to-end benchmarks; Rust 1.80 MSRV | MIT OR Apache-2.0 | dev dependency only; default features disabled, so neither Rayon nor plotting enters the lockfile |

The lockfile is authoritative for resolved versions. Before a release, rerun a
machine-readable license audit over the lockfile and record advisories and
maintenance status. `rayon`, `fixedbitset`, `petgraph`, and an
exact finite-field crate are deferred until a measured or adapter-specific need
exists; adding any of them reopens this audit.

Resolved direct versions at the 2026-08-25 gate are `blake3 1.8.7`, `clap
4.6.6`, `serde 1.0.229`, `serde_json 1.0.151`, `thiserror 2.0.20`, `criterion
0.7.0`, `proptest 1.11.0`, and `stats_alloc 0.1.10`. `cargo-deny 0.19.4`
reports advisories, bans, licenses, and sources all green. `deny.toml` rejects
wildcard and unknown registry/git dependencies; duplicate transitive versions
are visible warnings rather than hidden failures.
