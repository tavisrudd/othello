# Lean companion to *Exact Transfer of Bounded Linear Recovery and Relative Weight Hierarchies*

This Mathlib-only package is the paper-owned formal companion. Its
reviewer-facing entry point is

```text
TavisRuddFiniteGeom.Papers.RecoveryStructures.PaperInterface
```

and its axiom audit is

```text
TavisRuddFiniteGeom.Papers.RecoveryStructures.Verification.AxiomAudit
```

The package proves the linear-algebraic construction of the nested helper-code
pair associated with target and helper generator maps. The relative generalized
Hamming-weight identification, the concatenation-confinement theorem, and the
asymptotic realization theorem are not formalized in this package and are
classified as absent in the claim map. No literature theorem is declared as a
Lean axiom.

The source and annotation boundary can be checked without invoking Lean:

```text
python3 verification/check_formal_artifact.py --source-only
```

To rebuild the package with its pinned Lean and Mathlib revisions, enter the
Nix development shell and build the two library targets:

```text
nix develop
lake build RecoveryStructures RecoveryStructuresVerification
```

The axiom-audit target prints the dependencies of every reviewer-facing
terminal. The expected sets are recorded in
`verification/expected_axioms.txt`; the release claim is limited to those
terminals.
