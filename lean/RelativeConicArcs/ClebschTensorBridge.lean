import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Matrix.Basic

/-!
# A finite-field Clebsch cubic tensor

This module checks an explicit contraction identity over `ZMod 11`.  The input tensor has dimension
ten and twenty nonzero symmetric coordinates.  The displayed ten-by-four matrix restricts it to
the sum-zero hyperplane in the five-dimensional permutation representation.  Native decision
checks all 64 entries of the resulting polarized tensor and proves that it is four times the
polarization of

`(y₁³ + y₂³ + y₃³ + y₄³ + (-y₁-y₂-y₃-y₄)³) / 3`.

The literal tensor and contraction matrix are imported certificate data.  This module does not
derive them from a matching orbit, verify a group action, or prove that the matrix comes from an
equivariant isomorphism.  Those identifications remain outside the formal statement below.  The
terminal theorem uses Lean's native evaluator and therefore has the implementation axiom printed
at the end of the module in addition to Lean's standard logical quotient axioms.
-/

namespace RelativeConicArcs
namespace ClebschTensorBridge

/-- The prime field with eleven elements used by the explicit tensor certificate. -/
abbrev F11 := ZMod 11

/-- The nondecreasing rearrangement of three indices, represented by their values. -/
def sortedTriple (i j k : Fin 10) : Nat × Nat × Nat :=
  let low := min i.val (min j.val k.val)
  let high := max i.val (max j.val k.val)
  (low, i.val + j.val + k.val - low - high, high)

/-- One nonzero coordinate of a symmetric tensor in a nondecreasing triple basis. -/
structure SymmetricCoordinate where
  first : Fin 10
  second : Fin 10
  third : Fin 10
  coefficient : F11

/-- The twenty nonzero coordinates of the signed matching cubic. -/
def signedMatchingSupport : List SymmetricCoordinate := [
  ⟨0, 4, 9, 2⟩,
  ⟨0, 5, 9, 3⟩,
  ⟨0, 6, 8, 8⟩,
  ⟨0, 7, 7, 5⟩,
  ⟨1, 3, 9, 8⟩,
  ⟨1, 4, 8, 1⟩,
  ⟨1, 5, 8, 5⟩,
  ⟨1, 6, 7, 9⟩,
  ⟨2, 2, 9, 5⟩,
  ⟨2, 3, 8, 9⟩,
  ⟨2, 4, 7, 7⟩,
  ⟨2, 5, 7, 8⟩,
  ⟨2, 6, 6, 10⟩,
  ⟨3, 3, 7, 10⟩,
  ⟨3, 4, 6, 4⟩,
  ⟨3, 5, 6, 4⟩,
  ⟨4, 4, 4, 6⟩,
  ⟨4, 4, 5, 2⟩,
  ⟨4, 5, 5, 2⟩,
  ⟨5, 5, 5, 5⟩
]

/-- The symmetric ten-dimensional cubic tensor determined by `signedMatchingSupport`. -/
def signedMatchingCubic (i j k : Fin 10) : F11 :=
  match signedMatchingSupport.find? fun coordinate =>
      (coordinate.first.val, coordinate.second.val, coordinate.third.val) == sortedTriple i j k with
  | some coordinate => coordinate.coefficient
  | none => 0

/-- The contraction matrix obtained by transporting to the ten-pair permutation module and
restricting by `y ↦ (yᵢ + yⱼ)`. -/
def pairRestriction : Matrix (Fin 10) (Fin 4) F11 := ![
  ![3, 6, 1, 10],
  ![9, 2, 6, 2],
  ![7, 4, 3, 5],
  ![9, 4, 7, 4],
  ![6, 0, 0, 6],
  ![3, 0, 0, 3],
  ![0, 4, 8, 6],
  ![1, 7, 10, 3],
  ![0, 2, 7, 4],
  ![4, 5, 6, 8]
]

/-- The contribution of one nondecreasing symmetric-tensor coordinate to a contraction. -/
def symmetricContractionTerm (i j k : Fin 10) (a b c : Fin 4) : F11 :=
  if i = j then
    if j = k then
      pairRestriction i a * pairRestriction i b * pairRestriction i c
    else
      pairRestriction i a * pairRestriction i b * pairRestriction k c +
      pairRestriction i a * pairRestriction k b * pairRestriction i c +
      pairRestriction k a * pairRestriction i b * pairRestriction i c
  else if j = k then
    pairRestriction i a * pairRestriction j b * pairRestriction j c +
    pairRestriction j a * pairRestriction i b * pairRestriction j c +
    pairRestriction j a * pairRestriction j b * pairRestriction i c
  else
    pairRestriction i a * pairRestriction j b * pairRestriction k c +
    pairRestriction i a * pairRestriction k b * pairRestriction j c +
    pairRestriction j a * pairRestriction i b * pairRestriction k c +
    pairRestriction j a * pairRestriction k b * pairRestriction i c +
    pairRestriction k a * pairRestriction i b * pairRestriction j c +
    pairRestriction k a * pairRestriction j b * pairRestriction i c

/-- The polarized four-dimensional tensor obtained by contracting the twenty nonzero symmetric
coordinates of `signedMatchingCubic` with `pairRestriction` in all three indices. -/
def restrictedCubic (a b c : Fin 4) : F11 :=
  (signedMatchingSupport.map fun coordinate =>
    coordinate.coefficient *
      symmetricContractionTerm coordinate.first coordinate.second coordinate.third a b c).sum

/-- The polarization of the Clebsch cubic after eliminating the fifth coordinate by
`y₅ = -y₁-y₂-y₃-y₄`. -/
def clebschPolarization (a b c : Fin 4) : F11 :=
  if a = b ∧ b = c then 0 else -(3 : F11)⁻¹

/-- The explicit contracted tensor is four times the Clebsch cubic tensor over `F_11`.  Native
decision exhausts the finite domain `(Fin 4)³`; no sampled or searched cases are used. -/
theorem restrictedCubic_eq_four_mul_clebschPolarization :
    ∀ a b c : Fin 4,
      restrictedCubic a b c = 4 * clebschPolarization a b c := by
  native_decide

/-- The contracted tensor is nonzero; for example, its `(0,0,1)` entry is six. -/
theorem restrictedCubic_nonzero : restrictedCubic 0 0 1 = 6 := by
  decide

/-- The denominator of the rational Gaunt normalization is divisible by eleven, so that
normalization has no direct reduction to `F_11`. -/
theorem gauntDenominator_divisibleBy_eleven : 11 ∣ 1247103 := by
  norm_num

#print axioms restrictedCubic_eq_four_mul_clebschPolarization
#print axioms restrictedCubic_nonzero
#print axioms gauntDenominator_divisibleBy_eleven

end ClebschTensorBridge
end RelativeConicArcs
