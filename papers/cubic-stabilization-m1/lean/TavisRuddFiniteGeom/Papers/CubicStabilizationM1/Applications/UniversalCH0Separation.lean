import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.CubicResidueMarkerOneStep
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.UniversalCH0
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.SeparatedVariableCubicForms

/-!
# Separating universal zero-cycle triviality from rationality

The manuscript's separation statements all have the same shape.  For a smooth
cubic threefold `X` two independent facts are combined: `X` is universally
`CH₀`-trivial for a reason coming from cycle theory, and `X × ℙ¹` is irrational
because its direct-QDM rank-two residue marker is nonzero while the marker
vanishes on projective four-space.  Universal `CH₀`-triviality passes
from `X` to `X × ℙ¹` by the projective-bundle formula for Chow groups, so the
fourfold `X × ℙ¹` carries a trivial universal `CH₀` group and is nonetheless
irrational: the decomposition-of-the-diagonal obstruction and the atom
obstruction see different structures on it.

This module records that composition once and then instantiates it at the three
sources of universal `CH₀`-triviality used in the manuscript.

* Algebraicity of the primitive minimal class on the intermediate Jacobian,
  through Voisin's criterion, along a family of cubic threefolds.  Claire
  Voisin, *On the universal `CH₀` group of cubic hypersurfaces*, Journal of the
  European Mathematical Society 19 (2017), 1619--1653, arXiv:1407.7261v2,
  Theorem 4.5 and Lemma 4.6 produce such a family; that its parameter space is
  a nonempty countable union of subvarieties of codimension at most three in
  the moduli space of smooth cubic threefolds is that imported input, and is
  represented here only by a nonempty parameter type.
* An equation that is a sum of forms in pairwise disjoint groups of at most
  three variables, through the almost-diagonal criterion of Jean-Louis
  Colliot-Thélène, *CH₀-trivialité universelle d'hypersurfaces cubiques presque
  diagonales*, Algebraic Geometry 4 (2017), 597--602, arXiv:1607.05673v3,
  Théorème 2.8.  For the Fermat equation the hypothesis of that criterion is
  not assumed here: it is proved, in
  `TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Applications.fermatCubicForm_separatedVariable_five`.
* Unirational parametrizations of coprime degrees, which give a decomposition
  of the diagonal.  Song Yang, Xun Yu and Zigang Zhu, *Nonrational varieties
  with unirational parametrizations of coprime degrees*, arXiv:2508.03623v2
  (2025), Theorem 3.3 exhibits smooth cubic threefolds with a unirational
  parametrization of degree three, every smooth cubic hypersurface having one
  of degree two, and Corollary 3.5 keeps both degrees after multiplying by a
  projective space.  Coprimality of the two degrees is proved here rather than
  assumed.

Lean constructs no cubic threefold, moduli space, Chow group, projective-bundle
formula, unirational parametrization, intermediate Jacobian, or quantum
connection.  Each of those is a supplied type, function, predicate, or premise,
and each cited theorem enters as an explicit hypothesis.  All proofs are
symbolic and kernel checked, with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Applications

universe u v w x

variable {K : Type x} [CommRing K]
variable {Variety : Type u} {Center : Type v} {Occurrence : Type w}

/-- The two assertions a separation statement makes about the product of a
cubic threefold with a projective line: universal `CH₀`-triviality and
irrationality. -/
structure StabilizationSeparation
    (productWithProjectiveLine : Variety → Variety)
    (Rational universallyCH0Trivial : Variety → Prop) (cubic : Variety) : Prop where
  /-- The product is universally `CH₀`-trivial. -/
  stabilizationUniversallyCH0Trivial :
    universallyCH0Trivial (productWithProjectiveLine cubic)
  /-- The product is not rational. -/
  stabilizationNotRational :
    ¬ Rational (productWithProjectiveLine cubic)

/-- The separation composition.  Universal `CH₀`-triviality of the cubic
threefold passes to its projective-line stabilization by the supplied
projective-bundle premise, while the cubic residue marker makes that
stabilization irrational. -/
theorem stabilizationSeparation_of_universalCH0_and_residueMarker
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    (projectiveFourSpace : Variety) (Rational : Variety → Prop)
    {cubic : Variety}
    (universallyCH0Trivial : Variety → Prop)
    (projectiveBundleCH0 : ∀ variety, universallyCH0Trivial variety →
      universallyCH0Trivial (productWithProjectiveLine variety))
    (cubicUniversallyCH0Trivial : universallyCH0Trivial cubic)
    (input : CubicResidueMarkerOneStepInput context productWithProjectiveLine
      projectiveFourSpace Rational cubic) :
    StabilizationSeparation productWithProjectiveLine Rational
      universallyCH0Trivial cubic where
  stabilizationUniversallyCH0Trivial :=
    projectiveBundleCH0 cubic cubicUniversallyCH0Trivial
  stabilizationNotRational :=
    cubicThreefold_oneProjectiveLine_not_rational_of_residueMarker context
      productWithProjectiveLine projectiveFourSpace Rational cubic input

/-- Separation along a family whose members have algebraic primitive minimal
class.  Every member is universally `CH₀`-trivial by Voisin's criterion, and
its projective-line stabilization is universally `CH₀`-trivial and
irrational. -/
theorem primitiveMinimalClassFamily_separation
    {Base Jacobian : Type*}
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    (projectiveFourSpace : Variety) (Rational : Variety → Prop)
    (geometry : CubicCycleTrivialityGeometry Variety Jacobian)
    (voisinCriterion : VoisinPrimitiveMinimalClassCriterion geometry)
    (projectiveBundleCH0 : ∀ variety, geometry.universallyCH0Trivial variety →
      geometry.universallyCH0Trivial (productWithProjectiveLine variety))
    (fibre : Base → Variety)
    (familyInput : SixAxisMinimalClassFamilyInput geometry fibre)
    (residueInput : ∀ parameter,
      CubicResidueMarkerOneStepInput context productWithProjectiveLine
        projectiveFourSpace Rational (fibre parameter)) :
    ∀ parameter, geometry.universallyCH0Trivial (fibre parameter) ∧
      StabilizationSeparation productWithProjectiveLine Rational
        geometry.universallyCH0Trivial (fibre parameter) := by
  intro parameter
  have fibreCH0 : geometry.universallyCH0Trivial (fibre parameter) :=
    universalCH0Triviality_of_primitiveMinimalClassFamily geometry fibre familyInput
      voisinCriterion parameter
  exact ⟨fibreCH0,
    stabilizationSeparation_of_universalCH0_and_residueMarker context
      productWithProjectiveLine projectiveFourSpace Rational
      geometry.universallyCH0Trivial projectiveBundleCH0 fibreCH0
      (residueInput parameter)⟩

/-- The existential form of the previous statement.  When the parameter space of
the family is nonempty there is a cubic threefold that is universally
`CH₀`-trivial and whose projective-line stabilization is universally
`CH₀`-trivial and irrational.  Nonemptiness, and the codimension bound on the
parameter space, are the imported inputs; they are not derived here. -/
theorem exists_universalCH0_with_irrational_stabilization
    {Base Jacobian : Type*} [Nonempty Base]
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    (projectiveFourSpace : Variety) (Rational : Variety → Prop)
    (geometry : CubicCycleTrivialityGeometry Variety Jacobian)
    (voisinCriterion : VoisinPrimitiveMinimalClassCriterion geometry)
    (projectiveBundleCH0 : ∀ variety, geometry.universallyCH0Trivial variety →
      geometry.universallyCH0Trivial (productWithProjectiveLine variety))
    (fibre : Base → Variety)
    (familyInput : SixAxisMinimalClassFamilyInput geometry fibre)
    (residueInput : ∀ parameter,
      CubicResidueMarkerOneStepInput context productWithProjectiveLine
        projectiveFourSpace Rational (fibre parameter)) :
    ∃ cubic, geometry.universallyCH0Trivial cubic ∧
      StabilizationSeparation productWithProjectiveLine Rational
        geometry.universallyCH0Trivial cubic :=
  ⟨fibre (Classical.arbitrary Base),
    primitiveMinimalClassFamily_separation context productWithProjectiveLine
      projectiveFourSpace Rational geometry voisinCriterion projectiveBundleCH0
      fibre familyInput residueInput (Classical.arbitrary Base)⟩

/-- Separation for a cubic threefold whose equation is the Fermat form in five
variables.  The hypothesis of the almost-diagonal criterion is discharged by
Lean: the Fermat form is the sum of the cubes of the five variables, hence a
sum of forms in pairwise disjoint groups of at most three variables. -/
theorem fermatCubic_separation
    {Coefficient : Type*} [CommRing Coefficient] [Nontrivial Coefficient]
    (context : Quantum.RankTwoResidueMarkerContext K Variety Center Occurrence)
    (productWithProjectiveLine : Variety → Variety)
    (projectiveFourSpace : Variety) (Rational : Variety → Prop)
    {fermat : Variety}
    (universallyCH0Trivial : Variety → Prop)
    (definingForm : Variety → MvPolynomial (Fin 5) Coefficient)
    (separatedVariableCriterion : ∀ variety,
      HasSeparatedVariableDecomposition 3 (definingForm variety) →
        universallyCH0Trivial variety)
    (projectiveBundleCH0 : ∀ variety, universallyCH0Trivial variety →
      universallyCH0Trivial (productWithProjectiveLine variety))
    (fermatEquation : definingForm fermat = fermatCubicForm Coefficient 5)
    (input : CubicResidueMarkerOneStepInput context productWithProjectiveLine
      projectiveFourSpace Rational fermat) :
    StabilizationSeparation productWithProjectiveLine Rational
      universallyCH0Trivial fermat := by
  refine stabilizationSeparation_of_universalCH0_and_residueMarker context
    productWithProjectiveLine projectiveFourSpace Rational universallyCH0Trivial
    projectiveBundleCH0 (separatedVariableCriterion fermat ?_) input
  rw [fermatEquation]
  exact fermatCubicForm_separatedVariable_five Coefficient

/-- Separation for a cubic threefold with unirational parametrizations of
degrees two and three.  Both degrees persist on the projective-line
stabilization, two and three are coprime, so the stabilization is universally
`CH₀`-trivial by the coprime-degree criterion, and it is irrational by the
cubic residue marker.  No projective-bundle premise is needed: universal
`CH₀`-triviality is obtained on the fourfold directly. -/
theorem coprimeUnirationalDegrees_separation
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
    (input : CubicResidueMarkerOneStepInput context productWithProjectiveLine
      projectiveFourSpace Rational cubic) :
    admitsUnirationalParametrization (productWithProjectiveLine cubic) 2 ∧
      admitsUnirationalParametrization (productWithProjectiveLine cubic) 3 ∧
        StabilizationSeparation productWithProjectiveLine Rational
          universallyCH0Trivial cubic := by
  have stabilizedQuadratic :
      admitsUnirationalParametrization (productWithProjectiveLine cubic) 2 :=
    degreesPersist cubic 2 quadraticParametrization
  have stabilizedCubic :
      admitsUnirationalParametrization (productWithProjectiveLine cubic) 3 :=
    degreesPersist cubic 3 cubicParametrization
  refine ⟨stabilizedQuadratic, stabilizedCubic, ?_, ?_⟩
  · exact coprimeDegreeCriterion (productWithProjectiveLine cubic) 2 3
      stabilizedQuadratic stabilizedCubic (by decide)
  · exact cubicThreefold_oneProjectiveLine_not_rational_of_residueMarker context
      productWithProjectiveLine projectiveFourSpace Rational cubic input

end Applications

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
