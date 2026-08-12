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

The source-only correspondence check is

```text
nix shell nixpkgs#python3 --command python3 \
  verification/check_formal_artifact.py --source-only
```

It requires one claim-map row for every theorem-like manuscript environment,
an exact partition of the reviewer terminals among those rows, and an exact
expected-axiom row for every terminal.  After the guarded build of the axiom
audit, pass its captured standard output back to the same checker:

```text
nix shell nixpkgs#python3 --command python3 \
  verification/check_formal_artifact.py --axiom-log AXIOM_AUDIT_STDOUT
```

The second mode parses the kernel-reported dependencies and rejects any
difference from `verification/expected_axioms.txt`.  A source-only pass does
not claim that Lean was built or that the observed axiom output was checked.
