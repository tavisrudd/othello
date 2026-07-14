import RelativeConicArcs.Q25Normalization

/-!
# Exact conjugate-orbit decomposition of indexed `PG(2,25)` sets

This finite combinatorial layer turns an invariant set with two fixed points and six nonfixed
points into exactly three `OrbitCode`s.  It is independent of the arc predicate and of generated
certificate data.
-/

namespace RelativeConicArcs
namespace Q25OrbitDecomposition

open Q25Coordinates Q25PairCertificate Q25Normalization FiniteFields

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000

def IsConjInvariant (S : Finset Idx25) : Prop :=
  ∀ i ∈ S, conjIdx i ∈ S

def fixedPart (S : Finset Idx25) : Finset Idx25 :=
  S.filter fun i => conjIdx i = i

def selectedOrbits (S : Finset Idx25) : Finset OrbitCode :=
  Finset.univ.filter fun o => orbitPair o ⊆ S

def selectedOrbitUnion (S : Finset Idx25) : Finset Idx25 :=
  (selectedOrbits S).biUnion orbitPair

theorem orbitPair_pairwiseDisjoint :
    ((Finset.univ : Finset OrbitCode) : Set OrbitCode).PairwiseDisjoint orbitPair := by
  intro a _ b _ hab
  change Disjoint (orbitPair a) (orbitPair b)
  rw [Finset.disjoint_left]
  intro i hia hib
  simp only [orbitPair, Finset.mem_insert, Finset.mem_singleton] at hia hib
  have hidx : Function.Injective orbitIdx := by
    intro u v huv
    exact orbitRep_bijective.1 (Subtype.ext huv)
  rcases hia with rfl | rfl <;> rcases hib with h | h
  · exact hab (hidx h)
  · have h' := congrArg rank h
    have hback : conjIdx (orbitIdx b) = orbitIdx a := h.symm
    have hback' := congrArg rank (congrArg conjIdx hback)
    rw [conjIdx_involutive] at hback'
    have ha := orbitIdx_lt_conj a
    have hb := orbitIdx_lt_conj b
    omega
  · have h' := congrArg rank h
    have hback' := congrArg rank (congrArg conjIdx h)
    rw [conjIdx_involutive] at hback'
    have ha := orbitIdx_lt_conj a
    have hb := orbitIdx_lt_conj b
    omega
  · have h' := congrArg conjIdx h
    rw [conjIdx_involutive, conjIdx_involutive] at h'
    exact hab (hidx h')

theorem selectedOrbit_pairwiseDisjoint (S : Finset Idx25) :
    ((selectedOrbits S : Finset OrbitCode) : Set OrbitCode).PairwiseDisjoint orbitPair := by
  intro a _ b _ hab
  exact orbitPair_pairwiseDisjoint (Finset.mem_univ a) (Finset.mem_univ b) hab

theorem mem_conj_iff {S : Finset Idx25} (hS : IsConjInvariant S) (i : Idx25) :
    conjIdx i ∈ S ↔ i ∈ S := by
  constructor
  · intro hi
    have h := hS (conjIdx i) hi
    rw [conjIdx_involutive i] at h
    exact h
  · exact hS i

theorem selectedOrbitUnion_eq_nonfixed {S : Finset Idx25} (hS : IsConjInvariant S) :
    selectedOrbitUnion S = S \ fixedPart S := by
  ext i
  constructor
  · intro hi
    obtain ⟨o, hoSel, hiPair⟩ := Finset.mem_biUnion.mp hi
    have hoSub : orbitPair o ⊆ S := (Finset.mem_filter.mp hoSel).2
    apply Finset.mem_sdiff.mpr
    refine ⟨hoSub hiPair, ?_⟩
    intro hfix
    have hifixed : conjIdx i = i := (Finset.mem_filter.mp hfix).2
    simp only [orbitPair, Finset.mem_insert, Finset.mem_singleton] at hiPair
    rcases hiPair with rfl | rfl
    · have hr := congrArg rank hifixed
      exact (Nat.ne_of_lt (orbitIdx_lt_conj o)) hr.symm
    · rw [conjIdx_involutive] at hifixed
      have hr := congrArg rank hifixed
      exact (Nat.ne_of_lt (orbitIdx_lt_conj o)) hr
  · intro hi
    have hiS := (Finset.mem_sdiff.mp hi).1
    have hinon : i ≠ conjIdx i := by
      intro h
      exact (Finset.mem_sdiff.mp hi).2 (Finset.mem_filter.mpr ⟨hiS, h.symm⟩)
    obtain ⟨o, ho⟩ := exists_orbitCode_pair i hinon
    apply Finset.mem_biUnion.mpr
    refine ⟨o, ?_, ?_⟩
    · apply Finset.mem_filter.mpr
      refine ⟨Finset.mem_univ _, ?_⟩
      intro x hx
      rw [← ho] at hx
      simp only [Finset.mem_insert, Finset.mem_singleton] at hx
      rcases hx with rfl | rfl
      · exact hiS
      · exact hS i hiS
    · rw [← ho]
      simp

theorem card_selectedOrbitUnion (S : Finset Idx25) :
    (selectedOrbitUnion S).card = 2 * (selectedOrbits S).card := by
  rw [selectedOrbitUnion, Finset.card_biUnion (selectedOrbit_pairwiseDisjoint S)]
  simp_rw [card_orbitPair]
  simp [Nat.mul_comm]

theorem card_selectedOrbits_three {S : Finset Idx25} (hS : IsConjInvariant S)
    (hcard : S.card = 8) (hfixed : (fixedPart S).card = 2) :
    (selectedOrbits S).card = 3 := by
  have hsubset : fixedPart S ⊆ S := Finset.filter_subset _ _
  have hnonfixed : (S \ fixedPart S).card = 6 := by
    rw [Finset.card_sdiff, Finset.inter_eq_left.mpr hsubset, hcard, hfixed]
  have hunion := card_selectedOrbitUnion S
  rw [selectedOrbitUnion_eq_nonfixed hS, hnonfixed] at hunion
  omega

theorem eq_fixedPart_union_selectedOrbitUnion {S : Finset Idx25}
    (hS : IsConjInvariant S) :
    S = fixedPart S ∪ selectedOrbitUnion S := by
  rw [selectedOrbitUnion_eq_nonfixed hS]
  ext x
  simp [fixedPart]
  tauto

/-- An invariant eight-set with two fixed points is its fixed pair plus exactly three distinct
nonfixed conjugate pairs. -/
theorem exists_three_orbits {S : Finset Idx25} (hS : IsConjInvariant S)
    (hcard : S.card = 8) (hfixed : (fixedPart S).card = 2) :
    ∃ a b c : OrbitCode, a ≠ b ∧ a ≠ c ∧ b ≠ c ∧
      S = fixedPart S ∪ orbitPair a ∪ orbitPair b ∪ orbitPair c := by
  have hthree := card_selectedOrbits_three hS hcard hfixed
  obtain ⟨a, b, c, hab, hac, hbc, hsel⟩ := Finset.card_eq_three.mp hthree
  refine ⟨a, b, c, hab, hac, hbc, ?_⟩
  calc
    S = fixedPart S ∪ selectedOrbitUnion S := eq_fixedPart_union_selectedOrbitUnion hS
    _ = fixedPart S ∪ orbitPair a ∪ orbitPair b ∪ orbitPair c := by
      rw [selectedOrbitUnion, hsel]
      simp [Finset.union_assoc]

end Q25OrbitDecomposition
end RelativeConicArcs
