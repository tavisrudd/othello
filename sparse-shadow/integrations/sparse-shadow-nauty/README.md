# sparse-shadow-nauty

This optional, unpublished integration cross-checks the authoritative native
Paper-I artifact with bundled nauty 2.9.3. It is deliberately excluded from the
main workspace: native builds, tests, packaging, and verification require no C
compiler, libclang, FFI, or external canonicalizer.

The adapter applies the shared `sparse-shadow-colored-incidence/v1` encoding to
both the raw input and the native canonical payload. It accepts only when nauty
assigns both encodings the same canonical-graph BLAKE3 digest and reports the
same automorphism order as the native certificate. A nauty canonical labeling
does not replace the native transporter or proof artifact.

The published `nauty-Traces-sys` crate runs bindgen at build time. On NixOS, use
the committed shell to provide libclang and C headers:

```sh
nix-shell integrations/sparse-shadow-nauty/shell.nix --run \
  'cargo test --manifest-path integrations/sparse-shadow-nauty/Cargo.toml --locked'
```

Run the cross-check CLI with:

```sh
nix-shell integrations/sparse-shadow-nauty/shell.nix --run \
  'cargo run --manifest-path integrations/sparse-shadow-nauty/Cargo.toml --locked -- \
  fixtures/paper-i-icosahedral-orbitals.json'
```

The separate lockfile pins `nauty-Traces-sys 0.11.0`, whose bundled engine is
nauty/Traces 2.9.3 with TLS enabled. Both are Apache-2.0 licensed. The backend
report records the engine version, dense/bundled/TLS configuration, and nauty
word size.
