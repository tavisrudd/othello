import ProjectiveCap.Mirror
import ProjectiveCap.PlaneTransitivityGame
import Mathlib.FieldTheory.Finite.Basic

/-!
# Elliptic projective mirrors

This file builds the standard block elliptic linear automorphism
`(a, b) ↦ (δ * b, a)`.  Its square is scalar multiplication by `δ`; when
`δ` is nonsquare, the projectivized map is a fixed-point-free involution and
the projective cap game is P by the mirror theorem in `ProjectiveCap.Mirror`.
-/

open scoped LinearAlgebra.Projectivization

namespace ProjectiveCap
namespace Projective

noncomputable section

variable {K ι : Type*} [Field K]

/-- Block elliptic linear equivalence on `ι` copies of `K × K`. -/
def ellipticBlockLinearEquiv (δ : K) (hδ : δ ≠ 0) :
    (ι -> K × K) ≃ₗ[K] (ι -> K × K) where
  toFun v i := (δ * (v i).2, (v i).1)
  invFun v i := ((v i).2, δ⁻¹ * (v i).1)
  map_add' v w := by
    ext i <;> simp [mul_add]
  map_smul' a v := by
    ext i <;> simp [mul_left_comm]
  left_inv v := by
    ext i <;> simp [hδ]
  right_inv v := by
    ext i <;> simp [hδ]

theorem ellipticBlockLinearEquiv_sq (δ : K) (hδ : δ ≠ 0)
    (v : ι -> K × K) :
    ellipticBlockLinearEquiv (K := K) (ι := ι) δ hδ
        (ellipticBlockLinearEquiv (K := K) (ι := ι) δ hδ v) =
      δ • v := by
  ext i <;> simp [ellipticBlockLinearEquiv]

/--
Coordinate odd-projective-dimension theorem: on a direct product of `2`-blocks,
a nonsquare scalar supplies a fixed-point-free elliptic projective involution,
so the initial projective cap-game position is P.
-/
theorem initialPStatement_ellipticBlock_of_nonsquare
    [Fintype ι] [Fintype K] [Fintype (Point K (ι -> K × K))]
    [DecidableEq (Point K (ι -> K × K))]
    (δ : K) (hnonsquare : ¬ IsSquare δ) :
    InitialPStatement (K := K) (V := ι -> K × K) := by
  have hδ : δ ≠ 0 := by
    intro hδ0
    exact hnonsquare (by simp [hδ0])
  exact initialPStatement_of_linearEquiv_sq_scalar_nonsquare
    (K := K) (V := ι -> K × K)
    (ellipticBlockLinearEquiv (K := K) (ι := ι) δ hδ) δ
    (ellipticBlockLinearEquiv_sq (K := K) (ι := ι) δ hδ) hnonsquare

/--
Odd-cardinality coordinate corollary: a finite field of odd cardinality has a
nonsquare, so the elliptic block mirror proves the projective cap game is P on
the `2 * #ι`-dimensional coordinate vector space.
-/
theorem initialPStatement_ellipticBlock_of_odd_card
    [Fintype ι] [Fintype K] [Fintype (Point K (ι -> K × K))]
    [DecidableEq (Point K (ι -> K × K))]
    (hq : Odd (Fintype.card K)) :
    InitialPStatement (K := K) (V := ι -> K × K) := by
  have hchar : ringChar K ≠ 2 := by
    intro hchar
    have hmod : Fintype.card K % 2 = 0 :=
      (FiniteField.even_card_iff_char_two (F := K)).mp hchar
    have heven : Even (Fintype.card K) := by
      rw [Nat.even_iff]
      exact hmod
    exact (Nat.not_odd_iff_even.mpr heven) hq
  letI : Finite K := Fintype.finite (α := K) inferInstance
  rcases FiniteField.exists_nonsquare (F := K) hchar with ⟨δ, hδ⟩
  exact initialPStatement_ellipticBlock_of_nonsquare
    (K := K) (ι := ι) δ hδ

/--
Odd-dimensional projective theorem in any finite-rank model whose vector
dimension is `2 * n`.

For `n > 0`, this is the Lean form of the statement that `PG(2n-1,q)` over an
odd finite field is P by a fixed-point-free elliptic involution.
-/
theorem initialPStatement_of_odd_card_finrank_eq_two_mul
    {V : Type*} [AddCommGroup V] [Module K V]
    [Fintype K] [Fintype (Point K V)] [DecidableEq (Point K V)]
    (hq : Odd (Fintype.card K)) {n : ℕ} (hn : 0 < n)
    (hrank : Module.finrank K V = 2 * n) :
    InitialPStatement (K := K) (V := V) := by
  classical
  have hcoordRank : Module.finrank K (Fin n -> K × K) = 2 * n := by
    rw [Module.finrank_pi_fintype]
    simp [Module.finrank_prod, Fintype.card_fin, mul_comm]
  letI : Module.Finite K V := Module.finite_of_finrank_pos (by
    rw [hrank]
    omega)
  letI : Module.Finite K (Fin n -> K × K) :=
    Module.finite_of_finrank_pos (by
      rw [hcoordRank]
      omega)
  let e : (Fin n -> K × K) ≃ₗ[K] V :=
    LinearEquiv.ofFinrankEq _ _ (by
      rw [hcoordRank, hrank])
  letI : Fintype (Point K (Fin n -> K × K)) :=
    Fintype.ofEquiv (Point K V) (mapLinearEquiv e).symm
  have hcoord :
      InitialPStatement (K := K) (V := Fin n -> K × K) :=
    initialPStatement_ellipticBlock_of_odd_card (K := K) (ι := Fin n) hq
  have htransport :
      FiniteBuildGame.IsP (Cap K V)
        ((∅ : Finset (Point K (Fin n -> K × K))).map
          (mapLinearEquiv e).toEmbedding) :=
    (isP_mapLinearEquiv (K := K) (V := Fin n -> K × K) (W := V)
      e (∅ : Finset (Point K (Fin n -> K × K)))).mpr hcoord
  simpa [InitialPStatement] using htransport

end

end Projective
end ProjectiveCap
