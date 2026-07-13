# Adversarial review: equivariant extension and robust completion

Date: 2026-07-12
Target: `paper-baer-equivariant-robust-completion.md` and its Lean proof lane

## Verdict

The abstract proof spine is sound, `sorry`-free, and materially stronger than the initial prose
package. The concrete projective-plane secant theorem is also kernel-checked. The paper is **not yet
entitled to claim a fully formalized quadratic-Frobenius pair-extension theorem**: the exact
field-specific cardinalities are fields of `QuadraticBaerPairExtensionData`. The coordinate
Frobenius action on `PG(2,s²)` is now constructed and proved incidence-preserving and involutive;
its fixed-locus normalization and exact pair-count incidence maps are not yet derived.

This is a clean, localized gap rather than a gap in the counting argument. A paper proof can close
it with standard finite-field/projective-plane facts and citations, but the Lean trust statement
must call the result “formalized from exact geometric count inputs” until those inputs are proved.

## Checks passed

- No `sorry`, `admit`, custom `axiom`, or `unsafe` declaration occurs in the new proof lane or its
  concrete projective-plane instances.
- `#print axioms` on the headline declarations reports only Lean's standard `propext`,
  `Classical.choice`, and `Quot.sound` dependencies.
- The combined `FiniteGeom` and `RelativeConicArcs` build passes.
- `git diff --check` passes.
- The all-dependent-traces hypergraph and the minimal secant-pair clutter are now explicitly
  distinguished. This repairs the most serious ambiguity in the original prose.

## Theorem-by-theorem audit

### Theorem A — completion distance equals transversal number

Verdict: **proved, general form**.

`Obstruction.lean` proves the semantic insertion equivalence and the distance identity for every
finite hereditary independence system. This is stronger than a matroid-only statement.

### Theorem B — sharp deletion radius and completion core

Verdict: **proved for an explicit finite family of facets**.

`Core.lean` proves uniqueness below the separation radius, equality of the core with the unique
facet, and the sharp alternative-facet witness. Maximality is intentionally external: once the
facet family is supplied, it is irrelevant to the set-theoretic proof.

### Theorem C — secant resilience

Verdict: **fully proved in abstract projective planes**.

`RelativeConicArcs/CompletionDistance.lean` constructs the minimal secant-pair hypergraph and proves
both `arcInsertionDistance_eq_pointIndex` and the global minimum theorem. It uses the existing
canonical-pair and disjointness results from `RelativeConicArcs.Moments`.

### Theorem D — exact classical-family radii

Verdict: **not formalized; citation-dependent application table**.

The reduction from secant indices to completion distance is proved. The displayed conic, hyperoval,
maximal-arc, elliptic-quadric, ovoid, and spread values still require primary citations and, for a
machine-checked claim, family-specific incidence counts. The table must not be labeled fully
formalized.

### Theorem E — fixed and conjugate Baer secants

Verdict: **proved for any incidence-preserving projective-plane involution**.

`BaerPlane.lean` and `RelativeConicArcs/BaerIncidence.lean` prove trace transport, fixed two-trace
classification, and disjointness of conjugate nonfixed-line traces. `ProjectiveConjugation.lean`
constructs coordinatewise field-automorphism action and proves incidence preservation;
`QuadraticFrobenius.lean` proves the relative Frobenius action involutive in extension degree two.
The remaining field-specific step identifies its projective fixed locus with `PG(2,s)`.

### Theorem F — quantitative conjugate-pair extension

Verdict: **counting implication proved; geometric inputs packaged**.

`PairExtension.lean` proves the heterogeneous sum bound, its exact form when forbidden sets lie in
candidate sets, the uniform `E(N-M)` corollary, and legal-pair existence. The quadratic wrapper uses
the paper's formulas. However, `emptyLine_count`, `candidate_count`, and `forbidden_bound` are
structure fields. `OrbitCounting.lean` reduces them to an occupied/empty complement, a two-to-one
mate-pair map, and an injective obstruction-orbit charging map. A complete coordinate formalization
must construct those maps and verify their incidence properties.

The heterogeneous theorem is stronger and should be stated first:

```text
N_pair ≥ Σ over empty fixed lines ℓ of (N_ℓ-M_ℓ)_+.
```

The uniform theorem is its constant-profile corollary.

### Corollary G — square-root orbit saturation

Verdict: **denominator-free quadratic core proved**.

`OrbitSaturation.lean` proves the split-product bound and
`2s(s-1) ≤ (k-1)²`. The displayed ceiling/square-root reformulation and the profile-specific
eight-arc inequalities are now supported by `RelativeConicArcs/BaerArithmetic.lean`, which proves
`M≤12` and the candidate surplus for `s≥7`. The ceiling/square-root reformulation remains prose
arithmetic. A “fully Lean-formalized” label for that presentation would presently be too strong.

### Theorem H — robust fixed holes

Verdict: **proved and strengthened**.

`RobustHole.lean` proves survival below `τ` and below secant count. The perturbation hypothesis can
be weakened from equality of obstruction hypergraphs: it suffices that every old obstruction trace
remains supported. New obstructions are harmless.

## Adversarial findings requiring paper edits

1. Replace “complete obstruction hypergraph has one edge per secant” with “the minimal-obstruction
   clutter has one edge per secant.” The complete dependent-trace hypergraph also contains all
   dependent supersets.
2. State the heterogeneous pair-extension theorem before the uniform bound.
3. Keep the abstract involution, coordinate projective conjugation, and exact quadratic count-data
   instance as three explicit trust layers.
4. Mark the classical-family table as citation-backed rather than Lean-backed.
5. State the quadratic saturation inequality as the formal core; derive the square-root ceiling in
   prose or add a dedicated integer-square-root module.
6. Strengthen perturbation stability from obstruction equality to persistence of old obstructions.
7. Do not claim a new square-root constant; the novelty candidate is the orbit-valued criterion,
   heterogeneous count, and robustness coupling.

## Remaining completion gates

1. Identify the fixed projective locus of quadratic Frobenius with the embedded `PG(2,s)`, including
   the semilinear-eigenvector normalization step.
2. Construct the complement, mate-pair, and injective charging maps that discharge the three
   `QuadraticBaerPairExtensionData` fields.
3. Add primary citations for every row of the classical-family radius table.
4. Decide whether the manuscript promises machine checking of the square-root ceiling itself or
   only its stronger denominator-free quadratic inequality.

Until gates 1–2 land, the accurate trust claim is: **the general completion, secant, involution,
counting, robustness, and saturation mechanisms and the coordinate quadratic-Frobenius incidence
action are kernel-checked; the exact quadratic finite-field cardinality instance is proved in prose
from standard geometry.**
