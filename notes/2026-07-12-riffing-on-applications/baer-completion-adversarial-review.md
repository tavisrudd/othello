# Adversarial review: equivariant extension and robust completion

Date: 2026-07-12
Target: `paper-baer-equivariant-robust-completion.md` and its Lean proof lane

## Verdict

The abstract proof spine and the exact coordinate quadratic-Frobenius pair-extension theorem are
kernel-checked and `sorry`-free. The coordinate lane proves the fixed locus and all cardinalities,
constructs the injective forbidden-candidate charge, identifies forbiddenness semantically with
secant coverage, and produces a conjugate pair whose union with the old set is an arc. The paper may
therefore call Theorem F fully formalized, subject to matching its hypotheses exactly.

This is a proof-validity verdict, not a novelty verdict. Hilbert 90, the Baer fixed subplane,
projective point/line counts, elementary arc double counting, and two-element involution orbits are
classical infrastructure. They must not appear as new discoveries merely because they were newly
formalized here.

## Checks passed

- No `sorry`, `admit`, custom `axiom`, or `unsafe` declaration occurs in the new proof lane or its
  concrete projective-plane instances.
- `#print axioms` on the headline declarations reports only Lean's standard `propext`,
  `Classical.choice`, and `Quot.sound` dependencies.
- Focused builds of `QuadraticLineCounting`, `QuadraticPairExtension`, and `QuadraticForbidden`
  pass.
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
`QuadraticFrobenius.lean` now uses formal Hilbert 90 to identify the projective fixed locus with
`PG(2,s)`, proves its cardinality, and counts fixed and nonfixed points on every fixed line.

### Theorem F — quantitative conjugate-pair extension

Verdict: **fully proved in the coordinate quadratic-Frobenius plane**.

`PairExtension.lean` proves the heterogeneous sum bound, its exact form when forbidden sets lie in
candidate sets, the uniform `E(N-M)` corollary, and abstract legal-pair existence.
`QuadraticLineCounting.lean` proves exact occupied and empty fixed-line counts, including the
nontruncation side condition. `QuadraticForbidden.lean` counts nonfixed secant orbits, constructs
the injective charge, proves forbiddenness equivalent to endpoint secant coverage, and proves that
an uncharged candidate extends the arc. `exists_quadratic_pair_extension` is the end-to-end result.

The heterogeneous theorem is sharper and should distinguish the cardinality `f_ℓ` of the actual
distinct forbidden support from any secant-orbit charge count or upper bound:

```text
N_pair = Σ over empty fixed lines ℓ of (N_ℓ-f_ℓ),
N_pair ≥ Σ over empty fixed lines ℓ of (N_ℓ-U_ℓ)_+  when f_ℓ≤U_ℓ.
```

The uniform theorem is the common upper-bound specialization `U_ℓ=M`. The subsequent novelty audit
also isolates invisible-center and collision-redundancy corrections to this uniform bound; those
refinements are not yet Lean declarations.

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
8. Do not confuse an abstract surviving candidate with a legal geometric extension. This gap is
   now closed by `arc_union_candidate_of_not_mem_forbidden`.
9. State the natural-subtraction side condition explicitly or cite `choose_fixedArcPoints_le_star`;
   otherwise the displayed empty-line identity could hide truncation.
10. Keep the exact two-element secant-orbit proof visible: the forbidden bound depends on counting
    conjugate nonfixed lines once, not merely bounding the number of raw secants.

## Remaining paper gates

1. Add primary citations for every row of the classical-family radius table.
2. Decide whether the manuscript promises machine checking of the square-root ceiling itself or
   only its stronger denominator-free quadratic inequality.
3. The targeted paper-wide novelty audit is complete; use
   [`2026-07-13-baer-completion-adversarial-novelty-review.md`](../2026-07-13-baer-completion-adversarial-novelty-review.md)
   as the claim boundary. A specialist database-level priority search for the exact quadratic-
   Frobenius formula remains before submission.
4. Supply at least one nontrivial exact classical-family completion radius or demote that table from
   the paper's lead, per the packaging review.

Accurate trust claim: **the general completion, secant, involution, counting, robustness, and
saturation mechanisms and the exact coordinate quadratic-Frobenius pair-extension theorem are
kernel-checked. The classical-family radius table and the ceiling-form presentation remain outside
the present formalization.**

## Adversarial round conclusion

The review tried the main statement-adequacy failure modes: vacuous abstract legality, duplicated
secant-orbit charging, natural-number truncation, incorrect fixed-line classification, and missing
cross-secants after adjoining the pair. Each is now covered by a named declaration. A temporary
axiom audit of the fixed-locus, line-count, secant-orbit, forbidden-bound, semantic-extension, and
end-to-end theorems reported only `propext`, `Classical.choice`, and `Quot.sound`; the temporary
audit file was removed.
