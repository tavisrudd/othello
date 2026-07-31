import RelativeConicArcs.ClebschGoldenConference

/-!
# Reconstruction from an oriented two-graph

Triangle products determine a signed complete graph up to diagonal switching.
This module gives the root-gauge construction on six labels.  Edges through
the root are set to one; every other edge is the triangle sign through the
root.  The four-point identity then recovers all remaining triangle signs.

All arguments are symbolic over a commutative ring.  No finite evaluation or
external axiom is used.
-/

namespace RelativeConicArcs
namespace ClebschTwoGraph

open Matrix
open scoped Matrix
open ClebschGoldenConference

/-- The root gauge of a triangle tensor: diagonal entries vanish, edges
through label zero are one, and the edge `i-j` is `c 0 i j`. -/
def reconstructedMatrix {R : Type*} [CommRing R]
    (c : Fin 6 → Fin 6 → Fin 6 → R) : Matrix (Fin 6) (Fin 6) R :=
  fun i j => if i = j then 0 else if i = 0 ∨ j = 0 then 1 else c 0 i j

/-- The diagonal signs that put a signed symmetric matrix into root gauge. -/
def rootSwitchSign {R : Type*} [CommRing R]
    (C : Matrix (Fin 6) (Fin 6) R) (i : Fin 6) : R :=
  if i = 0 then 1 else C 0 i

/-- Root-gauge switching signs square to one when all off-diagonal entries do. -/
theorem rootSwitchSign_sq {R : Type*} [CommRing R]
    (C : Matrix (Fin 6) (Fin 6) R)
    (hsq : ∀ i j, i ≠ j → C i j * C i j = 1) (i : Fin 6) :
    rootSwitchSign C i * rootSwitchSign C i = 1 := by
  by_cases hi : i = 0
  · simp [rootSwitchSign, hi]
  · simpa [rootSwitchSign, hi] using hsq 0 i (Ne.symm hi)

/-- Switching a symmetric signed matrix into root gauge gives exactly the
matrix reconstructed from its triangle tensor.  This is the uniqueness-up-to-
switching statement for the two-graph presentation. -/
theorem switch_eq_reconstructed_triangleSign {R : Type*} [CommRing R]
    (C : Matrix (Fin 6) (Fin 6) R)
    (hsymm : C.transpose = C)
    (hdiag : ∀ i, C i i = 0)
    (hsq : ∀ i j, i ≠ j → C i j * C i j = 1) :
    switchMatrix (rootSwitchSign C) C =
      reconstructedMatrix (triangleSign C) := by
  have hsymm_apply : ∀ i j, C i j = C j i := by
    intro i j
    simpa [Matrix.transpose_apply] using
      congrArg (fun M => M j i) hsymm
  ext i j
  by_cases hij : i = j
  · subst j
    simp [switchMatrix, reconstructedMatrix, hdiag]
  · by_cases hi : i = 0
    · subst i
      simp [switchMatrix, rootSwitchSign, reconstructedMatrix, hij,
        Ne.symm hij, hsq]
    · by_cases hj : j = 0
      · subst j
        simp [switchMatrix, rootSwitchSign, reconstructedMatrix, hi,
          hsq, hsymm_apply]
      · simp only [switchMatrix, rootSwitchSign, hi, hj, if_false,
          reconstructedMatrix, hij]
        rw [if_neg (by simp)]
        simp only [triangleSign]
        rw [hsymm_apply j 0]

/-- Symmetry of the root slice makes the reconstructed matrix symmetric. -/
theorem reconstructedMatrix_transpose {R : Type*} [CommRing R]
    (c : Fin 6 → Fin 6 → Fin 6 → R)
    (hsymm : ∀ i j, c 0 i j = c 0 j i) :
    (reconstructedMatrix c).transpose = reconstructedMatrix c := by
  ext i j
  by_cases hij : i = j
  · subst j
    simp [reconstructedMatrix]
  · by_cases hi : i = 0
    · subst i
      simp [reconstructedMatrix, hij, Ne.symm hij]
    · by_cases hj : j = 0
      · subst j
        simp [reconstructedMatrix, hi, Ne.symm hi]
      · simp [reconstructedMatrix, hij, Ne.symm hij, hi, hj, hsymm]

/-- A triangle through the root has the prescribed sign. -/
theorem reconstructed_triangle_root {R : Type*} [CommRing R]
    (c : Fin 6 → Fin 6 → Fin 6 → R)
    (i j : Fin 6) (hi : i ≠ 0) (hj : j ≠ 0) (hij : i ≠ j) :
    triangleSign (reconstructedMatrix c) 0 i j = c 0 i j := by
  simp [triangleSign, reconstructedMatrix, hi, hj, hij, Ne.symm hi]

/-- Away from the root, the four-point identity reconstructs the prescribed
triangle sign. -/
theorem reconstructed_triangle_nonroot {R : Type*} [CommRing R]
    (c : Fin 6 → Fin 6 → Fin 6 → R)
    (i j k : Fin 6)
    (hi : i ≠ 0) (hj : j ≠ 0) (hk : k ≠ 0)
    (hij : i ≠ j) (hjk : j ≠ k) (hki : k ≠ i)
    (hfour : c 0 i j * c 0 j k * c 0 k i * c i j k = 1)
    (hsq : c i j k * c i j k = 1) :
    triangleSign (reconstructedMatrix c) i j k = c i j k := by
  have hprod : c 0 i j * c 0 j k * c 0 k i = c i j k := by
    calc
      c 0 i j * c 0 j k * c 0 k i =
          (c 0 i j * c 0 j k * c 0 k i) * (c i j k * c i j k) := by
            rw [hsq, mul_one]
      _ = (c 0 i j * c 0 j k * c 0 k i * c i j k) * c i j k := by ring
      _ = c i j k := by rw [hfour, one_mul]
  simpa [triangleSign, reconstructedMatrix, hi, hj, hk, hij, hjk, hki,
    Ne.symm hij, Ne.symm hjk, Ne.symm hki] using hprod

end ClebschTwoGraph
end RelativeConicArcs
