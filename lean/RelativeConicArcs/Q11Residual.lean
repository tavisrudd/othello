import RelativeConicArcs.ExampleChecks.Q11
import CapGame.GraphMirror

/-!
# The residual game of the `q = 11` relative-conic witness

The six-point witness `Examples.q11Witness` leaves all twelve points of the standard conic
available.  Two conic points conflict when they and one witness point are collinear.  This file
records that finite residual directly on `Fin 12`, identifies it with the standard icosahedral
graph, and proves that its independent-set building game is P by an explicit antipodal mirror.

The determinant and finite-table statements are discharged by kernel reduction.  The game-value
conclusion is not an exhaustive game-tree computation: it is an application of the generic
fixed-point-free conflict-graph mirror theorem.
-/

namespace RelativeConicArcs
namespace Examples
namespace Q11Residual

open Certificate ConflictGraph

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

/-- The twelve standard-conic representatives, ordered by the eleven affine parameters followed
by the point at infinity. -/
def conicVec (i : Fin 12) : Vec (ZMod 11) :=
  if i.1 < 11 then ![1, (i.1 : ZMod 11), (i.1 : ZMod 11) ^ 2] else ![0, 0, 1]

/-- No conic parameter is covered by a secant of two distinct witness points.  Thus every one of
the twelve conic points is initially live after the witness is occupied. -/
def SeedLegal (i : Fin 12) : Prop :=
  ∀ a ∈ q11Witness, ∀ b ∈ q11Witness, rayEq a.1 b.1 = false →
    Matrix.det ![conicVec i, a.1, b.1] ≠ 0

instance (i : Fin 12) : Decidable (SeedLegal i) := by
  unfold SeedLegal
  infer_instance

theorem all_seed_legal : ∀ i : Fin 12, SeedLegal i := by decide

theorem seed_rawArc : RawArc q11Witness :=
  (check_rawValid q11_check).2.1

/-- The twelve displayed conic vectors represent distinct projective points. -/
theorem conic_parameters_distinct :
    ∀ i j : Fin 12, i ≠ j → rayEq (conicVec i) (conicVec j) = false := by
  decide

/-- No three distinct displayed conic parameters are collinear. -/
theorem conic_triples_legal :
    ∀ i j k : Fin 12, i ≠ j → i ≠ k → j ≠ k →
      Matrix.det ![conicVec i, conicVec j, conicVec k] ≠ 0 := by
  decide

/-- Conflict in the conic residual: a witness point lies on the chord through the two parameters. -/
def Adj (i j : Fin 12) : Prop :=
  i ≠ j ∧ ∃ a ∈ q11Witness, Matrix.det ![conicVec i, conicVec j, a.1] = 0

instance (i j : Fin 12) : Decidable (Adj i j) := by
  unfold Adj
  infer_instance

/-- The six antipodal pairs in affine-parameter order:
`(0,9), (1,7), (2,∞), (3,4), (5,8), (6,10)`. -/
def antipode : Fin 12 ≃ Fin 12 where
  toFun i := ![9, 7, 11, 4, 3, 8, 10, 1, 5, 0, 6, 2] i
  invFun i := ![9, 7, 11, 4, 3, 8, 10, 1, 5, 0, 6, 2] i
  left_inv := by decide
  right_inv := by decide

theorem antipode_involutive (i : Fin 12) : antipode (antipode i) = i := by
  fin_cases i <;> decide

theorem antipode_fixedPointFree (i : Fin 12) : antipode i ≠ i := by
  fin_cases i <;> decide

theorem adj_symmetric : ∀ i j : Fin 12, Adj i j → Adj j i := by
  decide

theorem adj_antipode_iff (i j : Fin 12) :
    Adj (antipode i) (antipode j) ↔ Adj i j := by
  fin_cases i <;> fin_cases j <;> decide

theorem antipodal_chord_nonedge (i : Fin 12) : ¬ Adj i (antipode i) := by
  fin_cases i <;> decide

/-- The standard 30-edge presentation: north and south poles, two pentagons, and the ten
cross-pentagon edges. -/
def icosahedronEdges : Finset (Fin 12 × Fin 12) := {
  (0, 1), (0, 2), (0, 3), (0, 4), (0, 5),
  (11, 6), (11, 7), (11, 8), (11, 9), (11, 10),
  (1, 2), (2, 3), (3, 4), (4, 5), (5, 1),
  (6, 7), (7, 8), (8, 9), (9, 10), (10, 6),
  (1, 6), (2, 7), (3, 8), (4, 9), (5, 10),
  (1, 10), (2, 6), (3, 7), (4, 8), (5, 9) }

def IcosahedronAdj (i j : Fin 12) : Prop :=
  (i, j) ∈ icosahedronEdges ∨ (j, i) ∈ icosahedronEdges

instance (i j : Fin 12) : Decidable (IcosahedronAdj i j) := by
  unfold IcosahedronAdj
  infer_instance

/-- An explicit graph isomorphism from affine-parameter order to the standard presentation. -/
def toIcosahedron : Fin 12 ≃ Fin 12 where
  toFun i := ![7, 1, 11, 10, 3, 6, 9, 8, 4, 5, 2, 0] i
  invFun i := ![11, 1, 10, 4, 8, 9, 5, 0, 7, 6, 3, 2] i
  left_inv := by decide
  right_inv := by decide

/-- The determinant-defined residual is exactly the icosahedral graph. -/
theorem adj_iff_icosahedron (i j : Fin 12) :
    Adj i j ↔ IcosahedronAdj (toIcosahedron i) (toIcosahedron j) := by
  fin_cases i <;> fin_cases j <;> decide

theorem icosahedronEdges_card : icosahedronEdges.card = 30 := by decide

def neighbors (i : Fin 12) : Finset (Fin 12) :=
  Finset.univ.filter (Adj i)

theorem degree_five (i : Fin 12) : (neighbors i).card = 5 := by
  fin_cases i <;> decide

/-- The residual independent-set building game is P by antipodal reply. -/
theorem isP :
    FiniteBuildGame.IsP (IndepValid Adj) (∅ : Finset (Fin 12)) := by
  exact initialIndepP_of_fpf_adjPreserving_involution Adj adj_symmetric antipode
    antipode_involutive antipode_fixedPointFree adj_antipode_iff antipodal_chord_nonedge

end Q11Residual
end Examples
end RelativeConicArcs
