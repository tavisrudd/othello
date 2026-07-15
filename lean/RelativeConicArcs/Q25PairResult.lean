import RelativeConicArcs.Q25BaseNormalization
import RelativeConicArcs.Q25OrbitDecomposition
import RelativeConicArcs.Q25PairReduction
import RelativeConicArcs.QuadraticGlobalCount

/-!
# Fully kernel-checked order-five exceptional-profile result

This file composes:

1. exact conjugate-orbit decomposition;
2. base-field normalization of the two fixed points;
3. stabilizer normalization of one nonfixed orbit;
4. the kernel-reduced `L_005` determinant certificate; and
5. projective transport of the returned legal conjugate pair.

The end theorem ranges over arbitrary indexed invariant eight-caps with exactly two fixed points.
-/

namespace RelativeConicArcs
namespace Q25PairResult

open Q25Coordinates Q25PairCertificate Q25Normalization Q25PairReduction
  Q25BaseNormalization Q25OrbitDecomposition QuadraticGlobalCount FiniteFields

set_option maxHeartbeats 500000000
set_option maxRecDepth 100000

theorem gf25_degree : Module.finrank F5 K25 = 2 := GF25.finrank

noncomputable def basePointOfFixed (i : Idx25) (hi : conjIdx i = i) :
    ProjectiveConjugation.Point F5 :=
  (QuadraticFrobenius.fixedPointEquiv F5 K25 gf25_degree).symm
    ⟨point i, by
      rw [← point_conjIdx, hi]⟩

theorem projectiveBaseChange_basePointOfFixed (i : Idx25) (hi : conjIdx i = i) :
    QuadraticFrobenius.projectiveBaseChange F5 K25 (basePointOfFixed i hi) = point i := by
  exact congrArg Subtype.val
    ((QuadraticFrobenius.fixedPointEquiv F5 K25 gf25_degree).apply_symm_apply
      ⟨point i, by rw [← point_conjIdx, hi]⟩)

theorem projectiveBaseChange_baseA :
    QuadraticFrobenius.projectiveBaseChange F5 K25 baseA = point .vertical := by
  rw [baseA, QuadraticFrobenius.projectiveBaseChange, Projectivization.map_mk,
    point, Certificate.toPoint, rawPoint]
  apply (Projectivization.mk_eq_mk_iff' K25 _ _ _ _).mpr
  refine ⟨1, ?_⟩
  ext i
  fin_cases i <;> rfl

theorem projectiveBaseChange_baseB :
    QuadraticFrobenius.projectiveBaseChange F5 K25 baseB = point (.infinity 0) := by
  rw [baseB, QuadraticFrobenius.projectiveBaseChange, Projectivization.map_mk,
    point, Certificate.toPoint, rawPoint]
  apply (Projectivization.mk_eq_mk_iff' K25 _ _ _ _).mpr
  refine ⟨1, ?_⟩
  ext i
  fin_cases i <;> rfl

theorem liftMapIdx_fixed_to_A {i : Idx25} (hi : conjIdx i = i)
    {g : Vec5 ≃ₗ[F5] Vec5}
    (hg : ProjectiveCap.Projective.mapEquiv g (basePointOfFixed i hi) = baseA) :
    liftMapIdx g i = .vertical := by
  apply point_injective
  rw [point_liftMapIdx, ← projectiveBaseChange_basePointOfFixed i hi,
    mapEquiv_liftBase_projectiveBaseChange, hg, projectiveBaseChange_baseA]

theorem liftMapIdx_fixed_to_B {i : Idx25} (hi : conjIdx i = i)
    {g : Vec5 ≃ₗ[F5] Vec5}
    (hg : ProjectiveCap.Projective.mapEquiv g (basePointOfFixed i hi) = baseB) :
    liftMapIdx g i = .infinity 0 := by
  apply point_injective
  rw [point_liftMapIdx, ← projectiveBaseChange_basePointOfFixed i hi,
    mapEquiv_liftBase_projectiveBaseChange, hg, projectiveBaseChange_baseB]

theorem fixedPart_map_liftMapIdx (g : Vec5 ≃ₗ[F5] Vec5) (S : Finset Idx25) :
    fixedPart (S.map (liftMapIdx g).toEmbedding) =
      (fixedPart S).map (liftMapIdx g).toEmbedding := by
  ext x
  constructor
  · intro hx
    have hxparts := Finset.mem_filter.mp hx
    obtain ⟨i, hiS, hix⟩ := Finset.mem_map.mp hxparts.1
    subst x
    apply Finset.mem_map.mpr
    refine ⟨i, Finset.mem_filter.mpr ⟨hiS, ?_⟩, rfl⟩
    apply (liftMapIdx g).injective
    rw [liftMapIdx_conjIdx]
    exact hxparts.2
  · intro hx
    obtain ⟨i, hi, hix⟩ := Finset.mem_map.mp hx
    subst x
    have hiparts := Finset.mem_filter.mp hi
    apply Finset.mem_filter.mpr
    refine ⟨Finset.mem_map.mpr ⟨i, hiparts.1, rfl⟩, ?_⟩
    change conjIdx (liftMapIdx g i) = liftMapIdx g i
    rw [← liftMapIdx_conjIdx, hiparts.2]

theorem invariant_map_liftMapIdx {S : Finset Idx25} (hS : IsConjInvariant S)
    (g : Vec5 ≃ₗ[F5] Vec5) :
    IsConjInvariant (S.map (liftMapIdx g).toEmbedding) := by
  intro x hx
  obtain ⟨i, hiS, rfl⟩ := Finset.mem_map.mp hx
  change conjIdx (liftMapIdx g i) ∈ S.map (liftMapIdx g).toEmbedding
  rw [← liftMapIdx_conjIdx]
  exact Finset.mem_map.mpr ⟨conjIdx i, hS i hiS, rfl⟩

/-- Pull a legal orbit through a base-field normalization. -/
theorem exists_legalPair_lift_preimage (g : Vec5 ≃ₗ[F5] Vec5)
    {S T : Finset Idx25}
    (hmap : S.map (liftMapIdx g).toEmbedding = T)
    (hS : RawCap S) (hT : RawCap T) {q : OrbitCode} (hq : LegalPair T q) :
    ∃ r : OrbitCode, liftMapOrbitCode g r = q ∧ LegalPair S r := by
  have hsurj : Function.Surjective (liftMapOrbitCode g) :=
    Finite.surjective_of_injective (liftMapOrbitCode_injective g)
  obtain ⟨r, hr⟩ := hsurj q
  refine ⟨r, hr, ?_⟩
  have hpairMap := liftMapOrbitCode_spec g r
  rw [hr] at hpairMap
  have hfreshMap : PairFresh T q := hq.pairFresh
  have hfresh : PairFresh S r := by
    rw [PairFresh, Finset.disjoint_left]
    intro x hxS hxr
    have hxT : liftMapIdx g x ∈ T := by
      rw [← hmap]
      exact Finset.mem_map.mpr ⟨x, hxS, rfl⟩
    have hxrMap : liftMapIdx g x ∈ (orbitPair r).map (liftMapIdx g).toEmbedding :=
      Finset.mem_map.mpr ⟨x, hxr, rfl⟩
    rw [hpairMap] at hxrMap
    exact (Finset.disjoint_left.mp hfreshMap hxT) hxrMap
  have hTUnion : RawCap (T ∪ orbitPair q) := hq.rawCap_union hT
  have hmapUnion :
      (S ∪ orbitPair r).map (liftMapIdx g).toEmbedding = T ∪ orbitPair q := by
    rw [Finset.map_union, hmap, hpairMap]
  have hSUnion : RawCap (S ∪ orbitPair r) :=
    (rawCap_liftMapIdx g (S ∪ orbitPair r)).1 (by
      rw [hmapUnion]
      exact hTUnion)
  exact legalPair_of_pairFresh_rawCap_union hfresh hSUnion

/-- **Exceptional `(f,e)=(2,3)` multiplicity theorem over `PG(2,25)`.**  Every
Frobenius-invariant eight-cap with exactly two fixed points has two distinct legal nonfixed
conjugate-pair extensions. -/
theorem indexed_f2_two_pair_extension {S : Finset Idx25}
    (hArc : RawCap S) (hInv : IsConjInvariant S)
    (hcard : S.card = 8) (hfixed : (fixedPart S).card = 2) :
    ∃ q r : OrbitCode, TwoLegalPairs S q r := by
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
  obtain ⟨q, r, hqr, hq, hr⟩ :=
    normalized_two_extension_distinct hab hac hbc hnormArc
  have hqT : LegalPair T q := by rwa [hTnorm]
  have hrT : LegalPair T r := by rwa [hTnorm]
  obtain ⟨u, huMap, hu⟩ := exists_legalPair_lift_preimage g rfl hArc hTArc hqT
  obtain ⟨v, hvMap, hv⟩ := exists_legalPair_lift_preimage g rfl hArc hTArc hrT
  refine ⟨u, v, ?_, hu, hv⟩
  intro huv
  apply hqr
  rw [← huMap, ← hvMap, huv]

/-- The original one-witness exceptional-profile theorem is a projection of multiplicity. -/
theorem indexed_f2_pair_extension {S : Finset Idx25}
    (hArc : RawCap S) (hInv : IsConjInvariant S)
    (hcard : S.card = 8) (hfixed : (fixedPart S).card = 2) :
    ∃ q : OrbitCode, LegalPair S q := by
  obtain ⟨q, r, _hqr, hq, _hr⟩ :=
    indexed_f2_two_pair_extension hArc hInv hcard hfixed
  exact ⟨q, hq⟩

/-! ## Paper-facing projective theorem -/

noncomputable local instance : Fintype Point25 := Fintype.ofFinite _
noncomputable local instance : DecidableEq Point25 := Classical.decEq _

/-- The semantic unordered Frobenius pair represented by a coordinate orbit code. -/
noncomputable def semanticOrbitPair (q : OrbitCode) : Sym2 Point25 :=
  s(point (orbitIdx q), point (conjIdx (orbitIdx q)))

theorem semanticOrbitPair_toFinset (q : OrbitCode) :
    (semanticOrbitPair q).toFinset = pointSetIdx (orbitPair q) := by
  simp [semanticOrbitPair, Sym2.toFinset_mk_eq, pointSetIdx, orbitPair]

theorem semanticOrbitPair_injective : Function.Injective semanticOrbitPair := by
  intro q r hqr
  apply orbitPair_injective
  apply Finset.map_injective pointEquiv.toEmbedding
  simpa [pointSetIdx, semanticOrbitPair_toFinset] using congrArg Sym2.toFinset hqr

theorem semanticOrbitPair_mem_globalLegalPairs
    {C : Finset Point25} {S : Finset Idx25}
    (hpointS : pointSetIdx S = C) (hRaw : RawCap S)
    {q : OrbitCode} (hq : LegalPair S q) :
    semanticOrbitPair q ∈ globalLegalPairs F5 K25 gf25_degree C := by
  rw [mem_globalLegalPairs_iff]
  refine ⟨?_, ?_⟩
  · refine ⟨point (orbitIdx q), ?_, ?_, ?_⟩
    · intro hpfix
      have hpidx : conjIdx (orbitIdx q) = orbitIdx q := by
        apply point_injective
        rw [point_conjIdx]
        exact hpfix
      have hrank := congrArg rank hpidx
      exact (Nat.ne_of_lt (orbitIdx_lt_conj q)) hrank.symm
    · have hconj :
          (QuadraticFrobenius.incidence F5 K25 gf25_degree).pointConj
              (point (orbitIdx q)) =
            point (conjIdx (orbitIdx q)) := by
          change ProjectiveConjugation.projectiveEquiv
              (QuadraticFrobenius.frobeniusRingEquiv F5 K25) (point (orbitIdx q)) = _
          rw [← point_conjIdx]
      rw [semanticOrbitPair, hconj]
    · rw [semanticOrbitPair_toFinset, ← hpointS]
      apply (Finset.disjoint_map pointEquiv.toEmbedding).mpr
      exact hq.pairFresh.symm
  · have hRawUnion := hq.rawCap_union hRaw
    have hArcUnion : Arc (L := Point25) (pointSetIdx (S ∪ orbitPair q)) := by
      rw [ProjectiveBridge.arc_iff_projectiveCap]
      exact (rawCap_iff_projectiveCap (S ∪ orbitPair q)).mp hRawUnion
    have hset : pointSetIdx (S ∪ orbitPair q) =
        C ∪ (semanticOrbitPair q).toFinset := by
      calc
        pointSetIdx (S ∪ orbitPair q) =
            pointSetIdx S ∪ pointSetIdx (orbitPair q) := by
          simp [pointSetIdx, Finset.map_union]
        _ = C ∪ (semanticOrbitPair q).toFinset := by
          rw [hpointS, semanticOrbitPair_toFinset]
    rwa [hset] at hArcUnion

/-- **Projective exceptional-profile multiplicity theorem.**  Every Frobenius-invariant
eight-arc in `PG(2,25)` with exactly two selected fixed points has two distinct semantic legal
conjugate-pair extensions. -/
theorem f2_two_pair_extension
    (C : Finset Point25)
    (hArc : Arc (L := Point25) C)
    (hInv : FiniteGeom.BaerCompletion.IsInvariant
      (QuadraticFrobenius.incidence F5 K25 gf25_degree) C)
    (hcard : C.card = 8)
    (hfixed : (QuadraticLineCounting.fixedArcPoints F5 K25 C).card = 2) :
    ∃ q r : Sym2 Point25,
      q ≠ r ∧
      q ∈ globalLegalPairs F5 K25 gf25_degree C ∧
      r ∈ globalLegalPairs F5 K25 gf25_degree C := by
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
      (QuadraticFrobenius.incidence F5 K25 gf25_degree) hInv hi
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
  obtain ⟨q, r, hqr, hq, hr⟩ :=
    indexed_f2_two_pair_extension hRaw hSInv hScard hSfixed
  refine ⟨semanticOrbitPair q, semanticOrbitPair r,
    (fun h => hqr (semanticOrbitPair_injective h)), ?_, ?_⟩
  · exact semanticOrbitPair_mem_globalLegalPairs hpointS hRaw hq
  · exact semanticOrbitPair_mem_globalLegalPairs hpointS hRaw hr

/-- **Projective exceptional-profile theorem.**  Every Frobenius-invariant eight-arc in
`PG(2,25)` with exactly two selected fixed points admits a fresh nonfixed point together with its
conjugate, and adjoining that pair preserves the arc property. -/
theorem f2_pair_extension
    (C : Finset Point25)
    (hArc : Arc (L := Point25) C)
    (hInv : FiniteGeom.BaerCompletion.IsInvariant
      (QuadraticFrobenius.incidence F5 K25 gf25_degree) C)
    (hcard : C.card = 8)
    (hfixed : (QuadraticLineCounting.fixedArcPoints F5 K25 C).card = 2) :
    ∃ p : Point25,
      ProjectiveConjugation.projectiveEquiv
          (QuadraticFrobenius.frobeniusRingEquiv F5 K25) p ≠ p ∧
      p ∉ C ∧
      ProjectiveConjugation.projectiveEquiv
          (QuadraticFrobenius.frobeniusRingEquiv F5 K25) p ∉ C ∧
      Arc (L := Point25)
        (C ∪ {p,
          ProjectiveConjugation.projectiveEquiv
            (QuadraticFrobenius.frobeniusRingEquiv F5 K25) p}) := by
  obtain ⟨q, r, _hqr, hq, _hr⟩ := f2_two_pair_extension C hArc hInv hcard hfixed
  rw [mem_globalLegalPairs_iff] at hq
  obtain ⟨⟨p, hp, rfl, hdisj⟩, hArcUnion⟩ := hq
  refine ⟨p, hp, ?_, ?_, ?_⟩
  · intro hpC
    exact (Finset.disjoint_left.mp hdisj (by simp [Sym2.toFinset_mk_eq])) hpC
  · intro hpC
    change (QuadraticFrobenius.incidence F5 K25 gf25_degree).pointConj p ∈ C at hpC
    exact (Finset.disjoint_left.mp hdisj (by simp [Sym2.toFinset_mk_eq])) hpC
  · change Arc (L := Point25)
      (C ∪ {p, (QuadraticFrobenius.incidence F5 K25 gf25_degree).pointConj p})
    simpa [Sym2.toFinset_mk_eq] using hArcUnion

end Q25PairResult
end RelativeConicArcs
