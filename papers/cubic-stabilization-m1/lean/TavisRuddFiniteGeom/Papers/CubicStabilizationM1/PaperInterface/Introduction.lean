import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.CubicFramedMarkerOneStep
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.CubicResidueMarkerOneStep
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.CubicThreefold
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.ProjectiveProductMultiplicity
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.RelativeSixAxis
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.SeparatedVariableCubicForms
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.SeparationFamily
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.UniversalCH0
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.UniversalCH0Separation
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixAxisPrimaryDiscriminantSplitting
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.AssociatedGradedTagging
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FilteredCoefficientQuotients
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FramedSixthMarker
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.HirzebruchEulerSpectrum
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RankTwoResidueMarker

/-!
# Introduction-facing reviewer terminals

Headline and family-level consequences.  Geometric and literature inputs
remain explicit in the declaration types.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

open TensorProduct

open scoped MatrixGroups

/-- Exact conditional assembly of the manuscript's separation theorem for one
typed family.  Primitive-minimal-class algebraicity and Voisin's criterion
give fibrewise universal `CH₀`-triviality; a supplied projective-bundle formula
transports it to the stabilization; the direct residue-marker input gives
irrationality; and nonconstancy of a typed period map gives non-isotriviality
through the supplied comparison implication.  Every
geometric, Chow-theoretic, quantum, and moduli premise remains visible. -/
theorem separationFamily_of_sixAxis_residue_and_period_inputs
    {K Base Variety Center Occurrence Jacobian Moduli Period : Type*}
    [CommRing K]
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (projectiveFourSpace : Variety)
    (cycleGeometry : Applications.CubicCycleTrivialityGeometry
      Variety Jacobian)
    (rationalGeometry : Applications.CubicThreefoldGeometry Variety)
    (isNonIsotrivial : (Base → Variety) → Prop)
    (fibre : Base → Variety) (moduliPoint : Base → Moduli)
    (hasEckardtPoint separatedVariableType : Variety → Prop)
    (projectivelyEquivalent : Variety → Variety → Prop)
    (distinguishedPoint : Moduli)
    (input : Applications.SeparationFamilyInput (Period := Period)
      context projectiveFourSpace
      cycleGeometry rationalGeometry isNonIsotrivial fibre moduliPoint
      hasEckardtPoint separatedVariableType projectivelyEquivalent
      distinguishedPoint) :
    Applications.SeparationFamilyConclusion cycleGeometry rationalGeometry
      isNonIsotrivial fibre moduliPoint separatedVariableType
      projectivelyEquivalent distinguishedPoint :=
  Applications.separationFamily_of_cycle_residue_and_period_inputs context
    projectiveFourSpace cycleGeometry rationalGeometry isNonIsotrivial fibre
    moduliPoint hasEckardtPoint separatedVariableType projectivelyEquivalent
    distinguishedPoint input
/-- Reviewer-facing dimension-four birational invariance of the direct
rank-two residue marker.  It is a specialization of the generic
occurrence-indexed theorem, not a separate packet telescope. -/
theorem rankTwoResidueMarker_eq_of_birational
    {K Variety Center Occurrence : Type*} [CommRing K]
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    {left right : Variety}
    (leftSmooth : context.data.smoothProjective left)
    (rightSmooth : context.data.smoothProjective right)
    (leftDimension : context.data.dimension left = 4)
    (rightDimension : context.data.dimension right = 4)
    (related : context.birational.r left right) :
    context.marker left = context.marker right :=
  context.marker_eq_of_birational leftSmooth rightSmooth leftDimension rightDimension related
/-- Reviewer-facing direct-QDM one-step conclusion with the exact stabilized
marker value and irrationality exposed together. -/
theorem cubicThreefold_oneProjectiveLine_conclusion_of_residueMarker
    {K Variety Center Occurrence : Type*} [CommRing K]
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    (projectiveFourSpace : Variety) (Rational : Variety → Prop)
    (cubic : Variety)
    (input : Applications.CubicResidueMarkerOneStepInput context
      productWithProjectiveLine projectiveFourSpace Rational cubic) :
    Applications.CubicResidueMarkerOneStepConclusion context
      productWithProjectiveLine Rational cubic :=
  Applications.cubicThreefold_oneProjectiveLine_conclusion_of_residueMarker
    context productWithProjectiveLine projectiveFourSpace Rational cubic input
/-- Reviewer-facing exact three-clause conclusion of the conditional framed
theorem: marker four on the cubic stabilization, marker zero on every rational
smooth projective fourfold, and irrationality. -/
theorem cubicThreefold_oneProjectiveLine_conclusion_of_framedMarker
    {Variety Center Occurrence : Type*}
    (context : Quantum.FramedSixthMarkerContext 4 Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    (projectiveFourSpace : Variety) (Rational : Variety → Prop)
    (cubic : Variety)
    (input : Applications.CubicFramedMarkerOneStepInput context
      productWithProjectiveLine projectiveFourSpace Rational cubic) :
    Applications.CubicFramedMarkerOneStepConclusion context
      productWithProjectiveLine Rational cubic :=
  Applications.cubicThreefold_oneProjectiveLine_conclusion_of_framedMarker
    context productWithProjectiveLine projectiveFourSpace Rational cubic input
/-- Reviewer-facing separation statement along a family of cubic threefolds
whose intermediate Jacobians carry an algebraic primitive minimal class.  Each
member is universally `CH₀`-trivial through Voisin's criterion, its
projective-line stabilization is universally `CH₀`-trivial through the supplied
projective-bundle formula, and that stabilization is irrational by the
direct-QDM residue marker and its occurrence-indexed categorical descent.
Neither the family nor any cited geometric input is
constructed: the countable union of subvarieties of codimension at most three
in the moduli space of smooth cubic threefolds is the imported input,
represented here by the parameter type alone. -/
theorem primitiveMinimalClassFamily_universalCH0_and_irrational_stabilization
    {K Base Variety Center Occurrence Jacobian : Type*} [CommRing K]
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    (projectiveFourSpace : Variety) (Rational : Variety → Prop)
    (geometry : Applications.CubicCycleTrivialityGeometry Variety Jacobian)
    (voisinCriterion : Applications.VoisinPrimitiveMinimalClassCriterion geometry)
    (projectiveBundleCH0 : ∀ variety, geometry.universallyCH0Trivial variety →
      geometry.universallyCH0Trivial (productWithProjectiveLine variety))
    (fibre : Base → Variety)
    (familyInput : Applications.SixAxisMinimalClassFamilyInput geometry fibre)
    (markerInput : ∀ parameter,
      Applications.CubicResidueMarkerOneStepInput context productWithProjectiveLine
        projectiveFourSpace Rational (fibre parameter)) :
    ∀ parameter, geometry.universallyCH0Trivial (fibre parameter) ∧
      geometry.universallyCH0Trivial (productWithProjectiveLine (fibre parameter)) ∧
        ¬ Rational (productWithProjectiveLine (fibre parameter)) := by
  intro parameter
  obtain ⟨fibreCH0, separation⟩ :=
    Applications.primitiveMinimalClassFamily_separation context
      productWithProjectiveLine projectiveFourSpace Rational geometry
      voisinCriterion projectiveBundleCH0 fibre familyInput markerInput parameter
  exact ⟨fibreCH0, separation.stabilizationUniversallyCH0Trivial,
    separation.stabilizationNotRational⟩
/-- Reviewer-facing existential form of the preceding statement: when the
parameter space of the family is nonempty, some smooth cubic threefold is
universally `CH₀`-trivial and has a universally `CH₀`-trivial irrational
projective-line stabilization.  Nonemptiness of that parameter space is the
imported input and is a hypothesis here. -/
theorem exists_universalCH0_cubic_with_irrational_stabilization
    {K Base Variety Center Occurrence Jacobian : Type*} [CommRing K]
    [Nonempty Base]
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    (projectiveFourSpace : Variety) (Rational : Variety → Prop)
    (geometry : Applications.CubicCycleTrivialityGeometry Variety Jacobian)
    (voisinCriterion : Applications.VoisinPrimitiveMinimalClassCriterion geometry)
    (projectiveBundleCH0 : ∀ variety, geometry.universallyCH0Trivial variety →
      geometry.universallyCH0Trivial (productWithProjectiveLine variety))
    (fibre : Base → Variety)
    (familyInput : Applications.SixAxisMinimalClassFamilyInput geometry fibre)
    (markerInput : ∀ parameter,
      Applications.CubicResidueMarkerOneStepInput context productWithProjectiveLine
        projectiveFourSpace Rational (fibre parameter)) :
    ∃ cubic, geometry.universallyCH0Trivial cubic ∧
      geometry.universallyCH0Trivial (productWithProjectiveLine cubic) ∧
        ¬ Rational (productWithProjectiveLine cubic) := by
  obtain ⟨cubic, cubicCH0, separation⟩ :=
    Applications.exists_universalCH0_with_irrational_stabilization context
      productWithProjectiveLine projectiveFourSpace Rational geometry
      voisinCriterion projectiveBundleCH0 fibre familyInput markerInput
  exact ⟨cubic, cubicCH0, separation.stabilizationUniversallyCH0Trivial,
    separation.stabilizationNotRational⟩
/-- Reviewer-facing separation statement for a cubic threefold defined by the
Fermat equation.  The hypothesis of the almost-diagonal universal zero-cycle
triviality criterion is proved rather than assumed: the sum of the cubes of the
five variables is a sum of forms in pairwise disjoint groups of at most three
variables.  Universal `CH₀`-triviality then passes to the projective-line
stabilization, which the direct-QDM residue marker shows to be irrational. -/
theorem fermatCubic_universalCH0_and_irrational_stabilization
    {K Variety Center Occurrence Coefficient : Type*}
    [CommRing K] [CommRing Coefficient] [Nontrivial Coefficient]
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    (projectiveFourSpace : Variety) (Rational : Variety → Prop)
    {fermat : Variety}
    (universallyCH0Trivial : Variety → Prop)
    (definingForm : Variety → MvPolynomial (Fin 5) Coefficient)
    (separatedVariableCriterion : ∀ variety,
      Applications.HasSeparatedVariableDecomposition 3 (definingForm variety) →
        universallyCH0Trivial variety)
    (projectiveBundleCH0 : ∀ variety, universallyCH0Trivial variety →
      universallyCH0Trivial (productWithProjectiveLine variety))
    (fermatEquation : definingForm fermat = Applications.fermatCubicForm Coefficient 5)
    (input : Applications.CubicResidueMarkerOneStepInput context
      productWithProjectiveLine projectiveFourSpace Rational fermat) :
    universallyCH0Trivial (productWithProjectiveLine fermat) ∧
      ¬ Rational (productWithProjectiveLine fermat) := by
  have separation := Applications.fermatCubic_separation context
    productWithProjectiveLine projectiveFourSpace Rational universallyCH0Trivial
    definingForm separatedVariableCriterion projectiveBundleCH0 fermatEquation input
  exact ⟨separation.stabilizationUniversallyCH0Trivial, separation.stabilizationNotRational⟩
/-- Reviewer-facing separation statement for a cubic threefold with unirational
parametrizations of degrees two and three.  Both degrees persist on the
projective-line stabilization, and two and three are coprime, so the
stabilization is universally `CH₀`-trivial by the supplied coprime-degree
criterion; the direct-QDM residue marker makes it irrational.  Coprimality is
proved here; the parametrizations, their persistence, and the passage from
coprime degrees to a decomposition of the diagonal are premises. -/
theorem coprimeUnirationalDegrees_universalCH0_and_irrational_stabilization
    {K Variety Center Occurrence : Type*} [CommRing K]
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    (projectiveFourSpace : Variety) (Rational : Variety → Prop)
    {cubic : Variety}
    (universallyCH0Trivial : Variety → Prop)
    (admitsUnirationalParametrization : Variety → ℕ → Prop)
    (coprimeDegreeCriterion : ∀ variety degree otherDegree,
      admitsUnirationalParametrization variety degree →
        admitsUnirationalParametrization variety otherDegree →
          Nat.Coprime degree otherDegree → universallyCH0Trivial variety)
    (degreesPersist : ∀ variety degree,
      admitsUnirationalParametrization variety degree →
        admitsUnirationalParametrization (productWithProjectiveLine variety) degree)
    (quadraticParametrization : admitsUnirationalParametrization cubic 2)
    (cubicParametrization : admitsUnirationalParametrization cubic 3)
    (input : Applications.CubicResidueMarkerOneStepInput context
      productWithProjectiveLine projectiveFourSpace Rational cubic) :
    admitsUnirationalParametrization (productWithProjectiveLine cubic) 2 ∧
      admitsUnirationalParametrization (productWithProjectiveLine cubic) 3 ∧
        universallyCH0Trivial (productWithProjectiveLine cubic) ∧
          ¬ Rational (productWithProjectiveLine cubic) := by
  obtain ⟨stabilizedQuadratic, stabilizedCubic, separation⟩ :=
    Applications.coprimeUnirationalDegrees_separation context
      productWithProjectiveLine projectiveFourSpace Rational universallyCH0Trivial
      admitsUnirationalParametrization coprimeDegreeCriterion degreesPersist
      quadraticParametrization cubicParametrization input
  exact ⟨stabilizedQuadratic, stabilizedCubic, separation.stabilizationUniversallyCH0Trivial,
    separation.stabilizationNotRational⟩

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
