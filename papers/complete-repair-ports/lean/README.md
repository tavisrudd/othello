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
asymptotic realization theorem remain classified separately until their exact
paper statements are represented here. No literature theorem is declared as a
Lean axiom.

The older shared `RepairPorts` and `RepairCodes` libraries contain
machine-checked components used by the previous manuscript. They are upstream
evidence, not dependencies of this paper-owned package.
