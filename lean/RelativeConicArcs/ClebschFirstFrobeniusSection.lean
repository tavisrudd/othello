import Mathlib.Tactic

/-!
# The four-weight first Frobenius section

Let `σ` be a ring endomorphism.  On the free rank-four module with ordered basis `A,C,B,D`, define
the upper-root action by

* `A ↦ A`,
* `C ↦ C + tA`,
* `B ↦ B + σ(t)A`,
* `D ↦ D + tB + σ(t)C + tσ(t)A`.

This is the tensor-product action of a two-dimensional root representation and its `σ`-twist.
The action law is proved directly from additivity and multiplicativity of `σ`.  The vector `C-B`
has defect `(t-σ(t))A`, which is the four-weight mechanism used by the opposite-parity argument.

This module establishes the action table itself.  Identifying a concrete finite-group Hom space
with a submodule carrying this table requires the separate root-defect and representation-theoretic
arguments.
-/

namespace RelativeConicArcs.ClebschFirstFrobeniusSection

variable {R : Type*} [CommRing R]

/-- The free four-coordinate carrier in basis order `A,C,B,D`. -/
abbrev Carrier (R : Type*) [CommRing R] := Fin 4 → R

/-- The highest-weight basis vector `A`. -/
def A : Carrier R := ![1, 0, 0, 0]

/-- The weight basis vector `C`. -/
def C : Carrier R := ![0, 1, 0, 0]

/-- The weight basis vector `B`. -/
def B : Carrier R := ![0, 0, 1, 0]

/-- The lowest-weight basis vector `D`. -/
def D : Carrier R := ![0, 0, 0, 1]

/-- Weyl action in the basis `A,C,B,D`: `A ↦ D`, `C ↦ -B`, `B ↦ -C`, `D ↦ A`. -/
def weyl (v : Carrier R) : Carrier R := ![v 3, -v 2, -v 1, v 0]

/-- The chosen Weyl action is an involution on the four-weight section. -/
theorem weyl_involutive : Function.Involutive (weyl : Carrier R → Carrier R) := by
  intro v
  ext i
  fin_cases i <;> simp [weyl]

/-- Weyl sends the highest vector to the lowest vector. -/
theorem weyl_A : weyl (A : Carrier R) = D := by
  ext i
  fin_cases i <;> simp [weyl, A, D]

/-- Weyl exchanges the two middle vectors with the signs used in the root-action table. -/
theorem weyl_C : weyl (C : Carrier R) = -B := by
  ext i
  fin_cases i <;> simp [weyl, B, C]

/-- Weyl exchanges the two middle vectors with the signs used in the root-action table. -/
theorem weyl_B : weyl (B : Carrier R) = -C := by
  ext i
  fin_cases i <;> simp [weyl, B, C]

/-- Weyl sends the lowest vector back to the highest vector. -/
theorem weyl_D : weyl (D : Carrier R) = A := by
  ext i
  fin_cases i <;> simp [weyl, A, D]

/-- Upper-root action on coordinates in the ordered basis `A,C,B,D`. -/
def upper (σ : R →+* R) (t : R) (v : Carrier R) : Carrier R :=
  ![v 0 + t * v 1 + σ t * v 2 + t * σ t * v 3,
    v 1 + σ t * v 3,
    v 2 + t * v 3,
    v 3]

/-- The opposite-root action obtained by Weyl conjugation. -/
def lower (σ : R →+* R) (t : R) (v : Carrier R) : Carrier R :=
  weyl (upper σ (-t) (weyl v))

/-- The zero root parameter acts as the identity. -/
theorem upper_zero (σ : R →+* R) (v : Carrier R) : upper σ 0 v = v := by
  ext i
  fin_cases i <;> simp [upper]

/-- Root parameters add: acting by `u` and then `t` is acting by `t+u`. -/
theorem upper_add (σ : R →+* R) (t u : R) (v : Carrier R) :
    upper σ t (upper σ u v) = upper σ (t + u) v := by
  ext i
  fin_cases i <;> simp [upper, map_add] <;> ring

/-- Opposite-root parameters add as well. -/
theorem lower_add (σ : R →+* R) (t u : R) (v : Carrier R) :
    lower σ t (lower σ u v) = lower σ (t + u) v := by
  unfold lower
  rw [weyl_involutive]
  rw [upper_add]
  congr 2
  ring

/-- The opposite-root action on `A` contains all four weights. -/
theorem lower_A (σ : R →+* R) (t : R) :
    lower σ t A = A + t • C + σ t • B + (t * σ t) • D := by
  ext i
  fin_cases i <;> simp [lower, upper, weyl, A, B, C, D, map_neg]

/-- The opposite root sends `C` to `C+σ(t)D`. -/
theorem lower_C (σ : R →+* R) (t : R) : lower σ t C = C + σ t • D := by
  ext i
  fin_cases i <;> simp [lower, upper, weyl, C, D, map_neg]

/-- The opposite root sends `B` to `B+tD`. -/
theorem lower_B (σ : R →+* R) (t : R) : lower σ t B = B + t • D := by
  ext i
  fin_cases i <;> simp [lower, upper, weyl, B, D, map_neg]

/-- The opposite root fixes `D`. -/
theorem lower_D (σ : R →+* R) (t : R) : lower σ t D = D := by
  ext i
  fin_cases i <;> simp [lower, upper, weyl, D, map_neg]

/-- The upper root fixes `A`. -/
theorem upper_A (σ : R →+* R) (t : R) : upper σ t A = A := by
  ext i
  fin_cases i <;> simp [upper, A]

/-- The upper root sends `C` to `C+tA`. -/
theorem upper_C (σ : R →+* R) (t : R) : upper σ t C = C + t • A := by
  ext i
  fin_cases i <;> simp [upper, A, C]

/-- The upper root sends `B` to `B+σ(t)A`. -/
theorem upper_B (σ : R →+* R) (t : R) : upper σ t B = B + σ t • A := by
  ext i
  fin_cases i <;> simp [upper, A, B]

/-- The upper root action on the lowest vector contains the mixed coefficient `tσ(t)`. -/
theorem upper_D (σ : R →+* R) (t : R) :
    upper σ t D = D + t • B + σ t • C + (t * σ t) • A := by
  ext i
  fin_cases i <;> simp [upper, A, B, C, D]

/-- The vector `C-B` has exactly the first-Frobenius defect `(t-σ(t))A`. -/
theorem upper_C_sub_B (σ : R →+* R) (t : R) :
    upper σ t (C - B) = (C - B) + (t - σ t) • A := by
  ext i
  fin_cases i <;> (simp [upper, A, B, C] <;> ring)

end RelativeConicArcs.ClebschFirstFrobeniusSection
