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

- 4 absent from Lean;
- 15 represented by exact but strictly weaker fragments;
- 3 represented by conditional deductions with every external premise exposed
  in the theorem type;
- 1 completely formalized from the manuscript's stated hypotheses.

Checked coverage snapshot: 23 claims; 4 absent; 15 fragmentary; 3 conditional;
1 complete; 57 reviewer terminals.

The 57 reviewer-facing terminals currently verify:

- the exact DVR rank-one generation equivalence for arbitrary finite symmetric
  matrix-of-ideals lattices;
- the square-zero divided-power expansion;
- finite internal rank-one list extraction and its all-degree square-zero
  realization consequence, together with exact reflection of integral-product
  membership from a faithfully flat tensor extension via the quotient module;
- elementwise local-to-global subgroup membership from prime-to-prime
  denominator witnesses, including its composition with all-degree rank-one
  assembly into an abstract integral product subgroup;
- the equivalence of the dual- and coefficient-form adjoint conventions,
  graph-coordinate block multiplication, equivalence of entrywise integrality
  with the three displayed block conditions, the exact DVR equivalence between
  scalar-difference-product divisibility and the truncated valuation deficit,
  the reduction of the full split-slope commutator to that deficit under the
  two diagonal coefficient conditions, the exact equivalence between the
  single cross-depth condition and all three split-slope block conditions,
  now for actual rectangular matrices of arbitrary finite block ranks; the
  unit-to-positive rectangular commutator calculation; and the remaining
  intersection arithmetic, assembled across a finite dependent family of
  blocks including unrestricted depth-zero blocks, underlying the
  coefficient-lattice calculation;
- the `6I-J` eigenspaces, an explicit integral Smith reduction to
  `diag(1,6,6,6,6)`, uniqueness of the polarization parameters, the explicit
  orthogonal local block, and its exact depth-one arithmetic at two and three;
- the projective-line classification into scalar graphs and the vertical
  line, the five- and four-member finite-field packet counts, and the
  isotropic half-dimension calculation for self-adjoint graph slopes;
- the fixed points and exchanged non-prime-field pair for squaring Frobenius
  on the concrete four-element field, without identifying any geometric
  normalizer action with that field map;
- the manuscript's concrete trace-determinant form on `F4²`, its
  nondegeneracy, the nondegeneracy of the induced two-copy alternating form,
  and self-orthogonality of every scalar graph;
- trace rigidity for a determinant scalar and the transparent finite-field
  cardinality calculation `|SL₂(F4)| = 60`;
- the faithful action on the five natural projective points, triviality of the
  center in characteristic two, evenness of the projective image, and the
  resulting abstract exceptional isomorphism `SL₂(F4) ≃ A5`, without
  identifying the manuscript's geometric action with this abstract model;
- the order-120 full symmetric normalizer, its index-two alternating subgroup,
  and affine-chart Frobenius as an odd transposition in the nontrivial coset,
  without identifying it with a geometric normalizer;
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

From this package directory, build the pinned Lean library with:

```text
lake build CubicStabilizationEpilogue
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
