import RelativeConicArcs.Q11SemanticRayData
import RelativeConicArcs.Q11SemanticIndexCases
import RelativeConicArcs.Q11SemanticOneRep
import RelativeConicArcs.Q11SemanticTwoRep
import RelativeConicArcs.Q11SemanticPairAvoidance
import RelativeConicArcs.Q11SemanticOneAvoidance
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse

/-! # Semantic synthesis for the q=11 affine syndrome distribution -/

namespace RelativeConicArcs.Examples.Q11Coding

open Certificate Q11Residual ConflictGraph Matrix

set_option maxHeartbeats 30000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

/-- Every distinct witness triple is a basis of the syndrome space. -/
theorem witness_distinct_triples_det :
    ∀ i j k : Fin 6, i ≠ j → i ≠ k → j ≠ k →
      Matrix.det ![witnessVec i, witnessVec j, witnessVec k] ≠ 0 := by
  decide

theorem witness_triple_independent (T : Finset (Fin 6)) (hT : T.card = 3) :
    LinearIndependent (ZMod 11) (fun i : T => witnessVec i.1) := by
  classical
  let e : T ≃ Fin 3 := T.equivFinOfCardEq hT
  have hdet : Matrix.det ![witnessVec (e.symm 0).1, witnessVec (e.symm 1).1,
      witnessVec (e.symm 2).1] ≠ 0 := by
    apply witness_distinct_triples_det
    · intro h
      have := e.symm.injective (Subtype.ext h)
      exact (by decide : (0 : Fin 3) ≠ 1) this
    · intro h
      have := e.symm.injective (Subtype.ext h)
      exact (by decide : (0 : Fin 3) ≠ 2) this
    · intro h
      have := e.symm.injective (Subtype.ext h)
      exact (by decide : (1 : Fin 3) ≠ 2) this
  have hli : LinearIndependent (ZMod 11)
      ![witnessVec (e.symm 0).1, witnessVec (e.symm 1).1, witnessVec (e.symm 2).1] := by
    simpa [Matrix.row] using Matrix.linearIndependent_rows_of_det_ne_zero hdet
  have hli' : LinearIndependent (ZMod 11)
      (fun n : Fin 3 => witnessVec (e.symm n).1) := by
    convert hli using 1
    funext n
    fin_cases n <;> rfl
  have hcomp := hli'.comp e e.injective
  have hfam : ((fun n : Fin 3 => witnessVec (e.symm n).1) ∘ e) =
      (fun i : T => witnessVec i.1) := by
    funext i
    rw [Function.comp_apply, e.symm_apply_apply]
  rw [hfam] at hcomp
  exact hcomp

theorem witness_small_independent :
    ∀ S : Finset (Fin 6), S.card ≤ 3 →
      LinearIndependent (ZMod 11) (fun i : S => witnessVec i.1) :=
  CodingBridge.small_independent_of_triple_independent witnessVec (by simp)
    witness_triple_independent

/-- Every canonical representative has its actual parity-check syndrome distance. -/
theorem canonical_syndromeDistance_exact (i : Fin 133) :
    CodingBridge.SyndromeDistanceExactly (K := ZMod 11) witnessVec (projectiveVec i)
      (canonicalSyndromeDistance i) := by
  by_cases hfive : rawPointIndex (projectiveVec i) = 5
  · rw [canonicalSyndromeDistance, if_pos hfive]
    obtain ⟨j, a, ha, hrep⟩ := index_five_has_one_presentation i hfive
    refine ⟨CodingBridge.syndromeDistanceAtLeast_one_of_ne_zero witnessVec
      (projectiveVec_ne_zero i), oneWord j a, ?_, oneWord_weight j ha⟩
    rw [oneWord_syndrome, hrep]
  · by_cases hzero : rawPointIndex (projectiveVec i) = 0
    · rw [canonicalSyndromeDistance, if_neg hfive, if_pos hzero]
      have hlower := CodingBridge.syndromeDistanceAtLeast_three_of_pair_avoidance witnessVec
        (by simp) (index_zero_pair_avoidance i hzero)
      obtain ⟨c, hc, hle⟩ := CodingBridge.every_syndrome_has_weight_le_three witnessVec
        (by simp) (by simp) witness_small_independent (projectiveVec i)
      refine ⟨hlower, c, hc, ?_⟩
      exact Nat.le_antisymm hle (hlower c hc)
    · rw [canonicalSyndromeDistance, if_neg hfive, if_neg hzero]
      obtain ⟨j, k, hjk, a, b, ha, hb, hrep⟩ :=
        nonzero_nonfive_has_two_presentation i hzero hfive
      have hjkne : j ≠ k := ne_of_lt hjk
      refine ⟨CodingBridge.syndromeDistanceAtLeast_two_of_one_avoidance witnessVec
        (by simp) (nonfive_one_avoidance i hfive), twoWord j k a b, ?_,
        twoWord_weight hjkne ha hb⟩
      rw [twoWord_syndrome hjkne, hrep]

theorem affineRay_syndromeDistance_exact (p : AffineRay) :
    CodingBridge.SyndromeDistanceExactly (K := ZMod 11) witnessVec (affineRayVec p)
      (canonicalSyndromeDistance p.1) := by
  exact CodingBridge.syndromeDistanceExactly_smul_of_ne_zero witnessVec p.2.1 p.2.2
    (canonical_syndromeDistance_exact p.1)

/-- The projective point represented by the `i`th canonical syndrome vector. -/
def projectiveSyndromePoint (i : Fin 133) : Conic.Point (ZMod 11) :=
  Certificate.toPoint ⟨projectiveVec i, projectiveVec_ne_zero i⟩

/-- The computed distance-three class is exactly the quadratic zero locus, on canonical
projective representatives. -/
theorem canonical_syndromeDistance_eq_three_iff_conicForm_zero (i : Fin 133) :
    canonicalSyndromeDistance i = 3 ↔
      ProjectiveCap.Sym2Bridge.conicForm (projectiveVec i) = 0 := by
  revert i
  decide

/-- The actual syndrome distance of a canonical projective representative is three exactly on
the standard conic.  This is the semantic bridge between the code and the incidence-defined
projective locus. -/
theorem canonical_distanceThree_iff_mem_standardConic (i : Fin 133) :
    CodingBridge.SyndromeDistanceExactly (K := ZMod 11) witnessVec (projectiveVec i) 3 ↔
      projectiveSyndromePoint i ∈ Conic.standardConic (K := ZMod 11) := by
  rw [Conic.mem_standardConic_iff_onConic]
  unfold projectiveSyndromePoint Certificate.toPoint
  rw [ProjectiveCap.Sym2Bridge.onConic_mk]
  constructor
  · intro h
    exact (canonical_syndromeDistance_eq_three_iff_conicForm_zero i).mp
      ((canonical_syndromeDistance_exact i).unique h)
  · intro h
    have hd := (canonical_syndromeDistance_eq_three_iff_conicForm_zero i).mpr h
    simpa [hd] using canonical_syndromeDistance_exact i

/-- The distance-three/conic equivalence on all nonzero scalar multiples of the canonical
representatives. -/
theorem affineRay_distanceThree_iff_mem_standardConic (p : AffineRay) :
    CodingBridge.SyndromeDistanceExactly (K := ZMod 11) witnessVec (affineRayVec p) 3 ↔
      projectiveSyndromePoint p.1 ∈ Conic.standardConic (K := ZMod 11) := by
  constructor
  · intro h
    have hd : canonicalSyndromeDistance p.1 = 3 :=
      (affineRay_syndromeDistance_exact p).unique h
    apply (canonical_distanceThree_iff_mem_standardConic p.1).mp
    simpa [hd] using canonical_syndromeDistance_exact p.1
  · intro h
    have hc := (canonical_distanceThree_iff_mem_standardConic p.1).mpr h
    have hd : canonicalSyndromeDistance p.1 = 3 :=
      (canonical_syndromeDistance_exact p.1).unique hc
    simpa [hd] using affineRay_syndromeDistance_exact p

/-- The same distance-three/conic equivalence for every nonzero affine syndrome, without choosing
a canonical scalar representative in the statement. -/
theorem affine_distanceThree_iff_mem_standardConic (s : Vec (ZMod 11)) (hs : s ≠ 0) :
    CodingBridge.SyndromeDistanceExactly (K := ZMod 11) witnessVec s 3 ↔
      Certificate.toPoint ⟨s, hs⟩ ∈ Conic.standardConic (K := ZMod 11) := by
  let p : AffineRay := affineRayEquiv.symm ⟨s, hs⟩
  have hpvec : affineRayVec p = s := by
    exact congrArg Subtype.val (affineRayEquiv.apply_symm_apply ⟨s, hs⟩)
  have hpoint : Certificate.toPoint ⟨s, hs⟩ = projectiveSyndromePoint p.1 := by
    apply (Certificate.rayEq_iff_mk_eq ⟨s, hs⟩
      ⟨projectiveVec p.1, projectiveVec_ne_zero p.1⟩).mp
    exact ⟨p.2.1, by simpa [affineRayVec] using hpvec⟩
  rw [hpoint]
  constructor
  · intro h
    apply (affineRay_distanceThree_iff_mem_standardConic p).mp
    rw [hpvec]
    exact h
  · intro h
    rw [← hpvec]
    exact (affineRay_distanceThree_iff_mem_standardConic p).mpr h

theorem mem_affineSyndromesOfDistance_iff {s : Vec (ZMod 11)} {d : ℕ} :
    s ∈ affineSyndromesOfDistance d ↔
      s ≠ 0 ∧ CodingBridge.SyndromeDistanceExactly (K := ZMod 11) witnessVec s d := by
  constructor
  · intro hs
    obtain ⟨p, hp, rfl⟩ := Finset.mem_image.mp hs
    have hdist : canonicalSyndromeDistance p.1 = d := by
      simpa [affineRaysOfDistance] using hp
    exact ⟨affineRayVec_ne_zero p, by simpa [hdist] using affineRay_syndromeDistance_exact p⟩
  · rintro ⟨hs0, hs⟩
    let p : AffineRay := affineRayEquiv.symm ⟨s, hs0⟩
    have hpvec : affineRayVec p = s := by
      exact congrArg Subtype.val (affineRayEquiv.apply_symm_apply ⟨s, hs0⟩)
    have hpExact := affineRay_syndromeDistance_exact p
    have hdist : canonicalSyndromeDistance p.1 = d := hpExact.unique (hpvec ▸ hs)
    apply Finset.mem_image.mpr
    refine ⟨p, ?_, hpvec⟩
    simp [affineRaysOfDistance, hdist]

end RelativeConicArcs.Examples.Q11Coding
