import RelativeConicArcs.ReflectionArrangements
import RelativeConicArcs.Q11DecodingSynthesis

/-!
# Joint incidence/ambiguity census

This downstream module records, in one theorem, the reduced-`H3` incidence-stratum cardinalities
together with the Clebsch nearest-codeword ambiguity-census cardinalities.  It is kept separate from
the coordinate module so the decoder closure does not enter that module's elaboration.
-/

namespace RelativeConicArcs.Examples.ReflectionArrangements

open Certificate
open RelativeConicArcs.Examples.Q11Coding

set_option maxHeartbeats 30000000
set_option maxRecDepth 100000

/-- The affine syndrome obtained from a normalized arrangement point after applying the displayed
invertible coordinate map, renormalizing its projective direction, and multiplying by a chosen
nonzero scalar.  The scalar ranges over all ten elements of `NonzeroScalar`. -/
def h3AffineSyndrome (p : Fin 133) (a : NonzeroScalar) : Vec (ZMod 11) :=
  affineRayVec (h3ProjectiveIndex p, a)

/-- The nonzero-syndrome subtype associated to an arrangement point and nonzero scalar. -/
def h3AffineSyndromeNonzero (pa : Fin 133 × NonzeroScalar) :
    {s : Vec (ZMod 11) // s ≠ 0} :=
  ⟨h3AffineSyndrome pa.1 pa.2, affineRayVec_ne_zero (h3ProjectiveIndex pa.1, pa.2)⟩

/-- Distinct pairs of an arrangement point and a nonzero scalar give distinct affine syndromes. -/
theorem h3_affine_syndrome_injective :
    Function.Injective (fun pa : Fin 133 × NonzeroScalar => h3AffineSyndrome pa.1 pa.2) := by
  rintro ⟨p, a⟩ ⟨q, b⟩ hab
  have hab' : (⟨affineRayVec (h3ProjectiveIndex p, a),
      affineRayVec_ne_zero (h3ProjectiveIndex p, a)⟩ : {s : Vec (ZMod 11) // s ≠ 0}) =
      ⟨affineRayVec (h3ProjectiveIndex q, b),
        affineRayVec_ne_zero (h3ProjectiveIndex q, b)⟩ := Subtype.ext hab
  have hpairs : (h3ProjectiveIndex p, a) = (h3ProjectiveIndex q, b) :=
    affineRayVec_bijective.1 hab'
  have hp : p = q := h3_projective_index_bijective.1 (congrArg Prod.fst hpairs)
  have ha : a = b := congrArg Prod.snd hpairs
  exact Prod.ext hp ha

/-- Arrangement points paired with nonzero scalars are in bijection with all nonzero affine
syndromes. -/
theorem h3_affine_syndrome_bijective : Function.Bijective h3AffineSyndromeNonzero := by
  constructor
  · intro pa pb hab
    apply h3_affine_syndrome_injective
    exact congrArg Subtype.val hab
  · intro s
    obtain ⟨ray, hray⟩ := affineRayVec_bijective.2 s
    obtain ⟨p, hp⟩ := h3_projective_index_bijective.2 ray.1
    refine ⟨(p, ray.2), ?_⟩
    apply Subtype.ext
    simpa [h3AffineSyndromeNonzero, h3AffineSyndrome, hp] using congrArg Subtype.val hray

/-- The affine syndromes above arrangement points of incidence multiplicity `m`, including all ten
nonzero scalar representatives of each projective direction. -/
def h3AffineSyndromesOfMultiplicity (m : ℕ) : Finset (Vec (ZMod 11)) :=
  (h3PointsOfMultiplicity m ×ˢ (Finset.univ : Finset NonzeroScalar)).image
    fun pa => h3AffineSyndrome pa.1 pa.2

/-- Each projective point in an incidence stratum contributes exactly ten distinct affine
syndromes. -/
theorem h3_affine_syndromes_card (m : ℕ) :
    (h3AffineSyndromesOfMultiplicity m).card = 10 * (h3PointsOfMultiplicity m).card := by
  rw [h3AffineSyndromesOfMultiplicity, Finset.card_image_of_injOn]
  · simp [mul_comm]
  · exact h3_affine_syndrome_injective.injOn

/-- The actual nearest-codeword leader count on every affine ray is determined by the incidence
multiplicity of its arrangement point: multiplicities `0,1,2,3,5` give leader counts
`20,1,2,3,1`, respectively. -/
theorem h3_affine_syndrome_nearestLeaderCount (p : Fin 133) (a : NonzeroScalar) :
    nearestLeaderCount (h3AffineSyndrome p a) =
      if h3Multiplicity p = 0 then 20 else if h3Multiplicity p = 5 then 1
      else h3Multiplicity p := by
  let ray : AffineRay := (h3ProjectiveIndex p, a)
  have hindex : rawPointIndex (projectiveVec ray.1) = h3Multiplicity p := by
    simpa [ray, h3Multiplicity] using (h3_multiplicity_eq_normalized_rawPointIndex p).symm
  have hcases := h3_multiplicity_cases p
  rcases hcases with h0 | h1 | h2 | h3 | h5
  · have hcanonical : canonicalSyndromeDistance ray.1 = 3 := by
      simp [canonicalSyndromeDistance, hindex, h0]
    have hexact := affineRay_syndromeDistance_exact ray
    have htotal : totalSyndromeDistance (affineRayVec ray) = 3 :=
      (totalSyndromeDistance_exact (affineRayVec ray)).unique (by simpa [hcanonical] using hexact)
    simpa [h3AffineSyndrome, ray, nearestLeaderCount, h0, htotal] using
      distanceThree_leader_count_twenty (by simpa [hcanonical] using hexact)
  · have h0 : h3Multiplicity p ≠ 0 := by omega
    have hcanonical : canonicalSyndromeDistance ray.1 = 2 := by
      simp [canonicalSyndromeDistance, hindex, h1]
    have hexact := affineRay_syndromeDistance_exact ray
    have htotal : totalSyndromeDistance (affineRayVec ray) = 2 :=
      (totalSyndromeDistance_exact (affineRayVec ray)).unique (by simpa [hcanonical] using hexact)
    simpa [h3AffineSyndrome, ray, nearestLeaderCount, h0, h1, htotal] using
      (affineRay_weightTwo_leader_count ray hcanonical).trans (hindex.trans h1)
  · have h0 : h3Multiplicity p ≠ 0 := by omega
    have hcanonical : canonicalSyndromeDistance ray.1 = 2 := by
      simp [canonicalSyndromeDistance, hindex, h2]
    have hexact := affineRay_syndromeDistance_exact ray
    have htotal : totalSyndromeDistance (affineRayVec ray) = 2 :=
      (totalSyndromeDistance_exact (affineRayVec ray)).unique (by simpa [hcanonical] using hexact)
    simpa [h3AffineSyndrome, ray, nearestLeaderCount, h0, h2, htotal] using
      (affineRay_weightTwo_leader_count ray hcanonical).trans (hindex.trans h2)
  · have h0 : h3Multiplicity p ≠ 0 := by omega
    have hcanonical : canonicalSyndromeDistance ray.1 = 2 := by
      simp [canonicalSyndromeDistance, hindex, h3]
    have hexact := affineRay_syndromeDistance_exact ray
    have htotal : totalSyndromeDistance (affineRayVec ray) = 2 :=
      (totalSyndromeDistance_exact (affineRayVec ray)).unique (by simpa [hcanonical] using hexact)
    simpa [h3AffineSyndrome, ray, nearestLeaderCount, h0, h3, htotal] using
      (affineRay_weightTwo_leader_count ray hcanonical).trans (hindex.trans h3)
  · have h0 : h3Multiplicity p ≠ 0 := by omega
    have hcanonical : canonicalSyndromeDistance ray.1 = 1 := by
      simp [canonicalSyndromeDistance, hindex, h5]
    have hexact := affineRay_syndromeDistance_exact ray
    have htotal : totalSyndromeDistance (affineRayVec ray) = 1 :=
      (totalSyndromeDistance_exact (affineRayVec ray)).unique (by simpa [hcanonical] using hexact)
    simpa [h3AffineSyndrome, ray, nearestLeaderCount, h0, h5, htotal] using
      distanceOne_leader_count_one (by simpa [hcanonical] using hexact)

/-- The ordinary incidence-one points and the six incidence-five points contribute
`10*(90+6)=960` affine syndromes with one nearest leader. -/
theorem h3_one_leader_strata_card :
    (h3AffineSyndromesOfMultiplicity 1).card +
      (h3AffineSyndromesOfMultiplicity 5).card = 960 := by
  rw [h3_affine_syndromes_card, h3_affine_syndromes_card,
    h3_intersection_spectrum.2.1, h3_intersection_spectrum.2.2.2.2]

/-- The union of the incidence-one and incidence-five affine images. -/
def h3OneLeaderSyndromes : Finset (Vec (ZMod 11)) :=
  h3AffineSyndromesOfMultiplicity 1 ∪ h3AffineSyndromesOfMultiplicity 5

/-- Affine images of distinct incidence-multiplicity strata are disjoint. -/
theorem h3_affine_syndromes_disjoint_of_ne {m n : ℕ} (hmn : m ≠ n) :
    Disjoint (h3AffineSyndromesOfMultiplicity m) (h3AffineSyndromesOfMultiplicity n) := by
  refine Finset.disjoint_left.mpr ?_
  intro s hsm hsn
  obtain ⟨pa, hpa, hpas⟩ := Finset.mem_image.mp hsm
  obtain ⟨pb, hpb, hpbs⟩ := Finset.mem_image.mp hsn
  have hpab : pa = pb := h3_affine_syndrome_injective (hpas.trans hpbs.symm)
  have hm : h3Multiplicity pa.1 = m :=
    (Finset.mem_filter.mp (Finset.mem_product.mp hpa).1).2
  have hn : h3Multiplicity pb.1 = n :=
    (Finset.mem_filter.mp (Finset.mem_product.mp hpb).1).2
  subst pb
  exact hmn (hm.symm.trans hn)

/-- The union of the incidence-one and incidence-five affine images has cardinality 960. -/
theorem h3_one_leader_syndromes_card : h3OneLeaderSyndromes.card = 960 := by
  unfold h3OneLeaderSyndromes
  rw [Finset.card_union_of_disjoint (h3_affine_syndromes_disjoint_of_ne (by omega)),
    h3_one_leader_strata_card]

/-- Every syndrome in the incidence-one/incidence-five union has exactly one nearest leader. -/
theorem h3_one_leader_syndromes_sound :
    ∀ s ∈ h3OneLeaderSyndromes, nearestLeaderCount s = 1 := by
  intro s hs
  rw [h3OneLeaderSyndromes] at hs
  rcases Finset.mem_union.mp hs with hs | hs
  · obtain ⟨pa, hpa, hpas⟩ := Finset.mem_image.mp hs
    have hp : h3Multiplicity pa.1 = 1 :=
      (Finset.mem_filter.mp (Finset.mem_product.mp hpa).1).2
    rw [← hpas]
    simpa [hp] using h3_affine_syndrome_nearestLeaderCount pa.1 pa.2
  · obtain ⟨pa, hpa, hpas⟩ := Finset.mem_image.mp hs
    have hp : h3Multiplicity pa.1 = 5 :=
      (Finset.mem_filter.mp (Finset.mem_product.mp hpa).1).2
    rw [← hpas]
    simpa [hp] using h3_affine_syndrome_nearestLeaderCount pa.1 pa.2

/-- The incidence-one/incidence-five union is exactly the semantic one-nearest-leader syndrome
stratum. -/
theorem h3_one_leader_syndromes_eq_ambiguityOne :
    h3OneLeaderSyndromes = ambiguityOneSyndromes := by
  apply Finset.eq_of_subset_of_card_le
  · intro s hs
    rw [h3OneLeaderSyndromes] at hs
    rcases Finset.mem_union.mp hs with hs | hs
    · obtain ⟨pa, hpa, hpas⟩ := Finset.mem_image.mp hs
      subst s
      have hp : h3Multiplicity pa.1 = 1 :=
        (Finset.mem_filter.mp (Finset.mem_product.mp hpa).1).2
      let ray : AffineRay := (h3ProjectiveIndex pa.1, pa.2)
      have hindex : rawPointIndex (projectiveVec ray.1) = 1 := by
        calc
          rawPointIndex (projectiveVec ray.1) = h3Multiplicity pa.1 := by
            simpa [ray, h3Multiplicity] using
              (h3_multiplicity_eq_normalized_rawPointIndex pa.1).symm
          _ = 1 := hp
      have hcanonical : canonicalSyndromeDistance ray.1 = 2 := by
        simp [canonicalSyndromeDistance, hindex]
      apply Finset.mem_union_right
      apply Finset.mem_filter.mpr
      refine ⟨mem_affineSyndromesOfDistance_iff.mpr ⟨affineRayVec_ne_zero ray, ?_⟩, ?_⟩
      · simpa [h3AffineSyndrome, ray, hcanonical] using
          affineRay_syndromeDistance_exact ray
      · exact (affineRay_weightTwo_leader_count ray hcanonical).trans hindex
    · obtain ⟨pa, hpa, hpas⟩ := Finset.mem_image.mp hs
      subst s
      have hp : h3Multiplicity pa.1 = 5 :=
        (Finset.mem_filter.mp (Finset.mem_product.mp hpa).1).2
      let ray : AffineRay := (h3ProjectiveIndex pa.1, pa.2)
      have hindex : rawPointIndex (projectiveVec ray.1) = 5 := by
        calc
          rawPointIndex (projectiveVec ray.1) = h3Multiplicity pa.1 := by
            simpa [ray, h3Multiplicity] using
              (h3_multiplicity_eq_normalized_rawPointIndex pa.1).symm
          _ = 5 := hp
      have hcanonical : canonicalSyndromeDistance ray.1 = 1 := by
        simp [canonicalSyndromeDistance, hindex]
      apply Finset.mem_union_left
      apply mem_affineSyndromesOfDistance_iff.mpr
      refine ⟨affineRayVec_ne_zero ray, ?_⟩
      simpa [h3AffineSyndrome, ray, hcanonical] using
        affineRay_syndromeDistance_exact ray
  · rw [h3_one_leader_syndromes_card, ambiguity_strata_counts.1]

/-- Joint numerical census: the reduced-`H3` incidence-stratum sizes for incidence `0,1,2,3` together
with the Clebsch nearest-codeword ambiguity-census sizes.  This is a conjunction of cardinality
equalities only; it asserts no map, membership, or leader-count equivalence between the two
stratifications. -/
theorem h3_decoder_strata :
    (h3PointsOfMultiplicity 0).card = 12 ∧
    (h3PointsOfMultiplicity 1).card = 90 ∧
    (h3PointsOfMultiplicity 2).card = 15 ∧
    (h3PointsOfMultiplicity 3).card = 10 ∧
    ambiguityOneSyndromes.card = 960 ∧
    ambiguityTwoSyndromes.card = 150 ∧
    ambiguityThreeSyndromes.card = 100 ∧
    ambiguityTwentySyndromes.card = 120 := by
  exact ⟨h3_intersection_spectrum.1, h3_intersection_spectrum.2.1,
    h3_intersection_spectrum.2.2.1, h3_intersection_spectrum.2.2.2.1,
    ambiguity_strata_counts.1, ambiguity_strata_counts.2.1,
    ambiguity_strata_counts.2.2.1, ambiguity_strata_counts.2.2.2⟩

#print axioms h3_decoder_strata
#print axioms h3_affine_syndrome_injective
#print axioms h3_affine_syndrome_bijective
#print axioms h3_affine_syndromes_card
#print axioms h3_affine_syndrome_nearestLeaderCount
#print axioms h3_one_leader_strata_card
#print axioms h3_affine_syndromes_disjoint_of_ne
#print axioms h3_one_leader_syndromes_card
#print axioms h3_one_leader_syndromes_sound
#print axioms h3_one_leader_syndromes_eq_ambiguityOne

end RelativeConicArcs.Examples.ReflectionArrangements
