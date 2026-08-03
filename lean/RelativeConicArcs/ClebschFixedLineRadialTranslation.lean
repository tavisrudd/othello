import RelativeConicArcs.ClebschBalancedSheets

/-!
# Radial translation on a two-sheet fixed line

This module isolates the algebraic part of a fixed-line argument for two finite sheets.  A moving
base point leaves the two top configurations and their first and second moments unchanged, while
the outer radial constant changes from `c` to `c - 2t`.  When this constant is nonzero, a radial
level separates the sheets.  The abstract Radical--Hadamard theorem then identifies the
coordinatewise-product square with the equal-sheet-sum hyperplane and its annihilator with the
one-dimensional sheet-sign line.

The evaluation space attached to a parameter is presented, not assumed: it is the sum of a
parameter-independent top space, the line of constant functions, and the line spanned by the
radial level.  The only parameter-dependent generator is that radial level, whose two sheet values
are `0` and `c - 2t`.  Between two parameters with nonzero outer constant the two radial levels are
nonzero scalar multiples of each other, so the whole evaluation space is literally the same
submodule.  Consequently the three Radical--Hadamard hypotheses — surjectivity of the two sheet
restrictions onto their zero-sum hyperplanes, equality of the two sheet sums on every
coordinatewise product, and existence of one product with nonzero sheet sum — are hypotheses at a
single reference parameter only, and are derived at every other noncoalescent parameter rather than
assumed there.

The module does not identify a geometric fixed locus, a group stabilizer, or a completely
reducible point.  Those inputs belong to the geometric application, as does the verification that
the geometric evaluation spaces have the presented form.  It also performs no finite orbit
enumeration: over a finite field, deleting the reference parameter and the unique coalescence
parameter leaves exactly `|K| - 2` parameters.
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

/-- At the reference parameter the outer radial constant is the reference constant itself. -/
@[simp] theorem outerRadialConstantAt_zero
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment) :
    outerRadialConstantAt data 0 = data.referenceOuterConstant := by
  simp [outerRadialConstantAt]

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

section RadialPresentation

variable {q : ℕ} {K Top FirstMoment SecondMoment : Type*} [Field K]

/-- The constant function with value `1` on both sheets. -/
def constantLevel : SheetPair q K := (⟨fun _ ↦ 1, fun _ ↦ 1⟩)

/-- The radial level at a parameter: it vanishes identically on the left sheet and is constantly
equal to the outer radial constant `c - 2t` on the right sheet.  This is the only generator of the
evaluation space that depends on the parameter. -/
def radialLevel (data : TwoSheetRadialData K Top FirstMoment SecondMoment) (t : K) :
    SheetPair q K :=
  (⟨fun _ ↦ 0, fun _ ↦ outerRadialConstantAt data t⟩)

/-- The left-sheet values of the radial level. -/
@[simp] theorem radialLevel_left
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment) (t : K) (i : Fin q) :
    (radialLevel (q := q) data t).1 i = 0 := rfl

/-- The right-sheet values of the radial level. -/
@[simp] theorem radialLevel_right
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment) (t : K) (i : Fin q) :
    (radialLevel (q := q) data t).2 i = outerRadialConstantAt data t := rfl

/-- The two-sheet evaluation space presented at a parameter of the radial line: the
parameter-independent top space, together with the constant function and the radial level.  The
geometric application supplies `topSpace` as the span of the evaluations of the unchanged top
configurations. -/
def radialEvaluationSpace
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment)
    (topSpace : Submodule K (SheetPair q K)) (t : K) : Submodule K (SheetPair q K) :=
  topSpace ⊔ (Submodule.span K {(constantLevel : SheetPair q K)} ⊔
    Submodule.span K {radialLevel (q := q) data t})

/-- The constant function lies in every presented evaluation space. -/
theorem constantLevel_mem_radialEvaluationSpace
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment)
    (topSpace : Submodule K (SheetPair q K)) (t : K) :
    (constantLevel : SheetPair q K) ∈ radialEvaluationSpace data topSpace t :=
  Submodule.mem_sup_right (Submodule.mem_sup_left (Submodule.mem_span_singleton_self _))

/-- The radial level at a parameter lies in the evaluation space presented at that parameter. -/
theorem radialLevel_mem_radialEvaluationSpace
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment)
    (topSpace : Submodule K (SheetPair q K)) (t : K) :
    radialLevel (q := q) data t ∈ radialEvaluationSpace data topSpace t :=
  Submodule.mem_sup_right (Submodule.mem_sup_right (Submodule.mem_span_singleton_self _))

/-- At a parameter with nonzero outer radial constant, the radial level of any other parameter is
a scalar multiple of the given one, so it lies on the same line. -/
theorem span_radialLevel_le
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment) {s : K} (t : K)
    (hs : outerRadialConstantAt data s ≠ 0) :
    Submodule.span K {radialLevel (q := q) data t} ≤
      Submodule.span K {radialLevel (q := q) data s} := by
  rw [Submodule.span_singleton_le_iff_mem, Submodule.mem_span_singleton]
  refine ⟨outerRadialConstantAt data t / outerRadialConstantAt data s, ?_⟩
  ext i <;> simp [radialLevel, div_mul_cancel₀ _ hs]

/-- Two parameters with nonzero outer radial constant span the same radial line. -/
theorem span_radialLevel_eq
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment) {s t : K}
    (hs : outerRadialConstantAt data s ≠ 0) (ht : outerRadialConstantAt data t ≠ 0) :
    Submodule.span K {radialLevel (q := q) data s} =
      Submodule.span K {radialLevel (q := q) data t} :=
  le_antisymm (span_radialLevel_le data s ht) (span_radialLevel_le data t hs)

/-- Radial translation between two noncoalescent parameters does not move the evaluation space.
The top space and the constant function are parameter-independent by construction, and the two
radial levels differ by the nonzero scalar `(c - 2t)/(c - 2s)`. -/
theorem radialEvaluationSpace_eq_of_noncoalescent
    (data : TwoSheetRadialData K Top FirstMoment SecondMoment)
    (topSpace : Submodule K (SheetPair q K)) {s t : K}
    (hs : outerRadialConstantAt data s ≠ 0) (ht : outerRadialConstantAt data t ≠ 0) :
    radialEvaluationSpace data topSpace s = radialEvaluationSpace data topSpace t := by
  rw [radialEvaluationSpace, radialEvaluationSpace, span_radialLevel_eq data hs ht]

end RadialPresentation

section RadicalHadamard

variable {q : ℕ} {K Top FirstMoment SecondMoment : Type*} [Field K]

/-- A radial family of two-sheet evaluation spaces, presented from parameter-independent data.
The three Radical--Hadamard hypotheses are imposed at the reference parameter `0` alone: that the
two sheet restrictions cover their zero-sum hyperplanes, that every coordinatewise product has
equal sheet sums, and that some product has nonzero sheet sum.  Nothing is assumed at any other
parameter; the theorems below derive the same hypotheses wherever the outer radial constant is
nonzero. -/
structure RadialEvaluationFamily (q : ℕ) (K Top FirstMoment SecondMoment : Type*) [Field K] where
  /-- The parameter-independent top configurations, moments, and reference outer constant. -/
  radialData : TwoSheetRadialData K Top FirstMoment SecondMoment
  /-- The parameter-independent span of the top-configuration evaluations. -/
  topSpace : Submodule K (SheetPair q K)
  /-- The reference outer radial constant is nonzero, so the reference parameter is itself
  noncoalescent. -/
  referenceOuterConstant_ne_zero : radialData.referenceOuterConstant ≠ 0
  /-- At the reference parameter the two sheet restrictions cover their zero-sum hyperplanes. -/
  restrictsOntoZeroSum_reference :
    RestrictsOntoZeroSum (radialEvaluationSpace (q := q) radialData topSpace 0)
  /-- At the reference parameter every coordinatewise product has equal sheet sums. -/
  productsHaveEqualSheetSums_reference :
    ProductsHaveEqualSheetSums (radialEvaluationSpace (q := q) radialData topSpace 0)
  /-- At the reference parameter some coordinatewise product has nonzero sheet sum. -/
  hasNonzeroSheetProduct_reference :
    HasNonzeroSheetProduct (radialEvaluationSpace (q := q) radialData topSpace 0)

namespace RadialEvaluationFamily

variable (family : RadialEvaluationFamily q K Top FirstMoment SecondMoment)

/-- The evaluation space of the family at a parameter of the radial line. -/
def evaluationSpace (t : K) : Submodule K (SheetPair q K) :=
  radialEvaluationSpace family.radialData family.topSpace t

/-- The reference parameter is noncoalescent. -/
theorem reference_noncoalescent : outerRadialConstantAt family.radialData 0 ≠ 0 := by
  simpa using family.referenceOuterConstant_ne_zero

/-- Every noncoalescent parameter has the same evaluation space as the reference parameter. -/
theorem evaluationSpace_eq_reference {t : K}
    (hnoncoalescent : outerRadialConstantAt family.radialData t ≠ 0) :
    family.evaluationSpace t = family.evaluationSpace 0 :=
  radialEvaluationSpace_eq_of_noncoalescent family.radialData family.topSpace
    hnoncoalescent family.reference_noncoalescent

/-- Surjectivity of the two sheet restrictions is inherited at every noncoalescent parameter. -/
theorem restrictsOntoZeroSum_of_noncoalescent {t : K}
    (hnoncoalescent : outerRadialConstantAt family.radialData t ≠ 0) :
    RestrictsOntoZeroSum (family.evaluationSpace t) := by
  rw [family.evaluationSpace_eq_reference hnoncoalescent]
  exact family.restrictsOntoZeroSum_reference

/-- Equality of the two sheet sums on coordinatewise products is inherited at every noncoalescent
parameter. -/
theorem productsHaveEqualSheetSums_of_noncoalescent {t : K}
    (hnoncoalescent : outerRadialConstantAt family.radialData t ≠ 0) :
    ProductsHaveEqualSheetSums (family.evaluationSpace t) := by
  rw [family.evaluationSpace_eq_reference hnoncoalescent]
  exact family.productsHaveEqualSheetSums_reference

/-- Existence of one product with nonzero sheet sum is inherited at every noncoalescent
parameter. -/
theorem hasNonzeroSheetProduct_of_noncoalescent {t : K}
    (hnoncoalescent : outerRadialConstantAt family.radialData t ≠ 0) :
    HasNonzeroSheetProduct (family.evaluationSpace t) := by
  rw [family.evaluationSpace_eq_reference hnoncoalescent]
  exact family.hasNonzeroSheetProduct_reference

end RadialEvaluationFamily

/-- At a noncoalescent parameter, the radial level and the constant function recover both sheet
indicators. -/
theorem indicators_mem_of_outerRadialConstant_ne_zero
    (family : RadialEvaluationFamily q K Top FirstMoment SecondMoment) (t : K)
    (hnoncoalescent : outerRadialConstantAt family.radialData t ≠ 0) :
    leftIndicator ∈ family.evaluationSpace t ∧
      rightIndicator ∈ family.evaluationSpace t := by
  exact indicators_mem_of_separating_level (family.evaluationSpace t)
    (constantLevel_mem_radialEvaluationSpace family.radialData family.topSpace t)
    (radialLevel_mem_radialEvaluationSpace family.radialData family.topSpace t)
    (a := 0) (b := outerRadialConstantAt family.radialData t)
    hnoncoalescent.symm (fun i ↦ radialLevel_left family.radialData t i)
    (fun i ↦ radialLevel_right family.radialData t i)

/-- Every noncoalescent member of a radial family inherits the Radical--Hadamard conclusion: its
coordinatewise-product square is the equal-sheet-sum hyperplane.  The three Radical--Hadamard
hypotheses are not assumed at `t`; they are transported from the reference parameter along the
equality of evaluation spaces. -/
theorem hadamardSquare_eq_equalSheetSum_of_noncoalescent
    (family : RadialEvaluationFamily q K Top FirstMoment SecondMoment) (t : K)
    (hnoncoalescent : outerRadialConstantAt family.radialData t ≠ 0) :
    hadamardSquare (family.evaluationSpace t) = equalSheetSum := by
  obtain ⟨hleft, hright⟩ :=
    indicators_mem_of_outerRadialConstant_ne_zero family t hnoncoalescent
  exact hadamardSquare_eq_equalSheetSum (family.evaluationSpace t) hleft hright
    (family.restrictsOntoZeroSum_of_noncoalescent hnoncoalescent)
    (family.productsHaveEqualSheetSums_of_noncoalescent hnoncoalescent)
    (family.hasNonzeroSheetProduct_of_noncoalescent hnoncoalescent)

/-- On a nonempty pair of sheets, every noncoalescent member has precisely the sheet-sign
annihilator line.  This is the unique quadratic-trade conclusion of Radical--Hadamard recovery. -/
theorem annihilates_hadamardSquare_iff_eq_sheetSignLine_of_noncoalescent
    (family : RadialEvaluationFamily q K Top FirstMoment SecondMoment) (i₀ : Fin q)
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

/-- Membership in the displayed parameter set is exactly the conjunction of being different from
the matching parameter `0` and having nonzero outer radial constant. -/
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
coalescence values have exactly the sheet-sign quadratic-trade line.  Only the reference parameter
carries Radical--Hadamard hypotheses; every other parameter inherits them. -/
theorem nonmatchingNoncoalescentParameters_tradeLine_and_card
    {q : ℕ}
    (family : RadialEvaluationFamily q K Top FirstMoment SecondMoment)
    (i₀ : Fin q) (two_ne_zero : (2 : K) ≠ 0) :
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
  · exact card_nonmatchingNoncoalescentParameters family.radialData
      family.referenceOuterConstant_ne_zero two_ne_zero

end FiniteCount

end ClebschFixedLineRadialTranslation
end RelativeConicArcs
