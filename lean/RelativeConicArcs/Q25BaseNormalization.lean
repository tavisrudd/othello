import RelativeConicArcs.Q25Normalization
import Mathlib.RingTheory.TensorProduct.Pi
import Mathlib.LinearAlgebra.TensorProduct.Tower

/-!
# Lifting base-plane projectivities to `PG(2,25)`

A linear automorphism over `GF(5)` extends scalars to `GF(25)`.  The resulting projectivity
commutes with relative Frobenius, so it can normalize the two selected fixed points without
changing conjugate-orbit structure or pair extendability.
-/

open scoped LinearAlgebra.Projectivization TensorProduct

namespace RelativeConicArcs
namespace Q25BaseNormalization

open Q25Coordinates Q25PairCertificate Q25Normalization FiniteFields

set_option maxHeartbeats 300000000
set_option maxRecDepth 100000

abbrev Vec5 := Fin 3 → F5
abbrev Vec25 := Fin 3 → K25

/-- Scalar extension of a base-field linear automorphism, identified with coordinate vectors. -/
noncomputable def liftBase (g : Vec5 ≃ₗ[F5] Vec5) : Vec25 ≃ₗ[K25] Vec25 :=
  (TensorProduct.piScalarRight F5 K25 K25 (Fin 3)).symm |>.trans
    ((g.baseChange F5 K25 Vec5 Vec5).trans
      (TensorProduct.piScalarRight F5 K25 K25 (Fin 3)))

theorem liftBase_baseChange (g : Vec5 ≃ₗ[F5] Vec5) (v : Vec5) :
    liftBase g (QuadraticFrobenius.baseChange F5 K25 v) =
      QuadraticFrobenius.baseChange F5 K25 (g v) := by
  change liftBase g (algebraMap Vec5 Vec25 v) = algebraMap Vec5 Vec25 (g v)
  simp [liftBase, TensorProduct.piScalarRight_symm_algebraMap]
  ext j
  rw [Algebra.smul_def, mul_one]
  rfl

def realVec (v : Vec25) : Vec5 := fun i => realPart (v i)
def imagVec (v : Vec25) : Vec5 := fun i => imagPart (v i)

theorem vec_decompose (v : Vec25) :
    QuadraticFrobenius.baseChange F5 K25 (realVec v) +
        omega • QuadraticFrobenius.baseChange F5 K25 (imagVec v) = v := by
  ext i
  change algebraMap F5 K25 (realPart (v i)) +
      omega * algebraMap F5 K25 (imagPart (v i)) = v i
  simpa [mul_comm] using reconstruct (v i)

theorem liftBase_decompose (g : Vec5 ≃ₗ[F5] Vec5) (v : Vec25) :
    liftBase g v =
      QuadraticFrobenius.baseChange F5 K25 (g (realVec v)) +
        omega • QuadraticFrobenius.baseChange F5 K25 (g (imagVec v)) := by
  conv_lhs => rw [← vec_decompose v]
  rw [map_add, map_smul, liftBase_baseChange, liftBase_baseChange]

theorem conj_algebraMap (a : F5) :
    Q25Coordinates.conj (algebraMap F5 K25 a) = algebraMap F5 K25 a :=
  Q25Normalization.conj_algebraMap a

theorem conj_omega : Q25Coordinates.conj omega = -omega := by decide

theorem conjugate_decompose (v : Vec25) :
    ProjectiveConjugation.coordinatewise Q25Coordinates.conjRingEquiv v =
      QuadraticFrobenius.baseChange F5 K25 (realVec v) -
        omega • QuadraticFrobenius.baseChange F5 K25 (imagVec v) := by
  ext i
  have h := reconstruct (v i)
  change Q25Coordinates.conj (v i) =
    algebraMap F5 K25 (realPart (v i)) -
      omega * algebraMap F5 K25 (imagPart (v i))
  calc
    Q25Coordinates.conj (v i) = Q25Coordinates.conj
        (algebraMap F5 K25 (realPart (v i)) +
          algebraMap F5 K25 (imagPart (v i)) * omega) := congrArg _ h.symm
    _ = algebraMap F5 K25 (realPart (v i)) -
        omega * algebraMap F5 K25 (imagPart (v i)) := by
      rw [Q25Coordinates.conj_add, Q25Coordinates.conj_mul, conj_algebraMap,
        conj_algebraMap, conj_omega]
      ring

/-- A scalar-extended base projectivity commutes exactly with concrete quadratic conjugation. -/
theorem liftBase_conj (g : Vec5 ≃ₗ[F5] Vec5) (v : Vec25) :
    liftBase g (ProjectiveConjugation.coordinatewise Q25Coordinates.conjRingEquiv v) =
      ProjectiveConjugation.coordinatewise Q25Coordinates.conjRingEquiv (liftBase g v) := by
  rw [conjugate_decompose, map_sub, map_smul, liftBase_baseChange, liftBase_baseChange,
    liftBase_decompose]
  ext i
  change algebraMap F5 K25 (g (realVec v) i) -
      omega * algebraMap F5 K25 (g (imagVec v) i) =
    Q25Coordinates.conj
      (algebraMap F5 K25 (g (realVec v) i) +
        omega * algebraMap F5 K25 (g (imagVec v) i))
  rw [Q25Coordinates.conj_add, Q25Coordinates.conj_mul, conj_algebraMap,
    conj_algebraMap, conj_omega]
  ring

theorem mapEquiv_liftBase_projectiveBaseChange (g : Vec5 ≃ₗ[F5] Vec5)
    (p : ProjectiveConjugation.Point F5) :
    ProjectiveCap.Projective.mapEquiv (liftBase g)
        (QuadraticFrobenius.projectiveBaseChange F5 K25 p) =
      QuadraticFrobenius.projectiveBaseChange F5 K25
        (ProjectiveCap.Projective.mapEquiv g p) := by
  induction p using Projectivization.ind with
  | h v hv =>
      simp only [QuadraticFrobenius.projectiveBaseChange, Projectivization.map_mk,
        ProjectiveCap.Projective.mapEquiv_mk, liftBase_baseChange]

theorem mapEquiv_liftBase_conj (g : Vec5 ≃ₗ[F5] Vec5) (p : Point25) :
    ProjectiveCap.Projective.mapEquiv (liftBase g)
        (ProjectiveConjugation.projectiveEquiv Q25Coordinates.conjRingEquiv p) =
      ProjectiveConjugation.projectiveEquiv Q25Coordinates.conjRingEquiv
        (ProjectiveCap.Projective.mapEquiv (liftBase g) p) := by
  induction p using Projectivization.ind with
  | h v hv =>
      change ProjectiveCap.Projective.mapEquiv (liftBase g)
          (ProjectiveConjugation.projectiveMap Q25Coordinates.conjRingEquiv
            (Projectivization.mk K25 v hv)) =
        ProjectiveConjugation.projectiveMap Q25Coordinates.conjRingEquiv
          (ProjectiveCap.Projective.mapEquiv (liftBase g)
            (Projectivization.mk K25 v hv))
      simp only [ProjectiveConjugation.projectiveMap, Projectivization.map_mk,
        ProjectiveCap.Projective.mapEquiv_mk]
      apply (Projectivization.mk_eq_mk_iff' K25 _ _ _ _).mpr
      exact ⟨1, by rw [one_smul, liftBase_conj]⟩

def baseA : ProjectiveConjugation.Point F5 :=
  Projectivization.mk F5 ![0, 0, 1] (by simp)

def baseB : ProjectiveConjugation.Point F5 :=
  Projectivization.mk F5 ![0, 1, 0] (by simp)

theorem baseA_ne_baseB : baseA ≠ baseB := by
  intro h
  rw [baseA, baseB, Projectivization.mk_eq_mk_iff'] at h
  obtain ⟨a, ha⟩ := h
  have h1 := congrFun ha 1
  have h2 := congrFun ha 2
  simp at h1 h2

/-- Strengthened two-point transitivity retaining the inducing base-field linear equivalence. -/
theorem exists_base_map_pair {p q : ProjectiveConjugation.Point F5} (hpq : p ≠ q) :
    ∃ g : Vec5 ≃ₗ[F5] Vec5,
      ProjectiveCap.Projective.mapEquiv g p = baseA ∧
        ProjectiveCap.Projective.mapEquiv g q = baseB := by
  have h2 : LinearIndependent F5 ![p.rep, q.rep] :=
    Projectivization.linearIndependent_pair_iff_ne.mpr hpq
  obtain ⟨w3, hw3⟩ := ProjectiveCap.Projective.exists_cons_li
    (K := F5) (V := Vec5) (by simp) (by omega) _ h2
  have h2' : LinearIndependent F5 ![baseA.rep, baseB.rep] :=
    Projectivization.linearIndependent_pair_iff_ne.mpr baseA_ne_baseB
  obtain ⟨u3, hu3⟩ := ProjectiveCap.Projective.exists_cons_li
    (K := F5) (V := Vec5) (by simp) (by omega) _ h2'
  have hcard3 : Fintype.card (Fin 3) = Module.finrank F5 Vec5 := by simp
  let bp := basisOfLinearIndependentOfCardEqFinrank hw3 hcard3
  let bq := basisOfLinearIndependentOfCardEqFinrank hu3 hcard3
  let g : Vec5 ≃ₗ[F5] Vec5 := bp.equiv bq (Equiv.refl _)
  have hcoep : ⇑bp = ![w3, p.rep, q.rep] :=
    coe_basisOfLinearIndependentOfCardEqFinrank _ _
  have hcoeq : ⇑bq = ![u3, baseA.rep, baseB.rep] :=
    coe_basisOfLinearIndependentOfCardEqFinrank _ _
  have hgp : g p.rep = baseA.rep := by
    have happ : g (bp 1) = bq 1 := by simp [g]
    change g (bp 1) = bq 1 at happ
    rw [show bp 1 = p.rep by
          rw [show bp 1 = (![w3, p.rep, q.rep] : Fin 3 → Vec5) 1 from congrFun hcoep 1]
          rfl,
      show bq 1 = baseA.rep by
          rw [show bq 1 = (![u3, baseA.rep, baseB.rep] : Fin 3 → Vec5) 1 from congrFun hcoeq 1]
          rfl] at happ
    exact happ
  have hgq : g q.rep = baseB.rep := by
    have happ : g (bp 2) = bq 2 := by simp [g]
    change g (bp 2) = bq 2 at happ
    rw [show bp 2 = q.rep by
          rw [show bp 2 = (![w3, p.rep, q.rep] : Fin 3 → Vec5) 2 from congrFun hcoep 2]
          rfl,
      show bq 2 = baseB.rep by
          rw [show bq 2 = (![u3, baseA.rep, baseB.rep] : Fin 3 → Vec5) 2 from congrFun hcoeq 2]
          rfl] at happ
    exact happ
  exact ⟨g, ProjectiveCap.Projective.mapEquiv_eq_of_rep_eq g hgp,
    ProjectiveCap.Projective.mapEquiv_eq_of_rep_eq g hgq⟩

/-! ## Induced indexed permutation and orbit transport -/

noncomputable def liftMapIdx (g : Vec5 ≃ₗ[F5] Vec5) : Idx25 ≃ Idx25 :=
  pointEquiv.trans
    ((ProjectiveCap.Projective.mapEquiv (liftBase g)).trans pointEquiv.symm)

theorem point_liftMapIdx (g : Vec5 ≃ₗ[F5] Vec5) (i : Idx25) :
    point (liftMapIdx g i) = ProjectiveCap.Projective.mapEquiv (liftBase g) (point i) := by
  change pointEquiv (liftMapIdx g i) = _
  simp [liftMapIdx]

theorem liftMapIdx_conjIdx (g : Vec5 ≃ₗ[F5] Vec5) (i : Idx25) :
    liftMapIdx g (conjIdx i) = conjIdx (liftMapIdx g i) := by
  apply point_injective
  rw [point_liftMapIdx, point_conjIdx, point_conjIdx, point_liftMapIdx]
  have hσ : Q25Coordinates.conjRingEquiv =
      QuadraticFrobenius.frobeniusRingEquiv F5 K25 := by
    ext x
    exact (Q25Coordinates.frobenius_eq_conj x).symm
  simpa [hσ] using mapEquiv_liftBase_conj g (point i)

theorem pointSetIdx_liftMapIdx (g : Vec5 ≃ₗ[F5] Vec5) (S : Finset Idx25) :
    pointSetIdx (S.map (liftMapIdx g).toEmbedding) =
      (pointSetIdx S).map (ProjectiveCap.Projective.mapEquiv (liftBase g)).toEmbedding := by
  classical
  ext p
  constructor
  · intro hp
    obtain ⟨j, hj, hjp⟩ := Finset.mem_map.mp hp
    obtain ⟨i, hi, hij⟩ := Finset.mem_map.mp hj
    apply Finset.mem_map.mpr
    refine ⟨pointEquiv i, Finset.mem_map.mpr ⟨i, hi, rfl⟩, ?_⟩
    calc
      ProjectiveCap.Projective.mapEquiv (liftBase g) (pointEquiv i) =
          point (liftMapIdx g i) := (point_liftMapIdx g i).symm
      _ = point j := congrArg point hij
      _ = pointEquiv j := rfl
      _ = p := hjp
  · intro hp
    obtain ⟨q, hq, hqp⟩ := Finset.mem_map.mp hp
    obtain ⟨i, hi, hiq⟩ := Finset.mem_map.mp hq
    apply Finset.mem_map.mpr
    refine ⟨liftMapIdx g i, Finset.mem_map.mpr ⟨i, hi, rfl⟩, ?_⟩
    calc
      pointEquiv (liftMapIdx g i) = point (liftMapIdx g i) := rfl
      _ = ProjectiveCap.Projective.mapEquiv (liftBase g) (point i) := point_liftMapIdx g i
      _ = ProjectiveCap.Projective.mapEquiv (liftBase g) (pointEquiv i) := rfl
      _ = ProjectiveCap.Projective.mapEquiv (liftBase g) q :=
        congrArg (ProjectiveCap.Projective.mapEquiv (liftBase g)) hiq
      _ = p := hqp

theorem rawCap_liftMapIdx (g : Vec5 ≃ₗ[F5] Vec5) (S : Finset Idx25) :
    RawCap (S.map (liftMapIdx g).toEmbedding) ↔ RawCap S := by
  classical
  rw [rawCap_iff_projectiveCap, rawCap_iff_projectiveCap, pointSetIdx_liftMapIdx,
    ProjectiveCap.Projective.cap_map_mapEquiv]

noncomputable def liftMapOrbitCode (g : Vec5 ≃ₗ[F5] Vec5)
    (o : OrbitCode) : OrbitCode :=
  Classical.choose (exists_orbitCode_pair (liftMapIdx g (orbitIdx o)) (by
    intro h
    rw [← liftMapIdx_conjIdx] at h
    have h' := (liftMapIdx g).injective h
    have hr := congrArg rank h'
    exact (Nat.ne_of_lt (orbitIdx_lt_conj o)) hr))

theorem liftMapOrbitCode_spec (g : Vec5 ≃ₗ[F5] Vec5) (o : OrbitCode) :
    (orbitPair o).map (liftMapIdx g).toEmbedding = orbitPair (liftMapOrbitCode g o) := by
  rw [orbitPair, Finset.map_insert, Finset.map_singleton, orbitPair]
  change {liftMapIdx g (orbitIdx o), liftMapIdx g (conjIdx (orbitIdx o))} =
    {orbitIdx (liftMapOrbitCode g o), conjIdx (orbitIdx (liftMapOrbitCode g o))}
  rw [liftMapIdx_conjIdx]
  exact Classical.choose_spec (exists_orbitCode_pair (liftMapIdx g (orbitIdx o)) (by
    intro h
    rw [← liftMapIdx_conjIdx] at h
    have h' := (liftMapIdx g).injective h
    have hr := congrArg rank h'
    exact (Nat.ne_of_lt (orbitIdx_lt_conj o)) hr))

theorem liftMapOrbitCode_injective (g : Vec5 ≃ₗ[F5] Vec5) :
    Function.Injective (liftMapOrbitCode g) := by
  intro a b hab
  apply orbitPair_injective
  have hp : (orbitPair a).map (liftMapIdx g).toEmbedding =
      (orbitPair b).map (liftMapIdx g).toEmbedding := by
    rw [liftMapOrbitCode_spec, liftMapOrbitCode_spec, hab]
  have hback := congrArg
    (fun S : Finset Idx25 => S.map (liftMapIdx g).symm.toEmbedding) hp
  simpa [Finset.map_map] using hback

end Q25BaseNormalization
end RelativeConicArcs
