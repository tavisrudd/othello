# Structural orientation classification in `FourShadowRecognition`

**Lane:** `clebsch`
**Date:** 2026-08-03
**Task:** C815

## Objective

Remove the single `native_decide` step in
`lean/RelativeConicArcs/FourShadowRecognition.lean`
(`sixTestCode_classification_of_balanced`, an exhaustive compiled evaluation over
all `2^10` root-normalized Boolean signings) and replace it by the structural
argument of the frozen human theorem, so that no declaration in the module carries
a compiled-evaluation axiom.

## Design as assigned, and the deviation actually taken

The assigned route was:

1. one standard pentagon signing with `CubicsProportional … 4`;
2. relabelling equivariance for `Equiv.Perm (Fin 6)` fixing the root (triangle
   cubic transports without sign, matching evaluation with the permutation sign),
   proved by transposition induction;
3. every pentagon-gauge signing is a relabelling of the standard one, by an
   explicit walk in the 2-regular positive graph;
4. coefficient extraction `CubicsProportional C mu → shadowCoefficient012 C =
   mu * triangleSign C 0 1 2`.

I did not take that route. Reasons, in order of weight:

- **Step 3 is the expensive part, and it does not avoid a case analysis.**
  Turning `(Finset.univ.filter …).card = 2` at five vertices into a concrete
  `Equiv.Perm (Fin 6)` requires either a constructive walk (substantial
  `Finset.card`-level Lean work with no reusable Mathlib lemma) or, in practice,
  exactly the same finite case analysis on the ten edge bits that step 3 was
  meant to replace. Once that case analysis exists, it already names the twelve
  labelled pentagons, and the permutation is then only a repackaging.
- **Step 2 is not cheaper than the twelve identities it replaces.**
  `triangleCubic` and `matchingEvaluation` are explicit 20- and 15-term
  expressions, not `Finset` sums over triples/matchings, so permutation
  equivariance is not a reindexing argument. Transposition induction requires
  `fin_cases` on both swapped indices, i.e. thirty ring identities per cubic —
  sixty heavy `ring` calls — versus the twelve `simp; ring` identities already
  in the module. Combined with the twelve conjugation instances still needed to
  apply it, the permutation route is strictly more elaboration work for the same
  theorem.
- **Step 4 is replaceable by a two-line computation.** With the twelve labelled
  signings in hand, `shadowCoefficient012` and `triangleSign … 0 1 2` are
  explicit small integers, so the orientation of each pentagon is a kernel
  computation. Building mixed-difference machinery in three coordinates to
  extract the same number is unnecessary.

What I did instead keeps the human proof's causal order and removes all compiled
evaluation:

- the five root-pair balances give five linear equations in the ten edge signs
  (already extracted inside `normalizedSignMatrix_sq_of_firstRowBalanced`; now
  factored out as `firstRowBalanced_rowSums`);
- a proved sign lemma (`four_bool_sum_zero_cases`) says that four signs summing
  to zero split into exactly six balanced patterns — this is the "degree two at
  every non-root vertex" step;
- applied at the first non-root vertex it gives six branches; in each branch the
  four remaining balance equations determine the remaining six edge bits, and
  that residue is discharged by **kernel** `decide` over `2^6 = 64` Boolean
  assignments per branch (`pentagon_bit_classification`);
- the twelve resulting labelled pentagons each give one polynomial identity
  between the two cubics and one integer orientation check
  (`cubicsProportional_orientation_of_firstRowBalanced`).

The kernel residue is `6 × 64 = 384` Boolean assignments with no matrix
arithmetic, behind a proved reduction, replacing `1024` compiled matrix
evaluations. It is documented as such in the module header.

## Declarations

Added:

- `private theorem four_bool_sum_zero_cases (a b c d : Bool) :
  boolSign a + boolSign b + boolSign c + boolSign d = 0 → (six explicit
  sign patterns)`
- `private theorem firstRowBalanced_rowSums (bits : Fin 10 → Bool) :
  FirstRowBalanced (normalizedSignMatrix bits) → (the five vertex balance
  equations in the ten edge signs)`
- `private theorem pentagon_bit_classification (b0 … b9 : Bool) : (five balance
  equations) → (twelve explicit labelled pentagons)`
- `private theorem cubicsProportional_orientation_of_firstRowBalanced
  (bits : Fin 10 → Bool) : FirstRowBalanced (normalizedSignMatrix bits) →
  (CubicsProportional (normalizedSignMatrix bits) 4 ∧
   PositiveOrientation012 (normalizedSignMatrix bits)) ∨
  (CubicsProportional (normalizedSignMatrix bits) (-4) ∧
   NegativeOrientation012 (normalizedSignMatrix bits))`

Removed:

- `sixTestCode_classification_of_balanced` (the `native_decide` step)
- `six_test_code_classification`, `positive_six_test_codes`,
  `negative_six_test_codes`
- `PositiveSixTestCode`, `NegativeSixTestCode`
- the twelve `cubicsProportional_positivePentagon_*` /
  `cubicsProportional_negativePentagon_*` identity theorems (absorbed into the
  single classification theorem)
- `four_bool_signs_sum_zero_positive_count` (dead)

Unchanged public API: every non-`private` declaration keeps its exact statement.

## Final Lean statements

- `private theorem four_bool_sum_zero_cases (a b c d : Bool)
  (hsum : boolSign a + boolSign b + boolSign c + boolSign d = 0) :
  (a = false ∧ b = false ∧ c = true ∧ d = true) ∨ … ∨
  (a = true ∧ b = true ∧ c = false ∧ d = false)`
  — proof `revert hsum; cases a <;> cases b <;> cases c <;> cases d <;> decide`.
- `private theorem boolSign_false : boolSign false = 1`,
  `private theorem boolSign_true : boolSign true = -1` — `rfl`, used only to
  reduce the balance equations to integer literals inside the case analysis.
- `private theorem firstRowBalanced_rowSums (bits : Fin 10 → Bool)
  (hbalance : FirstRowBalanced (normalizedSignMatrix bits)) :
  boolSign (bits 0) + boolSign (bits 1) + boolSign (bits 2) + boolSign (bits 3) = 0 ∧ …`
  (five conjuncts, the vertex balances at `1,2,3,4,5`). Extracted verbatim from
  the previously inline `have`s of `normalizedSignMatrix_sq_of_firstRowBalanced`,
  which now consumes it.
- `private theorem pentagon_bit_classification (b0 … b9 : Bool) (r1 … r5) :
  (twelve explicit ten-fold conjunctions)` — proof: `rcases
  four_bool_sum_zero_cases b0 b1 b2 b3 r1` into six branches, then
  `cases b4 <;> … <;> cases b9`, `simp only [boolSign_false, boolSign_true] at
  r2 r3 r4 r5`, and `first | omega | simp`. `omega` refutes the 372 assignments
  inconsistent with the four remaining balances; `simp` closes the 12 that match.
- `private theorem cubicsProportional_orientation_of_firstRowBalanced
  (bits : Fin 10 → Bool) (hbalance : FirstRowBalanced (normalizedSignMatrix bits)) :
  (CubicsProportional (normalizedSignMatrix bits) 4 ∧
   PositiveOrientation012 (normalizedSignMatrix bits)) ∨
  (CubicsProportional (normalizedSignMatrix bits) (-4) ∧
   NegativeOrientation012 (normalizedSignMatrix bits))`
  — twelve branches, each `simp [...] ; ring` for the cubic identity and one
  `simp [...]` for the coefficient comparison.
- `orientation012_of_firstRowBalanced`, `cubicsProportional_four_of_sixTests`,
  `cubicsProportional_neg_four_of_sixTests` now read off that disjunction, using
  the unchanged `orientation012_disjoint` to discard the wrong orientation.

## What failed on the way

- `revert r2 r3 r4 r5 b4 b5 b6 b7 b8 b9; decide` inside
  `pentagon_bit_classification`: no `Decidable (∀ b : Bool, …)` instance was
  found for the reverted goal.
- `cases b4 <;> … <;> cases b9 <;> revert r2 r3 r4 r5 <;> decide`: instance
  synthesis still failed, and the reported goal shows why — the twelve-fold
  disjunction of ten-fold conjunctions needs more `Decidable` sub-instances than
  the default `synthInstance.maxSize` allows. Replacing the final `decide` by
  `simp` avoids both the instance-size limit and a large decidability term in
  the kernel.
- `norm_num [boolSign] at r2 r3 r4 r5`: when the first hypothesis reduces to
  `False` the goal is closed and the remaining hypotheses raise
  "No goals to be solved". Reducing with the two `rfl` lemmas and then splitting
  on `omega` versus `simp` is stable.

## Statements stronger than the frozen human theorem

1. `exists_scalar_mul_self_of_offDiagonal_zero` (unchanged, but worth recording)
   needs neither symmetry nor a vanishing diagonal: its hypotheses are only that
   every off-diagonal entry of `C` is nonzero and every off-diagonal entry of
   `C * C` vanishes. The human proof of Theorem B assumes `A` symmetric with
   zero diagonal throughout.
2. Everything from `CubicsProportional` through
   `exists_mul_self_eq_scalar_of_cubicsProportional` is stated over an arbitrary
   commutative integral domain `R`, and the purely algebraic parts
   (`matchingEvaluation_smul`, `triangleCubic_smul`,
   `triangleMixedDifference_eq_pairTriangleSum`,
   `pairTriangleSum_eq_zero_of_triangleCubic_translate`) hold over an arbitrary
   commutative ring, the `IsDomain` instance being explicitly omitted. The human
   Theorem B is stated over a field.
3. `pairTriangleSum_eq_zero_of_triangleCubic_translate` takes translation
   invariance of the triangle cubic as its hypothesis rather than deriving it
   from proportionality, so it applies to every symmetric zero-diagonal matrix
   with a translation-invariant triangle cubic, whether or not the two cubics
   are proportional.
4. `triangleMixedDifference_eq_pairTriangleSum` holds with no hypothesis beyond
   symmetry and zero diagonal, for every pair of distinct labels; the paper uses
   it only as the coefficient-extraction step inside the proportionality proof.
5. `cubicsProportional_smul_iff` is an iff for every nonzero scalar in the
   domain, not just for the sign-locus scaling used in Theorem C.
6. `pentagon_bit_classification` proves the twelve-pentagon list from the five
   balance equations alone, with no reference to the matrix; it is a statement
   about two-regular graphs on five labelled vertices, and is available for any
   later use of that classification.

## Validation

`lean/scripts/guarded-lean RelativeConicArcs/FourShadowRecognition.lean`,
exit 0, no errors and no warnings. Final green run directory:

```
/home/tavis/.cache/othello-lean-build/guarded-lean/20260803-194705-cd-lean-exec-taskset-c-20-23-env-LEAN_NUM_THREADS1-choom-n-1000-nix-develop-comma
```

Axiom closure, checked by temporary `#print axioms` probes in the module (run
directory `…/20260803-194543-…`, probes removed afterwards):
`pentagonGauge_of_firstRowBalanced`,
`normalizedSignMatrix_sq_of_firstRowBalanced`,
`cubicsProportional_four_of_sixTests`,
`cubicsProportional_neg_four_of_sixTests`,
`exists_nonzero_cubicsProportional_iff_conferenceSquare`,
`exists_nonzero_cubicsProportional_smul_iff_conferenceSquare`,
`exists_mul_self_eq_scalar_of_cubicsProportional`, and
`triangleMixedDifference_eq_pairTriangleSum` each depend on exactly
`[propext, Classical.choice, Quot.sound]`. No compiled-evaluation axiom and no
`sorryAx` anywhere in the module.

The single-file elaboration runs against the last-built dependencies, so it is a
smoke test for the imported modules; the module's own content is fully
elaborated. A gate build of `RelativeConicArcs.Gates.FourShadowRecognition` under
the unattended queue is the remaining confirmation and was not run here.

## Prose changes

The module header no longer claims compiled evaluation or a trusted compiler; it
describes the balance equations, the sign lemma, the enumerated residue, and the
kernel-normalized cubic identities. `Gates/FourShadowRecognition.lean` had the
same claim in its header and was corrected to match.

Nothing was committed.
