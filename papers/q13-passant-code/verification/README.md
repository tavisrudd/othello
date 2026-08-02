# Verification surface for the q=13 passant code

This directory is the paper-owned trust boundary for Paper IV. The human
structural proof is primary. Evidence records discovery and discharges only
finite terminal leaves that have not admitted useful conceptual compression.
Within that hierarchy, the release verifier distinguishes five modes:

1. human structural proof;
2. published theorem imported by pinpoint citation;
3. kernel-checked Lean theorem;
4. compact finite certificate checked by a proved or transparent checker; and
5. independent trusted exact execution.

The current `claim_map.json` records the frozen source claims and their
present trust modes. `evidence_manifest.json` records the first byte-for-byte
migration from Paper I, including source commit, paths, byte counts, hashes,
commands, and replay relationships. The paper-owned Lean package under
`lean-certificates/`, together with the shared semantic library, checks the q=13 coordinate
semantics, transports the normalized weight-eight reduction to the cyclic tangent graph, checks
both weight-ten syndrome profiles, and checks four displayed minimum-word orbits.  Its fixed-point
weight-twelve leaf exhausts the four pencil-profile domains and identifies their 56 solutions with
the four disjoint 14-support orbit slices; the point stabilizer acts transitively on each slice.
Its association transport proves that every displayed orbit spans the rho-zero kernel.
Its formal scope is strictly smaller than the complete release theorem.
The normalized weight-eight terminal is
`RelativeConicArcs.Gates.PassantCodeQ13.weightEight_semantic_transport`.
The arbitrary-word weight-ten profile terminal is
`RelativeConicArcs.Gates.PassantCodeQ13.arbitrary_weightTen_profile_transport`.

## Evidence to extract

The following Paper-I files were copied byte-for-byte into this root at the
source revision recorded by `evidence_manifest.json`:

- `papers/clebsch-rigidity/check_q13_tangent_code.py`;
- `papers/clebsch-rigidity/verification/c723_q13_weight10_profiles.py`;
- `papers/clebsch-rigidity/verification/c723_q13_weight10_profiles.json`;
- `papers/clebsch-rigidity/verification/c723_q13_weight10_independent.py`.

The copies are regular files and are now owned by Paper IV. Subsequent changes
must use paper-local names and semantics, preserve the migration provenance,
and refresh the current-file hashes. They must not depend on an internal task
report.

The current paper-local entry points are:

- `generate_weight_ten_profiles.py --check` for the canonical certificate;
- `replay_weight_ten_profiles.py` for the independent dynamic program; and
- `check_q13_tangent_code.py` for the full exact replay.
- `../lean-certificates/generate_rank_transport.py --check` for byte-identical regeneration of
  the recovery and expansion masks used by the semantic rank theorem.

Run all three together, after checking the manifest hashes and byte counts,
with `python3 verify_evidence.py`.

## Lean release layout

The shared Lean library contains these semantic, reusable modules:

```text
RelativeConicArcs/ConicPassantCode.lean
RelativeConicArcs/PassantCodeQ13/Geometry.lean
RelativeConicArcs/PassantCodeQ13/Rank.lean
RelativeConicArcs/PassantCodeQ13/WeightEight.lean
RelativeConicArcs/PassantCodeQ13/WeightTen.lean
RelativeConicArcs/PassantCodeQ13/AssociationAlgebra.lean
RelativeConicArcs/PassantCodeQ13/Reconstruction.lean
RelativeConicArcs/Gates/PassantCodeQ13.lean
```

The paper-owned standalone Lake package contains finite leaves partitioned by
mathematical role rather than build chronology:

```text
PassantCodeQ13/WeightTen/IsolatedProfile/Fibre0.lean ... Fibre6.lean
PassantCodeQ13/WeightTen/CycleProfile/Residue0.lean ... Residue6.lean
PassantCodeQ13/WeightTen/Aggregate.lean
PassantCodeQ13/MinimumWords/OrbitS4.lean
PassantCodeQ13/MinimumWords/OrbitDihedral.lean
PassantCodeQ13/MinimumWords/Exhaustion.lean
PassantCodeQ13/MinimumWords/Reconstruction.lean
PassantCodeQ13/AssociationTransport/Base.lean
PassantCodeQ13/AssociationTransport/RelationSquares/RhoZero.lean
PassantCodeQ13/AssociationTransport/RelationSquares/Nine.lean
PassantCodeQ13/AssociationTransport/RelationSquares/Ten.lean
PassantCodeQ13/AssociationTransport/RelationSquares/Twelve.lean
PassantCodeQ13/AssociationTransport/RelationSquares.lean
PassantCodeQ13/AssociationTransport/OrbitS4.lean
PassantCodeQ13/AssociationTransport/OrbitDihedralA.lean
PassantCodeQ13/AssociationTransport/OrbitDihedralB.lean
PassantCodeQ13/AssociationTransport/OrbitDihedralC.lean
PassantCodeQ13/AssociationTransport.lean
PassantCodeQ13/Gates/Main.lean
PassantCodeQ13/Gates/AxiomAudit.lean
```

The public aggregate transports its exact 42-column elimination certificate to semantic rank and
code dimension, transports every supported point of every weight-ten word to one of the two
exhaustive pencil profiles, and checks the fixed-point weight-twelve exhaustion against the four
projective orbit slices.  The fixed-point stabilizer acts transitively on each 14-support slice.
Eight bounded association leaves, joined by one generic parity-to-matrix theorem, identify the four
orbit Grams and prove that every orbit row space equals the kernel of the rho-zero relation matrix.
Polarity identifies that matrix with the incidence matrix up to row order.  The passage from the
fixed point to the global 364-support layer remains
the human projective-transitivity and double-count argument.  The aggregate does not establish
uniqueness of the recovered rows or the automorphism anchor. Its axiom report comes
from the pinned toolchain's actual `#print axioms` output. Task identifiers,
manuscript section numbers, private reports, and workflow status language are
forbidden from module names, declaration names, comments, and generated
banners.

## Semantic mirror and finite-leaf target

The preferred endpoint is a semantic Lean mirror of the human mechanisms,
with kernel checking at irreducibly finite leaves. It should eventually
establish, apart from Mathlib's standard logical axioms:

- the binary code has length 78, dimension 36, and minimum distance 12;
- its minimum layer has 364 words in the stated four orbits;
- each orbit spans the code;
- concurrence recovers the six elliptic relations and the 78 incidence rows;
- the resulting coordinate-permutation automorphism group is
  `PGL(2,13)`.

This formal surface is supporting evidence, not the manuscript's narrative
spine. It should preserve the human mechanisms. In particular, it
should formalize the tangent-graph reduction in weight eight, the exhaustive
coverage theorem for the two weight-ten profiles, the mod-two association-
algebra spanning argument, and the anchor proof of the automorphism group.
It should not replace the entire theorem by an opaque enumeration of
`2^78` words.
