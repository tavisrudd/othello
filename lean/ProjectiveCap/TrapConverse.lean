import ProjectiveCap.GridMirror

/-!
# Trapped residual positions imply an N projective plane

This file closes the converse direction of the odd-escape reduction: if the
rank-three projective cap game is P, then every legal residual size-three grid
position has a P-valued child.  Equivalently, a trapped residual size-three
position transports to a P-valued child of the standard projective frame, so the
frame is N and the empty game cannot be P.
-/

open scoped LinearAlgebra.Projectivization

namespace ProjectiveCap

namespace GridGame

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

namespace TrapConverse

open Projective
open Projective.FrameGridBridge.Coordinate

variable [DecidableEq (Projective.Point K (PlaneVec K))]
variable [Fintype (Projective.Point K (PlaneVec K))]

/--
Coordinate converse: if the standard coordinate projective plane is P, then
the residual odd-escape statement holds.
-/
theorem oddEscapeStatement_of_coordinateInitialPStatement
    (hInitial : Projective.InitialPStatement
      (K := K) (V := PlaneVec K)) :
    OddEscapeStatement (K := K) := by
  classical
  by_contra hOdd
  unfold OddEscapeStatement at hOdd
  push Not at hOdd
  rcases hOdd with ⟨S, hScard, hScap, hTrap⟩
  have hSP : GridGame.IsP (K := K) S := by
    rw [GridGame.isP_iff_all_children_win]
    intro p hpMove
    have hpLegal : p ∈ GridGame.LegalExtensions (K := K) S :=
      GridGame.mem_legalExtensions.mpr hpMove
    exact not_not.mp (hTrap p hpLegal)
  let A : Finset (Projective.Point K (PlaneVec K)) :=
    fixedDirections (K := K) ∪ S.map (affineEmbedding (K := K))
  have hAP :
      FiniteBuildGame.IsP (Projective.Cap K (PlaneVec K)) A := by
    dsimp [A]
    exact (isP_fixedDirections_iff_grid (K := K) S).mpr hSP
  have hAcap : Projective.Cap K (PlaneVec K) A := by
    dsimp [A]
    exact projectiveCap_of_gridCap (K := K) hScap
  have hAcard : A.card = 5 := by
    dsimp [A]
    rw [fixed_union_affine_image_card (K := K), hScard]
  have hSnonempty : S.Nonempty := by
    apply Finset.card_pos.mp
    rw [hScard]
    norm_num
  rcases hSnonempty with ⟨p0, hp0S⟩
  let y : Projective.Point K (PlaneVec K) := affinePoint (K := K) p0
  have hyA : y ∈ A := by
    dsimp [A, y]
    exact Finset.mem_union_right _
      (affinePoint_mem_map (K := K) hp0S)
  let F : Finset (Projective.Point K (PlaneVec K)) := A.erase y
  have hyF : y ∉ F := by
    dsimp [F]
    simp
  have hFsubset : F ⊆ A := by
    dsimp [F]
    exact Finset.erase_subset y A
  have hFcap : Projective.Cap K (PlaneVec K) F :=
    Projective.cap_mono hFsubset hAcap
  have hFcard : F.card = 4 := by
    dsimp [F]
    rw [Finset.card_erase_of_mem hyA, hAcard]
  let T : Finset (Projective.Point K (PlaneVec K)) :=
    fixedDirections (K := K) ∪
      (StandardResidualSeed (K := K)).map (affineEmbedding (K := K))
  have hTcap : Projective.Cap K (PlaneVec K) T := by
    dsimp [T]
    exact projectiveCap_of_gridCap (K := K)
      (standardResidualSeed_gridCap (K := K))
  have hTcard : T.card = 4 := by
    dsimp [T]
    rw [fixed_union_affine_image_card (K := K),
      standardResidualSeed_card]
  have hrankCoord : Module.finrank K (PlaneVec K) = 3 := by
    rw [Module.finrank_fintype_fun_eq_card, Fintype.card_fin]
  rcases Projective.capTransitiveStatement_four
      (K := K) (V := PlaneVec K) hrankCoord
      hFcap hTcap hFcard hTcard with
    ⟨e, hValid, hFmap⟩
  have heyT : e y ∉ T := by
    intro hey
    have hey' : e y ∈ F.map e.toEmbedding := by
      rwa [hFmap]
    rw [Finset.mem_map_equiv, Equiv.symm_apply_apply] at hey'
    exact hyF hey'
  have hAinsert : insert y F = A := by
    dsimp [F]
    exact Finset.insert_erase hyA
  have hAmap :
      A.map e.toEmbedding = insert (e y) T := by
    calc
      A.map e.toEmbedding = (insert y F).map e.toEmbedding := by
        rw [hAinsert]
      _ = insert (e y) (F.map e.toEmbedding) := by
        simp [Finset.map_insert]
      _ = insert (e y) T := by
        rw [hFmap]
  have hAmapP :
      FiniteBuildGame.IsP (Projective.Cap K (PlaneVec K))
        (A.map e.toEmbedding) :=
    (FiniteBuildGame.isP_map e hValid A).mpr hAP
  have hChildP :
      FiniteBuildGame.IsP (Projective.Cap K (PlaneVec K))
        (insert (e y) T) := by
    rwa [← hAmap]
  have hChildCap :
      Projective.Cap K (PlaneVec K) (insert (e y) T) := by
    rw [← hAmap]
    exact (hValid A).mpr hAcap
  have hMove :
      FiniteBuildGame.Move (Projective.Cap K (PlaneVec K)) T (e y) :=
    ⟨heyT, hChildCap⟩
  have hTWin :
      FiniteBuildGame.Win (Projective.Cap K (PlaneVec K)) T :=
    FiniteBuildGame.win_of_move_to_isP hMove hChildP
  have hTP :
      FiniteBuildGame.IsP (Projective.Cap K (PlaneVec K)) T :=
    ((Projective.initialPStatement_iff_isP_frame_of_finrank
      (K := K) (V := PlaneVec K) hrankCoord hTcap hTcard).mp hInitial)
  exact hTP hTWin

omit [DecidableEq (Projective.Point K (PlaneVec K))]
  [Fintype (Projective.Point K (PlaneVec K))] in
/--
Rank-three converse transported from the coordinate plane.
-/
theorem oddEscapeStatement_of_initialPStatement_finrank
    {V : Type*} [AddCommGroup V] [Module K V]
    [Fintype (Projective.Point K V)] [DecidableEq (Projective.Point K V)]
    (hInitial : Projective.InitialPStatement (K := K) (V := V))
    (hrank : Module.finrank K V = 3) :
    OddEscapeStatement (K := K) := by
  classical
  letI : Module.Finite K V := Module.finite_of_finrank_pos (by
    rw [hrank]
    norm_num)
  letI : Module.Finite K (PlaneVec K) :=
    Module.finite_of_finrank_pos (by
      rw [Module.finrank_fintype_fun_eq_card, Fintype.card_fin]
      norm_num)
  let e : PlaneVec K ≃ₗ[K] V :=
    LinearEquiv.ofFinrankEq _ _ (by
      rw [Module.finrank_fintype_fun_eq_card, Fintype.card_fin, hrank])
  letI : Fintype (Projective.Point K (PlaneVec K)) :=
    Fintype.ofEquiv (Projective.Point K V) (Projective.mapLinearEquiv e).symm
  have hcoord :
      Projective.InitialPStatement (K := K) (V := PlaneVec K) := by
    have htransport :
        FiniteBuildGame.IsP (Projective.Cap K V)
          ((∅ : Finset (Projective.Point K (PlaneVec K))).map
            (Projective.mapLinearEquiv e).toEmbedding) := by
      simpa [Projective.InitialPStatement] using hInitial
    exact (Projective.isP_mapLinearEquiv
      (K := K) (V := PlaneVec K) (W := V)
      e (∅ : Finset (Projective.Point K (PlaneVec K)))).mp htransport
  exact oddEscapeStatement_of_coordinateInitialPStatement
    (K := K) hcoord

omit [DecidableEq (Projective.Point K (PlaneVec K))]
  [Fintype (Projective.Point K (PlaneVec K))] in
/--
The rank-three projective cap game is P exactly when the residual odd-escape
kernel holds.
-/
theorem initialPStatement_iff_oddEscapeStatement_finrank
    {V : Type*} [AddCommGroup V] [Module K V]
    [Fintype (Projective.Point K V)] [DecidableEq (Projective.Point K V)]
    (hrank : Module.finrank K V = 3) :
    Projective.InitialPStatement (K := K) (V := V) ↔
      OddEscapeStatement (K := K) :=
  ⟨fun hInitial =>
      oddEscapeStatement_of_initialPStatement_finrank
        (K := K) (V := V) hInitial hrank,
    fun hOdd =>
      GridMirror.initialPStatement_of_oddEscapeStatement_finrank
        (K := K) (V := V) hOdd hrank⟩

end TrapConverse
end GridGame
end ProjectiveCap
