import Mathlib

/-!
# Row-visible marked projectors

A spectral marker may be represented by an idempotent endomorphism of a
quantum-module lattice.  Its scalar row need not take values in the same
coefficient ring: a Givental fundamental solution naturally gives a row with
values in a larger coefficient module.  This file keeps those types separate.

For a direct-sum comparison, the marked projector is required to be block
natural and the source row is required to factor through the ambient
projection.  The correction projector is retained explicitly and may be
nonzero.  These two squares imply that the row detects a marked vector on the
source exactly when it detects one on the ambient factor.

The declarations are linear algebra only.  Constructing the marked spectral
projectors and the rowed QDM comparison from blowup formulas remains an
external source theorem.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorDecomposition

open scoped TensorProduct

universe uR uA uV uW uC

variable
    (R : Type uR) [CommRing R]
    (A : Type uA) [AddCommGroup A] [Module R A]
    (V : Type uV) (W : Type uW) (C : Type uC)
    [AddCommGroup V] [Module R V]
    [AddCommGroup W] [Module R W]
    [AddCommGroup C] [Module R C]

/-- An idempotent linear endomorphism.  Storing idempotence prevents a raw
endomorphism from being used as a marked spectral projector. -/
structure Projector
    (M : Type*) [AddCommGroup M] [Module R M] where
  map : M →ₗ[R] M
  idempotent : ∀ x, map (map x) = map x

namespace Projector

variable
    {R}
    {M : Type*} [AddCommGroup M] [Module R M]

/-- The zero marked projector. -/
def zero : Projector R M where
  map := 0
  idempotent := by simp

/-- The projector marking the whole module. -/
def identity : Projector R M where
  map := LinearMap.id
  idempotent := by simp

/-- Scalar extension of an idempotent projector. -/
noncomputable def baseChange
    {K : Type*} [CommRing K] [Algebra R K]
    (projector : Projector R M) : Projector K (K ⊗[R] M) where
  map := projector.map.baseChange K
  idempotent := by
    intro x
    induction x using TensorProduct.induction_on with
    | zero => simp
    | add x y hx hy => simp [hx, hy]
    | tmul scalar x => simp [projector.idempotent]

/-- Tensoring a projector with the identity on an auxiliary factor. -/
def tensorIdentity
    {U : Type*} [AddCommGroup U] [Module R U]
    (projector : Projector R M) : Projector R (M ⊗[R] U) where
  map := TensorProduct.map projector.map LinearMap.id
  idempotent := by
    intro x
    induction x using TensorProduct.induction_on with
    | zero => simp
    | add x y hx hy => simp [hx, hy]
    | tmul scalar x => simp [projector.idempotent]

end Projector

/-- A row detects a marked projector when it is nonzero on a vector fixed by
that projector.  The row codomain is an arbitrary `R`-module. -/
def Detects
    {M : Type*} [AddCommGroup M] [Module R M]
    (row : M →ₗ[R] A) (projector : Projector R M) : Prop :=
  ∃ x, projector.map x = x ∧ row x ≠ 0

/-- Injecting the row codomain preserves and reflects detection without
changing the module or projector. -/
theorem detects_comp_injective_iff
    {M B : Type*}
    [AddCommGroup M] [Module R M]
    [AddCommGroup B] [Module R B]
    (row : M →ₗ[R] A) (projector : Projector R M)
    (inclusion : A →ₗ[R] B) (inclusion_injective : Function.Injective inclusion) :
    Detects R B (inclusion.comp row) projector ↔ Detects R A row projector := by
  constructor
  · rintro ⟨x, fixed, includedNonzero⟩
    refine ⟨x, fixed, ?_⟩
    intro rowVanishes
    apply includedNonzero
    simp [rowVanishes]
  · rintro ⟨x, fixed, rowNonzero⟩
    refine ⟨x, fixed, ?_⟩
    change inclusion (row x) ≠ 0
    simpa using inclusion_injective.ne rowNonzero

/-- Scalar extension of a row with an arbitrary module-valued codomain. -/
noncomputable def baseChangeRow
    {K : Type*} [CommRing K] [Algebra R K]
    {M : Type*} [AddCommGroup M] [Module R M]
    (row : M →ₗ[R] A) : (K ⊗[R] M) →ₗ[K] (K ⊗[R] A) :=
  row.baseChange K

/-- Faithfully flat scalar extension preserves and reflects row-visible
support of an idempotent projector.  This is the common-base certificate used
when two wall comparisons are formed over different faithful extensions of
one rational coefficient ring. -/
theorem detects_baseChange_iff
    {K : Type*} [CommRing K] [Algebra R K] [Module.FaithfullyFlat R K]
    {M : Type*} [AddCommGroup M] [Module R M]
    (row : M →ₗ[R] A) (projector : Projector R M) :
    Detects K (K ⊗[R] A) (baseChangeRow R A row) projector.baseChange ↔
      Detects R A row projector := by
  constructor
  · rintro ⟨y, fixed, rowNonzero⟩
    by_contra sourceDoesNotDetect
    have rowProjectorZero : ∀ x, row (projector.map x) = 0 := by
      intro x
      by_contra nonzero
      exact sourceDoesNotDetect ⟨projector.map x, projector.idempotent x, nonzero⟩
    have baseChangedRowProjectorZero : ∀ y : K ⊗[R] M,
        baseChangeRow R A row (projector.baseChange.map y) = 0 := by
      intro value
      induction value using TensorProduct.induction_on with
      | zero => simp
      | add x y hx hy => simp [hx, hy]
      | tmul scalar x => simp [baseChangeRow, Projector.baseChange, rowProjectorZero]
    apply rowNonzero
    rw [← fixed]
    exact baseChangedRowProjectorZero y
  · rintro ⟨x, fixed, rowNonzero⟩
    refine ⟨(1 : K) ⊗ₜ[R] x, ?_, ?_⟩
    · simp [Projector.baseChange, fixed]
    · have injective :=
        Module.FaithfullyFlat.tensorProduct_mk_injective
          (A := R) (B := K) A
      simpa [baseChangeRow] using injective.ne rowNonzero

/-- Two coefficient rings which are faithfully flat over one common base.
The record does not assert an embedding of either completion into the other. -/
structure CommonFaithfulScalarExtensions
    (K L : Type*) [CommRing K] [CommRing L]
    [Algebra R K] [Algebra R L] : Prop where
  leftFaithfullyFlat : Module.FaithfullyFlat R K
  rightFaithfullyFlat : Module.FaithfullyFlat R L

/-- Detection computed after either faithful scalar extension agrees through
the common rational model, without a map between the two extended rings. -/
theorem detects_on_common_extensions_iff
    {K L : Type*} [CommRing K] [CommRing L]
    [Algebra R K] [Algebra R L]
    {M : Type*} [AddCommGroup M] [Module R M]
    (extensions : CommonFaithfulScalarExtensions R K L)
    (row : M →ₗ[R] A) (projector : Projector R M) :
    Detects K (K ⊗[R] A) (baseChangeRow R A row) projector.baseChange ↔
      Detects L (L ⊗[R] A) (baseChangeRow R A row) projector.baseChange := by
  letI : Module.FaithfullyFlat R K := extensions.leftFaithfullyFlat
  letI : Module.FaithfullyFlat R L := extensions.rightFaithfullyFlat
  rw [detects_baseChange_iff R A, detects_baseChange_iff R A]

/-- The tensor product of two scalar rows. -/
def tensorRow
    {M U : Type*}
    [AddCommGroup M] [Module R M]
    [AddCommGroup U] [Module R U]
    (rowM : M →ₗ[R] R) (rowU : U →ₗ[R] R) :
    (M ⊗[R] U) →ₗ[R] R :=
  (TensorProduct.lift (LinearMap.mul R R)).comp
    (TensorProduct.map rowM rowU)

@[simp]
theorem tensorRow_tmul
    {M U : Type*}
    [AddCommGroup M] [Module R M]
    [AddCommGroup U] [Module R U]
    (rowM : M →ₗ[R] R) (rowU : U →ₗ[R] R) (x : M) (u : U) :
    tensorRow R rowM rowU (x ⊗ₜ[R] u) = rowM x * rowU u := by
  simp [tensorRow]

/-- A detected marked vector remains detected after tensoring with an
auxiliary vector on which the auxiliary row has value one. -/
theorem detects_tensorIdentity
    {M U : Type*}
    [AddCommGroup M] [Module R M]
    [AddCommGroup U] [Module R U]
    (rowM : M →ₗ[R] R) (rowU : U →ₗ[R] R)
    (projector : Projector R M)
    (sourceDetects : Detects R R rowM projector)
    (u : U) (rowU_one : rowU u = 1) :
    Detects R R (tensorRow R rowM rowU) projector.tensorIdentity := by
  rcases sourceDetects with ⟨x, fixed, rowNonzero⟩
  refine ⟨x ⊗ₜ[R] u, ?_, ?_⟩
  · simp [Projector.tensorIdentity, fixed]
  · simpa [rowU_one] using rowNonzero

/-- A zero marked projector cannot be detected by any linear row. -/
theorem not_detects_zero
    {M : Type*} [AddCommGroup M] [Module R M]
    (row : M →ₗ[R] A) :
    ¬ Detects R A row (Projector.zero (R := R) (M := M)) := by
  rintro ⟨x, fixed, rowNonzero⟩
  have xVanishes : x = 0 := by
    simpa [Projector.zero] using fixed.symm
  apply rowNonzero
  simp [xVanishes]

/-- The projective-space factor in a product with `P^m` has `m + 1`
cohomological branches.  This arithmetic count is separated from the external
quantum-product theorem that realizes the branches. -/
def projectiveProductBranchCount (m : ℕ) : ℕ := m + 1

/-- The projective-product branch count is positive for every stabilization
index, not only for a bounded range checked computationally. -/
theorem projectiveProductBranchCount_pos (m : ℕ) :
    0 < projectiveProductBranchCount m := by
  simp [projectiveProductBranchCount]

/-- Exact branch-count regressions at the stabilization indices one, three,
four, and thirteen.  The preceding theorem supplies the unbounded statement. -/
theorem projectiveProductBranchCounts_at_one_three_four_thirteen :
    projectiveProductBranchCount 1 = 2 ∧
      projectiveProductBranchCount 3 = 4 ∧
      projectiveProductBranchCount 4 = 5 ∧
      projectiveProductBranchCount 13 = 14 := by
  norm_num [projectiveProductBranchCount]

/-- An intertwiner of endomorphisms also intertwines every natural power of
those endomorphisms. -/
theorem intertwines_pow
    {M N : Type*}
    [AddCommGroup M] [Module R M]
    [AddCommGroup N] [Module R N]
    (comparison : M →ₗ[R] N)
    (sourceOperator : Module.End R M)
    (targetOperator : Module.End R N)
    (intertwines : ∀ x,
      comparison (sourceOperator x) = targetOperator (comparison x))
    (n : ℕ) (x : M) :
    comparison ((sourceOperator ^ n) x) =
      (targetOperator ^ n) (comparison x) := by
  induction n generalizing x with
  | zero => simp
  | succ n inductionHypothesis =>
      rw [pow_succ, pow_succ, Module.End.mul_apply, Module.End.mul_apply]
      rw [inductionHypothesis, intertwines]

/-- An intertwiner carries every polynomial in one endomorphism to the same
polynomial in the other.  Spectral projectors obtained by polynomial
functional calculus therefore need no separate appeal to a chosen splitting. -/
theorem intertwines_aeval
    {M N : Type*}
    [AddCommGroup M] [Module R M]
    [AddCommGroup N] [Module R N]
    (comparison : M →ₗ[R] N)
    (sourceOperator : Module.End R M)
    (targetOperator : Module.End R N)
    (intertwines : ∀ x,
      comparison (sourceOperator x) = targetOperator (comparison x))
    (polynomial : Polynomial R) (x : M) :
    comparison ((Polynomial.aeval sourceOperator polynomial) x) =
      (Polynomial.aeval targetOperator polynomial) (comparison x) := by
  induction polynomial using Polynomial.induction_on' with
  | add left right leftHypothesis rightHypothesis =>
      simp [leftHypothesis, rightHypothesis]
  | monomial n coefficient =>
      simp only [Polynomial.aeval_monomial, Module.End.mul_apply,
        Module.algebraMap_end_apply, map_smul]
      rw [intertwines_pow R comparison sourceOperator targetOperator intertwines]

/-- Polynomial presentations of two projectors turn one operator square into
the projector square consumed by `Data` and `UnitScaledData`. -/
theorem polynomialProjector_naturality
    {M N : Type*}
    [AddCommGroup M] [Module R M]
    [AddCommGroup N] [Module R N]
    (comparison : M →ₗ[R] N)
    (sourceOperator : Module.End R M)
    (targetOperator : Module.End R N)
    (intertwines : ∀ x,
      comparison (sourceOperator x) = targetOperator (comparison x))
    (polynomial : Polynomial R)
    (sourceProjector : Projector R M)
    (targetProjector : Projector R N)
    (sourcePolynomial : sourceProjector.map =
      Polynomial.aeval sourceOperator polynomial)
    (targetPolynomial : targetProjector.map =
      Polynomial.aeval targetOperator polynomial)
    (x : M) :
    comparison (sourceProjector.map x) =
      targetProjector.map (comparison x) := by
  rw [sourcePolynomial, targetPolynomial]
  exact intertwines_aeval R comparison sourceOperator targetOperator
    intertwines polynomial x

/-- A rowed direct-sum comparison with block-natural marked projectors.
The correction factor carries its own projector but no row contribution. -/
structure Data where
  sourceProjector : Projector R V
  ambientProjector : Projector R W
  correctionProjector : Projector R C
  comparison : V ≃ₗ[R] W × C
  sourceRow : V →ₗ[R] A
  ambientRow : W →ₗ[R] A
  rowComparison : ∀ x, sourceRow x = ambientRow (comparison x).1
  projectorComparison : ∀ x,
    comparison (sourceProjector.map x) =
      (ambientProjector.map (comparison x).1,
        correctionProjector.map (comparison x).2)

/-- A rowed direct-sum comparison whose two rows agree up to multiplication
by a unit.  This accepts harmless Fourier signs, Tate normalizations, and
invertible powers of a localized parameter without weakening detection. -/
structure UnitScaledData where
  sourceProjector : Projector R V
  ambientProjector : Projector R W
  correctionProjector : Projector R C
  comparison : V ≃ₗ[R] W × C
  sourceRow : V →ₗ[R] A
  ambientRow : W →ₗ[R] A
  rowScale : Rˣ
  rowComparison : ∀ x,
    sourceRow x = (rowScale : R) • ambientRow (comparison x).1
  projectorComparison : ∀ x,
    comparison (sourceProjector.map x) =
      (ambientProjector.map (comparison x).1,
        correctionProjector.map (comparison x).2)

/-- Two presentations of one source module, carrying one marked projector and
one row comparison.  This record models the situation in which separate
external results construct the two endpoint presentations; it does not assume
that either result directly states the composite endpoint comparison. -/
structure CommonSourcePresentation
    (S : Type*) [AddCommGroup S] [Module R S] where
  commonProjector : Projector R S
  sourceProjector : Projector R V
  ambientProjector : Projector R W
  correctionProjector : Projector R C
  sourcePresentation : S ≃ₗ[R] V
  targetPresentation : S ≃ₗ[R] W × C
  sourceRow : V →ₗ[R] A
  ambientRow : W →ₗ[R] A
  rowScale : Rˣ
  rowOnCommonSource : ∀ s,
    sourceRow (sourcePresentation s) =
      (rowScale : R) • ambientRow (targetPresentation s).1
  sourceProjectorNaturality : ∀ s,
    sourcePresentation (commonProjector.map s) =
      sourceProjector.map (sourcePresentation s)
  targetProjectorNaturality : ∀ s,
    targetPresentation (commonProjector.map s) =
      (ambientProjector.map (targetPresentation s).1,
        correctionProjector.map (targetPresentation s).2)

namespace CommonSourcePresentation

variable
    {R A V W C}
    {S : Type*} [AddCommGroup S] [Module R S]

/-- Basis certificates for the row square and both projector squares construct
the full common-source presentation.  Invertibility of the two presentations
is retained as explicit data; checking finite truncations cannot replace it. -/
def ofBasisSquares
    {Index : Type*}
    (basis : Module.Basis Index R S)
    (commonProjector : Projector R S)
    (sourceProjector : Projector R V)
    (ambientProjector : Projector R W)
    (correctionProjector : Projector R C)
    (sourcePresentation : S ≃ₗ[R] V)
    (targetPresentation : S ≃ₗ[R] W × C)
    (sourceRow : V →ₗ[R] A)
    (ambientRow : W →ₗ[R] A)
    (rowScale : Rˣ)
    (rowOnBasis : ∀ index,
      sourceRow (sourcePresentation (basis index)) =
        (rowScale : R) • ambientRow (targetPresentation (basis index)).1)
    (sourceProjectorOnBasis : ∀ index,
      sourcePresentation (commonProjector.map (basis index)) =
        sourceProjector.map (sourcePresentation (basis index)))
    (targetProjectorOnBasis : ∀ index,
      targetPresentation (commonProjector.map (basis index)) =
        (ambientProjector.map (targetPresentation (basis index)).1,
          correctionProjector.map (targetPresentation (basis index)).2)) :
    CommonSourcePresentation R A V W C S where
  commonProjector := commonProjector
  sourceProjector := sourceProjector
  ambientProjector := ambientProjector
  correctionProjector := correctionProjector
  sourcePresentation := sourcePresentation
  targetPresentation := targetPresentation
  sourceRow := sourceRow
  ambientRow := ambientRow
  rowScale := rowScale
  rowOnCommonSource := by
    have equality : sourceRow.comp sourcePresentation.toLinearMap =
        (rowScale : R) •
          ambientRow.comp
            ((LinearMap.fst R W C).comp targetPresentation.toLinearMap) := by
      exact basis.ext fun index ↦ by simpa using rowOnBasis index
    exact LinearMap.congr_fun equality
  sourceProjectorNaturality := by
    have equality : sourcePresentation.toLinearMap.comp commonProjector.map =
        sourceProjector.map.comp sourcePresentation.toLinearMap := by
      exact basis.ext fun index ↦ by simpa using sourceProjectorOnBasis index
    exact LinearMap.congr_fun equality
  targetProjectorNaturality := by
    have equality : targetPresentation.toLinearMap.comp commonProjector.map =
        (ambientProjector.map.prodMap correctionProjector.map).comp
          targetPresentation.toLinearMap := by
      exact basis.ext fun index ↦ by simpa using targetProjectorOnBasis index
    exact LinearMap.congr_fun equality

/-- Composing the two presentations of a common marked source produces the
unit-scaled rowed projector comparison used by the detection theorem. -/
def toUnitScaledData
    (presentation : CommonSourcePresentation R A V W C S) :
    UnitScaledData R A V W C where
  sourceProjector := presentation.sourceProjector
  ambientProjector := presentation.ambientProjector
  correctionProjector := presentation.correctionProjector
  comparison := presentation.sourcePresentation.symm.trans
    presentation.targetPresentation
  sourceRow := presentation.sourceRow
  ambientRow := presentation.ambientRow
  rowScale := presentation.rowScale
  rowComparison := by
    intro x
    simpa using presentation.rowOnCommonSource
      (presentation.sourcePresentation.symm x)
  projectorComparison := by
    intro x
    let s := presentation.sourcePresentation.symm x
    have commonValue : presentation.commonProjector.map s =
        presentation.sourcePresentation.symm
          (presentation.sourceProjector.map x) := by
      apply presentation.sourcePresentation.injective
      simpa [s] using presentation.sourceProjectorNaturality s
    change presentation.targetPresentation
        (presentation.sourcePresentation.symm
          (presentation.sourceProjector.map x)) = _
    rw [← commonValue, presentation.targetProjectorNaturality]
    rfl

end CommonSourcePresentation

namespace Data

variable
    {R A V W C}

/-- The two comparison squares may be checked on a basis of the source.
This is the algebraic extension principle used for a completed wall module
whose basis vectors already lie in the nonlocalized quantum-module source.
No density, topology, convergence, or inverse-limit argument is involved. -/
def ofBasisSquares
    {Index : Type*}
    (basis : Module.Basis Index R V)
    (sourceProjector : Projector R V)
    (ambientProjector : Projector R W)
    (correctionProjector : Projector R C)
    (comparison : V ≃ₗ[R] W × C)
    (sourceRow : V →ₗ[R] A)
    (ambientRow : W →ₗ[R] A)
    (rowOnBasis : ∀ index,
      sourceRow (basis index) = ambientRow (comparison (basis index)).1)
    (projectorOnBasis : ∀ index,
      comparison (sourceProjector.map (basis index)) =
        (ambientProjector.map (comparison (basis index)).1,
          correctionProjector.map (comparison (basis index)).2)) :
    Data R A V W C where
  sourceProjector := sourceProjector
  ambientProjector := ambientProjector
  correctionProjector := correctionProjector
  comparison := comparison
  sourceRow := sourceRow
  ambientRow := ambientRow
  rowComparison := by
    have equality : sourceRow =
        ambientRow.comp ((LinearMap.fst R W C).comp comparison.toLinearMap) := by
      exact basis.ext fun index ↦ by simpa using rowOnBasis index
    exact LinearMap.congr_fun equality
  projectorComparison := by
    have equality : comparison.toLinearMap.comp sourceProjector.map =
        (ambientProjector.map.prodMap correctionProjector.map).comp
          comparison.toLinearMap := by
      exact basis.ext fun index ↦ by simpa using projectorOnBasis index
    exact LinearMap.congr_fun equality

/-- Block naturality and row factorization preserve row-visible marked
support in both directions.  No vanishing or emptiness condition is imposed
on the correction projector. -/
theorem detects_iff
    (data : Data R A V W C) :
    Detects R A data.sourceRow data.sourceProjector ↔
      Detects R A data.ambientRow data.ambientProjector := by
  constructor
  · rintro ⟨x, fixed, rowNonzero⟩
    refine ⟨(data.comparison x).1, ?_, ?_⟩
    · have naturality := data.projectorComparison x
      rw [fixed] at naturality
      exact (congrArg Prod.fst naturality).symm
    · intro ambientVanishes
      apply rowNonzero
      rw [data.rowComparison, ambientVanishes]
  · rintro ⟨x, fixed, rowNonzero⟩
    let sourceVector : V := data.comparison.symm (x, 0)
    refine ⟨sourceVector, ?_, ?_⟩
    · apply data.comparison.injective
      rw [data.projectorComparison]
      simp [sourceVector, fixed]
    · intro sourceVanishes
      apply rowNonzero
      have comparisonRow := data.rowComparison sourceVector
      rw [sourceVanishes] at comparisonRow
      simpa [sourceVector] using comparisonRow.symm

/-- A detected source cannot admit a rowed projector decomposition with zero
ambient marked projector.  This is the endpoint contradiction consumed by
the all-stabilizations route. -/
theorem false_of_source_detects_of_ambient_zero
    (data : Data R A V W C)
    (sourceDetects : Detects R A data.sourceRow data.sourceProjector)
    (ambientProjectorZero : data.ambientProjector = Projector.zero) : False := by
  have ambientDetects := data.detects_iff.mp sourceDetects
  rw [ambientProjectorZero] at ambientDetects
  exact not_detects_zero R A data.ambientRow ambientDetects

end Data

namespace UnitScaledData

variable
    {R A V W C}

/-- Every exact rowed comparison is a unit-scaled comparison with scale one. -/
def ofExact (data : Data R A V W C) : UnitScaledData R A V W C where
  sourceProjector := data.sourceProjector
  ambientProjector := data.ambientProjector
  correctionProjector := data.correctionProjector
  comparison := data.comparison
  sourceRow := data.sourceRow
  ambientRow := data.ambientRow
  rowScale := 1
  rowComparison := by simpa using data.rowComparison
  projectorComparison := data.projectorComparison

/-- The unit-scaled row square and projector square may both be checked on a
basis. -/
def ofBasisSquares
    {Index : Type*}
    (basis : Module.Basis Index R V)
    (sourceProjector : Projector R V)
    (ambientProjector : Projector R W)
    (correctionProjector : Projector R C)
    (comparison : V ≃ₗ[R] W × C)
    (sourceRow : V →ₗ[R] A)
    (ambientRow : W →ₗ[R] A)
    (rowScale : Rˣ)
    (rowOnBasis : ∀ index,
      sourceRow (basis index) =
        (rowScale : R) • ambientRow (comparison (basis index)).1)
    (projectorOnBasis : ∀ index,
      comparison (sourceProjector.map (basis index)) =
        (ambientProjector.map (comparison (basis index)).1,
          correctionProjector.map (comparison (basis index)).2)) :
    UnitScaledData R A V W C where
  sourceProjector := sourceProjector
  ambientProjector := ambientProjector
  correctionProjector := correctionProjector
  comparison := comparison
  sourceRow := sourceRow
  ambientRow := ambientRow
  rowScale := rowScale
  rowComparison := by
    have equality : sourceRow =
        (rowScale : R) •
          ambientRow.comp ((LinearMap.fst R W C).comp comparison.toLinearMap) := by
      exact basis.ext fun index ↦ by simpa using rowOnBasis index
    exact LinearMap.congr_fun equality
  projectorComparison := by
    have equality : comparison.toLinearMap.comp sourceProjector.map =
        (ambientProjector.map.prodMap correctionProjector.map).comp
          comparison.toLinearMap := by
      exact basis.ext fun index ↦ by simpa using projectorOnBasis index
    exact LinearMap.congr_fun equality

/-- Unit-scaled row factorization and block-natural projectors preserve
row-visible marked support in both directions. -/
theorem detects_iff
    (data : UnitScaledData R A V W C) :
    Detects R A data.sourceRow data.sourceProjector ↔
      Detects R A data.ambientRow data.ambientProjector := by
  constructor
  · rintro ⟨x, fixed, rowNonzero⟩
    refine ⟨(data.comparison x).1, ?_, ?_⟩
    · have naturality := data.projectorComparison x
      rw [fixed] at naturality
      exact (congrArg Prod.fst naturality).symm
    · intro ambientVanishes
      apply rowNonzero
      rw [data.rowComparison, ambientVanishes]
      simp
  · rintro ⟨x, fixed, rowNonzero⟩
    let sourceVector : V := data.comparison.symm (x, 0)
    refine ⟨sourceVector, ?_, ?_⟩
    · apply data.comparison.injective
      rw [data.projectorComparison]
      simp [sourceVector, fixed]
    · have scaledNonzero :
          (data.rowScale : R) • data.ambientRow x ≠ 0 := by
        intro scaledVanishes
        apply rowNonzero
        have unscaledVanishes := congrArg
          (fun y : A => (↑data.rowScale⁻¹ : R) • y) scaledVanishes
        simpa [smul_smul] using unscaledVanishes
      intro sourceVanishes
      apply scaledNonzero
      have comparisonRow := data.rowComparison sourceVector
      rw [sourceVanishes] at comparisonRow
      simpa [sourceVector] using comparisonRow.symm

/-- A detected source is incompatible with a zero ambient marked projector,
even when the row comparison is normalized only up to a unit. -/
theorem false_of_source_detects_of_ambient_zero
    (data : UnitScaledData R A V W C)
    (sourceDetects : Detects R A data.sourceRow data.sourceProjector)
    (ambientProjectorZero : data.ambientProjector = Projector.zero) : False := by
  have ambientDetects := data.detects_iff.mp sourceDetects
  rw [ambientProjectorZero] at ambientDetects
  exact not_detects_zero R A data.ambientRow ambientDetects

end UnitScaledData

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorDecomposition
