import RelativeConicArcs.ClebschDoubleCosetDepthPositive
import RelativeConicArcs.ClebschDoubleCosetDepthNegative
import RelativeConicArcs.ClebschMomentTrade
import RelativeConicArcs.ClebschBalancedSheetsH3

/-!
# Six mixed double cosets, their depth plane, and singleton recovery

The six orbits of the two displayed matching-row permutations have sizes `1,4,6` on each
displayed eleven-row sheet.  Their secant-incidence profiles form three opposite pairs in a two-dimensional
subspace of four-space over `ZMod 11`.  The induced linear map from the six orbit labels has rank two
and kernel dimension four, while the six individual profiles remain distinct.  The weighted signed
pushforward has zero first and second scalar moments and a nonzero cubic moment.

The finite geometry is checked in the two sheet modules.  This module uses ordinary linear algebra
to assemble those checks and invokes the displayed matching-decoration recovery theorem only after
a singleton profile has selected a unique matching row.
-/

namespace RelativeConicArcs
namespace ClebschDoubleCosetDepth

open scoped BigOperators

set_option maxRecDepth 100000

/-- The six derived representative profiles reduced to `ZMod 11`. -/
def representativeProfile (i : Fin 6) : Fin 4 → ZMod 11 :=
  fun j ↦ (depthProfile (orbitRepresentative i) j : ZMod 11)

/-- The exact representative profiles, proved from the two secant-incidence leaves. -/
theorem representativeProfile_values : representativeProfile = ![
    ![5, 0, 1, 10], ![8, 3, 0, 3], ![3, 9, 9, 0],
    ![6, 0, 10, 1], ![3, 8, 0, 8], ![8, 2, 2, 0]
  ] := by
  rcases positiveRepresentative_profiles with ⟨h0, h1, h2⟩
  rcases negativeRepresentative_profiles with ⟨h3, h4, h5⟩
  funext i j
  fin_cases i <;> fin_cases j <;> simp_all [representativeProfile] <;> decide

/-- The linear map from functions on the six orbit labels to the four depth coordinates. -/
def profileLinearMap : (Fin 6 → ZMod 11) →ₗ[ZMod 11] (Fin 4 → ZMod 11) :=
  ClebschFactorization.configurationMap representativeProfile

/-- Coordinates relative to the first two positive profiles. -/
def profileCoordinate (i : Fin 6) : Fin 2 → ZMod 11 :=
  ![9 * representativeProfile i 0 + 9 * representativeProfile i 1,
    4 * representativeProfile i 1]

/-- The injection of the two depth-plane coordinates into four-space. -/
def profileLift : (Fin 2 → ZMod 11) →ₗ[ZMod 11] (Fin 4 → ZMod 11) where
  toFun c := fun j ↦ c 0 * (![5, 0, 1, 10] : Fin 4 → ZMod 11) j +
    c 1 * (![8, 3, 0, 3] : Fin 4 → ZMod 11) j
  map_add' left right := by
    funext j
    simp only [Pi.add_apply]
    ring
  map_smul' scalar c := by
    funext j
    simp only [Pi.smul_apply, smul_eq_mul, RingHom.id_apply]
    ring

/-- The first two coordinate functionals give a left inverse to `profileLift`. -/
def profileProject : (Fin 4 → ZMod 11) →ₗ[ZMod 11] (Fin 2 → ZMod 11) where
  toFun v := ![9 * v 0 + 9 * v 1, 4 * v 1]
  map_add' left right := by
    funext j
    fin_cases j <;> simp <;> ring
  map_smul' scalar v := by
    funext j
    fin_cases j <;> simp [smul_eq_mul] <;> ring

private theorem mul_fortyFive_add_mul_ninetyNine (x y : ZMod 11) :
    x * 45 + y * 99 = x := by
  have h45 : (45 : ZMod 11) = 1 := by decide
  have h99 : (99 : ZMod 11) = 0 := by decide
  calc
    x * 45 + y * 99 = x * 1 + y * 0 :=
      congrArg₂ (· + ·) (congrArg (x * ·) h45) (congrArg (y * ·) h99)
    _ = x := by ring

private theorem mul_twelve (x : ZMod 11) : x * 12 = x := by
  have h12 : (12 : ZMod 11) = 1 := by decide
  calc
    x * 12 = x * 1 := congrArg (x * ·) h12
    _ = x := by ring

private theorem project_first_formula (x y : ZMod 11) :
    9 * (x * 5 + y * 8) + 9 * (y * 3) = x := by
  calc
    9 * (x * 5 + y * 8) + 9 * (y * 3) = x * 45 + y * 99 := by ring
    _ = x := mul_fortyFive_add_mul_ninetyNine x y

private theorem project_second_formula (y : ZMod 11) : 4 * (y * 3) = y := by
  calc
    4 * (y * 3) = y * 12 := by ring
    _ = y := mul_twelve y

private theorem coordinate_first_formula (x y : ZMod 11) :
    x * (9 * 5) + y * (9 * 8 + 9 * 3) = x := by
  calc
    x * (9 * 5) + y * (9 * 8 + 9 * 3) = x * 45 + y * 99 := by ring
    _ = x := mul_fortyFive_add_mul_ninetyNine x y

private theorem coordinate_second_formula (y : ZMod 11) : y * (4 * 3) = y := by
  calc
    y * (4 * 3) = y * 12 := by ring
    _ = y := mul_twelve y

/-- Projection after lifting is the identity on the two coordinate functions. -/
theorem profileProject_profileLift (c : Fin 2 → ZMod 11) :
    profileProject (profileLift c) = c := by
  funext i
  fin_cases i
  · simpa [profileProject, profileLift] using
      project_first_formula (c 0) (c 1)
  · simpa [profileProject, profileLift] using project_second_formula (c 1)

/-- The depth-plane lift is injective. -/
theorem profileLift_injective : Function.Injective profileLift := by
  intro left right h
  rw [← profileProject_profileLift left, ← profileProject_profileLift right, h]

/-- Every derived representative profile is reconstructed from its two displayed coordinates. -/
theorem representativeProfile_reconstruct (i : Fin 6) :
    profileLift (profileCoordinate i) = representativeProfile i := by
  rw [representativeProfile_values]
  fin_cases i <;> decide

/-- The coordinate configuration spans all of two-space. -/
theorem profileCoordinate_surjective :
    Function.Surjective (ClebschFactorization.configurationMap profileCoordinate) := by
  intro target
  refine ⟨![target 0, target 1, 0, 0, 0, 0], ?_⟩
  funext j
  fin_cases j
  · simpa [ClebschFactorization.configurationMap, profileCoordinate,
      representativeProfile_values, Fin.sum_univ_succ] using
      coordinate_first_formula (target 0) (target 1)
  · simpa [ClebschFactorization.configurationMap, profileCoordinate,
      representativeProfile_values, Fin.sum_univ_succ] using coordinate_second_formula (target 1)

/-- The six-column profile map factors through the injective two-dimensional lift. -/
theorem profileLinearMap_factorization :
    profileLinearMap = profileLift.comp
      (ClebschFactorization.configurationMap profileCoordinate) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [profileLinearMap, ClebschFactorization.configurationMap, profileCoordinate, profileLift,
      representativeProfile_values, Fin.sum_univ_succ] <;> decide

/-- The linear image of the six double-coset labels has dimension two. -/
theorem profileLinearMap_range_finrank :
    Module.finrank (ZMod 11) (LinearMap.range profileLinearMap) = 2 := by
  rw [profileLinearMap_factorization]
  have hrange : LinearMap.range
      (profileLift.comp (ClebschFactorization.configurationMap profileCoordinate)) =
      LinearMap.range profileLift := by
    ext y
    constructor
    · rintro ⟨x, rfl⟩
      exact ⟨ClebschFactorization.configurationMap profileCoordinate x, rfl⟩
    · rintro ⟨c, rfl⟩
      obtain ⟨x, rfl⟩ := profileCoordinate_surjective c
      exact ⟨x, rfl⟩
  rw [hrange, LinearMap.finrank_range_of_inj profileLift_injective, Module.finrank_pi]
  decide

/-- The kernel of the six-label depth map has dimension four. -/
theorem profileLinearMap_ker_finrank :
    Module.finrank (ZMod 11) (LinearMap.ker profileLinearMap) = 4 := by
  have hrk := profileLinearMap.finrank_range_add_finrank_ker
  rw [profileLinearMap_range_finrank, Module.finrank_pi] at hrk
  norm_num at hrk ⊢
  omega

/-- The six derived profiles are pairwise distinct despite the four-dimensional linear kernel. -/
theorem representativeProfile_injective : Function.Injective representativeProfile := by
  rw [representativeProfile_values]
  decide

/-- Both equations cutting out the depth plane hold for every representative profile. -/
theorem representativeProfiles_planeEquations : ∀ i : Fin 6,
    2 * representativeProfile i 0 + 2 * representativeProfile i 1 +
      representativeProfile i 2 = 0 ∧
    9 * representativeProfile i 0 + 8 * representativeProfile i 1 +
      representativeProfile i 3 = 0 := by
  rw [representativeProfile_values]
  decide

/-- The positive profiles satisfy the displayed integer-weighted barycentre relation. -/
theorem positiveProfiles_weightedBarycentre :
    depthProfile (orbitRepresentative 0) +
      4 • depthProfile (orbitRepresentative 1) +
      6 • depthProfile (orbitRepresentative 2) = 0 := by
  rcases positiveRepresentative_profiles with ⟨h0, h1, h2⟩
  rw [h0, h1, h2]
  decide

/-- The signed weights on the three positive and three negative double cosets. -/
def pushforwardWeight : Fin 6 → ZMod 11 := ![1, 4, 6, 10, 7, 5]

/-- The first scalar coordinate of the signed depth pushforward has cubic-first survival. -/
theorem cubicFirst_pushforward :
    ClebschMomentTrade.signedMoment pushforwardWeight (fun i ↦ representativeProfile i 0) 1 = 0 ∧
    ClebschMomentTrade.signedMoment pushforwardWeight (fun i ↦ representativeProfile i 0) 2 = 0 ∧
    ClebschMomentTrade.signedMoment pushforwardWeight (fun i ↦ representativeProfile i 0) 3 = 6 := by
  rw [representativeProfile_values]
  decide

/-- The singleton representatives form the unordered golden matching-row pair. -/
def singletonMatchingPair : Finset Parent :=
  {orbitRepresentative 0, orbitRepresentative 3}

/-- The two size-one generated orbits are exactly the unordered singleton pair. -/
theorem singletonOrbits_recover_unordered_pair :
    generatedOrbit (orbitRepresentative 0) ∪ generatedOrbit (orbitRepresentative 3) =
      singletonMatchingPair := by
  decide

/-- Once the positive singleton decoration is chosen, the displayed decorated transform recovers
its matching-row parent exactly. -/
theorem chosenPositiveSingleton_recovers_decoratedParent {p : Parent}
    (h : ClebschGateway.Q11Matching.matchingMate p =
      ClebschGateway.Q11Matching.matchingMate (orbitRepresentative 0)) :
    p = orbitRepresentative 0 :=
  ClebschGateway.Q11Matching.matchingMate_injective h

/-- The relation pairs used by the depth profile are the four pairs selected by the displayed odd
Fourier involution, whose integer matrix has the checked square `1331 I`. -/
theorem oddFourier_relation_bridge :
    orientedRelationPair = ![![1, 10], ![3, 13], ![6, 14], ![9, 11]] ∧
    ClebschGateway.Q11Fusion.oddFourier * ClebschGateway.Q11Fusion.oddFourier =
      (1331 : Int) • (1 : Matrix (Fin 4) (Fin 4) Int) := by
  exact ⟨by decide, ClebschGateway.Q11Fusion.oddFourier_square⟩

end ClebschDoubleCosetDepth
end RelativeConicArcs
