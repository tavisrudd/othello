# Verification surface for the q=13 passant code

This directory will be the paper-owned trust boundary for Paper IV. The
release verifier must distinguish five modes:

1. human structural proof;
2. published theorem imported by pinpoint citation;
3. kernel-checked Lean theorem;
4. compact finite certificate checked by a proved or transparent checker; and
5. independent trusted exact execution.

The current `claim_map.json` records the frozen source claims and their
present trust modes. `evidence_manifest.json` records the first byte-for-byte
migration from Paper I, including source commit, paths, byte counts, hashes,
commands, and replay relationships. This infrastructure is not yet a release
certificate.

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

The shared `finitegeom` repository should contain semantic, reusable modules:

```text
RelativeConicArcs/ConicPassantCode.lean
RelativeConicArcs/PassantCodeQ13/Geometry.lean
RelativeConicArcs/PassantCodeQ13/Rank.lean
RelativeConicArcs/PassantCodeQ13/WeightEight.lean
RelativeConicArcs/PassantCodeQ13/AssociationAlgebra.lean
RelativeConicArcs/PassantCodeQ13/Reconstruction.lean
RelativeConicArcs/Gates/PassantCodeQ13.lean
```

Large generated finite leaves belong in a standalone certificate package,
partitioned by mathematical role rather than build chronology:

```text
PassantCodeQ13/WeightTen/IsolatedProfile.lean
PassantCodeQ13/WeightTen/CycleProfile.lean
PassantCodeQ13/MinimumWords/OrbitS4.lean
PassantCodeQ13/MinimumWords/OrbitDihedral.lean
PassantCodeQ13/MinimumWords/Reconstruction.lean
PassantCodeQ13/Gates/Main.lean
```

The public aggregate must prove the exact paper theorem or expose its residual
human boundary. Its axiom report must be generated from the pinned toolchain's
actual `#print axioms` output. Task identifiers, manuscript section numbers,
private reports, and workflow status language are forbidden from module names,
declaration names, comments, and generated banners.

## Formalization target

The preferred endpoint is an axiom-free finite theorem, apart from Mathlib's
standard logical axioms, establishing:

- the binary code has length 78, dimension 36, and minimum distance 12;
- its minimum layer has 364 words in the stated four orbits;
- each orbit spans the code;
- concurrence recovers the six elliptic relations and the 78 incidence rows;
- the resulting coordinate-permutation automorphism group is
  `PGL(2,13)`.

The formal proof should preserve the human mechanisms. In particular, it
should formalize the tangent-graph reduction in weight eight, the exhaustive
coverage theorem for the two weight-ten profiles, the mod-two association-
algebra spanning argument, and the anchor proof of the automorphism group.
It should not replace the entire theorem by an opaque enumeration of
`2^78` words.
