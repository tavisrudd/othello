import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RankTwoResidueMarker

/-!
# One-projective-line obstruction from the residue marker

This module assembles the direct residue-marker proof for one stabilization.
The cubic marker value, the rank-two projective-bundle formula, the vanishing
comparison value, and the birational comparison supplied by rationality remain
explicit premises.  Birational invariance is not an additional premise: it is
deduced from the shared occurrence-indexed marker theorem through the supplied
rank-two residue context.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Applications

universe u v w x

/-- Endpoint and comparison data for the direct residue-marker obstruction to
rationality after multiplication by one projective line. -/
structure CubicResidueMarkerOneStepInput
    {K : Type x} [CommRing K]
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    (projectiveFourSpace : Variety) (Rational : Variety → Prop)
    (cubic : Variety) : Prop where
  cubicDimension : context.data.dimension cubic = 3
  cubicMarker : context.marker cubic = 1
  projectiveLineFormula :
    Quantum.ProjectiveBundleMarkerFormula context.data context.presentation.fold
      cubic (productWithProjectiveLine cubic) 2
  projectiveFourSpaceSmooth : context.data.smoothProjective projectiveFourSpace
  projectiveFourSpaceDimension : context.data.dimension projectiveFourSpace = 4
  projectiveFourSpaceMarker : context.marker projectiveFourSpace = 0
  rationalComparison : Rational (productWithProjectiveLine cubic) →
    context.birational.r (productWithProjectiveLine cubic) projectiveFourSpace

/-- Both conclusions used in the direct one-step proof: the stabilized marker
is exactly two, and the stabilization is irrational. -/
structure CubicResidueMarkerOneStepConclusion
    {K : Type x} [CommRing K]
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    (Rational : Variety → Prop) (cubic : Variety) : Prop where
  stabilizedMarker : context.marker (productWithProjectiveLine cubic) = 2
  stabilizationIrrational : ¬ Rational (productWithProjectiveLine cubic)

/-- A smooth cubic threefold remains irrational after multiplication by one
projective line under the stated direct-QDM residue-marker inputs. -/
theorem cubicThreefold_oneProjectiveLine_not_rational_of_residueMarker
    {K : Type x} [CommRing K]
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    (projectiveFourSpace : Variety) (Rational : Variety → Prop)
    (cubic : Variety)
    (input : CubicResidueMarkerOneStepInput context productWithProjectiveLine
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
    change context.data.varietyMarker context.presentation.fold cubic = 1 at cubicMarker
    change context.data.varietyMarker context.presentation.fold
      (productWithProjectiveLine cubic) ≠ 0
    rw [input.projectiveLineFormula.markerFormula, cubicMarker]
    norm_num
  apply stabilizedNonzero
  exact markerEquality.trans input.projectiveFourSpaceMarker

/-- Exact direct-QDM one-step conclusion, with the nonzero marker value exposed
rather than left only as an intermediate fact in the irrationality proof. -/
theorem cubicThreefold_oneProjectiveLine_conclusion_of_residueMarker
    {K : Type x} [CommRing K]
    {Variety : Type u} {Center : Type v} {Occurrence : Type w}
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    (projectiveFourSpace : Variety) (Rational : Variety → Prop)
    (cubic : Variety)
    (input : CubicResidueMarkerOneStepInput context productWithProjectiveLine
      projectiveFourSpace Rational cubic) :
    CubicResidueMarkerOneStepConclusion context productWithProjectiveLine
      Rational cubic := by
  refine
    { stabilizedMarker := ?_
      stabilizationIrrational :=
        cubicThreefold_oneProjectiveLine_not_rational_of_residueMarker context
          productWithProjectiveLine projectiveFourSpace Rational cubic input }
  change context.data.varietyMarker context.presentation.fold
    (productWithProjectiveLine cubic) = 2
  rw [input.projectiveLineFormula.markerFormula]
  have cubicMarker := input.cubicMarker
  change context.data.varietyMarker context.presentation.fold cubic = 1 at cubicMarker
  rw [cubicMarker]
  norm_num

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
