import Mathlib.Algebra.Algebra.Subalgebra.Basic
import Mathlib.LinearAlgebra.Dimension.Constructions
import Mathlib.Tactic

/-!
# The six-fibre information lattice on the fourteen-point matching set

This module checks a displayed finite permutation action on fourteen perfect matchings of eight
vertices.  The eight displayed permutations form the subgroup called `K` here.  For every pair of
matchings, exhaustive native evaluation proves that they lie in the same `K`-orbit exactly when
their sheet labels and their numbers of edges shared with two distinguished matchings agree.

For a finite label map, `fibreSubalgebra` is the algebra of rational-valued functions constant on
its fibres.  A general linear equivalence computes its dimension when the label map is surjective.
Applied to the constant, sheet, `K`-orbit, and singleton labels, this gives the strict tower of
dimensions `1 < 2 < 6 < 14`.

The matching, sheet, and permutation tables are accepted finite data.  Lean checks every displayed
entry, the permutation-group laws, the quantified fibre identity, surjectivity of every label, and
the subalgebra consequences.  It does not derive the tables from projective coordinates or identify
the displayed permutation group with a named abstract group.
-/

namespace RelativeConicArcs
namespace ClebschInformationLattice

/-- Rational-valued functions that are constant on the fibres of a label map. -/
def fibreSubalgebra {Ω ι : Type*} [DecidableEq Ω] (label : Ω → ι) :
    Subalgebra ℚ (Ω → ℚ) where
  carrier := {f | ∀ x y, label x = label y → f x = f y}
  add_mem' := by
    intro f g hf hg x y hxy
    simp [hf x y hxy, hg x y hxy]
  mul_mem' := by
    intro f g hf hg x y hxy
    simp [hf x y hxy, hg x y hxy]
  algebraMap_mem' := by
    intro r x y _
    rfl

/-- Pullback along a surjective label identifies fibre-constant functions with functions on the
label set. -/
noncomputable def fibreSubalgebraLinearEquiv {Ω ι : Type*} [DecidableEq Ω]
    (label : Ω → ι) (surj : Function.Surjective label) :
    (ι → ℚ) ≃ₗ[ℚ] fibreSubalgebra label where
  toFun g := ⟨fun x ↦ g (label x), by
    intro x y hxy
    exact congrArg g hxy⟩
  invFun f i := (f : Ω → ℚ) (Classical.choose (surj i))
  left_inv := by
    intro g
    funext i
    exact congrArg g (Classical.choose_spec (surj i))
  right_inv := by
    intro f
    apply Subtype.ext
    funext x
    exact f.property _ _ (Classical.choose_spec (surj (label x)))
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- The dimension of a fibre-constant function algebra is the cardinality of a surjective finite
label set. -/
theorem fibreSubalgebra_finrank {Ω ι : Type*} [DecidableEq Ω] [Fintype Ω] [Fintype ι]
    (label : Ω → ι) (surj : Function.Surjective label) :
    Module.finrank ℚ (fibreSubalgebra label) = Fintype.card ι := by
  rw [← (fibreSubalgebraLinearEquiv label surj).finrank_eq, Module.finrank_pi]

/-- Refining a label enlarges its fibre-constant function algebra. -/
theorem fibreSubalgebra_mono {Ω ι κ : Type*} [DecidableEq Ω]
    (coarse : Ω → ι) (fine : Ω → κ)
    (refines : ∀ x y, fine x = fine y → coarse x = coarse y) :
    fibreSubalgebra coarse ≤ fibreSubalgebra fine := by
  intro f hf x y hxy
  exact hf x y (refines x y hxy)

namespace B3

/-- An index for the fourteen displayed perfect matchings. -/
abbrev MatchingIndex := Fin 14

/-- An index for the eight vertices on which the matchings are displayed. -/
abbrev Vertex := Fin 8

/-- Mate maps for the fourteen displayed perfect matchings. -/
def matchingMate : MatchingIndex → Vertex → Vertex := ![
  ![1, 0, 4, 6, 2, 7, 3, 5],
  ![1, 0, 5, 7, 6, 2, 4, 3],
  ![2, 4, 0, 7, 1, 6, 5, 3],
  ![2, 5, 0, 4, 3, 1, 7, 6],
  ![3, 6, 7, 0, 5, 4, 1, 2],
  ![3, 7, 4, 0, 2, 6, 5, 1],
  ![4, 2, 1, 5, 0, 3, 7, 6],
  ![4, 6, 3, 2, 0, 7, 1, 5],
  ![5, 2, 1, 6, 7, 0, 3, 4],
  ![5, 7, 6, 4, 3, 0, 2, 1],
  ![6, 3, 5, 1, 7, 2, 0, 4],
  ![6, 4, 7, 5, 1, 3, 0, 2],
  ![7, 3, 6, 1, 5, 4, 2, 0],
  ![7, 5, 3, 2, 6, 1, 4, 0]
]

/-- Every displayed row is a fixed-point-free involution, hence a perfect matching. -/
theorem matchingMate_fixedPointFree_involutive :
    ∀ p v, matchingMate p v ≠ v ∧ matchingMate p (matchingMate p v) = v := by
  decide

/-- The fourteen displayed mate maps are pairwise distinct. -/
theorem matchingMate_injective : Function.Injective matchingMate := by
  decide

/-- The two seven-element sheets. -/
def sheet : MatchingIndex → Fin 2 := ![0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 1, 0]

/-- The accepted labels of the six `K`-orbits. -/
def kOrbitLabel : MatchingIndex → Fin 6 := ![0, 1, 2, 1, 0, 1, 0, 3, 4, 5, 5, 1, 4, 0]

/-- The full action table of `K` on the fourteen matchings. -/
def kAction : Fin 8 → MatchingIndex → MatchingIndex := ![
  ![0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13],
  ![0, 5, 2, 11, 13, 1, 6, 7, 8, 10, 9, 3, 12, 4],
  ![4, 5, 2, 1, 6, 11, 13, 7, 12, 10, 9, 3, 8, 0],
  ![4, 11, 2, 3, 0, 5, 13, 7, 12, 9, 10, 1, 8, 6],
  ![6, 3, 2, 1, 4, 11, 0, 7, 8, 10, 9, 5, 12, 13],
  ![6, 11, 2, 5, 13, 3, 0, 7, 8, 9, 10, 1, 12, 4],
  ![13, 1, 2, 5, 6, 3, 4, 7, 12, 9, 10, 11, 8, 0],
  ![13, 3, 2, 11, 0, 1, 4, 7, 12, 10, 9, 5, 8, 6]
]

/-- The displayed action is closed under composition and inversion and contains the identity. -/
theorem kAction_group_laws :
    (∃ e, ∀ p, kAction e p = p) ∧
    (∀ a b, ∃ c, ∀ p, kAction a (kAction b p) = kAction c p) ∧
    (∀ a, ∃ b, ∀ p, kAction a (kAction b p) = p) := by
  decide

/-- The eight displayed indices act by pairwise distinct permutations. -/
theorem kAction_injective : Function.Injective kAction := by
  decide

/-- Orbit membership under the displayed `K`-action. -/
def SameKOrbit (p r : MatchingIndex) : Prop := ∃ k, kAction k p = r

/-- The displayed action table makes orbit membership an equivalence relation. -/
theorem sameKOrbit_equivalence : Equivalence SameKOrbit := by
  constructor
  · intro p
    refine ⟨0, ?_⟩
    decide +revert
  · intro p r h
    unfold SameKOrbit at h ⊢
    decide +revert
  · intro p r s hpr hrs
    unfold SameKOrbit at hpr hrs ⊢
    decide +revert

/-- The accepted orbit label has exactly the fibres of the displayed `K`-action. -/
theorem sameKOrbit_iff_kOrbitLabel_eq (p r : MatchingIndex) :
    SameKOrbit p r ↔ kOrbitLabel p = kOrbitLabel r := by
  unfold SameKOrbit
  decide +revert

/-- The number of unordered edges common to two displayed matchings. -/
def sharedEdgeCount (p r : MatchingIndex) : Nat :=
  ((Finset.univ.filter fun v : Vertex ↦
    v < matchingMate p v ∧ matchingMate p v = matchingMate r v)).card

/-- The matching fixed as the first reference for shared-edge counts. -/
def baseMatching : MatchingIndex := 2

/-- The matching fixed as the second reference for shared-edge counts. -/
def pairedMatching : MatchingIndex := 7

/-- The intrinsic middle label: sheet together with the two shared-edge counts. -/
def intrinsicProfile (p : MatchingIndex) : Fin 2 × Nat × Nat :=
  (sheet p, sharedEdgeCount p baseMatching, sharedEdgeCount p pairedMatching)

/-- The fibres of `(sheet, shared-edge counts)` are exactly the `K`-orbits. -/
theorem intrinsicProfile_eq_iff_sameKOrbit (p r : MatchingIndex) :
    intrinsicProfile p = intrinsicProfile r ↔ SameKOrbit p r := by
  unfold SameKOrbit
  decide +revert

/-- The edge-count pair alone merges two distinct `K`-orbits; the sheet coordinate is essential. -/
theorem sharedEdgePair_not_complete :
    ∃ p r, (sharedEdgeCount p baseMatching, sharedEdgeCount p pairedMatching) =
        (sharedEdgeCount r baseMatching, sharedEdgeCount r pairedMatching) ∧
      ¬SameKOrbit p r := by
  unfold SameKOrbit
  decide

/-- The constant label at the bottom of the information lattice. -/
def constantLabel (_ : MatchingIndex) : Fin 1 := 0

/-- The singleton label at the top of the information lattice. -/
def singletonLabel (p : MatchingIndex) : MatchingIndex := p

theorem constantLabel_surjective : Function.Surjective constantLabel := by decide
theorem sheet_surjective : Function.Surjective sheet := by decide
theorem kOrbitLabel_surjective : Function.Surjective kOrbitLabel := by decide
theorem singletonLabel_surjective : Function.Surjective singletonLabel := by decide

/-- Every `K`-orbit lies in a single sheet. -/
theorem kOrbitLabel_refines_sheet :
    ∀ p r, kOrbitLabel p = kOrbitLabel r → sheet p = sheet r := by
  decide

/-- The rational invariant-function algebras form the expected inclusion tower. -/
theorem invariantSubalgebra_inclusions :
    fibreSubalgebra constantLabel ≤ fibreSubalgebra sheet ∧
    fibreSubalgebra sheet ≤ fibreSubalgebra kOrbitLabel ∧
    fibreSubalgebra kOrbitLabel ≤ fibreSubalgebra singletonLabel := by
  constructor
  · exact fibreSubalgebra_mono constantLabel sheet (by simp [constantLabel])
  constructor
  · exact fibreSubalgebra_mono sheet kOrbitLabel kOrbitLabel_refines_sheet
  · exact fibreSubalgebra_mono kOrbitLabel singletonLabel (by
      intro p r h
      simpa [singletonLabel] using congrArg kOrbitLabel h)

theorem constantInvariant_finrank :
    Module.finrank ℚ (fibreSubalgebra constantLabel) = 1 := by
  simpa using fibreSubalgebra_finrank constantLabel constantLabel_surjective

theorem sheetInvariant_finrank :
    Module.finrank ℚ (fibreSubalgebra sheet) = 2 := by
  simpa using fibreSubalgebra_finrank sheet sheet_surjective

theorem kOrbitInvariant_finrank :
    Module.finrank ℚ (fibreSubalgebra kOrbitLabel) = 6 := by
  simpa using fibreSubalgebra_finrank kOrbitLabel kOrbitLabel_surjective

theorem fullFunctionAlgebra_finrank :
    Module.finrank ℚ (fibreSubalgebra singletonLabel) = 14 := by
  simpa using fibreSubalgebra_finrank singletonLabel singletonLabel_surjective

/-- The invariant-subalgebra tower is strict and has dimensions `1 < 2 < 6 < 14`. -/
theorem invariantSubalgebra_strictTower :
    fibreSubalgebra constantLabel < fibreSubalgebra sheet ∧
    fibreSubalgebra sheet < fibreSubalgebra kOrbitLabel ∧
    fibreSubalgebra kOrbitLabel < fibreSubalgebra singletonLabel := by
  rcases invariantSubalgebra_inclusions with ⟨h12, h26, h6n⟩
  constructor
  · refine lt_of_le_of_ne h12 ?_
    intro h
    have hf : Module.finrank ℚ (fibreSubalgebra constantLabel) =
        Module.finrank ℚ (fibreSubalgebra sheet) := by rw [h]
    rw [constantInvariant_finrank, sheetInvariant_finrank] at hf
    omega
  constructor
  · refine lt_of_le_of_ne h26 ?_
    intro h
    have hf : Module.finrank ℚ (fibreSubalgebra sheet) =
        Module.finrank ℚ (fibreSubalgebra kOrbitLabel) := by rw [h]
    rw [sheetInvariant_finrank, kOrbitInvariant_finrank] at hf
    omega
  · refine lt_of_le_of_ne h6n ?_
    intro h
    have hf : Module.finrank ℚ (fibreSubalgebra kOrbitLabel) =
        Module.finrank ℚ (fibreSubalgebra singletonLabel) := by rw [h]
    rw [kOrbitInvariant_finrank, fullFunctionAlgebra_finrank] at hf
    omega

end B3
end ClebschInformationLattice
end RelativeConicArcs
