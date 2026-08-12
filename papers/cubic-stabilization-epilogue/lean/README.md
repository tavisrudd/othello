# Lean companion to *Cubic threefolds: cycle triviality versus one-step irrationality*

This Mathlib-only package is the formal companion to the manuscript.  Its
reviewer-facing entry point is

```text
TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.PaperInterface
```

and its axiom audit is

```text
TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Verification.AxiomAudit
```

The package separates two kinds of statement.  Algebraic and logical
deductions are proved by Lean's kernel.  Deep geometric and quantum comparison
theorems imported from the literature occur as explicit hypotheses of
conditional interfaces; they are not declared as Lean axioms and are not
reported as independently formalized.

From the monorepo root, build only through the guarded queue:

```text
lean/scripts/lean-build-queue.py build \
  CubicStabilizationEpilogue \
  --lean-root papers/cubic-stabilization-epilogue/lean --cores 20-23
```

The paper-level verifier additionally checks the public terminal list, source
hygiene, forbidden proof mechanisms, axiom output, and manuscript claim map.
