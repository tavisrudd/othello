import RelativeConicArcs.BaerArithmetic
import RelativeConicArcs.QuadraticGlobalCount

/-!
# Alternate-orbit repair for Frobenius-invariant arcs

Deleting a selected nonfixed Frobenius orbit from an invariant ten-arc leaves an invariant
eight-arc.  The semantic global legal-pair finset then counts all possible conjugate-orbit
repairs, including restoration of the deleted orbit; removing that one element gives the
alternate repairs.
-/

namespace RelativeConicArcs
namespace AlternateOrbitRepair

noncomputable section

open Configuration Finset
open FiniteGeom.BaerCompletion
open QuadraticFrobenius QuadraticLineCounting QuadraticForbidden QuadraticGlobalCount

variable (F E : Type) [Field F] [Fintype F] [Field E] [Finite E] [Algebra F E]
  [Algebra.IsAlgebraic F E]

abbrev Point := ProjectiveConjugation.Point E

local instance : Fintype E := Fintype.ofFinite E
local instance : DecidableEq E := Classical.decEq E
local instance : DecidableEq (Point E) := Classical.decEq _
local instance : DecidableEq (FixedProjectivePoint F E) := Classical.decEq _
local instance : DecidableRel fun p l : Point E => p.orthogonal l := Classical.decRel _

/-- An unordered pair which is exactly one nonfixed quadratic-Frobenius point orbit. -/
def IsNonfixedFrobeniusOrbit (hdeg : Module.finrank F E = 2)
    (q : Sym2 (Point E)) : Prop :=
  ∃ p : Point E,
    (incidence F E hdeg).pointConj p ≠ p ∧
      q = s(p, (incidence F E hdeg).pointConj p)

/-- A nonfixed Frobenius orbit selected inside `A`. -/
def IsSelectedNonfixedOrbit (hdeg : Module.finrank F E = 2)
    (A : Finset (Point E)) (q : Sym2 (Point E)) : Prop :=
  IsNonfixedFrobeniusOrbit F E hdeg q ∧ q.toFinset ⊆ A

/-- All selected nonfixed Frobenius orbits of `A`, represented as unordered pairs. -/
noncomputable def selectedNonfixedOrbits (hdeg : Module.finrank F E = 2)
    (A : Finset (Point E)) : Finset (Sym2 (Point E)) := by
  classical
  exact Finset.univ.filter (IsSelectedNonfixedOrbit F E hdeg A)

theorem mem_selectedNonfixedOrbits_iff (hdeg : Module.finrank F E = 2)
    (A : Finset (Point E)) (q : Sym2 (Point E)) :
    q ∈ selectedNonfixedOrbits F E hdeg A ↔ IsSelectedNonfixedOrbit F E hdeg A q := by
  classical
  simp [selectedNonfixedOrbits]

/-- Delete both endpoints of an unordered orbit. -/
def deleteOrbit (A : Finset (Point E)) (q : Sym2 (Point E)) : Finset (Point E) :=
  A \ q.toFinset

/-- Legal conjugate-pair repairs after deletion, excluding restoration of the deleted orbit. -/
noncomputable def alternateLegalPairs (hdeg : Module.finrank F E = 2)
    (A : Finset (Point E)) (q : Sym2 (Point E)) : Finset (Sym2 (Point E)) :=
  globalLegalPairs F E hdeg (deleteOrbit E A q) \ {q}

theorem card_orbit_of_isNonfixedFrobeniusOrbit (hdeg : Module.finrank F E = 2)
    {q : Sym2 (Point E)} (hq : IsNonfixedFrobeniusOrbit F E hdeg q) :
    q.toFinset.card = 2 := by
  obtain ⟨p, hp, rfl⟩ := hq
  simp [Sym2.toFinset_mk_eq, Ne.symm hp]

theorem invariant_orbit_of_isNonfixedFrobeniusOrbit (hdeg : Module.finrank F E = 2)
    {q : Sym2 (Point E)} (hq : IsNonfixedFrobeniusOrbit F E hdeg q) :
    IsInvariant (incidence F E hdeg) q.toFinset := by
  obtain ⟨p, _hp, rfl⟩ := hq
  unfold IsInvariant
  rw [Sym2.toFinset_mk_eq, Finset.map_insert, Finset.map_singleton]
  simp only [Equiv.toEmbedding_apply]
  rw [(incidence F E hdeg).point_involutive p]
  exact Finset.pair_comm _ _

theorem invariant_deleteOrbit (hdeg : Module.finrank F E = 2)
    {A : Finset (Point E)} (hA : IsInvariant (incidence F E hdeg) A)
    {q : Sym2 (Point E)} (hq : IsNonfixedFrobeniusOrbit F E hdeg q) :
    IsInvariant (incidence F E hdeg) (deleteOrbit E A q) := by
  unfold deleteOrbit
  have hqInv := invariant_orbit_of_isNonfixedFrobeniusOrbit F E hdeg hq
  unfold IsInvariant at hA hqInv ⊢
  rw [Finset.map_sdiff, hA, hqInv]

/-- Deleting a selected nonfixed orbit from an invariant ten-arc leaves an invariant eight-arc,
and the deleted orbit itself is one member of the semantic legal-pair finset of the remainder. -/
theorem delete_selected_nonfixed_orbit (hdeg : Module.finrank F E = 2)
    (A : Finset (Point E)) (hArc : Arc (L := Point E) A)
    (hA : IsInvariant (incidence F E hdeg) A) (hcard : A.card = 10)
    (q : Sym2 (Point E)) (hq : IsSelectedNonfixedOrbit F E hdeg A q) :
    Arc (L := Point E) (deleteOrbit E A q) ∧
      IsInvariant (incidence F E hdeg) (deleteOrbit E A q) ∧
      (deleteOrbit E A q).card = 8 ∧
      q ∈ globalLegalPairs F E hdeg (deleteOrbit E A q) := by
  classical
  refine ⟨arc_mono Finset.sdiff_subset hArc,
    invariant_deleteOrbit F E hdeg hA hq.1, ?_, ?_⟩
  · rw [deleteOrbit, Finset.card_sdiff_of_subset hq.2,
      card_orbit_of_isNonfixedFrobeniusOrbit F E hdeg hq.1, hcard]
  · rw [mem_globalLegalPairs_iff]
    refine ⟨?_, ?_⟩
    · obtain ⟨p, hp, hpq⟩ := hq.1
      refine ⟨p, hp, hpq, ?_⟩
      subst q
      change Disjoint s(p, (incidence F E hdeg).pointConj p).toFinset
        (A \ s(p, (incidence F E hdeg).pointConj p).toFinset)
      exact disjoint_sdiff_self_left.symm
    · unfold deleteOrbit
      rw [Finset.sdiff_union_of_subset hq.2]
      exact hArc

/-- The selected nonfixed points of an invariant set split into two-element unordered orbits. -/
theorem card_eq_fixed_add_two_mul_nonfixedOrbits (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hC : IsInvariant (incidence F E hdeg) C) :
    C.card = (fixedArcPoints F E C).card +
      2 * Nat.card (ConjugateInvariantArcPair F E C hC) := by
  classical
  let S : Finset (NonfixedArcPoint F E C) := Finset.univ
  let T : Finset (ConjugateInvariantArcPair F E C hC) := Finset.univ
  have hfiber : ∀ q ∈ T,
      (S.filter fun p => selectedOrbitPair F E C hC p = q).card = 2 := by
    intro q _hq
    obtain ⟨p, hp⟩ := selectedOrbitPair_surjective F E C hC q
    subst q
    exact selectedOrbitPair_fiber_card F E C hC p
  have hmul := card_eq_card_mul_of_constant_fibers S T
    (selectedOrbitPair F E C hC) 2 (fun _ _ => Finset.mem_univ _) hfiber
  have hS : S.card = C.card - (fixedArcPoints F E C).card := by
    change (Finset.univ : Finset (NonfixedArcPoint F E C)).card =
      C.card - (fixedArcPoints F E C).card
    rw [Finset.card_univ, ← Nat.card_eq_fintype_card,
      natCard_nonfixedArcPoint F E C]
  have hT : T.card = Nat.card (ConjugateInvariantArcPair F E C hC) := by
    change (Finset.univ : Finset (ConjugateInvariantArcPair F E C hC)).card = _
    rw [Finset.card_univ, ← Nat.card_eq_fintype_card]
  have hfixed : (fixedArcPoints F E C).card ≤ C.card :=
    Finset.card_le_card (Finset.filter_subset _ _)
  rw [hS, hT] at hmul
  omega

/-- An invariant eight-arc over a subfield of order at least seven has an empty fixed carrier. -/
theorem one_le_baerEmptyLineCount_of_eight {s f e : ℕ} (hs : 7 ≤ s)
    (hprofile : 8 = f + 2 * e) : 1 ≤ baerEmptyLineCount s f e := by
  have hf : f ≤ 8 := by omega
  have he : e ≤ 4 := by omega
  have hoccupied :
      f * (s + 1) - f.choose 2 + e ≤ 8 * (s + 1) - 28 := by
    interval_cases f <;> interval_cases e
    all_goals norm_num [Nat.choose] at hprofile
    all_goals norm_num [Nat.choose]
    all_goals omega
  have hseven : 7 * s ≤ s * s := Nat.mul_le_mul_right s hs
  have hworst :
      1 ≤ s * s + s + 1 - (8 * (s + 1) - 28) := by
    omega
  exact hworst.trans (Nat.sub_le_sub_left hoccupied _)

/-- The exact quadratic carrier count gives a lower bound for the semantic global pair finset. -/
theorem quadratic_global_pair_lowerBound (hdeg : Module.finrank F E = 2)
    (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) (k f e : ℕ)
    (hkcard : C.card = k) (hf : (fixedArcPoints F E C).card = f)
    (horbit : k = f + 2 * e) :
    baerEmptyLineCount (Nat.card F) f e *
        (((Nat.card F * Nat.card F - Nat.card F) / 2) -
          baerNonInvariantSecantOrbits k f e) ≤
      (globalLegalPairs F E hdeg C).card := by
  rw [card_globalLegalPairs_eq_legalCount F E hdeg C hArc hC k f e hkcard hf horbit]
  exact quadraticBaer_pairExtension_lowerBound
    (coordinateQuadraticExtensionData F E hdeg C hArc hC k f e hkcard hf horbit)

/-- Every invariant eight-arc over a quadratic extension whose base has order at least seven has
at least nine fresh legal Frobenius-orbit extensions. -/
theorem nine_le_card_globalLegalPairs_of_card_eight (hdeg : Module.finrank F E = 2)
    (hs : 7 ≤ Nat.card F) (C : Finset (Point E)) (hArc : Arc (L := Point E) C)
    (hC : IsInvariant (incidence F E hdeg) C) (hcard : C.card = 8) :
    9 ≤ (globalLegalPairs F E hdeg C).card := by
  let f := (fixedArcPoints F E C).card
  let e := Nat.card (ConjugateInvariantArcPair F E C hC)
  have hprofile : 8 = f + 2 * e := by
    calc
      8 = C.card := hcard.symm
      _ = (fixedArcPoints F E C).card +
          2 * Nat.card (ConjugateInvariantArcPair F E C hC) :=
        card_eq_fixed_add_two_mul_nonfixedOrbits F E hdeg C hC
      _ = f + 2 * e := rfl
  have hempty : 1 ≤ baerEmptyLineCount (Nat.card F) f e :=
    one_le_baerEmptyLineCount_of_eight hs hprofile
  have horbits : baerNonInvariantSecantOrbits 8 f e ≤ 12 :=
    baerNonInvariantSecantOrbits_le_twelve_of_eight hprofile
  have hcandidates : 21 ≤ (Nat.card F * Nat.card F - Nat.card F) / 2 := by
    rw [Nat.le_div_iff_mul_le (by omega : 0 < 2)]
    have h42 : Nat.card F + 42 ≤ Nat.card F * Nat.card F := by
      nlinarith
    omega
  have hsurplus :
      9 ≤ ((Nat.card F * Nat.card F - Nat.card F) / 2) -
        baerNonInvariantSecantOrbits 8 f e := by
    omega
  have hproduct :
      9 ≤ baerEmptyLineCount (Nat.card F) f e *
        (((Nat.card F * Nat.card F - Nat.card F) / 2) -
          baerNonInvariantSecantOrbits 8 f e) := by
    calc
      9 = 1 * 9 := by norm_num
      _ ≤ baerEmptyLineCount (Nat.card F) f e *
          (((Nat.card F * Nat.card F - Nat.card F) / 2) -
            baerNonInvariantSecantOrbits 8 f e) :=
        Nat.mul_le_mul hempty hsurplus
  exact hproduct.trans (quadratic_global_pair_lowerBound F E hdeg C hArc hC
    8 f e hcard rfl hprofile)

/-- After deleting a selected orbit from an invariant ten-arc, at least nine legal repairs remain
when the base-field order is at least seven. -/
theorem nine_le_globalLegalPairs_after_deletion (hdeg : Module.finrank F E = 2)
    (hs : 7 ≤ Nat.card F) (A : Finset (Point E)) (hArc : Arc (L := Point E) A)
    (hA : IsInvariant (incidence F E hdeg) A) (hcard : A.card = 10)
    (q : Sym2 (Point E)) (hq : IsSelectedNonfixedOrbit F E hdeg A q) :
    9 ≤ (globalLegalPairs F E hdeg (deleteOrbit E A q)).card := by
  obtain ⟨hArcD, hInvD, hcardD, _hqD⟩ :=
    delete_selected_nonfixed_orbit F E hdeg A hArc hA hcard q hq
  exact nine_le_card_globalLegalPairs_of_card_eight F E hdeg hs
    (deleteOrbit E A q) hArcD hInvD hcardD

theorem pred_le_card_alternateLegalPairs {n : ℕ} (hdeg : Module.finrank F E = 2)
    {A : Finset (Point E)} {q : Sym2 (Point E)}
    (hq : q ∈ globalLegalPairs F E hdeg (deleteOrbit E A q))
    (hcount : n + 1 ≤ (globalLegalPairs F E hdeg (deleteOrbit E A q)).card) :
    n ≤ (alternateLegalPairs F E hdeg A q).card := by
  unfold alternateLegalPairs
  rw [Finset.card_sdiff_of_subset (Finset.singleton_subset_iff.mpr hq)]
  simp only [Finset.card_singleton]
  omega

/-- **Certificate-free alternate-orbit repair.** Deleting any selected nonfixed orbit from an
invariant ten-arc leaves at least eight legal conjugate orbits different from the deleted one. -/
theorem eight_le_alternateLegalPairs_of_seven_le (hdeg : Module.finrank F E = 2)
    (hs : 7 ≤ Nat.card F) (A : Finset (Point E)) (hArc : Arc (L := Point E) A)
    (hA : IsInvariant (incidence F E hdeg) A) (hcard : A.card = 10)
    (q : Sym2 (Point E)) (hq : IsSelectedNonfixedOrbit F E hdeg A q) :
    8 ≤ (alternateLegalPairs F E hdeg A q).card := by
  have hqD := (delete_selected_nonfixed_orbit F E hdeg A hArc hA hcard q hq).2.2.2
  apply pred_le_card_alternateLegalPairs F E hdeg hqD
  exact nine_le_globalLegalPairs_after_deletion F E hdeg hs A hArc hA hcard q hq

end
end AlternateOrbitRepair
end RelativeConicArcs
