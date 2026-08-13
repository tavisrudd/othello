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

## Interim coverage status

This is a publishable partial companion, not a claim of complete
formalization.  The machine-checked claim inventory currently contains all 23
labelled theorem-like environments in the manuscript and classifies them as:

- 7 absent from Lean;
- 13 represented by exact but strictly weaker fragments;
- 3 represented by conditional deductions with every external premise exposed
  in the theorem type;
- 0 completely formalized from the manuscript's stated hypotheses.

Checked coverage snapshot: 23 claims; 7 absent; 13 fragmentary; 3 conditional;
0 complete; 28 reviewer terminals.

The 28 reviewer-facing terminals currently verify:

- constructive two-coordinate rank-one assembly under the midpoint inequality;
- the square-zero divided-power expansion;
- the `6I-J` eigenspaces, an explicit integral Smith reduction to
  `diag(1,6,6,6,6)`, and its exact depth-one arithmetic at two and three;
- finite-matrix definitions and deductions for primitive-sixth multiplicity,
  coefficient extension, conjugacy, pro-Laurent inverse systems, formal base
  shift, and block multiplicity formulas;
- finite-fiber numerical Novikov coefficient pushforward and the algebraic
  core of strict Novikov admissibility and divisor-tag separation;
- typed blowup/blowdown telescoping in dimension four and the conditional cubic
  and genus-eight irrationality deductions;
- the factorization and framed eigenvalues of Cai's displayed rank-two
  indicial polynomial.

The authoritative per-claim account is
[`verification/claims.json`](verification/claims.json).  In particular, the
companion does not yet formalize the relative six-axis geometry, graph-lattice
descent, universal `CH_0` argument, quantum comparison theorems,
low-dimensional vanishing, or Cai's block diagonalization.

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
