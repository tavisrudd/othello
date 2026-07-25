import RelativeConicArcs.Q11SemanticLeaders
import RelativeConicArcs.Q11Coding
import RelativeConicArcs.Q11BrianchonPetersen

/-!
# Complete decoding synthesis for the Clebsch code

This downstream module packages the already kernel-checked `q = 11` semantic tables into the
four-branch syndrome-distance oracle, the complete nearest-word ambiguity enumerator, and the
explicit Brianchon/triple-ambiguity bridge.  It deliberately contains no group-action or chirality
infrastructure.
-/

namespace RelativeConicArcs.Examples.Q11Coding

open Certificate
open RelativeConicArcs.Examples.Q11BrianchonPetersen

set_option maxHeartbeats 30000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

/-- Total distance oracle, including the zero syndrome.  On a nonzero syndrome it normalizes to
the unique affine ray and uses the certified branches `index 5 -> 1`, `index 0 -> 3`, otherwise
`2`. -/
def totalSyndromeDistance (s : Vec (ZMod 11)) : ℕ :=
  if hs : s = 0 then 0
  else canonicalSyndromeDistance (affineRayOfVec ⟨s, hs⟩).1

/-- The total oracle is the actual minimum parity-check weight for every syndrome. -/
theorem totalSyndromeDistance_exact (s : Vec (ZMod 11)) :
    CodingBridge.SyndromeDistanceExactly (K := ZMod 11) witnessVec s
      (totalSyndromeDistance s) := by
  by_cases hs : s = 0
  · subst s
    constructor
    · intro c _
      exact Nat.zero_le _
    · refine ⟨0, ?_, ?_⟩
      · simp [CodingBridge.parityCheckMap]
      · simp [CodingBridge.hammingWeight, CodingBridge.hammingSupport, totalSyndromeDistance]
  · let p : AffineRay := affineRayOfVec ⟨s, hs⟩
    have hpvec : affineRayVec p = s := by
      exact congrArg Subtype.val (affineRayOfVec_rightInverse ⟨s, hs⟩)
    have hpExact := affineRay_syndromeDistance_exact p
    rw [hpvec] at hpExact
    simpa only [totalSyndromeDistance, dif_neg hs, p] using hpExact

/-- Explicit three-way branch certificate after the zero syndrome has been removed. -/
theorem totalSyndromeDistance_nonzero_branches (s : Vec (ZMod 11)) (hs : s ≠ 0) :
    let p : AffineRay := affineRayOfVec ⟨s, hs⟩
    (totalSyndromeDistance s = 1 ↔ rawPointIndex (projectiveVec p.1) = 5) ∧
    (totalSyndromeDistance s = 3 ↔ rawPointIndex (projectiveVec p.1) = 0) ∧
    (totalSyndromeDistance s = 2 ↔
      rawPointIndex (projectiveVec p.1) ≠ 5 ∧ rawPointIndex (projectiveVec p.1) ≠ 0) := by
  dsimp
  simp only [totalSyndromeDistance, dif_neg hs, canonicalSyndromeDistance]
  by_cases h5 : rawPointIndex (projectiveVec (affineRayOfVec ⟨s, hs⟩).1) = 5 <;>
    by_cases h0 : rawPointIndex (projectiveVec (affineRayOfVec ⟨s, hs⟩).1) = 0 <;>
      simp [h5, h0]

/-- The total syndrome-distance oracle returns zero exactly on the zero syndrome. -/
theorem totalSyndromeDistance_zero_iff (s : Vec (ZMod 11)) :
    totalSyndromeDistance s = 0 ↔ s = 0 := by
  constructor
  · intro hd
    by_contra hs
    have hbranches := totalSyndromeDistance_nonzero_branches s hs
    have hcases := rawPointIndex_cases (affineRayOfVec ⟨s, hs⟩).1
    rcases hcases with h | h | h | h | h <;> simp [h] at hbranches <;> omega
  · rintro rfl
    simp [totalSyndromeDistance]

/-- Every distance-three syndrome has one leader on every three-coordinate support. -/
theorem distanceThree_leaderSupports_eq_allTriples {s : Vec (ZMod 11)}
    (hd : CodingBridge.SyndromeDistanceExactly (K := ZMod 11) witnessVec s 3) :
    CodingBridge.syndromeLeaderSupportsOfWeight (K := ZMod 11) witnessVec s 3 =
      (Finset.univ : Finset (Fin 6)).powersetCard 3 := by
  ext S
  constructor
  · intro hS
    obtain ⟨c, hcweight, _hcmap, hsupport⟩ :=
      CodingBridge.mem_syndromeLeaderSupportsOfWeight.mp hS
    apply Finset.mem_powersetCard.mpr
    refine ⟨Finset.subset_univ _, ?_⟩
    rw [← hsupport]
    simpa only [CodingBridge.hammingWeight] using hcweight
  · intro hS
    have hcard : S.card = 3 := (Finset.mem_powersetCard.mp hS).2
    obtain ⟨c, hc, _hunique⟩ :=
      CodingBridge.exists_unique_weightThree_leader_on_support witnessVec
        witness_mds_columns.ambient_finrank witness_small_independent hd.1 hcard
    apply CodingBridge.mem_syndromeLeaderSupportsOfWeight.mpr
    exact ⟨c, by simp [CodingBridge.hammingWeight, hc.1, hcard], hc.2, hc.1⟩

/-- Uniform coefficient-bearing leader count at every affine deep-hole syndrome. -/
theorem distanceThree_leader_count_twenty {s : Vec (ZMod 11)}
    (hd : CodingBridge.SyndromeDistanceExactly (K := ZMod 11) witnessVec s 3) :
    (CodingBridge.syndromeLeadersOfWeight (K := ZMod 11) witnessVec s 3).card = 20 := by
  rw [CodingBridge.card_syndromeLeadersOfWeight_three witnessVec
    witness_mds_columns.ambient_finrank witness_small_independent hd.1]
  decide

/-- Two weight-one coefficient words with the same syndrome coincide.  The union of their supports
has size at most two, so this is a direct consequence of the certified small independence. -/
private theorem weightOne_representation_unique {s : Vec (ZMod 11)}
    {c d : Fin 6 → ZMod 11}
    (hcweight : CodingBridge.hammingWeight c = 1)
    (hdweight : CodingBridge.hammingWeight d = 1)
    (hc : CodingBridge.parityCheckMap (K := ZMod 11) witnessVec c = s)
    (hd : CodingBridge.parityCheckMap (K := ZMod 11) witnessVec d = s) : c = d := by
  let S := CodingBridge.hammingSupport c ∪ CodingBridge.hammingSupport d
  have hScard : S.card ≤ 2 := by
    calc
      S.card ≤ (CodingBridge.hammingSupport c).card +
          (CodingBridge.hammingSupport d).card := Finset.card_union_le _ _
      _ = CodingBridge.hammingWeight c + CodingBridge.hammingWeight d := rfl
      _ = 2 := by omega
  have hLI := witness_small_independent S (by omega)
  have hzero : CodingBridge.parityCheckMap (K := ZMod 11) witnessVec (c - d) = 0 := by
    rw [map_sub, hc, hd, sub_self]
  have hsum : ∑ i, (c i - d i) • witnessVec i = 0 := by
    simpa [CodingBridge.parityCheckMap, Fintype.linearCombination_apply] using hzero
  have hsumS : ∑ i : S, (c i.1 - d i.1) • witnessVec i.1 = 0 := by
    calc
      (∑ i : S, (c i.1 - d i.1) • witnessVec i.1) =
          ∑ i ∈ S, (c i - d i) • witnessVec i :=
        Finset.sum_coe_sort S (fun i => (c i - d i) • witnessVec i)
      _ = ∑ i, (c i - d i) • witnessVec i := by
        apply Finset.sum_subset (Finset.subset_univ S)
        intro i _ hi
        have hci : c i = 0 := by
          by_contra hne
          exact hi (Finset.mem_union_left _ (CodingBridge.mem_hammingSupport.mpr hne))
        have hdi : d i = 0 := by
          by_contra hne
          exact hi (Finset.mem_union_right _ (CodingBridge.mem_hammingSupport.mpr hne))
        simp [hci, hdi]
      _ = 0 := hsum
  have hcoeff : ∀ i : S, c i.1 - d i.1 = 0 :=
    (Fintype.linearIndependent_iff.mp hLI) _ hsumS
  funext i
  by_cases hi : i ∈ S
  · exact sub_eq_zero.mp (hcoeff ⟨i, hi⟩)
  · have hci : c i = 0 := by
      by_contra hne
      exact hi (Finset.mem_union_left _ (CodingBridge.mem_hammingSupport.mpr hne))
    have hdi : d i = 0 := by
      by_contra hne
      exact hi (Finset.mem_union_right _ (CodingBridge.mem_hammingSupport.mpr hne))
    rw [hci, hdi]

/-- Every distance-one syndrome has exactly one coefficient-bearing weight-one leader. -/
theorem distanceOne_leader_count_one {s : Vec (ZMod 11)}
    (hd : CodingBridge.SyndromeDistanceExactly (K := ZMod 11) witnessVec s 1) :
    (CodingBridge.syndromeLeadersOfWeight (K := ZMod 11) witnessVec s 1).card = 1 := by
  obtain ⟨c, hcmap, hcweight⟩ := hd.2
  have hcMem : c ∈ CodingBridge.syndromeLeadersOfWeight (K := ZMod 11) witnessVec s 1 :=
    CodingBridge.mem_syndromeLeadersOfWeight.mpr ⟨hcweight, hcmap⟩
  have heq : CodingBridge.syndromeLeadersOfWeight (K := ZMod 11) witnessVec s 1 = {c} := by
    ext d
    simp only [CodingBridge.mem_syndromeLeadersOfWeight, Finset.mem_singleton]
    constructor
    · rintro ⟨hdweight, hdmap⟩
      exact weightOne_representation_unique hdweight hcweight hdmap hcmap
    · rintro rfl
      exact ⟨hcweight, hcmap⟩
  rw [heq]
  simp

/-- The four semantic ambiguity strata. -/
def ambiguityOneSyndromes : Finset (Vec (ZMod 11)) :=
  affineSyndromesOfDistance 1 ∪ affineDistanceTwoSyndromesOfLeaderCount 1

/-- Nonzero syndromes having exactly two nearest leaders. -/
def ambiguityTwoSyndromes : Finset (Vec (ZMod 11)) :=
  affineDistanceTwoSyndromesOfLeaderCount 2

/-- Nonzero syndromes having exactly three nearest leaders. -/
def ambiguityThreeSyndromes : Finset (Vec (ZMod 11)) :=
  affineDistanceTwoSyndromesOfLeaderCount 3

/-- Nonzero syndromes having exactly twenty nearest leaders. -/
def ambiguityTwentySyndromes : Finset (Vec (ZMod 11)) :=
  affineSyndromesOfDistance 3

/-- Number of leaders at the minimum weight returned by `totalSyndromeDistance`. -/
def nearestLeaderCount (s : Vec (ZMod 11)) : ℕ :=
  (CodingBridge.syndromeLeadersOfWeight (K := ZMod 11) witnessVec s
    (totalSyndromeDistance s)).card

/-- Every stratum has the advertised actual nearest-word multiplicity. -/
theorem ambiguity_strata_sound :
    (∀ s ∈ ambiguityOneSyndromes, nearestLeaderCount s = 1) ∧
    (∀ s ∈ ambiguityTwoSyndromes, nearestLeaderCount s = 2) ∧
    (∀ s ∈ ambiguityThreeSyndromes, nearestLeaderCount s = 3) ∧
    (∀ s ∈ ambiguityTwentySyndromes, nearestLeaderCount s = 20) := by
  constructor
  · intro s hs
    rcases Finset.mem_union.mp hs with hs1 | hs2
    · obtain ⟨_hs0, hexact⟩ := mem_affineSyndromesOfDistance_iff.mp hs1
      have horacle := totalSyndromeDistance_exact s
      have hd : totalSyndromeDistance s = 1 := horacle.unique hexact
      simp only [nearestLeaderCount, hd]
      exact distanceOne_leader_count_one hexact
    · obtain ⟨hsDistance, hsCount⟩ := Finset.mem_filter.mp hs2
      obtain ⟨_hs0, hexact⟩ := mem_affineSyndromesOfDistance_iff.mp hsDistance
      have hd : totalSyndromeDistance s = 2 := (totalSyndromeDistance_exact s).unique hexact
      simpa [nearestLeaderCount, hd] using hsCount
  · constructor
    · intro s hs
      obtain ⟨hsDistance, hsCount⟩ := Finset.mem_filter.mp hs
      obtain ⟨_hs0, hexact⟩ := mem_affineSyndromesOfDistance_iff.mp hsDistance
      have hd : totalSyndromeDistance s = 2 := (totalSyndromeDistance_exact s).unique hexact
      simpa [nearestLeaderCount, hd] using hsCount
    · constructor
      · intro s hs
        obtain ⟨hsDistance, hsCount⟩ := Finset.mem_filter.mp hs
        obtain ⟨_hs0, hexact⟩ := mem_affineSyndromesOfDistance_iff.mp hsDistance
        have hd : totalSyndromeDistance s = 2 := (totalSyndromeDistance_exact s).unique hexact
        simpa [nearestLeaderCount, hd] using hsCount
      · intro s hs
        obtain ⟨_hs0, hexact⟩ := mem_affineSyndromesOfDistance_iff.mp hs
        have hd : totalSyndromeDistance s = 3 := (totalSyndromeDistance_exact s).unique hexact
        simpa [nearestLeaderCount, hd] using distanceThree_leader_count_twenty hexact

/-- Complete nonzero-syndrome ambiguity enumerator `1^960 2^150 3^100 20^120`. -/
theorem ambiguity_strata_counts :
    ambiguityOneSyndromes.card = 960 ∧
    ambiguityTwoSyndromes.card = 150 ∧
    ambiguityThreeSyndromes.card = 100 ∧
    ambiguityTwentySyndromes.card = 120 := by
  obtain ⟨hdistOne, _hdistTwo, hdistThree⟩ := affine_coset_distance_distribution
  obtain ⟨htwoOne, htwoTwo, htwoThree⟩ := distance_two_leader_distribution
  have hdisjoint : Disjoint (affineSyndromesOfDistance 1)
      (affineDistanceTwoSyndromesOfLeaderCount 1) := by
    rw [Finset.disjoint_left]
    intro s hs1 hs2
    obtain ⟨_, hExact1⟩ := mem_affineSyndromesOfDistance_iff.mp hs1
    have hs2Distance := (Finset.mem_filter.mp hs2).1
    obtain ⟨_, hExact2⟩ := mem_affineSyndromesOfDistance_iff.mp hs2Distance
    have := hExact1.unique hExact2
    omega
  constructor
  · rw [ambiguityOneSyndromes, Finset.card_union_of_disjoint hdisjoint]
    omega
  · exact ⟨htwoTwo, htwoThree, hdistThree⟩

/-- Index of the `k`th normalized Brianchon point `(1,y,z)` among the 133 canonical projective
representatives. -/
def brianchonDirectionIndex (k : Fin 10) : Fin 133 :=
  ⟨(brianchonPointCode k).1.1 * 11 + (brianchonPointCode k).2.1, by
    have hy := (brianchonPointCode k).1.2
    have hz := (brianchonPointCode k).2.2
    omega⟩

/-- The ten Brianchon rows are exactly all secant-index-three canonical directions. -/
theorem brianchonDirectionIndices_eq_indexThree :
    Finset.univ.image brianchonDirectionIndex = directionsOfIndex 3 := by
  decide

/-- The determinant-defined raw leader supports at a Brianchon direction are the three edges in
the corresponding antipodal matching. -/
theorem brianchon_rawLeaderSupports (k : Fin 10) :
    rawLeaderSupports (brianchonDirectionIndex k) =
      (brianchonMatching k).image pairSupport := by
  fin_cases k <;> decide

/-- Explicit bridge from the ten geometric Brianchon matchings to actual coefficient-bearing
weight-two leader supports. -/
theorem brianchon_weightTwo_leaderSupports (k : Fin 10) :
    CodingBridge.syndromeLeaderSupportsOfWeight (K := ZMod 11) witnessVec
      (projectiveVec (brianchonDirectionIndex k)) 2 =
        (brianchonMatching k).image pairSupport := by
  have hd : canonicalSyndromeDistance (brianchonDirectionIndex k) = 2 := by
    fin_cases k <;> decide
  calc
    CodingBridge.syndromeLeaderSupportsOfWeight (K := ZMod 11) witnessVec
        (projectiveVec (brianchonDirectionIndex k)) 2 =
        rawLeaderSupports (brianchonDirectionIndex k) :=
      syndromeLeaderSupports_two_eq_raw (brianchonDirectionIndex k) hd
    _ = (brianchonMatching k).image pairSupport := brianchon_rawLeaderSupports k

#print axioms totalSyndromeDistance_exact
#print axioms totalSyndromeDistance_nonzero_branches
#print axioms distanceThree_leaderSupports_eq_allTriples
#print axioms distanceThree_leader_count_twenty
#print axioms distanceOne_leader_count_one
#print axioms ambiguity_strata_sound
#print axioms ambiguity_strata_counts
#print axioms brianchonDirectionIndices_eq_indexThree
#print axioms brianchon_weightTwo_leaderSupports

end RelativeConicArcs.Examples.Q11Coding
