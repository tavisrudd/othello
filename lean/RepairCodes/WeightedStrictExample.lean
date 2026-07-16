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

/-- The exact numerical deduction from regular Singer counting: a 20-set in a regular 820-point
action has a disjoint translate.  Regularity itself is the cited classical Singer input. -/
theorem exists_disjoint_translate_of_twenty_in_regular_820
    {G X : Type*} [Fintype G] [DecidableEq G] [Fintype X] [DecidableEq X]
    (S : Finset X) (translate : G → X ≃ X)
    (hS : S.card = 20) (hG : Fintype.card G = 820)
    (hcount : (∑ g, (S ∩ S.map (translate g).toEmbedding).card) = S.card * S.card) :
    ∃ g, Disjoint S (S.map (translate g).toEmbedding) := by
  apply exists_disjoint_translate_of_sum_inter_lt S translate
  rw [hcount, hS, hG]
  norm_num

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

/-- The raw-functional form of disjointness between the seed's cost-one projective set and its
multiplier translate.  It is invariant under nonzero scalar rescaling and is exactly what the
Singer argument supplies. -/
def HasDisjointUnitCostMultiplier
    (I : Submodule 𝔽 (κ → 𝔽)) (e : V ≃ₗ[𝔽] I)
    (a : V ≃ₗ[𝔽] V) : Prop :=
  ∀ f : Module.Dual 𝔽 V, f ≠ 0 →
    ¬ (HasUnitFunctionalCost I e f ∧
      HasUnitFunctionalCost I e (f.comp a.toLinearMap))

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

end
end RepairCodes

#print axioms RepairCodes.mem_functionalDual_generalizedSPCFive_iff
#print axioms RepairCodes.exists_disjoint_translate_of_twenty_in_regular_820
#print axioms RepairCodes.generalizedSPCFive_functionalDual_full_support
#print axioms RepairCodes.generalizedSPCFive_functionalDistance_five
#print axioms RepairCodes.generalizedSPCFive_not_functionalDistance_six
#print axioms RepairCodes.generalizedSPCFive_isCoordinateSurjective
#print axioms RepairCodes.hasUnitFunctionalCost_iff_coordinate_orbit
#print axioms RepairCodes.innerCoordinateFunctional_orbit_injective
#print axioms RepairCodes.projectiveAxisTwistedCubic_twenty_unitCost_orbits
#print axioms RepairCodes.generalizedSPCFive_weightedDistance_six_of_disjoint
#print axioms RepairCodes.generalizedSPCFive_radiusFour_transfer_of_disjoint
#print axioms RepairCodes.projectiveAxisTwistedCubic_strict_weighted_transfer
