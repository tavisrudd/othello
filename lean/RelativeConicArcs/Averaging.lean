import RelativeConicArcs.Conic
import ProjectiveCap.PlaneTransitivity
import Mathlib.GroupTheory.GroupAction.Quotient
import Mathlib.LinearAlgebra.Projectivization.Action
import Mathlib.Algebra.Group.Action.Pointwise.Finset

/-!
# Projective averaging

The first section proves a reusable union-bound form of finite transitive-action averaging.  The
second applies it to projective linear automorphisms of `PG(2,K)`.
-/

namespace RelativeConicArcs
namespace Averaging

open Finset MulAction

section FiniteAction

variable {G X : Type*} [Group G] [Fintype G] [Fintype X] [MulAction G X]
  [DecidableEq G] [DecidableEq X]

/-- Group elements sending `a` to `b`. -/
def actionFiber (a b : X) : Finset G := Finset.univ.filter fun g => g • a = b

/-- Image of a finite point set under a group element. -/
def actionImage (g : G) (A : Finset X) : Finset X := A.image fun x => g • x

omit [Fintype G] [Fintype X] [DecidableEq G] in
@[simp] theorem mem_actionImage {g : G} {A : Finset X} {x : X} :
    x ∈ actionImage g A ↔ ∃ a ∈ A, g • a = x := by simp [actionImage]

omit [Fintype X] [DecidableEq G] in
@[simp] theorem mem_actionFiber {a b : X} {g : G} :
    g ∈ actionFiber a b ↔ g • a = b := by simp [actionFiber]

/-- A nonempty action fiber is a torsor for the stabilizer. -/
noncomputable def actionFiberEquivStabilizer {a b : X} (g₀ : G) (hg₀ : g₀ • a = b) :
    {g // g ∈ actionFiber (G := G) a b} ≃ MulAction.stabilizer G a where
  toFun g := ⟨g₀⁻¹ * g.1, by
    change (g₀⁻¹ * g.1) • a = a
    rw [mul_smul, mem_actionFiber.mp g.2, ← hg₀, inv_smul_smul]⟩
  invFun h := ⟨g₀ * h.1, mem_actionFiber.mpr (by
    rw [mul_smul, h.2, hg₀])⟩
  left_inv g := by
    apply Subtype.ext
    simp
  right_inv h := by
    apply Subtype.ext
    simp

variable [IsPretransitive G X]

omit [Fintype X] [DecidableEq G] in
theorem card_actionFiber (a b : X) :
    (actionFiber (G := G) a b).card = Fintype.card (MulAction.stabilizer G a) := by
  obtain ⟨g₀, hg₀⟩ := MulAction.exists_smul_eq G a b
  rw [← Fintype.card_coe]
  exact Fintype.card_congr (actionFiberEquivStabilizer (G := G) g₀ hg₀)

omit [DecidableEq G] in
theorem card_group_eq_card_points_mul_stabilizer (a : X) :
    Fintype.card G = Fintype.card X * Fintype.card (MulAction.stabilizer G a) := by
  letI : Fintype (MulAction.orbit G a) := Fintype.ofFinite _
  have horbit : Fintype.card (MulAction.orbit G a) = Fintype.card X :=
    Fintype.card_congr ((Equiv.setCongr (orbit_eq_univ G a)).trans (Equiv.Set.univ X))
  have h := (card_orbit_mul_card_stabilizer_eq_card_group G a).symm
  rw [horbit] at h
  exact h

/-- If `|A||B| < |X|`, some group translate of `A` is disjoint from `B`. -/
theorem exists_disjoint_smul (A B : Finset X)
    (hsmall : A.card * B.card < Fintype.card X) :
    ∃ g : G, Disjoint (actionImage g A) B := by
  classical
  by_cases hA : A = ∅
  · exact ⟨1, by simp [actionImage, hA]⟩
  by_cases hB : B = ∅
  · exact ⟨1, by simp [hB]⟩
  have hAne : A.Nonempty := Finset.nonempty_iff_ne_empty.mpr hA
  let a₀ : X := hAne.choose
  have ha₀ : a₀ ∈ A := hAne.choose_spec
  letI : Nonempty X := ⟨a₀⟩
  let c := Fintype.card (MulAction.stabilizer G a₀)
  have hcpos : 0 < c := Fintype.card_pos
  have hstab (a : X) : Fintype.card (MulAction.stabilizer G a) = c := by
    have ha := card_group_eq_card_points_mul_stabilizer (G := G) a
    have ha₀eq := card_group_eq_card_points_mul_stabilizer (G := G) a₀
    dsimp [c]
    apply Nat.mul_left_cancel (Fintype.card_pos : 0 < Fintype.card X)
    exact ha.symm.trans ha₀eq
  by_contra hnone
  push Not at hnone
  let cover : Finset G := A.biUnion fun a => B.biUnion fun b => actionFiber a b
  have huniv : Finset.univ ⊆ cover := by
    intro g _hg
    have hnot := hnone g
    rw [Finset.not_disjoint_iff] at hnot
    obtain ⟨x, hxgA, hxB⟩ := hnot
    obtain ⟨a, ha, hga⟩ := mem_actionImage.mp hxgA
    apply Finset.mem_biUnion.mpr
    refine ⟨a, ha, Finset.mem_biUnion.mpr ⟨x, hxB, ?_⟩⟩
    exact mem_actionFiber.mpr hga
  have hcover : cover.card ≤
      A.card * (B.card * c) := by
    calc
      cover.card ≤ ∑ a ∈ A, (B.biUnion fun b => actionFiber a b).card :=
        Finset.card_biUnion_le
      _ ≤ ∑ a ∈ A, ∑ b ∈ B, (actionFiber a b).card := by
        exact Finset.sum_le_sum fun a _ha => Finset.card_biUnion_le
      _ = ∑ _a ∈ A, ∑ _b ∈ B, c := by
        apply Finset.sum_congr rfl
        intro a _ha
        apply Finset.sum_congr rfl
        intro b _hb
        rw [card_actionFiber (G := G), hstab]
      _ = A.card * (B.card * c) := by simp
  have hGle : Fintype.card G ≤ cover.card := by
    simpa only [Finset.card_univ] using Finset.card_le_card huniv
  have hGeq := card_group_eq_card_points_mul_stabilizer (G := G) a₀
  rw [hstab] at hGeq
  have hmul : Fintype.card X * c ≤ A.card * B.card * c := by
    calc
      Fintype.card X * c = Fintype.card G := hGeq.symm
      _ ≤ cover.card := hGle
      _ ≤ A.card * (B.card * c) := hcover
      _ = A.card * B.card * c := by ring
  have : Fintype.card X ≤ A.card * B.card := Nat.le_of_mul_le_mul_right hmul hcpos
  omega

end FiniteAction

/-! ## Projective-plane specialization -/

open Conic Projectivization
open scoped LinearAlgebra.Projectivization

/-- Ordinary completeness is relative completeness with no prescribed holes. -/
abbrev CompleteArc {P L : Type*} [Membership P L] [Fintype P] [Fintype L]
    [DecidableEq P] (A : Finset P) : Prop :=
  CompleteOutside (L := L) A ∅

section Completeness

variable {P L : Type*} [Membership P L] [Fintype P] [Fintype L] [DecidableEq P]

/-- An ordinary complete arc disjoint from `H` is complete outside `H`. -/
theorem completeOutside_of_completeArc_of_disjoint {A H : Finset P}
    (hA : CompleteArc (L := L) A) (hdisj : Disjoint A H) :
    CompleteOutside (L := L) A H := by
  refine ⟨hA.1, hdisj, ?_⟩
  intro x hxA _hxH
  exact hA.2.2 x hxA (by simp)

end Completeness

section ProjectiveAction

variable {K : Type*} [Field K]
variable {V : Type*} [AddCommGroup V] [Module K V]

/-- The mathlib action of a linear automorphism on projective space is the existing
`Projective.mapEquiv` construction. -/
theorem linearEquiv_smul_eq_mapEquiv (g : V ≃ₗ[K] V)
    (p : Projectivization K V) :
    g • p = ProjectiveCap.Projective.mapEquiv g p := by
  induction p using Projectivization.ind with
  | h v hv =>
      rw [Projectivization.smul_mk, ProjectiveCap.Projective.mapEquiv_mk]
      rfl

variable [Fintype K] [DecidableEq K]

noncomputable local instance instFintypePoint : Fintype (Point K) :=
  Fintype.ofFinite (Point K)

noncomputable local instance instDecidableEqPoint : DecidableEq (Point K) :=
  Classical.decEq (Point K)

omit [DecidableEq K] in
/-- The number of points in `PG(2,K)`. -/
theorem card_projectivePlane :
    Fintype.card (Point K) = Fintype.card K ^ 2 + Fintype.card K + 1 := by
  rw [← Nat.card_eq_fintype_card,
    Projectivization.card_of_finrank K (PlaneSpace K) (n := 3) (by simp)]
  norm_num [Finset.sum_range_succ]
  ring

omit [DecidableEq K] in
/-- The finite-action averaging lemma instantiated with projective linear automorphisms. -/
theorem exists_projective_map_disjoint (A B : Finset (Point K))
    (hsmall : A.card * B.card < Fintype.card (Point K)) :
    ∃ g : PlaneSpace K ≃ₗ[K] PlaneSpace K,
      Disjoint (A.map (ProjectiveCap.Projective.mapEquiv g).toEmbedding) B := by
  classical
  letI : Finite (PlaneSpace K ≃ₗ[K] PlaneSpace K) :=
    Finite.of_injective
      (fun g : PlaneSpace K ≃ₗ[K] PlaneSpace K => (g : PlaneSpace K → PlaneSpace K))
      DFunLike.coe_injective
  letI : Fintype (PlaneSpace K ≃ₗ[K] PlaneSpace K) := Fintype.ofFinite _
  letI : IsPretransitive (PlaneSpace K ≃ₗ[K] PlaneSpace K) (Point K) :=
    MulAction.isPretransitive_of_is_two_pretransitive
  obtain ⟨g, hg⟩ := exists_disjoint_smul
    (G := PlaneSpace K ≃ₗ[K] PlaneSpace K) A B hsmall
  refine ⟨g, ?_⟩
  have heq : actionImage g A =
      A.map (ProjectiveCap.Projective.mapEquiv g).toEmbedding := by
    simp only [actionImage, Finset.map_eq_image]
    congr 1
  rwa [← heq]

/-- Ordinary complete arcs are preserved by projective linear automorphisms. -/
theorem completeArc_map_projective (g : PlaneSpace K ≃ₗ[K] PlaneSpace K)
    {A : Finset (Point K)} (hA : CompleteArc (L := Point K) A) :
    CompleteArc (L := Point K)
      (A.map (ProjectiveCap.Projective.mapEquiv g).toEmbedding) := by
  have hcol : ∀ x a b,
      Collinear (L := Point K) (ProjectiveCap.Projective.mapEquiv g x)
          (ProjectiveCap.Projective.mapEquiv g a) (ProjectiveCap.Projective.mapEquiv g b) ↔
        Collinear (L := Point K) x a b := by
    intro x a b
    rw [ProjectiveBridge.collinear_iff_projective_collinear,
      ProjectiveCap.Projective.collinear_mapEquiv,
      ProjectiveBridge.collinear_iff_projective_collinear]
  simpa using completeOutside_map (L := Point K)
    (ProjectiveCap.Projective.mapEquiv g) hcol hA

/-- A complete arc `A` can be moved off any prescribed hole set `H` whenever
`|A| |H| < |PG(2,K)|`; the moved arc is then complete outside `H`. -/
theorem exists_completeOutside_of_completeArc
    (H : Finset (Point K)) {A : Finset (Point K)}
    (hA : CompleteArc (L := Point K) A)
    (hsmall : A.card * H.card < Fintype.card (Point K)) :
    ∃ B : Finset (Point K), CompleteOutside (L := Point K) B H ∧ B.card = A.card := by
  obtain ⟨g, hdisj⟩ := exists_projective_map_disjoint A H hsmall
  let B := A.map (ProjectiveCap.Projective.mapEquiv g).toEmbedding
  refine ⟨B, completeOutside_of_completeArc_of_disjoint
    (completeArc_map_projective g hA) hdisj, ?_⟩
  simp [B]

#print axioms exists_completeOutside_of_completeArc

/-- Any arc of size at most `q` has a projective image disjoint from a nonsingular conic. -/
theorem exists_projective_map_disjoint_conic (C : NonsingularConic (K := K))
    (A : Finset (Point K)) (hcard : A.card ≤ Fintype.card K) :
    ∃ g : PlaneSpace K ≃ₗ[K] PlaneSpace K,
      Disjoint (A.map (ProjectiveCap.Projective.mapEquiv g).toEmbedding) C.points := by
  apply exists_projective_map_disjoint
  rw [C.card_points, card_projectivePlane]
  have hq : 1 < Fintype.card K := Fintype.one_lt_card
  nlinarith

/-- An ordinary complete `b`-arc with `b ≤ q` gives a conic-complete `b`-arc. -/
theorem exists_completeOutside_conic_of_completeArc
    (C : NonsingularConic (K := K)) {A : Finset (Point K)}
    (hA : CompleteArc (L := Point K) A) (hcard : A.card ≤ Fintype.card K) :
    ∃ B : Finset (Point K),
      CompleteOutside (L := Point K) B C.points ∧ B.card = A.card := by
  obtain ⟨g, hdisj⟩ := exists_projective_map_disjoint_conic C A hcard
  let B := A.map (ProjectiveCap.Projective.mapEquiv g).toEmbedding
  refine ⟨B, completeOutside_of_completeArc_of_disjoint
    (completeArc_map_projective g hA) hdisj, ?_⟩
  simp [B]

end ProjectiveAction

section Minimum

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

noncomputable local instance instFintypePointMinimum : Fintype (Point K) :=
  Fintype.ofFinite (Point K)

noncomputable local instance instDecidableEqPointMinimum : DecidableEq (Point K) :=
  Classical.decEq (Point K)

/-- The smallest ordinary complete arc in `PG(2,K)`, conventionally denoted `t₂(2,q)`. -/
noncomputable def t2 : ℕ := rho (L := Point K) ∅

/-- If `t₂(2,q) ≤ q`, then `ρ_C(q) ≤ t₂(2,q)`. -/
theorem rhoC_le_t2 (ht2 : t2 (K := K) ≤ Fintype.card K) :
    rhoC (K := K) ≤ t2 (K := K) := by
  obtain ⟨A, hA, hcard⟩ :=
    exists_completeOutside_card_eq_rho (L := Point K) (∅ : Finset (Point K))
  have hcard' : A.card = t2 (K := K) := by simpa [t2] using hcard
  obtain ⟨B, hB, hBcard⟩ := exists_completeOutside_conic_of_completeArc
    (NonsingularConic.standard (K := K)) hA (by simpa [hcard'] using ht2)
  calc
    rhoC (K := K) = rho (L := Point K) (NonsingularConic.standard (K := K)).points :=
      (NonsingularConic.rho_points_eq_rhoC _).symm
    _ ≤ B.card := rho_le_card (L := Point K) hB
    _ = t2 (K := K) := hBcard.trans hcard'

/-- A named, assumption-transparent form of the Kim--Vu small-complete-arc input
(J. H. Kim and V. H. Vu, *Small complete arcs in projective planes*, Combinatorica 23 (2003),
311--363). This is a hypothesis interface, not an axiom: it says that an ordinary complete arc of
size at most `b` has been supplied. -/
def KimVuBound (b : ℕ) : Prop :=
  ∃ A : Finset (Point K), CompleteArc (L := Point K) A ∧ A.card ≤ b

/-- The Kim--Vu input transfers directly to the conic problem whenever its bound is at most `q`. -/
theorem rhoC_le_of_kimVuBound {b : ℕ} (hKV : KimVuBound (K := K) b)
    (hbq : b ≤ Fintype.card K) : rhoC (K := K) ≤ b := by
  obtain ⟨A, hA, hAb⟩ := hKV
  obtain ⟨B, hB, hBcard⟩ := exists_completeOutside_conic_of_completeArc
    (NonsingularConic.standard (K := K)) hA (hAb.trans hbq)
  calc
    rhoC (K := K) = rho (L := Point K) (NonsingularConic.standard (K := K)).points :=
      (NonsingularConic.rho_points_eq_rhoC _).symm
    _ ≤ B.card := rho_le_card (L := Point K) hB
    _ = A.card := hBcard
    _ ≤ b := hAb

end Minimum

end Averaging
end RelativeConicArcs
