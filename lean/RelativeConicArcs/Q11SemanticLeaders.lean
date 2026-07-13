import RelativeConicArcs.Q11SemanticDistribution
import RelativeConicArcs.Q11SemanticPairRep

/-! # Actual weight-two leader multiplicities for the q=11 code -/

namespace RelativeConicArcs.Examples.Q11Coding

open Certificate Matrix

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩
set_option maxHeartbeats 30000000
set_option maxRecDepth 100000

def pairSupport (e : Fin 6 × Fin 6) : Finset (Fin 6) := {e.1, e.2}

def rawLeaderSupports (i : Fin 133) : Finset (Finset (Fin 6)) :=
  (witnessPairs.filter fun e =>
    Matrix.det ![projectiveVec i, witnessVec e.1, witnessVec e.2] = 0).image pairSupport

private theorem pairSupport_injOn :
    Set.InjOn pairSupport (↑witnessPairs : Set (Fin 6 × Fin 6)) := by
  decide

private theorem det_zero_of_two_rep (x u v : Vec (ZMod 11)) (a b : ZMod 11)
    (h : a • u + b • v = x) : Matrix.det ![x, u, v] = 0 := by
  rw [← h]
  simp [Matrix.det_fin_three]
  ring

/-- For a canonical distance-two syndrome, determinant-zero witness pairs are exactly the
supports of actual weight-two coefficient words mapping to that syndrome. -/
theorem syndromeLeaderSupports_two_eq_raw (i : Fin 133)
    (hd : canonicalSyndromeDistance i = 2) :
    CodingBridge.syndromeLeaderSupportsOfWeight (K := ZMod 11) witnessVec
      (projectiveVec i) 2 = rawLeaderSupports i := by
  ext S
  constructor
  · intro hS
    obtain ⟨c, hw, hmap, hsupp⟩ :=
      CodingBridge.mem_syndromeLeaderSupportsOfWeight.mp hS
    have hcard : S.card = 2 := by
      rw [← hsupp, ← CodingBridge.hammingWeight, hw]
    obtain ⟨j, k, hjk, hSjk⟩ := Finset.card_eq_two.mp hcard
    have hcj : c j ≠ 0 := by
      apply CodingBridge.mem_hammingSupport.mp
      rw [hsupp, hSjk]
      simp
    have hck : c k ≠ 0 := by
      apply CodingBridge.mem_hammingSupport.mp
      rw [hsupp, hSjk]
      simp
    have hceq : c = twoWord j k (c j) (c k) := by
      funext l
      by_cases hlj : l = j
      · subst l
        simp [twoWord]
      by_cases hlk : l = k
      · subst l
        simp [twoWord, hlj]
      have hcl : c l = 0 := by
        by_contra hne
        have hlmem : l ∈ CodingBridge.hammingSupport c :=
          CodingBridge.mem_hammingSupport.mpr hne
        rw [hsupp, hSjk] at hlmem
        simp [hlj, hlk] at hlmem
      simp [twoWord, hlj, hlk, hcl]
    have hrep : c j • witnessVec j + c k • witnessVec k = projectiveVec i := by
      rw [hceq, twoWord_syndrome hjk] at hmap
      exact hmap
    by_cases hjklt : j < k
    · apply Finset.mem_image.mpr
      refine ⟨(j, k), ?_, by simpa [pairSupport] using hSjk.symm⟩
      apply Finset.mem_filter.mpr
      refine ⟨?_, det_zero_of_two_rep _ _ _ _ _ hrep⟩
      simp [witnessPairs, hjklt]
    · have hkjlt : k < j := lt_of_le_of_ne (le_of_not_gt hjklt) hjk.symm
      apply Finset.mem_image.mpr
      refine ⟨(k, j), ?_, by simpa [pairSupport, Finset.pair_comm] using hSjk.symm⟩
      apply Finset.mem_filter.mpr
      refine ⟨?_, det_zero_of_two_rep (projectiveVec i) (witnessVec k) (witnessVec j)
        (c k) (c j) ?_⟩
      · simp [witnessPairs, hkjlt]
      · simpa [add_comm] using hrep
  · intro hS
    obtain ⟨e, he, rfl⟩ := Finset.mem_image.mp hS
    obtain ⟨hePair, hdet⟩ := Finset.mem_filter.mp he
    have helt : e.1 < e.2 := by simpa [witnessPairs] using hePair
    obtain ⟨a, b, ha, hb, hrep⟩ := distance_two_secant_pair_rep i e hd hePair hdet
    apply CodingBridge.mem_syndromeLeaderSupportsOfWeight.mpr
    refine ⟨twoWord e.1 e.2 a b, twoWord_weight (ne_of_lt helt) ha hb, ?_, ?_⟩
    · rw [twoWord_syndrome (ne_of_lt helt), hrep]
    · exact twoWord_support (ne_of_lt helt) ha hb

/-- The determinant secant index is the number of actual weight-two leaders for every canonical
distance-two syndrome. -/
theorem canonical_weightTwo_leader_count (i : Fin 133)
    (hd : canonicalSyndromeDistance i = 2) :
    (CodingBridge.syndromeLeadersOfWeight (K := ZMod 11) witnessVec
      (projectiveVec i) 2).card = rawPointIndex (projectiveVec i) := by
  rw [CodingBridge.card_syndromeLeadersOfWeight_eq_supports witnessVec
    witness_small_independent (projectiveVec i) (by omega),
    syndromeLeaderSupports_two_eq_raw i hd]
  unfold rawLeaderSupports rawPointIndex
  apply Finset.card_image_of_injOn
  exact pairSupport_injOn.mono (fun _ he => (Finset.mem_filter.mp he).1)

/-- Scalar normalization preserves the actual leader count, so the canonical secant index gives
the leader multiplicity on every nonzero affine ray. -/
theorem affineRay_weightTwo_leader_count (p : AffineRay)
    (hd : canonicalSyndromeDistance p.1 = 2) :
    (CodingBridge.syndromeLeadersOfWeight (K := ZMod 11) witnessVec
      (affineRayVec p) 2).card = rawPointIndex (projectiveVec p.1) := by
  unfold affineRayVec
  rw [CodingBridge.card_syndromeLeadersOfWeight_smul_of_ne_zero witnessVec
    (projectiveVec p.1) 2 p.2.1 p.2.2]
  exact canonical_weightTwo_leader_count p.1 hd

/-- The affine syndromes at actual distance two having exactly `r` minimum-weight coefficient
words.  The word count is taken from `syndromeLeadersOfWeight`, not from projective incidences. -/
def affineDistanceTwoSyndromesOfLeaderCount (r : ℕ) : Finset (Vec (ZMod 11)) :=
  (affineSyndromesOfDistance 2).filter fun s =>
    (CodingBridge.syndromeLeadersOfWeight (K := ZMod 11) witnessVec s 2).card = r

private theorem affineDistanceTwoSyndromesOfLeaderCount_eq (r : ℕ)
    (hr : r = 1 ∨ r = 2 ∨ r = 3) :
    affineDistanceTwoSyndromesOfLeaderCount r =
      (directionsOfIndex r ×ˢ (Finset.univ : Finset NonzeroScalar)).image affineRayVec := by
  ext s
  constructor
  · intro hs
    obtain ⟨hsDistance, hsCount⟩ := Finset.mem_filter.mp hs
    obtain ⟨hs0, hsExact⟩ := mem_affineSyndromesOfDistance_iff.mp hsDistance
    let p : AffineRay := affineRayEquiv.symm ⟨s, hs0⟩
    have hpvec : affineRayVec p = s :=
      congrArg Subtype.val (affineRayEquiv.apply_symm_apply ⟨s, hs0⟩)
    have hpExact := affineRay_syndromeDistance_exact p
    have hpDistance : canonicalSyndromeDistance p.1 = 2 :=
      hpExact.unique (hpvec ▸ hsExact)
    have hpCount : rawPointIndex (projectiveVec p.1) = r := by
      rw [← affineRay_weightTwo_leader_count p hpDistance, hpvec]
      exact hsCount
    apply Finset.mem_image.mpr
    refine ⟨p, ?_, hpvec⟩
    simp [directionsOfIndex, hpCount]
  · intro hs
    obtain ⟨p, hp, rfl⟩ := Finset.mem_image.mp hs
    have hpCount : rawPointIndex (projectiveVec p.1) = r := by
      simpa [directionsOfIndex] using hp
    have hpDistance : canonicalSyndromeDistance p.1 = 2 := by
      rcases hr with rfl | rfl | rfl <;>
        simp [canonicalSyndromeDistance, hpCount]
    apply Finset.mem_filter.mpr
    refine ⟨mem_affineSyndromesOfDistance_iff.mpr
      ⟨affineRayVec_ne_zero p, by simpa [hpDistance] using affineRay_syndromeDistance_exact p⟩, ?_⟩
    exact (affineRay_weightTwo_leader_count p hpDistance).trans hpCount

private theorem card_affineDistanceTwoSyndromesOfLeaderCount (r : ℕ)
    (hr : r = 1 ∨ r = 2 ∨ r = 3) :
    (affineDistanceTwoSyndromesOfLeaderCount r).card = 10 * (directionsOfIndex r).card := by
  rw [affineDistanceTwoSyndromesOfLeaderCount_eq r hr]
  rw [Finset.card_image_of_injOn]
  · simp [mul_comm]
  · intro a _ b _ hab
    apply affineRayVec_bijective.1
    exact Subtype.ext hab

/-- Actual distance-two affine cosets split as 900 with one leader, 150 with two leaders, and
100 with three leaders. -/
theorem distance_two_leader_distribution :
    (affineDistanceTwoSyndromesOfLeaderCount 1).card = 900 ∧
    (affineDistanceTwoSyndromesOfLeaderCount 2).card = 150 ∧
    (affineDistanceTwoSyndromesOfLeaderCount 3).card = 100 := by
  rw [card_affineDistanceTwoSyndromesOfLeaderCount 1 (by omega),
    card_affineDistanceTwoSyndromesOfLeaderCount 2 (by omega),
    card_affineDistanceTwoSyndromesOfLeaderCount 3 (by omega)]
  have hs := secant_index_spectrum
  omega

end RelativeConicArcs.Examples.Q11Coding
