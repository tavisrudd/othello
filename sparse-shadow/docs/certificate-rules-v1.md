# Paper-I certificate rules v1

Proof-system identifier: `paper-i-ir-exhaustion/v1`.

This is a deliberately small, adapter-specific proof system. It is not a claim
to reproduce the general `isocert` calculus. The producer and checker have
separate search implementations and share only the typed input/output schema.
The certificate stays compact by asking the checker to rederive the exhausted
tree, rather than serializing all 193 nodes.

The checker accepts a canonical certificate exactly when these rules succeed:

1. **Admissible root.** Schema v1 parses strictly; the two named orbitals are
   disjoint 5-regular graphs, the antipodal relation is 1-regular, and the three
   relations partition all unordered pairs on twelve vertices.
2. **Initial partition.** Vertex color, weight, and sign determine the ordered
   root cells. Provenance is excluded from mathematical identity.
3. **Equitable refinement.** Within each current cell, vertices split by their
   counts into every ordered cell for every named relation, plus calibrated
   triangle membership when present. Refinement repeats to stability.
4. **Complete individualization.** At every nondiscrete node, choose the first
   smallest nonsingleton cell and independently visit every vertex child in its
   stable order. No producer pruning fact or cached partition is trusted.
5. **Canonical leaf.** Encode the named relation of every canonical unordered
   pair, followed by calibration membership, and select the least leaf key.
6. **Transporter.** Apply the claimed input-to-canonical permutation to the raw
   relations and calibration and require the claimed canonical JSON exactly.
7. **Automorphisms.** Every leaf attaining the least key induces an explicit
   input automorphism. Require the certificate's sorted set to equal the full
   independently rederived set; separately verify every action on the input.
8. **Exhaustion commitment.** Require exact agreement on search nodes, leaves,
   refinement rounds, maximum depth, and producer arena grows. This catches
   truncated or differently normalized searches without treating a hash as
   proof.

Only after rules 1--8 pass is BLAKE3 recomputed as the stable artifact identity.
Equivalence additionally verifies the composed left-to-right transporter.
Inequivalence requires two accepted canonical certificates with unequal
identities. Reconstruction additionally verifies the carrier label, residual
orientation ambiguity, calibrated exact-return flag, and round-trip shadow. It
also binds every enclosing canonical-artifact field to the replayed proof:
schema, identity, payload, transporter, search statistics, group order,
generator closure, vertex orbits, and point stabilizers for the least
representative of every orbit. Stabilizer orders, generators, and orbits are
recomputed from the certified full group. Generator replay is
membership-bounded by that group, so hostile wrapper data cannot trigger an
unbounded closure search. Wrapper metadata cannot be altered while retaining a
valid embedded certificate.

The library's `verify_canonical_artifact` entry point and the CLI's
`verify-certificate` command replay this complete wrapper. The CLI accepts the
output of `canonicalize` without extraction, while retaining support for a bare
`CanonicalCertificate`.

The first fixture's certificate is about 5.1 KiB because it carries all 120
automorphisms. The public artifact reports a three-element generating set, but
the proof retains the full set so completeness is independently checkable.
