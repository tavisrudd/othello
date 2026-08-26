# C968 Paper-II sparse-shadow integration

## Result

Paper II's paper-owned export and C968 adapter are complete. The frozen shadow
contains the exact 22-element H3 perfect-matching orbit on `P1(F11)`, split
into two 11-element PSL sheets. Its declared endpoint action is `PGL2(11)` of
order 1,320. The cubic-first calibration has value 6 and the exact 17-coordinate
support derived from `profile_incidence.json`. Degree-one and degree-two
collisions carry BLAKE3 identities of their compact zero moment vectors.

The native adapter exhausts the declared action, produces a deterministic
canonical representative and transporter, and verifies the full 660-element
oriented automorphism group. A representation-distinct checker rebuilds each
matching as a set of six endpoint pairs and independently recomputes the orbit
minimum and certificate. Reconstruction returns all 22 matchings, their two
oriented sheets, the full action order 1,320, and oriented stabilizer order 660;
the cubic calibration kills the residual orientation `C2`.

The colored-incidence backend has 166 nodes and 396 edges. Bundled nauty 2.9.3
recovers automorphism order 660 on both raw and native-canonical inputs and the
same canonical graph digest
`286566ef3ad75aae814d2b5d0d0ea9fee6902877f500d2b28548d531ef602fa0`.

## Reproducibility

From `papers/clebsch-factorization/`:

```sh
python3 verification/generate_sparse_shadow_export.py --check verification/evidence/sparse_shadow_export.json
sha256sum -c verification/sparse_shadow_export.sha256
```

The checksum manifest freezes the generator, export, and load-bearing source.
The generator rederives the matching orbit, sheet split, action generators,
cubic witness, and cubic support.

From `sparse-shadow/`:

```sh
cargo test --workspace --all-features
cargo clippy --workspace --all-targets --all-features -- -D warnings
cargo doc --workspace --all-features --no-deps
cargo build --release --locked --offline
nix-shell integrations/sparse-shadow-nauty/shell.nix --run \
  'cargo test --manifest-path integrations/sparse-shadow-nauty/Cargo.toml --locked --test paper_ii'
```

The allocator gate records zero allocations, reallocations, and deallocations
inside the 1,320-leaf production loop. Measurements and their boundary are in
`sparse-shadow/docs/performance-paper-ii.md`.

The export-specific generator/checksum gates pass in the paper's pinned Nix
environment. The paper-wide `verify_release.py --metadata-only` currently stops
at its pre-existing statement-identity check because the user-owned modified
`clebsch_factorization.tex` is not represented by the committed identity. This
integration neither stages that manuscript change nor regenerates its identity.

## Boundary

This proves exact behavior for the frozen Paper-II profile and declared action.
It makes no universal canonical-labeling, asymptotic, or performance-floor
claim. Papers III and V remain disabled until their complete exports freeze.

## Mystery ledger

- **Settled:** closeout rejected a hand-transcribed cubic support and replaced
  it with the 17 nonzero coordinates rederived from the source vector; collision
  fields now contain actual BLAKE3 values rather than source SHA-256 values.
- **Explained:** nauty visits 11 nodes on the raw encoding and 13 on the native
  canonical encoding while returning the same digest and group. Its node count
  is labeling-heuristic evidence, not a correctness invariant.
- **Open outside C968:** the three-dimensional outer-odd cubic space is a Paper-II
  mathematical feature, not ambiguity in the selected frozen calibration.
