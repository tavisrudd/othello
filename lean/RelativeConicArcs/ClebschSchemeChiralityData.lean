import Mathlib.Data.ZMod.Basic
import Mathlib.Data.Fin.Tuple.Basic
import Mathlib.Data.Matrix.Basic

/-!
# Frozen data for the six-block Clebsch chirality calculation

This module records six projective directions over `F_11`, two permutations generating
their degree-six icosahedral action, the twenty three-subsets of the six directions, and one
normalizing permutation that exchanges the two ten-element orbits.  The tracked independent replay
and semantic certificate are `ClebschSchemeChirality.py` and `ClebschSchemeChirality.json` in this
directory.  The mathematical checks of the displayed tables are in `ClebschSchemeChirality.lean`.
-/

namespace RelativeConicArcs
namespace ClebschSchemeChirality

/-- Three-coordinate representatives over the eleven-element field model. -/
abbrev SchemeVector := Fin 3 → Fin 11
/-- Indices for the sixty direction-neighbor pairs. -/
abbrev NeighborIndex := Fin 6 × Fin 10

/-- Representatives of the six scalar-line directions, normalized by their first nonzero
coordinate. -/
def direction : Fin 6 → SchemeVector := ![
  ![0, 1, 4], ![0, 1, 7], ![1, 0, 3], ![1, 0, 8], ![1, 4, 0], ![1, 7, 0]]

/-- Two permutations generating the induced degree-six icosahedral action. -/
def blockGenerator : Fin 2 → Fin 6 → Fin 6 := ![
  ![0, 1, 3, 2, 5, 4],
  ![1, 2, 0, 5, 3, 4]]

/-- The twenty three-subsets, ordered with one ten-element orbit followed by the other. -/
def triple : Fin 20 → Finset (Fin 6) := ![
  {0, 1, 2}, {0, 1, 3}, {0, 2, 4}, {0, 3, 5}, {0, 4, 5},
  {1, 2, 5}, {1, 3, 4}, {1, 4, 5}, {2, 3, 4}, {2, 3, 5},
  {0, 1, 4}, {0, 1, 5}, {0, 2, 3}, {0, 2, 5}, {0, 3, 4},
  {1, 2, 3}, {1, 2, 4}, {1, 3, 5}, {2, 4, 5}, {3, 4, 5}]

/-- Action of the two block generators on the ordered twenty triples. -/
def generatorTripleAction : Fin 2 → Fin 20 → Fin 20 := ![
  ![1, 0, 3, 2, 4, 6, 5, 7, 9, 8, 11, 10, 12, 14, 13, 15, 17, 16, 19, 18],
  ![0, 5, 1, 7, 6, 2, 9, 8, 3, 4, 15, 16, 11, 10, 17, 13, 12, 18, 14, 19]]

/-- A degree-six normalizer element of order four outside the displayed generated action. -/
def sheetExchangeBlock : Fin 6 → Fin 6 := ![0, 1, 4, 5, 3, 2]

/-- Action of `sheetExchangeBlock` on the ordered twenty triples. -/
def sheetExchangeTriple : Fin 20 → Fin 20 :=
  ![10, 11, 14, 13, 12, 16, 17, 15, 19, 18, 1, 0, 4, 2, 3, 7, 6, 5, 8, 9]

end ClebschSchemeChirality
end RelativeConicArcs
