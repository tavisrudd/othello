import RelativeConicArcs.Q25PairResult
import RelativeConicArcs.Q25ProfileFour
import RelativeConicArcs.Q25ProfileZero

/-!
# Uniform invariant eight-arc extension over `PG(2,25)`

The profile split is exhaustive: selected nonfixed points occur in conjugate pairs, so the number
of selected fixed points is one of `0,2,4,6,8`.  The first three cases use the profile-specific
theorems; the last two satisfy the original strict first-order orbit bound.
-/

namespace RelativeConicArcs
namespace Q25AllProfiles

noncomputable section

open Configuration Finset
open FiniteGeom.BaerCompletion
open QuadraticFrobenius QuadraticLineCounting QuadraticForbidden
open Q25Coordinates Q25PairResult FiniteFields

local instance : Fintype K25 := Fintype.ofFinite _
local instance : Fintype Point25 := Fintype.ofFinite _
local instance : DecidableEq Point25 := Classical.decEq _
local instance : DecidableRel fun p l : Point25 => p.orthogonal l := Classical.decRel _

theorem f5_card : Nat.card F5 = 5 := by
  rw [Nat.card_eq_fintype_card]
  norm_num [F5]

/-- Package the original first-order quadratic criterion in the same paper-facing fresh-pair
form used by the exceptional profile theorems. -/
theorem strict_profile_pair_extension
    (C : Finset Point25) (hArc : Arc (L := Point25) C)
    (hC : IsInvariant (incidence F5 K25 gf25_degree) C)
    (f e : ℕ) (hcard : C.card = 8) (hfixed : (fixedArcPoints F5 K25 C).card = f)
    (hprofile : 8 = f + 2 * e)
    (hempty : 0 < baerEmptyLineCount 5 f e)
    (horbits : baerNonInvariantSecantOrbits 8 f e < 10) :
    ∃ p : Point25,
      (incidence F5 K25 gf25_degree).pointConj p ≠ p ∧
      p ∉ C ∧ (incidence F5 K25 gf25_degree).pointConj p ∉ C ∧
      Arc (L := Point25)
        (C ∪ {p, (incidence F5 K25 gf25_degree).pointConj p}) := by
  obtain ⟨m, q, hm, hq, hArcq⟩ := exists_quadratic_pair_extension
    F5 K25 gf25_degree C hArc hC 8 f e hcard hfixed hprofile
    (by simpa [f5_card] using hempty) (by simpa [f5_card] using horbits)
  let mm : {m // m ∈ emptyFixedLines F5 K25 C} := ⟨m, hm⟩
  obtain ⟨p, hpq⟩ := (mem_candidates_iff_exists F5 K25 gf25_degree m q).mp hq
  have hdisjoint := candidate_disjoint_arc F5 K25 gf25_degree C mm q hq
  have hpmem : p.1.1 ∈ q.toFinset := by
    rw [← hpq]
    simp [matePair]
  have hmateMem : (incidence F5 K25 gf25_degree).pointConj p.1.1 ∈ q.toFinset := by
    rw [← hpq]
    apply Sym2.mem_toFinset.mpr
    rw [← Sym2.mem_iff_mem, matePair, Sym2.mem_iff']
    right
    rfl
  refine ⟨p.1.1, p.2, ?_, ?_, ?_⟩
  · exact fun hpC => (Finset.disjoint_left.mp hdisjoint) hpmem hpC
  · exact fun hpC => (Finset.disjoint_left.mp hdisjoint) hmateMem hpC
  · rw [← hpq] at hArcq
    change Arc (L := Point25) (C ∪
      {p.1.1, ProjectiveConjugation.projectiveEquiv
        (frobeniusRingEquiv F5 K25) p.1.1})
    simpa [matePair, nonfixedMate, Sym2.toFinset_mk_eq] using hArcq

/-- Every Frobenius-invariant eight-arc in `PG(2,25)` admits a fresh conjugate-pair extension. -/
theorem pair_extension
    (C : Finset Point25) (hArc : Arc (L := Point25) C)
    (hC : IsInvariant (incidence F5 K25 gf25_degree) C)
    (hcard : C.card = 8) :
    ∃ p : Point25,
      (incidence F5 K25 gf25_degree).pointConj p ≠ p ∧
      p ∉ C ∧ (incidence F5 K25 gf25_degree).pointConj p ∉ C ∧
      Arc (L := Point25)
        (C ∪ {p, (incidence F5 K25 gf25_degree).pointConj p}) := by
  classical
  let f := (fixedArcPoints F5 K25 C).card
  have hfle : f ≤ 8 := by
    dsimp [f]
    exact (Finset.card_le_card (Finset.filter_subset _ _)).trans_eq hcard
  have hnon : Nat.card (NonfixedArcPoint F5 K25 C) = 8 - f := by
    rw [natCard_nonfixedArcPoint F5 K25 C, hcard]
  let S : Finset (NonfixedArcPoint F5 K25 C) := Finset.univ
  let T : Finset (ConjugateInvariantArcPair F5 K25 C hC) := Finset.univ
  have hfiber : ∀ q ∈ T,
      (S.filter fun p => selectedOrbitPair F5 K25 C hC p = q).card = 2 := by
    intro q _hq
    obtain ⟨p, hp⟩ := selectedOrbitPair_surjective F5 K25 C hC q
    subst q
    exact selectedOrbitPair_fiber_card F5 K25 C hC p
  have hmul := card_eq_card_mul_of_constant_fibers S T
    (selectedOrbitPair F5 K25 C hC) 2 (fun _ _ => Finset.mem_univ _) hfiber
  have hparity : 8 - f = T.card * 2 := by
    rw [← hnon]
    calc
      Nat.card (NonfixedArcPoint F5 K25 C) = S.card := by
        change Nat.card (NonfixedArcPoint F5 K25 C) =
          (Finset.univ : Finset (NonfixedArcPoint F5 K25 C)).card
        rw [Finset.card_univ, ← Nat.card_eq_fintype_card]
      _ = T.card * 2 := hmul
  have hf : (fixedArcPoints F5 K25 C).card = f := rfl
  interval_cases f
  · exact Q25ProfileZero.profile_zero_pair_extension
      F5 K25 gf25_degree f5_card C hArc hC hcard hf
  · omega
  · exact f2_pair_extension C hArc hC hcard hf
  · omega
  · exact Q25ProfileFour.profile_four_pair_extension
      F5 K25 gf25_degree f5_card C hArc hC hcard hf
  · omega
  · exact strict_profile_pair_extension C hArc hC 6 1 hcard hf (by omega)
      (by norm_num [baerEmptyLineCount, Nat.choose])
      (by norm_num [baerNonInvariantSecantOrbits, Nat.choose])
  · omega
  · exact strict_profile_pair_extension C hArc hC 8 0 hcard hf (by omega)
      (by norm_num [baerEmptyLineCount, Nat.choose])
      (by norm_num [baerNonInvariantSecantOrbits, Nat.choose])

end
end Q25AllProfiles
end RelativeConicArcs
