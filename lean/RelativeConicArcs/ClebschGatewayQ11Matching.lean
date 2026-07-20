import RelativeConicArcs.ClebschGateway

/-!
# C380 q=11 leaf: matching-decorated parent recovery and the 11+11 sheets

The table is the compact finite interface frozen by C379.  Rows are the 22 parent matchings and
columns are the twelve child-conic points in C379's canonical order.  This leaf proves only the
bounded matching facts needed by C380; it deliberately develops no general biplane foundation.
-/

namespace RelativeConicArcs
namespace ClebschGateway
namespace Q11Matching

open Finset

abbrev Parent := Fin 22
abbrev ChildPoint := Fin 12
abbrev Matching := ChildPoint → ChildPoint

/-- The 22 obstruction matchings as fixed-point-free mate maps.  Rows `0..10` and `11..21` are
the two orientation sheets from C379. -/
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

/-- The binary orientation sheet.  A sheet is a system of eleven parent matchings, not a parent. -/
def sheet (p : Parent) : Fin 2 :=
  if p.1 < 11 then 0 else 1

def sheetParents (s : Fin 2) : Finset Parent :=
  Finset.univ.filter fun p => sheet p = s

/-- Each orientation sheet contains exactly eleven decorated parents. -/
theorem sheetParents_card : ∀ s : Fin 2, (sheetParents s).card = 11 := by
  decide

/-- The binary sheet alone cannot recover an individual parent. -/
theorem sheet_not_injective : ¬Function.Injective sheet := by
  decide

/-- Each sheet is a one-factorization: every edge of `K_12` occurs in exactly one of its eleven
perfect matchings. -/
theorem sheet_edge_unique :
    ∀ s : Fin 2, ∀ x y : ChildPoint, x ≠ y →
      (Finset.univ.filter fun p : Parent =>
        sheet p = s ∧ matchingMate p x = y).card = 1 := by
  decide

/-- The common child plus the obstruction matching is a faithful decorated transform. -/
def decoratedTransform : DecoratedTransform Parent PUnit Matching where
  child := fun _ => PUnit.unit
  decoration := matchingMate
  faithful := by
    intro p q h
    exact matchingMate_injective (congrArg Prod.snd h)

/-- Equality of matching-decorated children is exactly equality of parents. -/
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
