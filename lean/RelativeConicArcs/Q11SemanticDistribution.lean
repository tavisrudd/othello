import RelativeConicArcs.Q11SemanticSynthesis
import RelativeConicArcs.Q11SemanticSpectrum

namespace RelativeConicArcs.Examples.Q11Coding

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩
set_option maxHeartbeats 30000000
set_option maxRecDepth 100000

private theorem affineRaysOfDistance_one :
    affineRaysOfDistance 1 =
      directionsOfIndex 5 ×ˢ (Finset.univ : Finset NonzeroScalar) := by
  ext p
  simp only [affineRaysOfDistance, Finset.mem_filter, Finset.mem_univ, true_and,
    Finset.mem_product, directionsOfIndex, and_true]
  by_cases h5 : rawPointIndex (projectiveVec p.1) = 5 <;>
    by_cases h0 : rawPointIndex (projectiveVec p.1) = 0 <;>
      simp [canonicalSyndromeDistance, h5, h0]

private theorem affineRaysOfDistance_three :
    affineRaysOfDistance 3 =
      directionsOfIndex 0 ×ˢ (Finset.univ : Finset NonzeroScalar) := by
  ext p
  simp only [affineRaysOfDistance, Finset.mem_filter, Finset.mem_univ, true_and,
    Finset.mem_product, directionsOfIndex, and_true]
  by_cases h5 : rawPointIndex (projectiveVec p.1) = 5 <;>
    by_cases h0 : rawPointIndex (projectiveVec p.1) = 0 <;>
      simp [canonicalSyndromeDistance, h5, h0]

private theorem affineRaysOfDistance_two :
    affineRaysOfDistance 2 =
      (directionsOfIndex 1 ∪ directionsOfIndex 2 ∪ directionsOfIndex 3) ×ˢ
        (Finset.univ : Finset NonzeroScalar) := by
  ext p
  have hc := rawPointIndex_cases p.1
  simp only [affineRaysOfDistance, Finset.mem_filter, Finset.mem_univ, true_and,
    Finset.mem_product, Finset.mem_union, directionsOfIndex, and_true, or_assoc]
  change canonicalSyndromeDistance p.1 = 2 ↔
    rawPointIndex (projectiveVec p.1) = 1 ∨
      rawPointIndex (projectiveVec p.1) = 2 ∨
      rawPointIndex (projectiveVec p.1) = 3
  rcases hc with h | h | h | h | h <;> simp [canonicalSyndromeDistance, h]

/-- The actual nonzero affine coset-distance distribution. -/
theorem affine_coset_distance_distribution :
    (affineSyndromesOfDistance 1).card = 60 ∧
    (affineSyndromesOfDistance 2).card = 1150 ∧
    (affineSyndromesOfDistance 3).card = 120 := by
  have himage (d : ℕ) : (affineSyndromesOfDistance d).card =
      (affineRaysOfDistance d).card := by
    apply Finset.card_image_of_injOn
    intro a _ b _ hab
    apply affineRayVec_bijective.1
    exact Subtype.ext hab
  have hs := secant_index_spectrum
  have hscalars : (Finset.univ : Finset NonzeroScalar).card = 10 := by decide
  rcases hs with ⟨h0, h1, h2, h3, h5⟩
  have hd12 : Disjoint (directionsOfIndex 1) (directionsOfIndex 2) := by
    rw [Finset.disjoint_left]
    intro i hi1 hi2
    simp [directionsOfIndex] at hi1 hi2
    omega
  have hd123 : Disjoint (directionsOfIndex 1 ∪ directionsOfIndex 2)
      (directionsOfIndex 3) := by
    rw [Finset.disjoint_left]
    intro i hi12 hi3
    simp [directionsOfIndex] at hi12 hi3
    omega
  have hunion :
      (directionsOfIndex 1 ∪ directionsOfIndex 2 ∪ directionsOfIndex 3).card = 115 := by
    rw [Finset.card_union_of_disjoint hd123, Finset.card_union_of_disjoint hd12,
      h1, h2, h3]
  have hr1 : (affineRaysOfDistance 1).card = 60 := by
    rw [affineRaysOfDistance_one, Finset.card_product, h5, hscalars]
  have hr2 : (affineRaysOfDistance 2).card = 1150 := by
    rw [affineRaysOfDistance_two, Finset.card_product, hunion, hscalars]
  have hr3 : (affineRaysOfDistance 3).card = 120 := by
    rw [affineRaysOfDistance_three, Finset.card_product, h0, hscalars]
  simpa [himage] using And.intro hr1 (And.intro hr2 hr3)

end RelativeConicArcs.Examples.Q11Coding
