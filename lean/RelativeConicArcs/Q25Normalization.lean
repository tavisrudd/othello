import RelativeConicArcs.Q25PairCertificate
import ProjectiveCap.PlaneTransitivity

/-!
# Frobenius-compatible normalization of an invariant four-cap in `PG(2,25)`

After the two fixed points are `[0:0:1]` and `[0:1:0]`, every conjugate pair compatible with
them has a representative `[1:y:z]` with both imaginary coefficients nonzero.  Independent affine
changes in the last two coordinates, defined over `GF(5)`, send it to `[1:ω:ω]` while fixing the
two fixed points.  This file formalizes that stabilizer reduction and proves that it commutes with
quadratic Frobenius.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace Q25Normalization

open Q25Coordinates Q25PairCertificate FiniteFields

set_option maxHeartbeats 200000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

def realPart (x : K25) : F5 := ((x.val.val % 5 : Nat) : F5)
def imagPart (x : K25) : F5 := ((x.val.val / 5 : Nat) : F5)

def omega : K25 := GF25.ofNat 5

lemma assemble (a b : F5) :
    algebraMap F5 K25 a + algebraMap F5 K25 b * omega =
      GF25.encode a.val b.val := by
  revert a b
  decide

theorem reconstruct (x : K25) :
    algebraMap F5 K25 (realPart x) + algebraMap F5 K25 (imagPart x) * omega = x := by
  rw [assemble]
  simpa [GF25.coeffEquiv, realPart, imagPart] using GF25.coeffEquiv.symm_apply_apply x

def scale (x : K25) : K25 := algebraMap F5 K25 (imagPart x)⁻¹
def shift (x : K25) : K25 := -scale x * algebraMap F5 K25 (realPart x)

theorem scale_ne_zero {x : K25} (hx : imagPart x ≠ 0) : scale x ≠ 0 := by
  exact (map_ne_zero (algebraMap F5 K25)).2 (inv_ne_zero hx)

theorem normalize_coordinate (x : K25) (hx : imagPart x ≠ 0) :
    shift x + scale x * x = omega := by
  have hrec := reconstruct x
  calc
    shift x + scale x * x = shift x + scale x *
        (algebraMap F5 K25 (realPart x) +
          algebraMap F5 K25 (imagPart x) * omega) :=
      congrArg (fun t => shift x + scale x * t) hrec.symm
    _ = -algebraMap F5 K25 (imagPart x)⁻¹ * algebraMap F5 K25 (realPart x) +
        algebraMap F5 K25 (imagPart x)⁻¹ *
          (algebraMap F5 K25 (realPart x) +
            algebraMap F5 K25 (imagPart x) * omega) := rfl
    _ = algebraMap F5 K25 (imagPart x)⁻¹ *
        algebraMap F5 K25 (imagPart x) * omega := by ring
    _ = omega := by
      rw [← map_mul, inv_mul_cancel₀ hx, map_one, one_mul]

theorem conj_algebraMap (a : F5) :
    Q25Coordinates.conj (algebraMap F5 K25 a) = algebraMap F5 K25 a := by
  revert a
  decide

theorem conj_neg (a : K25) :
    Q25Coordinates.conj (-a) = -Q25Coordinates.conj a := by
  exact Q25Coordinates.conjRingEquiv.map_neg a

theorem conj_scale (x : K25) : Q25Coordinates.conj (scale x) = scale x := by
  exact conj_algebraMap _

theorem conj_shift (x : K25) : Q25Coordinates.conj (shift x) = shift x := by
  simp only [shift, Q25Coordinates.conj_mul, conj_neg, conj_algebraMap]
  rw [conj_scale]

/-- The triangular coordinate change fixing the two standard fixed points. -/
def normalizer (y z : K25) (hy : imagPart y ≠ 0) (hz : imagPart z ≠ 0) :
    (Fin 3 → K25) ≃ₗ[K25] (Fin 3 → K25) where
  toFun v := ![v 0,
    shift y * v 0 + scale y * v 1,
    shift z * v 0 + scale z * v 2]
  invFun v := ![v 0,
    (scale y)⁻¹ * (v 1 - shift y * v 0),
    (scale z)⁻¹ * (v 2 - shift z * v 0)]
  left_inv v := by
    have hsy := scale_ne_zero hy
    have hsz := scale_ne_zero hz
    ext i
    fin_cases i <;> simp [hsy, hsz] <;> field_simp <;> ring
  right_inv v := by
    have hsy := scale_ne_zero hy
    have hsz := scale_ne_zero hz
    ext i
    fin_cases i <;> simp [hsy, hsz] <;> field_simp <;> ring
  map_add' v w := by
    ext i
    fin_cases i <;> simp <;> ring
  map_smul' a v := by
    ext i
    fin_cases i <;> simp <;> ring

@[simp] theorem normalizer_apply (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) (v : Fin 3 → K25) :
    normalizer y z hy hz v = ![v 0,
      shift y * v 0 + scale y * v 1,
      shift z * v 0 + scale z * v 2] := rfl

theorem normalizer_fixedA (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) :
    normalizer y z hy hz (vec .vertical) = scale z • vec .vertical := by
  ext i
  fin_cases i <;> simp [vec, normalizer]

theorem normalizer_fixedB (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) :
    normalizer y z hy hz (vec (.infinity 0)) = scale y • vec (.infinity 0) := by
  ext i
  fin_cases i <;> simp [vec, normalizer]

theorem normalizer_affine (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) :
    normalizer y z hy hz (vec (.affine y z)) = vec (.affine omega omega) := by
  ext i
  fin_cases i <;> simp [vec, normalizer, normalize_coordinate y hy,
    normalize_coordinate z hz]

/-- The coordinate change commutes exactly with coefficient conjugation. -/
theorem normalizer_conj (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) (v : Fin 3 → K25) :
    normalizer y z hy hz
        (ProjectiveConjugation.coordinatewise Q25Coordinates.conjRingEquiv v) =
      ProjectiveConjugation.coordinatewise Q25Coordinates.conjRingEquiv
        (normalizer y z hy hz v) := by
  ext i
  fin_cases i
  · rfl
  · change shift y * Q25Coordinates.conj (v 0) +
        scale y * Q25Coordinates.conj (v 1) =
      Q25Coordinates.conj (shift y * v 0 + scale y * v 1)
    rw [Q25Coordinates.conj_add, Q25Coordinates.conj_mul, Q25Coordinates.conj_mul,
      conj_shift, conj_scale]
  · change shift z * Q25Coordinates.conj (v 0) +
        scale z * Q25Coordinates.conj (v 2) =
      Q25Coordinates.conj (shift z * v 0 + scale z * v 2)
    rw [Q25Coordinates.conj_add, Q25Coordinates.conj_mul, Q25Coordinates.conj_mul,
      conj_shift, conj_scale]

/-- Individual compatibility with the two fixed points is exactly the elementary nonzero-imaginary
condition used by the normalizer. -/
def IndividuallyGood (o : OrbitCode) : Prop :=
  RawCap (fixedPair ∪ orbitPair o)

instance (o : OrbitCode) : Decidable (IndividuallyGood o) := by
  unfold IndividuallyGood
  infer_instance

def Admissible : OrbitCode → Prop
  | .affineY _ _ z => imagPart z ≠ 0
  | _ => False

instance (o : OrbitCode) : Decidable (Admissible o) := by
  cases o <;> simp only [Admissible] <;> infer_instance

@[simp] theorem conj_fixed_iff (z : K25) :
    Q25Coordinates.conj z = z ↔ imagPart z = 0 := by
  revert z
  decide

@[simp] theorem fixed_conj_iff (z : K25) :
    z = Q25Coordinates.conj z ↔ imagPart z = 0 := by
  rw [eq_comm, conj_fixed_iff]

@[simp] theorem imagPart_smallNonfixed_ne_zero (a : Fin 5) (b : Fin 2) :
    imagPart (smallNonfixed a b) ≠ 0 := by
  revert a b
  decide

@[simp] theorem conj_smallNonfixed_ne (a : Fin 5) (b : Fin 2) :
    Q25Coordinates.conj (smallNonfixed a b) ≠ smallNonfixed a b := by
  revert a b
  decide

@[simp] theorem smallNonfixed_ne_conj (a : Fin 5) (b : Fin 2) :
    smallNonfixed a b ≠ Q25Coordinates.conj (smallNonfixed a b) := by
  exact (conj_smallNonfixed_ne a b).symm

@[simp] theorem smallNonfixed_ne_zero (a : Fin 5) (b : Fin 2) :
    smallNonfixed a b ≠ 0 := by
  revert a b
  decide

@[simp] theorem conj_smallNonfixed_ne_zero (a : Fin 5) (b : Fin 2) :
    Q25Coordinates.conj (smallNonfixed a b) ≠ 0 := by
  revert a b
  decide

@[simp] theorem conj_encode_real (a : Fin 5) :
    Q25Coordinates.conj (GF25.encode a.val 0) = GF25.encode a.val 0 := by
  revert a
  decide

/-- Symbolic characterization of the 310 nonfixed orbits compatible with the standard fixed
pair.  The only nonconstant determinant is the one detecting whether the second affine
coordinate is fixed by conjugation. -/
theorem individuallyGood_iff_admissible (o : OrbitCode) :
    IndividuallyGood o ↔ Admissible o := by
  cases o with
  | affineY a b z =>
      simp [IndividuallyGood, Admissible, RawCap, fixedPair, orbitPair, orbitIdx,
        Q25Coordinates.conjIdx, Q25Coordinates.vec, Matrix.det_fin_three,
        sub_eq_zero, neg_add_eq_zero]
  | affineZ y a b =>
      simp [IndividuallyGood, Admissible, RawCap, fixedPair, orbitPair, orbitIdx,
        Q25Coordinates.conjIdx, Q25Coordinates.vec, Matrix.det_fin_three,
        sub_eq_zero, neg_add_eq_zero]
  | infinity a b =>
      simp [IndividuallyGood, Admissible, RawCap, fixedPair, orbitPair, orbitIdx,
        Q25Coordinates.conjIdx, Q25Coordinates.vec, Matrix.det_fin_three,
        sub_eq_zero, neg_add_eq_zero]

theorem five_le_orbitNumber_of_individuallyGood {o : OrbitCode} (h : IndividuallyGood o) :
    5 ≤ orbitNumber o := by
  have ha := (individuallyGood_iff_admissible o).1 h
  cases o with
  | affineY a b z =>
      simp only [Admissible] at ha
      simp [orbitNumber]
      have hz : 5 ≤ z.val.val := by
        by_contra hlt
        have : z.val.val / 5 = 0 := by omega
        apply ha
        simp [imagPart, this]
      omega
  | affineZ y a b => simp [Admissible] at ha
  | infinity a b => simp [Admissible] at ha

def standardOrbit : OrbitCode := .affineY 0 0 omega

@[simp] theorem orbitIdx_standard : orbitIdx standardOrbit = .affine omega omega := by
  rfl

/-! ## The induced permutation of canonical projective coordinates -/

noncomputable def mapIdx (y z : K25) (hy : imagPart y ≠ 0) (hz : imagPart z ≠ 0) :
    Idx25 ≃ Idx25 :=
  pointEquiv.trans
    ((ProjectiveCap.Projective.mapEquiv (normalizer y z hy hz)).trans pointEquiv.symm)

theorem point_mapIdx (y z : K25) (hy : imagPart y ≠ 0) (hz : imagPart z ≠ 0)
    (i : Idx25) :
    point (mapIdx y z hy hz i) =
      ProjectiveCap.Projective.mapEquiv (normalizer y z hy hz) (point i) := by
  change pointEquiv (mapIdx y z hy hz i) = _
  simp [mapIdx]

@[simp] theorem mapIdx_fixedA (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) :
    mapIdx y z hy hz .vertical = .vertical := by
  apply point_injective
  rw [point_mapIdx]
  rw [point, Certificate.toPoint, rawPoint, ProjectiveCap.Projective.mapEquiv_mk]
  apply (Projectivization.mk_eq_mk_iff' K25 _ _ _ _).mpr
  exact ⟨scale z, (normalizer_fixedA y z hy hz).symm⟩

@[simp] theorem mapIdx_fixedB (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) :
    mapIdx y z hy hz (.infinity 0) = .infinity 0 := by
  apply point_injective
  rw [point_mapIdx]
  rw [point, Certificate.toPoint, rawPoint, ProjectiveCap.Projective.mapEquiv_mk]
  apply (Projectivization.mk_eq_mk_iff' K25 _ _ _ _).mpr
  exact ⟨scale y, (normalizer_fixedB y z hy hz).symm⟩

theorem mapIdx_affine (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) :
    mapIdx y z hy hz (.affine y z) = .affine omega omega := by
  apply point_injective
  rw [point_mapIdx]
  rw [point, Certificate.toPoint, rawPoint]
  exact ProjectiveCap.Projective.mapEquiv_mk_eq_mk
    (vec_ne_zero _) (vec_ne_zero _) (normalizer_affine y z hy hz)

theorem mapEquiv_conj (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) (p : Point25) :
    ProjectiveCap.Projective.mapEquiv (normalizer y z hy hz)
        (ProjectiveConjugation.projectiveEquiv Q25Coordinates.conjRingEquiv p) =
      ProjectiveConjugation.projectiveEquiv Q25Coordinates.conjRingEquiv
        (ProjectiveCap.Projective.mapEquiv (normalizer y z hy hz) p) := by
  induction p using Projectivization.ind with
  | h v hv =>
      change ProjectiveCap.Projective.mapEquiv (normalizer y z hy hz)
          (ProjectiveConjugation.projectiveMap Q25Coordinates.conjRingEquiv
            (Projectivization.mk K25 v hv)) =
        ProjectiveConjugation.projectiveMap Q25Coordinates.conjRingEquiv
          (ProjectiveCap.Projective.mapEquiv (normalizer y z hy hz)
            (Projectivization.mk K25 v hv))
      simp only [ProjectiveConjugation.projectiveMap, Projectivization.map_mk,
        ProjectiveCap.Projective.mapEquiv_mk]
      apply (Projectivization.mk_eq_mk_iff' K25 _ _ _ _).mpr
      exact ⟨1, by rw [one_smul, normalizer_conj]⟩

/-- The induced point permutation commutes with indexed conjugation. -/
theorem mapIdx_conjIdx (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) (i : Idx25) :
    mapIdx y z hy hz (conjIdx i) = conjIdx (mapIdx y z hy hz i) := by
  apply point_injective
  rw [point_mapIdx, point_conjIdx, point_conjIdx, point_mapIdx]
  have hσ : Q25Coordinates.conjRingEquiv =
      QuadraticFrobenius.frobeniusRingEquiv F5 K25 := by
    ext x
    exact (Q25Coordinates.frobenius_eq_conj x).symm
  simpa [hσ] using mapEquiv_conj y z hy hz (point i)

theorem pointSetIdx_mapIdx (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) (S : Finset Idx25) :
    pointSetIdx (S.map (mapIdx y z hy hz).toEmbedding) =
      (pointSetIdx S).map
        (ProjectiveCap.Projective.mapEquiv (normalizer y z hy hz)).toEmbedding := by
  classical
  ext p
  constructor
  · intro hp
    obtain ⟨j, hj, hjp⟩ := Finset.mem_map.mp hp
    obtain ⟨i, hi, hij⟩ := Finset.mem_map.mp hj
    apply Finset.mem_map.mpr
    refine ⟨pointEquiv i, Finset.mem_map.mpr ⟨i, hi, rfl⟩, ?_⟩
    calc
      ProjectiveCap.Projective.mapEquiv (normalizer y z hy hz) (pointEquiv i) =
          point (mapIdx y z hy hz i) := (point_mapIdx y z hy hz i).symm
      _ = point j := congrArg point hij
      _ = pointEquiv j := rfl
      _ = p := hjp
  · intro hp
    obtain ⟨q, hq, hqp⟩ := Finset.mem_map.mp hp
    obtain ⟨i, hi, hiq⟩ := Finset.mem_map.mp hq
    apply Finset.mem_map.mpr
    refine ⟨mapIdx y z hy hz i, Finset.mem_map.mpr ⟨i, hi, rfl⟩, ?_⟩
    calc
      pointEquiv (mapIdx y z hy hz i) = point (mapIdx y z hy hz i) := rfl
      _ = ProjectiveCap.Projective.mapEquiv (normalizer y z hy hz) (point i) :=
        point_mapIdx y z hy hz i
      _ = ProjectiveCap.Projective.mapEquiv (normalizer y z hy hz) (pointEquiv i) := rfl
      _ = ProjectiveCap.Projective.mapEquiv (normalizer y z hy hz) q :=
        congrArg (ProjectiveCap.Projective.mapEquiv (normalizer y z hy hz)) hiq
      _ = p := hqp

theorem rawCap_mapIdx (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) (S : Finset Idx25) :
    RawCap (S.map (mapIdx y z hy hz).toEmbedding) ↔ RawCap S := by
  classical
  rw [rawCap_iff_projectiveCap, rawCap_iff_projectiveCap,
    pointSetIdx_mapIdx, ProjectiveCap.Projective.cap_map_mapEquiv]

@[simp] theorem map_fixedPair (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) :
    fixedPair.map (mapIdx y z hy hz).toEmbedding = fixedPair := by
  simp [fixedPair]

theorem map_orbitPair (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) (o : OrbitCode) :
    (orbitPair o).map (mapIdx y z hy hz).toEmbedding =
      {mapIdx y z hy hz (orbitIdx o),
        conjIdx (mapIdx y z hy hz (orbitIdx o))} := by
  simp [orbitPair, mapIdx_conjIdx]

theorem map_selected_orbit_to_standard {a : Fin 5} {b : Fin 2} {z : K25}
    (hz : imagPart z ≠ 0) :
    (orbitPair (.affineY a b z)).map
        (mapIdx (smallNonfixed a b) z (imagPart_smallNonfixed_ne_zero a b) hz).toEmbedding =
      orbitPair standardOrbit := by
  rw [map_orbitPair]
  have hm := mapIdx_affine (smallNonfixed a b) z
    (imagPart_smallNonfixed_ne_zero a b) hz
  have hs : smallNonfixed (0 : Fin 5) (0 : Fin 2) = omega := by decide
  simp [orbitPair, orbitIdx, hm, standardOrbit, hs]

/-! ## Transporting unordered conjugate orbits -/

noncomputable def orbitCodeEquiv : OrbitCode ≃ OrbitRep :=
  Equiv.ofBijective orbitRep orbitRep_bijective

theorem exists_orbitCode_pair (i : Idx25) (hi : i ≠ conjIdx i) :
    ∃ o : OrbitCode, {i, conjIdx i} = orbitPair o := by
  classical
  rcases lt_or_gt_of_ne (fun h => hi (rank_injective h)) with hlt | hgt
  · let r : OrbitRep := ⟨i, hlt⟩
    let o := orbitCodeEquiv.symm r
    refine ⟨o, ?_⟩
    have ho : orbitIdx o = i := congrArg Subtype.val (orbitCodeEquiv.apply_symm_apply r)
    simp [orbitPair, ho]
  · have hlt : rank (conjIdx i) < rank (conjIdx (conjIdx i)) := by
      rw [conjIdx_involutive i]
      exact hgt
    let r : OrbitRep := ⟨conjIdx i, hlt⟩
    let o := orbitCodeEquiv.symm r
    refine ⟨o, ?_⟩
    have ho : orbitIdx o = conjIdx i :=
      congrArg Subtype.val (orbitCodeEquiv.apply_symm_apply r)
    rw [orbitPair, ho, conjIdx_involutive i]
    exact Finset.pair_comm _ _

theorem mapIdx_nonfixed (y z : K25) (hy : imagPart y ≠ 0) (hz : imagPart z ≠ 0)
    {i : Idx25} (hi : i ≠ conjIdx i) :
    mapIdx y z hy hz i ≠ conjIdx (mapIdx y z hy hz i) := by
  intro h
  rw [← mapIdx_conjIdx] at h
  exact hi ((mapIdx y z hy hz).injective h)

noncomputable def mapOrbitCode (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) (o : OrbitCode) : OrbitCode :=
  Classical.choose (exists_orbitCode_pair (mapIdx y z hy hz (orbitIdx o))
    (mapIdx_nonfixed y z hy hz (by
      intro h
      have hr := congrArg rank h
      exact (Nat.ne_of_lt (orbitIdx_lt_conj o)) hr)))

theorem mapOrbitCode_spec (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) (o : OrbitCode) :
    (orbitPair o).map (mapIdx y z hy hz).toEmbedding =
      orbitPair (mapOrbitCode y z hy hz o) := by
  rw [map_orbitPair]
  exact Classical.choose_spec (exists_orbitCode_pair (mapIdx y z hy hz (orbitIdx o))
    (mapIdx_nonfixed y z hy hz (by
      intro h
      have hr := congrArg rank h
      exact (Nat.ne_of_lt (orbitIdx_lt_conj o)) hr)))

theorem mapOrbitCode_injective (y z : K25) (hy : imagPart y ≠ 0)
    (hz : imagPart z ≠ 0) : Function.Injective (mapOrbitCode y z hy hz) := by
  intro a b hab
  apply orbitPair_injective
  have hp : (orbitPair a).map (mapIdx y z hy hz).toEmbedding =
      (orbitPair b).map (mapIdx y z hy hz).toEmbedding := by
    rw [mapOrbitCode_spec, mapOrbitCode_spec, hab]
  have hback := congrArg
    (fun S : Finset Idx25 => S.map (mapIdx y z hy hz).symm.toEmbedding) hp
  simpa [Finset.map_map] using hback

end Q25Normalization
end RelativeConicArcs
