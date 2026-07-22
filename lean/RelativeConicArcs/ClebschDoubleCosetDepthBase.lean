import RelativeConicArcs.ClebschDoubleCosetDepthData
import RelativeConicArcs.ClebschGatewayQ11Fusion

/-!
# Secant incidence and finite permutation-generator orbits over `ZMod 11`

This module evaluates the six secants of each displayed perfect matching on 133 frozen normalized
coordinate representatives.  It defines four signed relation-cell counts and derives their invariance
under two displayed permutation generators and their negation under the displayed sheet involution.

The coordinate representatives, relation labels, matching table, and action generators are literal finite
input.  Every theorem below is checked by kernel reduction; no depth vector or equivariance fact is
part of the input data.
-/

namespace RelativeConicArcs
namespace ClebschDoubleCosetDepth

open Finset
open ClebschGateway.Q11Matching

set_option maxRecDepth 100000
set_option maxHeartbeats 5000000

local instance : Fact (Nat.Prime 11) := ⟨by decide⟩

/-- The standard-conic secant through two parameter labels, in coefficient order `X,Y,Z`. -/
def secantLine (i j : Endpoint) : Fin 3 → ZMod 11 := ![
  conicParameter i 1 * conicParameter j 1,
  -(conicParameter i 0 * conicParameter j 1 + conicParameter i 1 * conicParameter j 0),
  conicParameter i 0 * conicParameter j 0
]

/-- Standard coordinates of a frozen normalized representative in the displayed source frame. -/
def standardPoint (x : ProjectivePoint) : Fin 3 → ZMod 11 :=
  fun i ↦ ∑ j, h3ToStandard i j * projectivePoint x j

/-- Whether a frozen coordinate representative lies on the secant with the displayed endpoint labels. -/
def liesOnSecant (i j : Endpoint) (x : ProjectivePoint) : Bool :=
  decide (∑ k, secantLine i j k * standardPoint x k = 0)

/-- Whether a point lies on at least one of the six undirected secants of a matching row. -/
def liesOnSecantUnion (p : Parent) (x : ProjectivePoint) : Bool :=
  decide (∃ i : Endpoint, i.1 < (matchingMate p i).1 ∧
    liesOnSecant i (matchingMate p i) x = true)

/-- Number of frozen coordinate representatives in one relation cell lying on the secant union. -/
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

/-- A vector represents a frozen normalized coordinate when it is a nonzero scalar multiple. -/
def Represents (x : ProjectivePoint) (v : Fin 3 → ZMod 11) : Prop :=
  ∃ a : ZMod 11, a ≠ 0 ∧ v = fun i ↦ a * projectivePoint x i

/-- The homogeneous vectors represented by points in one relation cell. -/
def VectorInRelation (r : RelationCell) (v : Fin 3 → ZMod 11) : Prop :=
  ∃ x, Represents x v ∧ relationCell x = r

/-- Each of the 133 frozen point indices belongs to exactly one of the sixteen displayed cells. -/
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

/-- Each displayed point permutation is the projective action of its displayed matrix. -/
theorem subgroupGeneratorPoint_represents_matrix :
    ∀ g x, Represents (subgroupGeneratorPoint g x)
      (fun i ↦ ∑ j, subgroupGeneratorMatrix g i j * projectivePoint x j) := by
  simp only [Represents]
  decide

/-- The displayed sheet point permutation is the projective action of its displayed matrix. -/
theorem sheetInvolutionPoint_represents_matrix :
    ∀ x, Represents (sheetInvolutionPoint x)
      (fun i ↦ ∑ j, sheetInvolutionMatrix i j * projectivePoint x j) := by
  simp only [Represents]
  decide

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

/-- The sheet involution carries the displayed relation label of each frozen index to its mate. -/
theorem sheetInvolution_moves_relation :
    ∀ x, relationCell (sheetInvolutionPoint x) = sheetInvolutionRelation (relationCell x) := by
  decide

/-- The sheet involution exchanges the two entries of each oriented relation pair. -/
theorem sheetInvolution_swaps_oriented_pairs :
    ∀ i, sheetInvolutionRelation (orientedRelationPair i 0) = orientedRelationPair i 1 ∧
      sheetInvolutionRelation (orientedRelationPair i 1) = orientedRelationPair i 0 := by
  decide

/-- One simultaneous expansion by the two displayed matching-row generators. -/
def generatorStep (s : Finset Parent) : Finset Parent :=
  (s ∪ s.image (subgroupGeneratorParent 0)) ∪
    s.image (subgroupGeneratorParent 1)

/-- Reachability by a finite word in the two displayed matching-row generators. -/
inductive GeneratorReachable (p : Parent) : Parent → Prop
  | refl : GeneratorReachable p p
  | step (g : Generator) {q : Parent} :
      GeneratorReachable p q → GeneratorReachable p (subgroupGeneratorParent g q)

/-- The finite set obtained after twelve simultaneous generator expansions. -/
def generatedOrbit (p : Parent) : Finset Parent :=
  (generatorStep^[12]) {p}

/-- Both displayed matching-row generators are permutations. -/
theorem subgroupGeneratorParent_bijective :
    ∀ g, Function.Bijective (subgroupGeneratorParent g) := by
  decide

/-- The first displayed permutation has order dividing two and the second order dividing three. -/
theorem subgroupGeneratorParent_orders :
    (∀ p, subgroupGeneratorParent 0 (subgroupGeneratorParent 0 p) = p) ∧
    (∀ p, subgroupGeneratorParent 1
      (subgroupGeneratorParent 1 (subgroupGeneratorParent 1 p)) = p) := by
  decide

private theorem generatorStep_preserves_reachability {p : Parent} (s : Finset Parent)
    (hs : ∀ q ∈ s, GeneratorReachable p q) :
    ∀ q ∈ generatorStep s, GeneratorReachable p q := by
  intro q hq
  simp only [generatorStep, mem_union, mem_image] at hq
  rcases hq with (hq | ⟨r, hr, rfl⟩) | ⟨r, hr, rfl⟩
  · exact hs q hq
  · exact GeneratorReachable.step 0 (hs r hr)
  · exact GeneratorReachable.step 1 (hs r hr)

private theorem iteratedGeneratorStep_reachable (p : Parent) :
    ∀ n q, q ∈ (generatorStep^[n]) {p} → GeneratorReachable p q := by
  intro n
  induction n with
  | zero =>
      intro q hq
      have hqp : q = p := by
        simpa only [Function.iterate_zero, id_eq, mem_singleton] using hq
      subst q
      exact GeneratorReachable.refl
  | succ n ih =>
      intro q hq
      rw [Function.iterate_succ_apply'] at hq
      exact generatorStep_preserves_reachability _ (fun r hr ↦ ih r hr) q hq

/-- The twelve-step set contains its seed. -/
theorem generatedOrbit_seed : ∀ p, p ∈ generatedOrbit p := by
  decide

/-- The twelve-step set is closed under both displayed generators. -/
theorem generatedOrbit_closed :
    ∀ p g q, q ∈ generatedOrbit p → subgroupGeneratorParent g q ∈ generatedOrbit p := by
  decide

set_option linter.constructorNameAsVariable false

/-- The computed finite set is exactly reachability by arbitrary generator words. -/
theorem mem_generatedOrbit_iff_reachable (p q : Parent) :
    q ∈ generatedOrbit p ↔ GeneratorReachable p q := by
  constructor
  · exact iteratedGeneratorStep_reachable p 12 q
  · intro h
    induction h with
    | refl => exact generatedOrbit_seed p
    | step g h ih => exact generatedOrbit_closed p g _ ih

set_option linter.constructorNameAsVariable true

/-- The six permutation-generator orbits have sizes `1,4,6` on each sheet. -/
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
