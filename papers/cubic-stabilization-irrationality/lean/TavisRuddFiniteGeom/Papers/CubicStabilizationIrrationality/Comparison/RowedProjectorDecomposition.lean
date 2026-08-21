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

end Projector

/-- A row detects a marked projector when it is nonzero on a vector fixed by
that projector.  The row codomain is an arbitrary `R`-module. -/
def Detects
    {M : Type*} [AddCommGroup M] [Module R M]
    (row : M →ₗ[R] A) (projector : Projector R M) : Prop :=
  ∃ x, projector.map x = x ∧ row x ≠ 0

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

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorDecomposition
