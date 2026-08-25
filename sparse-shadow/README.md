# sparse-shadow

`sparse-shadow` is an exact, proof-carrying reconstruction and canonicalization
engine for the five reconstruction profiles in *Clebsch: Rigidity from Sparse
Shadows*.

The project is deliberately paperwise: every adapter declares its own input,
action, carrier, reconstruction map, and residual ambiguity. The shared engine
provides deterministic canonicalization, witnesses, certificates, replay, and
stable JSON artifacts. Canonical output includes the complete certified
automorphism order and generators, vertex orbits, and an explicit point
stabilizer for one representative of every vertex orbit.

The first development gate enables only the hand-checkable Paper-I orientation
fixtures: an uncalibrated shadow with residual `C2` and a calibrated triangle
with exact oriented return. The other four typed profiles are represented in
schema version 1 but remain explicitly gated until their frozen exported
fixtures exist; failure diagnostics name the required export.

## Toolchain and commands

The MSRV is Rust 1.85.0 (edition 2024); `rust-toolchain.toml` pins the same
compiler for reproducible development.

```sh
cargo test --workspace --all-features
cargo clippy --workspace --all-targets --all-features -- -D warnings
cargo deny check
cargo bench --bench paper_i -- --noplot
cargo run -p sparse-shadow-cli -- validate fixtures/paper-i-icosahedral-orbitals.json
cargo run -p sparse-shadow-cli -- canonicalize fixtures/paper-i-icosahedral-orbitals.json
cargo run -p sparse-shadow-cli -- reconstruct fixtures/paper-i-calibrated-icosahedral-orbitals.json
cargo run -p sparse-shadow-cli -- equivalent LEFT.json RIGHT.json
```

`equivalent` emits explicit isomorphism witnesses or an inequivalence separator
backed by both exhaustive canonical certificates. Dedicated verifier commands
replay canonical, equivalence, and reconstruction artifacts from the raw
input(s). Black-box tests pass each emitted certificate back through its CLI
verifier and require corrupted artifacts to exit nonzero.

See `docs/schema-v1.md`, `docs/certificate-rules-v1.md`,
`docs/dependency-audit.md`, `docs/prior-art-audit.md`, and
`docs/performance-paper-i.md` for the frozen boundaries and measured evidence.
