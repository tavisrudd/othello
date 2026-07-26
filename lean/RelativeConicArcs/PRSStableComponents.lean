import RelativeConicArcs.PRSPolarInduction
import RelativeConicArcs.PRSSquarefreeMarkerDensity
import Mathlib.Topology.Irreducible

/-!
# Algebraic terminals for stable coherent-polar components

This module checks the coordinate calculations and the topological component-selection argument
used in the all-degree contained-component proof for binary divided-power syndromes.

First, it proves the Plücker factorizations for the symmetric, exchanged, and anti-invariant
factorizations of a symmetric bidegree-`(2,2)` ordered-root incidence.  Second, it shows that a
linear contraction family indexed by a two-dimensional free module lies in a lower nucleus
exactly when its two coordinate contractions do.  Third, it proves the coefficient-block
overlap responsible for termination of the characteristic-two cyclic-plane descendant: if the
first and last columns of an `(m+1) × 5` consecutive catalecticant vanish and `m ≥ 3`, every
coefficient represented by that catalecticant vanishes.  Finally, it proves that a dense attainable
locus contained in a closed finite component union has its irreducible row-space closure contained
in one component, and connects that selected component to the recursive contained classification.

The imported marker-density module proves polynomial density of monic split-squarefree coefficient
tuples over an infinite field, as used after passage to an algebraic closure.  The paper-specific
identification of that coefficient map with the projective
catalecticant row-space closure and the primary decomposition of the lower bad scheme remain
mathematical inputs.  Once supplied, component selection and recursive classification are
conclusions rather than interface assumptions.
-/

namespace RelativeConicArcs.PRSStableComponents

section PluckerFactorizations

variable {R : Type*} [CommRing R]

/-- The Plücker relation for a product of two symmetric `(1,1)` forms factors as the product of
their two rank-one determinants. -/
theorem symmetricFactor_plucker
    (a b c A B C : R) :
    (a * A) * (c * C) -
          (a * B + b * A) * (b * C + c * B) +
          (b * B) * (a * C + c * A + b * B) =
      (a * c - b ^ 2) * (A * C - B ^ 2) := by
  ring

/-- The Plücker relation for a `(1,1)` form multiplied by its transposed form has the collision
factor `a*d-b*c` and the residual cyclic factor `a*d-b²+b*c-c²`. -/
theorem exchangedFactor_plucker
    (a b c d : R) :
    (a ^ 2) * (d ^ 2) -
          (a * (b + c)) * (d * (b + c)) +
          (b * c) * (2 * a * d + b ^ 2 + c ^ 2 - b * c) =
      (a * d - b * c) * (a * d - b ^ 2 + b * c - c ^ 2) := by
  ring

/-- Two anti-invariant factors are proportional to the diagonal bracket.  Their only nonzero
Plücker coordinates are `z₂=-μ` and `z₃=3μ`, so the Plücker relation is `-3μ²`. -/
theorem antiInvariantFactor_plucker (μ : R) :
    (0 : R) * 0 - 0 * 0 + (-μ) * (3 * μ) = -(3 : R) * μ ^ 2 := by
  ring

end PluckerFactorizations

section CoherentFanoIdentities

variable {R : Type*} [CommRing R]

/-- The first coherent-Fano coefficient combination equals six times the leading consecutive
`3 × 3` Hankel minor. -/
theorem coherentFano_first_hankelMinor
    (d0 d1 d2 d3 d4 d5 : R) :
    6 * (d0 * d2 * d4 - d0 * d3 ^ 2 - d1 ^ 2 * d4 +
          2 * d1 * d2 * d3 - d2 ^ 3) =
      -3 * (d0 * d3 ^ 2 - d1 ^ 2 * d4) -
      2 * (d0 * d1 * d5 - 2 * d0 * d2 * d4 - 3 * d0 * d3 ^ 2 +
        3 * d1 ^ 2 * d4 + d1 * d2 * d3) +
      (2 * d0 * d1 * d5 + 2 * d0 * d2 * d4 - 9 * d0 * d3 ^ 2 +
        3 * d1 ^ 2 * d4 - 4 * d1 * d2 * d3 + 6 * d2 ^ 3) -
      6 * (d1 ^ 2 * d4 - 3 * d1 * d2 * d3 + 2 * d2 ^ 3) := by
  ring

/-- The second coherent-Fano coefficient combination equals six times the next consecutive
`3 × 3` Hankel minor. -/
theorem coherentFano_second_hankelMinor
    (d0 d1 d2 d3 d4 d5 : R) :
    6 * (d0 * d2 * d5 - d0 * d3 * d4 - d1 ^ 2 * d5 +
          d1 * d2 * d4 + d1 * d3 ^ 2 - d2 ^ 2 * d3) =
      -6 * (d0 * d3 * d4 - 3 * d1 * d2 * d4 + 2 * d1 * d3 ^ 2) +
      9 * (2 * d0 * d3 * d4 - d1 ^ 2 * d5 -
        2 * d1 * d2 * d4 + d1 * d3 ^ 2) +
      6 * (d0 * d2 * d5 - 3 * d0 * d3 * d4 + d1 ^ 2 * d5 +
        2 * d1 * d2 * d4 - 3 * d1 * d3 ^ 2 + 2 * d2 ^ 2 * d3) -
      3 * (d1 ^ 2 * d5 + 2 * d1 * d2 * d4 -
        9 * d1 * d3 ^ 2 + 6 * d2 ^ 2 * d3) := by
  ring

/-- The third coherent-Fano coefficient combination equals six times the reversal-paired
consecutive `3 × 3` Hankel minor. -/
theorem coherentFano_third_hankelMinor
    (d0 d1 d2 d3 d4 d5 : R) :
    6 * (d0 * d3 * d5 - d0 * d4 ^ 2 - d1 * d2 * d5 +
          d1 * d3 * d4 + d2 ^ 2 * d4 - d2 * d3 ^ 2) =
      -3 * (d0 * d4 ^ 2 + 2 * d1 * d3 * d4 -
        9 * d2 ^ 2 * d4 + 6 * d2 * d3 ^ 2) +
      6 * (d0 * d3 * d5 + d0 * d4 ^ 2 - 3 * d1 * d2 * d5 +
        2 * d1 * d3 * d4 - 3 * d2 ^ 2 * d4 + 2 * d2 * d3 ^ 2) -
      9 * (d0 * d4 ^ 2 - 2 * d1 * d2 * d5 +
        2 * d1 * d3 * d4 - d2 ^ 2 * d4) -
      6 * (d1 * d2 * d5 - 3 * d1 * d3 * d4 + 2 * d2 ^ 2 * d4) := by
  ring

/-- The fourth coherent-Fano coefficient combination equals six times the trailing consecutive
`3 × 3` Hankel minor. -/
theorem coherentFano_fourth_hankelMinor
    (d0 d1 d2 d3 d4 d5 : R) :
    6 * (d1 * d3 * d5 - d1 * d4 ^ 2 - d2 ^ 2 * d5 +
          2 * d2 * d3 * d4 - d3 ^ 3) =
      -6 * (d1 * d4 ^ 2 - 3 * d2 * d3 * d4 + 2 * d3 ^ 3) +
      (2 * d0 * d4 * d5 + 2 * d1 * d3 * d5 + 3 * d1 * d4 ^ 2 -
        9 * d2 ^ 2 * d5 - 4 * d2 * d3 * d4 + 6 * d3 ^ 3) -
      2 * (d0 * d4 * d5 - 2 * d1 * d3 * d5 + 3 * d1 * d4 ^ 2 -
        3 * d2 ^ 2 * d5 + d2 * d3 * d4) +
      3 * (d1 * d4 ^ 2 - d2 ^ 2 * d5) := by
  ring

end CoherentFanoIdentities

section ContainedRowSpaceGeometry

variable {Point : Type*} [TopologicalSpace Point]

/-- Topological data for the row-space step in a contained coherent-polar argument.

`attainable` is the locus produced by distinct retained markers, `rowSpace` is its asserted
closure, and `badCarrier` is the closed lower bad locus.  The finite set `components` is the exact
closed-component ledger for that carrier. -/
structure ContainedRowSpaceData (Point : Type*) [TopologicalSpace Point] where
  /-- Syndromes attained by the allowed distinct-marker products. -/
  attainable : Set Point
  /-- Projective row space obtained by closing the attainable locus. -/
  rowSpace : Set Point
  /-- Reduced closed lower bad carrier. -/
  badCarrier : Set Point
  /-- Finite ledger of closed components of the lower bad carrier. -/
  components : Finset (Set Point)
  /-- The attainable locus is dense in the asserted row space. -/
  closure_attainable : closure attainable = rowSpace
  /-- Every attainable syndrome belongs to the lower bad carrier. -/
  attainable_subset_badCarrier : attainable ⊆ badCarrier
  /-- The lower bad carrier is closed. -/
  badCarrier_closed : IsClosed badCarrier
  /-- The finite component ledger covers the lower bad carrier exactly. -/
  badCarrier_eq_sUnion_components : badCarrier = ⋃₀ (components : Set (Set Point))
  /-- Every member of the component ledger is closed. -/
  components_closed : ∀ component ∈ components, IsClosed component
  /-- The projective row space is nonempty and irreducible. -/
  rowSpace_irreducible : IsIrreducible rowSpace

namespace ContainedRowSpaceData

/-- Closing a dense attainable locus transports its containment in the closed bad carrier to the
entire row space. -/
theorem rowSpace_subset_badCarrier (data : ContainedRowSpaceData Point) :
    data.rowSpace ⊆ data.badCarrier := by
  rw [← data.closure_attainable]
  exact closure_minimal data.attainable_subset_badCarrier data.badCarrier_closed

/-- An irreducible row space contained in a finite union of closed components lies in one listed
component. -/
theorem exists_component_containing_rowSpace (data : ContainedRowSpaceData Point) :
    ∃ component ∈ data.components, data.rowSpace ⊆ component := by
  apply (isIrreducible_iff_sUnion_isClosed.mp data.rowSpace_irreducible)
  · exact data.components_closed
  · rw [← data.badCarrier_eq_sUnion_components]
    exact data.rowSpace_subset_badCarrier

end ContainedRowSpaceData

end ContainedRowSpaceGeometry

section RecursiveContainedGeometry

/-- Geometric inputs for recursively contained polar flags.

At each positive stage, the retained-marker locus has a row-space closure and a finite closed
component ledger.  Each selected component is declared persistent, modular, or descending.  This
structure differs from `PRSPolarInduction.RecursiveContainedInput` by deriving component selection
from density, closedness, and irreducibility instead of accepting a preselected lower component. -/
structure RecursiveContainedGeometryInput
    (Stage GeometryPoint : ℕ → Type*)
    [∀ j, TopologicalSpace (GeometryPoint j)] where
  /-- Reduced recursively contained bad locus at each stage. -/
  bad : ∀ j, Stage j → Prop
  /-- Persistent component predicate at each stage. -/
  persistent : ∀ j, Stage j → Prop
  /-- Modular component predicate at each stage. -/
  modular : ∀ j, Stage j → Prop
  /-- Lower syndrome associated with one contraction step. -/
  lower : ∀ j, Stage (j + 1) → Stage j
  /-- Classification of the bottom bad locus. -/
  bottomClassification :
    ∀ {syndrome}, bad 0 syndrome → persistent 0 syndrome ∨ modular 0 syndrome
  /-- Dense row-space and finite-component data attached to every positive-stage bad syndrome. -/
  rowSpaceData :
    ∀ j {syndrome}, bad (j + 1) syndrome →
      ContainedRowSpaceData (GeometryPoint j)
  /-- Classification of any component selected from the exact lower ledger. -/
  componentClassification :
    ∀ j {syndrome} (hbad : bad (j + 1) syndrome)
      (component : Set (GeometryPoint j)),
      component ∈ (rowSpaceData j hbad).components →
      (rowSpaceData j hbad).rowSpace ⊆ component →
      persistent (j + 1) syndrome ∨ modular (j + 1) syndrome ∨
        bad j (lower j syndrome)
  /-- A persistent lower classification lifts through one contraction. -/
  persistent_lift :
    ∀ j {syndrome}, persistent j (lower j syndrome) → persistent (j + 1) syndrome
  /-- A modular lower classification lifts through one contraction. -/
  modular_lift :
    ∀ j {syndrome}, modular j (lower j syndrome) → modular (j + 1) syndrome

namespace RecursiveContainedGeometryInput

/-- Density and irreducibility select a classified lower component at every recursive step. -/
theorem recursiveStep
    {Stage GeometryPoint : ℕ → Type*}
    [∀ j, TopologicalSpace (GeometryPoint j)]
    (input : RecursiveContainedGeometryInput Stage GeometryPoint)
    (j : ℕ) {syndrome : Stage (j + 1)}
    (hbad : input.bad (j + 1) syndrome) :
    input.persistent (j + 1) syndrome ∨ input.modular (j + 1) syndrome ∨
      input.bad j (input.lower j syndrome) := by
  obtain ⟨component, hcomponent, hrowSpace⟩ :=
    (input.rowSpaceData j hbad).exists_component_containing_rowSpace
  exact input.componentClassification j hbad component hcomponent hrowSpace

/-- Forgetting the geometric witnesses gives the recursive logical interface used by polar
induction.  Its recursive-step field is proved by component selection rather than supplied. -/
def toRecursiveContainedInput
    {Stage GeometryPoint : ℕ → Type*}
    [∀ j, TopologicalSpace (GeometryPoint j)]
    (input : RecursiveContainedGeometryInput Stage GeometryPoint) :
    PRSPolarInduction.RecursiveContainedInput Stage where
  bad := input.bad
  persistent := input.persistent
  modular := input.modular
  lower := input.lower
  bottomClassification := input.bottomClassification
  recursiveStep := input.recursiveStep
  persistent_lift := input.persistent_lift
  modular_lift := input.modular_lift

/-- Every recursively contained bad syndrome is persistent or modular once the exact dense
row-space component ledger and the one-step lift classifications are supplied. -/
theorem bad_implies_persistent_or_modular
    {Stage GeometryPoint : ℕ → Type*}
    [∀ j, TopologicalSpace (GeometryPoint j)]
    (input : RecursiveContainedGeometryInput Stage GeometryPoint) :
    ∀ j {syndrome : Stage j}, input.bad j syndrome →
      input.persistent j syndrome ∨ input.modular j syndrome :=
  input.toRecursiveContainedInput.bad_implies_persistent_or_modular

end RecursiveContainedGeometryInput

end RecursiveContainedGeometry

section TwoCoordinateModularKernel

variable {R Syndrome Lower : Type*}
  [CommRing R]
  [AddCommGroup Syndrome] [Module R Syndrome]
  [AddCommGroup Lower] [Module R Lower]

/-- For a contraction family linear in two marker coordinates, containment of the whole family
in a lower nucleus is equivalent to containment of the two coordinate contractions.  This is the
linear coherent-lift calculation behind consecutive-support modular pullbacks. -/
theorem mem_modularContractionKernel_prod_iff
    (contractionFamily : Syndrome →ₗ[R] (R × R) →ₗ[R] Lower)
    (nucleus : Submodule R Lower) (syndrome : Syndrome) :
    syndrome ∈
        PRSPolarInduction.modularContractionKernel contractionFamily nucleus ↔
      contractionFamily syndrome (1, 0) ∈ nucleus ∧
        contractionFamily syndrome (0, 1) ∈ nucleus := by
  constructor
  · intro h
    exact ⟨h (1, 0), h (0, 1)⟩
  · rintro ⟨hfirst, hsecond⟩ ⟨x, y⟩
    have hdecomposition :
        (x, y) = x • (1, 0) + y • (0, 1) := by
      ext <;> simp
    rw [hdecomposition, map_add, map_smul, map_smul]
    exact nucleus.add_mem
      (nucleus.smul_mem x hfirst)
      (nucleus.smul_mem y hsecond)

end TwoCoordinateModularKernel

section CyclicPlaneTermination

variable {Coefficient : Type*} [Zero Coefficient]

/-- If the first coefficient block `a₀,…,a_m` and the shifted last block
`a₄,…,a_{m+4}` vanish with `m ≥ 3`, then every coefficient through `a_{m+4}` vanishes. -/
theorem cyclicPlaneCatalecticant_blocks_cover
    {m : ℕ} (hm : 3 ≤ m) (a : ℕ → Coefficient)
    (hfirst : ∀ i, i ≤ m → a i = 0)
    (hlast : ∀ i, i ≤ m → a (i + 4) = 0) :
    ∀ i, i ≤ m + 4 → a i = 0 := by
  intro i hi
  by_cases him : i ≤ m
  · exact hfirst i him
  · have hfour : 4 ≤ i := by omega
    let k := i - 4
    have hk : k ≤ m := by
      dsimp [k]
      omega
    have hik : k + 4 = i := by
      dsimp [k]
      omega
    rw [← hik]
    exact hlast k hk

/-- Under the two cyclic-plane block equations and `m ≥ 3`, there is no nonzero coefficient in
the projective range represented by the consecutive catalecticant. -/
theorem cyclicPlaneCatalecticant_no_nonzero_coefficient
    {m : ℕ} (hm : 3 ≤ m) (a : ℕ → Coefficient)
    (hfirst : ∀ i, i ≤ m → a i = 0)
    (hlast : ∀ i, i ≤ m → a (i + 4) = 0) :
    ¬ ∃ i, i ≤ m + 4 ∧ a i ≠ 0 := by
  rintro ⟨i, hi, hne⟩
  exact hne (cyclicPlaneCatalecticant_blocks_cover hm a hfirst hlast i hi)

end CyclicPlaneTermination

end RelativeConicArcs.PRSStableComponents
