import RelativeConicArcs.Q25MinimumMask

/-!
# The computable order-400 residual action in `PG(2,25)`

The fixed-pair stabilizer used by the C151 quotient is the family of independent affine changes in
the last two coordinates, with nonzero base-field scales.  `Q25Normalization.mapIdx` already proves
the corresponding projective map is an equivalence and preserves caps.  This file exposes the same
map by an executable formula, so generated orbit-cover certificates can reduce coordinate images
without unfolding the noncomputable projective equivalence.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace Q25ResidualAction

open Q25Coordinates Q25PairCertificate Q25Normalization Q25MinimumMask FiniteFields

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

abbrev AdmissibleCoordinate := {x : K25 // imagPart x ≠ 0}

/-- The two independent affine coordinate changes give exactly `20 * 20 = 400` maps. -/
abbrev ResidualParameter := AdmissibleCoordinate × AdmissibleCoordinate

theorem card_admissibleCoordinate : Fintype.card AdmissibleCoordinate = 20 := by decide

theorem card_residualParameter : Fintype.card ResidualParameter = 400 := by decide

/-- Executable canonical-coordinate form of the residual projective transformation. -/
def residualApply (y z : K25) : Idx25 → Idx25
  | .affine u v => .affine (shift y + scale y * u) (shift z + scale z * v)
  | .infinity v => .infinity ((scale y)⁻¹ * scale z * v)
  | .vertical => .vertical

/-- The executable formula is exactly the already-proved projective normalizer. -/
theorem mapIdx_eq_residualApply (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) (i : Idx25) :
    mapIdx y z hy hz i = residualApply y z i := by
  cases i with
  | affine u v =>
      apply point_injective
      rw [point_mapIdx]
      change
        ProjectiveCap.Projective.mapEquiv (normalizer y z hy hz)
            (Projectivization.mk K25 (vec (.affine u v)) (vec_ne_zero _)) =
          Projectivization.mk K25 (vec (residualApply y z (.affine u v))) (vec_ne_zero _)
      have hvec :
          normalizer y z hy hz (vec (.affine u v)) =
            vec (residualApply y z (.affine u v)) := by
        ext j
        fin_cases j <;> simp [normalizer, residualApply, vec]
      exact ProjectiveCap.Projective.mapEquiv_mk_eq_mk
        (vec_ne_zero _) (vec_ne_zero _) hvec
  | infinity v =>
      apply point_injective
      rw [point_mapIdx]
      change
        ProjectiveCap.Projective.mapEquiv (normalizer y z hy hz)
            (Projectivization.mk K25 (vec (.infinity v)) (vec_ne_zero _)) =
          Projectivization.mk K25 (vec (residualApply y z (.infinity v))) (vec_ne_zero _)
      rw [ProjectiveCap.Projective.mapEquiv_mk]
      apply (Projectivization.mk_eq_mk_iff' K25 _ _ _ _).mpr
      refine ⟨scale y, ?_⟩
      have hsy := scale_ne_zero hy
      ext j
      fin_cases j
      · simp [normalizer, residualApply, vec]
      · simp [normalizer, residualApply, vec]
      · simp [normalizer, residualApply, vec]
        field_simp
  | vertical =>
      exact mapIdx_fixedA y z hy hz

theorem residualApply_injective (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) : Function.Injective (residualApply y z) := by
  intro i j hij
  apply (mapIdx y z hy hz).injective
  simpa only [mapIdx_eq_residualApply] using hij

/-- Computable embedding used by generated finite-set image certificates. -/
def residualEmbedding (y z : K25) (hy : imagPart y ≠ 0) (hz : imagPart z ≠ 0) :
    Idx25 ↪ Idx25 :=
  ⟨residualApply y z, residualApply_injective y z hy hz⟩

def parameterEmbedding (g : ResidualParameter) : Idx25 ↪ Idx25 :=
  residualEmbedding g.1.1 g.2.1 g.1.2 g.2.2

theorem map_residualEmbedding (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) (S : Finset Idx25) :
    S.map (residualEmbedding y z hy hz) = S.map (mapIdx y z hy hz).toEmbedding := by
  ext i
  simp only [Finset.mem_map]
  constructor
  · rintro ⟨j, hj, rfl⟩
    exact ⟨j, hj, mapIdx_eq_residualApply y z hy hz j⟩
  · rintro ⟨j, hj, rfl⟩
    exact ⟨j, hj, (mapIdx_eq_residualApply y z hy hz j).symm⟩

/-- Executable residual images preserve the coordinate cap predicate. -/
theorem rawCap_map_residualEmbedding (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) (S : Finset Idx25) :
    RawCap (S.map (residualEmbedding y z hy hz)) ↔ RawCap S := by
  rw [map_residualEmbedding]
  exact rawCap_mapIdx y z hy hz S

theorem map_orbitPair_residualEmbedding (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) (o : OrbitCode) :
    (orbitPair o).map (residualEmbedding y z hy hz) =
      orbitPair (mapOrbitCode y z hy hz o) := by
  rw [map_residualEmbedding]
  exact mapOrbitCode_spec y z hy hz o

theorem pairFresh_map_residualEmbedding_iff (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) (C : Finset Idx25) (o : OrbitCode) :
    PairFresh (C.map (residualEmbedding y z hy hz)) (mapOrbitCode y z hy hz o) ↔
      PairFresh C o := by
  rw [PairFresh, PairFresh, Finset.disjoint_left, Finset.disjoint_left]
  constructor
  · intro h i hiC hio
    have hiCm : residualApply y z i ∈ C.map (residualEmbedding y z hy hz) :=
      Finset.mem_map.mpr ⟨i, hiC, rfl⟩
    have hiom : residualApply y z i ∈
        (orbitPair o).map (residualEmbedding y z hy hz) :=
      Finset.mem_map.mpr ⟨i, hio, rfl⟩
    rw [map_orbitPair_residualEmbedding] at hiom
    exact h hiCm hiom
  · intro h i hiCm hiom
    obtain ⟨j, hjC, hji⟩ := Finset.mem_map.mp hiCm
    rw [← map_orbitPair_residualEmbedding] at hiom
    obtain ⟨k, hko, hki⟩ := Finset.mem_map.mp hiom
    have hjk : j = k := (residualApply_injective y z hy hz) (hji.trans hki.symm)
    subst k
    exact h hjC hko

/-- Residual transformations preserve legality of the corresponding conjugate orbit. -/
theorem legalPair_mapOrbitCode_iff (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) {C D : Finset Idx25}
    (hmap : C.map (residualEmbedding y z hy hz) = D)
    (hC : RawCap C) (hD : RawCap D) (o : OrbitCode) :
    LegalPair D (mapOrbitCode y z hy hz o) ↔ LegalPair C o := by
  have hmapUnion :
      (C ∪ orbitPair o).map (residualEmbedding y z hy hz) =
        D ∪ orbitPair (mapOrbitCode y z hy hz o) := by
    rw [Finset.map_union, hmap, map_orbitPair_residualEmbedding]
  constructor
  · intro hlegal
    have hfreshMapped :
        PairFresh (C.map (residualEmbedding y z hy hz)) (mapOrbitCode y z hy hz o) := by
      rw [hmap]
      exact hlegal.pairFresh
    have hfresh : PairFresh C o :=
      (pairFresh_map_residualEmbedding_iff y z hy hz C o).1 hfreshMapped
    have hcapMapped : RawCap ((C ∪ orbitPair o).map (residualEmbedding y z hy hz)) := by
      rw [hmapUnion]
      exact hlegal.rawCap_union hD
    have hcap : RawCap (C ∪ orbitPair o) :=
      (rawCap_map_residualEmbedding y z hy hz _).1 hcapMapped
    exact legalPair_of_pairFresh_rawCap_union hfresh hcap
  · intro hlegal
    have hfreshMapped :
        PairFresh (C.map (residualEmbedding y z hy hz)) (mapOrbitCode y z hy hz o) :=
      (pairFresh_map_residualEmbedding_iff y z hy hz C o).2 hlegal.pairFresh
    have hfresh : PairFresh D (mapOrbitCode y z hy hz o) := by
      rw [← hmap]
      exact hfreshMapped
    have hcapMapped : RawCap ((C ∪ orbitPair o).map (residualEmbedding y z hy hz)) :=
      (rawCap_map_residualEmbedding y z hy hz _).2 (hlegal.rawCap_union hC)
    have hcap : RawCap (D ∪ orbitPair (mapOrbitCode y z hy hz o)) := by
      rw [← hmapUnion]
      exact hcapMapped
    exact legalPair_of_pairFresh_rawCap_union hfresh hcap

noncomputable def residualOrbitEquiv (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) : OrbitCode ≃ OrbitCode :=
  Equiv.ofBijective (mapOrbitCode y z hy hz)
    ⟨mapOrbitCode_injective y z hy hz,
      Finite.surjective_of_injective (mapOrbitCode_injective y z hy hz)⟩

/-- The order-400 residual action preserves the exact number of legal conjugate-pair extensions. -/
theorem card_legalOrbitSet_residual (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) {C D : Finset Idx25}
    (hmap : C.map (residualEmbedding y z hy hz) = D)
    (hC : RawCap C) (hD : RawCap D) :
    (legalOrbitSet C).card = (legalOrbitSet D).card := by
  let e := residualOrbitEquiv y z hy hz
  have hset : (legalOrbitSet C).map e.toEmbedding = legalOrbitSet D := by
    ext o
    constructor
    · intro ho
      obtain ⟨t, ht, hto⟩ := Finset.mem_map.mp ho
      have htLegal : LegalPair C t := (Finset.mem_filter.mp ht).2
      have hmapt : mapOrbitCode y z hy hz t = o := by
        simpa [e, residualOrbitEquiv] using hto
      apply Finset.mem_filter.mpr
      refine ⟨Finset.mem_univ o, ?_⟩
      rw [← hmapt]
      exact (legalPair_mapOrbitCode_iff y z hy hz hmap hC hD t).2 htLegal
    · intro ho
      have hoLegal : LegalPair D o := (Finset.mem_filter.mp ho).2
      let t := e.symm o
      have hmapt : mapOrbitCode y z hy hz t = o := by
        change e t = o
        exact e.apply_symm_apply o
      apply Finset.mem_map.mpr
      refine ⟨t, ?_, by simpa [e, residualOrbitEquiv] using hmapt⟩
      apply Finset.mem_filter.mpr
      refine ⟨Finset.mem_univ t, ?_⟩
      exact (legalPair_mapOrbitCode_iff y z hy hz hmap hC hD t).1 (hmapt ▸ hoLegal)
  rw [← hset, Finset.card_map]

end Q25ResidualAction
end RelativeConicArcs
