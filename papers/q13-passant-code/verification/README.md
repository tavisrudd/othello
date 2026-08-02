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
`lean-certificates/` checks the q=13 coordinate semantics, tangent-graph leaf,
both weight-ten syndrome profiles, and four displayed minimum-word orbits.
Its formal scope is strictly smaller than the complete release theorem.

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

Run all three together, after checking the manifest hashes and byte counts,
with `python3 verify_evidence.py`.

## Lean release layout

The shared Lean library contains these semantic, reusable modules:

```text
RelativeConicArcs/ConicPassantCode.lean
RelativeConicArcs/PassantCodeQ13/Geometry.lean
RelativeConicArcs/PassantCodeQ13/Rank.lean
RelativeConicArcs/PassantCodeQ13/WeightEight.lean
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
PassantCodeQ13/MinimumWords/Reconstruction.lean
PassantCodeQ13/Gates/Main.lean
PassantCodeQ13/Gates/AxiomAudit.lean
```

The public aggregate exposes its formal boundary: it does not establish
arbitrary-word profile transport, minimum-layer exhaustion, uniqueness of the
recovered rows, or the automorphism anchor. Its axiom report comes
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
