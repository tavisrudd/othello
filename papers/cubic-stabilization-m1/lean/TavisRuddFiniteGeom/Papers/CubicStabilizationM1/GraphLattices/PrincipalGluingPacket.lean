import Mathlib.FieldTheory.Finite.Extension
import Mathlib.LinearAlgebra.Projectivization.Cardinality
import Mathlib.LinearAlgebra.Prod
import Mathlib.Tactic

/-!
# Finite-field core of the principal gluing packet

This module identifies a projective line with its affine scalar graphs plus
the vertical line, counts the resulting packets over fields of orders four
and three, and verifies the alternating-pairing argument for self-adjoint
graph slopes.  Group stabilizers and geometric selection are intentionally
not asserted.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

open scoped LinearAlgebra.Projectivization

/-- A concrete Mathlib model of the field with four elements. -/
abbrev F4 := FiniteField.Extension (ZMod 2) 2 2

/-- The chosen field with four elements has cardinality four. -/
theorem natCard_F4 : Nat.card F4 = 4 := by
  rw [FiniteField.natCard_extension]
  norm_num

section ProjectiveLine

variable (K : Type*) [Field K]

/-- The projective point represented by the scalar graph vector `(1,a)`. -/
def scalarGraphPoint (a : K) : Projectivization K (K × K) :=
  Projectivization.mk K (1, a) (by simp)

/-- The vertical projective point represented by `(0,1)`. -/
def verticalPoint : Projectivization K (K × K) :=
  Projectivization.mk K (0, 1) (by simp)

/-- Scalar graph points have exactly their scalar as projective coordinate. -/
theorem scalarGraphPoint_injective : Function.Injective (scalarGraphPoint K) := by
  intro first second equality
  rw [scalarGraphPoint, scalarGraphPoint,
    Projectivization.mk_eq_mk_iff'] at equality
  obtain ⟨coefficient, coefficientEquality⟩ := equality
  have firstCoordinate := congrArg Prod.fst coefficientEquality
  have secondCoordinate := congrArg Prod.snd coefficientEquality
  simp only [smul_eq_mul, Prod.smul_fst, Prod.smul_snd, mul_one] at firstCoordinate secondCoordinate
  simpa [firstCoordinate] using secondCoordinate.symm

/-- The vertical point is not a scalar graph. -/
theorem verticalPoint_ne_scalarGraphPoint (a : K) :
    verticalPoint K ≠ scalarGraphPoint K a := by
  intro equality
  rw [verticalPoint, scalarGraphPoint,
    Projectivization.mk_eq_mk_iff'] at equality
  obtain ⟨coefficient, coefficientEquality⟩ := equality
  have firstCoordinate := congrArg Prod.fst coefficientEquality
  have secondCoordinate := congrArg Prod.snd coefficientEquality
  simp only [smul_eq_mul, Prod.smul_fst, Prod.smul_snd, mul_one] at firstCoordinate secondCoordinate
  rw [firstCoordinate, zero_mul] at secondCoordinate
  exact zero_ne_one secondCoordinate

/-- The standard affine chart: `none` is the vertical line and `some a` is
the graph of scalar `a`. -/
def projectiveLineChart : Option K → Projectivization K (K × K)
  | none => verticalPoint K
  | some a => scalarGraphPoint K a

/-- The standard affine chart is injective over every field. -/
theorem projectiveLineChart_injective :
    Function.Injective (projectiveLineChart K) := by
  intro first second equality
  cases first with
  | none =>
      cases second with
      | none => rfl
      | some value => exact (verticalPoint_ne_scalarGraphPoint K value equality).elim
  | some firstValue =>
      cases second with
      | none => exact (verticalPoint_ne_scalarGraphPoint K firstValue equality.symm).elim
      | some secondValue =>
          exact congrArg some (scalarGraphPoint_injective K equality)

/-- Every projective-line point is either the vertical line or a unique
scalar graph.  Surjectivity is proved from the exact finite cardinality
formula, after the coordinate map has been proved injective. -/
noncomputable def optionEquivProjectiveLine [Finite K] :
    Option K ≃ Projectivization K (K × K) := by
  apply Equiv.ofBijective (projectiveLineChart K)
  apply (Nat.bijective_iff_injective_and_card _).mpr
  refine ⟨projectiveLineChart_injective K, ?_⟩
  have finrankTwo : Module.finrank K (K × K) = 2 := by
    rw [Module.finrank_prod]
    simp
  rw [Projectivization.card_of_finrank_two K (K × K) finrankTwo]
  letI : Fintype K := Fintype.ofFinite K
  rw [Nat.card_eq_fintype_card, Fintype.card_option,
    ← Nat.card_eq_fintype_card]

/-- A projective line over a finite field of order four has five points. -/
theorem projectiveLine_card_five_of_card_four [Finite K]
    (cardinality : Nat.card K = 4) :
    Nat.card (Projectivization K (K × K)) = 5 := by
  have finrankTwo : Module.finrank K (K × K) = 2 := by
    rw [Module.finrank_prod]
    simp
  rw [Projectivization.card_of_finrank_two K (K × K) finrankTwo]
  omega

/-- A projective line over a finite field of order three has four points. -/
theorem projectiveLine_card_four_of_card_three [Finite K]
    (cardinality : Nat.card K = 3) :
    Nat.card (Projectivization K (K × K)) = 4 := by
  have finrankTwo : Module.finrank K (K × K) = 2 := by
    rw [Module.finrank_prod]
    simp
  rw [Projectivization.card_of_finrank_two K (K × K) finrankTwo]
  omega

end ProjectiveLine

/-- The two-primary projective packet over the chosen `F4` has exactly five
members: four scalar graphs and the vertical line. -/
theorem f4_projectiveLine_card :
    Nat.card (Projectivization F4 (F4 × F4)) = 5 :=
  projectiveLine_card_five_of_card_four F4 natCard_F4

/-- The three-primary scalar-graph packet over `F3` has four members. -/
theorem f3_projectiveLine_card :
    Nat.card (Projectivization (ZMod 3) (ZMod 3 × ZMod 3)) = 4 := by
  apply projectiveLine_card_four_of_card_three
  norm_num

section Isotropy

variable {K H : Type*} [Field K] [AddCommGroup H] [Module K H]

/-- The graph embedding of a linear slope in two multiplicity copies. -/
def graphEmbedding (slope : H →ₗ[K] H) : H →ₗ[K] H × H :=
  LinearMap.prod LinearMap.id slope

/-- The vertical embedding in two multiplicity copies. -/
def verticalEmbedding : H →ₗ[K] H × H :=
  LinearMap.prod 0 LinearMap.id

/-- Alternating multiplicity pairing induced by a supplied coefficient
pairing. -/
def multiplicityAlternatingPairing
    (coefficientPairing : H →ₗ[K] H →ₗ[K] K)
    (left right : H × H) : K :=
  coefficientPairing left.1 right.2 - coefficientPairing left.2 right.1

/-- A self-adjoint slope has isotropic graph for the alternating
multiplicity pairing. -/
theorem graphEmbedding_isotropic_of_selfAdjoint
    (coefficientPairing : H →ₗ[K] H →ₗ[K] K)
    (slope : H →ₗ[K] H)
    (selfAdjoint : ∀ left right,
      coefficientPairing left (slope right) =
        coefficientPairing (slope left) right)
    (left right : H) :
    multiplicityAlternatingPairing coefficientPairing
        (graphEmbedding (K := K) slope left)
        (graphEmbedding (K := K) slope right) = 0 := by
  simp [multiplicityAlternatingPairing, graphEmbedding, selfAdjoint]

/-- The vertical half is isotropic for every coefficient pairing. -/
theorem verticalEmbedding_isotropic
    (coefficientPairing : H →ₗ[K] H →ₗ[K] K) (left right : H) :
    multiplicityAlternatingPairing coefficientPairing
        (verticalEmbedding (K := K) left)
        (verticalEmbedding (K := K) right) = 0 := by
  simp [multiplicityAlternatingPairing, verticalEmbedding]

/-- A graph half has the same dimension as one coefficient copy. -/
theorem finrank_graphEmbedding_range [Module.Finite K H] (slope : H →ₗ[K] H) :
    Module.finrank K (LinearMap.range (graphEmbedding (K := K) slope)) =
      Module.finrank K H := by
  apply LinearMap.finrank_range_of_inj
  intro left right equality
  exact congrArg Prod.fst equality

/-- The ambient two-copy space has twice the coefficient dimension. -/
theorem finrank_multiplicity_pair [Module.Finite K H] :
    Module.finrank K (H × H) = 2 * Module.finrank K H := by
  rw [Module.finrank_prod]
  omega

end Isotropy

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
