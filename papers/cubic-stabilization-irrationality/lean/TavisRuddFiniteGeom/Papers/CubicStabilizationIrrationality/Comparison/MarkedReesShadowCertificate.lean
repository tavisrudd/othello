import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.BinaryCubicOrderResidues
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.Generated.MarkedReesShadowData
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.KummerDivisorGenerator

/-!
# Certificate checker for the marked Rees shadow

The generic cubic packet forgets two different pieces of native information.
The generated Laurent blocks record the relative lattice position of the two
explicit rank-six orders.  The generated first jet records a nontrivial
pairing-compatible extension which has zero coweight and trivial associated
graded.

This module independently recomputes the three elementary-divisor pairs,
their relative coweight, and every first-jet identity.  It then packages the
finite data in a `ReesPortChart`.  A chart is not a geometric marked Rees
port: it has no trait, actual loop, native QDM lattice, or occurrence map.
Constructing those data and identifying them with one of the checked charts
is the remaining source adapter.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MarkedReesShadowCertificate

open Generated.MarkedReesShadowData

/-- Product of two Laurent monomials. -/
def monomialMul (left right : LaurentMonomial) : LaurentMonomial :=
  ⟨left.coefficient * right.coefficient, left.exponent + right.exponent⟩

/-- Valuation of a Laurent monomial, with zero represented by `none`. -/
def monomialValuation (entry : LaurentMonomial) : Option ℤ :=
  if entry.coefficient = 0 then none else some entry.exponent

/-- Minimum of two optional finite valuations. -/
def minValuation : Option ℤ → Option ℤ → Option ℤ
  | none, value => value
  | value, none => value
  | some left, some right => some (min left right)

/-- Minimum valuation of a nonzero entry of a `2 x 2` block. -/
def blockMinimumValuation
    (block : Matrix BlockIndex BlockIndex LaurentMonomial) : Option ℤ :=
  minValuation (monomialValuation (block 0 0))
    (minValuation (monomialValuation (block 0 1))
      (minValuation (monomialValuation (block 1 0))
        (monomialValuation (block 1 1))))

/-- Valuation of the difference of two Laurent monomials.  Returning
`none` in the equal-exponent cancellation case makes that case explicit
rather than silently assigning it a valuation. -/
def monomialDifferenceValuation
    (positive negative : LaurentMonomial) : Option ℤ :=
  if positive.coefficient = 0 then
    monomialValuation negative
  else if negative.coefficient = 0 then
    monomialValuation positive
  else if positive.exponent < negative.exponent then
    some positive.exponent
  else if negative.exponent < positive.exponent then
    some negative.exponent
  else if positive.coefficient - negative.coefficient = 0 then
    none
  else
    some positive.exponent

/-- Determinant valuation of a `2 x 2` monomial block. -/
def blockDeterminantValuation
    (block : Matrix BlockIndex BlockIndex LaurentMonomial) : Option ℤ :=
  monomialDifferenceValuation
    (monomialMul (block 0 0) (block 1 1))
    (monomialMul (block 0 1) (block 1 0))

/-- The two elementary divisors determined by the minimum entry valuation and
the determinant valuation. -/
def blockElementaryDivisors
    (block : Matrix BlockIndex BlockIndex LaurentMonomial) :
    Option (ℤ × ℤ) := do
  let minimum ← blockMinimumValuation block
  let determinant ← blockDeterminantValuation block
  pure (minimum, determinant - minimum)

/-- Recompute the relative coweight after the harmless block permutation
`(0,2,1)`. -/
def computedRelativeCoweight : Option (List ℤ) := do
  let first ← blockElementaryDivisors comparisonBlock0
  let second ← blockElementaryDivisors comparisonBlock1
  let third ← blockElementaryDivisors comparisonBlock2
  pure [first.1, first.2, third.1, third.2, second.1, second.2]

/-- Row indices of the three Laurent blocks in the displayed comparison
matrix. -/
def comparisonRows : Matrix (Fin 3) BlockIndex Index :=
  !![1, 4; 2, 3; 0, 5]

/-- Column indices of the three Laurent blocks in the displayed comparison
matrix. -/
def comparisonColumns : Matrix (Fin 3) BlockIndex Index :=
  !![1, 3; 2, 4; 0, 5]

/-- Extract one of the three displayed blocks from the full comparison
matrix. -/
def extractedComparisonBlock (block : Fin 3) :
    Matrix BlockIndex BlockIndex LaurentMonomial :=
  fun i j => comparisonMatrix (comparisonRows block i) (comparisonColumns block j)

/-- The three generated blocks are exact submatrices of the full basis-change
matrix coming from the five displayed generator images. -/
theorem comparisonMatrix_blockExtraction :
    extractedComparisonBlock 0 = comparisonBlock0 ∧
      extractedComparisonBlock 1 = comparisonBlock1 ∧
      extractedComparisonBlock 2 = comparisonBlock2 := by
  constructor
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [extractedComparisonBlock, comparisonRows, comparisonColumns,
        comparisonMatrix, comparisonBlock0]
  constructor
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [extractedComparisonBlock, comparisonRows, comparisonColumns,
        comparisonMatrix, comparisonBlock1]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [extractedComparisonBlock, comparisonRows, comparisonColumns,
        comparisonMatrix, comparisonBlock2]

/-- Row block labels for the full comparison matrix. -/
def comparisonRowLabel : Index → Fin 3 :=
  ![2, 0, 1, 1, 0, 2]

/-- Column block labels for the full comparison matrix. -/
def comparisonColumnLabel : Index → Fin 3 :=
  ![2, 0, 1, 0, 1, 2]

/-- All entries outside the three extracted blocks vanish. -/
theorem comparisonMatrix_offBlock_zero
    (i j : Index) (different : comparisonRowLabel i ≠ comparisonColumnLabel j) :
    (comparisonMatrix i j).coefficient = 0 := by
  fin_cases i <;> fin_cases j <;>
    norm_num [comparisonRowLabel, comparisonColumnLabel] at different <;>
    norm_num [comparisonMatrix]

/-- The exact elementary divisors of the three comparison blocks. -/
theorem comparisonBlock_elementaryDivisors :
    blockElementaryDivisors comparisonBlock0 = some (-1, 0) ∧
      blockElementaryDivisors comparisonBlock1 = some (0, 1) ∧
      blockElementaryDivisors comparisonBlock2 = some (0, 0) := by
  norm_num [blockElementaryDivisors, blockMinimumValuation,
    blockDeterminantValuation, monomialDifferenceValuation, monomialMul,
    minValuation, monomialValuation, comparisonBlock0, comparisonBlock1,
    comparisonBlock2]

/-- Lean independently recovers the coweight emitted by the Rust solver. -/
theorem relativeCoweight_checked :
    computedRelativeCoweight = some certifiedRelativeCoweight := by
  norm_num [computedRelativeCoweight, blockElementaryDivisors,
    blockMinimumValuation, blockDeterminantValuation,
    monomialDifferenceValuation, monomialMul, minValuation,
    monomialValuation, comparisonBlock0, comparisonBlock1, comparisonBlock2,
    certifiedRelativeCoweight]

/-- The certified relative coweight is nonzero. -/
theorem certifiedRelativeCoweight_ne_zero :
    certifiedRelativeCoweight ≠ [0, 0, 0, 0, 0, 0] := by
  decide

/-- The certified coweight is self-dual. -/
theorem certifiedRelativeCoweight_selfDual :
    certifiedRelativeCoweight.reverse =
      certifiedRelativeCoweight.map (fun value => -value) := by
  decide

/-- Cohomological weights in the basis `1,e,x,xe,x^2,x^2e`. -/
def cohomologicalWeight : Index → ℤ :=
  ![0, 1, 1, 2, 2, 3]

/-- A finite first-jet chart.  These are exactly the identities checked after
a geometric provider has supplied a native lattice and a Kummer parameter. -/
structure ReesJetChart where
  firstJet : Matrix Index Index ℚ
  pairingTangent :
    firstJet.transpose * ThreefoldKummerCompatibility.threefoldPairing +
      ThreefoldKummerCompatibility.threefoldPairing * firstJet = 0
  fixesUnitAndDivisors :
    ∀ i : Index, ∀ j : Fin 3,
      firstJet i ⟨j, by omega⟩ = 0
  homogeneous :
    ∀ i j : Index, firstJet i j ≠ 0 →
      cohomologicalWeight i + 1 = cohomologicalWeight j

/-- The zero first-jet chart. -/
def zeroJetChart : ReesJetChart where
  firstJet := 0
  pairingTangent := by simp
  fixesUnitAndDivisors := by simp
  homogeneous := by simp

/-- The generated parabolic first jet satisfies every finite chart identity. -/
def shearJetChart : ReesJetChart where
  firstJet := shearFirstJet
  pairingTangent := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [shearFirstJet,
        ThreefoldKummerCompatibility.threefoldPairing, Matrix.mul_apply,
        Fin.sum_univ_succ]
  fixesUnitAndDivisors := by
    intro i j
    fin_cases i <;> fin_cases j <;> norm_num [shearFirstJet]
  homogeneous := by
    intro i j hij
    fin_cases i <;> fin_cases j <;>
      norm_num [shearFirstJet] at hij <;>
      norm_num [cohomologicalWeight]

/-- The generated first jet is the linear term of the displayed parabolic
shear. -/
theorem shear_eq_one_add_firstJet :
    KummerDivisorGenerator.ParabolicShear.shear =
      1 + shearFirstJet := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [KummerDivisorGenerator.ParabolicShear.shear, shearFirstJet,
      Matrix.one_apply]

/-- The parabolic first jet is genuinely nonzero. -/
theorem shearFirstJet_ne_zero : shearFirstJet ≠ 0 := by
  decide

/-- Finite coweight-and-jet data.  This is a checked chart, not the
source-owned geometric port. -/
structure ReesPortChart where
  coweight : List ℤ
  coweightLength : coweight.length = 6
  coweightSelfDual :
    coweight.reverse = coweight.map (fun value => -value)
  jet : ReesJetChart

/-- The strict reference chart. -/
def referencePortChart : ReesPortChart where
  coweight := [0, 0, 0, 0, 0, 0]
  coweightLength := rfl
  coweightSelfDual := by decide
  jet := zeroJetChart

/-- The zero-coweight parabolic chart. -/
def shearPortChart : ReesPortChart where
  coweight := [0, 0, 0, 0, 0, 0]
  coweightLength := rfl
  coweightSelfDual := by decide
  jet := shearJetChart

/-- The strict and parabolic charts have the same coweight. -/
theorem reference_shear_same_coweight :
    referencePortChart.coweight = shearPortChart.coweight := rfl

/-- The strict and parabolic charts are nevertheless different. -/
theorem reference_shear_distinct :
    referencePortChart ≠ shearPortChart := by
  intro equal
  have matrices := congrArg (fun chart => chart.jet.firstJet) equal
  have zero_eq_shear : (0 : Matrix Index Index ℚ) = shearFirstJet := by
    simpa [referencePortChart, zeroJetChart, shearPortChart, shearJetChart]
      using matrices
  exact shearFirstJet_ne_zero zero_eq_shear.symm

/-- The displayed zero-coweight reference and shear models have different
modified-residue discriminants.  This theorem deliberately does not assert a
general function from charts to residues; that requires the missing
calibration adapter. -/
theorem displayed_same_coweight_different_discriminants :
    referencePortChart.coweight = shearPortChart.coweight ∧
      BinaryCubicOrderResidues.residueDiscriminant
          BinaryCubicOrderResidues.dualNumberReduction ≠
        KummerDivisorGenerator.ParabolicShear.selectedModifiedResidue.trace ^ 2 -
          4 *
            KummerDivisorGenerator.ParabolicShear.selectedModifiedResidue.det := by
  refine ⟨reference_shear_same_coweight, ?_⟩
  rw [BinaryCubicOrderResidues.dualNumber_residueDiscriminant_zero,
    KummerDivisorGenerator.ParabolicShear.selectedModifiedResidue_discriminant]
  norm_num

/-- The two independent ambiguity witnesses: generic localization can forget
a nonzero coweight, and fixed coweight can still forget a nonzero first jet. -/
theorem two_layer_information_loss :
    certifiedRelativeCoweight ≠ [0, 0, 0, 0, 0, 0] ∧
      referencePortChart.coweight = shearPortChart.coweight ∧
      referencePortChart ≠ shearPortChart :=
  ⟨certifiedRelativeCoweight_ne_zero, reference_shear_same_coweight,
    reference_shear_distinct⟩

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MarkedReesShadowCertificate
