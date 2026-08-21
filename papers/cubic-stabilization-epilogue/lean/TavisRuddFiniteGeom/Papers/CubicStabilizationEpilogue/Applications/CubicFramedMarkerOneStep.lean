import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FramedSixthMarker

/-!
# One-projective-line obstruction from the framed sixth-root marker

This module assembles the refined framed proof for one stabilization.  The
cubic value, projective-line formula, comparison value, and rationality
comparison remain explicit premises.  The conditional QDM operation and
center-nullity hypotheses occur only inside the framed marker context.
Birational invariance is deduced from the same occurrence-indexed theorem used
by the unframed residue-marker proof.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Applications

universe u v w

/-- Endpoint and comparison data for the framed primitive-sixth obstruction to
rationality after multiplication by one projective line. -/
structure CubicFramedMarkerOneStepInput
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    (context : Quantum.FramedSixthMarkerContext 4 Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    (projectiveFourSpace : Variety) (Rational : Variety → Prop)
    (cubic : Variety) : Prop where
  cubicDimension : context.data.dimension cubic = 3
  cubicMarker : context.marker cubic = 2
  projectiveLineFormula :
    Quantum.ProjectiveBundleMarkerFormula context.data context.presentation.fold
      cubic (productWithProjectiveLine cubic) 2
  projectiveFourSpaceSmooth : context.data.smoothProjective projectiveFourSpace
  projectiveFourSpaceDimension : context.data.dimension projectiveFourSpace = 4
  projectiveFourSpaceMarker : context.marker projectiveFourSpace = 0
  rationalComparison : ∀ {variety}, context.data.smoothProjective variety →
    context.data.dimension variety = 4 → Rational variety →
      context.birational.r variety projectiveFourSpace

/-- The three clauses of the manuscript's conditional framed theorem. -/
structure CubicFramedMarkerOneStepConclusion
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    (context : Quantum.FramedSixthMarkerContext 4 Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    (Rational : Variety → Prop) (cubic : Variety) : Prop where
  stabilizedMarker : context.marker (productWithProjectiveLine cubic) = 4
  rationalFourfoldMarkerZero : ∀ variety,
    context.data.smoothProjective variety →
      context.data.dimension variety = 4 → Rational variety →
        context.marker variety = 0
  stabilizationIrrational : ¬ Rational (productWithProjectiveLine cubic)

/-- Birationality after one projective-line stabilization forces equality of
the framed primitive-sixth markers of two smooth projective threefolds. -/
theorem framedSixthMarker_eq_of_oneProjectiveLine_birational
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    (context : Quantum.FramedSixthMarkerContext 4 Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    {left right : Variety}
    (leftDimension : context.data.dimension left = 3)
    (rightDimension : context.data.dimension right = 3)
    (leftFormula : Quantum.ProjectiveBundleMarkerFormula
      context.data context.presentation.fold left
        (productWithProjectiveLine left) 2)
    (rightFormula : Quantum.ProjectiveBundleMarkerFormula
      context.data context.presentation.fold right
        (productWithProjectiveLine right) 2)
    (related : context.birational.r
      (productWithProjectiveLine left) (productWithProjectiveLine right)) :
    context.marker left = context.marker right := by
  have leftTotalDimension :
      context.data.dimension (productWithProjectiveLine left) = 4 := by
    rw [leftFormula.dimensionFormula, leftDimension]
  have rightTotalDimension :
      context.data.dimension (productWithProjectiveLine right) = 4 := by
    rw [rightFormula.dimensionFormula, rightDimension]
  have totalEquality := context.marker_eq_of_birational
    leftFormula.totalSmooth rightFormula.totalSmooth leftTotalDimension
      rightTotalDimension related
  change context.data.varietyMarker context.presentation.fold left =
    context.data.varietyMarker context.presentation.fold right
  change context.data.varietyMarker context.presentation.fold
      (productWithProjectiveLine left) =
    context.data.varietyMarker context.presentation.fold
      (productWithProjectiveLine right) at totalEquality
  rw [leftFormula.markerFormula, rightFormula.markerFormula] at totalEquality
  simp only [two_nsmul] at totalEquality
  omega

/-- A smooth cubic threefold remains irrational after multiplication by one
projective line under the stated framed primitive-sixth inputs. -/
theorem cubicThreefold_oneProjectiveLine_not_rational_of_framedMarker
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    (context : Quantum.FramedSixthMarkerContext 4 Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    (projectiveFourSpace : Variety) (Rational : Variety → Prop)
    (cubic : Variety)
    (input : CubicFramedMarkerOneStepInput context productWithProjectiveLine
      projectiveFourSpace Rational cubic) :
    ¬ Rational (productWithProjectiveLine cubic) := by
  intro rational
  have stabilizedDimension :
      context.data.dimension (productWithProjectiveLine cubic) = 4 := by
    rw [input.projectiveLineFormula.dimensionFormula, input.cubicDimension]
  have markerEquality := context.marker_eq_of_birational
    input.projectiveLineFormula.totalSmooth input.projectiveFourSpaceSmooth
    stabilizedDimension input.projectiveFourSpaceDimension
    (input.rationalComparison input.projectiveLineFormula.totalSmooth
      stabilizedDimension rational)
  have stabilizedNonzero : context.marker (productWithProjectiveLine cubic) ≠ 0 := by
    have cubicMarker := input.cubicMarker
    change context.data.varietyMarker context.presentation.fold cubic = 2 at cubicMarker
    change context.data.varietyMarker context.presentation.fold
      (productWithProjectiveLine cubic) ≠ 0
    rw [input.projectiveLineFormula.markerFormula, cubicMarker]
    norm_num
  apply stabilizedNonzero
  exact markerEquality.trans input.projectiveFourSpaceMarker

/-- Exact three-clause conditional framed conclusion.  In particular, the
marker-four calculation and the vanishing on every rational smooth projective
fourfold are public conclusions rather than unrecorded intermediate steps. -/
theorem cubicThreefold_oneProjectiveLine_conclusion_of_framedMarker
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    (context : Quantum.FramedSixthMarkerContext 4 Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    (projectiveFourSpace : Variety) (Rational : Variety → Prop)
    (cubic : Variety)
    (input : CubicFramedMarkerOneStepInput context productWithProjectiveLine
      projectiveFourSpace Rational cubic) :
    CubicFramedMarkerOneStepConclusion context productWithProjectiveLine
      Rational cubic := by
  refine
    { stabilizedMarker := ?_
      rationalFourfoldMarkerZero := ?_
      stabilizationIrrational :=
        cubicThreefold_oneProjectiveLine_not_rational_of_framedMarker context
          productWithProjectiveLine projectiveFourSpace Rational cubic input }
  · change context.data.varietyMarker context.presentation.fold
      (productWithProjectiveLine cubic) = 4
    rw [input.projectiveLineFormula.markerFormula]
    have cubicMarker := input.cubicMarker
    change context.data.varietyMarker context.presentation.fold cubic = 2 at cubicMarker
    rw [cubicMarker]
    norm_num
  · intro variety smooth dimension rational
    exact (context.marker_eq_of_birational smooth input.projectiveFourSpaceSmooth
      dimension input.projectiveFourSpaceDimension
      (input.rationalComparison smooth dimension rational)).trans
        input.projectiveFourSpaceMarker

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
