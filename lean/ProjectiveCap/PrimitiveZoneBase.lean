import NodeKayles.GrundyCertificate

/-!
# Primitive-repair nine-vertex zone base

The C79 score-9 arithmetic packet reduces every clean q=17 guard repair to one
isomorphism class of nine-vertex conflict graph.  This file checks its Grundy-zero
claim through the generic reflected Node-Kayles book kernel.
-/

namespace ProjectiveCap.PrimitiveZoneBase

open NodeKayles
open NodeKayles.GrundyBookData

abbrev V := Fin 9

/-- Adjacency masks of the canonical 23-edge zone graph. -/
def adjMask : V → Nat := ![448, 480, 456, 308, 488, 218, 439, 375, 223]

def graph : Graph 9 where
  adj i j := (adjMask i).testBit j
  symm := by decide
  irrefl := by decide

def live (mask : ℕ) : Finset V :=
  Finset.univ.filter fun i => mask.testBit i.val

def mv (i : ℕ) (h : i < 9 := by omega) : V := ⟨i, h⟩

/-- Complete reachable Grundy DAG for the canonical zone. -/
def nodes : List (GrundyBookNode 9) := [
  { position := live 0x1ff, value := 0, lowerMoves := movesOfList [] (by decide) },
  { position := live 0x105, value := 2, lowerMoves := movesOfList [mv 8, mv 0] (by decide) },
  { position := live 0x0c3, value := 2, lowerMoves := movesOfList [mv 6, mv 0] (by decide) },
  { position := live 0x03e, value := 3, lowerMoves := movesOfList [mv 4, mv 3, mv 1] (by decide) },
  { position := live 0x033, value := 3, lowerMoves := movesOfList [mv 1, mv 5, mv 0] (by decide) },
  { position := live 0x032, value := 2, lowerMoves := movesOfList [mv 5, mv 1] (by decide) },
  { position := live 0x020, value := 1, lowerMoves := movesOfList [mv 5] (by decide) },
  { position := live 0x01d, value := 3, lowerMoves := movesOfList [mv 2, mv 3, mv 0] (by decide) },
  { position := live 0x01c, value := 2, lowerMoves := movesOfList [mv 3, mv 2] (by decide) },
  { position := live 0x011, value := 0, lowerMoves := movesOfList [] (by decide) },
  { position := live 0x010, value := 1, lowerMoves := movesOfList [mv 4] (by decide) },
  { position := live 0x008, value := 1, lowerMoves := movesOfList [mv 3] (by decide) },
  { position := live 0x007, value := 1, lowerMoves := movesOfList [mv 0] (by decide) },
  { position := live 0x006, value := 0, lowerMoves := movesOfList [] (by decide) },
  { position := live 0x005, value := 0, lowerMoves := movesOfList [] (by decide) },
  { position := live 0x004, value := 1, lowerMoves := movesOfList [mv 2] (by decide) },
  { position := live 0x003, value := 0, lowerMoves := movesOfList [] (by decide) },
  { position := live 0x002, value := 1, lowerMoves := movesOfList [mv 1] (by decide) },
  { position := live 0x001, value := 1, lowerMoves := movesOfList [mv 0] (by decide) },
  { position := live 0x000, value := 0, lowerMoves := movesOfList [] (by decide) }
]

def book : GrundyBookData 9 where
  root := live 0x1ff
  rootValue := 0
  nodes := nodes

theorem check_book : book.check graph = true := by decide

theorem live_full : live 0x1ff = Finset.univ := by decide

/-- The unique C79 primitive-clean zone base is a Node-Kayles P-position. -/
theorem grundy_zero : grundy graph Finset.univ = 0 := by
  rw [← live_full]
  exact root_grundy_eq_of_check check_book

theorem isP : ¬ win graph Finset.univ := by
  rw [win_iff_grundy_ne_zero]
  simp [grundy_zero]

#print axioms isP

end ProjectiveCap.PrimitiveZoneBase
