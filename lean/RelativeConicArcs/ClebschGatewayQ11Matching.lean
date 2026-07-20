import RelativeConicArcs.ClebschGateway

/-!
# A displayed pair of one-factorizations of `K_12`

The input is a literal table of 22 fixed-point-free mate maps on twelve labels.  Kernel reduction
checks that the rows are distinct perfect matchings and that the two consecutive blocks of eleven
rows are one-factorizations of the complete graph on those labels.

`Parent` below means a row index.  This module does not define projective six-arcs, derive the table
from conic geometry, prove that the index partition is a group-orbit partition, or establish
equivariance.  Consequently its decorated-recovery theorem recovers a table row, not a geometric
parent.  Any geometric identification of these rows is a separate verification obligation.
-/

namespace RelativeConicArcs
namespace ClebschGateway
namespace Q11Matching

open Finset

/-- An index for one of the 22 displayed matching rows. -/
abbrev Parent := Fin 22

/-- A vertex label for the displayed complete graph on twelve vertices. -/
abbrev ChildPoint := Fin 12

/-- A mate map on the twelve displayed vertex labels. -/
abbrev Matching := ChildPoint → ChildPoint

/-- The 22 displayed mate maps.  Their fixed-point-free and involutive properties are proved below.
Rows `0..10` and `11..21` form the two blocks used by `sheet`; no geometric or group-theoretic
meaning for that partition is asserted in this module. -/
def matchingMate : Parent → Matching := ![
  ![1, 0, 11, 10, 9, 8, 7, 6, 5, 4, 3, 2],
  ![2, 6, 0, 5, 8, 3, 1, 11, 4, 10, 9, 7],
  ![3, 5, 6, 0, 11, 1, 2, 9, 10, 7, 8, 4],
  ![4, 2, 1, 7, 0, 10, 8, 3, 6, 11, 5, 9],
  ![5, 11, 8, 4, 3, 0, 9, 10, 2, 6, 7, 1],
  ![6, 9, 10, 8, 7, 11, 0, 4, 3, 1, 2, 5],
  ![7, 3, 4, 1, 2, 9, 10, 0, 11, 5, 6, 8],
  ![8, 7, 9, 11, 10, 6, 5, 1, 0, 2, 4, 3],
  ![9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 11, 10],
  ![10, 4, 5, 9, 1, 2, 11, 8, 7, 3, 0, 6],
  ![11, 10, 3, 2, 6, 7, 4, 5, 9, 8, 1, 0],
  ![1, 0, 6, 7, 10, 11, 2, 3, 9, 8, 4, 5],
  ![2, 4, 0, 11, 1, 8, 10, 9, 5, 7, 6, 3],
  ![3, 10, 5, 0, 7, 2, 9, 4, 11, 6, 1, 8],
  ![4, 9, 7, 5, 0, 3, 11, 2, 10, 1, 8, 6],
  ![5, 3, 10, 1, 9, 0, 8, 11, 6, 4, 2, 7],
  ![6, 7, 3, 2, 8, 9, 0, 1, 4, 5, 11, 10],
  ![7, 8, 11, 9, 6, 10, 4, 0, 1, 3, 5, 2],
  ![8, 5, 4, 6, 2, 1, 3, 10, 0, 11, 7, 9],
  ![9, 6, 8, 10, 11, 7, 1, 5, 2, 0, 3, 4],
  ![10, 11, 9, 8, 5, 4, 7, 6, 3, 2, 0, 1],
  ![11, 2, 1, 4, 3, 6, 5, 8, 7, 10, 9, 0]
]

/-- Every row is fixed-point-free. -/
theorem matchingMate_fixedPointFree :
    ∀ p : Parent, ∀ x : ChildPoint, matchingMate p x ≠ x := by
  decide

/-- Every row is an involution, hence a perfect matching together with fixed-point-freeness. -/
theorem matchingMate_involutive :
    ∀ p : Parent, ∀ x : ChildPoint,
      matchingMate p (matchingMate p x) = x := by
  decide

/-- The 22 matching decorations are pairwise distinct. -/
theorem matchingMate_injective : Function.Injective matchingMate := by
  decide

/-- The chosen partition of the 22 row indices into two consecutive blocks of eleven. -/
def sheet (p : Parent) : Fin 2 :=
  if p.1 < 11 then 0 else 1

/-- The row indices in one block of the chosen binary partition. -/
def sheetParents (s : Fin 2) : Finset Parent :=
  Finset.univ.filter fun p => sheet p = s

/-- Each block of the chosen row partition has eleven elements. -/
theorem sheetParents_card : ∀ s : Fin 2, (sheetParents s).card = 11 := by
  decide

/-- The binary block label does not determine a matching-row index. -/
theorem sheet_not_injective : ¬Function.Injective sheet := by
  decide

/-- Each displayed block is a one-factorization: every ordered pair of distinct vertex labels has
the prescribed mate relation in exactly one of its eleven rows. -/
theorem sheet_edge_unique :
    ∀ s : Fin 2, ∀ x y : ChildPoint, x ≠ y →
      (Finset.univ.filter fun p : Parent =>
        sheet p = s ∧ matchingMate p x = y).card = 1 := by
  decide

/-- Regard a matching row as a decoration of a constant child.  Faithfulness is precisely the
proved injectivity of the displayed mate table. -/
def decoratedTransform : DecoratedTransform Parent PUnit Matching where
  child := fun _ => PUnit.unit
  decoration := matchingMate
  faithful := by
    intro p q h
    exact matchingMate_injective (congrArg Prod.snd h)

/-- Equality of the displayed matching decorations is equivalent to equality of their row
indices.  This statement contains no geometric parent object. -/
theorem decorated_child_recovers_parent {p q : Parent} :
    (decoratedTransform.child p, decoratedTransform.decoration p) =
      (decoratedTransform.child q, decoratedTransform.decoration q) ↔ p = q :=
  decoratedTransform.recovers_parent

#print axioms matchingMate_injective
#print axioms sheetParents_card
#print axioms sheet_edge_unique
#print axioms decorated_child_recovers_parent

end Q11Matching
end ClebschGateway
end RelativeConicArcs
