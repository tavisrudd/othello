import RelativeConicArcs.Q25PairResult
import RelativeConicArcs.Q25ResidualConclusionDispatchData.All

/-!
# Exact Q25 exceptional-profile minimum

This module lifts the checked orbit-`5` residual-row lower bound through the two projective
normalizations used by the semantic exceptional-profile theorem.
-/

namespace RelativeConicArcs
namespace Q25MinimumClassification

open Q25Coordinates Q25PairCertificate Q25Normalization Q25BaseNormalization
  Q25MinimumMask Q25ResidualAction Q25ResidualCoverData Q25ResidualConclusionDispatchData
  Q25PairResult Q25OrbitDecomposition QuadraticGlobalCount Configuration FiniteFields

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

theorem pairFresh_map_liftMapIdx_iff (g : Vec5 ≃ₗ[F5] Vec5)
    (C : Finset Idx25) (o : OrbitCode) :
    PairFresh (C.map (liftMapIdx g).toEmbedding) (liftMapOrbitCode g o) ↔
      PairFresh C o := by
  rw [PairFresh, PairFresh, Finset.disjoint_left, Finset.disjoint_left]
  constructor
  · intro h i hiC hio
    have hiCm : liftMapIdx g i ∈ C.map (liftMapIdx g).toEmbedding :=
      Finset.mem_map.mpr ⟨i, hiC, rfl⟩
    have hiom : liftMapIdx g i ∈ (orbitPair o).map (liftMapIdx g).toEmbedding :=
      Finset.mem_map.mpr ⟨i, hio, rfl⟩
    rw [liftMapOrbitCode_spec] at hiom
    exact h hiCm hiom
  · intro h i hiCm hiom
    obtain ⟨j, hjC, hji⟩ := Finset.mem_map.mp hiCm
    rw [← liftMapOrbitCode_spec] at hiom
    obtain ⟨k, hko, hki⟩ := Finset.mem_map.mp hiom
    have hjk : j = k := (liftMapIdx g).injective (hji.trans hki.symm)
    subst k
    exact h hjC hko

theorem legalPair_liftMapOrbitCode_iff (g : Vec5 ≃ₗ[F5] Vec5)
    {C D : Finset Idx25} (hmap : C.map (liftMapIdx g).toEmbedding = D)
    (hC : RawCap C) (hD : RawCap D) (o : OrbitCode) :
    LegalPair D (liftMapOrbitCode g o) ↔ LegalPair C o := by
  have hmapUnion :
      (C ∪ orbitPair o).map (liftMapIdx g).toEmbedding =
        D ∪ orbitPair (liftMapOrbitCode g o) := by
    rw [Finset.map_union, hmap, liftMapOrbitCode_spec]
  constructor
  · intro hlegal
    have hfreshMapped :
        PairFresh (C.map (liftMapIdx g).toEmbedding) (liftMapOrbitCode g o) := by
      rw [hmap]
      exact hlegal.pairFresh
    have hfresh : PairFresh C o :=
      (pairFresh_map_liftMapIdx_iff g C o).1 hfreshMapped
    have hcapMapped : RawCap ((C ∪ orbitPair o).map (liftMapIdx g).toEmbedding) := by
      rw [hmapUnion]
      exact hlegal.rawCap_union hD
    have hcap : RawCap (C ∪ orbitPair o) :=
      (rawCap_liftMapIdx g _).1 hcapMapped
    exact legalPair_of_pairFresh_rawCap_union hfresh hcap
  · intro hlegal
    have hfreshMapped :
        PairFresh (C.map (liftMapIdx g).toEmbedding) (liftMapOrbitCode g o) :=
      (pairFresh_map_liftMapIdx_iff g C o).2 hlegal.pairFresh
    have hfresh : PairFresh D (liftMapOrbitCode g o) := by
      rw [← hmap]
      exact hfreshMapped
    have hcapMapped : RawCap ((C ∪ orbitPair o).map (liftMapIdx g).toEmbedding) :=
      (rawCap_liftMapIdx g _).2 (hlegal.rawCap_union hC)
    have hcap : RawCap (D ∪ orbitPair (liftMapOrbitCode g o)) := by
      rw [← hmapUnion]
      exact hcapMapped
    exact legalPair_of_pairFresh_rawCap_union hfresh hcap

noncomputable def liftOrbitEquiv (g : Vec5 ≃ₗ[F5] Vec5) : OrbitCode ≃ OrbitCode :=
  Equiv.ofBijective (liftMapOrbitCode g)
    ⟨liftMapOrbitCode_injective g,
      Finite.surjective_of_injective (liftMapOrbitCode_injective g)⟩

theorem card_legalOrbitSet_liftMapIdx (g : Vec5 ≃ₗ[F5] Vec5)
    {C D : Finset Idx25} (hmap : C.map (liftMapIdx g).toEmbedding = D)
    (hC : RawCap C) (hD : RawCap D) :
    (legalOrbitSet C).card = (legalOrbitSet D).card := by
  let e := liftOrbitEquiv g
  have hset : (legalOrbitSet C).map e.toEmbedding = legalOrbitSet D := by
    ext o
    constructor
    · intro ho
      obtain ⟨t, ht, hto⟩ := Finset.mem_map.mp ho
      have htLegal : LegalPair C t := (Finset.mem_filter.mp ht).2
      have hmapt : liftMapOrbitCode g t = o := by
        simpa [e, liftOrbitEquiv] using hto
      apply Finset.mem_filter.mpr
      refine ⟨Finset.mem_univ o, ?_⟩
      rw [← hmapt]
      exact (legalPair_liftMapOrbitCode_iff g hmap hC hD t).2 htLegal
    · intro ho
      have hoLegal : LegalPair D o := (Finset.mem_filter.mp ho).2
      let t := e.symm o
      have hmapt : liftMapOrbitCode g t = o := by
        change e t = o
        exact e.apply_symm_apply o
      apply Finset.mem_map.mpr
      refine ⟨t, ?_, by simpa [e, liftOrbitEquiv] using hmapt⟩
      apply Finset.mem_filter.mpr
      refine ⟨Finset.mem_univ t, ?_⟩
      exact (legalPair_liftMapOrbitCode_iff g hmap hC hD t).1 (hmapt ▸ hoLegal)
  rw [← hset, Finset.card_map]

theorem individuallyGood_first {a b c : OrbitCode}
    (hraw : RawCap (normalizedConfig a b c)) : IndividuallyGood a := by
  unfold IndividuallyGood
  apply rawCap_mono (T := normalizedConfig a b c) ?_ hraw
  intro x hx
  simp [normalizedConfig] at hx ⊢
  tauto

theorem individuallyGood_second {a b c : OrbitCode}
    (hraw : RawCap (normalizedConfig a b c)) : IndividuallyGood b := by
  unfold IndividuallyGood
  apply rawCap_mono (T := normalizedConfig a b c) ?_ hraw
  intro x hx
  simp [normalizedConfig] at hx ⊢
  tauto

theorem individuallyGood_third {a b c : OrbitCode}
    (hraw : RawCap (normalizedConfig a b c)) : IndividuallyGood c := by
  unfold IndividuallyGood
  apply rawCap_mono (T := normalizedConfig a b c) ?_ hraw
  intro x hx
  simp [normalizedConfig] at hx ⊢
  tauto

/-- The residual rows fix orbit number `5`, which is the normalization's standard orbit. -/
theorem orbitCodeOfNumber_five : orbitCodeOfNumber (5 : Fin 310) = standardOrbit := by decide

theorem normalized_card_legalOrbitSet_ge_32
    {a b c : OrbitCode} (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c)
    (hraw : RawCap (normalizedConfig a b c)) :
    32 ≤ (legalOrbitSet (normalizedConfig a b c)).card := by
  have ha := (individuallyGood_iff_admissible a).1 (individuallyGood_first hraw)
  cases a with
  | affineY aa ab z =>
      simp only [Q25Normalization.Admissible] at ha
      let y := smallNonfixed aa ab
      have hy : imagPart y ≠ 0 := imagPart_smallNonfixed_ne_zero aa ab
      let d := mapOrbitCode y z hy ha b
      let e := mapOrbitCode y z hy ha c
      have hmapA : mapOrbitCode y z hy ha (.affineY aa ab z) = standardOrbit := by
        apply orbitPair_injective
        rw [← mapOrbitCode_spec]
        exact map_selected_orbit_to_standard ha
      have hmap :
          (normalizedConfig (.affineY aa ab z) b c).map
              (mapIdx y z hy ha).toEmbedding =
            normalizedConfig standardOrbit d e := by
        rw [normalizedConfig]
        simp only [Finset.map_union, map_fixedPair]
        rw [map_selected_orbit_to_standard, mapOrbitCode_spec, mapOrbitCode_spec]
        simp [normalizedConfig, d, e, Finset.union_assoc]
      have hmapResidual :
          (normalizedConfig (.affineY aa ab z) b c).map
              (residualEmbedding y z hy ha) =
            normalizedConfig standardOrbit d e := by
        rw [map_residualEmbedding]
        exact hmap
      have htargetRaw : RawCap (normalizedConfig standardOrbit d e) := by
        rw [← hmap]
        exact (rawCap_mapIdx y z hy ha _).2 hraw
      have hdGood : IndividuallyGood d := individuallyGood_second htargetRaw
      have heGood : IndividuallyGood e := individuallyGood_third htargetRaw
      have hinj := mapOrbitCode_injective y z hy ha
      have hdne : d ≠ standardOrbit := by
        intro hd
        exact hab (hinj (hmapA.trans hd.symm))
      have hene : e ≠ standardOrbit := by
        intro he
        exact hac (hinj (hmapA.trans he.symm))
      have hde : d ≠ e := by
        intro h
        exact hbc (hinj h)
      have hstandard : orbitNumber standardOrbit = 5 := by decide
      have hdgt : 5 < orbitNumber d := by
        have hge := five_le_orbitNumber_of_individuallyGood hdGood
        have hn : orbitNumber d ≠ 5 := by
          intro h
          exact hdne (orbitNumber_injective (h.trans hstandard.symm))
        omega
      have hegt : 5 < orbitNumber e := by
        have hge := five_le_orbitNumber_of_individuallyGood heGood
        have hn : orbitNumber e ≠ 5 := by
          intro h
          exact hene (orbitNumber_injective (h.trans hstandard.symm))
        omega
      let dn : Fin 310 := ⟨orbitNumber d, orbitNumber_lt d⟩
      let en : Fin 310 := ⟨orbitNumber e, orbitNumber_lt e⟩
      have hcard := card_legalOrbitSet_residual y z hy ha hmapResidual hraw htargetRaw
      rw [hcard]
      by_cases hlt : orbitNumber d < orbitNumber e
      · have hrow : normalizedConfig standardOrbit d e = rowConfig dn en := by
          simp [rowConfig, dn, en, orbitCodeOfNumber_five]
        rw [hrow] at htargetRaw ⊢
        exact concludeNormalizedRow dn en hdgt hlt htargetRaw
      · have hne : orbitNumber d ≠ orbitNumber e := by
          intro h
          exact hde (orbitNumber_injective h)
        have hlt' : orbitNumber e < orbitNumber d := by omega
        have hrow : normalizedConfig standardOrbit d e = rowConfig en dn := by
          simp [rowConfig, dn, en, orbitCodeOfNumber_five, normalizedConfig,
            Finset.union_assoc, Finset.union_left_comm, Finset.union_comm]
        rw [hrow] at htargetRaw ⊢
        exact concludeNormalizedRow en dn hegt hlt' htargetRaw
  | affineZ y aa ab => simp [Q25Normalization.Admissible] at ha
  | infinity aa ab => simp [Q25Normalization.Admissible] at ha

/-- Every indexed invariant exceptional-profile eight-cap has at least `32` legal orbits. -/
theorem indexed_f2_card_legalOrbitSet_ge_32 {S : Finset Idx25}
    (hArc : RawCap S) (hInv : IsConjInvariant S)
    (hcard : S.card = 8) (hfixed : (fixedPart S).card = 2) :
    32 ≤ (legalOrbitSet S).card := by
  obtain ⟨i, j, hij, hfix⟩ := Finset.card_eq_two.mp hfixed
  have hiFix : conjIdx i = i := by
    have : i ∈ fixedPart S := by rw [hfix]; simp
    exact (Finset.mem_filter.mp this).2
  have hjFix : conjIdx j = j := by
    have : j ∈ fixedPart S := by rw [hfix]; simp
    exact (Finset.mem_filter.mp this).2
  have hpq : basePointOfFixed i hiFix ≠ basePointOfFixed j hjFix := by
    intro hpq
    have hbc := congrArg (QuadraticFrobenius.projectiveBaseChange F5 K25) hpq
    rw [projectiveBaseChange_basePointOfFixed, projectiveBaseChange_basePointOfFixed] at hbc
    exact hij (point_injective hbc)
  obtain ⟨g, hgi, hgj⟩ := exists_base_map_pair hpq
  let T := S.map (liftMapIdx g).toEmbedding
  have hTArc : RawCap T := (rawCap_liftMapIdx g S).2 hArc
  have hTInv : IsConjInvariant T := invariant_map_liftMapIdx hInv g
  have hTcard : T.card = 8 := by simp [T, hcard]
  have hmapI : liftMapIdx g i = .vertical := liftMapIdx_fixed_to_A hiFix hgi
  have hmapJ : liftMapIdx g j = .infinity 0 := liftMapIdx_fixed_to_B hjFix hgj
  have hTfixed : fixedPart T = fixedPair := by
    change fixedPart (S.map (liftMapIdx g).toEmbedding) = fixedPair
    rw [fixedPart_map_liftMapIdx, hfix]
    simp [fixedPair, hmapI, hmapJ, Finset.pair_comm]
  have hTfixedCard : (fixedPart T).card = 2 := by rw [hTfixed, card_fixedPair]
  obtain ⟨a, b, c, hab, hac, hbc, hTdecomp⟩ :=
    exists_three_orbits hTInv hTcard hTfixedCard
  have hTnorm : T = normalizedConfig a b c := by
    rw [hTdecomp, hTfixed]
    simp [normalizedConfig, Finset.union_assoc]
  have hnormArc : RawCap (normalizedConfig a b c) := by rwa [← hTnorm]
  have hbaseCard := card_legalOrbitSet_liftMapIdx g (C := S) (D := T) rfl hArc hTArc
  rw [hbaseCard, hTnorm]
  exact normalized_card_legalOrbitSet_ge_32 hab hac hbc hnormArc

/-- **Projective exceptional-profile minimum.** Every invariant eight-arc in `PG(2,25)` with
exactly two fixed points has at least `32` semantic legal conjugate-pair extensions. -/
theorem f2_card_globalLegalPairs_ge_32
    (C : Finset Point25)
    (hArc : Arc (L := Point25) C)
    (hInv : FiniteGeom.BaerCompletion.IsInvariant
      (QuadraticFrobenius.incidence F5 K25 Q25PairResult.gf25_degree) C)
    (hcard : C.card = 8)
    (hfixed : (QuadraticLineCounting.fixedArcPoints F5 K25 C).card = 2) :
    32 ≤ (globalLegalPairs F5 K25 Q25PairResult.gf25_degree C).card := by
  classical
  let S : Finset Idx25 := C.map pointEquiv.symm.toEmbedding
  have hmemS (i : Idx25) : i ∈ S ↔ point i ∈ C := by
    simp [S]
  have hpointS : pointSetIdx S = C := by
    ext p
    simp [S, pointSetIdx]
  have hRaw : RawCap S := by
    rw [rawCap_iff_projectiveCap, hpointS]
    exact (ProjectiveBridge.arc_iff_projectiveCap C).mp hArc
  have hSInv : IsConjInvariant S := by
    intro i hi
    rw [hmemS] at hi ⊢
    rw [point_conjIdx]
    exact FiniteGeom.BaerCompletion.mem_of_invariant_conj
      (QuadraticFrobenius.incidence F5 K25 Q25PairResult.gf25_degree) hInv hi
  have hScard : S.card = 8 := by simp [S, hcard]
  have hfixedSet : pointSetIdx (fixedPart S) =
      QuadraticLineCounting.fixedArcPoints F5 K25 C := by
    ext p
    constructor
    · intro hp
      obtain ⟨i, hi, rfl⟩ := Finset.mem_map.mp hp
      have hiparts := Finset.mem_filter.mp hi
      apply Finset.mem_filter.mpr
      refine ⟨(hmemS i).1 hiparts.1, ?_⟩
      change ProjectiveConjugation.projectiveEquiv
          (QuadraticFrobenius.frobeniusRingEquiv F5 K25) (point i) = point i
      rw [← point_conjIdx, hiparts.2]
    · intro hp
      have hpparts := Finset.mem_filter.mp hp
      let i := pointEquiv.symm p
      have hpi : point i = p := by
        change pointEquiv i = p
        exact pointEquiv.apply_symm_apply p
      apply Finset.mem_map.mpr
      refine ⟨i, Finset.mem_filter.mpr ⟨(hmemS i).2 (by rw [hpi]; exact hpparts.1), ?_⟩,
        by simp [hpi]⟩
      apply point_injective
      rw [point_conjIdx, hpi]
      exact hpparts.2
  have hSfixed : (fixedPart S).card = 2 := by
    have hc := congrArg Finset.card hfixedSet
    simpa [pointSetIdx, hfixed] using hc
  have hlower := indexed_f2_card_legalOrbitSet_ge_32 hRaw hSInv hScard hSfixed
  let orbitEmbedding : OrbitCode ↪ Sym2 Point25 :=
    ⟨semanticOrbitPair, semanticOrbitPair_injective⟩
  have hsubset : (legalOrbitSet S).map orbitEmbedding ⊆
      globalLegalPairs F5 K25 Q25PairResult.gf25_degree C := by
    intro q hq
    obtain ⟨o, ho, rfl⟩ := Finset.mem_map.mp hq
    exact semanticOrbitPair_mem_globalLegalPairs hpointS hRaw
      (Finset.mem_filter.mp ho).2
  have hle := Finset.card_le_card hsubset
  rw [Finset.card_map] at hle
  exact hlower.trans hle

end Q25MinimumClassification
end RelativeConicArcs
