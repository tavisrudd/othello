import RelativeConicArcs.PRSFoundation

/-!
# Four-marker pointed witness composition

This module formalizes the logical and numerical core of a three-step pointed
contraction argument.  An admissible lower object carries a witness, and the
corresponding lift preserves the witness property.  Three such steps compose a
bottom witness into an upper witness.

The numerical declarations record a genus-one ordered-pair cover with diagonal
degree four, different degree eight, and four marker fibers of degree six.  They
also record the three recursive parameter-line degrees and the final
first-polar degree.  The squared Hasse--Weil margin is proved for every field
order at least fifty-three.

No algebraic-geometric assertion is inferred here: geometric integrality,
exhaustion of gcd and monodromy strata, divisor-degree calculations, and the
existence of admissible contractions are inputs to `PointedWitnessStep`.
Lean checks their threefold composition and all displayed integer arithmetic by
kernel elaboration, with no finite census or imported certificate.
-/

namespace RelativeConicArcs.PRSFourMarkerLowerPackage

/-- Data for one pointed contraction step.  `admissible upper lower` includes
all distinct-marker, noncollision, and lower-stratum conditions needed by that
step. -/
structure PointedWitnessStep (Upper Lower : Type*) where
  /-- Upper objects to which the contraction step applies. -/
  exceptional : Upper → Prop
  /-- Admissible incidence between an upper object and a selected contraction. -/
  admissible : Upper → Lower → Prop
  /-- Witness predicate at the lower degree. -/
  lowerHasWitness : Lower → Prop
  /-- Witness predicate after lifting to the upper degree. -/
  upperHasWitness : Upper → Prop
  /-- Every exceptional upper object has an admissible contraction. -/
  select : ∀ upper, exceptional upper → ∃ lower, admissible upper lower
  /-- A lower witness lifts through an admissible contraction. -/
  lift :
    ∀ {upper lower}, admissible upper lower →
      lowerHasWitness lower → upperHasWitness upper

namespace PointedWitnessStep

/-- A pointwise supply of lower witnesses produces upper witnesses after one
admissible pointed contraction. -/
theorem exceptional_has_witness {Upper Lower : Type*}
    (step : PointedWitnessStep Upper Lower)
    (lowerWitness :
      ∀ upper lower, step.admissible upper lower →
        step.lowerHasWitness lower) :
    ∀ upper, step.exceptional upper → step.upperHasWitness upper := by
  intro upper hUpper
  obtain ⟨lower, hAdmissible⟩ := step.select upper hUpper
  exact step.lift hAdmissible (lowerWitness upper lower hAdmissible)

end PointedWitnessStep

/-- Compatibility conditions that connect three pointed contraction steps. -/
structure ThreeStepCompatibility
    {LevelThree LevelTwo LevelOne LevelZero : Type*}
    (stepThree : PointedWitnessStep LevelThree LevelTwo)
    (stepTwo : PointedWitnessStep LevelTwo LevelOne)
    (stepOne : PointedWitnessStep LevelOne LevelZero) : Prop where
  /-- Every first admissible contraction lies in the domain of the second step. -/
  secondExceptional :
    ∀ {upper middle}, stepThree.admissible upper middle →
      stepTwo.exceptional middle
  /-- The witness lifted by the second step is the witness consumed by the first. -/
  secondWitness :
    ∀ middle, stepTwo.upperHasWitness middle ↔
      stepThree.lowerHasWitness middle
  /-- Every second admissible contraction lies in the domain of the third step. -/
  firstExceptional :
    ∀ {middle lower}, stepTwo.admissible middle lower →
      stepOne.exceptional lower
  /-- The witness lifted by the third step is the witness consumed by the second. -/
  firstWitness :
    ∀ lower, stepOne.upperHasWitness lower ↔
      stepTwo.lowerHasWitness lower

/-- Three compatible pointed contractions lift a bottom witness to the original
upper object. -/
theorem three_pointed_steps_have_witness
    {LevelThree LevelTwo LevelOne LevelZero : Type*}
    (stepThree : PointedWitnessStep LevelThree LevelTwo)
    (stepTwo : PointedWitnessStep LevelTwo LevelOne)
    (stepOne : PointedWitnessStep LevelOne LevelZero)
    (compatible : ThreeStepCompatibility stepThree stepTwo stepOne)
    (bottomWitness :
      ∀ upper middle lower bottom,
        stepThree.admissible upper middle →
        stepTwo.admissible middle lower →
        stepOne.admissible lower bottom →
        stepOne.lowerHasWitness bottom) :
    ∀ upper, stepThree.exceptional upper →
      stepThree.upperHasWitness upper := by
  intro upper hUpper
  obtain ⟨middle, hMiddle⟩ := stepThree.select upper hUpper
  obtain ⟨lower, hLower⟩ :=
    stepTwo.select middle (compatible.secondExceptional hMiddle)
  obtain ⟨bottom, hBottom⟩ :=
    stepOne.select lower (compatible.firstExceptional hLower)
  apply stepThree.lift hMiddle
  apply (compatible.secondWitness middle).1
  apply stepTwo.lift hLower
  apply (compatible.firstWitness lower).1
  exact stepOne.lift hBottom
    (bottomWitness upper middle lower bottom hMiddle hLower hBottom)

/-- Total deletion degree on the four-marker ordered-pair cover:
four diagonal points, eight off-diagonal different points, and four
six-point marker fibers. -/
def fourMarkerDeletionDegree : ℕ := 4 + 8 + 4 * 6

/-- Exceptional degree on the contraction line of a quartic net with three
old markers. -/
def threePointedQuarticParameterDegree : ℕ :=
  3 + 4 + 6 + 3 * 2 + 3

/-- Exceptional degree on the contraction line of a quintic series with two
old markers. -/
def twoPointedQuinticParameterDegree : ℕ :=
  3 + 1 + 8 + 2 * 2 + 2

/-- Exceptional degree on the contraction line of a sextic series with one
old marker. -/
def onePointedSexticParameterDegree : ℕ :=
  3 + 2 + 10 + 2 + 1

/-- Exceptional degree on the final degree-eight first-polar line. -/
def degreeEightFirstPolarDegree : ℕ := 3 + 2 + 12

/-- The four-marker deletion and recursive parameter degrees are respectively
`36`, `22`, `18`, `18`, and `17`. -/
theorem exact_deletion_and_parameter_degrees :
    fourMarkerDeletionDegree = 36 ∧
      threePointedQuarticParameterDegree = 22 ∧
      twoPointedQuinticParameterDegree = 18 ∧
      onePointedSexticParameterDegree = 18 ∧
      degreeEightFirstPolarDegree = 17 := by
  norm_num [fourMarkerDeletionDegree, threePointedQuarticParameterDegree,
    twoPointedQuinticParameterDegree, onePointedSexticParameterDegree,
    degreeEightFirstPolarDegree]

/-- Every recursive parameter divisor has degree strictly smaller than the
number of rational points of a projective line when `q ≥ 53`. -/
theorem parameter_degrees_lt_projectiveLine_cardinality
    {q : ℕ} (hq : 53 ≤ q) :
    threePointedQuarticParameterDegree < q + 1 ∧
      twoPointedQuinticParameterDegree < q + 1 ∧
      onePointedSexticParameterDegree < q + 1 ∧
      degreeEightFirstPolarDegree < q + 1 := by
  norm_num [threePointedQuarticParameterDegree,
    twoPointedQuinticParameterDegree, onePointedSexticParameterDegree,
    degreeEightFirstPolarDegree]
  omega

/-- Squared form of the strict genus-one Hasse--Weil margin
`q + 1 - 2√q > 36`.  Positivity of `q - 35` is automatic in the stated
range, so this strict square inequality is equivalent to the displayed
real inequality. -/
theorem fourMarker_genusOne_squared_margin
    {q : ℕ} (hq : 53 ≤ q) :
    4 * (q : ℤ) < ((q : ℤ) - 35) ^ 2 := by
  have hqz : (53 : ℤ) ≤ q := by exact_mod_cast hq
  nlinarith [sq_nonneg ((q : ℤ) - 53)]

end RelativeConicArcs.PRSFourMarkerLowerPackage
