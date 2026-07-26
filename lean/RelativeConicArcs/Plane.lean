import Mathlib.Combinatorics.Configuration

/-!
# Finite projective-plane vocabulary

This module supplies the incidence vocabulary used for finite projective planes.  It builds
on Mathlib's `Configuration.ProjectivePlane` rather than defining a second projective-plane
structure.
-/

namespace RelativeConicArcs

open Configuration

variable {P L : Type*} [Membership P L]

/-- Three points are collinear when they lie on a common incidence line. -/
def Collinear (a b c : P) : Prop :=
  ∃ l : L, a ∈ l ∧ b ∈ l ∧ c ∈ l

theorem collinear_rotate {a b c : P} :
    Collinear (L := L) a b c ↔ Collinear (L := L) b c a := by
  simp only [Collinear]
  aesop

theorem collinear_swap_left {a b c : P} :
    Collinear (L := L) a b c ↔ Collinear (L := L) b a c := by
  simp only [Collinear]
  aesop

/-- The order supplied by Mathlib's abstract projective-plane structure. -/
noncomputable abbrev PlaneOrder (P L : Type*) [Membership P L]
    [Configuration.ProjectivePlane P L] : ℕ :=
  Configuration.ProjectivePlane.order P L

/-- An abstract projective plane has the usual `q²+q+1` point count. -/
theorem card_points [Configuration.ProjectivePlane P L] [Fintype P] [Finite L] :
    Fintype.card P = PlaneOrder P L ^ 2 + PlaneOrder P L + 1 :=
  Configuration.ProjectivePlane.card_points P L

/-- Every line of an abstract projective plane of order `q` has `q+1` points. -/
theorem card_points_on_line [Configuration.ProjectivePlane P L] [Finite P] [Finite L]
    (l : L) :
    Nat.card {p : P // p ∈ l} = PlaneOrder P L + 1 := by
  exact Configuration.ProjectivePlane.pointCount_eq P l

end RelativeConicArcs
