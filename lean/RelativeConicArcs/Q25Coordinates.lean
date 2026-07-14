import RelativeConicArcs.Certificate
import RelativeConicArcs.FiniteFields
import RelativeConicArcs.QuadraticFrobenius

/-!
# Kernel-checkable coordinates for `PG(2,25)`

This is the rules-only coordinate layer for the order-five Baer-extension certificate.  The
canonical point type has one constructor for each of the normal forms `[1:y:z]`, `[0:1:z]`, and
`[0:0:1]`.  Its equivalence with the abstract projective plane, its explicit conjugation, and the
bridge from determinant checks to projective caps are proved here.  No generated census data occur
in this file.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace Q25Coordinates

open Certificate FiniteFields ProjectiveBridge
open Projectivization

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

abbrev F5 := ZMod 5
abbrev K25 := GF25
abbrev Point25 := ProjectiveConjugation.Point K25

/-- The three canonical projective-coordinate charts, with no quotient remaining. -/
inductive Idx25 where
  | affine (y z : K25)
  | infinity (z : K25)
  | vertical
deriving DecidableEq, Fintype

/-- Canonical nonzero coordinate representative. -/
def vec : Idx25 → Fin 3 → K25
  | .affine y z => ![1, y, z]
  | .infinity z => ![0, 1, z]
  | .vertical => ![0, 0, 1]

theorem vec_ne_zero (i : Idx25) : vec i ≠ 0 := by
  cases i <;> intro h
  · have := congrFun h 0
    simp [vec] at this
  · have := congrFun h 1
    simp [vec] at this
  · have := congrFun h 2
    simp [vec] at this

def rawPoint (i : Idx25) : RawPoint K25 := ⟨vec i, vec_ne_zero i⟩
def point (i : Idx25) : Point25 := toPoint (rawPoint i)

/-- Canonical representatives are equal exactly when they lie on the same projective ray. -/
theorem rayEq_vec_iff_eq (i j : Idx25) : RayEq (vec i) (vec j) ↔ i = j := by
  constructor
  · rintro ⟨a, ha⟩
    cases i with
    | affine y z =>
        cases j with
        | affine y' z' =>
            have h0 := congrFun ha 0
            have h1 := congrFun ha 1
            have h2 := congrFun ha 2
            simp only [vec, Pi.smul_apply, smul_eq_mul, Matrix.cons_val_zero,
              Matrix.cons_val_one, Matrix.cons_val_two, Matrix.head_cons,
              Matrix.tail_cons] at h0 h1 h2
            have ha1 : a = 1 := by simpa using h0
            subst a
            simp only [one_mul] at h1 h2
            simp [h1, h2]
        | infinity z' =>
            have h0 := congrFun ha 0
            simp [vec] at h0
        | vertical =>
            have h0 := congrFun ha 0
            simp [vec] at h0
    | infinity z =>
        cases j with
        | affine y' z' =>
            have h0 := congrFun ha 0
            have h1 := congrFun ha 1
            simp [vec] at h0
            rw [h0] at h1
            simp [vec] at h1
        | infinity z' =>
            have h1 := congrFun ha 1
            have h2 := congrFun ha 2
            simp only [vec, Pi.smul_apply, smul_eq_mul, Matrix.cons_val_one,
              Matrix.cons_val_two, Matrix.head_cons, Matrix.tail_cons] at h1 h2
            have ha1 : a = 1 := by simpa using h1
            subst a
            simp only [one_mul] at h2
            simp [h2]
        | vertical =>
            have h1 := congrFun ha 1
            simp [vec] at h1
    | vertical =>
        cases j with
        | affine y' z' =>
            have h0 := congrFun ha 0
            have h2 := congrFun ha 2
            simp [vec] at h0
            rw [h0] at h2
            simp [vec] at h2
        | infinity z' =>
            have h1 := congrFun ha 1
            have h2 := congrFun ha 2
            simp [vec] at h1
            rw [h1] at h2
            simp [vec] at h2
        | vertical => rfl
  · rintro rfl
    exact ⟨1, by simp⟩

theorem point_injective : Function.Injective point := by
  intro i j hij
  exact (rayEq_vec_iff_eq i j).mp ((rayEq_iff_mk_eq (rawPoint i) (rawPoint j)).mpr hij)

theorem card_point25 : Nat.card Point25 = 651 := by
  rw [Projectivization.card_of_finrank K25 (Fin 3 → K25) (n := 3) (by simp)]
  norm_num [Finset.sum_range_succ, GF25.card]

theorem card_idx25 : Fintype.card Idx25 = 651 := by decide

noncomputable local instance : Fintype Point25 := Fintype.ofFinite _
noncomputable local instance : DecidableEq Point25 := Classical.decEq _

/-- The canonical coordinate representatives exhaust `PG(2,25)`. -/
noncomputable def pointEquiv : Idx25 ≃ Point25 :=
  Equiv.ofBijective point ((Fintype.bijective_iff_injective_and_card point).2
    ⟨point_injective, by rw [card_idx25, ← Nat.card_eq_fintype_card, card_point25]⟩)

@[simp] theorem pointEquiv_apply (i : Idx25) : pointEquiv i = point i := rfl

noncomputable def pointSetIdx (S : Finset Idx25) : Finset Point25 :=
  S.map pointEquiv.toEmbedding

/-- Coordinate cap validity on canonical representatives. -/
def RawCap (S : Finset Idx25) : Prop :=
  ∀ a ∈ S, ∀ b ∈ S, ∀ c ∈ S,
    a ≠ b → a ≠ c → b ≠ c → Matrix.det ![vec a, vec b, vec c] ≠ 0

instance (S : Finset Idx25) : Decidable (RawCap S) := by
  unfold RawCap
  infer_instance

theorem rawCap_iff_projectiveCap (S : Finset Idx25) :
    RawCap S ↔ ProjectiveCap.Projective.Cap K25 (Fin 3 → K25) (pointSetIdx S) := by
  let xs := S.toList.map rawPoint
  have hpoint : pointSet xs = pointSetIdx S := by
    classical
    ext p
    rw [mem_pointSet]
    constructor
    · rintro ⟨v, hv, rfl⟩
      obtain ⟨i, hi, rfl⟩ := List.mem_map.mp hv
      exact Finset.mem_map.mpr ⟨i, by simpa using hi, rfl⟩
    · intro hp
      obtain ⟨i, hi, hip⟩ := Finset.mem_map.mp hp
      exact ⟨rawPoint i, List.mem_map.mpr ⟨i, by simpa using hi, rfl⟩, hip⟩
  have hraw : RawArc xs ↔ RawCap S := by
    classical
    unfold RawArc RawCap xs
    simp only [List.mem_map, Finset.mem_toList]
    constructor
    · intro h a ha b hb c hc hab hac hbc
      exact h (rawPoint a) ⟨a, ha, rfl⟩ (rawPoint b) ⟨b, hb, rfl⟩
        (rawPoint c) ⟨c, hc, rfl⟩
        ((rayEq_eq_false_iff _ _).2 (fun hr => hab ((rayEq_vec_iff_eq a b).1 hr)))
        ((rayEq_eq_false_iff _ _).2 (fun hr => hac ((rayEq_vec_iff_eq a c).1 hr)))
        ((rayEq_eq_false_iff _ _).2 (fun hr => hbc ((rayEq_vec_iff_eq b c).1 hr)))
    · intro h va hva vb hvb vc hvc hab hac hbc
      obtain ⟨a, ha, rfl⟩ := hva
      obtain ⟨b, hb, rfl⟩ := hvb
      obtain ⟨c, hc, rfl⟩ := hvc
      exact h a ha b hb c hc
        (fun e => by subst b; exact (rayEq_eq_false_iff _ _).1 hab ⟨1, by simp⟩)
        (fun e => by subst c; exact (rayEq_eq_false_iff _ _).1 hac ⟨1, by simp⟩)
        (fun e => by subst c; exact (rayEq_eq_false_iff _ _).1 hbc ⟨1, by simp⟩)
  rw [← hpoint, ← rawArc_iff_projectiveCap, hraw]

/-! ## Explicit quadratic conjugation -/

/-- Coefficient conjugation `a+bω ↦ a-bω`. -/
def conj (x : K25) : K25 := GF25.encode (x.val % 5) (5 - x.val / 5)

theorem conj_involutive : Function.Involutive conj := by
  intro x
  revert x
  decide
theorem conj_add (x y : K25) : conj (x + y) = conj x + conj y := by
  revert x y
  decide
theorem conj_mul (x y : K25) : conj (x * y) = conj x * conj y := by
  revert x y
  decide
theorem conj_one : conj 1 = 1 := by decide
theorem conj_zero : conj 0 = 0 := by decide

def conjRingEquiv : K25 ≃+* K25 where
  toFun := conj
  invFun := conj
  left_inv := conj_involutive
  right_inv := conj_involutive
  map_mul' := conj_mul
  map_add' := conj_add

/-- The concrete coefficient conjugation is the relative fifth-power Frobenius. -/
theorem frobenius_eq_conj (x : K25) :
    QuadraticFrobenius.frobeniusRingEquiv F5 K25 x = conj x := by
  change x ^ Fintype.card F5 = conj x
  rw [ZMod.card]
  revert x
  decide

def conjIdx : Idx25 → Idx25
  | .affine y z => .affine (conj y) (conj z)
  | .infinity z => .infinity (conj z)
  | .vertical => .vertical

theorem conjIdx_involutive : Function.Involutive conjIdx := by
  intro i
  cases i <;> simp only [conjIdx]
  · congr 1 <;> apply conj_involutive
  · congr 1
    apply conj_involutive

theorem vec_conjIdx (i : Idx25) :
    vec (conjIdx i) = ProjectiveConjugation.coordinatewise conjRingEquiv (vec i) := by
  cases i <;> ext j <;> fin_cases j <;>
    change _ = conj _ <;>
    simp [vec, conjIdx, conj_zero, conj_one]

/-- Explicit indexed conjugation agrees with the abstract quadratic-Frobenius projective action. -/
theorem point_conjIdx (i : Idx25) :
    point (conjIdx i) =
      ProjectiveConjugation.projectiveEquiv
        (QuadraticFrobenius.frobeniusRingEquiv F5 K25) (point i) := by
  rw [point, point, toPoint, toPoint]
  change Projectivization.mk K25 (vec (conjIdx i)) _ =
    ProjectiveConjugation.projectiveMap
      (QuadraticFrobenius.frobeniusRingEquiv F5 K25)
      (Projectivization.mk K25 (vec i) _)
  rw [ProjectiveConjugation.projectiveMap, Projectivization.map_mk]
  apply (Projectivization.mk_eq_mk_iff' K25 _ _ _ _).mpr
  refine ⟨1, ?_⟩
  rw [one_smul, vec_conjIdx]
  ext j
  change
    QuadraticFrobenius.frobeniusRingEquiv F5 K25 (vec i j) =
      conj (vec i j)
  exact frobenius_eq_conj (vec i j)

/-- A numeric rank used only to choose one representative from each two-point orbit. -/
def rank : Idx25 → Nat
  | .affine y z => y.val * 25 + z.val
  | .infinity z => 625 + z.val
  | .vertical => 650

theorem rank_lt_651 (i : Idx25) : rank i < 651 := by
  cases i <;> simp [rank] <;> omega

theorem rank_injective : Function.Injective rank := by
  intro i j h
  have gfext : ∀ x y : K25, x.val.val = y.val.val → x = y := by
    intro x y hxy
    cases x with
    | mk xv =>
      cases y with
      | mk yv =>
        congr
        exact Fin.ext hxy
  cases i <;> cases j <;> simp [rank] at h ⊢
  · constructor
    · exact gfext _ _ (by omega)
    · exact gfext _ _ (by omega)
  · omega
  · omega
  · omega
  · exact gfext _ _ (by omega)
  · omega
  · omega
  · omega

/-- The selected representative of a nonfixed conjugate pair. -/
abbrev OrbitRep := {i : Idx25 // rank i < rank (conjIdx i)}

theorem card_orbitRep : Fintype.card OrbitRep = 310 := by decide

end Q25Coordinates
end RelativeConicArcs
