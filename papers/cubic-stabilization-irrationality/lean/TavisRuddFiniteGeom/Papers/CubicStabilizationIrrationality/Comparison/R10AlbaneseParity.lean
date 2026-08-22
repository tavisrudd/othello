import Mathlib.Data.Matrix.Basic
import Mathlib.Data.ZMod.Basic
import Mathlib.Tactic

/-!
# The parity certificate for the reduced `R10` Albanese graph

Let `R10` be represented by the displayed rank-five regular matroid matrix in
Engel--de Gaay Fortman--Schreieder, *Matroids and the integral Hodge
conjecture for abelian varieties* (2026), arXiv:2507.15704v3,
Proposition 7.6.  Their reduced
Albanese graph over `F_2` has 32 vertices, ten colours, and sixteen oriented
edges of every colour.  The admissibility equations form a `160 × 160`
matrix.  Divisibility asks that the sum of the edge coefficients of each
colour vanish.

The ten masks below are explicit row-span witnesses: for every colour, the
corresponding colour-profile row is the sum of the selected admissibility
rows.  `profileMatrix_eq_combination_mul_constraintMatrix` checks all 1,600
coefficients by native evaluation.  The axiom audit reports `propext`,
`Classical.choice`, `Quot.sound`, and the declaration-local native-decision
axiom generated for this theorem.  The symbolic theorem
`colourProfiles_eq_zero_of_constraints_eq_zero` then proves that every
admissible vector has zero colour profile.

This finite result is only the `R10` computation in Proposition 7.6.  The
geometric reduction to this graph, the structure theorem for regular
matroids, and the deduction concerning minimal theta classes remain imported
mathematics.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.R10AlbaneseParity

abbrev F2 := ZMod 2
abbrev Edge := Fin 160
abbrev Constraint := Fin 160
abbrev Colour := Fin 10

/-- The columns of `[Pᵀ | I₅]` for the representation `R10 = [I₅ | P]`,
packed as five-bit natural numbers.  Coordinate zero is the most significant
bit. -/
def dualColumnMask (colour : ℕ) : ℕ :=
  match colour with
  | 0 => 25
  | 1 => 28
  | 2 => 14
  | 3 => 7
  | 4 => 19
  | 5 => 16
  | 6 => 8
  | 7 => 4
  | 8 => 2
  | _ => 1

/-- The components to which an edge of a given colour contributes.  For the
last five colours these are the supports of the corresponding columns of
`R10`, packed with component zero as the least significant bit. -/
def componentMask (colour : ℕ) : ℕ :=
  match colour with
  | 0 => 1
  | 1 => 2
  | 2 => 4
  | 3 => 8
  | 4 => 16
  | 5 => 19
  | 6 => 7
  | 7 => 14
  | 8 => 28
  | _ => 25

/-- Insert a zero at bit position `pivot` in a four-bit integer. -/
def insertZeroBit (value pivot : ℕ) : ℕ :=
  value % 2 ^ pivot + (value / 2 ^ pivot) * 2 ^ (pivot + 1)

/-- Colour of an edge in the order used by the reduced graph. -/
def edgeColour (edge : Edge) : ℕ := edge.val / 16

/-- The first endpoint of an edge.  The reduced orientation chooses the
endpoint whose first nonzero dual-column coordinate is zero. -/
def edgeStart (edge : Edge) : ℕ :=
  let colour := edgeColour edge
  let column := dualColumnMask colour
  insertZeroBit (edge.val % 16) (Nat.log2 column)

/-- The second endpoint of an edge. -/
def edgeEnd (edge : Edge) : ℕ :=
  Nat.xor (edgeStart edge) (dualColumnMask (edgeColour edge))

/-- One coefficient of the `160 × 160` admissibility matrix.  Minus signs
and plus signs agree over `F_2`. -/
def constraintCoefficient (row : Constraint) (edge : Edge) : F2 :=
  let component := row.val / 32
  let vertex := row.val % 32
  if (componentMask (edgeColour edge)).testBit component &&
      (vertex == edgeStart edge || vertex == edgeEnd edge) then 1 else 0

/-- One coefficient of a colour-profile row. -/
def profileCoefficient (colour : Colour) (edge : Edge) : F2 :=
  if edgeColour edge == colour.val then 1 else 0

/-- Packed selections of admissibility rows whose sums are the ten profile
rows.  Bit `i` selects row `i`. -/
def combinationMask (colour : Colour) : ℕ :=
  match colour.val with
  | 0 => 0x003300cc003c003c00000ff0000ff000000ff0ff
  | 1 => 0x003300cc003c003c00000ff0000f0fff000f0f00
  | 2 => 0x003300cc003c003c00ff0f0f000ff00000f0f000
  | 3 => 0x003300cc0f330f3300000ff00f0000f0000f0f00
  | 4 => 0x0033ff33003c003c00000ff0000ff000000f0f00
  | 5 => 0x003300cc003c003c00000ff0000ff000000f0f00
  | 6 => 0x003300cc003c003c00000ff0000ff00000f0f000
  | 7 => 0x003300cc003c003c00000ff00f0000f0000f0f00
  | 8 => 0x003300cc003c003c33cc3c3c000ff00000f0f000
  | _ => 0x003300cc003c003c00000ff0000ff000555aa5aa

/-- The admissibility matrix of the reduced graph. -/
def constraintMatrix : Matrix Constraint Edge F2 := constraintCoefficient

/-- The ten colour-profile rows. -/
def profileMatrix : Matrix Colour Edge F2 := profileCoefficient

/-- The matrix selecting the certified combinations of admissibility rows. -/
def combinationMatrix : Matrix Colour Constraint F2 := fun colour row =>
  if (combinationMask colour).testBit row.val then 1 else 0

/-- The ten explicit masks factor every profile row through the admissibility
matrix.  This checks all coefficients by native evaluation. -/
theorem profileMatrix_eq_combination_mul_constraintMatrix :
    profileMatrix = combinationMatrix * constraintMatrix := by
  native_decide

/-- Every vector satisfying the 160 admissibility equations has zero sum in
each of the ten colour classes. -/
theorem colourProfiles_eq_zero_of_constraints_eq_zero
    (weights : Edge → F2)
    (admissible : constraintMatrix.mulVec weights = 0) :
    profileMatrix.mulVec weights = 0 := by
  rw [profileMatrix_eq_combination_mul_constraintMatrix,
    ← Matrix.mulVec_mulVec, admissible, Matrix.mulVec_zero]

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.R10AlbaneseParity
