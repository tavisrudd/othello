import RelativeConicArcs.ZeroDefectConicInvariance
import Mathlib.GroupTheory.Perm.Cycle.Type

/-!
# Fixed parameters of conic secant involutions

In characteristic two, the projectivity of the conic parameter line associated with an
off-conic point is represented by a trace-zero matrix.  Except at the conic nucleus, such a
projectivity has at most one fixed parameter.  This module supplies the coordinate lemmas used
to turn a tangent secant into a four-group action on the maximum-index conic parameters.
-/

namespace RelativeConicArcs
namespace TangentPairFourGroup

open Conic Nucleus
open scoped CharTwo LinearAlgebra.Projectivization Matrix

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K] [CharP K 2]

noncomputable local instance : Fintype (Point K) := Fintype.ofFinite (Point K)
noncomputable local instance : DecidableEq (Point K) := Classical.decEq (Point K)

omit [CharP K 2] in
/-- A fixed representative of a secant projectivity satisfies the tangent quadratic equation. -/
theorem fixed_quadratic_mk
    (P : Point K) (hP : P ∉ standardConic (K := K))
    (v : LineSpace K) (hv : v ≠ 0)
    (hfix : ConicSecantInvolution.equiv P hP
      (Projectivization.mk K v hv) = Projectivization.mk K v hv) :
    P.rep 2 * v 0 ^ 2 = P.rep 0 * v 1 ^ 2 := by
  rw [ConicSecantInvolution.equiv_mk] at hfix
  obtain ⟨c, hc⟩ :=
    (Projectivization.mk_eq_mk_iff' K _ _ _ _).mp hfix
  have h0 := congrFun hc 0
  have h1 := congrFun hc 1
  simp [ConicSecantInvolution.matrix, Matrix.mulVec, dotProduct,
    Fin.sum_univ_two] at h0 h1
  linear_combination -(v 0) * h1 + (v 1) * h0

omit [Fintype K] [DecidableEq K] [CharP K 2] in
/-- A projective plane point is the standard nucleus if both outer coordinates of its
representative vanish. -/
theorem eq_standardNucleus_of_outer_eq_zero
    {P : Point K} (h0 : P.rep 0 = 0) (h2 : P.rep 2 = 0) :
    P = standardNucleus (K := K) := by
  have h1 : P.rep 1 ≠ 0 := by
    intro h
    apply P.rep_nonzero
    funext i
    fin_cases i <;> assumption
  rw [← Projectivization.mk_rep P]
  unfold standardNucleus
  apply (Projectivization.mk_eq_mk_iff' K _ _ _ _).mpr
  refine ⟨Units.mk0 (P.rep 1) h1, ?_⟩
  funext i
  fin_cases i <;>
    simp [standardNucleusVector, h0, h2]

omit [Fintype K] [CharP K 2] in
/-- Away from the standard nucleus, at least one outer coordinate is nonzero. -/
theorem outer_ne_zero_of_ne_standardNucleus
    {P : Point K} (hP : P ≠ standardNucleus (K := K)) :
    P.rep 0 ≠ 0 ∨ P.rep 2 ≠ 0 := by
  by_contra h
  push Not at h
  exact hP (eq_standardNucleus_of_outer_eq_zero h.1 h.2)

omit [Fintype K] [DecidableEq K] in
/-- In characteristic two, the square of the two-dimensional cross product has no mixed term. -/
theorem cross2_sq (v w : LineSpace K) :
    cross2 v w ^ 2 = v 0 ^ 2 * w 1 ^ 2 - v 1 ^ 2 * w 0 ^ 2 := by
  unfold cross2
  ring_nf
  simp

omit [Fintype K] in
/-- Two nonzero parameter vectors satisfying the same nonzero tangent quadratic determine the
same projective parameter. -/
theorem mk_eq_mk_of_tangent_quadratic
    {a c : K} (houter : a ≠ 0 ∨ c ≠ 0)
    {v w : LineSpace K} (hv : v ≠ 0) (hw : w ≠ 0)
    (hvq : c * v 0 ^ 2 = a * v 1 ^ 2)
    (hwq : c * w 0 ^ 2 = a * w 1 ^ 2) :
    Projectivization.mk K v hv = Projectivization.mk K w hw := by
  have hcross : cross2 v w = 0 := by
    by_cases ha : a = 0
    · have hc : c ≠ 0 := by
        rcases houter with ha' | hc
        · exact (ha' ha).elim
        · exact hc
      have hv0sq : v 0 ^ 2 = 0 :=
        (mul_eq_zero.mp (by simpa [ha] using hvq)).resolve_left hc
      have hw0sq : w 0 ^ 2 = 0 :=
        (mul_eq_zero.mp (by simpa [ha] using hwq)).resolve_left hc
      have hv0 : v 0 = 0 :=
        (pow_eq_zero_iff (n := 2) (by norm_num)).mp hv0sq
      have hw0 : w 0 = 0 :=
        (pow_eq_zero_iff (n := 2) (by norm_num)).mp hw0sq
      simp [cross2, hv0, hw0]
    · have hmul : a * cross2 v w ^ 2 = 0 := by
        rw [cross2_sq]
        linear_combination (w 0 ^ 2) * hvq - (v 0 ^ 2) * hwq
      have hsq : cross2 v w ^ 2 = 0 :=
        (mul_eq_zero.mp hmul).resolve_left ha
      exact (pow_eq_zero_iff (n := 2) (by norm_num)).mp hsq
  by_contra hvw
  exact (cross2_ne_zero_of_mk_ne hv hw hvw) hcross

/-- An off-conic point distinct from the nucleus induces a projectivity with at most one fixed
parameter on the standard conic. -/
theorem fixed_unique
    (P : Point K) (hP : P ∉ standardConic (K := K))
    (hPnuc : P ≠ standardNucleus (K := K))
    {t u : LinePoint K}
    (ht : ConicSecantInvolution.equiv P hP t = t)
    (hu : ConicSecantInvolution.equiv P hP u = u) :
    t = u := by
  induction t using Projectivization.ind with
  | h v hv =>
    induction u using Projectivization.ind with
    | h w hw =>
      have hvq := fixed_quadratic_mk P hP v hv ht
      have hwq := fixed_quadratic_mk P hP w hw hu
      exact mk_eq_mk_of_tangent_quadratic
        (outer_ne_zero_of_ne_standardNucleus hPnuc) hv hw hvq hwq

omit [CharP K 2] in
/-- Two secant-involution matrices with a common fixed conic parameter have proportional outer
coordinate pairs. -/
theorem outer_cross_eq_zero_of_common_fixed
    (P Q : Point K)
    (hP : P ∉ standardConic (K := K))
    (hQ : Q ∉ standardConic (K := K))
    {t : LinePoint K}
    (hPt : ConicSecantInvolution.equiv P hP t = t)
    (hQt : ConicSecantInvolution.equiv Q hQ t = t) :
    P.rep 0 * Q.rep 2 - P.rep 2 * Q.rep 0 = 0 := by
  induction t using Projectivization.ind with
  | h v hv =>
    have hPv := fixed_quadratic_mk P hP v hv hPt
    have hQv := fixed_quadratic_mk Q hQ v hv hQt
    by_cases hv0 : v 0 = 0
    · have hv1 : v 1 ≠ 0 := by
        intro hv1
        exact hv (by funext i; fin_cases i <;> assumption)
      have hP0 : P.rep 0 = 0 := by
        have hz : P.rep 0 * v 1 ^ 2 = 0 := by simpa [hv0] using hPv.symm
        exact (mul_eq_zero.mp hz).resolve_right
          (pow_ne_zero 2 hv1)
      have hQ0 : Q.rep 0 = 0 := by
        have hz : Q.rep 0 * v 1 ^ 2 = 0 := by simpa [hv0] using hQv.symm
        exact (mul_eq_zero.mp hz).resolve_right
          (pow_ne_zero 2 hv1)
      simp [hP0, hQ0]
    · by_cases hv1 : v 1 = 0
      · have hP2 : P.rep 2 = 0 := by
          have hz : P.rep 2 * v 0 ^ 2 = 0 := by simpa [hv1] using hPv
          exact (mul_eq_zero.mp hz).resolve_right
            (pow_ne_zero 2 hv0)
        have hQ2 : Q.rep 2 = 0 := by
          have hz : Q.rep 2 * v 0 ^ 2 = 0 := by simpa [hv1] using hQv
          exact (mul_eq_zero.mp hz).resolve_right
            (pow_ne_zero 2 hv0)
        simp [hP2, hQ2]
      · have hmul :
            (P.rep 0 * Q.rep 2) * v 1 ^ 2 =
              (P.rep 2 * Q.rep 0) * v 1 ^ 2 := by
          calc
            (P.rep 0 * Q.rep 2) * v 1 ^ 2 =
                Q.rep 2 * (P.rep 0 * v 1 ^ 2) := by ring
            _ = Q.rep 2 * (P.rep 2 * v 0 ^ 2) := by rw [← hPv]
            _ = P.rep 2 * (Q.rep 2 * v 0 ^ 2) := by ring
            _ = P.rep 2 * (Q.rep 0 * v 1 ^ 2) := by rw [hQv]
            _ = (P.rep 2 * Q.rep 0) * v 1 ^ 2 := by ring
        exact sub_eq_zero.mpr
          (mul_right_cancel₀ (pow_ne_zero 2 hv1) hmul)

omit [CharP K 2] in
/-- Secant-involution matrices with a common fixed parameter commute. -/
theorem matrix_commute_of_common_fixed
    (P Q : Point K)
    (hP : P ∉ standardConic (K := K))
    (hQ : Q ∉ standardConic (K := K))
    {t : LinePoint K}
    (hPt : ConicSecantInvolution.equiv P hP t = t)
    (hQt : ConicSecantInvolution.equiv Q hQ t = t) :
    ConicSecantInvolution.matrix P.rep * ConicSecantInvolution.matrix Q.rep =
      ConicSecantInvolution.matrix Q.rep * ConicSecantInvolution.matrix P.rep := by
  have hcross := outer_cross_eq_zero_of_common_fixed P Q hP hQ hPt hQt
  have heq : P.rep 0 * Q.rep 2 = P.rep 2 * Q.rep 0 :=
    sub_eq_zero.mp hcross
  ext i j
  fin_cases i <;> fin_cases j
  · simp [ConicSecantInvolution.matrix, Matrix.mul_apply, Fin.sum_univ_two]
    rw [heq]
    ring
  · simp [ConicSecantInvolution.matrix, Matrix.mul_apply,
      Fin.sum_univ_two, mul_comm, add_comm]
  · simp [ConicSecantInvolution.matrix, Matrix.mul_apply,
      Fin.sum_univ_two, mul_comm, add_comm]
  · simp [ConicSecantInvolution.matrix, Matrix.mul_apply, Fin.sum_univ_two]
    calc
      P.rep 2 * Q.rep 0 + P.rep 1 * Q.rep 1 =
          P.rep 0 * Q.rep 2 + P.rep 1 * Q.rep 1 := by rw [heq]
      _ = Q.rep 2 * P.rep 0 + Q.rep 1 * P.rep 1 := by ring

/-- The product of the matrices attached to two distinct off-conic points with a common fixed
parameter is not scalar. -/
theorem product_outer_ne_zero_of_ne
    (P Q : Point K)
    (hP : P ∉ standardConic (K := K))
    (hQ : Q ∉ standardConic (K := K))
    (hPQ : P ≠ Q)
    {t : LinePoint K}
    (hPt : ConicSecantInvolution.equiv P hP t = t)
    (hQt : ConicSecantInvolution.equiv Q hQ t = t) :
    (ConicSecantInvolution.matrix P.rep *
        ConicSecantInvolution.matrix Q.rep) 0 1 ≠ 0 ∨
      (ConicSecantInvolution.matrix P.rep *
        ConicSecantInvolution.matrix Q.rep) 1 0 ≠ 0 := by
  let MP := ConicSecantInvolution.matrix P.rep
  let MQ := ConicSecantInvolution.matrix Q.rep
  let d := ProjectiveCap.Sym2Bridge.conicForm P.rep
  let lam := (MP * MQ) 0 0
  have hd : d ≠ 0 := ConicSecantInvolution.conicForm_rep_ne_zero hP
  have hcomm : MP * MQ = MQ * MP :=
    matrix_commute_of_common_fixed P Q hP hQ hPt hQt
  by_contra houter
  push Not at houter
  have hscalar : MP * MQ = lam • (1 : Matrix (Fin 2) (Fin 2) K) := by
    ext i j
    fin_cases i <;> fin_cases j
    · simp [lam]
    · simpa [MP, MQ] using houter.1
    · simpa [MP, MQ] using houter.2
    · have heq := sub_eq_zero.mp
        (outer_cross_eq_zero_of_common_fixed P Q hP hQ hPt hQt)
      simp [MP, MQ, ConicSecantInvolution.matrix, Matrix.mul_apply,
        Fin.sum_univ_two, lam]
      rw [heq]
      ring
  have hlam : lam ≠ 0 := by
    intro hlam
    have hzero : MP * MQ = 0 := by simpa [hlam] using hscalar
    have hdet := congrArg Matrix.det hzero
    rw [Matrix.det_mul] at hdet
    simp [MP, MQ, ConicSecantInvolution.matrix_det,
      ConicSecantInvolution.conicForm_rep_ne_zero hP,
      ConicSecantInvolution.conicForm_rep_ne_zero hQ] at hdet
  have hmat : d • MQ = lam • MP := by
    calc
      d • MQ = (d • (1 : Matrix (Fin 2) (Fin 2) K)) * MQ := by simp
      _ = (MP * MP) * MQ := by
        rw [ConicSecantInvolution.matrix_mul_self]
      _ = MP * (MP * MQ) := by rw [Matrix.mul_assoc]
      _ = MP * (lam • (1 : Matrix (Fin 2) (Fin 2) K)) := by rw [hscalar]
      _ = lam • MP := by
        ext i j
        fin_cases i <;> fin_cases j <;> simp [Matrix.mul_apply] <;> ring
  have hvec : d • Q.rep = lam • P.rep := by
    funext i
    fin_cases i
    · simpa [MP, MQ, ConicSecantInvolution.matrix] using
        congrFun (congrFun hmat 0) 1
    · simpa [MP, MQ, ConicSecantInvolution.matrix] using
        congrFun (congrFun hmat 0) 0
    · simpa [MP, MQ, ConicSecantInvolution.matrix] using
        congrFun (congrFun hmat 1) 0
  have hQP : Q = P := by
    rw [← Projectivization.mk_rep Q, ← Projectivization.mk_rep P]
    apply (Projectivization.mk_eq_mk_iff' K _ _ _ _).mpr
    refine ⟨Units.mk0 (lam / d) (div_ne_zero hlam hd), ?_⟩
    funext i
    have hi := congrFun hvec i
    simp only [Pi.smul_apply, smul_eq_mul] at hi ⊢
    change (lam / d) * P.rep i = Q.rep i
    rw [div_mul_eq_mul_div, div_eq_iff hd]
    simpa [mul_comm] using hi.symm
  exact hPQ hQP.symm

omit [CharP K 2] in
/-- A fixed representative of the product of two secant projectivities satisfies the tangent
quadratic determined by the off-diagonal entries of the product matrix. -/
theorem product_fixed_quadratic_mk
    (P Q : Point K)
    (hP : P ∉ standardConic (K := K))
    (hQ : Q ∉ standardConic (K := K))
    {t : LinePoint K}
    (hPt : ConicSecantInvolution.equiv P hP t = t)
    (hQt : ConicSecantInvolution.equiv Q hQ t = t)
    (v : LineSpace K) (hv : v ≠ 0)
    (hfix : ConicSecantInvolution.equiv P hP
      (ConicSecantInvolution.equiv Q hQ (Projectivization.mk K v hv)) =
        Projectivization.mk K v hv) :
    (ConicSecantInvolution.matrix P.rep *
        ConicSecantInvolution.matrix Q.rep) 1 0 * v 0 ^ 2 =
      (ConicSecantInvolution.matrix P.rep *
        ConicSecantInvolution.matrix Q.rep) 0 1 * v 1 ^ 2 := by
  rw [ConicSecantInvolution.equiv_mk, ConicSecantInvolution.equiv_mk] at hfix
  have hprod_ne :
      (ConicSecantInvolution.matrix P.rep *
        ConicSecantInvolution.matrix Q.rep) *ᵥ v ≠ 0 := by
    rw [← Matrix.mulVec_mulVec]
    exact ConicSecantInvolution.matrix_mulVec_ne_zero P hP
      (ConicSecantInvolution.matrix_mulVec_ne_zero Q hQ hv)
  have hfix' :
      Projectivization.mk K
          ((ConicSecantInvolution.matrix P.rep *
            ConicSecantInvolution.matrix Q.rep) *ᵥ v) hprod_ne =
        Projectivization.mk K v hv := by
    simpa only [Matrix.mulVec_mulVec] using hfix
  obtain ⟨c, hc⟩ :=
    (Projectivization.mk_eq_mk_iff' K _ _ _ _).mp hfix'
  have h0 := congrFun hc 0
  have h1 := congrFun hc 1
  simp [Matrix.mulVec, dotProduct, Fin.sum_univ_two] at h0 h1
  have hdiag :
      (ConicSecantInvolution.matrix P.rep *
          ConicSecantInvolution.matrix Q.rep) 0 0 =
        (ConicSecantInvolution.matrix P.rep *
          ConicSecantInvolution.matrix Q.rep) 1 1 := by
    have heq := sub_eq_zero.mp
      (outer_cross_eq_zero_of_common_fixed P Q hP hQ hPt hQt)
    simp [ConicSecantInvolution.matrix, Matrix.mul_apply, Fin.sum_univ_two]
    rw [heq]
    ring
  linear_combination -(v 0) * h1 + (v 1) * h0 +
    (v 0 * v 1) * hdiag

/-- The product of the secant projectivities attached to two distinct off-conic points with a
common fixed parameter has that parameter as its unique fixed point. -/
theorem product_fixed_unique
    (P Q : Point K)
    (hP : P ∉ standardConic (K := K))
    (hQ : Q ∉ standardConic (K := K))
    (hPQ : P ≠ Q)
    {t u : LinePoint K}
    (hPt : ConicSecantInvolution.equiv P hP t = t)
    (hQt : ConicSecantInvolution.equiv Q hQ t = t)
    (hu : ConicSecantInvolution.equiv P hP
      (ConicSecantInvolution.equiv Q hQ u) = u) :
    u = t := by
  induction u using Projectivization.ind with
  | h v hv =>
    induction t using Projectivization.ind with
    | h w hw =>
      have hvq :=
        product_fixed_quadratic_mk P Q hP hQ hPt hQt v hv hu
      have hwfix :
          ConicSecantInvolution.equiv P hP
            (ConicSecantInvolution.equiv Q hQ
              (Projectivization.mk K w hw)) =
              Projectivization.mk K w hw := by
        rw [hQt, hPt]
      have hwq :=
        product_fixed_quadratic_mk P Q hP hQ hPt hQt w hw hwfix
      exact mk_eq_mk_of_tangent_quadratic
        (product_outer_ne_zero_of_ne P Q hP hQ hPQ hPt hQt)
        hv hw hvq hwq

omit [CharP K 2] in
/-- Secant projectivities with a common fixed parameter commute pointwise. -/
theorem equiv_commute_of_common_fixed
    (P Q : Point K)
    (hP : P ∉ standardConic (K := K))
    (hQ : Q ∉ standardConic (K := K))
    {t : LinePoint K}
    (hPt : ConicSecantInvolution.equiv P hP t = t)
    (hQt : ConicSecantInvolution.equiv Q hQ t = t)
    (u : LinePoint K) :
    ConicSecantInvolution.equiv P hP
        (ConicSecantInvolution.equiv Q hQ u) =
      ConicSecantInvolution.equiv Q hQ
        (ConicSecantInvolution.equiv P hP u) := by
  induction u using Projectivization.ind with
  | h v hv =>
    rw [ConicSecantInvolution.equiv_mk, ConicSecantInvolution.equiv_mk,
      ConicSecantInvolution.equiv_mk, ConicSecantInvolution.equiv_mk]
    apply (Projectivization.mk_eq_mk_iff' K _ _ _ _).mpr
    refine ⟨1, ?_⟩
    rw [one_smul, Matrix.mulVec_mulVec, Matrix.mulVec_mulVec,
      ← matrix_commute_of_common_fixed P Q hP hQ hPt hQt]

/-- If an off-conic point and a conic point lie on a tangent line, then the corresponding
secant projectivity fixes the conic parameter. -/
theorem equiv_fixed_of_tangent_line
    (P : Point K) (hP : P ∉ standardConic (K := K))
    (l : Point K) {t : LinePoint K}
    (hPl : P ∈ l)
    (htl : ProjectiveCap.Sym2Bridge.veronesePoint t ∈ l)
    (htangent : (lineSlice (standardConic (K := K)) l).card = 1) :
    ConicSecantInvolution.equiv P hP t = t := by
  let Y := ProjectiveCap.Sym2Bridge.veronesePoint t
  let t' := ConicSecantInvolution.equiv P hP t
  let Y' := ProjectiveCap.Sym2Bridge.veronesePoint t'
  have hPY : P ≠ Y := by
    intro h
    apply hP
    rw [h]
    exact mem_standardConic.mpr ⟨t, rfl⟩
  have hchord : Collinear (L := Point K) P Y Y' :=
    ConicSecantInvolution.collinear_veronese_equiv P hP t
  obtain ⟨m, hPm, hYm, hY'm⟩ := hchord
  have hlm : l = m :=
    (Configuration.HasLines.existsUnique_line
      (P := Point K) (L := Point K) P Y hPY).unique
      ⟨hPl, htl⟩ ⟨hPm, hYm⟩
  have hY'l : Y' ∈ l := hlm ▸ hY'm
  have hY'C : Y' ∈ standardConic (K := K) :=
    mem_standardConic.mpr ⟨t', rfl⟩
  have hYC : Y ∈ standardConic (K := K) :=
    mem_standardConic.mpr ⟨t, rfl⟩
  have hY'mem : Y' ∈ lineSlice (standardConic (K := K)) l :=
    mem_lineSlice.mpr ⟨hY'l, hY'C⟩
  have hYmem : Y ∈ lineSlice (standardConic (K := K)) l :=
    mem_lineSlice.mpr ⟨htl, hYC⟩
  obtain ⟨z, hz⟩ := Finset.card_eq_one.mp htangent
  have hY'eq : Y' = Y := by
    have hY'z : Y' = z := by simpa [hz] using hY'mem
    have hYz : Y = z := by simpa [hz] using hYmem
    exact hY'z.trans hYz.symm
  exact ProjectiveCap.Sym2Bridge.veronesePoint_injective hY'eq

/-- Three commuting involutions with the same unique fixed point cannot act on a set of
cardinality `91`.  This is the sign form of the four-orbit congruence. -/
theorem no_card_ninety_one_of_two_commuting_unique_fixed_involutions
    {X : Type*} [Fintype X] [DecidableEq X]
    (s r : Equiv.Perm X) (t : X)
    (hcard : Fintype.card X = 91)
    (hs2 : s ^ 2 = 1) (hr2 : r ^ 2 = 1)
    (hsr2 : (s * r) ^ 2 = 1)
    (hfixeds : Function.fixedPoints s = {t})
    (hfixedr : Function.fixedPoints r = {t})
    (hfixedsr : Function.fixedPoints (s * r) = {t}) :
    False := by
  have hcards : Fintype.card (Function.fixedPoints s) = 1 := by
    calc
      Fintype.card (Function.fixedPoints s) =
          Fintype.card ({t} : Set X) :=
        Fintype.card_congr (Equiv.setCongr hfixeds)
      _ = 1 := by simp
  have hcardr : Fintype.card (Function.fixedPoints r) = 1 := by
    calc
      Fintype.card (Function.fixedPoints r) =
          Fintype.card ({t} : Set X) :=
        Fintype.card_congr (Equiv.setCongr hfixedr)
      _ = 1 := by simp
  have hcardsr : Fintype.card (Function.fixedPoints (s * r)) = 1 := by
    calc
      Fintype.card (Function.fixedPoints (s * r)) =
          Fintype.card ({t} : Set X) :=
        Fintype.card_congr (Equiv.setCongr hfixedsr)
      _ = 1 := by simp
  have hsigns := Equiv.Perm.sign_of_pow_two_eq_one hs2
  have hsignr := Equiv.Perm.sign_of_pow_two_eq_one hr2
  have hsignsr := Equiv.Perm.sign_of_pow_two_eq_one hsr2
  rw [hcard, hcards] at hsigns
  rw [hcard, hcardr] at hsignr
  rw [hcard, hcardsr, Equiv.Perm.sign_mul, hsigns, hsignr] at hsignsr
  norm_num at hsignsr

/-- Three commuting involutions with the same unique fixed point cannot act on a finite set whose
cardinality is three modulo four. -/
theorem no_card_four_mul_add_three_of_two_commuting_unique_fixed_involutions
    {X : Type*} [Fintype X] [DecidableEq X]
    (s r : Equiv.Perm X) (t : X) {j : ℕ}
    (hcard : Fintype.card X = 4 * j + 3)
    (hs2 : s ^ 2 = 1) (hr2 : r ^ 2 = 1)
    (hsr2 : (s * r) ^ 2 = 1)
    (hfixeds : Function.fixedPoints s = {t})
    (hfixedr : Function.fixedPoints r = {t})
    (hfixedsr : Function.fixedPoints (s * r) = {t}) :
    False := by
  have hcards : Fintype.card (Function.fixedPoints s) = 1 := by
    calc
      Fintype.card (Function.fixedPoints s) =
          Fintype.card ({t} : Set X) :=
        Fintype.card_congr (Equiv.setCongr hfixeds)
      _ = 1 := by simp
  have hcardr : Fintype.card (Function.fixedPoints r) = 1 := by
    calc
      Fintype.card (Function.fixedPoints r) =
          Fintype.card ({t} : Set X) :=
        Fintype.card_congr (Equiv.setCongr hfixedr)
      _ = 1 := by simp
  have hcardsr : Fintype.card (Function.fixedPoints (s * r)) = 1 := by
    calc
      Fintype.card (Function.fixedPoints (s * r)) =
          Fintype.card ({t} : Set X) :=
        Fintype.card_congr (Equiv.setCongr hfixedsr)
      _ = 1 := by simp
  have hexp : (4 * j + 3 - 1) / 2 = 2 * j + 1 := by omega
  have hsigns := Equiv.Perm.sign_of_pow_two_eq_one hs2
  have hsignr := Equiv.Perm.sign_of_pow_two_eq_one hr2
  have hsignsr := Equiv.Perm.sign_of_pow_two_eq_one hsr2
  rw [hcard, hcards, hexp] at hsigns
  rw [hcard, hcardr, hexp] at hsignr
  rw [hcard, hcardsr, hexp, Equiv.Perm.sign_mul, hsigns, hsignr] at hsignsr
  simp [pow_succ] at hsignsr

/-- At the exceptional parameter pair, the standard conic nucleus cannot belong to the arc. -/
theorem exceptional_candidate_standardNucleus_not_mem
    {A : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A (standardConic (K := K)))
    (hq : Fintype.card K = 4096) (hcard : A.card = 92)
    (hzero : scaledDefect (L := Point K) A (standardConic (K := K)) = 0) :
    standardNucleus (K := K) ∉ A := by
  intro hnu
  have hinc := exceptional_candidate_holeIncidence hcomplete hq hcard hzero
  have hmod :=
    (nucleus_mem_arc_constraints
      (CharP.cast_eq_zero K 2) hcomplete.1 hnu).2.2
  rw [hinc, hcard] at hmod
  norm_num [Nat.ModEq] at hmod

/-- For an arc of size `2n` with even `n`, zero defect and one conic incidence per secant force
the nucleus outside the arc and force at least one tangent arc secant. -/
theorem even_half_tangentSecants_nonempty
    {A : Finset (Point K)} {n : ℕ}
    (hcomplete : CompleteOutside (L := Point K) A (standardConic (K := K)))
    (hcard : A.card = 2 * n) (hnpos : 1 ≤ n) (hneven : Even n)
    (hzero : scaledDefect (L := Point K) A (standardConic (K := K)) = 0)
    (hinc : holeIncidence (L := Point K) A (standardConic (K := K)) =
      Nat.choose A.card 2) :
    standardNucleus (K := K) ∉ A ∧
      (tangentSecants (L := Point K) A (standardConic (K := K))).Nonempty := by
  have hchoose := two_mul_choose_two (2 * n)
  have hchooseA : Nat.choose A.card 2 = n * (2 * n - 1) := by
    rw [hcard]
    have hrhs : 2 * n * (2 * n - 1) = 2 * (n * (2 * n - 1)) := by
      simp [Nat.mul_assoc]
    rw [hrhs] at hchoose
    omega
  have hincEven :
      Even (holeIncidence (L := Point K) A (standardConic (K := K))) := by
    rw [hinc, hchooseA]
    exact hneven.mul_right _
  have hnu : standardNucleus (K := K) ∉ A := by
    intro hnu
    have hmod :=
      (nucleus_mem_arc_constraints
        (CharP.cast_eq_zero K 2) hcomplete.1 hnu).2.2
    have hleft :
        holeIncidence (L := Point K) A (standardConic (K := K)) % 2 = 0 :=
      Nat.even_iff.mp hincEven
    have hright : (A.card - 1) % 2 = 1 := by
      rw [hcard]
      omega
    rw [Nat.ModEq] at hmod
    omega
  refine ⟨hnu, ?_⟩
  have hconstraints :=
    nucleus_not_mem_arc_constraints (CharP.cast_eq_zero K 2) hcomplete hnu
  have hcases :=
    pointIndex_eq_zero_or_one_or_half_of_scaledDefect_eq_zero
      (L := Point K) hcomplete.1 hcomplete.2.1 hzero hnu
  have hindex :
      pointIndex (L := Point K) A (standardNucleus (K := K)) = n := by
    rcases hcases with h0 | h1 | hm
    · omega
    · have hmod := hconstraints.2.2.2.2
      have hleft :
          holeIncidence (L := Point K) A (standardConic (K := K)) % 2 = 0 :=
        Nat.even_iff.mp hincEven
      rw [Nat.ModEq, h1] at hmod
      norm_num at hmod
      omega
    · rw [hcard] at hm
      omega
  rw [Finset.nonempty_iff_ne_empty]
  intro hempty
  have ht := hconstraints.2.2.1
  rw [hempty, hindex] at ht
  simp at ht
  omega

/-- A tangent arc secant excludes zero defect whenever the invariant maximum-index conic set has
cardinality three modulo four and the conic nucleus is not an arc point. -/
theorem no_zeroDefect_of_tangentSecant_of_maximumIndex_card_four_mul_add_three
    {A : Finset (Point K)} {j : ℕ}
    (hcomplete : CompleteOutside (L := Point K) A (standardConic (K := K)))
    (hzero : scaledDefect (L := Point K) A (standardConic (K := K)) = 0)
    (heven : Even A.card)
    (hnuc : standardNucleus (K := K) ∉ A)
    (htangentNonempty :
      (tangentSecants (L := Point K) A (standardConic (K := K))).Nonempty)
    (hmaximumCard :
      (ZeroDefectConicInvariance.maximumIndexParameters A).card = 4 * j + 3) :
    False := by
  classical
  obtain ⟨l, hl⟩ := htangentNonempty
  obtain ⟨hsecant, hsliceCard⟩ := mem_tangentSecants.mp hl
  obtain ⟨P, hPA, Q, hQA, hPQ, hPl, hQl⟩ := hsecant
  obtain ⟨Y, hslice⟩ := Finset.card_eq_one.mp hsliceCard
  have hYslice : Y ∈ lineSlice (standardConic (K := K)) l := by
    simp [hslice]
  have hYl : Y ∈ l := (mem_lineSlice.mp hYslice).1
  have hYC : Y ∈ standardConic (K := K) := (mem_lineSlice.mp hYslice).2
  obtain ⟨t, rfl⟩ := mem_standardConic.mp hYC
  let Y := ProjectiveCap.Sym2Bridge.veronesePoint t
  have hPoff : P ∉ standardConic (K := K) :=
    fun hPC => Finset.disjoint_left.mp hcomplete.2.1 hPA hPC
  have hQoff : Q ∉ standardConic (K := K) :=
    fun hQC => Finset.disjoint_left.mp hcomplete.2.1 hQA hQC
  have hPt : ConicSecantInvolution.equiv P hPoff t = t :=
    equiv_fixed_of_tangent_line P hPoff l hPl hYl hsliceCard
  have hQt : ConicSecantInvolution.equiv Q hQoff t = t :=
    equiv_fixed_of_tangent_line Q hQoff l hQl hYl hsliceCard
  have hPnuc : P ≠ standardNucleus (K := K) := by
    intro h
    exact hnuc (h ▸ hPA)
  have hQnuc : Q ≠ standardNucleus (K := K) := by
    intro h
    exact hnuc (h ▸ hQA)
  have hYcovered : Covered (L := Point K) A Y :=
    covered_of_collinear_pair hPA hQA hPQ
      ⟨l, hYl, hPl, hQl⟩
  have hYhalf :
      pointIndex (L := Point K) A Y = A.card / 2 := by
    have hpatterns :=
      (scaledDefect_eq_zero_iff (L := Point K)
        hcomplete.1 hcomplete.2.1).mp hzero
    rcases hpatterns.2 Y
      (mem_standardConic.mpr ⟨t, rfl⟩) with hzeroIndex | hhalf
    · exact absurd hzeroIndex (by
        have : 0 < pointIndex (L := Point K) A Y := hYcovered
        omega)
    · exact hhalf
  have htmem :
      t ∈ ZeroDefectConicInvariance.maximumIndexParameters A :=
    ZeroDefectConicInvariance.mem_maximumIndexParameters.mpr hYhalf
  let X := {u // u ∈ ZeroDefectConicInvariance.maximumIndexParameters A}
  let tX : X := ⟨t, htmem⟩
  let s : Equiv.Perm X :=
    ZeroDefectConicInvariance.restrictedEquiv
      hcomplete hzero heven P hPA
  let r : Equiv.Perm X :=
    ZeroDefectConicInvariance.restrictedEquiv
      hcomplete hzero heven Q hQA
  have hXcard : Fintype.card X = 4 * j + 3 := by
    rw [show Fintype.card X =
      (ZeroDefectConicInvariance.maximumIndexParameters A).card by
        exact Fintype.card_coe _]
    exact hmaximumCard
  have hsval (x : X) :
      (s x).1 = ConicSecantInvolution.equiv P hPoff x.1 := rfl
  have hrval (x : X) :
      (r x).1 = ConicSecantInvolution.equiv Q hQoff x.1 := rfl
  have hs2 : s ^ 2 = 1 := by
    ext x
    simp only [pow_two, Equiv.Perm.mul_apply]
    rw [hsval, hsval, ConicSecantInvolution.equiv_apply_apply]
    simp
  have hr2 : r ^ 2 = 1 := by
    ext x
    simp only [pow_two, Equiv.Perm.mul_apply]
    rw [hrval, hrval, ConicSecantInvolution.equiv_apply_apply]
    simp
  have hsrcomm : s * r = r * s := by
    ext x
    simp only [Equiv.Perm.mul_apply]
    calc
      (s (r x)).1 =
          ConicSecantInvolution.equiv P hPoff (r x).1 := hsval (r x)
      _ = ConicSecantInvolution.equiv P hPoff
          (ConicSecantInvolution.equiv Q hQoff x.1) := by rw [hrval]
      _ = ConicSecantInvolution.equiv Q hQoff
          (ConicSecantInvolution.equiv P hPoff x.1) :=
        equiv_commute_of_common_fixed P Q hPoff hQoff hPt hQt x.1
      _ = ConicSecantInvolution.equiv Q hQoff (s x).1 := by rw [hsval]
      _ = (r (s x)).1 := (hrval (s x)).symm
  have hsr2 : (s * r) ^ 2 = 1 := by
    calc
      (s * r) ^ 2 = s * (r * s) * r := by simp [pow_two, mul_assoc]
      _ = s * (s * r) * r := by rw [hsrcomm]
      _ = (s ^ 2) * (r ^ 2) := by simp [pow_two, mul_assoc]
      _ = 1 := by rw [hs2, hr2, one_mul]
  have hfixeds : Function.fixedPoints s = {tX} := by
    ext x
    simp only [Function.mem_fixedPoints, Set.mem_singleton_iff]
    constructor
    · intro hx
      apply Subtype.ext
      apply fixed_unique P hPoff hPnuc
      · have := congrArg Subtype.val hx
        simpa [hsval] using this
      · exact hPt
    · intro hx
      subst x
      apply Subtype.ext
      simpa [hsval] using hPt
  have hfixedr : Function.fixedPoints r = {tX} := by
    ext x
    simp only [Function.mem_fixedPoints, Set.mem_singleton_iff]
    constructor
    · intro hx
      apply Subtype.ext
      apply fixed_unique Q hQoff hQnuc
      · have := congrArg Subtype.val hx
        simpa [hrval] using this
      · exact hQt
    · intro hx
      subst x
      apply Subtype.ext
      simpa [hrval] using hQt
  have hfixedsr : Function.fixedPoints (s * r) = {tX} := by
    ext x
    simp only [Function.mem_fixedPoints, Set.mem_singleton_iff]
    constructor
    · intro hx
      apply Subtype.ext
      apply product_fixed_unique P Q hPoff hQoff hPQ hPt hQt
      have := congrArg Subtype.val hx
      simpa [hsval, hrval] using this
    · intro hx
      subst x
      apply Subtype.ext
      change ConicSecantInvolution.equiv P hPoff
        (ConicSecantInvolution.equiv Q hQoff t) = t
      rw [hQt, hPt]
  exact no_card_four_mul_add_three_of_two_commuting_unique_fixed_involutions
    s r tX hXcard hs2 hr2 hsr2 hfixeds hfixedr hfixedsr

/-- An even arc of size `2n` with even `n` cannot have zero defect when its total conic incidence
equals its number of secants. -/
theorem no_zeroDefect_of_even_half_and_holeIncidence_eq_choose
    {A : Finset (Point K)} {n : ℕ}
    (hcomplete : CompleteOutside (L := Point K) A (standardConic (K := K)))
    (hcard : A.card = 2 * n) (hnpos : 1 ≤ n) (hneven : Even n)
    (hzero : scaledDefect (L := Point K) A (standardConic (K := K)) = 0)
    (hinc : holeIncidence (L := Point K) A (standardConic (K := K)) =
      Nat.choose A.card 2) :
    False := by
  obtain ⟨hnuc, htangent⟩ :=
    even_half_tangentSecants_nonempty
      hcomplete hcard hnpos hneven hzero hinc
  have hmaximum :=
    ZeroDefectConicInvariance.maximumIndexParameters_card_eq_two_mul_sub_one
      hcomplete hcard hnpos hzero hinc
  obtain ⟨r, hr⟩ := hneven
  have hrpos : 1 ≤ r := by omega
  let j := r - 1
  have hj : 2 * n - 1 = 4 * j + 3 := by
    dsimp [j]
    omega
  apply no_zeroDefect_of_tangentSecant_of_maximumIndex_card_four_mul_add_three
    hcomplete hzero (hcard ▸ ⟨n, by omega⟩) hnuc htangent
  rw [hmaximum, hj]

omit [DecidableEq K] in
/-- Over a finite field of characteristic two, the half-size parameter on the upper even equality
branch is even. -/
theorem upper_even_equality_branch_half_even
    {n : ℕ} (hn : 3 ≤ n)
    (hq : Fintype.card K = Nat.choose (2 * n - 1) 2 + 1) :
    Even n := by
  have hchoosePred := two_mul_choose_two (2 * n - 1)
  have hchoosePredValue :
      Nat.choose (2 * n - 1) 2 = (2 * n - 1) * (n - 1) := by
    have hsub : 2 * n - 1 - 1 = 2 * (n - 1) := by omega
    rw [hsub] at hchoosePred
    have hrhs :
        (2 * n - 1) * (2 * (n - 1)) =
          2 * ((2 * n - 1) * (n - 1)) := by ring
    rw [hrhs] at hchoosePred
    omega
  have hqValue :
      Fintype.card K = (2 * n - 1) * (n - 1) + 1 := by
    simpa [hchoosePredValue] using hq
  obtain ⟨e, _hprime, hpow⟩ := FiniteField.card K 2
  have hcardMod : Fintype.card K % 2 = 0 := by
    rw [hpow]
    obtain ⟨d, hd⟩ : ∃ d : ℕ, (e : ℕ) = d + 1 :=
      Nat.exists_eq_succ_of_ne_zero e.ne_zero
    rw [hd, pow_succ]
    simp
  by_contra hneven
  have hnodd : Odd n := Nat.not_even_iff_odd.mp hneven
  obtain ⟨r, hr⟩ := hnodd
  rw [hqValue, hr] at hcardMod
  norm_num [Nat.add_mod, Nat.mul_mod] at hcardMod

/-- The upper even equality branch is impossible over every finite field of characteristic two. -/
theorem no_upper_even_equality_branch
    {A : Finset (Point K)} {n : ℕ}
    (hcomplete : CompleteOutside (L := Point K) A (standardConic (K := K)))
    (hcard : A.card = 2 * n) (hn : 3 ≤ n)
    (hq : Fintype.card K = Nat.choose (2 * n - 1) 2 + 1)
    (hzero : scaledDefect (L := Point K) A (standardConic (K := K)) = 0) :
    False := by
  have hinc :=
    upper_even_equality_branch_holeIncidence hcomplete hcard hn hq hzero
  exact no_zeroDefect_of_even_half_and_holeIncidence_eq_choose
    hcomplete hcard (by omega) (upper_even_equality_branch_half_even hn hq)
      hzero hinc

/-- An even zero-defect arc complete outside the standard conic has hyperoval size.  The
three-order equality spectrum is purely incidence-theoretic; characteristic two eliminates its
middle root, and the conic involution argument eliminates its upper root. -/
theorem even_standardConic_zeroDefect_charTwo_order
    {A : Finset (Point K)} {n : ℕ}
    (hcomplete : CompleteOutside (L := Point K) A (standardConic (K := K)))
    (hcard : A.card = 2 * n) (hn : 3 ≤ n)
    (hzero : scaledDefect (L := Point K) A (standardConic (K := K)) = 0) :
    Fintype.card K = A.card - 2 := by
  have hconicCard :
      (standardConic (K := K)).card =
        PlaneOrder (Point K) (Point K) + 1 := by
    rw [ProjectiveBridge.planeOrder_eq_card]
    exact standardConic_card (K := K)
  have hspectrum :=
    even_completeOutside_zeroDefect_order_spectrum
      (P := Point K) (L := Point K) hcomplete hconicCard hcard hn hzero
  rw [ProjectiveBridge.planeOrder_eq_card, hcard] at hspectrum
  have hchoosePred : Nat.choose (2 * n - 1) 2 =
      (2 * n - 1) * (n - 1) := by
    have h := two_mul_choose_two (2 * n - 1)
    have hsub : 2 * n - 1 - 1 = 2 * (n - 1) := by omega
    rw [hsub] at h
    have hrhs : (2 * n - 1) * (2 * (n - 1)) =
        2 * ((2 * n - 1) * (n - 1)) := by ring
    rw [hrhs] at h
    omega
  simp only [hchoosePred] at hspectrum
  obtain ⟨e, _hprime, hpow⟩ := FiniteField.card K 2
  rcases even_equality_spectrum_power_two hn hpow hspectrum with hfirst | hupper
  · rw [hcard]
    exact hfirst
  · exact (no_upper_even_equality_branch hcomplete hcard hn
      (by simpa [hchoosePred] using hupper) hzero).elim

/-- No zero-defect relative-complete `92`-arc exists outside the standard conic over a field of
order `4096`.  This is the `n = 46` specialization of the uniform upper-branch exclusion. -/
theorem no_exceptional_candidate_standardConic
    {A : Finset (Point K)}
    (hcomplete : CompleteOutside (L := Point K) A (standardConic (K := K)))
    (hq : Fintype.card K = 4096) (hcard : A.card = 92)
    (hzero : scaledDefect (L := Point K) A (standardConic (K := K)) = 0) :
    False := by
  have horder := even_standardConic_zeroDefect_charTwo_order
    (n := 46) hcomplete hcard (by norm_num) hzero
  omega

end TangentPairFourGroup
end RelativeConicArcs
