import RelativeConicArcs.PaperIOrientationCover
import RelativeConicArcs.MarkedClebschBridge
import RelativeConicArcs.ClebschTwoGraph
import Mathlib.GroupTheory.SpecificGroups.Alternating.Simple

/-!
# The fibre-odd signed pentagon and its golden square

The two inverse-stable five-valent orbitals of the antipodal cover give,
after choosing one lift above each of the six axes, a symmetric signed
matrix.  This packet fixes the root gauge used in Paper I.  A different
choice of lifts is diagonal switching, while exchanging the two orbitals
negates the matrix.

The last theorem works on the full twelve-point cover.  Its proof separates
the two points in every fibre: equal sheet signs and opposite sheet signs are
the two cancellation cases in the paper.
-/

namespace RelativeConicArcs.PaperIOrientationPentagon

open Matrix
open scoped Matrix
open ClebschGoldenConference
open MarkedClebschBridge
open ClebschTwoGraph
open PaperIOrientationCover

/-- Explicit representatives for the base axis and the five first-orbital
neighbors above all other axes. -/
def rawAxisRepresentative : Fin 6 → A5 :=
  Fin.cases 1 fun i : Fin 5 =>
    rotationA5 (i.val : Letter) * firstOrbitalRepresentative

/-- Their oriented support labels in the explicit `A5/C5` transversal. -/
def rawAxisLift (i : Fin 6) : OrientedSupport :=
  (i, false)

/-- Adjacency matrix of one O1 orbital on the explicit representatives. -/
def rawOrbitalMatrix (orbital : FiveOrbital) : Matrix (Fin 6) (Fin 6) ℤ :=
  fun i j => if (rawAxisRepresentative i)⁻¹ * rawAxisRepresentative j ∈
    orbital.elements then 1 else 0

/-- Difference of the two O1 orbital adjacency matrices. -/
def rawFiberOddOrbitalMatrix : Matrix (Fin 6) (Fin 6) ℤ :=
  rawOrbitalMatrix .first - rawOrbitalMatrix .second

/-- Exchanging the two O1 orbitals negates their adjacency difference. -/
theorem rawOrbitalExchange_eq_neg :
    rawOrbitalMatrix .second - rawOrbitalMatrix .first =
      -rawFiberOddOrbitalMatrix := by
  rw [rawFiberOddOrbitalMatrix, neg_sub]

/-- Membership of the chosen representative difference is an actual O1
homogeneous-orbital incidence. -/
theorem rawAxisRepresentative_mem_implies_orbital
    (orbital : FiveOrbital) (i j : Fin 6)
    (h : (rawAxisRepresentative i)⁻¹ * rawAxisRepresentative j ∈
      orbital.elements) :
    InFiveOrbital orbital (rawAxisLift i) (rawAxisLift j) := by
  simpa [InFiveOrbital, rawAxisLift, supportRepresentative,
    axisRepresentative, rawAxisRepresentative] using h

/-- Row permutation from the explicit cover representatives to the repository
conference order. -/
def coverAxisOrder : Fin 6 ≃ Fin 6 where
  toFun := ![0, 1, 2, 4, 5, 3]
  invFun := ![0, 1, 2, 5, 3, 4]
  left_inv := by decide
  right_inv := by decide

/-- Lift-switching signs for the cover-to-conference normalization. -/
def coverAxisSign : Fin 6 → ℤ := ![1, 1, 1, -1, -1, 1]

/-- The signed orbital matrix in the normalized lift gauge. -/
def fiberOddOrbitalMatrix : Matrix (Fin 6) (Fin 6) ℤ := conferenceMatrix

/-- The signed matrix is exactly the difference of O1's two orbital adjacency
operators, after the displayed axis permutation and lift switching. -/
theorem rawFiberOddOrbitalMatrix_eq_conference_transport (i j : Fin 6) :
    rawFiberOddOrbitalMatrix i j = coverAxisSign i *
      fiberOddOrbitalMatrix (coverAxisOrder i) (coverAxisOrder j) *
        coverAxisSign j := by
  fin_cases i <;> fin_cases j <;> decide

/-- Changing the six chosen lifts performs diagonal switching. -/
theorem liftChange_eq_diagonalSwitch (d : Fin 6 → ℤ)
    (_hd : ∀ i, d i * d i = 1) :
    switchMatrix d fiberOddOrbitalMatrix =
      fun i j => d i * fiberOddOrbitalMatrix i j * d j := by
  rfl

/-- The normalized matrix after exchanging the two five-valent orbitals. -/
def exchangedFiberOddOrbitalMatrix : Matrix (Fin 6) (Fin 6) ℤ :=
  -fiberOddOrbitalMatrix

/-- Exchanging the two five-valent orbitals negates the signed matrix. -/
theorem orbitalExchange_eq_neg :
    exchangedFiberOddOrbitalMatrix = -fiberOddOrbitalMatrix := rfl

/-- The normalized root gauge, in which every edge from axis zero is `+1`. -/
def rootGaugeMatrix : Matrix (Fin 6) (Fin 6) ℤ :=
  switchMatrix (rootSwitchSign fiberOddOrbitalMatrix) fiberOddOrbitalMatrix

/-- Successor in the positive pentagon on the five axes other than the root.
The cycle is `(1,4,3,2,5)` in the six-axis numbering. -/
def pentagonNext : Fin 5 → Fin 5 := ![3, 4, 1, 2, 0]

def IsPentagonSide (i j : Fin 5) : Prop :=
  j = pentagonNext i ∨ i = pentagonNext j

instance (i j : Fin 5) : Decidable (IsPentagonSide i j) := by
  unfold IsPentagonSide
  infer_instance

/-- The displayed positive side graph is connected: iterating its successor
from one vertex visits all five vertices. -/
theorem pentagonNext_orbit_surjective : Function.Surjective
    (fun n : Fin 5 => (pentagonNext^[n.val]) 0) := by
  decide

/-- `A5` has no nontrivial sign quotient.  This is the group-theoretic
obstruction which rules out the equal-sign disconnected alternatives. -/
theorem A5_no_sign_quotient (f : PaperIOrientationCover.A5 →* ℤˣ) : f = 1 := by
  have hfive : 5 ≤ Nat.card PaperIOrientationCover.Letter := by
    rw [Nat.card_eq_fintype_card]
    decide
  letI : IsSimpleGroup PaperIOrientationCover.A5 :=
    alternatingGroup.isSimpleGroup (α := PaperIOrientationCover.Letter) hfive
  rcases (inferInstance : f.ker.Normal).eq_bot_or_eq_top with hker | hker
  · have hinj : Function.Injective f := (MonoidHom.ker_eq_bot_iff f).mp hker
    have hcard := Fintype.card_le_of_injective f hinj
    have hA5 : Fintype.card PaperIOrientationCover.A5 = 60 := by
      rw [card_alternatingGroup]
      norm_num
    rw [hA5] at hcard
    norm_num at hcard
  · apply MonoidHom.ext
    intro g
    have hg : g ∈ f.ker := by rw [hker]; trivial
    exact f.mem_ker.mp hg

/-- In root gauge the five remaining axes form a pentagon: side and diagonal
edges have opposite signs.  This is the normalized signed-pentagon conclusion
of the connectivity/no-index-two-quotient argument. -/
theorem normalized_pentagon_side_diagonal_opposite :
    (∀ i : Fin 5, rootGaugeMatrix 0 i.succ = 1) ∧
    (∀ i j : Fin 5, i ≠ j →
      rootGaugeMatrix i.succ j.succ = if IsPentagonSide i j then 1 else -1) := by
  decide

/-- The signed orbital matrix is a golden conference matrix. -/
theorem signedOrbitalMatrix_sq :
    fiberOddOrbitalMatrix * fiberOddOrbitalMatrix =
      5 • (1 : Matrix (Fin 6) (Fin 6) ℤ) := by
  ext i j
  fin_cases i <;> fin_cases j <;> decide

/-- A label for the two lifts above each of the six support axes. -/
abbrev OrientedAxis := Fin 6 × Bool

/-- The sign of a chosen oriented lift. -/
def liftSign : Bool → ℤ
  | false => 1
  | true => -1

/-- The deck transformation exchanges the two lifts in every fibre. -/
def deck (x : OrientedAxis) : OrientedAxis := (x.1, !x.2)

/-- Matrix of the deck permutation on the twelve oriented lifts. -/
def deckMatrix : Matrix OrientedAxis OrientedAxis ℤ :=
  fun x y => if y = deck x then 1 else 0

/-- Difference of the two orbital adjacency operators on the oriented cover.
On the fibre-odd part it is twice the signed orbital matrix. -/
def orbitalDifference : Matrix OrientedAxis OrientedAxis ℤ :=
  fun x y => liftSign x.2 * fiberOddOrbitalMatrix x.1 y.1 * liftSign y.2

private theorem liftSign_sq (b : Bool) : liftSign b * liftSign b = 1 := by
  cases b <;> rfl

private theorem orbitalDifference_fiber_sum (i j k : Fin 6) (b c : Bool) :
    ∑ t : Bool, orbitalDifference (i, b) (k, t) *
      orbitalDifference (k, t) (j, c) =
        2 * (liftSign b * liftSign c) *
          (fiberOddOrbitalMatrix i k * fiberOddOrbitalMatrix k j) := by
  cases b <;> cases c <;>
    simp [orbitalDifference, liftSign] <;> ring

/-- Golden square on the twelve-point cover:
`(A-A')² = 10(1-R)`.  The Boolean fibre sum is the two-case cancellation;
the remaining axis sum is `B²=5I`. -/
theorem orbitalDifference_sq_eq_ten_one_sub_deck :
    orbitalDifference * orbitalDifference =
      10 • ((1 : Matrix OrientedAxis OrientedAxis ℤ) - deckMatrix) := by
  ext x y
  rcases x with ⟨i, b⟩
  rcases y with ⟨j, c⟩
  simp only [Matrix.mul_apply]
  rw [Fintype.sum_prod_type]
  simp_rw [orbitalDifference_fiber_sum]
  rw [← Finset.mul_sum]
  have hB := congrArg (fun M : Matrix (Fin 6) (Fin 6) ℤ => M i j)
    signedOrbitalMatrix_sq
  simp only [Matrix.mul_apply, Matrix.smul_apply, Matrix.one_apply] at hB
  rw [hB]
  by_cases hij : i = j
  · subst j
    cases b <;> cases c <;>
      simp [deckMatrix, deck, liftSign, Matrix.smul_apply, Matrix.sub_apply]
  · cases b <;> cases c <;>
      simp [deckMatrix, deck, liftSign, Matrix.smul_apply, Matrix.sub_apply,
        hij, Ne.symm hij]

#print axioms liftChange_eq_diagonalSwitch
#print axioms rawAxisRepresentative_mem_implies_orbital
#print axioms rawFiberOddOrbitalMatrix_eq_conference_transport
#print axioms rawOrbitalExchange_eq_neg
#print axioms orbitalExchange_eq_neg
#print axioms normalized_pentagon_side_diagonal_opposite
#print axioms pentagonNext_orbit_surjective
#print axioms A5_no_sign_quotient
#print axioms signedOrbitalMatrix_sq
#print axioms orbitalDifference_sq_eq_ten_one_sub_deck

end RelativeConicArcs.PaperIOrientationPentagon
