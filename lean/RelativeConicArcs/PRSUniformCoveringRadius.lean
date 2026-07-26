import RelativeConicArcs.PRSFoundation

/-!
# Uniform projective Reed--Solomon covering-radius bridge

For redundancy `r`, the uniform transverse argument uses the field threshold

`6r - 15 + floor (2 * sqrt (6r - 17))`.

The definition below writes the floor term as the natural-number square root of
`4 * (6r - 17)`.  The kernel-checked arithmetic shows that, for `r ≥ 6`, this
threshold lies inside the high-rate range `r ≤ floor(q / 2) + 2`.

The coding-theoretic passage is deliberately separated into two propositions.
The first implication represents Theorem 1 of Seroussi and Roth, *On MDS extensions of
generalized Reed--Solomon codes* (1986), DOI `10.1109/TIT.1986.1057188`: in the stated
high-rate range, the relevant dual generalized Reed--Solomon code is not extendable.
The second represents Dür, *On the covering radius of Reed--Solomon codes* (1994),
DOI `10.1016/0012-365X(94)90256-9`: the corresponding nonextendability/completeness
statement gives covering radius `r - 1`.

Lean checks the threshold arithmetic and the composition of these implications.  It does not
formalize either cited coding theorem or the identification of the abstract propositions with a
concrete projective Reed--Solomon code.
-/

namespace RelativeConicArcs.PRSUniformCoveringRadius

/-- The dimension range in the Seroussi--Roth nonextendability theorem, including its
even-field dimension-three exception. -/
def SeroussiRothDimensionRange (q r : ℕ) : Prop :=
  2 ≤ r ∧ r ≤ q / 2 + 2 ∧ ¬(Even q ∧ r = 3)

/-- The integer threshold
`6r - 15 + floor (2 * sqrt (6r - 17))`, expressed using natural-number square root. -/
def uniformTransverseThreshold (r : ℕ) : ℕ :=
  6 * r - 15 + Nat.sqrt (4 * (6 * r - 17))

/-- For redundancy at least six, the uniform transverse threshold dominates `2r - 3`. -/
theorem two_mul_sub_three_le_uniformTransverseThreshold
    {r : ℕ} (hr : 6 ≤ r) :
    2 * r - 3 ≤ uniformTransverseThreshold r := by
  unfold uniformTransverseThreshold
  omega

/-- Redundancy at least six and the exact endpoint inequality imply the complete
Seroussi--Roth dimension range. -/
theorem seroussiRothDimensionRange_of_six_le_of_twice_le
    {q r : ℕ} (hr : 6 ≤ r) (hq : 2 * r ≤ q + 4) :
    SeroussiRothDimensionRange q r := by
  unfold SeroussiRothDimensionRange
  omega

/-- Above the uniform transverse threshold, the parameters lie in the complete
Seroussi--Roth dimension range. -/
theorem seroussiRothDimensionRange_of_uniformTransverseThreshold
    {q r : ℕ} (hr : 6 ≤ r) (hq : uniformTransverseThreshold r ≤ q) :
    SeroussiRothDimensionRange q r := by
  apply seroussiRothDimensionRange_of_six_le_of_twice_le hr
  have hlinear := two_mul_sub_three_le_uniformTransverseThreshold hr
  omega

/-- External coding propositions used to turn the Seroussi--Roth range into the
covering-radius condition in `PRSFoundation.CoveringRadiusInput`.

The fields expose five semantic inputs: the field order, identification of the code dual as the
relevant generalized Reed--Solomon code, Seroussi--Roth nonextendability, Dür's equivalence
between nonextendability/completeness and the covering-radius equality, and identification of
that equality with the syndrome interface's radius proposition. -/
structure SeroussiRothDuerRadiusInput
    (K Syndrome : Type*) [Field K] [Fintype K] (q r : ℕ) where
  /-- The abstract syndrome interface whose radius-range proposition is to be discharged. -/
  radius : PRSFoundation.CoveringRadiusInput Syndrome
  /-- The natural number `q` is the cardinality of the concrete base field. -/
  fieldOrder_eq_card : q = Fintype.card K
  /-- The dual of the concrete projective Reed--Solomon code is the length-`q + 1`,
  dimension-`r` generalized Reed--Solomon code to which Seroussi--Roth applies. -/
  prsDualIsLengthQPlusOneDimensionRGRS : Prop
  /-- The relevant dual generalized Reed--Solomon code has no one-coordinate MDS extension. -/
  prsDualHasNoOneCoordinateMDSExtension : Prop
  /-- The intended proposition is that the length-`q + 1`, redundancy-`r` projective
  Reed--Solomon code has covering radius `r - 1`. -/
  prsCoveringRadiusEqRedundancyMinusOne : Prop
  /-- The externally supplied Seroussi--Roth implication. -/
  seroussiRoth_nonextendable :
    SeroussiRothDimensionRange q r →
    prsDualIsLengthQPlusOneDimensionRGRS →
    prsDualHasNoOneCoordinateMDSExtension
  /-- The externally supplied Dür equivalence between completeness/nonextendability and the
  covering-radius equality. -/
  duer_nonextendable_iff_coveringRadiusEq :
    prsDualHasNoOneCoordinateMDSExtension ↔
    prsCoveringRadiusEqRedundancyMinusOne
  /-- Identification of the syndrome interface's radius hypothesis with the concrete
  covering-radius equality. -/
  radiusRange_iff_coveringRadiusEq :
    radius.radiusRange ↔ prsCoveringRadiusEqRedundancyMinusOne

namespace SeroussiRothDuerRadiusInput

/-- The external Seroussi--Roth and Dür inputs discharge the abstract radius-range proposition. -/
theorem radiusRange_of_externalSeroussiRothDuer
    {K Syndrome : Type*} [Field K] [Fintype K] {q r : ℕ}
    (input : SeroussiRothDuerRadiusInput K Syndrome q r)
    (hrange : SeroussiRothDimensionRange q r)
    (hdual : input.prsDualIsLengthQPlusOneDimensionRGRS) :
    input.radius.radiusRange :=
  input.radiusRange_iff_coveringRadiusEq.mpr
    (input.duer_nonextendable_iff_coveringRadiusEq.mp
      (input.seroussiRoth_nonextendable hrange hdual))

/-- At redundancy six and field order eight, the parameters already lie in the exact
Seroussi--Roth high-rate range. -/
theorem seroussiRothDimensionRange_six_eight :
    SeroussiRothDimensionRange 8 6 := by
  norm_num [SeroussiRothDimensionRange, Even]

/-- The external coding inputs promote the redundancy-six, field-eight case without using the
larger uniform transverse threshold. -/
theorem radiusRange_six_eight_of_externalSeroussiRothDuer
    {K Syndrome : Type*} [Field K] [Fintype K]
    (input : SeroussiRothDuerRadiusInput K Syndrome 8 6)
    (hdual : input.prsDualIsLengthQPlusOneDimensionRGRS) :
    input.radius.radiusRange :=
  input.radiusRange_of_externalSeroussiRothDuer
    seroussiRothDimensionRange_six_eight hdual

end SeroussiRothDuerRadiusInput

/-- The external coding inputs and the kernel-checked threshold arithmetic make deepness and
split-freeness coincide throughout the uniform transverse range. -/
theorem deep_iff_splitFree_of_externalSeroussiRothDuer_uniformTransverseThreshold
    {K Syndrome : Type*} [Field K] [Fintype K] {q r : ℕ}
    (input : SeroussiRothDuerRadiusInput K Syndrome q r)
    (hdual : input.prsDualIsLengthQPlusOneDimensionRGRS)
    (hr : 6 ≤ r) (hq : uniformTransverseThreshold r ≤ q) (syndrome : Syndrome) :
    input.radius.isDeep syndrome ↔ input.radius.isSplitFree syndrome :=
  input.radius.deep_iff_splitFree
    (input.radiusRange_of_externalSeroussiRothDuer
      (seroussiRothDimensionRange_of_uniformTransverseThreshold hr hq) hdual)
    syndrome

end RelativeConicArcs.PRSUniformCoveringRadius
