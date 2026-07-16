import RepairCodes.WeightedTransferExact
import RepairCodes.ProjectiveAxisTwistedCubic

/-!
# A strict five-coordinate weighted-transfer example

This file formalizes the generalized single-parity-check part of the manuscript's strict
weighted-transfer example.  The Singer regular-action theorem is kept as an explicit geometric
input; every code-theoretic deduction from the resulting disjoint multiplier is checked here.
-/

namespace RepairCodes

open Finset FiniteGeom
open scoped BigOperators

noncomputable section

variable {κ V 𝔽 : Type*}
variable [Fintype κ] [DecidableEq κ]
variable [Field 𝔽] [DecidableEq 𝔽]
variable [AddCommGroup V] [Module 𝔽 V] [DecidableEq V]

/-- A regular action supplies a disjoint translate whenever the square of the selected-set size
is smaller than the acting group.  This proves the orbit-counting step used after invoking
Singer's classical regular-action theorem. -/
theorem exists_disjoint_translate_of_regular_action
    {G X : Type*} [Fintype G] [DecidableEq G] [Fintype X] [DecidableEq X]
    (S : Finset X) (translate : G → X ≃ X)
    (hregular : ∀ x y : X, ∃! g : G, translate g x = y)
    (hsmall : S.card * S.card < Fintype.card G) :
    ∃ g, Disjoint S (S.map (translate g).toEmbedding) := by
  classical
  let move : X → X → G := fun x y => Classical.choose (hregular x y)
  have hmove_unique (x y : X) (g : G) (hg : translate g x = y) : g = move x y := by
    exact (Classical.choose_spec (hregular x y)).2 g hg
  let pairs : Finset (X × X) := S ×ˢ S
  let bad : Finset G := pairs.image fun p => move p.1 p.2
  have hbadcard : bad.card ≤ S.card * S.card := by
    calc
      bad.card ≤ pairs.card := Finset.card_image_le
      _ = S.card * S.card := by simp [pairs]
  have hexists : ∃ g : G, g ∉ bad := by
    by_contra h
    push_neg at h
    have huniv : (univ : Finset G) ⊆ bad := fun g _ => h g
    have hcard : Fintype.card G ≤ bad.card := by
      simpa using Finset.card_le_card huniv
    omega
  obtain ⟨g, hgbad⟩ := hexists
  refine ⟨g, ?_⟩
  rw [Finset.disjoint_left]
  intro y hyS hytranslate
  obtain ⟨x, hxS, hxy⟩ := Finset.mem_map.mp hytranslate
  have hgmove : g = move x y := hmove_unique x y g hxy
  apply hgbad
  rw [hgmove]
  apply Finset.mem_image.mpr
  exact ⟨(x, y), by simp [pairs, hxS, hyS], rfl⟩

/-- The exact numerical deduction from regular Singer counting: a 20-set in a regular 820-point
action has a disjoint translate.  Regularity itself is the cited classical Singer input. -/
theorem exists_disjoint_translate_of_twenty_in_regular_820
    {G X : Type*} [Fintype G] [DecidableEq G] [Fintype X] [DecidableEq X]
    (S : Finset X) (translate : G → X ≃ X)
    (hS : S.card = 20) (hG : Fintype.card G = 820)
    (hregular : ∀ x y : X, ∃! g : G, translate g x = y) :
    ∃ g, Disjoint S (S.map (translate g).toEmbedding) := by
  apply exists_disjoint_translate_of_regular_action S translate hregular
  calc
    S.card * S.card = 20 * 20 := by rw [hS]
    _ < 820 := by norm_num
    _ = Fintype.card G := hG.symm

/-- The generalized parity-check map. -/
def generalizedSPCFiveCheck (a : V ≃ₗ[𝔽] V) : (Fin 5 → V) →ₗ[𝔽] V where
  toFun u := u 0 + a (u 1) + u 2 + u 3 + u 4
  map_add' u v := by
    simp only [Pi.add_apply, map_add]
    abel
  map_smul' c u := by
    simp only [Pi.smul_apply, map_smul]
    simp [smul_add]

/-- The five-coordinate generalized single-parity-check code with multiplier `a` in coordinate
one. -/
def generalizedSPCFive (a : V ≃ₗ[𝔽] V) : Submodule 𝔽 (Fin 5 → V) :=
  LinearMap.ker (generalizedSPCFiveCheck a)

@[simp]
theorem mem_generalizedSPCFive {a : V ≃ₗ[𝔽] V} {u : Fin 5 → V} :
    u ∈ generalizedSPCFive a ↔ u 0 + a (u 1) + u 2 + u 3 + u 4 = 0 := by
  rfl

/-- The functional dual consists exactly of tuples `(f, f ∘ a, f, f, f)`. -/
theorem mem_functionalDual_generalizedSPCFive_iff
    (a : V ≃ₗ[𝔽] V) (beta : Fin 5 → Module.Dual 𝔽 V) :
    beta ∈ functionalDual (generalizedSPCFive a) ↔
      ∃ f : Module.Dual 𝔽 V,
        beta 0 = f ∧ beta 1 = f.comp a.toLinearMap ∧
          beta 2 = f ∧ beta 3 = f ∧ beta 4 = f := by
  classical
  constructor
  · intro hbeta
    let f : Module.Dual 𝔽 V := beta 0
    have h02 : beta 2 = f := by
      apply LinearMap.ext
      intro v
      have h := hbeta ![v, 0, -v, 0, 0]
        (by simp [generalizedSPCFive, generalizedSPCFiveCheck])
      simp [Fin.sum_univ_succ, f] at h
      linear_combination -h
    have h03 : beta 3 = f := by
      apply LinearMap.ext
      intro v
      have h := hbeta ![v, 0, 0, -v, 0]
        (by simp [generalizedSPCFive, generalizedSPCFiveCheck])
      simp [Fin.sum_univ_succ, f] at h
      linear_combination -h
    have h04 : beta 4 = f := by
      apply LinearMap.ext
      intro v
      have h := hbeta ![v, 0, 0, 0, -v]
        (by simp [generalizedSPCFive, generalizedSPCFiveCheck])
      simp [Fin.sum_univ_succ, f] at h
      linear_combination -h
    have h01 : beta 1 = f.comp a.toLinearMap := by
      apply LinearMap.ext
      intro v
      have h := hbeta ![-a v, v, 0, 0, 0]
        (by simp [generalizedSPCFive, generalizedSPCFiveCheck])
      simp [Fin.sum_univ_succ, f] at h
      linear_combination h
    exact ⟨f, rfl, h01, h02, h03, h04⟩
  · rintro ⟨f, h0, h1, h2, h3, h4⟩ u hu
    simpa [generalizedSPCFiveCheck, Fin.sum_univ_succ, h0, h1, h2, h3, h4,
      map_add, add_assoc] using congrArg f hu

/-- Every nonzero generalized-SPC functional-dual word has full support. -/
theorem generalizedSPCFive_functionalDual_full_support
    (a : V ≃ₗ[𝔽] V) {beta : Fin 5 → Module.Dual 𝔽 V}
    (hbeta : beta ∈ functionalDual (generalizedSPCFive a)) (hbeta0 : beta ≠ 0) :
    ∀ i, beta i ≠ 0 := by
  obtain ⟨f, h0, h1, h2, h3, h4⟩ :=
    (mem_functionalDual_generalizedSPCFive_iff a beta).mp hbeta
  have hf : f ≠ 0 := by
    intro hf
    apply hbeta0
    funext i
    fin_cases i
    · simpa [h0, hf]
    · simpa [h1, hf]
    · simpa [h2, hf]
    · simpa [h3, hf]
    · simpa [h4, hf]
  have hfa : f.comp a.toLinearMap ≠ 0 := by
    intro hcomp
    apply hf
    apply LinearMap.ext
    intro v
    obtain ⟨x, rfl⟩ := a.surjective v
    have h := LinearMap.congr_fun hcomp x
    simpa using h
  intro i
  fin_cases i
  · simpa [h0] using hf
  · simpa [h1] using hfa
  · simpa [h2] using hf
  · simpa [h3] using hf
  · simpa [h4] using hf

/-- The generalized-SPC functional support distance is at least five. -/
theorem generalizedSPCFive_functionalDistance_five (a : V ≃ₗ[𝔽] V) :
    HasFunctionalDualDistanceAtLeast (generalizedSPCFive a) 5 :=
  hasFunctionalDualDistanceAtLeast_five_of_full_support _
    (fun beta hbeta hbeta0 => generalizedSPCFive_functionalDual_full_support a hbeta hbeta0)

/-- A nonzero functional supplies a weight-five functional-dual word, so the preceding bound is
exact. -/
theorem generalizedSPCFive_not_functionalDistance_six
    (a : V ≃ₗ[𝔽] V) (f : Module.Dual 𝔽 V) (hf : f ≠ 0) :
    ¬ HasFunctionalDualDistanceAtLeast (generalizedSPCFive a) 6 := by
  classical
  let beta : Fin 5 → Module.Dual 𝔽 V :=
    ![f, f.comp a.toLinearMap, f, f, f]
  have hbeta : beta ∈ functionalDual (generalizedSPCFive a) := by
    apply (mem_functionalDual_generalizedSPCFive_iff a beta).mpr
    exact ⟨f, rfl, rfl, rfl, rfl, rfl⟩
  have hbeta0 : beta ≠ 0 := by
    intro h
    apply hf
    exact congrFun h 0
  intro hsix
  have hlower := hsix beta hbeta hbeta0
  have hweight : functionalWeight beta = 5 := by
    rw [functionalWeight]
    have hfull := generalizedSPCFive_functionalDual_full_support a hbeta hbeta0
    rw [Finset.filter_eq_self.mpr fun i _ => hfull i]
    simp
  omega

/-- Every coordinate projection of the generalized-SPC code is onto. -/
theorem generalizedSPCFive_isCoordinateSurjective (a : V ≃ₗ[𝔽] V) :
    IsCoordinateSurjective (generalizedSPCFive a) := by
  intro j v
  fin_cases j
  · exact ⟨![v, 0, -v, 0, 0], by simp [generalizedSPCFive, generalizedSPCFiveCheck], rfl⟩
  · exact ⟨![-a v, v, 0, 0, 0], by simp [generalizedSPCFive, generalizedSPCFiveCheck], rfl⟩
  · exact ⟨![-v, 0, v, 0, 0], by simp [generalizedSPCFive, generalizedSPCFiveCheck], rfl⟩
  · exact ⟨![-v, 0, 0, v, 0], by simp [generalizedSPCFive, generalizedSPCFiveCheck], rfl⟩
  · exact ⟨![-v, 0, 0, 0, v], by simp [generalizedSPCFive, generalizedSPCFiveCheck], rfl⟩

/-- A functional has unit inner realization cost. -/
def HasUnitFunctionalCost
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (f : Module.Dual 𝔽 V) : Prop :=
  ∃ w : κ → 𝔽, blockFunctional I e w = f ∧ hammingNorm w = 1

/-- The functional induced by a unit word at inner coordinate `k`. -/
def innerCoordinateFunctional
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I) (k : κ) : Module.Dual 𝔽 V :=
  blockFunctional I e (Pi.single k 1)

/-- A scalar unit word induces the corresponding scalar multiple of the coordinate functional. -/
theorem blockFunctional_single
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I) (k : κ) (c : 𝔽) :
    blockFunctional I e (Pi.single k c) = c • innerCoordinateFunctional I e k := by
  classical
  apply LinearMap.ext
  intro v
  change (∑ i, (e v : κ → 𝔽) i * (Pi.single k c : κ → 𝔽) i) =
    c * ∑ i, (e v : κ → 𝔽) i * (Pi.single k (1 : 𝔽) : κ → 𝔽) i
  have hleft : (∑ i, (e v : κ → 𝔽) i * (Pi.single k c : κ → 𝔽) i) =
      (e v : κ → 𝔽) k * c := by
    calc
      (∑ i, (e v : κ → 𝔽) i * (Pi.single k c : κ → 𝔽) i) =
          (e v : κ → 𝔽) k * (Pi.single k c : κ → 𝔽) k := by
        apply Fintype.sum_eq_single k
        intro i hik
        simp [Pi.single_apply, hik]
      _ = (e v : κ → 𝔽) k * c := by simp
  have hright : (∑ i, (e v : κ → 𝔽) i *
      (Pi.single k (1 : 𝔽) : κ → 𝔽) i) = (e v : κ → 𝔽) k := by
    calc
      (∑ i, (e v : κ → 𝔽) i * (Pi.single k (1 : 𝔽) : κ → 𝔽) i) =
          (e v : κ → 𝔽) k * 1 := by
        calc
          (∑ i, (e v : κ → 𝔽) i * (Pi.single k (1 : 𝔽) : κ → 𝔽) i) =
              (e v : κ → 𝔽) k * (Pi.single k (1 : 𝔽) : κ → 𝔽) k := by
            apply Fintype.sum_eq_single k
            intro i hik
            simp [Pi.single_apply, hik]
          _ = (e v : κ → 𝔽) k * 1 := by simp
      _ = (e v : κ → 𝔽) k := mul_one _
  rw [hleft, hright]
  exact mul_comm _ _

/-- `blockFunctional` is additive in the ambient block word. -/
theorem blockFunctional_sub
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I) (w u : κ → 𝔽) :
    blockFunctional I e (w - u) = blockFunctional I e w - blockFunctional I e u := by
  apply LinearMap.ext
  intro v
  simp [blockFunctional, dotProduct, Finset.sum_sub_distrib, mul_sub]

/-- Dual distance at least three makes the coordinate-functional scalar orbits pairwise distinct. -/
theorem innerCoordinateFunctional_orbit_injective
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (hdist : 3 ≤ dualDist I) {k l : κ} {c : 𝔽} (hc : c ≠ 0)
    (heq : innerCoordinateFunctional I e l = c • innerCoordinateFunctional I e k) :
    l = k := by
  classical
  by_contra hlk
  let z : κ → 𝔽 := Pi.single l 1 - Pi.single k c
  have hzfunctional : blockFunctional I e z = 0 := by
    rw [show z = Pi.single l 1 - Pi.single k c by rfl, blockFunctional_sub,
      blockFunctional_single, blockFunctional_single, one_smul, heq, sub_self]
  have hzdual : z ∈ dualCode I :=
    (blockFunctional_eq_zero_iff I e z).mp hzfunctional
  have hz0 : z ≠ 0 := by
    intro hz
    have hzl := congrFun hz l
    simp [z, Pi.single_apply, hlk, hc] at hzl
  have hnorm : hammingNorm z = 2 := by
    rw [hammingNorm]
    have hfilter : (univ.filter fun x => z x ≠ 0) = ({l, k} : Finset κ) := by
      ext x
      by_cases hxl : x = l
      · subst x
        simp [z, Pi.single_apply, hlk]
      · by_cases hxk : x = k
        · subst x
          simp [z, Pi.single_apply, hxl, hc]
        · simp [z, Pi.single_apply, hxl, hxk]
    rw [hfilter]
    simp [hlk]
  have hlower := dualDist_le_hammingNorm hzdual hz0
  omega

/-- Unit realization cost is exactly membership in a nonzero scalar orbit of the inner coordinate
functionals.  This is the seed-specific bridge from coordinate columns to Singer projective
classes. -/
theorem hasUnitFunctionalCost_iff_coordinate_orbit
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (f : Module.Dual 𝔽 V) :
    HasUnitFunctionalCost I e f ↔
      ∃ k : κ, ∃ c : 𝔽, c ≠ 0 ∧ f = c • innerCoordinateFunctional I e k := by
  classical
  constructor
  · rintro ⟨w, hwf, hweight⟩
    let S : Finset κ := univ.filter fun k => w k ≠ 0
    have hScard : S.card = 1 := by simpa [S, hammingNorm] using hweight
    obtain ⟨k, hS⟩ := Finset.card_eq_one.mp hScard
    have hkS : k ∈ S := by rw [hS]; simp
    have hwk : w k ≠ 0 := (Finset.mem_filter.mp hkS).2
    have hwEq : w = Pi.single k (w k) := by
      funext l
      by_cases hlk : l = k
      · subst l
        simp
      · have hl0 : w l = 0 := by
          by_contra hl
          have hlS : l ∈ S := Finset.mem_filter.mpr ⟨Finset.mem_univ _, hl⟩
          rw [hS] at hlS
          exact hlk (Finset.mem_singleton.mp hlS)
        simp [Pi.single_apply, hlk, hl0]
    refine ⟨k, w k, hwk, ?_⟩
    calc
      f = blockFunctional I e w := hwf.symm
      _ = blockFunctional I e (Pi.single k (w k)) := congrArg (blockFunctional I e) hwEq
      _ = w k • innerCoordinateFunctional I e k := blockFunctional_single I e k (w k)
  · rintro ⟨k, c, hc, rfl⟩
    refine ⟨Pi.single k c, blockFunctional_single I e k c, ?_⟩
    rw [hammingNorm]
    have hfilter : (univ.filter fun x => (Pi.single k c : κ → 𝔽) x ≠ 0) =
        ({k} : Finset κ) := by
      ext x
      by_cases hxk : x = k
      · subst x
        simp [hc]
      · simp [Pi.single_apply, hxk]
    rw [hfilter]
    simp

/-- Dual distance at least two makes every inner coordinate functional nonzero. -/
theorem innerCoordinateFunctional_ne_zero
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (hdist : 2 ≤ dualDist I) (k : κ) :
    innerCoordinateFunctional I e k ≠ 0 := by
  intro hzero
  have hzdual : (Pi.single k (1 : 𝔽) : κ → 𝔽) ∈ dualCode I := by
    rw [← blockFunctional_eq_zero_iff I e, blockFunctional_single, one_smul]
    exact hzero
  have hz0 : (Pi.single k (1 : 𝔽) : κ → 𝔽) ≠ 0 := by
    intro h
    have := congrFun h k
    simp at this
  have hnorm : hammingNorm (Pi.single k (1 : 𝔽) : κ → 𝔽) = 1 := by
    rw [hammingNorm]
    have hfilter :
        (univ.filter fun x => (Pi.single k (1 : 𝔽) : κ → 𝔽) x ≠ 0) =
          ({k} : Finset κ) := by
      ext x
      by_cases hx : x = k
      · subst x
        simp
      · simp [Pi.single_apply, hx]
    rw [hfilter]
    simp
  have := dualDist_le_hammingNorm hzdual hz0
  omega

/-- Precomposition by a linear equivalence preserves nonzero dual functionals. -/
def precompNonzeroDual (a : V ≃ₗ[𝔽] V)
    (f : {f : Module.Dual 𝔽 V // f ≠ 0}) :
    {f : Module.Dual 𝔽 V // f ≠ 0} :=
  ⟨f.1.comp a.toLinearMap, by
    intro hzero
    apply f.2
    apply LinearMap.ext
    intro v
    obtain ⟨u, rfl⟩ := a.surjective v
    have h := LinearMap.congr_fun hzero u
    simpa using h⟩

/-- The raw-functional form of disjointness between the seed's cost-one projective set and its
multiplier translate.  It is invariant under nonzero scalar rescaling and is exactly what the
Singer argument supplies. -/
def HasDisjointUnitCostMultiplier
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (a : V ≃ₗ[𝔽] V) : Prop :=
  ∀ f : Module.Dual 𝔽 V, f ≠ 0 →
    ¬ (HasUnitFunctionalCost I e f ∧
      HasUnitFunctionalCost I e (f.comp a.toLinearMap))

/-- **Singer-to-code bridge.**  Suppose a regular projective action is presented by projective
classes of nonzero dual functionals, compatible linear multipliers, and the usual scalar-orbit
equality.  Then the completed seed's twenty coordinate classes have a multiplier translate
disjoint from themselves, and that multiplier satisfies the raw unit-cost predicate consumed by
the generalized-SPC theorem.  The regular action is the sole cited Singer input; all deductions
from it are made here. -/
theorem exists_disjointUnitCostMultiplier_of_regular_projective_action
    {G X : Type*} [Fintype G] [DecidableEq G] [Fintype X] [DecidableEq X]
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (hdist : 3 ≤ dualDist I) (hcard : Fintype.card κ = 20)
    (classOf : {f : Module.Dual 𝔽 V // f ≠ 0} → X)
    (translate : G → X ≃ X) (multiplier : G → V ≃ₗ[𝔽] V)
    (hGcard : Fintype.card G = 820)
    (hregular : ∀ x y : X, ∃! g : G, translate g x = y)
    (hclass : ∀ f g, classOf f = classOf g ↔
      ∃ c : 𝔽, c ≠ 0 ∧ f.1 = c • g.1)
    (hcompat : ∀ g f,
      translate g (classOf f) = classOf (precompNonzeroDual (multiplier g) f)) :
    ∃ g : G, HasDisjointUnitCostMultiplier I e (multiplier g) := by
  classical
  let coord : κ → {f : Module.Dual 𝔽 V // f ≠ 0} := fun k =>
    ⟨innerCoordinateFunctional I e k,
      innerCoordinateFunctional_ne_zero I e (hdist.trans' (by omega)) k⟩
  let S : Finset X := univ.image fun k => classOf (coord k)
  have hcoordInjective : Function.Injective (fun k => classOf (coord k)) := by
    intro k l hkl
    obtain ⟨c, hc, heq⟩ := (hclass (coord k) (coord l)).mp hkl
    exact innerCoordinateFunctional_orbit_injective I e hdist hc heq
  have hScard : S.card = 20 := by
    rw [show S = univ.image (fun k => classOf (coord k)) by rfl,
      Finset.card_image_of_injective _ hcoordInjective]
    simpa using hcard
  have hunit (f : {f : Module.Dual 𝔽 V // f ≠ 0}) :
      classOf f ∈ S ↔ HasUnitFunctionalCost I e f.1 := by
    constructor
    · intro hfS
      obtain ⟨k, _, hk⟩ := Finset.mem_image.mp hfS
      obtain ⟨c, hc, heq⟩ := (hclass f (coord k)).mp hk.symm
      exact (hasUnitFunctionalCost_iff_coordinate_orbit I e f.1).mpr ⟨k, c, hc, heq⟩
    · intro hcost
      obtain ⟨k, c, hc, heq⟩ :=
        (hasUnitFunctionalCost_iff_coordinate_orbit I e f.1).mp hcost
      apply Finset.mem_image.mpr
      refine ⟨k, Finset.mem_univ _, ?_⟩
      exact ((hclass f (coord k)).mpr ⟨c, hc, heq⟩).symm
  obtain ⟨g, hg⟩ := exists_disjoint_translate_of_twenty_in_regular_820
    S translate hScard hGcard hregular
  refine ⟨g, ?_⟩
  intro f hf hboth
  let fs : {f : Module.Dual 𝔽 V // f ≠ 0} := ⟨f, hf⟩
  have hfS : classOf fs ∈ S := (hunit fs).mpr hboth.1
  have hcompS : classOf (precompNonzeroDual (multiplier g) fs) ∈ S :=
    (hunit (precompNonzeroDual (multiplier g) fs)).mpr hboth.2
  have htranslated : classOf (precompNonzeroDual (multiplier g) fs) ∈
      S.map (translate g).toEmbedding := by
    apply Finset.mem_map.mpr
    exact ⟨classOf fs, hfS, hcompat g fs⟩
  exact (Finset.disjoint_left.mp hg hcompS htranslated)

/-- A disjoint unit-cost multiplier forces weighted functional distance at least six for its
generalized-SPC outer code. -/
theorem generalizedSPCFive_weightedDistance_six_of_disjoint
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (a : V ≃ₗ[𝔽] V) (hdisjoint : HasDisjointUnitCostMultiplier I e a) :
    HasNonzeroFunctionalRealizationAtLeast I e (generalizedSPCFive a) 6 := by
  apply hasNonzeroFunctionalRealizationAtLeast_six_of_five_full_support I e
    (generalizedSPCFive a)
  · intro beta hbeta hbeta0
    exact generalizedSPCFive_functionalDual_full_support a hbeta hbeta0
  · intro beta hbeta hbeta0 w hw
    obtain ⟨f, h0, h1, _, _, _⟩ :=
      (mem_functionalDual_generalizedSPCFive_iff a beta).mp hbeta
    have hf : f ≠ 0 := by
      intro hf
      exact (generalizedSPCFive_functionalDual_full_support a hbeta hbeta0 0) (h0.trans hf)
    have hw0pos : 1 ≤ hammingNorm (w 0) := by
      apply Nat.one_le_iff_ne_zero.mpr
      intro hz
      have hwzero := hammingNorm_eq_zero.mp hz
      apply hf
      rw [← h0, ← hw 0, hwzero]
      apply LinearMap.ext
      intro v
      simp [blockFunctional]
    have hw1pos : 1 ≤ hammingNorm (w 1) := by
      apply Nat.one_le_iff_ne_zero.mpr
      intro hz
      have hwzero := hammingNorm_eq_zero.mp hz
      apply generalizedSPCFive_functionalDual_full_support a hbeta hbeta0 1
      rw [← hw 1, hwzero]
      apply LinearMap.ext
      intro v
      simp [blockFunctional]
    by_contra hpair
    push_neg at hpair
    have hw0one : hammingNorm (w 0) = 1 := by omega
    have hw1one : hammingNorm (w 1) = 1 := by omega
    exact hdisjoint f hf ⟨⟨w 0, (hw 0).trans h0, hw0one⟩,
      ⟨w 1, (hw 1).trans h1, hw1one⟩⟩

/-- **Strict radius-four transfer.**  For an inner code of dual distance three, a disjoint
unit-cost multiplier gives literal complete radius-four repair-hypergraph equality, even though
the ordinary support-distance-six gate can fail. -/
theorem generalizedSPCFive_radiusFour_transfer_of_disjoint
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (a : V ≃ₗ[𝔽] V) (hdual : dualDist I = 3)
    (hdisjoint : HasDisjointUnitCostMultiplier I e a)
    (j : Fin 5) (x : κ) :
    repairHypergraph (concatenatedCode I e (generalizedSPCFive a)) (j, x) 4 =
      embedHypergraph (blockEmbedding j) (repairHypergraph I x 4) := by
  have hzero : HasZeroFunctionalMultiblockAtLeast I e (generalizedSPCFive a) 6 :=
    hasZeroFunctionalMultiblockAtLeast_of_two_dualDist I e (generalizedSPCFive a) 6 (by
      rw [hdual])
  have hweighted :
      HasNonzeroFunctionalRealizationAtLeast I e (generalizedSPCFive a) 6 :=
    generalizedSPCFive_weightedDistance_six_of_disjoint I e a hdisjoint
  have hnonembedded :
      HasNonembeddedDualDistanceAtLeast I e (generalizedSPCFive a) 6 :=
    (hasNonembeddedDualDistanceAtLeast_iff_zero_and_weighted
      I e (generalizedSPCFive a) 6).mpr ⟨hzero, hweighted⟩
  exact repairHypergraph_concatenatedCode_eq_embed_nonembedded
    I e (generalizedSPCFive a) 4 hnonembedded j x

/-- For the completed seed, a disjoint unit-cost multiplier makes both natural obstruction
thresholds exactly six: they have lower bound six but not seven. -/
theorem projectiveAxisTwistedCubic_exact_threshold_six_of_disjoint
    {L : Type*} [AddCommGroup L] [Module 𝔽 L] [DecidableEq L]
    [Fintype 𝔽] [CharP 𝔽 3]
    (e : L ≃ₗ[𝔽] projectiveAxisTwistedCubicCode (𝔽 := 𝔽))
    (a : L ≃ₗ[𝔽] L)
    (hdisjoint : HasDisjointUnitCostMultiplier
      (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) e a) :
    HasNonembeddedDualDistanceAtLeast
        (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) e (generalizedSPCFive a) 6 ∧
      ¬ HasNonembeddedDualDistanceAtLeast
        (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) e (generalizedSPCFive a) 7 ∧
      HasMultiblockDualDistanceAtLeast
        (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) e (generalizedSPCFive a) 6 ∧
      ¬ HasMultiblockDualDistanceAtLeast
        (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) e (generalizedSPCFive a) 7 := by
  let I := projectiveAxisTwistedCubicCode (𝔽 := 𝔽)
  have hdual : dualCode I ≠ ⊥ := by
    intro hbot
    have hzero : dualDist I = 0 := by
      rw [dualDist, hbot]
      simp [minDist]
    have hthree : dualDist I = 3 := projectiveAxisTwistedCubicCode_dualDist
    omega
  have hweighted :
      HasNonzeroFunctionalRealizationAtLeast I e (generalizedSPCFive a) 6 :=
    generalizedSPCFive_weightedDistance_six_of_disjoint I e a hdisjoint
  have hzero : HasZeroFunctionalMultiblockAtLeast I e (generalizedSPCFive a) 6 :=
    hasZeroFunctionalMultiblockAtLeast_of_two_dualDist I e (generalizedSPCFive a) 6 (by
      dsimp [I]
      rw [projectiveAxisTwistedCubicCode_dualDist])
  have hnonembedded :
      HasNonembeddedDualDistanceAtLeast I e (generalizedSPCFive a) 6 :=
    (hasNonembeddedDualDistanceAtLeast_iff_zero_and_weighted
      I e (generalizedSPCFive a) 6).mpr ⟨hzero, hweighted⟩
  have hnotseven :
      ¬ HasNonembeddedDualDistanceAtLeast I e (generalizedSPCFive a) 7 := by
    intro hseven
    have hbound := (hasNonembeddedDualDistanceAtLeast_iff_le_two_dualDist_and_weighted
      I e (generalizedSPCFive a) (by simp) hdual 7).mp hseven
    have hthree : dualDist I = 3 := projectiveAxisTwistedCubicCode_dualDist
    omega
  have hsurj : IsCoordinateSurjective (generalizedSPCFive a) :=
    generalizedSPCFive_isCoordinateSurjective a
  have hequiv (d : ℕ) :
      HasNonembeddedDualDistanceAtLeast I e (generalizedSPCFive a) d ↔
        HasMultiblockDualDistanceAtLeast I e (generalizedSPCFive a) d :=
    hasNonembeddedDualDistanceAtLeast_iff_multiblock_of_isCoordinateSurjective
      I e (generalizedSPCFive a) hsurj d
  exact ⟨hnonembedded, hnotseven, (hequiv 6).mp hnonembedded,
    fun hseven => hnotseven ((hequiv 7).mpr hseven)⟩

/-- Over a nine-element field, the completed cubic--axis seed has twenty pairwise distinct
projective coordinate-functional classes, and these are exactly its unit-cost functional
classes.  This packages the seed-side input used in the Singer multiplier argument. -/
theorem projectiveAxisTwistedCubic_twenty_unitCost_orbits
    {L : Type*} [AddCommGroup L] [Module 𝔽 L] [DecidableEq L]
    [Fintype 𝔽] [CharP 𝔽 3]
    (hcard : Fintype.card 𝔽 = 9)
    (e : L ≃ₗ[𝔽] projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) :
    Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽) = 20 ∧
      (∀ f : Module.Dual 𝔽 L,
        HasUnitFunctionalCost (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) e f ↔
          ∃ k : ProjectiveAxisTwistedCubicIndex 𝔽, ∃ c : 𝔽,
            c ≠ 0 ∧ f = c • innerCoordinateFunctional
              (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) e k) ∧
      (∀ {k l : ProjectiveAxisTwistedCubicIndex 𝔽} {c : 𝔽}, c ≠ 0 →
        innerCoordinateFunctional (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) e l =
          c • innerCoordinateFunctional
            (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) e k →
        l = k) := by
  refine ⟨?_, fun f => hasUnitFunctionalCost_iff_coordinate_orbit _ e f, ?_⟩
  · simp [hcard]
  · intro k l c hc heq
    exact innerCoordinateFunctional_orbit_injective _ e (by
      rw [projectiveAxisTwistedCubicCode_dualDist]) hc heq

/-- Paper-facing specialization to the completed cubic--axis seed. -/
theorem projectiveAxisTwistedCubic_strict_weighted_transfer
    {L : Type*} [AddCommGroup L] [Module 𝔽 L] [DecidableEq L]
    [Fintype 𝔽] [CharP 𝔽 3]
    (e : L ≃ₗ[𝔽] projectiveAxisTwistedCubicCode (𝔽 := 𝔽))
    (a : L ≃ₗ[𝔽] L)
    (hdisjoint : HasDisjointUnitCostMultiplier
      (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) e a)
    (f : Module.Dual 𝔽 L) (hf : f ≠ 0) :
    HasFunctionalDualDistanceAtLeast (generalizedSPCFive a) 5 ∧
      ¬ HasFunctionalDualDistanceAtLeast (generalizedSPCFive a) 6 ∧
      HasNonzeroFunctionalRealizationAtLeast
        (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) e (generalizedSPCFive a) 6 ∧
      IsCoordinateSurjective (generalizedSPCFive a) ∧
      ∀ j x,
        repairHypergraph
            (concatenatedCode (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) e
              (generalizedSPCFive a)) (j, x) 4 =
          embedHypergraph (blockEmbedding j)
            (repairHypergraph (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) x 4) := by
  refine ⟨generalizedSPCFive_functionalDistance_five a,
    generalizedSPCFive_not_functionalDistance_six a f hf,
    generalizedSPCFive_weightedDistance_six_of_disjoint _ e a hdisjoint,
    generalizedSPCFive_isCoordinateSurjective a, ?_⟩
  intro j x
  exact generalizedSPCFive_radiusFour_transfer_of_disjoint _ e a
    projectiveAxisTwistedCubicCode_dualDist hdisjoint j x

/-- End-to-end paper specialization from a presented regular Singer action.  The action's
regularity is the cited classical input; the theorem constructs the disjoint multiplier and then
derives the strict weighted transfer conclusion without assuming `HasDisjointUnitCostMultiplier`. -/
theorem projectiveAxisTwistedCubic_strict_weighted_transfer_of_regular_projective_action
    {L G X : Type*} [AddCommGroup L] [Module 𝔽 L] [DecidableEq L]
    [Fintype 𝔽] [CharP 𝔽 3]
    [Fintype G] [DecidableEq G] [Fintype X] [DecidableEq X]
    (hFcard : Fintype.card 𝔽 = 9)
    (e : L ≃ₗ[𝔽] projectiveAxisTwistedCubicCode (𝔽 := 𝔽))
    (classOf : {f : Module.Dual 𝔽 L // f ≠ 0} → X)
    (translate : G → X ≃ X) (multiplier : G → L ≃ₗ[𝔽] L)
    (hGcard : Fintype.card G = 820)
    (hregular : ∀ x y : X, ∃! g : G, translate g x = y)
    (hclass : ∀ f g, classOf f = classOf g ↔
      ∃ c : 𝔽, c ≠ 0 ∧ f.1 = c • g.1)
    (hcompat : ∀ g f,
      translate g (classOf f) = classOf (precompNonzeroDual (multiplier g) f))
    (f : Module.Dual 𝔽 L) (hf : f ≠ 0) :
    ∃ g : G,
      HasFunctionalDualDistanceAtLeast (generalizedSPCFive (multiplier g)) 5 ∧
        ¬ HasFunctionalDualDistanceAtLeast (generalizedSPCFive (multiplier g)) 6 ∧
        HasNonzeroFunctionalRealizationAtLeast
          (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) e
          (generalizedSPCFive (multiplier g)) 6 ∧
        IsCoordinateSurjective (generalizedSPCFive (multiplier g)) ∧
        ∀ j x,
          repairHypergraph
              (concatenatedCode (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) e
                (generalizedSPCFive (multiplier g))) (j, x) 4 =
            embedHypergraph (blockEmbedding j)
              (repairHypergraph (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) x 4) := by
  have hindex : Fintype.card (ProjectiveAxisTwistedCubicIndex 𝔽) = 20 := by
    simp [hFcard]
  obtain ⟨g, hg⟩ := exists_disjointUnitCostMultiplier_of_regular_projective_action
    (projectiveAxisTwistedCubicCode (𝔽 := 𝔽)) e
    (by rw [projectiveAxisTwistedCubicCode_dualDist]) hindex
    classOf translate multiplier hGcard hregular hclass hcompat
  exact ⟨g, projectiveAxisTwistedCubic_strict_weighted_transfer e (multiplier g) hg f hf⟩

end
end RepairCodes

#print axioms RepairCodes.mem_functionalDual_generalizedSPCFive_iff
#print axioms RepairCodes.exists_disjoint_translate_of_regular_action
#print axioms RepairCodes.exists_disjoint_translate_of_twenty_in_regular_820
#print axioms RepairCodes.generalizedSPCFive_functionalDual_full_support
#print axioms RepairCodes.generalizedSPCFive_functionalDistance_five
#print axioms RepairCodes.generalizedSPCFive_not_functionalDistance_six
#print axioms RepairCodes.generalizedSPCFive_isCoordinateSurjective
#print axioms RepairCodes.hasUnitFunctionalCost_iff_coordinate_orbit
#print axioms RepairCodes.innerCoordinateFunctional_orbit_injective
#print axioms RepairCodes.exists_disjointUnitCostMultiplier_of_regular_projective_action
#print axioms RepairCodes.projectiveAxisTwistedCubic_twenty_unitCost_orbits
#print axioms RepairCodes.projectiveAxisTwistedCubic_exact_threshold_six_of_disjoint
#print axioms RepairCodes.generalizedSPCFive_weightedDistance_six_of_disjoint
#print axioms RepairCodes.generalizedSPCFive_radiusFour_transfer_of_disjoint
#print axioms RepairCodes.projectiveAxisTwistedCubic_strict_weighted_transfer
#print axioms RepairCodes.projectiveAxisTwistedCubic_strict_weighted_transfer_of_regular_projective_action
