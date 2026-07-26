import RepairPorts.PointedTransfer
import RepairPorts.MDSReconstruction
import RepairCodes.TraceDual

/-!
# Repeated coefficient ports from outer families

Let `L/K` be a finite separable extension, let an inner `K`-linear code have message space `L`,
and concatenate it with an `L`-linear outer code.  Trace duality transports the ordinary
extension-field dual-distance bound to the coordinate-free functional dual.  Once that distance
is at least `r + 2`, every nonzero functional sector lies above the radius-`r` pointed range.
The only remaining obstruction is the fixed zero-functional inner cost.

Consequently, whenever the pointed zero-functional cost is at least `r + 2`, every outer block
contains an exact zero-extended copy of the inner radius-`r` support and normalized coefficient
ports.  The selected inner coordinate occupies one coordinate in every block, so these copies have
exact coordinate density the reciprocal of the inner block length.

The finite theorem is the complete formal consequence used by asymptotic constructions.  Existence
of outer families with positive rate, positive distance, and dual distance tending to infinity is
a separate classical coding-theory input.
-/

namespace RepairPorts

open Finset FiniteGeom RepairCodes

variable {K L ι κ : Type*}
variable [Field K] [DecidableEq K] [Field L] [DecidableEq L]
variable [Algebra K L] [FiniteDimensional K L] [Algebra.IsSeparable K L]
variable [Fintype ι] [DecidableEq ι] [Fintype κ] [DecidableEq κ]

/-- The embedding of the outer block indices as all occurrences of one fixed inner coordinate. -/
def fixedInnerCoordinateEmbedding (x : κ) : ι ↪ ι × κ where
  toFun j := (j, x)
  inj' := fun _ _ h => congrArg Prod.fst h

/-- All concatenated-code coordinates carrying the fixed inner coordinate `x`. -/
def representedTargets (x : κ) : Finset (ι × κ) :=
  Finset.univ.map (fixedInnerCoordinateEmbedding x)

omit [DecidableEq ι] [Fintype κ] [DecidableEq κ] in
/-- There is exactly one represented target in every outer block. -/
@[simp]
theorem card_representedTargets (x : κ) :
    (representedTargets x : Finset (ι × κ)).card = Fintype.card ι := by
  simp [representedTargets]

omit [DecidableEq ι] [DecidableEq κ] in
/-- Cross-multiplied density statement: the represented targets have density exactly the
reciprocal of the inner block length among all concatenated coordinates. -/
theorem representedTargets_density (x : κ) :
    (representedTargets x : Finset (ι × κ)).card * Fintype.card κ =
      Fintype.card (ι × κ) := by
  simp [Fintype.card_prod]

omit [DecidableEq K] [FiniteDimensional K L] [Algebra.IsSeparable K L]
  [DecidableEq ι] in
/-- Restricting the outer code's scalars does not change its nonzero words or their symbol
supports. -/
theorem symbolMinDist_restrictScalars (O : Submodule L (ι → L)) :
    symbolMinDist (O.restrictScalars K) = symbolMinDist O := by
  rfl

omit [Algebra.IsSeparable K L] [DecidableEq ι] [DecidableEq κ] in
/-- Concatenation with an extension-field outer code multiplies its extension-field dimension by
the extension degree and obeys the usual multiplicative distance lower bound. -/
theorem concatenatedRestrictedCode_parameters
    (I : Submodule K (κ → K)) (e : L ≃ₗ[K] I)
    (O : Submodule L (ι → L)) (hO : O ≠ ⊥) :
    Module.finrank K (concatenatedCode I e (O.restrictScalars K)) =
        Module.finrank K L * Module.finrank L O ∧
      minDist I * symbolMinDist O ≤
        minDist (concatenatedCode I e (O.restrictScalars K)) := by
  constructor
  · rw [concatenatedCode_finrank]
    exact (Module.finrank_mul_finrank (F := K) (K := L) (A := O)).symm
  · rw [← symbolMinDist_restrictScalars (K := K) O]
    apply concatenatedCode_minDist_lower
    intro hbot
    apply hO
    ext u
    constructor
    · intro hu
      have huK : u ∈ O.restrictScalars K := hu
      rw [hbot] at huK
      simpa using huK
    · rintro rfl
      exact O.zero_mem

omit [FiniteDimensional K L] [Algebra.IsSeparable K L] in
/-- A weighted functional-dual lower bound also bounds the exact pointed cost of every nonzero
functional sector. -/
theorem le_nonzeroOuterPointedFiberCost_of_weighted
    (I : Submodule K (κ → K)) (e : L ≃ₗ[K] I)
    (O : Submodule K (ι → L)) (j : ι) (x : κ) (d : ℕ)
    (hweighted : HasWeightedFunctionalDualDistanceAtLeast I e O d) :
    (d : WithTop ℕ) ≤ nonzeroOuterPointedFiberCost I e O j x := by
  rw [← nonzeroOuterPointedRealizationCost_eq_fiberCost]
  apply le_sInf
  intro n hn
  obtain ⟨beta, hbeta, hbeta0, rfl⟩ := hn
  apply le_sInf
  intro m hm
  obtain ⟨w, hw, -, rfl⟩ := hm
  exact_mod_cast hweighted beta hbeta hbeta0 w hw

/-- Once the ordinary outer dual distance clears the bounded range, pointed confinement is
equivalent to the single fixed inner zero-functional cost. -/
theorem pointedConfinement_iff_zeroCost_of_outerDualDistance
    (I : Submodule K (κ → K)) (e : L ≃ₗ[K] I)
    (O : Submodule L (ι → L)) (j : ι) (x : κ) (r : ℕ)
    (hother : ∃ l, l ≠ j)
    (hdual : r + 2 ≤ dualDist O) :
    HasPointedNonembeddedDualDistanceAtLeast
        I e (O.restrictScalars K) j x (r + 2) ↔
      ((r + 2 : ℕ) : WithTop ℕ) ≤ pointedZeroFunctionalCost I e x := by
  have hfunctional :
      HasFunctionalDualDistanceAtLeast (O.restrictScalars K) (r + 2) :=
    hasFunctionalDualDistanceAtLeast_restrictScalars O (r + 2) hdual
  have hweighted :
      HasWeightedFunctionalDualDistanceAtLeast I e (O.restrictScalars K) (r + 2) :=
    hasWeightedFunctionalDualDistanceAtLeast_of_functionalDistance
      I e (O.restrictScalars K) (r + 2) hfunctional
  have hnonzero :
      ((r + 2 : ℕ) : WithTop ℕ) ≤
        nonzeroOuterPointedFiberCost I e (O.restrictScalars K) j x :=
    le_nonzeroOuterPointedFiberCost_of_weighted
      I e (O.restrictScalars K) j x (r + 2) hweighted
  rw [hasPointedNonembeddedDualDistanceAtLeast_iff_le_pointedCost,
    pointedNonembeddedCost_eq_min_closed_nonzero,
    zeroFunctionalPointedClosedCost_eq_pointedZeroFunctionalCost I e j x hother]
  constructor
  · exact fun h => h.trans (min_le_left _ _)
  · intro hzero
    exact le_min hzero hnonzero

/-- **Finite prescribed-port theorem.**  An outer dual-distance bound removes every nonzero
functional obstruction.  If the fixed pointed zero-functional cost is also above the bounded
range, every block carries exact copies of both the inner support port and its normalized
coefficient port. -/
theorem prescribedPorts_of_outerDualDistance
    (I : Submodule K (κ → K)) (e : L ≃ₗ[K] I)
    (O : Submodule L (ι → L)) (j : ι) (x : κ) (r : ℕ)
    (hother : ∃ l, l ≠ j)
    (hdual : r + 2 ≤ dualDist O)
    (hzero : ((r + 2 : ℕ) : WithTop ℕ) ≤ pointedZeroFunctionalCost I e x) :
    repairHypergraph (concatenatedCode I e (O.restrictScalars K)) (j, x) r =
        embedHypergraph (blockEmbedding j) (repairHypergraph I x r) ∧
      coefficientPort (concatenatedCode I e (O.restrictScalars K)) (j, x) r =
        (fun z => singleBlockWord j z) '' coefficientPort I x r := by
  have hpointed :=
    (pointedConfinement_iff_zeroCost_of_outerDualDistance
      I e O j x r hother hdual).2 hzero
  exact ⟨repairHypergraph_concatenatedCode_eq_embed_pointed
      I e (O.restrictScalars K) r j x hpointed,
    coefficientPort_concatenatedCode_eq_image_pointed
      I e (O.restrictScalars K) j x r hpointed⟩

/-- The exact outer-family hypothesis consumed by eventual prescribed-port transfer. -/
def OuterDualDistanceTendsToInfinity
    (O : ∀ N : ℕ, Submodule L (Fin N → L)) : Prop :=
  ∀ d : ℕ, ∃ N₀ : ℕ, ∀ N, N₀ ≤ N → d ≤ dualDist (O N)

/-- The paper's necessity-and-sufficiency statement: eventually, the fixed pointed inner
zero-functional cost is the only bounded-confinement gate at every block. -/
theorem eventually_pointedConfinement_iff_zeroCost
    (I : Submodule K (κ → K)) (e : L ≃ₗ[K] I)
    (O : ∀ N : ℕ, Submodule L (Fin N → L))
    (hdual : OuterDualDistanceTendsToInfinity O)
    (x : κ) (r : ℕ) :
    ∃ N₀ : ℕ, ∀ N, N₀ ≤ N → ∀ j : Fin N,
      HasPointedNonembeddedDualDistanceAtLeast
          I e ((O N).restrictScalars K) j x (r + 2) ↔
        ((r + 2 : ℕ) : WithTop ℕ) ≤ pointedZeroFunctionalCost I e x := by
  obtain ⟨N₁, hN₁⟩ := hdual (r + 2)
  refine ⟨max 2 N₁, ?_⟩
  intro N hN j
  have hNtwo : 2 ≤ N := le_trans (le_max_left 2 N₁) hN
  have hNN₁ : N₁ ≤ N := le_trans (le_max_right 2 N₁) hN
  have hother : ∃ l : Fin N, l ≠ j := by
    by_cases hj : j = ⟨0, by omega⟩
    · refine ⟨⟨1, by omega⟩, ?_⟩
      subst j
      simp
    · exact ⟨⟨0, by omega⟩, fun h => hj h.symm⟩
  exact pointedConfinement_iff_zeroCost_of_outerDualDistance
    I e (O N) j x r hother (hN₁ N hNN₁)

/-- **Eventual prescribed-port theorem.**  If the outer dual distances tend to infinity and the
fixed inner zero-functional cost clears radius `r`, then every sufficiently long concatenation
contains the exact inner support and coefficient ports at all copies of the selected coordinate. -/
theorem eventually_prescribedPorts
    (I : Submodule K (κ → K)) (e : L ≃ₗ[K] I)
    (O : ∀ N : ℕ, Submodule L (Fin N → L))
    (hdual : OuterDualDistanceTendsToInfinity O)
    (x : κ) (r : ℕ)
    (hzero : ((r + 2 : ℕ) : WithTop ℕ) ≤ pointedZeroFunctionalCost I e x) :
    ∃ N₀ : ℕ, ∀ N, N₀ ≤ N → ∀ j : Fin N,
      repairHypergraph
          (concatenatedCode I e ((O N).restrictScalars K)) (j, x) r =
          embedHypergraph (blockEmbedding j) (repairHypergraph I x r) ∧
        coefficientPort
            (concatenatedCode I e ((O N).restrictScalars K)) (j, x) r =
          (fun z => singleBlockWord j z) '' coefficientPort I x r := by
  obtain ⟨N₁, hN₁⟩ := hdual (r + 2)
  refine ⟨max 2 N₁, ?_⟩
  intro N hN j
  have hNtwo : 2 ≤ N := le_trans (le_max_left 2 N₁) hN
  have hNN₁ : N₁ ≤ N := le_trans (le_max_right 2 N₁) hN
  have hother : ∃ l : Fin N, l ≠ j := by
    by_cases hj : j = ⟨0, by omega⟩
    · refine ⟨⟨1, by omega⟩, ?_⟩
      subst j
      simp
    · exact ⟨⟨0, by omega⟩, fun h => hj h.symm⟩
  exact prescribedPorts_of_outerDualDistance
    I e (O N) j x r hother (hN₁ N hNN₁) hzero

/-- For an MDS inner code, the pointed zero-functional cost is exactly twice the minimum dual
weight.  In the `[n,k]` convention used here this is `2 * (k + 1)`. -/
theorem HasMDSDualParameters.pointedZeroFunctionalCost_eq
    (I : Submodule K (κ → K)) (e : L ≃ₗ[K] I)
    (k : ℕ) (hMDS : HasMDSDualParameters I k) (x : κ) :
    pointedZeroFunctionalCost I e x = ((2 * (k + 1) : ℕ) : WithTop ℕ) := by
  classical
  let D := dualCode I
  let H := (Finset.univ : Finset κ).erase x
  haveI : Nontrivial D := Submodule.nontrivial_iff_ne_bot.mpr hMDS.dual_ne_bot
  have hdimpos : 0 < Module.finrank K D := Module.finrank_pos
  have hkcard : k < Fintype.card κ := by
    have hdim := hMDS.dual_finrank_add
    have hdimpos' : 0 < Module.finrank K (dualCode I) := by
      simpa [D] using hdimpos
    omega
  have hkH : k ≤ H.card := by
    have hxuniv : x ∈ (Finset.univ : Finset κ) := Finset.mem_univ x
    simp only [H, Finset.card_erase_of_mem hxuniv, Finset.card_univ]
    omega
  obtain ⟨R, hRsub, hRcard⟩ :=
    Finset.exists_subset_card_eq (s := H) (n := k) hkH
  have hxR : x ∉ R := by
    intro hxR
    exact (Finset.mem_erase.mp (hRsub hxR)).1 rfl
  have hTcard : (insert x R).card = k + 1 := by
    rw [Finset.card_insert_of_notMem hxR, hRcard]
  obtain ⟨y, hydual, hyx, hysupport⟩ :=
    hMDS.exists_normalized_word hTcard (Finset.mem_insert_self x R)
  have hynorm : hammingNorm y = k + 1 := by
    rw [← card_wordSupport, hysupport, hTcard]
  have hdualDist : dualDist I = k + 1 := by
    apply le_antisymm
    · calc
        dualDist I ≤ hammingNorm y :=
          dualDist_le_hammingNorm hydual (by
            intro hy0
            have := congrFun hy0 x
            simp [hyx] at this)
        _ = k + 1 := hynorm
    · exact hMDS.dual_distance
  have hpoint :
      pointedFunctionalFiberCost I e x 0 = ((k + 1 : ℕ) : WithTop ℕ) := by
    apply le_antisymm
    · have hle := pointedFunctionalFiberCost_le I e x 0 y
          ⟨(blockFunctional_eq_zero_iff I e y).2 hydual, by simp [hyx]⟩
      simpa [hynorm] using hle
    · rw [← hdualDist]
      exact dualDist_le_pointedFunctionalFiberCost_zero I e x
  rw [pointedZeroFunctionalCost, if_pos hMDS.dual_ne_bot, hpoint, hdualDist,
    Nat.cast_mul]
  norm_num [two_mul]

/-- **Positive-density MDS coefficient fingerprints.**  The minimum coefficient port of a
positive-dimensional MDS inner code reconstructs that code, has the generic complete uniform
support clutter, and occurs exactly at every copy of the selected inner coordinate throughout any
outer family whose dual distance tends to infinity. -/
theorem eventually_mdsMinimumCoefficientFingerprints
    (I : Submodule K (κ → K)) (e : L ≃ₗ[K] I)
    (k : ℕ) (hMDS : HasMDSDualParameters I k) (hk : 1 ≤ k)
    (O : ∀ N : ℕ, Submodule L (Fin N → L))
    (hdual : OuterDualDistanceTendsToInfinity O)
    (x : κ) :
    ∃ N₀ : ℕ, ∀ N, N₀ ≤ N → ∀ j : Fin N,
      repairHypergraph
          (concatenatedCode I e ((O N).restrictScalars K)) (j, x) k =
          embedHypergraph (blockEmbedding j) (repairHypergraph I x k) ∧
        coefficientPort
            (concatenatedCode I e ((O N).restrictScalars K)) (j, x) k =
          (fun z => singleBlockWord j z) '' coefficientPort I x k ∧
        ReconstructsAt I x k ∧
        repairHypergraph I x k = (Finset.univ.erase x).powersetCard k := by
  have hnat : k + 2 ≤ 2 * dualDist I := by
    have hd := hMDS.dual_distance
    omega
  have hzero :
      ((k + 2 : ℕ) : WithTop ℕ) ≤ pointedZeroFunctionalCost I e x :=
    (WithTop.coe_le_coe.mpr hnat).trans
      (two_mul_dualDist_le_pointedZeroFunctionalCost I e x hMDS.dual_ne_bot)
  obtain ⟨N₀, hN₀⟩ := eventually_prescribedPorts I e O hdual x k hzero
  refine ⟨N₀, ?_⟩
  intro N hN j
  obtain ⟨hsupport, hcoefficient⟩ := hN₀ N hN j
  exact ⟨hsupport, hcoefficient, hMDS.reconstructsAt hk x,
    hMDS.repairHypergraph_eq_powersetCard x⟩

#print axioms RepairPorts.card_representedTargets
#print axioms RepairPorts.representedTargets_density
#print axioms RepairPorts.symbolMinDist_restrictScalars
#print axioms RepairPorts.concatenatedRestrictedCode_parameters
#print axioms RepairPorts.le_nonzeroOuterPointedFiberCost_of_weighted
#print axioms RepairPorts.pointedConfinement_iff_zeroCost_of_outerDualDistance
#print axioms RepairPorts.prescribedPorts_of_outerDualDistance
#print axioms RepairPorts.eventually_pointedConfinement_iff_zeroCost
#print axioms RepairPorts.eventually_prescribedPorts
#print axioms RepairPorts.HasMDSDualParameters.pointedZeroFunctionalCost_eq
#print axioms RepairPorts.eventually_mdsMinimumCoefficientFingerprints

end RepairPorts
