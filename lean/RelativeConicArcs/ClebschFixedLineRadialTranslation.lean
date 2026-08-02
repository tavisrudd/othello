import RelativeConicArcs.ClebschBalancedSheets

/-!
# Radial translation on a two-sheet fixed line

This module isolates the algebraic part of a fixed-line argument for two finite sheets.  A moving
base point leaves the two top configurations and their first and second moments unchanged, while
the outer radial constant changes from `c` to `c - 2t`.  When this constant is nonzero, a radial
level separates the sheets.  The abstract Radical--Hadamard theorem then identifies the
coordinatewise-product square with the equal-sheet-sum hyperplane and its annihilator with the
one-dimensional sheet-sign line.

The module does not identify a geometric fixed locus, a group stabilizer, or a completely
reducible point.  Those inputs belong to the geometric application.  It also performs no finite
orbit enumeration: over a finite field, deleting the reference parameter and the unique
coalescence parameter leaves exactly `|K| - 2` parameters.
-/

namespace RelativeConicArcs
namespace ClebschFixedLineRadialTranslation

open ClebschBalancedSheets

/-- Parameter-independent data seen after radial translation is expressed relative to the moving
base point.  The types of the top configurations and moments are deliberately abstract: the
geometric application supplies their concrete meanings. -/
structure TwoSheetRadialData (K Top FirstMoment SecondMoment : Type*) where
  leftTop : Top
  rightTop : Top
  firstMoment : FirstMoment
  secondMoment : SecondMoment
  referenceOuterConstant : K

section RadialData

variable {K Top FirstMoment SecondMoment : Type*} [Ring K]

/-- The pair of top configurations at a parameter on the radial line. -/
def topConfigurationsAt
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment) (_t : K) : Top × Top :=
  (data.leftTop, data.rightTop)

/-- The first moment at a parameter on the radial line. -/
def firstMomentAt
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment) (_t : K) : FirstMoment :=
  data.firstMoment

/-- The second moment at a parameter on the radial line. -/
def secondMomentAt
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment) (_t : K) : SecondMoment :=
  data.secondMoment

/-- The outer radial sheet constant after translation by the parameter `t`. -/
def outerRadialConstantAt
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment) (t : K) : K :=
  data.referenceOuterConstant - 2 * t

omit [Ring K] in
/-- Radial translation preserves the top configurations and their first and second moments. -/
theorem topConfigurations_first_secondMoments_invariant
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment) (s t : K) :
    topConfigurationsAt data s = topConfigurationsAt data t ∧
      firstMomentAt data s = firstMomentAt data t ∧
      secondMomentAt data s = secondMomentAt data t := by
  exact ⟨rfl, rfl, rfl⟩

/-- The outer radial constant changes affinely with slope `-2`. -/
theorem outerRadialConstantAt_sub
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment) (s t : K) :
    outerRadialConstantAt data t - outerRadialConstantAt data s = -2 * (t - s) := by
  unfold outerRadialConstantAt
  noncomm_ring

end RadialData

section FieldLine

variable {K Top FirstMoment SecondMoment : Type*} [Field K]

/-- The unique parameter at which the two radial constants coalesce. -/
def coalescenceParameter
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment) : K :=
  data.referenceOuterConstant / 2

/-- Away from characteristic two, the affine outer constant vanishes exactly at the displayed
coalescence parameter. -/
theorem outerRadialConstantAt_eq_zero_iff
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment) (two_ne_zero : (2 : K) ≠ 0)
    (t : K) :
    outerRadialConstantAt data t = 0 ↔ t = coalescenceParameter data := by
  rw [outerRadialConstantAt, sub_eq_zero]
  constructor
  · intro h
    apply (eq_div_iff two_ne_zero).2
    simpa [mul_comm] using h.symm
  · intro h
    have ht := (eq_div_iff two_ne_zero).1 h
    simpa [mul_comm] using ht.symm

/-- If the reference outer constant is nonzero, the matching parameter `0` and the coalescence
parameter are distinct. -/
theorem coalescenceParameter_ne_zero
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment)
    (reference_ne_zero : data.referenceOuterConstant ≠ 0) (two_ne_zero : (2 : K) ≠ 0) :
    coalescenceParameter data ≠ 0 :=
  div_ne_zero reference_ne_zero two_ne_zero

end FieldLine

section RadicalHadamard

variable {q : ℕ} {K Top FirstMoment SecondMoment : Type*} [Field K]

/-- The algebraic hypotheses shared by a radial family of two-sheet evaluation spaces.  The
geometric application proves these hypotheses from its unchanged top configurations and moments;
the only parameter-dependent separation is the affine outer radial constant. -/
structure RadicalHadamardFamily where
  radialData : TwoSheetRadialData K Top FirstMoment SecondMoment
  evaluationSpace : K → Submodule K (SheetPair q K)
  radialLevel : K → SheetPair q K
  one_mem : ∀ t, (⟨(1 : Fin q → K), (1 : Fin q → K)⟩ : SheetPair q K) ∈ evaluationSpace t
  radialLevel_mem : ∀ t, radialLevel t ∈ evaluationSpace t
  radialLevel_left : ∀ t i, (radialLevel t).1 i = 0
  radialLevel_right : ∀ t i,
    (radialLevel t).2 i = outerRadialConstantAt radialData t
  restrictsOntoZeroSum : ∀ t, RestrictsOntoZeroSum (evaluationSpace t)
  productsHaveEqualSheetSums : ∀ t, ProductsHaveEqualSheetSums (evaluationSpace t)
  hasNonzeroSheetProduct : ∀ t, HasNonzeroSheetProduct (evaluationSpace t)

/-- At a noncoalescent parameter, the radial level and the constant function recover both sheet
indicators. -/
theorem indicators_mem_of_outerRadialConstant_ne_zero
    (family : RadicalHadamardFamily (q := q) (K := K) (Top := Top)
      (FirstMoment := FirstMoment) (SecondMoment := SecondMoment)) (t : K)
    (hnoncoalescent : outerRadialConstantAt family.radialData t ≠ 0) :
    leftIndicator ∈ family.evaluationSpace t ∧
      rightIndicator ∈ family.evaluationSpace t := by
  exact indicators_mem_of_separating_level (family.evaluationSpace t) (family.one_mem t)
    (family.radialLevel_mem t) (a := 0) (b := outerRadialConstantAt family.radialData t)
    hnoncoalescent.symm (family.radialLevel_left t)
    (family.radialLevel_right t)

/-- Every noncoalescent member of a radial family inherits the Radical--Hadamard conclusion. -/
theorem hadamardSquare_eq_equalSheetSum_of_noncoalescent
    (family : RadicalHadamardFamily (q := q) (K := K) (Top := Top)
      (FirstMoment := FirstMoment) (SecondMoment := SecondMoment)) (t : K)
    (hnoncoalescent : outerRadialConstantAt family.radialData t ≠ 0) :
    hadamardSquare (family.evaluationSpace t) = equalSheetSum := by
  obtain ⟨hleft, hright⟩ :=
    indicators_mem_of_outerRadialConstant_ne_zero family t hnoncoalescent
  exact hadamardSquare_eq_equalSheetSum (family.evaluationSpace t) hleft hright
    (family.restrictsOntoZeroSum t) (family.productsHaveEqualSheetSums t)
    (family.hasNonzeroSheetProduct t)

/-- On a nonempty pair of sheets, every noncoalescent member has precisely the sheet-sign
annihilator line.  This is the unique quadratic-trade conclusion of Radical--Hadamard recovery. -/
theorem annihilates_hadamardSquare_iff_eq_sheetSignLine_of_noncoalescent
    (family : RadicalHadamardFamily (q := q) (K := K) (Top := Top)
      (FirstMoment := FirstMoment) (SecondMoment := SecondMoment)) (i₀ : Fin q)
    (t : K) (hnoncoalescent : outerRadialConstantAt family.radialData t ≠ 0)
    (trade : SheetPair q K) :
    (∀ x ∈ hadamardSquare (family.evaluationSpace t), sheetPairing trade x = 0) ↔
      ∃ c : K, trade = (⟨fun _ ↦ c, fun _ ↦ -c⟩ : SheetPair q K) := by
  rw [hadamardSquare_eq_equalSheetSum_of_noncoalescent family t hnoncoalescent]
  exact annihilates_equalSheetSum_iff_eq_sheetSignLine i₀ trade

end RadicalHadamard

section FiniteCount

variable {K Top FirstMoment SecondMoment : Type*} [Field K] [Fintype K] [DecidableEq K]

/-- Parameters other than the matching value `0` and the coalescence value. -/
def nonmatchingNoncoalescentParameters
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment) : Finset K :=
  (Finset.univ.erase 0).erase (coalescenceParameter data)

@[simp] theorem mem_nonmatchingNoncoalescentParameters_iff
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment) (two_ne_zero : (2 : K) ≠ 0)
    (t : K) :
    t ∈ nonmatchingNoncoalescentParameters data ↔
      t ≠ 0 ∧ outerRadialConstantAt data t ≠ 0 := by
  simp only [nonmatchingNoncoalescentParameters, Finset.mem_erase, Finset.mem_univ, and_true]
  have hzero := outerRadialConstantAt_eq_zero_iff data two_ne_zero t
  constructor
  · rintro ⟨hcoalescence, hmatching⟩
    exact ⟨hmatching, fun h ↦ hcoalescence (hzero.mp h)⟩
  · rintro ⟨hmatching, houter⟩
    exact ⟨fun h ↦ houter (hzero.mpr h), hmatching⟩

/-- A finite radial line with distinct matching and coalescence parameters has exactly `|K| - 2`
nonmatching noncoalescent parameters. -/
theorem card_nonmatchingNoncoalescentParameters
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment)
    (reference_ne_zero : data.referenceOuterConstant ≠ 0) (two_ne_zero : (2 : K) ≠ 0) :
    (nonmatchingNoncoalescentParameters data).card = Fintype.card K - 2 := by
  have hcoalescence : coalescenceParameter data ∈ (Finset.univ.erase (0 : K)) := by
    exact Finset.mem_erase.mpr
      ⟨coalescenceParameter_ne_zero data reference_ne_zero two_ne_zero, Finset.mem_univ _⟩
  rw [nonmatchingNoncoalescentParameters, Finset.card_erase_of_mem hcoalescence,
    Finset.card_erase_of_mem (Finset.mem_univ (0 : K)), Finset.card_univ]
  omega

/-- The table-free fixed-line conclusion: all `|K| - 2` parameters other than the matching and
coalescence values have exactly the sheet-sign quadratic-trade line. -/
theorem nonmatchingNoncoalescentParameters_tradeLine_and_card
    {q : ℕ}
    (family : RadicalHadamardFamily (q := q) (K := K) (Top := Top)
      (FirstMoment := FirstMoment) (SecondMoment := SecondMoment))
    (i₀ : Fin q) (reference_ne_zero : family.radialData.referenceOuterConstant ≠ 0)
    (two_ne_zero : (2 : K) ≠ 0) :
    (∀ t ∈ nonmatchingNoncoalescentParameters family.radialData,
      ∀ trade : SheetPair q K,
        (∀ x ∈ hadamardSquare (family.evaluationSpace t), sheetPairing trade x = 0) ↔
          ∃ c : K, trade = (⟨fun _ ↦ c, fun _ ↦ -c⟩ : SheetPair q K)) ∧
      (nonmatchingNoncoalescentParameters family.radialData).card = Fintype.card K - 2 := by
  constructor
  · intro t ht trade
    have houter :=
      (mem_nonmatchingNoncoalescentParameters_iff family.radialData two_ne_zero t).mp ht
    exact annihilates_hadamardSquare_iff_eq_sheetSignLine_of_noncoalescent
      family i₀ t houter.2 trade
  · exact card_nonmatchingNoncoalescentParameters family.radialData reference_ne_zero two_ne_zero

end FiniteCount

end ClebschFixedLineRadialTranslation
end RelativeConicArcs
