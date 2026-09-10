import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.InvertibleMorphismDescent
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse
import Mathlib.Data.Complex.Basic

/-!
# Rational descent for whole weight-three Hodge objects

A pure effective weight-three rational Hodge object in a rational basis is
represented by four orthogonal complex projectors summing to the identity;
complex conjugation exchanges the projectors indexed by p and 3-p. Rational
Hodge morphisms are rational matrices intertwining those projectors after
complexification. They form an actual rational linear subspace. An invertible
complex linear combination of members of that rational subspace implies an
invertible rational member, by the determinant-polynomial descent theorem.
The resulting isomorphism has a rational inverse intertwining every projector.

The objects are finite rational vector spaces in chosen bases. No integral
lattice or polarization is encoded. This descent applies to whole objects
and requires no rational realization of separately labelled scalar branches.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- A pure effective rational weight-three Hodge decomposition in a rational
basis, expressed by its complex projectors onto types (p,3-p). -/
structure RationalWeightThreeHodgeMatrices (rank : ℕ) where
  projector : Fin 4 → Matrix (Fin rank) (Fin rank) ℂ
  idempotent : ∀ p, projector p * projector p=projector p
  orthogonal : ∀ p q, p ≠ q → projector p * projector q=0
  exhaustive : ∑ p, projector p=1
  conjugate : ∀ p, (projector p).map (starRingEnd ℂ)=projector p.rev

/-- Actual coefficientwise complexification of a rational matrix, as an
algebra homomorphism preserving both multiplication and rational scalars. -/
noncomputable def rationalMatrixComplexification (rank : ℕ) :
    Matrix (Fin rank) (Fin rank) ℚ →ₐ[ℚ] Matrix (Fin rank) (Fin rank) ℂ :=
  (Algebra.ofId ℚ ℂ).mapMatrix

/-- Rational matrices preserving the entire Hodge decomposition form a
rational linear subspace; no scalar-extended invertible element is assumed. -/
noncomputable def rationalHodgeMorphismSubspace {rank : ℕ}
    (source target : RationalWeightThreeHodgeMatrices rank) :
    Submodule ℚ (Matrix (Fin rank) (Fin rank) ℚ) where
  carrier := {matrix | ∀ p, target.projector p * rationalMatrixComplexification rank matrix=
    rationalMatrixComplexification rank matrix * source.projector p}
  zero_mem' := by simp
  add_mem' := by
    intro left right hl hr p
    simp only [map_add, mul_add, add_mul, hl p, hr p]
  smul_mem' := by
    intro scalar matrix h p
    simp only [map_smul, mul_smul_comm, smul_mul_assoc, h p]

/-- An actual rational Hodge isomorphism, including an invertible rational
matrix and compatibility with every complex Hodge projector. -/
structure RationalWeightThreeHodgeMatrixIso {rank : ℕ}
    (source target : RationalWeightThreeHodgeMatrices rank) where
  matrix : (Matrix (Fin rank) (Fin rank) ℚ)ˣ
  intertwines : ∀ p, target.projector p * rationalMatrixComplexification rank (matrix : Matrix (Fin rank) (Fin rank) ℚ)=
    rationalMatrixComplexification rank (matrix : Matrix (Fin rank) (Fin rank) ℚ) * source.projector p

/-- The inverse rational matrix also preserves all Hodge projectors, so the
constructed morphism is an isomorphism of the full rational Hodge objects. -/
def RationalWeightThreeHodgeMatrixIso.symm {rank : ℕ}
    {source target : RationalWeightThreeHodgeMatrices rank}
    (equiv : RationalWeightThreeHodgeMatrixIso source target) :
    RationalWeightThreeHodgeMatrixIso target source where
  matrix := equiv.matrix⁻¹
  intertwines p := by
    let unit := Units.map (rationalMatrixComplexification rank).toMonoidHom equiv.matrix
    have h : target.projector p * (unit : Matrix (Fin rank) (Fin rank) ℂ)=
        (unit : Matrix (Fin rank) (Fin rank) ℂ) * source.projector p := equiv.intertwines p
    change source.projector p * (↑(unit⁻¹) : Matrix (Fin rank) (Fin rank) ℂ)=
      (↑(unit⁻¹) : Matrix (Fin rank) (Fin rank) ℂ) * target.projector p
    calc
      _ = (↑(unit⁻¹) : Matrix (Fin rank) (Fin rank) ℂ) *
          ((unit : Matrix (Fin rank) (Fin rank) ℂ) * source.projector p) *
          (↑(unit⁻¹) : Matrix (Fin rank) (Fin rank) ℂ) := by simp
      _ = _ := by rw [← h]; simp [mul_assoc]

/-- An invertible complex combination in the scalar extension of the actual
rational Hodge-morphism space yields an actual rational Hodge isomorphism. -/
noncomputable def rationalHodgeMatrixIso_of_extendedCombination
    {rank : ℕ} {Index : Type*} [Fintype Index]
    (source target : RationalWeightThreeHodgeMatrices rank)
    (family : Index → Matrix (Fin rank) (Fin rank) ℚ)
    (members : ∀ i, family i ∈ rationalHodgeMorphismSubspace source target)
    (coefficient : Index → ℂ)
    (invertible : (∑ i, coefficient i • (family i).map (algebraMap ℚ ℂ)).det ≠ 0) :
    RationalWeightThreeHodgeMatrixIso source target := by
  let existence := matrixMorphismSubspace_contains_invertible
    (rationalHodgeMorphismSubspace source target) family members (algebraMap ℚ ℂ) coefficient invertible
  let matrix := Classical.choose existence
  have member : matrix ∈ rationalHodgeMorphismSubspace source target := (Classical.choose_spec existence).1
  have determinant : matrix.det ≠ 0 := (Classical.choose_spec existence).2
  have unit : IsUnit matrix := (Matrix.isUnit_iff_isUnit_det matrix).mpr
    (isUnit_iff_ne_zero.mpr determinant)
  let chosen := Classical.choose unit
  have equation : (chosen : Matrix (Fin rank) (Fin rank) ℚ)=matrix := Classical.choose_spec unit
  refine ⟨chosen,?_⟩
  intro p
  rw [equation]
  exact member p

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
