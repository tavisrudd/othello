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

The completed adapter then exhausts the weighted-scheme canonical search with
3,901 nodes and 2,184 least leaves, proving that the full automorphism group has
order 2,184.  A representation-distinct checker repeats the tree.  Exact
arithmetic recovery splits the two multiplicity-six relations intrinsically,
recovers all six elliptic relations, the 78 passant rows, binary rank 36, all
183 points and lines of `PG(2,13)`, its 14-point conic and polarity, and the
residual `PGL2(13)` marking torsor.  Canonical, equivalence, reconstruction,
corruption, relabeling, idempotence, CLI, golden-output, and nauty gates pass.

## Reproduction

From `papers/q13-passant-code/`:

```sh
nix shell nixpkgs#python3 --command python3 verification/generate_sparse_shadow_export.py --check verification/sparse_shadow_export.json
```

From `sparse-shadow/`:

```sh
cargo test --release --locked --workspace --all-features
cargo run --locked -q -p sparse-shadow-cli -- validate ../papers/q13-passant-code/verification/sparse_shadow_export.json
nix-shell integrations/sparse-shadow-nauty/shell.nix --run \
  'cargo test --release --manifest-path integrations/sparse-shadow-nauty/Cargo.toml --locked'
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
`fixtures/paper-iv-golden-contract.json` freezes the canonical and
reconstruction stdout BLAKE3 digests and the nauty comparison; its SHA-256 is
`a262edfd6b0c10c7be6e3f0888beae1026542e34a1b3b36e6c39f8e7e61cb63c`.

## Boundary

The Paper-IV integration is complete.  It proves the exact finite artifact and
its declared reconstruction; it does not claim a uniform-q theorem, a new
graph-isomorphism bound, or that nauty supplies the native proof.  The complete
automorphism set is carried in the certificate, so canonical stdout is about
2.53 MB and reconstruction stdout about 3.46 MB by deliberate trust-surface
choice.

## Mystery ledger

- **Full-group equality:** settled by two exhaustive native searches and the
  nauty 2.9.3 order-2,184 cross-check.
- **Intrinsic relation recovery:** settled; common multiplicity-seven counts
  two and four split the two multiplicity-six relations without field labels.
- **Marked carrier:** settled by canonical matching to an independently
  generated symmetric-square GF(13) model and exact plane/conic/polarity replay.
- **Performance:** the hot producer is zero-allocation.  `perf` leaves unused
  fixed-signature-tail initialization as a possible speed lever, but no
  correctness or acceptance gap remains and no speedup claim is made.
- **Remaining genuine mysteries:** none within the frozen Paper-IV adapter.
  Uniform-field generalization remains outside C968 and belongs to its existing
  mathematical owners.
