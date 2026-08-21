# Lean companion to the cubic-stabilization irrationality paper

This is a paper-local Mathlib package. Its top-level namespace is

```text
TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality
```

and its reviewer-facing entry point is

```text
TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.PaperInterface
```

The initial module isolates the fixed-phase identification interface. Lean
checks the crossed-row algebra, the closed-fibre vanishing deduction, and the
endpoint-indexed path syntax. The geometric comparison with the actual QDM
packet is represented by an explicit inhabited-structure proposition rather
than an axiom.

From this directory, elaborate the reviewer interface through the repository's
guarded runner:

```text
../../../lean/scripts/guarded-lean --root "$PWD" \
  TavisRuddFiniteGeom/Papers/CubicStabilizationIrrationality/PaperInterface.lean
```

The axiom audit is:

```text
../../../lean/scripts/guarded-lean --root "$PWD" \
  TavisRuddFiniteGeom/Papers/CubicStabilizationIrrationality/Verification/AxiomAudit.lean
```
