import ProjectiveCap.CertCheck

namespace ProjectiveCap
namespace Certificate
namespace CertData
namespace Q13

instance : Fact (Nat.Prime 13) := Fact.mk (by decide)

abbrev K := ZMod 13
abbrev P := GridPoint K

def pt (r c : Nat) : P := ((r : K), (c : K))

def allCellsChunk0 : List P :=
  ([pt 0 0, pt 0 1, pt 0 2, pt 0 3, pt 0 4, pt 0 5, pt 0 6, pt 0 7, pt 0 8, pt 0 9, pt 0 10] : List (P))
def allCellsChunk1 : List P :=
  ([pt 0 11, pt 0 12, pt 1 0, pt 1 1, pt 1 2, pt 1 3, pt 1 4, pt 1 5, pt 1 6, pt 1 7, pt 1 8] : List (P))
def allCellsChunk2 : List P :=
  ([pt 1 9, pt 1 10, pt 1 11, pt 1 12, pt 2 0, pt 2 1, pt 2 2, pt 2 3, pt 2 4, pt 2 5, pt 2 6] : List (P))
def allCellsChunk3 : List P :=
  ([pt 2 7, pt 2 8, pt 2 9, pt 2 10, pt 2 11, pt 2 12, pt 3 0, pt 3 1, pt 3 2, pt 3 3, pt 3 4] : List (P))
def allCellsChunk4 : List P :=
  ([pt 3 5, pt 3 6, pt 3 7, pt 3 8, pt 3 9, pt 3 10, pt 3 11, pt 3 12, pt 4 0, pt 4 1, pt 4 2] : List (P))
def allCellsChunk5 : List P :=
  ([pt 4 3, pt 4 4, pt 4 5, pt 4 6, pt 4 7, pt 4 8, pt 4 9, pt 4 10, pt 4 11, pt 4 12, pt 5 0] : List (P))
def allCellsChunk6 : List P :=
  ([pt 5 1, pt 5 2, pt 5 3, pt 5 4, pt 5 5, pt 5 6, pt 5 7, pt 5 8, pt 5 9, pt 5 10, pt 5 11] : List (P))
def allCellsChunk7 : List P :=
  ([pt 5 12, pt 6 0, pt 6 1, pt 6 2, pt 6 3, pt 6 4, pt 6 5, pt 6 6, pt 6 7, pt 6 8, pt 6 9] : List (P))
def allCellsChunk8 : List P :=
  ([pt 6 10, pt 6 11, pt 6 12, pt 7 0, pt 7 1, pt 7 2, pt 7 3, pt 7 4, pt 7 5, pt 7 6, pt 7 7] : List (P))
def allCellsChunk9 : List P :=
  ([pt 7 8, pt 7 9, pt 7 10, pt 7 11, pt 7 12, pt 8 0, pt 8 1, pt 8 2, pt 8 3, pt 8 4, pt 8 5] : List (P))
def allCellsChunk10 : List P :=
  ([pt 8 6, pt 8 7, pt 8 8, pt 8 9, pt 8 10, pt 8 11, pt 8 12, pt 9 0, pt 9 1, pt 9 2, pt 9 3] : List (P))
def allCellsChunk11 : List P :=
  ([pt 9 4, pt 9 5, pt 9 6, pt 9 7, pt 9 8, pt 9 9, pt 9 10, pt 9 11, pt 9 12, pt 10 0, pt 10 1] : List (P))
def allCellsChunk12 : List P :=
  ([pt 10 2, pt 10 3, pt 10 4, pt 10 5, pt 10 6, pt 10 7, pt 10 8, pt 10 9, pt 10 10, pt 10 11, pt 10 12] : List (P))
def allCellsChunk13 : List P :=
  ([pt 11 0, pt 11 1, pt 11 2, pt 11 3, pt 11 4, pt 11 5, pt 11 6, pt 11 7, pt 11 8, pt 11 9, pt 11 10] : List (P))
def allCellsChunk14 : List P :=
  ([pt 11 11, pt 11 12, pt 12 0, pt 12 1, pt 12 2, pt 12 3, pt 12 4, pt 12 5, pt 12 6, pt 12 7, pt 12 8] : List (P))
def allCellsChunk15 : List P :=
  ([pt 12 9, pt 12 10, pt 12 11, pt 12 12] : List (P))
def allCellChunks : List (List P) :=
  ([allCellsChunk0, allCellsChunk1, allCellsChunk2, allCellsChunk3, allCellsChunk4, allCellsChunk5, allCellsChunk6, allCellsChunk7, allCellsChunk8, allCellsChunk9, allCellsChunk10, allCellsChunk11, allCellsChunk12, allCellsChunk13, allCellsChunk14, allCellsChunk15] : List (List P))
def allCells : List P :=
  allCellChunks.flatten
theorem allCells_mem (x : GridPoint K) : x ∈ allCells := by
  rcases x with ⟨r, c⟩
  fin_cases r <;> fin_cases c <;> decide

end Q13
end CertData
end Certificate
end ProjectiveCap
