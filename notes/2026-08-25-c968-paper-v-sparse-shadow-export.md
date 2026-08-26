# C968 Paper-V sparse-shadow export

## Result

Paper V now owns a deterministic `sparse-shadow/v1` export for its signed
six-axis conference residue, rational conference matrix, selected chordal line,
outer lift, and exact `F11` conference/chordal cubic evidence. The export
records six conference singular points and all twelve singular points of the
chordal control cubic.

C968 independently validates the frozen source identities, the signed `K6`
partition, the matrix equation `Delta^2 = 5I`, both finite-field singular loci,
the selected-line odd calibration, and the full 720-element `S6` action. Its
fixed-key native search and a representation-distinct lexicographic checker
agree on canonical identity
`2515fa4e7a4f27c00330d2ad7ee18a5ed2f9335b10aca10dcae2440683309141`,
720 nodes/leaves, and marked automorphism order one. Reconstruction emits the
six axes, twelve chordal singular points, both cubics, signed residue, and outer
lift, and replays exactly. CLI, corruption, arbitrary-relabeling, idempotence,
golden-output, allocator, and nauty gates pass.

## Reproduction

From `papers/chordal-conference-reconstruction/`:

```sh
make evidence
sha256sum -c verification/sparse_shadow_export.sha256
```

From `sparse-shadow/`:

```sh
cargo test --workspace --all-features --locked --offline
cargo clippy --workspace --all-targets --all-features --locked --offline -- -D warnings
sha256sum -c fixtures/SHA256SUMS
nix-shell integrations/sparse-shadow-nauty/shell.nix --run \
  'cargo test --manifest-path integrations/sparse-shadow-nauty/Cargo.toml --locked --offline'
```

The generator is SHA-256
`91c38a6448cc8a6bd3b81e6f20e40fcc474116c496d61dcbda619e8aa2d2b5d0`; the generated export is
`fc776e473a5adc8cf8366211713f06f3f29bf141ac51473d305e940b56712714`.
Its three frozen antecedents are recorded in
`verification/sparse_shadow_export.sha256`. Enumeration is deterministic and
uses no random seed.

## Boundary

The schema retains the compatibility field name `outer_involution`, but the
frozen permutation is not itself an involution: it has order four, and its
square is inner. It therefore represents the nontrivial order-two outer coset.
The selected chordal line chooses the first of the explicitly frozen exchanged
parameters `[0:1]` and `[1:7]`. No claim is made that the six-axis residue alone
has trivial symmetry or that nauty supplies the native certificate.

## `ej` + `tt` closeout

The cheap extra-value pass made the coset-versus-lift distinction executable:
both the producer and Rust verifier now reject a literal order-two substitution
or a lift whose fourth power is nontrivial. It also tied selected-line index
zero to the exact ordered pair of exchanged chordal parameters instead of
leaving that index as an undocumented convention. Removing an unused producer
helper kept the paper-owned trust surface minimal. A broader projective model
of the whole pencil would add machinery but no new acceptance evidence, so it
is not promoted into this adapter.

## Mystery ledger

- **Why an alleged involution has order four:** settled. The permutation is a
  lift in the normalizer; its square is inner, so its outer coset has order two.
- **Why the marked automorphism group is trivial:** settled by exhaustive native
  and independent searches plus nauty: the signed residue together with the
  chosen outer lift kills the ten-element residue symmetry.
- **Selected-line meaning:** settled by producer checks against the two exact
  exchanged parameters and the odd-calibration replay.
- **Performance:** settled for this frozen fixture only: the 720-leaf hot loop
  allocates nothing and measures 1.76 ms mean task-clock on the recorded host.
  This is not a bound or optimality claim.
- **Remaining genuine mysteries:** none within the frozen Paper-V adapter.
  Paper III's absent paper-owned export is the sole remaining C968 gate and is
  owned by the Paper-III stream.
