# sparse-shadow

`sparse-shadow` is an exact, proof-carrying reconstruction and canonicalization
engine for the five reconstruction profiles in *Clebsch: Rigidity from Sparse
Shadows*.

The project is deliberately paperwise: every adapter declares its own input,
action, carrier, reconstruction map, and residual ambiguity. The shared engine
provides deterministic canonicalization, witnesses, certificates, replay, and
stable JSON artifacts. Canonical output includes the complete certified
automorphism order and generators, vertex orbits, and an explicit point
stabilizer for one representative of every vertex orbit. The input interchange
schema is `sparse-shadow/v1`; the expanded canonical wrapper is
`sparse-shadow-canonical/v2`, while its unchanged exhaustive proof is
`sparse-shadow-certificate/v1`.

Paper-I reconstruction output is `sparse-shadow-reconstruction/v2`; Papers II
through V use paper-specific reconstruction-v1 artifacts. Their typed carriers
retain the exact matching trade, rational twist and calibrated conference
two-graph, marked projective plane, and chordal/conference return respectively.
Automorphism, orbit, and point-stabilizer fields use raw input coordinates;
`input_to_canonical` is the explicit bridge between the two bases.

All five paper adapters are enabled from their paper-owned exports. Paper III
consumes `papers/clebsch-passages/verification/sparse_shadow_export.json`,
exhausts the full six-label action, independently replays its canonical proof,
and returns the rational twist, golden fibre algebra, conference switching
class, and calibrated orientation. The separate `gated-*` fixtures remain
disabled fail-closed schema examples.

`fixtures/paper-i-golden-contract.json` freezes the enabled adapter's canonical
identities, group and point-stabilizer summaries, vertex orbits, exhaustive
search counters, proof-system identifiers, and both reconstructed six-axis
carriers. It also pins BLAKE3 digests of exact stdout bytes for validate,
canonicalize, reconstruct, and equivalence commands. Changes to those values require
an explicit contract review rather than merely remaining deterministic within
one build.
`fixtures/paper-iv-golden-contract.json` likewise freezes Paper IV's canonical
identity, exhaustive counters, full group order, reconstruction census, exact
CLI stdout digests, and nauty 2.9.3 comparison.

## Toolchain and commands

The MSRV is Rust 1.85.0 (edition 2024); `rust-toolchain.toml` pins the same
compiler for reproducible development.

For registry release, `sparse-shadow-core` must be packaged and published before
the same-version CLI. The CLI manifest deliberately retains both the local path
and exact compatible version; no crate was published as part of this task.
The core `.crate` is self-contained for unit/doc testing; the complete
integration, golden-contract, gate, and benchmark evidence remains in this
standalone workspace.

```sh
cargo test --workspace --all-features
cargo clippy --workspace --all-targets --all-features -- -D warnings
cargo deny check
sha256sum --check fixtures/SHA256SUMS
cargo bench --bench paper_i -- --noplot
cargo run -p sparse-shadow-cli -- validate fixtures/paper-i-icosahedral-orbitals.json
cargo run -p sparse-shadow-cli -- canonicalize fixtures/paper-i-icosahedral-orbitals.json
cargo run -p sparse-shadow-cli -- reconstruct fixtures/paper-i-calibrated-icosahedral-orbitals.json
cargo run -p sparse-shadow-cli -- equivalent LEFT.json RIGHT.json
cargo run -p sparse-shadow-cli -- verify-certificate INPUT.json CANONICAL-OUTPUT.json
```

`equivalent` emits explicit isomorphism witnesses or an inequivalence separator
backed by both exhaustive canonical certificates. Dedicated verifier commands
replay canonical, equivalence, and reconstruction artifacts from the raw
input(s). Black-box tests pass each emitted certificate back through its CLI
verifier and require corrupted artifacts to exit nonzero. `verify-certificate`
accepts the complete output of `canonicalize` directly; it also accepts a bare
nested canonical certificate for compatibility.

See `docs/schema-v1.md`, `docs/certificate-rules-v1.md`,
`docs/dependency-audit.md`, `docs/prior-art-audit.md`, and
`docs/performance-paper-i.md` for the frozen boundaries and measured evidence.

## External canonicalization baselines

The native Rust engine remains the always-available authority. The excluded
`integrations/sparse-shadow-nauty` crate implements the first optional external
cross-check using bundled nauty 2.9.3; it compares canonical colored-incidence
digests and automorphism orders for the raw and native-canonical inputs. A bliss
backend is retained as an open second path behind the same versioned contract.
See `docs/backend-architecture.md` for the trust boundary and frozen encoding.
