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
  rationalComparison : Rational (productWithProjectiveLine cubic) →
    context.birational.r (productWithProjectiveLine cubic) projectiveFourSpace

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
    (input.rationalComparison rational)
  have stabilizedNonzero : context.marker (productWithProjectiveLine cubic) ≠ 0 := by
    have cubicMarker := input.cubicMarker
    change context.data.varietyMarker context.presentation.fold cubic = 2 at cubicMarker
    change context.data.varietyMarker context.presentation.fold
      (productWithProjectiveLine cubic) ≠ 0
    rw [input.projectiveLineFormula.markerFormula, cubicMarker]
    norm_num
  apply stabilizedNonzero
  exact markerEquality.trans input.projectiveFourSpaceMarker

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
