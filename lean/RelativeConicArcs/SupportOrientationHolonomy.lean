import RelativeConicArcs.SupportOrientationPentagon
import RelativeConicArcs.ClebschTwoGraph

/-!
# Triangle holonomy and switching reconstruction

The signs on triples of support axes are the holonomies of the signed
orbital matrix.  They are unchanged by lift switching and reverse when the
complementary orbital is chosen.  The four-point identity reconstructs the
whole switching class from a root gauge.  Pair balance is equivalent to the
golden conference equation and supplies the low-degree cancellations which
make the support cubic translation invariant.
-/

namespace RelativeConicArcs.SupportOrientationHolonomy

open Matrix
open scoped Matrix
open ClebschGoldenConference
open SupportOrientationPentagon
open ClebschTwoGraph

/-- The support sign is the triangle holonomy of the signed orbital matrix. -/
def supportSign (i j k : Fin 6) : ℤ :=
  fiberOddOrbitalMatrix i j * fiberOddOrbitalMatrix j k *
    fiberOddOrbitalMatrix k i

/-- Holonomy is exactly the triangle product. -/
theorem supportSign_eq_triangleProduct (i j k : Fin 6) :
    supportSign i j k = triangleSign fiberOddOrbitalMatrix i j k := by
  rfl

/-- Changing lifts does not change triangle holonomy. -/
theorem supportSign_switching_invariant (d : Fin 6 → ℤ)
    (hd : ∀ i, d i * d i = 1) (i j k : Fin 6) :
    triangleSign (switchMatrix d fiberOddOrbitalMatrix) i j k =
      supportSign i j k := by
  rw [triangleSign_switch d hd]
  rfl

/-- Complementary orbital exchange reverses every triangle sign. -/
theorem supportSign_complementary (i j k : Fin 6) :
    triangleSign (-fiberOddOrbitalMatrix) i j k = -supportSign i j k := by
  simp [triangleSign, supportSign]

theorem fiberOddOrbitalMatrix_transpose :
    fiberOddOrbitalMatrix.transpose = fiberOddOrbitalMatrix := by
  ext i j
  fin_cases i <;> fin_cases j <;> decide

@[simp] theorem fiberOddOrbitalMatrix_apply_self (i : Fin 6) :
    fiberOddOrbitalMatrix i i = 0 := by
  fin_cases i <;> decide

theorem fiberOddOrbitalMatrix_apply_sq (i j : Fin 6) (hij : i ≠ j) :
    fiberOddOrbitalMatrix i j * fiberOddOrbitalMatrix i j = 1 := by
  fin_cases i <;> fin_cases j <;>
    simp_all [fiberOddOrbitalMatrix, conferenceMatrix]

/-- The four triangle holonomies on four distinct support axes multiply to
one. -/
theorem fourPoint_twoGraph_identity (i j k l : Fin 6)
    (hij : i ≠ j) (hik : i ≠ k) (hil : i ≠ l)
    (hjk : j ≠ k) (hjl : j ≠ l) (hkl : k ≠ l) :
    supportSign i j k * supportSign i j l *
      supportSign i k l * supportSign j k l = 1 := by
  have hsymm : fiberOddOrbitalMatrix.transpose = fiberOddOrbitalMatrix := by
    exact fiberOddOrbitalMatrix_transpose
  have hedge : ∀ a b, a ≠ b →
      fiberOddOrbitalMatrix a b * fiberOddOrbitalMatrix a b = 1 := by
    exact fiberOddOrbitalMatrix_apply_sq
  simpa [supportSign_eq_triangleProduct] using
    triangleSign_four_point fiberOddOrbitalMatrix hsymm hedge
      i j k l hij hik hil hjk hjl hkl

/-- Root-gauge reconstruction proves uniqueness of the signed matrix up to
diagonal switching from its triangle holonomies. -/
theorem supportSign_reconstructs_switchingClass :
    switchMatrix (rootSwitchSign fiberOddOrbitalMatrix)
        fiberOddOrbitalMatrix =
      reconstructedMatrix (triangleSign fiberOddOrbitalMatrix) := by
  exact switch_eq_reconstructed_triangleSign fiberOddOrbitalMatrix
    fiberOddOrbitalMatrix_transpose
    fiberOddOrbitalMatrix_apply_self
    fiberOddOrbitalMatrix_apply_sq

/-- Positive neighbors in the root-gauge graph on the five non-root axes. -/
def positivePentagonNeighbors (i : Fin 5) : Finset (Fin 5) :=
  Finset.univ.filter fun j =>
    i ≠ j ∧ rootGaugeMatrix i.succ j.succ = 1

/-- Pair balance leaves two positive edges at every non-root vertex; together
with connectivity this is the unique five-cycle switching class. -/
theorem positivePentagonNeighbors_card_two (i : Fin 5) :
    (positivePentagonNeighbors i).card = 2 := by
  fin_cases i <;> decide

/-- For a symmetric signed order-six matrix, pair balance is equivalent to
the golden square equation. -/
theorem pairBalance_iff_sq_five
    {R : Type*} [CommRing R] (B : Matrix (Fin 6) (Fin 6) R)
    (hsymm : B.transpose = B) (hdiag : ∀ i, B i i = 0)
    (hedge : ∀ i j, i ≠ j → B i j * B i j = 1) :
    (∀ i j, i ≠ j → pairTriangleSum B i j = 0) ↔
      B * B = (5 : R) • (1 : Matrix (Fin 6) (Fin 6) R) := by
  constructor
  · exact sq_eq_five_of_pairTriangleSum_eq_zero B hsymm hdiag hedge
  · intro hsq i j hij
    exact pairTriangleSum_eq_zero B 5 hsymm hsq i j hij

/-- Degree-two signed moment through an ordered pair. -/
def supportMomentTwo (i j : Fin 6) : ℤ := ∑ k, supportSign i j k

/-- Degree-one signed moment through one support axis. -/
def supportMomentOne (i : Fin 6) : ℤ := ∑ j, supportMomentTwo i j

/-- Degree-zero total signed moment. -/
def supportMomentZero : ℤ := ∑ i, supportMomentOne i

theorem supportMomentTwo_eq_zero (i j : Fin 6) :
    supportMomentTwo i j = 0 := by
  by_cases hij : i = j
  · subst j
    simp [supportMomentTwo, supportSign, fiberOddOrbitalMatrix_apply_self]
  · simpa [supportMomentTwo, supportSign_eq_triangleProduct,
      pairTriangleSum] using
      pairTriangleSum_eq_zero fiberOddOrbitalMatrix 5
        fiberOddOrbitalMatrix_transpose signedOrbitalMatrix_sq i j hij

theorem supportMomentOne_eq_zero (i : Fin 6) : supportMomentOne i = 0 := by
  simp [supportMomentOne, supportMomentTwo_eq_zero]

theorem supportMomentZero_eq_zero : supportMomentZero = 0 := by
  simp [supportMomentZero, supportMomentOne_eq_zero]

/-- The support cubic in the normalized switching class. -/
def supportCubic (x : Fin 6 → ℤ) : ℤ :=
  triangleCubic fiberOddOrbitalMatrix x

/-- Its degree-zero, degree-one, and degree-two translation terms vanish;
equivalently the cubic is invariant under the all-ones translation. -/
theorem supportCubic_translation_invariant (x : Fin 6 → ℤ) (u : ℤ) :
    supportCubic (fun i => x i + u) = supportCubic x := by
  simp [supportCubic, triangleCubic, cubicTerm,
    triangleSign, fiberOddOrbitalMatrix, conferenceMatrix]
  ring

#print axioms supportSign_eq_triangleProduct
#print axioms supportSign_switching_invariant
#print axioms fiberOddOrbitalMatrix_transpose
#print axioms fourPoint_twoGraph_identity
#print axioms supportSign_reconstructs_switchingClass
#print axioms positivePentagonNeighbors_card_two
#print axioms pairBalance_iff_sq_five
#print axioms supportMomentTwo_eq_zero
#print axioms supportMomentOne_eq_zero
#print axioms supportMomentZero_eq_zero
#print axioms supportCubic_translation_invariant

end RelativeConicArcs.SupportOrientationHolonomy
