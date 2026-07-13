import RelativeConicArcs.Plane
import Mathlib.Data.Finset.Powerset

/-!
# Arcs, secants, and prescribed holes

The definitions in this file are incidence-theoretic.  They therefore apply to every finite
projective plane represented by Mathlib's `Configuration.ProjectivePlane`, not only to a
Desarguesian coordinate plane.
-/

namespace RelativeConicArcs

open Finset

variable {P L : Type*} [Membership P L]

/-- An arc is a finite point set with no three distinct collinear points. -/
def Arc (A : Finset P) : Prop :=
  ∀ ⦃a b c : P⦄,
    a ∈ A → b ∈ A → c ∈ A →
      a ≠ b → a ≠ c → b ≠ c → ¬ Collinear (L := L) a b c

@[simp] theorem arc_empty : Arc (L := L) (∅ : Finset P) := by
  classical
  intro a _b _c ha
  simp at ha

theorem arc_mono {A B : Finset P} (hAB : A ⊆ B) (hB : Arc (L := L) B) :
    Arc (L := L) A := by
  intro a b c ha hb hc
  exact hB (hAB ha) (hAB hb) (hAB hc)

/-- A secant of `A` is a line containing two distinct points of `A`. -/
def Secant (A : Finset P) (l : L) : Prop :=
  ∃ a ∈ A, ∃ b ∈ A, a ≠ b ∧ a ∈ l ∧ b ∈ l

section Finite

variable [Fintype P] [Fintype L] [DecidableEq P]

/-- The finite set of secants determined by `A`. -/
noncomputable def secants (A : Finset P) : Finset L := by
  classical
  exact Finset.univ.filter (Secant A)

omit [Fintype P] [DecidableEq P] in
@[simp] theorem mem_secants {A : Finset P} {l : L} :
    l ∈ secants A ↔ Secant A l := by
  classical
  simp [secants]

/-- The secant index `r_A(x)`: the number of secants of `A` through `x`. -/
noncomputable def pointIndex (A : Finset P) (x : P) : ℕ := by
  classical
  exact ((secants (L := L) A).filter fun l => x ∈ l).card

/-- A point is covered by `A` when it lies on at least one secant of `A`. -/
def Covered (A : Finset P) (x : P) : Prop :=
  0 < pointIndex (L := L) A x

omit [Fintype P] [DecidableEq P] in
theorem covered_iff_exists_secant {A : Finset P} {x : P} :
    Covered (L := L) A x ↔ ∃ l : L, Secant A l ∧ x ∈ l := by
  classical
  simp only [Covered, pointIndex, Finset.card_pos]
  constructor
  · rintro ⟨l, hl⟩
    exact ⟨l, mem_secants.mp (Finset.mem_filter.mp hl).1, (Finset.mem_filter.mp hl).2⟩
  · rintro ⟨l, hl, hxl⟩
    exact ⟨l, Finset.mem_filter.mpr ⟨mem_secants.mpr hl, hxl⟩⟩

omit [Fintype P] [DecidableEq P] in
theorem covered_of_collinear_pair {A : Finset P} {x a b : P}
    (ha : a ∈ A) (hb : b ∈ A) (hab : a ≠ b)
    (hcol : Collinear (L := L) x a b) : Covered (L := L) A x := by
  obtain ⟨l, hxl, hal, hbl⟩ := hcol
  exact covered_iff_exists_secant.mpr
    ⟨l, ⟨a, ha, b, hb, hab, hal, hbl⟩, hxl⟩

omit [Fintype P] in
/-- Adding an uncovered point to an arc preserves the arc condition. -/
theorem arc_insert_of_not_covered {A : Finset P} {x : P}
    (hA : Arc (L := L) A) (hx : ¬ Covered (L := L) A x) :
    Arc (L := L) (insert x A) := by
  classical
  intro a b c ha hb hc hab hac hbc hcol
  simp only [Finset.mem_insert] at ha hb hc
  rcases ha with rfl | ha
  · rcases hb with rfl | hb
    · exact hab rfl
    · rcases hc with rfl | hc
      · exact hac rfl
      · exact hx (covered_of_collinear_pair hb hc hbc hcol)
  · rcases hb with rfl | hb
    · rcases hc with rfl | hc
      · exact hbc rfl
      · exact hx (covered_of_collinear_pair ha hc hac
          ((collinear_swap_left (L := L)).mp hcol))
    · rcases hc with rfl | hc
      · exact hx (covered_of_collinear_pair ha hb hab
          ((collinear_rotate (L := L)).mp ((collinear_rotate (L := L)).mp hcol)))
      · exact hA ha hb hc hab hac hbc hcol

/-- Points at which coverage is required when `H` is the prescribed hole set. -/
noncomputable def requiredLocus (A H : Finset P) : Finset P := by
  classical
  exact Finset.univ \ (A ∪ H)

/-- Covered points in the required locus. -/
noncomputable def coveredRequired (A H : Finset P) : Finset P := by
  classical
  exact (requiredLocus A H).filter (Covered (L := L) A)

/-- The uncovered required locus `U_H(A)`. -/
noncomputable def uncovered (A H : Finset P) : Finset P := by
  classical
  exact (requiredLocus A H).filter fun x => ¬ Covered (L := L) A x

/-- `A` is complete outside the prescribed hole set `H`. -/
def CompleteOutside (A H : Finset P) : Prop :=
  Arc (L := L) A ∧ Disjoint A H ∧
    ∀ x, x ∉ A → x ∉ H → Covered (L := L) A x

/-- Arc positions disjoint from the prescribed hole set. -/
def Admissible (A H : Finset P) : Prop :=
  Arc (L := L) A ∧ Disjoint A H

/-- The finite family of all admissible positions outside `H`. -/
noncomputable def admissiblePositions (H : Finset P) : Finset (Finset P) := by
  classical
  exact Finset.univ.powerset.filter fun A => Admissible (L := L) A H

omit [Fintype L] [DecidableEq P] in
@[simp] theorem mem_admissiblePositions {A H : Finset P} :
    A ∈ admissiblePositions (L := L) H ↔ Admissible (L := L) A H := by
  classical
  simp [admissiblePositions]

/-- Every prescribed hole set admits an arc that is complete outside it. -/
theorem exists_completeOutside
    [Configuration.ProjectivePlane P L] (H : Finset P) :
    ∃ A : Finset P, CompleteOutside (L := L) A H := by
  classical
  have hne : (admissiblePositions (L := L) H).Nonempty := by
    refine ⟨∅, ?_⟩
    simp [Admissible]
  obtain ⟨A, hApos, hmax⟩ :=
    Finset.exists_max_image (admissiblePositions (L := L) H) Finset.card hne
  have hA : Admissible (L := L) A H := mem_admissiblePositions.mp hApos
  refine ⟨A, hA.1, hA.2, ?_⟩
  intro x hxA hxH
  by_contra hxcover
  have hinsArc : Arc (L := L) (insert x A) :=
    arc_insert_of_not_covered hA.1 hxcover
  have hinsDisj : Disjoint (insert x A) H := by
    simpa [Finset.disjoint_insert_left, hxH] using hA.2
  have hinsPos : insert x A ∈ admissiblePositions (L := L) H :=
    mem_admissiblePositions.mpr ⟨hinsArc, hinsDisj⟩
  have hcard := hmax (insert x A) hinsPos
  simp [hxA] at hcard

theorem completeOutside_iff_uncovered_eq_empty {A H : Finset P} :
    CompleteOutside (L := L) A H ↔
      Arc (L := L) A ∧ Disjoint A H ∧ uncovered (L := L) A H = ∅ := by
  classical
  constructor
  · rintro ⟨hArc, hdisj, hcover⟩
    refine ⟨hArc, hdisj, Finset.eq_empty_iff_forall_notMem.mpr ?_⟩
    intro x hx
    simp only [uncovered, Finset.mem_filter, requiredLocus, Finset.mem_sdiff,
      Finset.mem_univ, Finset.mem_union, true_and, not_or] at hx
    exact hx.2 (hcover x hx.1.1 hx.1.2)
  · rintro ⟨hArc, hdisj, hempty⟩
    refine ⟨hArc, hdisj, ?_⟩
    intro x hxA hxH
    have hx : x ∉ uncovered (L := L) A H := by simp [hempty]
    simpa [uncovered, requiredLocus, hxA, hxH] using hx

/-- The relative-completeness parameter for a prescribed hole set.  Later modules prove the
defining set is nonempty and identify this infimum with an attained minimum. -/
noncomputable def rho (H : Finset P) : ℕ :=
  sInf {k : ℕ | ∃ A : Finset P, CompleteOutside (L := L) A H ∧ A.card = k}

/-- The relative-completeness parameter is attained. -/
theorem exists_completeOutside_card_eq_rho
    [Configuration.ProjectivePlane P L] (H : Finset P) :
    ∃ A : Finset P, CompleteOutside (L := L) A H ∧ A.card = rho (L := L) H := by
  obtain ⟨A, hA⟩ := exists_completeOutside (L := L) H
  have hne : {k : ℕ | ∃ B : Finset P,
      CompleteOutside (L := L) B H ∧ B.card = k}.Nonempty :=
    ⟨A.card, A, hA, rfl⟩
  rw [rho]
  exact Nat.sInf_mem hne

omit [Fintype P] [DecidableEq P] in
theorem rho_le_card {A H : Finset P} (hA : CompleteOutside (L := L) A H) :
    rho (L := L) H ≤ A.card := by
  apply Nat.sInf_le
  exact ⟨A, hA, rfl⟩

end Finite

end RelativeConicArcs
