# C968 Paper-IV sparse-shadow export

## Result

Paper IV now owns a deterministic `sparse-shadow/v1` export containing all
`78 choose 2 = 3003` pair concurrences obtained from the 364 minimum supports,
together with three explicit coordinate permutations.  The producer refuses
to emit unless the concurrence distribution is
`6^1092 7^546 8^273 9^546 12^546` and the permutation closure has order 2184.

The C968 Rust verifier independently checks the frozen source identity, exact
field and census contract, complete pair domain, multiplicity distribution,
permutation validity, pair-weight invariance, and bounded closure order.  It
rejects corrupted pair weights, source hashes, and action generators.

## Reproduction

From `papers/q13-passant-code/`:

```sh
nix shell nixpkgs#python3 --command python3 verification/generate_sparse_shadow_export.py --check verification/sparse_shadow_export.json
```

From `sparse-shadow/`:

```sh
cargo test --locked --workspace --all-features
cargo run --locked -q -p sparse-shadow-cli -- validate ../papers/q13-passant-code/verification/sparse_shadow_export.json
```

The producer and export are recorded in Paper IV's
`verification/evidence_manifest.json`:

- `generate_sparse_shadow_export.py`: 4907 bytes,
  SHA-256 `0ae6a5694c0d4dc5f36e356b13e98e70ab385b44bf6d4e655a2dab4074c9aaf7`;
- `sparse_shadow_export.json`: 287045 bytes,
  SHA-256 `dbccc767a9054ac17253f55347efe9917d53d40eb8ab398b5b1123881b021aa2`.

The load-bearing antecedent is `verification/pair_reconstruction.json`,
SHA-256 `cb9c1da169cef5f23402bb87d28d4f5885ddecb9ae7d92f784803a2d9d8d0ae6`.
Enumeration is deterministic and uses no random seed.

## Boundary and next gate

This slice certifies a complete weighted-pair object and an explicit
weight-preserving subgroup of order 2184.  It does not yet certify that this is
the full automorphism group, canonically reconstruct the six elliptic
relations or 78 incidence rows, or recover the marked plane, conic, and
polarity.  C968 next implements those independent reconstruction checks before
enabling canonicalization and reconstruction certificates for Paper IV.

## Mystery ledger

- **Full-group equality:** unsettled in C968.  The export proves a subgroup of
  order 2184; full scheme rigidity or an independent nauty census must exclude
  extra automorphisms.
- **Intrinsic coordinate recovery:** unsettled in C968.  Pair multiplicities
  expose five classes immediately, but the exact route from those classes to
  the six elliptic relations and the 78 incidence rows still needs an
  independently replayed adapter.
- **Marking torsor:** unsettled in C968.  The export declares `PGL2(13)`, but
  the canonical artifact must recover and verify the marking action rather
  than trust the label.
- **Settled by the closeout pass:** no additional field-arithmetic dependency
  is needed for this first gate; prime-field arithmetic is already eliminated
  into the exported integral pair weights and permutations.
