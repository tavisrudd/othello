import FiniteGeom.Code
import Mathlib.LinearAlgebra.BilinearForm.Orthogonal
import Mathlib.LinearAlgebra.Matrix.ToLin

/-!
# Nondegeneracy of the standard code pairing

The coordinate dot product is a symmetric nondegenerate bilinear form on a finite function space.
Consequently the double dual of a linear code is the original code, and the parity-check space
determines the code injectively.
-/

namespace FiniteGeom

open Matrix

variable {ι : Type*} [Fintype ι] [DecidableEq ι]
  {𝔽 : Type*} [Field 𝔽] [DecidableEq 𝔽]

/-- The standard coordinate dot product as a bilinear form. -/
def standardDotBilin : LinearMap.BilinForm 𝔽 (ι → 𝔽) :=
  dotProductBilin 𝔽 𝔽

omit [DecidableEq ι] [DecidableEq 𝔽] in
@[simp]
theorem standardDotBilin_apply (u v : ι → 𝔽) :
    standardDotBilin u v = u ⬝ᵥ v := rfl

theorem standardDotBilin_isRefl :
    (standardDotBilin (ι := ι) (𝔽 := 𝔽)).IsRefl := by
  intro u v huv
  rw [standardDotBilin_apply, dotProduct_comm]
  exact huv

omit [DecidableEq 𝔽] in
theorem standardDotBilin_nondegenerate :
    (standardDotBilin (ι := ι) (𝔽 := 𝔽)).Nondegenerate := by
  constructor
  · intro u hu
    funext i
    have hi := hu (Pi.single i 1)
    simpa [standardDotBilin] using hi
  · intro v hv
    funext i
    have hi := hv (Pi.single i 1)
    simpa [standardDotBilin] using hi

omit [DecidableEq ι] [DecidableEq 𝔽] in
theorem dualCode_eq_standardDotBilin_orthogonal (C : Submodule 𝔽 (ι → 𝔽)) :
    dualCode C = (standardDotBilin (ι := ι) (𝔽 := 𝔽)).orthogonal C := by
  ext y
  rfl

/-- The double dual of a finite linear code under the standard coordinate pairing is the code. -/
@[simp]
theorem dualCode_dualCode (C : Submodule 𝔽 (ι → 𝔽)) :
    dualCode (dualCode C) = C := by
  rw [dualCode_eq_standardDotBilin_orthogonal,
    dualCode_eq_standardDotBilin_orthogonal,
    LinearMap.BilinForm.orthogonal_orthogonal standardDotBilin_nondegenerate
      standardDotBilin_isRefl]

/-- Equality of parity-check spaces implies equality of the represented linear codes. -/
theorem dualCode_injective : Function.Injective
    (dualCode : Submodule 𝔽 (ι → 𝔽) → Submodule 𝔽 (ι → 𝔽)) := by
  intro C C' h
  rw [← dualCode_dualCode C, ← dualCode_dualCode C', h]

#print axioms dualCode_dualCode
#print axioms dualCode_injective

end FiniteGeom
