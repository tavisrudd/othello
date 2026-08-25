# sparse-shadow

`sparse-shadow` is an exact, proof-carrying reconstruction and canonicalization
engine for the five reconstruction profiles in *Clebsch: Rigidity from Sparse
Shadows*.

The project is deliberately paperwise: every adapter declares its own input,
action, carrier, reconstruction map, and residual ambiguity. The shared engine
provides deterministic canonicalization, witnesses, certificates, replay, and
stable JSON artifacts.

The first development gate enables only the hand-checkable Paper-I orientation
fixture. The other four typed profiles are represented in schema version 1 but
remain explicitly gated until their frozen exported fixtures exist.

## Toolchain and commands

The MSRV is Rust 1.85.0 (edition 2024); `rust-toolchain.toml` pins the same
compiler for reproducible development.

```sh
cargo test --workspace --all-features
cargo clippy --workspace --all-targets --all-features -- -D warnings
cargo run -p sparse-shadow-cli -- validate fixtures/paper-i-icosahedral-orbitals.json
cargo run -p sparse-shadow-cli -- canonicalize fixtures/paper-i-icosahedral-orbitals.json
```

See `docs/schema-v1.md`, `docs/dependency-audit.md`, and
`docs/prior-art-audit.md` for the frozen boundaries.

