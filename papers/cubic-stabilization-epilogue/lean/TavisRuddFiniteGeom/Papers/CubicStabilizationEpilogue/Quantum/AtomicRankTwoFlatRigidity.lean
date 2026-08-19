import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.AtomicElementaryModification
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.RankTwoResidueRigidity

/-!
# Flatness freezes the residue discriminant of a rank-two atomic factor

This module derives, from flatness of the connection alone, the rigidity of the
residue of the canonical elementary modification of an even rank-two atomic
factor: the modified connection has no pole in a base direction, its residue
satisfies a Lax equation with a regular matrix, and consequently the residue
discriminant is annihilated by every derivation of the coefficient ring.

## Objects and conventions

The connection is presented in the formal model of `FormalLoopConnection`: the
loop and base directions of the centered factor are the power series obtained
from the connection matrices by clearing their simple poles, and flatness is the
single series identity `IsFlatPair`.  The frame is adapted to the leading
operator, meaning that the leading coefficient of the loop direction is
`adaptedLeadingOperator` of a unit: the matrix whose only nonzero entry is the
upper-right one, whose square vanishes and whose kernel and image are the first
coordinate line.  The elementary modification is the one of
`AtomicElementaryModification`.

Two invertibility hypotheses appear.  The upper-right entry of the leading
operator is a unit, which is the manuscript's generic nonvanishing of the
nilpotent part on the open locus where the modification is performed, and `2` is
a unit in the coefficient ring, which holds in the characteristic-zero
coefficient fields the manuscript works over and is what forces a trace-free
matrix commuting with the leading operator to be one of its multiples.

## Results

Flatness gives that the leading base coefficient commutes with the leading loop
coefficient and has vanishing trace; in the adapted frame those two facts make
it a multiple of the leading loop coefficient, so its diagonal and its
lower-left entry vanish.  That is exactly the hypothesis under which the
modification transports the base direction, and flatness of the transformed pair
then forces the residual pole of the base direction to vanish, because the
upper-right entry of the modified residue is the unit of the leading operator.
With no pole left, the next order of flatness is the Lax equation for the
modified residue, and trace and determinant are unchanged by an infinitesimal
conjugation, so the residue discriminant is constant along the base.

Lean constructs no `F`-bundle, spectral cover, atomic factor, or geometric
lattice: the hypotheses are the formal shape of the connection in an adapted
frame, and the geometric statements that an atomic factor supplies such data are
assumed wherever they are used.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

open Matrix PowerSeries

variable {B : Type*} [CommRing B]

/-- The leading operator of a rank-two atomic factor in an adapted frame: the
matrix whose only nonzero entry is the upper-right one. -/
def adaptedLeadingOperator (unitValue : B) : Matrix (Fin 2) (Fin 2) B := !![0, unitValue; 0, 0]

/-- The adapted leading operator has square zero. -/
theorem adaptedLeadingOperator_mul_self (unitValue : B) :
    adaptedLeadingOperator unitValue * adaptedLeadingOperator unitValue = 0 := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp [adaptedLeadingOperator, Matrix.mul_apply, Fin.sum_univ_two]

/-- The adapted leading operator has vanishing trace. -/
theorem trace_adaptedLeadingOperator (unitValue : B) :
    trace (adaptedLeadingOperator unitValue) = 0 := by
  simp [adaptedLeadingOperator, Matrix.trace_fin_two]

/-- A trace-free matrix commuting with the adapted leading operator is a
multiple of it: its lower-left entry and both diagonal entries vanish.  This is
the commutant computation of the manuscript, in the frame where the leading
operator is a unit multiple of the upper-right matrix unit. -/
theorem entries_eq_zero_of_commutes_adaptedLeadingOperator {unitValue : B}
    (unitProperty : IsUnit unitValue) (twoUnit : IsUnit (2 : B))
    {companion : Matrix (Fin 2) (Fin 2) B}
    (commuting : adaptedLeadingOperator unitValue * companion
      = companion * adaptedLeadingOperator unitValue)
    (traceZero : trace companion = 0) :
    companion 1 0 = 0 ∧ companion 0 0 = 0 ∧ companion 1 1 = 0 := by
  have lowerLeft : unitValue * companion 1 0 = 0 := by
    have entry := congrFun (congrFun commuting 0) 0
    simpa [adaptedLeadingOperator, Matrix.mul_apply, Fin.sum_univ_two] using entry
  have lowerLeftZero : companion 1 0 = 0 := by
    rcases unitProperty.exists_left_inv with ⟨inverse, inverseProperty⟩
    calc companion 1 0 = inverse * (unitValue * companion 1 0) := by
          rw [← mul_assoc, inverseProperty, one_mul]
      _ = 0 := by rw [lowerLeft, mul_zero]
  have diagonal : unitValue * (companion 1 1 - companion 0 0) = 0 := by
    have entry := congrFun (congrFun commuting 0) 1
    simp [adaptedLeadingOperator, Matrix.mul_apply, Fin.sum_univ_two] at entry
    linear_combination entry
  have diagonalEqual : companion 1 1 = companion 0 0 := by
    rcases unitProperty.exists_left_inv with ⟨inverse, inverseProperty⟩
    have difference : companion 1 1 - companion 0 0 = 0 := by
      calc companion 1 1 - companion 0 0
          = inverse * (unitValue * (companion 1 1 - companion 0 0)) := by
            rw [← mul_assoc, inverseProperty, one_mul]
        _ = 0 := by rw [diagonal, mul_zero]
    linear_combination difference
  have doubled : (2 : B) * companion 0 0 = 0 := by
    have expansion : companion 0 0 + companion 1 1 = 0 := by
      simpa [Matrix.trace_fin_two] using traceZero
    linear_combination expansion - diagonalEqual
  have upperLeftZero : companion 0 0 = 0 := by
    rcases twoUnit.exists_left_inv with ⟨inverse, inverseProperty⟩
    calc companion 0 0 = inverse * ((2 : B) * companion 0 0) := by
          rw [← mul_assoc, inverseProperty, one_mul]
      _ = 0 := by rw [doubled, mul_zero]
  exact ⟨lowerLeftZero, upperLeftZero, by rw [diagonalEqual, upperLeftZero]⟩

/-- In an adapted frame the identity `N A N = 0`, which the horizontal pairing
supplies for the regular coefficient of the loop direction, is exactly the
vanishing of the lower-left entry of that coefficient. -/
theorem lowerLeft_eq_zero_of_adapted_sandwich {unitValue : B} (unitProperty : IsUnit unitValue)
    {regular : Matrix (Fin 2) (Fin 2) B}
    (sandwich : adaptedLeadingOperator unitValue * regular * adaptedLeadingOperator unitValue = 0) :
    regular 1 0 = 0 := by
  have entry : unitValue * (unitValue * regular 1 0) = 0 := by
    have value := congrFun (congrFun sandwich 0) 1
    simpa [adaptedLeadingOperator, Matrix.mul_apply, Fin.sum_univ_two, Matrix.vecMul,
      dotProduct, mul_comm, mul_assoc] using value
  rcases unitProperty.exists_left_inv with ⟨inverse, inverseProperty⟩
  have once : unitValue * regular 1 0 = 0 := by
    calc unitValue * regular 1 0 = inverse * (unitValue * (unitValue * regular 1 0)) := by
          rw [← mul_assoc, inverseProperty, one_mul]
      _ = 0 := by rw [entry, mul_zero]
  calc regular 1 0 = inverse * (unitValue * regular 1 0) := by
        rw [← mul_assoc, inverseProperty, one_mul]
    _ = 0 := by rw [once, mul_zero]

/-- The trace of a commutator vanishes. -/
theorem trace_commutator_eq_zero (left right : Matrix (Fin 2) (Fin 2) B) :
    trace (left * right - right * left) = 0 := by
  rw [Matrix.trace_sub, Matrix.trace_mul_comm, sub_self]

/-- Flatness forces the leading coefficient of a base direction to be a multiple
of the leading loop coefficient: its lower-left entry and both diagonal entries
vanish.  The commutation comes from the coefficient of `u ^ (-2)` of flatness
and the vanishing trace from the coefficient of `u ^ (-1)`. -/
theorem baseLeadingCoefficient_entries_eq_zero_of_isFlatPair {derivation : B → B}
    (zeroValue : derivation 0 = 0)
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    {loop base : PowerSeries (Matrix (Fin 2) (Fin 2) B)} {unitValue : B}
    (unitProperty : IsUnit unitValue) (twoUnit : IsUnit (2 : B))
    (adapted : coeff 0 loop = adaptedLeadingOperator unitValue)
    (flat : IsFlatPair derivation loop base) :
    (coeff 0 base) 1 0 = 0 ∧ (coeff 0 base) 0 0 = 0 ∧ (coeff 0 base) 1 1 = 0 := by
  have commuting : adaptedLeadingOperator unitValue * coeff 0 base
      = coeff 0 base * adaptedLeadingOperator unitValue := by
    have identity := leadingCoefficients_commute_of_isFlatPair flat
    rw [adapted] at identity
    exact sub_eq_zero.mp identity
  have traceZero : trace (coeff 0 base) = 0 := by
    have identity := firstOrder_identity_of_isFlatPair flat
    have traced := congrArg trace identity
    rw [Matrix.trace_add, Matrix.trace_add, Matrix.trace_add, trace_commutator_eq_zero,
      trace_commutator_eq_zero, Matrix.trace_zero, add_zero, add_zero] at traced
    have mapped : trace ((coeff 0 loop).map derivation) = 0 := by
      rw [← trace_map_of_additive additive, adapted, trace_adaptedLeadingOperator, zeroValue]
    linear_combination traced - mapped
  exact entries_eq_zero_of_commutes_adaptedLeadingOperator unitProperty twoUnit commuting traceZero

/-- The upper-right entry of the modified residue is the unit of the adapted
leading operator. -/
theorem modifiedResidue_upperRight {loop : PowerSeries (Matrix (Fin 2) (Fin 2) B)} {unitValue : B}
    (adapted : coeff 0 loop = adaptedLeadingOperator unitValue) :
    (modifiedResidue loop) 0 1 = unitValue := by
  rw [modifiedResidue_eq, adapted]
  simp [adaptedLeadingOperator]

/-- After the elementary modification the base direction has no pole.  The
coefficient of `u ^ (-1)` of flatness in the modified lattice is the identity
`K + [R, K] = 0` for the residual pole `K` and the modified residue `R`, and the
upper-right entry of `R` is a unit, so `K` vanishes. -/
theorem modifiedBase_leadingCoefficient_eq_zero_of_isFlatPair {derivation : B → B}
    (zeroValue : derivation 0 = 0) (oneValue : derivation 1 = 0)
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (leibniz : ∀ x y, derivation (x * y) = derivation x * y + x * derivation y)
    {loop base : PowerSeries (Matrix (Fin 2) (Fin 2) B)} {unitValue : B}
    (unitProperty : IsUnit unitValue) (twoUnit : IsUnit (2 : B))
    (adapted : coeff 0 loop = adaptedLeadingOperator unitValue)
    (nilpotentLine : (coeff 1 loop) 1 0 = 0)
    (flat : IsFlatPair derivation loop base) :
    coeff 0 (modifiedBase base) = 0 := by
  obtain ⟨baseLowerLeft, baseUpperLeft, baseLowerRight⟩ :=
    baseLeadingCoefficient_entries_eq_zero_of_isFlatPair zeroValue additive unitProperty twoUnit
      adapted flat
  have leadingUpperLeft : (coeff 0 loop) 0 0 = 0 := by
    rw [adapted]; simp [adaptedLeadingOperator]
  have leadingLowerLeft : (coeff 0 loop) 1 0 = 0 := by
    rw [adapted]; simp [adaptedLeadingOperator]
  have leadingLowerRight : (coeff 0 loop) 1 1 = 0 := by
    rw [adapted]; simp [adaptedLeadingOperator]
  have modifiedFlat := isFlatPair_modified zeroValue oneValue additive leibniz
    leadingUpperLeft leadingLowerLeft leadingLowerRight nilpotentLine baseLowerLeft flat
  have identity := firstOrder_identity_of_isFlatPair modifiedFlat
  have zeroLoop : coeff 0 (PowerSeries.X * modifiedLoop loop) = 0 :=
    PowerSeries.coeff_zero_X_mul _
  have residueCoefficient : coeff 1 (PowerSeries.X * modifiedLoop loop) = modifiedResidue loop :=
    PowerSeries.coeff_succ_X_mul 0 _
  have zeroMap : ((0 : Matrix (Fin 2) (Fin 2) B)).map derivation = 0 := by
    ext row column
    simp [zeroValue]
  rw [zeroLoop, residueCoefficient, zeroMap, zero_add, zero_mul, mul_zero, sub_zero,
    add_zero] at identity
  have poleShape : coeff 0 (modifiedBase base)
      = !![0, 0; (coeff 1 base) 1 0, 0] := by
    rw [modifiedBase, PowerSeries.coeff_mk, baseUpperLeft, baseLowerRight]
    simp
  rw [poleShape] at identity
  have entry := congrFun (congrFun identity 0) 0
  have upperRight : (modifiedResidue loop) 0 1 = unitValue := modifiedResidue_upperRight adapted
  have product : unitValue * (coeff 1 base) 1 0 = 0 := by
    simp [Matrix.add_apply, Matrix.sub_apply, Matrix.mul_apply, Fin.sum_univ_two,
      Matrix.vecMul, dotProduct, upperRight] at entry
    linear_combination entry
  have valueZero : (coeff 1 base) 1 0 = 0 := by
    rcases unitProperty.exists_left_inv with ⟨inverse, inverseProperty⟩
    calc (coeff 1 base) 1 0 = inverse * (unitValue * (coeff 1 base) 1 0) := by
          rw [← mul_assoc, inverseProperty, one_mul]
      _ = 0 := by rw [product, mul_zero]
  rw [poleShape, valueZero]
  ext row column
  fin_cases row <;> fin_cases column <;> simp

/-- The Lax equation for the modified residue.  Once the base direction has no
pole, the next order of flatness in the modified lattice says that a derivation
of the coefficient ring carries the modified residue to its commutator with the
regular coefficient of the modified base direction. -/
theorem modifiedResidue_lax_of_isFlatPair {derivation : B → B}
    (zeroValue : derivation 0 = 0) (oneValue : derivation 1 = 0)
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (leibniz : ∀ x y, derivation (x * y) = derivation x * y + x * derivation y)
    {loop base : PowerSeries (Matrix (Fin 2) (Fin 2) B)} {unitValue : B}
    (unitProperty : IsUnit unitValue) (twoUnit : IsUnit (2 : B))
    (adapted : coeff 0 loop = adaptedLeadingOperator unitValue)
    (nilpotentLine : (coeff 1 loop) 1 0 = 0)
    (flat : IsFlatPair derivation loop base) :
    (modifiedResidue loop).map derivation
      = coeff 1 (modifiedBase base) * modifiedResidue loop
        - modifiedResidue loop * coeff 1 (modifiedBase base) := by
  obtain ⟨baseLowerLeft, _, _⟩ :=
    baseLeadingCoefficient_entries_eq_zero_of_isFlatPair zeroValue additive unitProperty twoUnit
      adapted flat
  have leadingUpperLeft : (coeff 0 loop) 0 0 = 0 := by
    rw [adapted]; simp [adaptedLeadingOperator]
  have leadingLowerLeft : (coeff 0 loop) 1 0 = 0 := by
    rw [adapted]; simp [adaptedLeadingOperator]
  have leadingLowerRight : (coeff 0 loop) 1 1 = 0 := by
    rw [adapted]; simp [adaptedLeadingOperator]
  have modifiedFlat := isFlatPair_modified zeroValue oneValue additive leibniz
    leadingUpperLeft leadingLowerLeft leadingLowerRight nilpotentLine baseLowerLeft flat
  have poleVanishes : coeff 0 (modifiedBase base) = 0 :=
    modifiedBase_leadingCoefficient_eq_zero_of_isFlatPair zeroValue oneValue additive leibniz
      unitProperty twoUnit adapted nilpotentLine flat
  have identity := secondOrder_identity_of_isFlatPair modifiedFlat
  have zeroLoop : coeff 0 (PowerSeries.X * modifiedLoop loop) = 0 :=
    PowerSeries.coeff_zero_X_mul _
  have residueCoefficient : coeff 1 (PowerSeries.X * modifiedLoop loop) = modifiedResidue loop :=
    PowerSeries.coeff_succ_X_mul 0 _
  rw [zeroLoop, residueCoefficient, poleVanishes] at identity
  simp only [zero_mul, mul_zero, sub_self, add_zero] at identity
  have expanded : (modifiedResidue loop).map derivation
      + (modifiedResidue loop * coeff 1 (modifiedBase base)
        - coeff 1 (modifiedBase base) * modifiedResidue loop) = 0 := identity
  linear_combination (norm := abel) expanded

/-- Flatness freezes the residue discriminant of an even rank-two atomic factor.
Every derivation of the coefficient ring annihilates the discriminant of the
residue of the canonical elementary modification, because that residue satisfies
a Lax equation and the trace and determinant of a matrix are unchanged by an
infinitesimal conjugation. -/
theorem residueDiscriminant_modifiedResidue_map_eq_zero_of_isFlatPair {derivation : B → B}
    (zeroValue : derivation 0 = 0) (oneValue : derivation 1 = 0)
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (leibniz : ∀ x y, derivation (x * y) = derivation x * y + x * derivation y)
    {loop base : PowerSeries (Matrix (Fin 2) (Fin 2) B)} {unitValue : B}
    (unitProperty : IsUnit unitValue) (twoUnit : IsUnit (2 : B))
    (adapted : coeff 0 loop = adaptedLeadingOperator unitValue)
    (nilpotentLine : (coeff 1 loop) 1 0 = 0)
    (flat : IsFlatPair derivation loop base) :
    derivation (residueDiscriminant (modifiedResidue loop)) = 0 :=
  lax_residueDiscriminant_map_eq_zero additive leibniz (modifiedResidue loop)
    (coeff 1 (modifiedBase base))
    (modifiedResidue_lax_of_isFlatPair zeroValue oneValue additive leibniz unitProperty twoUnit
      adapted nilpotentLine flat)

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
