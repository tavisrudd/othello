import RelativeConicArcs.ClebschDoubleCosetDepthData
import RelativeConicArcs.ClebschGatewayQ11Fusion

/-!
# Secant incidence and tetrahedral generator orbits over `ZMod 11`

This module evaluates the six secants of each displayed perfect matching on the normalized points
of the projective plane.  It defines four signed relation-cell counts and derives their invariance
under the two displayed tetrahedral generators and their negation under the sheet involution.

The projective points, relation labels, matching table, and action generators are literal finite
input.  Every theorem below is checked by kernel reduction; no depth vector or equivariance fact is
part of the input data.
-/

namespace RelativeConicArcs
namespace ClebschDoubleCosetDepth

open Finset
open ClebschGateway.Q11Matching

set_option maxRecDepth 100000
set_option maxHeartbeats 1000000

local instance : Fact (Nat.Prime 11) := ⟨by decide⟩

/-- The standard-conic secant through two parameter labels, in coefficient order `X,Y,Z`. -/
def secantLine (i j : Endpoint) : Fin 3 → ZMod 11 := ![
  conicParameter i 1 * conicParameter j 1,
  -(conicParameter i 0 * conicParameter j 1 + conicParameter i 1 * conicParameter j 0),
  conicParameter i 0 * conicParameter j 0
]

/-- Standard coordinates of a normalized point expressed in the icosahedral frame. -/
def standardPoint (x : ProjectivePoint) : Fin 3 → ZMod 11 :=
  fun i ↦ ∑ j, h3ToStandard i j * projectivePoint x j

/-- Whether a normalized projective point lies on the secant with the displayed endpoint labels. -/
def liesOnSecant (i j : Endpoint) (x : ProjectivePoint) : Bool :=
  decide (∑ k, secantLine i j k * standardPoint x k = 0)

/-- Whether a point lies on at least one of the six undirected secants of a matching row. -/
def liesOnSecantUnion (p : Parent) (x : ProjectivePoint) : Bool :=
  decide (∃ i : Endpoint, i.1 < (matchingMate p i).1 ∧
    liesOnSecant i (matchingMate p i) x = true)

/-- Number of projective points in one relation cell lying on the six-secants union. -/
def relationZeroCount (p : Parent) (r : RelationCell) : ℤ :=
  ((Finset.univ.filter fun x : ProjectivePoint =>
    relationCell x = r ∧ liesOnSecantUnion p x).card : ℤ)

/-- Four oriented differences of relation-cell zero counts. -/
def depthProfile (p : Parent) : Fin 4 → ℤ :=
  fun i ↦ relationZeroCount p (orientedRelationPair i 0) -
    relationZeroCount p (orientedRelationPair i 1)

/-- The points carrying a fixed relation label. -/
def relationCellSet (r : RelationCell) : Finset ProjectivePoint :=
  Finset.univ.filter fun x ↦ relationCell x = r

/-- A vector represents a normalized projective point when it is a nonzero scalar multiple. -/
def Represents (x : ProjectivePoint) (v : Fin 3 → ZMod 11) : Prop :=
  ∃ a : ZMod 11, a ≠ 0 ∧ v = fun i ↦ a * projectivePoint x i

/-- The homogeneous vectors represented by points in one relation cell. -/
def VectorInRelation (r : RelationCell) (v : Fin 3 → ZMod 11) : Prop :=
  ∃ x, Represents x v ∧ relationCell x = r

/-- Each normalized projective point belongs to exactly one of the sixteen displayed cells. -/
theorem relationCells_partition : ∀ x : ProjectivePoint, ∃! r, x ∈ relationCellSet r := by
  intro x
  refine ⟨relationCell x, by simp [relationCellSet], ?_⟩
  intro r hr
  have h : relationCell x = r := by simpa [relationCellSet] using hr
  exact h.symm

/-- The homogeneous lift of every relation cell is closed under nonzero scalar multiplication. -/
theorem vectorInRelation_smul {r : RelationCell} {v : Fin 3 → ZMod 11}
    (b : ZMod 11) (hb : b ≠ 0) (hv : VectorInRelation r v) :
    VectorInRelation r (b • v) := by
  rcases hv with ⟨x, ⟨a, ha, rfl⟩, hx⟩
  refine ⟨x, ⟨b * a, mul_ne_zero hb ha, ?_⟩, hx⟩
  funext i
  simp [Pi.smul_apply, mul_assoc]

/-- The two displayed maps on matching rows agree with relabelling every matching endpoint. -/
theorem subgroupGeneratorParent_matches_endpoints :
    ∀ g p x, matchingMate (subgroupGeneratorParent g p) (subgroupGeneratorEndpoint g x) =
      subgroupGeneratorEndpoint g (matchingMate p x) := by
  decide

/-- Each displayed subgroup generator preserves every relation cell. -/
theorem subgroupGenerator_preserves_relation :
    ∀ g x, relationCell (subgroupGeneratorPoint g x) = relationCell x := by
  decide

/-- The sheet involution is an involution on matching rows. -/
theorem sheetInvolutionParent_involutive : Function.Involutive sheetInvolutionParent := by
  intro p
  fin_cases p <;> decide

/-- The sheet involution relabels every endpoint of every matching row. -/
theorem sheetInvolutionParent_matches_endpoints :
    ∀ p x, matchingMate (sheetInvolutionParent p) (sheetInvolutionEndpoint x) =
      sheetInvolutionEndpoint (matchingMate p x) := by
  decide

/-- The sheet involution carries each normalized projective relation cell to its displayed mate. -/
theorem sheetInvolution_moves_relation :
    ∀ x, relationCell (sheetInvolutionPoint x) = sheetInvolutionRelation (relationCell x) := by
  decide

/-- The sheet involution exchanges the two entries of each oriented relation pair. -/
theorem sheetInvolution_swaps_oriented_pairs :
    ∀ i, sheetInvolutionRelation (orientedRelationPair i 0) = orientedRelationPair i 1 ∧
      sheetInvolutionRelation (orientedRelationPair i 1) = orientedRelationPair i 0 := by
  decide

/-- One simultaneous expansion by the two subgroup generators. -/
def generatorStep (s : Finset Parent) : Finset Parent :=
  s ∪ Finset.univ.biUnion fun g : Generator => s.image (subgroupGeneratorParent g)

/-- The generator orbit, computed after twelve expansions, the order of the displayed subgroup. -/
def generatedOrbit (p : Parent) : Finset Parent :=
  (generatorStep^[12]) {p}

/-- The six generator orbits have sizes `1,4,6` on each sheet. -/
theorem generatedOrbit_card :
    ∀ i : Fin 6, (generatedOrbit (orbitRepresentative i)).card = ![1, 4, 6, 1, 4, 6] i := by
  decide

/-- The union of the six generated orbits is the full set of matching rows. -/
theorem generatedOrbits_cover :
    Finset.univ.biUnion (fun i : Fin 6 => generatedOrbit (orbitRepresentative i)) =
      (Finset.univ : Finset Parent) := by
  decide

/-- Distinct displayed representatives generate disjoint orbits. -/
theorem generatedOrbits_pairwise_disjoint :
    ∀ i j : Fin 6, i ≠ j →
      Disjoint (generatedOrbit (orbitRepresentative i)) (generatedOrbit (orbitRepresentative j)) := by
  decide

/-- The sheet involution pairs the three positive representatives with the three negative ones. -/
theorem sheetInvolution_pairs_representatives :
    sheetInvolutionParent (orbitRepresentative 0) = orbitRepresentative 3 ∧
    sheetInvolutionParent (orbitRepresentative 1) = orbitRepresentative 4 ∧
    sheetInvolutionParent (orbitRepresentative 2) = orbitRepresentative 5 := by
  decide

end ClebschDoubleCosetDepth
end RelativeConicArcs
