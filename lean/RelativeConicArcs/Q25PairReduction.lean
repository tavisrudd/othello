import RelativeConicArcs.Q25Normalization
import RelativeConicArcs.Q25PairData

/-!
# Reduction of the normalized exceptional profile to the checked `L_005` slice

This file contains no generated census.  It composes the Frobenius-compatible stabilizer
normalization with the one kernel-checked finite slice, and transports the certified legal orbit
back through the inverse projective permutation.
-/

namespace RelativeConicArcs
namespace Q25PairReduction

open Q25Coordinates Q25PairCertificate Q25Normalization FiniteFields

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

theorem individuallyGood_left {a b c : OrbitCode}
    (hC : RawCap (normalizedConfig a b c)) : IndividuallyGood a := by
  apply rawCap_mono (T := normalizedConfig a b c) _ hC
  intro x hx
  simp only [normalizedConfig] at hx ⊢
  aesop

theorem mapped_normalizedConfig {a : Fin 5} {b : Fin 2} {z : K25}
    (hz : imagPart z ≠ 0) (u v : OrbitCode) :
    (normalizedConfig (.affineY a b z) u v).map
        (mapIdx (smallNonfixed a b) z (imagPart_smallNonfixed_ne_zero a b) hz).toEmbedding =
      normalizedConfig standardOrbit
        (mapOrbitCode (smallNonfixed a b) z (imagPart_smallNonfixed_ne_zero a b) hz u)
        (mapOrbitCode (smallNonfixed a b) z (imagPart_smallNonfixed_ne_zero a b) hz v) := by
  rw [normalizedConfig, Finset.map_union, Finset.map_union, Finset.map_union,
    map_fixedPair, map_selected_orbit_to_standard, mapOrbitCode_spec, mapOrbitCode_spec]
  rfl

theorem mapped_selected_is_standard {a : Fin 5} {b : Fin 2} {z : K25}
    (hz : imagPart z ≠ 0) :
    mapOrbitCode (smallNonfixed a b) z (imagPart_smallNonfixed_ne_zero a b) hz
        (.affineY a b z) =
      standardOrbit := by
  apply orbitPair_injective
  rw [← mapOrbitCode_spec]
  exact map_selected_orbit_to_standard hz

/-- Pull a legal orbit through the inverse of the stabilizer normalization. -/
theorem exists_legalPair_preimage (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) {C D : Finset Idx25}
    (hmap : C.map (mapIdx y z hy hz).toEmbedding = D)
    (hC : RawCap C) (hD : RawCap D) {s : OrbitCode} (hs : LegalPair D s) :
    ∃ t : OrbitCode, mapOrbitCode y z hy hz t = s ∧ LegalPair C t := by
  let e := mapIdx y z hy hz
  have hsurj : Function.Surjective (mapOrbitCode y z hy hz) :=
    Finite.surjective_of_injective (mapOrbitCode_injective y z hy hz)
  obtain ⟨t, ht⟩ := hsurj s
  refine ⟨t, ht, ?_⟩
  have hpairMap := mapOrbitCode_spec y z hy hz t
  rw [ht] at hpairMap
  have hfreshMap : PairFresh D s := hs.pairFresh
  have hfresh : PairFresh C t := by
    rw [PairFresh, Finset.disjoint_left]
    intro x hxC hxt
    have hxCm : e x ∈ C.map e.toEmbedding :=
      Finset.mem_map.mpr ⟨x, hxC, rfl⟩
    rw [hmap] at hxCm
    have hxtm : e x ∈ (orbitPair t).map e.toEmbedding :=
      Finset.mem_map.mpr ⟨x, hxt, rfl⟩
    rw [hpairMap] at hxtm
    exact (Finset.disjoint_left.mp hfreshMap hxCm) hxtm
  have hcapDUnion : RawCap (D ∪ orbitPair s) := hs.rawCap_union hD
  have hmapUnion :
      (C ∪ orbitPair t).map e.toEmbedding = D ∪ orbitPair s := by
    rw [Finset.map_union, hmap, hpairMap]
  have hcapUnion : RawCap (C ∪ orbitPair t) :=
    (rawCap_mapIdx y z hy hz _).1 (by
      rw [hmapUnion]
      exact hcapDUnion)
  exact legalPair_of_pairFresh_rawCap_union hfresh hcapUnion

/-- **Kernel-checked normalized exceptional-profile multiplicity theorem.**  Every eight-point cap
made from the two standard fixed points and three distinct conjugate orbits has two distinct legal
conjugate-pair extensions. -/
theorem normalized_two_extension : NormalizedTwoExtensionStatement := by
  intro a b c hab hbc hC
  have haGood : IndividuallyGood a := individuallyGood_left hC
  have haAdm : Q25Normalization.Admissible a :=
    (individuallyGood_iff_admissible a).1 haGood
  cases a with
  | affineZ y aa bb => simp [Q25Normalization.Admissible] at haAdm
  | infinity aa bb => simp [Q25Normalization.Admissible] at haAdm
  | affineY aa bb z =>
      simp only [Q25Normalization.Admissible] at haAdm
      let e := mapIdx (smallNonfixed aa bb) z
        (imagPart_smallNonfixed_ne_zero aa bb) haAdm
      let q := mapOrbitCode (smallNonfixed aa bb) z
        (imagPart_smallNonfixed_ne_zero aa bb) haAdm b
      let r := mapOrbitCode (smallNonfixed aa bb) z
        (imagPart_smallNonfixed_ne_zero aa bb) haAdm c
      have hmap :
          (normalizedConfig (.affineY aa bb z) b c).map e.toEmbedding =
            normalizedConfig standardOrbit q r := by
        exact mapped_normalizedConfig haAdm b c
      have hD : RawCap (normalizedConfig standardOrbit q r) := by
        rw [← hmap]
        exact (rawCap_mapIdx (smallNonfixed aa bb) z
          (imagPart_smallNonfixed_ne_zero aa bb) haAdm _).2 hC
      have hqGood : IndividuallyGood q := by
        apply rawCap_mono (T := normalizedConfig standardOrbit q r) _ hD
        intro x hx
        simp only [normalizedConfig] at hx ⊢
        aesop
      have hrGood : IndividuallyGood r := by
        apply rawCap_mono (T := normalizedConfig standardOrbit q r) _ hD
        intro x hx
        simp only [normalizedConfig] at hx ⊢
        aesop
      have haMapped :
          mapOrbitCode (smallNonfixed aa bb) z (imagPart_smallNonfixed_ne_zero aa bb)
              haAdm (.affineY aa bb z) =
            standardOrbit := mapped_selected_is_standard haAdm
      have hq_ne_std : q ≠ standardOrbit := by
        intro hq
        have hba := mapOrbitCode_injective (smallNonfixed aa bb) z
          (imagPart_smallNonfixed_ne_zero aa bb) haAdm
          (show mapOrbitCode (smallNonfixed aa bb) z
                (imagPart_smallNonfixed_ne_zero aa bb) haAdm b =
              mapOrbitCode (smallNonfixed aa bb) z
                (imagPart_smallNonfixed_ne_zero aa bb) haAdm (.affineY aa bb z) by
            simpa [q, haMapped] using hq)
        subst b
        exact (Nat.lt_irrefl _ hab)
      have hr_ne_std : r ≠ standardOrbit := by
        intro hr
        have hca := mapOrbitCode_injective (smallNonfixed aa bb) z
          (imagPart_smallNonfixed_ne_zero aa bb) haAdm
          (show mapOrbitCode (smallNonfixed aa bb) z
                (imagPart_smallNonfixed_ne_zero aa bb) haAdm c =
              mapOrbitCode (smallNonfixed aa bb) z
                (imagPart_smallNonfixed_ne_zero aa bb) haAdm (.affineY aa bb z) by
            simpa [r, haMapped] using hr)
        subst c
        omega
      have hqr : q ≠ r := by
        intro hqr
        have hcb := mapOrbitCode_injective (smallNonfixed aa bb) z
          (imagPart_smallNonfixed_ne_zero aa bb) haAdm
          (by simpa [q, r] using hqr)
        subst c
        exact (Nat.lt_irrefl _ hbc)
      have horbitStd : orbitNumber standardOrbit = 5 := by decide
      have hfirst : orbitNumber (.affineY 0 0 (GF25.ofNat 5)) = 5 := by decide
      have hstdq : orbitNumber standardOrbit < orbitNumber q := by
        have hle := five_le_orbitNumber_of_individuallyGood hqGood
        have hne : orbitNumber q ≠ 5 := by
          intro heq
          apply hq_ne_std
          apply orbitNumber_injective
          omega
        omega
      have hstdr : orbitNumber standardOrbit < orbitNumber r := by
        have hle := five_le_orbitNumber_of_individuallyGood hrGood
        have hne : orbitNumber r ≠ 5 := by
          intro heq
          apply hr_ne_std
          apply orbitNumber_injective
          omega
        omega
      have hlegalD : ∃ s t : OrbitCode,
          TwoLegalPairs (normalizedConfig standardOrbit q r) s t := by
        rcases lt_or_gt_of_ne (fun h => hqr (orbitNumber_injective h)) with hqr' | hrq'
        · simpa only [standardOrbit, omega] using
            first_slice_two_005 q r (by simpa only [horbitStd, hfirst] using hstdq) hqr'
              (by simpa only [standardOrbit, omega] using hD)
        · have hDrq : RawCap (normalizedConfig standardOrbit r q) := by
            simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
              Finset.union_comm] using hD
          simpa [standardOrbit, omega, normalizedConfig, Finset.union_assoc,
            Finset.union_left_comm, Finset.union_comm] using
            first_slice_two_005 r q (by simpa only [horbitStd, hfirst] using hstdr) hrq'
              (by simpa only [standardOrbit, omega] using hDrq)
      obtain ⟨s, t, hst, hs, ht⟩ := hlegalD
      obtain ⟨u, huMap, hu⟩ := exists_legalPair_preimage
        (smallNonfixed aa bb) z (imagPart_smallNonfixed_ne_zero aa bb) haAdm
        hmap hC hD hs
      obtain ⟨v, hvMap, hv⟩ := exists_legalPair_preimage
        (smallNonfixed aa bb) z (imagPart_smallNonfixed_ne_zero aa bb) haAdm
        hmap hC hD ht
      refine ⟨u, v, ?_, hu, hv⟩
      intro huv
      apply hst
      rw [← huMap, ← hvMap, huv]

/-- The original one-witness theorem is a projection of the stronger normalized certificate. -/
theorem normalized_extension : NormalizedExtensionStatement := by
  intro a b c hab hbc hC
  obtain ⟨q, r, _hqr, hq, _hr⟩ := normalized_two_extension a b c hab hbc hC
  exact ⟨q, hq⟩

/-- Order-free form used after orbit decomposition. -/
theorem normalized_extension_distinct {a b c : OrbitCode}
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (hC : RawCap (normalizedConfig a b c)) :
    ∃ q : OrbitCode, LegalPair (normalizedConfig a b c) q := by
  have habn : orbitNumber a ≠ orbitNumber b := fun h => hab (orbitNumber_injective h)
  have hacn : orbitNumber a ≠ orbitNumber c := fun h => hac (orbitNumber_injective h)
  have hbcn : orbitNumber b ≠ orbitNumber c := fun h => hbc (orbitNumber_injective h)
  rcases lt_or_gt_of_ne habn with hab' | hba'
  · rcases lt_or_gt_of_ne hbcn with hbc' | hcb'
    · exact normalized_extension a b c hab' hbc' hC
    · rcases lt_or_gt_of_ne hacn with hac' | hca'
      · have hC' : RawCap (normalizedConfig a c b) := by
          simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
            Finset.union_comm] using hC
        simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
          Finset.union_comm] using normalized_extension a c b hac' hcb' hC'
      · have hC' : RawCap (normalizedConfig c a b) := by
          simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
            Finset.union_comm] using hC
        simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
          Finset.union_comm] using normalized_extension c a b hca' hab' hC'
  · rcases lt_or_gt_of_ne hacn with hac' | hca'
    · have hC' : RawCap (normalizedConfig b a c) := by
        simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
          Finset.union_comm] using hC
      simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
        Finset.union_comm] using normalized_extension b a c hba' hac' hC'
    · rcases lt_or_gt_of_ne hbcn with hbc' | hcb'
      · have hC' : RawCap (normalizedConfig b c a) := by
          simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
            Finset.union_comm] using hC
        simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
          Finset.union_comm] using normalized_extension b c a hbc' hca' hC'
      · have hC' : RawCap (normalizedConfig c b a) := by
          simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
            Finset.union_comm] using hC
        simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
          Finset.union_comm] using normalized_extension c b a hcb' hba' hC'

/-- Order-free two-witness form used after orbit decomposition. -/
theorem normalized_two_extension_distinct {a b c : OrbitCode}
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (hC : RawCap (normalizedConfig a b c)) :
    ∃ q r : OrbitCode, TwoLegalPairs (normalizedConfig a b c) q r := by
  have habn : orbitNumber a ≠ orbitNumber b := fun h => hab (orbitNumber_injective h)
  have hacn : orbitNumber a ≠ orbitNumber c := fun h => hac (orbitNumber_injective h)
  have hbcn : orbitNumber b ≠ orbitNumber c := fun h => hbc (orbitNumber_injective h)
  rcases lt_or_gt_of_ne habn with hab' | hba'
  · rcases lt_or_gt_of_ne hbcn with hbc' | hcb'
    · exact normalized_two_extension a b c hab' hbc' hC
    · rcases lt_or_gt_of_ne hacn with hac' | hca'
      · have hC' : RawCap (normalizedConfig a c b) := by
          simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
            Finset.union_comm] using hC
        simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
          Finset.union_comm] using normalized_two_extension a c b hac' hcb' hC'
      · have hC' : RawCap (normalizedConfig c a b) := by
          simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
            Finset.union_comm] using hC
        simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
          Finset.union_comm] using normalized_two_extension c a b hca' hab' hC'
  · rcases lt_or_gt_of_ne hacn with hac' | hca'
    · have hC' : RawCap (normalizedConfig b a c) := by
        simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
          Finset.union_comm] using hC
      simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
        Finset.union_comm] using normalized_two_extension b a c hba' hac' hC'
    · rcases lt_or_gt_of_ne hbcn with hbc' | hcb'
      · have hC' : RawCap (normalizedConfig b c a) := by
          simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
            Finset.union_comm] using hC
        simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
          Finset.union_comm] using normalized_two_extension b c a hbc' hca' hC'
      · have hC' : RawCap (normalizedConfig c b a) := by
          simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
            Finset.union_comm] using hC
        simpa [normalizedConfig, Finset.union_assoc, Finset.union_left_comm,
          Finset.union_comm] using normalized_two_extension c b a hcb' hba' hC'

end Q25PairReduction
end RelativeConicArcs
