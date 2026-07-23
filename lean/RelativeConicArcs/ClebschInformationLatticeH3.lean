import RelativeConicArcs.ClebschInformationLatticeB3
import RelativeConicArcs.ClebschDoubleCosetDepth

/-!
# The six-fibre information lattice on the twenty-two-point matching set

This module checks a displayed finite permutation action on twenty-two perfect matchings of twelve
vertices.  The twelve displayed permutations form the subgroup called `K` here.  Exhaustive native
evaluation proves that two matchings lie in the same `K`-orbit exactly when their sheet labels and
their numbers of edges shared with two distinguished matchings agree.

The constant, sheet, `K`-orbit, and singleton labels yield a strict tower of rational function
subalgebras of dimensions `1 < 2 < 6 < 22`.  The module imports the public six-profile
matching-depth terminal, but makes no identification between its depth coordinates and the
shared-edge coordinates checked here.

The matching, sheet, and permutation tables are accepted finite data.  Lean checks every displayed
entry, the permutation-group laws, the quantified fibre identity, surjectivity of every label, and
the subalgebra consequences.  It does not derive the tables from projective coordinates or identify
the displayed permutation group with a named abstract group.
-/

namespace RelativeConicArcs
namespace ClebschInformationLattice
namespace H3

/-- An index for the twenty-two displayed perfect matchings. -/
abbrev MatchingIndex := Fin 22

/-- An index for the twelve vertices on which the matchings are displayed. -/
abbrev Vertex := Fin 12

/-- Mate maps for the twenty-two displayed perfect matchings. -/
def matchingMate : MatchingIndex → Vertex → Vertex := ![
  ![1, 0, 5, 7, 9, 2, 8, 3, 6, 4, 11, 10],
  ![1, 0, 11, 8, 6, 9, 4, 10, 3, 5, 7, 2],
  ![2, 5, 0, 6, 10, 1, 3, 8, 7, 11, 4, 9],
  ![2, 8, 0, 9, 11, 6, 5, 10, 1, 3, 7, 4],
  ![3, 5, 7, 0, 6, 1, 4, 2, 11, 10, 9, 8],
  ![3, 7, 9, 0, 5, 4, 11, 1, 10, 2, 8, 6],
  ![4, 6, 10, 5, 0, 3, 1, 11, 9, 8, 2, 7],
  ![4, 10, 5, 9, 0, 2, 7, 6, 11, 3, 1, 8],
  ![5, 3, 6, 1, 7, 0, 2, 4, 9, 8, 11, 10],
  ![5, 9, 4, 10, 2, 0, 11, 8, 7, 1, 3, 6],
  ![6, 8, 10, 4, 3, 11, 0, 9, 1, 7, 2, 5],
  ![6, 11, 3, 2, 7, 9, 0, 4, 10, 5, 8, 1],
  ![7, 9, 3, 2, 11, 10, 8, 0, 6, 1, 5, 4],
  ![7, 10, 8, 11, 5, 4, 9, 0, 2, 6, 1, 3],
  ![8, 2, 1, 11, 9, 7, 10, 5, 0, 4, 6, 3],
  ![8, 3, 9, 1, 10, 11, 7, 6, 0, 2, 4, 5],
  ![9, 4, 8, 10, 1, 6, 5, 11, 2, 0, 3, 7],
  ![9, 7, 11, 4, 3, 8, 10, 1, 5, 0, 6, 2],
  ![10, 4, 6, 8, 1, 7, 2, 5, 3, 11, 0, 9],
  ![10, 11, 7, 5, 8, 3, 9, 2, 4, 6, 0, 1],
  ![11, 2, 1, 6, 8, 10, 3, 9, 4, 7, 5, 0],
  ![11, 6, 4, 7, 2, 8, 1, 3, 5, 10, 9, 0]
]

/-- Every displayed row is a fixed-point-free involution, hence a perfect matching. -/
theorem matchingMate_fixedPointFree_involutive :
    ∀ p v, matchingMate p v ≠ v ∧ matchingMate p (matchingMate p v) = v := by
  native_decide

/-- The twenty-two displayed mate maps are pairwise distinct. -/
theorem matchingMate_injective : Function.Injective matchingMate := by
  native_decide

/-- The two eleven-element sheets. -/
def sheet : MatchingIndex → Fin 2 :=
  ![0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 1]

/-- The accepted labels of the six `K`-orbits. -/
def kOrbitLabel : MatchingIndex → Fin 6 :=
  ![0, 1, 2, 3, 3, 4, 5, 1, 1, 3, 4, 5, 1, 5, 1, 3, 4, 5, 3, 4, 3, 1]

/-- The full action table of `K` on the twenty-two matchings. -/
def kAction : Fin 12 → MatchingIndex → MatchingIndex := ![
  ![0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21],
  ![0, 1, 2, 4, 3, 10, 13, 7, 14, 20, 5, 17, 21, 6, 8, 15, 19, 11, 18, 16, 9, 12],
  ![0, 7, 2, 3, 4, 19, 17, 1, 14, 20, 16, 13, 12, 11, 8, 18, 10, 6, 15, 5, 9, 21],
  ![0, 7, 2, 4, 3, 16, 11, 1, 8, 9, 19, 6, 21, 17, 14, 18, 5, 13, 15, 10, 20, 12],
  ![0, 8, 2, 15, 18, 19, 17, 14, 21, 4, 10, 6, 7, 13, 12, 20, 5, 11, 9, 16, 3, 1],
  ![0, 8, 2, 18, 15, 10, 13, 14, 12, 3, 19, 11, 1, 17, 21, 20, 16, 6, 9, 5, 4, 7],
  ![0, 12, 2, 9, 20, 19, 17, 21, 1, 18, 5, 11, 8, 6, 7, 4, 16, 13, 3, 10, 15, 14],
  ![0, 12, 2, 20, 9, 5, 6, 21, 7, 15, 19, 13, 14, 17, 1, 4, 10, 11, 3, 16, 18, 8],
  ![0, 14, 2, 15, 18, 16, 11, 8, 12, 3, 5, 13, 7, 6, 21, 9, 10, 17, 20, 19, 4, 1],
  ![0, 14, 2, 18, 15, 5, 6, 8, 21, 4, 16, 17, 1, 11, 12, 9, 19, 13, 20, 10, 3, 7],
  ![0, 21, 2, 9, 20, 10, 13, 12, 7, 15, 16, 6, 8, 11, 1, 3, 5, 17, 4, 19, 18, 14],
  ![0, 21, 2, 20, 9, 16, 11, 12, 1, 18, 10, 17, 14, 13, 7, 3, 19, 6, 4, 5, 15, 8]
]

/-- The displayed action is closed under composition and inversion and contains the identity. -/
theorem kAction_group_laws :
    (∃ e, ∀ p, kAction e p = p) ∧
    (∀ a b, ∃ c, ∀ p, kAction a (kAction b p) = kAction c p) ∧
    (∀ a, ∃ b, ∀ p, kAction a (kAction b p) = p) := by
  native_decide

/-- Every displayed permutation has a two-sided inverse in the displayed action table. -/
theorem kAction_twoSidedInverse :
    ∀ a, ∃ b, (∀ p, kAction a (kAction b p) = p) ∧
      (∀ p, kAction b (kAction a p) = p) := by
  native_decide

/-- The twelve displayed indices act by pairwise distinct permutations. -/
theorem kAction_injective : Function.Injective kAction := by
  native_decide

/-- Orbit membership under the displayed `K`-action. -/
def SameKOrbit (p r : MatchingIndex) : Prop := ∃ k, kAction k p = r

/-- The displayed action table makes orbit membership an equivalence relation. -/
theorem sameKOrbit_equivalence : Equivalence SameKOrbit := by
  rcases kAction_group_laws with ⟨⟨e, he⟩, hcomp, _⟩
  constructor
  · intro p
    exact ⟨e, he p⟩
  · intro p r h
    rcases h with ⟨a, ha⟩
    rcases kAction_twoSidedInverse a with ⟨b, _, hba⟩
    refine ⟨b, ?_⟩
    rw [← ha]
    exact hba p
  · intro p r s hpr hrs
    rcases hpr with ⟨a, ha⟩
    rcases hrs with ⟨b, hb⟩
    rcases hcomp b a with ⟨c, hc⟩
    refine ⟨c, ?_⟩
    rw [← hc p, ha, hb]

/-- The accepted orbit label has exactly the fibres of the displayed `K`-action. -/
theorem sameKOrbit_iff_kOrbitLabel_eq (p r : MatchingIndex) :
    SameKOrbit p r ↔ kOrbitLabel p = kOrbitLabel r := by
  unfold SameKOrbit
  native_decide +revert

/-- The number of unordered edges common to two displayed matchings. -/
def sharedEdgeCount (p r : MatchingIndex) : Nat :=
  ((Finset.univ.filter fun v : Vertex ↦
    v < matchingMate p v ∧ matchingMate p v = matchingMate r v)).card

/-- The matching fixed as the first reference for shared-edge counts. -/
def baseMatching : MatchingIndex := 0

/-- The matching fixed as the second reference for shared-edge counts. -/
def pairedMatching : MatchingIndex := 2

/-- The intrinsic middle label: sheet together with the two shared-edge counts. -/
def intrinsicProfile (p : MatchingIndex) : Fin 2 × Nat × Nat :=
  (sheet p, sharedEdgeCount p baseMatching, sharedEdgeCount p pairedMatching)

/-- Kernel-checked values of the relative shared-edge profile on all twenty-two matchings. -/
theorem intrinsicProfile_values : intrinsicProfile = ![
    (0, 6, 0), (1, 1, 0), (1, 0, 6), (0, 0, 1), (0, 0, 1), (1, 0, 0),
    (0, 0, 0), (1, 1, 0), (1, 1, 0), (0, 0, 1), (1, 0, 0), (0, 0, 0),
    (1, 1, 0), (0, 0, 0), (1, 1, 0), (0, 0, 1), (1, 0, 0), (0, 0, 0),
    (0, 0, 1), (1, 0, 0), (0, 0, 1), (1, 1, 0)
  ] := by
  native_decide

/-- The fibres of `(sheet, shared-edge counts)` are exactly the `K`-orbits. -/
theorem intrinsicProfile_eq_iff_sameKOrbit (p r : MatchingIndex) :
    intrinsicProfile p = intrinsicProfile r ↔ SameKOrbit p r := by
  rw [intrinsicProfile_values]
  unfold SameKOrbit
  native_decide +revert

/-- The edge-count pair alone merges two distinct `K`-orbits; the sheet coordinate is essential. -/
theorem sharedEdgePair_not_complete :
    ∃ p r, (sharedEdgeCount p baseMatching, sharedEdgeCount p pairedMatching) =
        (sharedEdgeCount r baseMatching, sharedEdgeCount r pairedMatching) ∧
      ¬SameKOrbit p r := by
  refine ⟨5, 6, ?_, ?_⟩
  · native_decide
  · unfold SameKOrbit
    native_decide

/-- The constant label at the bottom of the information lattice. -/
def constantLabel (_ : MatchingIndex) : Fin 1 := 0

/-- The singleton label at the top of the information lattice. -/
def singletonLabel (p : MatchingIndex) : MatchingIndex := p

theorem constantLabel_surjective : Function.Surjective constantLabel := by native_decide
theorem sheet_surjective : Function.Surjective sheet := by native_decide
theorem kOrbitLabel_surjective : Function.Surjective kOrbitLabel := by native_decide
theorem singletonLabel_surjective : Function.Surjective singletonLabel := by native_decide

/-- Every `K`-orbit lies in a single sheet. -/
theorem kOrbitLabel_refines_sheet :
    ∀ p r, kOrbitLabel p = kOrbitLabel r → sheet p = sheet r := by
  native_decide

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
    Module.finrank ℚ (fibreSubalgebra singletonLabel) = 22 := by
  simpa using fibreSubalgebra_finrank singletonLabel singletonLabel_surjective

/-- The invariant-subalgebra tower is strict and has dimensions `1 < 2 < 6 < 22`. -/
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

end H3
end ClebschInformationLattice
end RelativeConicArcs
