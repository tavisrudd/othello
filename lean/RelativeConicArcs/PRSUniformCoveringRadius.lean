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

/-- Uniform degree budget for every unavailable-parameter scheme in the iterated polar flag. -/
def uniformParameterBudget (r : ℕ) : ℕ :=
  3 * r - 5

/-- Degree budget obtained at an intermediate redundancy `j`. -/
def intermediateParameterBudget (r j : ℕ) : ℕ :=
  3 + 1 + (2 * j - 6) + 3 * (r - j)

/-- Parameter budget for the factor-preserving exact-linear-gcd flag. -/
def exactLinearFlagParameterBudget (r j : ℕ) : ℕ :=
  3 + 1 + (r - j)

/-- Total deletion degree on the final genus-one ordered-root curve. -/
def bottomCurveDeletionBudget (r : ℕ) : ℕ :=
  13 + 6 * (r - 5)

/-- Total deletion degree on the exact-linear-gcd quadratic deck graph. -/
def exactLinearGraphDeletionBudget (r : ℕ) : ℕ :=
  8 + 2 * (r - 5)

/-- The bottom-curve deletion formula simplifies to `6r - 17` for redundancy at least six. -/
theorem bottomCurveDeletionBudget_eq
    {r : ℕ} (hr : 6 ≤ r) :
    bottomCurveDeletionBudget r = 6 * r - 17 := by
  unfold bottomCurveDeletionBudget
  omega

/-- The exact-linear-gcd graph deletion formula simplifies to `2r - 2`. -/
theorem exactLinearGraphDeletionBudget_eq
    {r : ℕ} (hr : 6 ≤ r) :
    exactLinearGraphDeletionBudget r = 2 * r - 2 := by
  unfold exactLinearGraphDeletionBudget
  omega

/-- Every intermediate parameter budget is strictly smaller than the bottom-stage budget. -/
theorem intermediateParameterBudget_lt_uniformParameterBudget
    {r j : ℕ} (hj : 7 ≤ j) (hjr : j ≤ r) :
    intermediateParameterBudget r j < uniformParameterBudget r := by
  unfold intermediateParameterBudget uniformParameterBudget
  omega

/-- The factor-preserving exact-linear-gcd flag has a smaller parameter budget than the
uniform trivial-gcd iteration. -/
theorem exactLinearFlagParameterBudget_lt_uniformParameterBudget
    {r j : ℕ} (hr : 6 ≤ r) (hj : 6 ≤ j) (hjr : j ≤ r) :
    exactLinearFlagParameterBudget r j < uniformParameterBudget r := by
  unfold exactLinearFlagParameterBudget uniformParameterBudget
  omega

/-- The uniform field threshold leaves more rational marker parameters than the largest
stagewise unavailable-parameter degree. -/
theorem uniformParameterBudget_lt_fieldOrder_add_one
    {q r : ℕ} (hr : 6 ≤ r) (hq : uniformTransverseThreshold r ≤ q) :
    uniformParameterBudget r < q + 1 := by
  have hbudget :
      3 * r - 5 < uniformTransverseThreshold r := by
    unfold uniformTransverseThreshold
    omega
  unfold uniformParameterBudget
  omega

/-- The uniform threshold leaves a rational point on the exact-linear-gcd graph after every
retained-marker deletion. -/
theorem exactLinearGraphDeletionBudget_lt_fieldOrder_add_one
    {q r : ℕ} (hr : 6 ≤ r) (hq : uniformTransverseThreshold r ≤ q) :
    exactLinearGraphDeletionBudget r < q + 1 := by
  have hbudget :
      2 * r - 2 < uniformTransverseThreshold r := by
    unfold uniformTransverseThreshold
    omega
  rw [exactLinearGraphDeletionBudget_eq hr]
  omega

/-- Geometric inputs for instantiating the lower package at every stage of a uniform polar
iteration.  Properness, geometric integrality, and the degree comparisons remain explicit
hypotheses; Lean checks their simultaneous use and the threshold arithmetic. -/
structure UniformIteratedPackageInput (q r : ℕ) where
  /-- Degree of the unavailable-parameter scheme at stage `j`. -/
  parameterSchemeDegree : ℕ → ℕ
  /-- The unavailable-parameter scheme at stage `j` is a proper closed subscheme of the
  projective marker line. -/
  parameterSchemeProper : ℕ → Prop
  /-- Properness holds at every stage used by the iteration. -/
  parameterSchemeProper_of_mem :
    ∀ {j}, 6 ≤ j → j ≤ r → parameterSchemeProper j
  /-- Every stagewise scheme has degree at most the uniform bottom-stage budget. -/
  parameterSchemeDegree_le :
    ∀ {j}, 6 ≤ j → j ≤ r →
      parameterSchemeDegree j ≤ uniformParameterBudget r
  /-- Degree of the parameter scheme on the factor-preserving exact-linear-gcd branch. -/
  exactLinearFlagParameterSchemeDegree : ℕ → ℕ
  /-- Properness proposition for the exact-linear-gcd flag at stage `j`. -/
  exactLinearFlagParameterSchemeProper : ℕ → Prop
  /-- The exact-linear-gcd flag parameter scheme is proper at every stage used. -/
  exactLinearFlagParameterSchemeProper_of_mem :
    ∀ {j}, 6 ≤ j → j ≤ r → exactLinearFlagParameterSchemeProper j
  /-- Its terminal-carrier, fixed-factor, and old-marker degree has the displayed bound. -/
  exactLinearFlagParameterSchemeDegree_le :
    ∀ {j}, 6 ≤ j → j ≤ r →
      exactLinearFlagParameterSchemeDegree j ≤ exactLinearFlagParameterBudget r j
  /-- Proposition asserting that the final ordered-root curve is proper. -/
  bottomCurveIsProper : Prop
  /-- Proof that the final ordered-root curve is proper. -/
  bottomCurveProper : bottomCurveIsProper
  /-- Proposition asserting that the final ordered-root curve is geometrically integral. -/
  bottomCurveIsGeometricallyIntegral : Prop
  /-- Proof that the final ordered-root curve is geometrically integral. -/
  bottomCurveGeometricallyIntegral : bottomCurveIsGeometricallyIntegral
  /-- Degree of its singular, branch, diagonal, collision, and marker deletion scheme. -/
  bottomCurveDeletionDegree : ℕ
  /-- The deletion scheme obeys the uniform retained-marker bound. -/
  bottomCurveDeletionDegree_le :
    bottomCurveDeletionDegree ≤ bottomCurveDeletionBudget r
  /-- Proposition asserting that the exact-linear-gcd quadratic deck graph is proper. -/
  exactLinearGraphIsProper : Prop
  /-- Proof that the exact-linear-gcd graph is proper. -/
  exactLinearGraphProper : exactLinearGraphIsProper
  /-- Proposition asserting that the exact-linear-gcd graph is geometrically integral. -/
  exactLinearGraphIsGeometricallyIntegral : Prop
  /-- Proof that the exact-linear-gcd graph is geometrically integral. -/
  exactLinearGraphGeometricallyIntegral : exactLinearGraphIsGeometricallyIntegral
  /-- Number of rational points on the exact-linear-gcd graph. -/
  exactLinearGraphRationalPointCardinality : ℕ
  /-- The rational deck graph has one point over every rational base point. -/
  exactLinearGraphRationalPointCardinality_eq :
    exactLinearGraphRationalPointCardinality = q + 1
  /-- Degree of its fixed-point, branch, gcd-root, and retained-marker deletion scheme. -/
  exactLinearGraphDeletionDegree : ℕ
  /-- The graph deletion scheme obeys the uniform retained-marker bound. -/
  exactLinearGraphDeletionDegree_le :
    exactLinearGraphDeletionDegree ≤ exactLinearGraphDeletionBudget r

namespace UniformIteratedPackageInput

/-- Above the uniform threshold, every supplied stage is proper and has fewer unavailable
parameters than the `q+1` rational points of the projective marker line; the bottom curve and
deletion data are retained in the same conclusion. -/
theorem packages_fit_uniform_threshold
    {q r : ℕ} (input : UniformIteratedPackageInput q r)
    (hr : 6 ≤ r) (hq : uniformTransverseThreshold r ≤ q) :
    (∀ {j}, 6 ≤ j → j ≤ r →
      input.parameterSchemeProper j ∧ input.parameterSchemeDegree j < q + 1) ∧
    (∀ {j}, 6 ≤ j → j ≤ r →
      input.exactLinearFlagParameterSchemeProper j ∧
        input.exactLinearFlagParameterSchemeDegree j < q + 1) ∧
      input.bottomCurveIsProper ∧ input.bottomCurveIsGeometricallyIntegral ∧
        input.bottomCurveDeletionDegree ≤ bottomCurveDeletionBudget r ∧
      input.exactLinearGraphIsProper ∧
        input.exactLinearGraphIsGeometricallyIntegral ∧
          input.exactLinearGraphDeletionDegree <
            input.exactLinearGraphRationalPointCardinality := by
  refine ⟨?_, ?_, input.bottomCurveProper, input.bottomCurveGeometricallyIntegral,
    input.bottomCurveDeletionDegree_le, input.exactLinearGraphProper,
    input.exactLinearGraphGeometricallyIntegral, ?_⟩
  · intro j hj hjr
    exact ⟨input.parameterSchemeProper_of_mem hj hjr,
      lt_of_le_of_lt (input.parameterSchemeDegree_le hj hjr)
        (uniformParameterBudget_lt_fieldOrder_add_one hr hq)⟩
  · intro j hj hjr
    refine ⟨input.exactLinearFlagParameterSchemeProper_of_mem hj hjr, ?_⟩
    exact lt_of_le_of_lt
      (input.exactLinearFlagParameterSchemeDegree_le hj hjr)
      (lt_trans
        (exactLinearFlagParameterBudget_lt_uniformParameterBudget hr hj hjr)
        (uniformParameterBudget_lt_fieldOrder_add_one hr hq))
  · rw [input.exactLinearGraphRationalPointCardinality_eq]
    exact lt_of_le_of_lt input.exactLinearGraphDeletionDegree_le
      (exactLinearGraphDeletionBudget_lt_fieldOrder_add_one hr hq)

end UniformIteratedPackageInput

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
