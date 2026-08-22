import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FormalLoopConnection
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.RankTwoResidueRigidity

/-!
# The canonical elementary modification of a rank-two atomic factor

Let a rank-two factor of an `F`-bundle be centered so that its connection in the
loop coordinate `u` has a simple pole, and let the frame be adapted to the
leading operator, meaning that the leading operator is a unit multiple of the
upper-right matrix unit: its kernel and image are the first coordinate line.
The elementary modification of the manuscript replaces the lattice by the one
spanned by the first basis vector and `u` times the second, which is the gauge

  `S = diag(1, u)`.

This module constructs that modification inside the formal model of
`FormalLoopConnection`, where a connection matrix with a simple pole is
represented by the power series obtained from it by clearing the pole.

## Objects and conventions

`modificationGauge` is `S` itself, a power series with matrix coefficients whose
coefficient of `u ^ 0` is the upper-left idempotent and whose coefficient of
`u ^ 1` is the lower-right idempotent.  `modifiedLoop` and `modifiedBase` are the
transformed connection matrices, again cleared of their poles: writing the
original loop and base series as `loop` and `base`, the entries of the
transformed matrices are the entries of the original ones shifted by the powers
of `u` that conjugation by `S` introduces, and the loop direction acquires in
addition the constant term `-diag(0, 1)` coming from `S⁻¹ u ∂_u S`.

No inverse of `S` and no Laurent series appear: the transformation law is stated
as the identities

  `S * (u * A♯) = loop * S - u ^ 2 * diag(0, 1)`,   `S * (u * B♯) = base * S`,

which are equivalent to the usual conjugation formulas because `S` is a
non-zerodivisor, and the second module identity is proved here as well.

## Results

The two transformation identities hold exactly when the frame is adapted and the
regular coefficient of the loop direction preserves the nilpotent line; those
hypotheses appear as vanishing of three entries of the leading coefficient and
of the lower-left entry of the regular coefficient.  Left multiplication by the
gauge is injective, so the transformed data are determined by them.  Flatness is
inherited: if the original loop and base series are flat for a derivation of the
coefficient ring, then so are the transformed ones.

Lean constructs no `F`-bundle, lattice, or spectral cover; the modification is
performed on the formal series that represent a connection in an adapted frame,
and the geometric statement that an atomic factor supplies such series in such a
frame is a hypothesis wherever it is used.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

open Matrix PowerSeries

variable {B : Type*} [CommRing B]

/-- A map of the coefficient ring obeying the Leibniz rule annihilates one. -/
theorem map_one_of_leibniz {derivation : B → B}
    (leibniz : ∀ x y, derivation (x * y) = derivation x * y + x * derivation y) :
    derivation 1 = 0 := by
  have doubled := leibniz 1 1
  simp only [mul_one, one_mul] at doubled
  linear_combination -doubled

/-- The idempotent projecting onto the first coordinate. -/
def firstCoordinateProjector : Matrix (Fin 2) (Fin 2) B := !![1, 0; 0, 0]

/-- The idempotent projecting onto the second coordinate. -/
def secondCoordinateProjector : Matrix (Fin 2) (Fin 2) B := !![0, 0; 0, 1]

/-- The gauge `diag(1, u)` of the canonical elementary modification, as a formal
series with matrix coefficients. -/
noncomputable def modificationGauge : PowerSeries (Matrix (Fin 2) (Fin 2) B) :=
  PowerSeries.C firstCoordinateProjector + PowerSeries.C secondCoordinateProjector * PowerSeries.X

/-- The coefficient of `u ^ 0` in a product with the modification gauge on the
left. -/
theorem coeff_zero_modificationGauge_mul (f : PowerSeries (Matrix (Fin 2) (Fin 2) B)) :
    coeff 0 (modificationGauge * f) = firstCoordinateProjector * coeff 0 f := by
  simp [modificationGauge, add_mul, mul_assoc]

/-- The coefficient of `u ^ (n + 1)` in a product with the modification gauge on
the left. -/
theorem coeff_succ_modificationGauge_mul (n : ℕ)
    (f : PowerSeries (Matrix (Fin 2) (Fin 2) B)) :
    coeff (n + 1) (modificationGauge * f)
      = firstCoordinateProjector * coeff (n + 1) f + secondCoordinateProjector * coeff n f := by
  have expansion : modificationGauge * f
      = PowerSeries.C firstCoordinateProjector * f
        + PowerSeries.X * (PowerSeries.C secondCoordinateProjector * f) := by
    rw [modificationGauge, add_mul, (PowerSeries.commute_X
      (PowerSeries.C (secondCoordinateProjector : Matrix (Fin 2) (Fin 2) B))).eq, mul_assoc]
  rw [expansion, map_add, PowerSeries.coeff_C_mul, PowerSeries.coeff_succ_X_mul,
    PowerSeries.coeff_C_mul]

/-- The coefficient of `u ^ 0` in a product with the modification gauge on the
right. -/
theorem coeff_zero_mul_modificationGauge (f : PowerSeries (Matrix (Fin 2) (Fin 2) B)) :
    coeff 0 (f * modificationGauge) = coeff 0 f * firstCoordinateProjector := by
  simp [modificationGauge, mul_add, ← mul_assoc]

/-- The coefficient of `u ^ (n + 1)` in a product with the modification gauge on
the right. -/
theorem coeff_succ_mul_modificationGauge (n : ℕ)
    (f : PowerSeries (Matrix (Fin 2) (Fin 2) B)) :
    coeff (n + 1) (f * modificationGauge)
      = coeff (n + 1) f * firstCoordinateProjector + coeff n f * secondCoordinateProjector := by
  have expansion : f * modificationGauge
      = f * PowerSeries.C firstCoordinateProjector
        + PowerSeries.X * (f * PowerSeries.C secondCoordinateProjector) := by
    rw [modificationGauge, mul_add, ← mul_assoc,
      (PowerSeries.commute_X (f * PowerSeries.C
        (secondCoordinateProjector : Matrix (Fin 2) (Fin 2) B))).eq]
  rw [expansion, map_add, PowerSeries.coeff_mul_C, PowerSeries.coeff_succ_X_mul,
    PowerSeries.coeff_mul_C]

/-- The loop-direction connection matrix of the modified lattice, cleared of a
pole it does not have: its coefficient of `u ^ k` is the coefficient of `u ^ k`
in the transformed connection matrix `S⁻¹ A S - S⁻¹ u ∂_u S`. -/
noncomputable def modifiedLoop (loop : PowerSeries (Matrix (Fin 2) (Fin 2) B)) :
    PowerSeries (Matrix (Fin 2) (Fin 2) B) :=
  PowerSeries.mk fun index =>
    !![(coeff (index + 1) loop) 0 0, (coeff index loop) 0 1;
       (coeff (index + 2) loop) 1 0,
         (coeff (index + 1) loop) 1 1 - (if index = 0 then 1 else 0)]

/-- The base-direction connection matrix of the modified lattice, cleared of its
possible simple pole: its coefficient of `u ^ 0` is the residual pole and its
coefficient of `u ^ (k + 1)` is the coefficient of `u ^ k` in the transformed
matrix `S⁻¹ B S`. -/
noncomputable def modifiedBase (base : PowerSeries (Matrix (Fin 2) (Fin 2) B)) :
    PowerSeries (Matrix (Fin 2) (Fin 2) B) :=
  PowerSeries.mk fun index =>
    !![(coeff index base) 0 0, (if index = 0 then 0 else (coeff (index - 1) base) 0 1);
       (coeff (index + 1) base) 1 0, (coeff index base) 1 1]

/-- The residue of the modified lattice in the loop direction. -/
noncomputable def modifiedResidue (loop : PowerSeries (Matrix (Fin 2) (Fin 2) B)) :
    Matrix (Fin 2) (Fin 2) B :=
  coeff 0 (modifiedLoop loop)

/-- The residue of the modified lattice, entry by entry: its upper-right entry
is the unit of the adapted leading operator, its diagonal comes from the regular
coefficient of the original connection with the modification's constant shift in
the second slot, and its lower-left entry is the next coefficient. -/
theorem modifiedResidue_eq (loop : PowerSeries (Matrix (Fin 2) (Fin 2) B)) :
    modifiedResidue loop =
      !![(coeff 1 loop) 0 0, (coeff 0 loop) 0 1;
         (coeff 2 loop) 1 0, (coeff 1 loop) 1 1 - 1] := by
  simp [modifiedResidue, modifiedLoop]

/-- Transformation law of the loop direction under the elementary modification.
The identity `S * (u * A♯) = A * S - u ^ 2 * diag(0, 1)` holds exactly in the
form stated, without inverting the gauge, provided the frame is adapted to the
leading operator and the regular coefficient preserves the nilpotent line: the
first three hypotheses say that the leading coefficient is supported in its
upper-right entry, the fourth is the vanishing of the lower-left entry of the
regular coefficient. -/
theorem modificationGauge_mul_modifiedLoop {loop : PowerSeries (Matrix (Fin 2) (Fin 2) B)}
    (leadingUpperLeft : (coeff 0 loop) 0 0 = 0)
    (leadingLowerLeft : (coeff 0 loop) 1 0 = 0)
    (leadingLowerRight : (coeff 0 loop) 1 1 = 0)
    (regularLowerLeft : (coeff 1 loop) 1 0 = 0) :
    modificationGauge * (PowerSeries.X * modifiedLoop loop)
      = loop * modificationGauge
        - PowerSeries.C secondCoordinateProjector * PowerSeries.X ^ 2 := by
  have leadingUpperLeft' : (constantCoeff loop) 0 0 = 0 := by
    rwa [← PowerSeries.coeff_zero_eq_constantCoeff_apply]
  have leadingLowerLeft' : (constantCoeff loop) 1 0 = 0 := by
    rwa [← PowerSeries.coeff_zero_eq_constantCoeff_apply]
  have leadingLowerRight' : (constantCoeff loop) 1 1 = 0 := by
    rwa [← PowerSeries.coeff_zero_eq_constantCoeff_apply]
  refine PowerSeries.ext fun index => ?_
  obtain _ | _ | _ | n := index <;>
    · simp only [map_sub, coeff_zero_modificationGauge_mul, coeff_succ_modificationGauge_mul,
        coeff_zero_mul_modificationGauge, coeff_succ_mul_modificationGauge,
        PowerSeries.coeff_zero_X_mul, PowerSeries.coeff_succ_X_mul,
        PowerSeries.coeff_C_mul_X_pow, modifiedLoop, PowerSeries.coeff_mk]
      ext row column
      fin_cases row <;> fin_cases column <;>
        simp [firstCoordinateProjector, secondCoordinateProjector, Matrix.mul_apply,
          Fin.sum_univ_two, regularLowerLeft, leadingUpperLeft', leadingLowerLeft',
          leadingLowerRight']

/-- Transformation law of a base direction under the elementary modification.
The gauge is independent of the base, so the transformed matrix is the plain
conjugate `S⁻¹ B S`, and the identity `S * (u * B♯) = B * S` holds provided the
leading coefficient of the base direction has vanishing lower-left entry, which
is what the commutation with the leading loop coefficient supplies. -/
theorem modificationGauge_mul_modifiedBase {base : PowerSeries (Matrix (Fin 2) (Fin 2) B)}
    (leadingLowerLeft : (coeff 0 base) 1 0 = 0) :
    modificationGauge * modifiedBase base = base * modificationGauge := by
  have leadingLowerLeft' : (constantCoeff base) 1 0 = 0 := by
    rwa [← PowerSeries.coeff_zero_eq_constantCoeff_apply]
  refine PowerSeries.ext fun index => ?_
  obtain _ | n := index <;>
    · simp only [coeff_zero_modificationGauge_mul, coeff_succ_modificationGauge_mul,
        coeff_zero_mul_modificationGauge, coeff_succ_mul_modificationGauge,
        modifiedBase, PowerSeries.coeff_mk]
      ext row column
      fin_cases row <;> fin_cases column <;>
        simp [firstCoordinateProjector, secondCoordinateProjector, Matrix.mul_apply,
          Fin.sum_univ_two, leadingLowerLeft']

/-- Left multiplication by the modification gauge is injective, so the
transformed connection matrices are determined by the transformation laws. -/
theorem eq_zero_of_modificationGauge_mul_eq_zero
    {f : PowerSeries (Matrix (Fin 2) (Fin 2) B)} (vanishing : modificationGauge * f = 0) :
    f = 0 := by
  refine PowerSeries.ext fun index => ?_
  have firstRow : firstCoordinateProjector * coeff index f
      + (if index = 0 then 0 else secondCoordinateProjector * coeff (index - 1) f) = 0 := by
    obtain _ | n := index
    · simpa [coeff_zero_modificationGauge_mul] using congrArg (fun g => coeff 0 g) vanishing
    · simpa [coeff_succ_modificationGauge_mul] using congrArg (fun g => coeff (n + 1) g) vanishing
  have secondRow : firstCoordinateProjector * coeff (index + 1) f
      + secondCoordinateProjector * coeff index f = 0 := by
    simpa [coeff_succ_modificationGauge_mul] using congrArg (fun g => coeff (index + 1) g) vanishing
  ext row column
  fin_cases row
  · have entry := congrFun (congrFun firstRow 0) column
    obtain _ | n := index <;>
      · fin_cases column <;>
        simpa [firstCoordinateProjector, secondCoordinateProjector, Matrix.mul_apply,
          Fin.sum_univ_two, Matrix.vecMul, dotProduct] using entry
  · have entry := congrFun (congrFun secondRow 1) column
    fin_cases column <;>
      simpa [firstCoordinateProjector, secondCoordinateProjector, Matrix.mul_apply,
        Fin.sum_univ_two, Matrix.vecMul, dotProduct] using entry

/-- The coefficient of `u ^ 0` in the modification gauge. -/
theorem coeff_zero_modificationGauge :
    coeff 0 (modificationGauge : PowerSeries (Matrix (Fin 2) (Fin 2) B))
      = firstCoordinateProjector := by
  simp [modificationGauge]

/-- The coefficient of `u ^ 1` in the modification gauge. -/
theorem coeff_one_modificationGauge :
    coeff 1 (modificationGauge : PowerSeries (Matrix (Fin 2) (Fin 2) B))
      = secondCoordinateProjector := by
  simp [modificationGauge]

/-- The modification gauge has no coefficient beyond the first order. -/
theorem coeff_add_two_modificationGauge (n : ℕ) :
    coeff (n + 2) (modificationGauge : PowerSeries (Matrix (Fin 2) (Fin 2) B)) = 0 := by
  simp [modificationGauge]

/-- A derivation of the coefficient ring annihilates a series whose
coefficients have only zeros and ones as entries; the two cases needed are the
loop coordinate itself and the constant series on the lower-right idempotent. -/
theorem seriesDerivation_eq_zero_of_entries {derivation : B → B}
    (zeroValue : derivation 0 = 0) (oneValue : derivation 1 = 0)
    {f : PowerSeries (Matrix (Fin 2) (Fin 2) B)}
    (entries : ∀ index row column, (coeff index f) row column = 0 ∨ (coeff index f) row column = 1) :
    seriesDerivation derivation f = 0 := by
  refine PowerSeries.ext fun index => ?_
  rw [coeff_seriesDerivation]
  ext row column
  rcases entries index row column with value | value <;>
    simp [Matrix.map_apply, value, zeroValue, oneValue]

/-- The modification gauge is constant along the base: a derivation of the
coefficient ring annihilates it. -/
theorem seriesDerivation_modificationGauge {derivation : B → B}
    (zeroValue : derivation 0 = 0) (oneValue : derivation 1 = 0) :
    seriesDerivation derivation
        (modificationGauge : PowerSeries (Matrix (Fin 2) (Fin 2) B)) = 0 := by
  refine seriesDerivation_eq_zero_of_entries zeroValue oneValue ?_
  intro index row column
  obtain _ | _ | n := index
  · rw [coeff_zero_modificationGauge]
    fin_cases row <;> fin_cases column <;> simp [firstCoordinateProjector]
  · rw [coeff_one_modificationGauge]
    fin_cases row <;> fin_cases column <;> simp [secondCoordinateProjector]
  · rw [coeff_add_two_modificationGauge]
    simp

/-- A derivation of the coefficient ring annihilates the constant series on the
lower-right idempotent. -/
theorem seriesDerivation_secondCoordinateProjector {derivation : B → B}
    (zeroValue : derivation 0 = 0) (oneValue : derivation 1 = 0) :
    seriesDerivation derivation
        (PowerSeries.C (secondCoordinateProjector : Matrix (Fin 2) (Fin 2) B)) = 0 := by
  refine seriesDerivation_eq_zero_of_entries zeroValue oneValue ?_
  intro index row column
  obtain _ | n := index
  · simp only [PowerSeries.coeff_zero_eq_constantCoeff_apply, PowerSeries.constantCoeff_C]
    fin_cases row <;> fin_cases column <;> simp [secondCoordinateProjector]
  · simp

/-- A derivation of the coefficient ring annihilates the loop coordinate. -/
theorem seriesDerivation_loopCoordinate {derivation : B → B}
    (zeroValue : derivation 0 = 0) (oneValue : derivation 1 = 0) :
    seriesDerivation derivation
        (PowerSeries.X : PowerSeries (Matrix (Fin 2) (Fin 2) B)) = 0 := by
  refine seriesDerivation_eq_zero_of_entries zeroValue oneValue ?_
  intro index row column
  rcases eq_or_ne index 1 with value | value
  · subst value
    rw [PowerSeries.coeff_one_X]
    fin_cases row <;> fin_cases column <;> simp
  · rw [PowerSeries.coeff_X, if_neg value]
    simp

/-- The Euler operator of the loop coordinate applied to the modification gauge:
only its first-order coefficient survives. -/
theorem loopEulerOperator_modificationGauge :
    loopEulerOperator (modificationGauge : PowerSeries (Matrix (Fin 2) (Fin 2) B))
      = PowerSeries.X * PowerSeries.C secondCoordinateProjector := by
  refine PowerSeries.ext fun index => ?_
  obtain _ | _ | n := index
  · simp [coeff_loopEulerOperator, PowerSeries.coeff_X]
  · simp [coeff_loopEulerOperator, coeff_one_modificationGauge, PowerSeries.coeff_X]
  · simp [coeff_loopEulerOperator, coeff_add_two_modificationGauge, PowerSeries.coeff_X]

/-- Flatness passes to the modified lattice.  If the loop and base series of an
adapted rank-two factor are flat for a derivation of the coefficient ring, then
so are the transformed series of the elementary modification.  The proof
multiplies the transformed flatness expression by the gauge, replaces every
transformed factor using the transformation laws, and cancels the gauge, which
is injective on the left. -/
theorem isFlatPair_modified {derivation : B → B}
    (additive : ∀ x y, derivation (x + y) = derivation x + derivation y)
    (leibniz : ∀ x y, derivation (x * y) = derivation x * y + x * derivation y)
    {loop base : PowerSeries (Matrix (Fin 2) (Fin 2) B)}
    (leadingUpperLeft : (coeff 0 loop) 0 0 = 0)
    (leadingLowerLeft : (coeff 0 loop) 1 0 = 0)
    (leadingLowerRight : (coeff 0 loop) 1 1 = 0)
    (regularLowerLeft : (coeff 1 loop) 1 0 = 0)
    (baseLeadingLowerLeft : (coeff 0 base) 1 0 = 0)
    (flat : IsFlatPair derivation loop base) :
    IsFlatPair derivation (PowerSeries.X * modifiedLoop loop) (modifiedBase base) := by
  have zeroValue : derivation 0 = 0 := map_zero_of_additive additive
  have oneValue : derivation 1 = 0 := map_one_of_leibniz leibniz
  set gauge := (modificationGauge : PowerSeries (Matrix (Fin 2) (Fin 2) B)) with gaugeDefinition
  set pole := PowerSeries.C (secondCoordinateProjector : Matrix (Fin 2) (Fin 2) B)
    with poleDefinition
  set transformedLoop := PowerSeries.X * modifiedLoop loop with transformedLoopDefinition
  set transformedBase := modifiedBase base with transformedBaseDefinition
  have moveLoopCoordinate : ∀ (exponent : ℕ) (f : PowerSeries (Matrix (Fin 2) (Fin 2) B)),
      base * (PowerSeries.X ^ exponent * f) = PowerSeries.X ^ exponent * (base * f) := by
    intro exponent f
    rw [← mul_assoc, (PowerSeries.commute_X_pow base exponent).eq, mul_assoc]
  have loopLaw : gauge * transformedLoop = loop * gauge - PowerSeries.X ^ 2 * pole := by
    rw [gaugeDefinition, poleDefinition, transformedLoopDefinition,
      modificationGauge_mul_modifiedLoop leadingUpperLeft leadingLowerLeft leadingLowerRight
        regularLowerLeft,
      (PowerSeries.commute_X_pow
        (PowerSeries.C (secondCoordinateProjector : Matrix (Fin 2) (Fin 2) B)) 2).eq]
  have baseLaw : gauge * transformedBase = base * gauge :=
    modificationGauge_mul_modifiedBase baseLeadingLowerLeft
  have gaugeConstant : seriesDerivation derivation gauge = 0 :=
    seriesDerivation_modificationGauge zeroValue oneValue
  have poleConstant : seriesDerivation derivation (PowerSeries.X ^ 2 * pole) = 0 := by
    have loopConstant : seriesDerivation derivation
        (PowerSeries.X : PowerSeries (Matrix (Fin 2) (Fin 2) B)) = 0 :=
      seriesDerivation_loopCoordinate zeroValue oneValue
    have squareConstant : seriesDerivation derivation
        ((PowerSeries.X : PowerSeries (Matrix (Fin 2) (Fin 2) B)) ^ 2) = 0 := by
      rw [pow_two, seriesDerivation_mul additive leibniz, loopConstant, zero_mul, mul_zero,
        add_zero]
    rw [seriesDerivation_mul additive leibniz, squareConstant, zero_mul,
      seriesDerivation_secondCoordinateProjector zeroValue oneValue, mul_zero, add_zero]
  have derivationLaw : gauge * seriesDerivation derivation transformedLoop
      = seriesDerivation derivation loop * gauge := by
    have left : seriesDerivation derivation (gauge * transformedLoop)
        = gauge * seriesDerivation derivation transformedLoop := by
      rw [seriesDerivation_mul additive leibniz, gaugeConstant, zero_mul, zero_add]
    have right : seriesDerivation derivation (loop * gauge - PowerSeries.X ^ 2 * pole)
        = seriesDerivation derivation loop * gauge := by
      rw [seriesDerivation_sub additive, poleConstant, sub_zero,
        seriesDerivation_mul additive leibniz, gaugeConstant, mul_zero, add_zero]
    rw [← left, loopLaw, right]
  have eulerLaw : gauge * loopEulerOperator transformedBase
      = loopEulerOperator base * gauge
        + PowerSeries.X * (base * pole) - PowerSeries.X * (pole * transformedBase) := by
    have gaugeEuler : loopEulerOperator gauge = PowerSeries.X * pole := by
      rw [gaugeDefinition, poleDefinition, loopEulerOperator_modificationGauge]
    have left : loopEulerOperator (gauge * transformedBase)
        = PowerSeries.X * pole * transformedBase
          + gauge * loopEulerOperator transformedBase := by
      rw [loopEulerOperator_mul, gaugeEuler]
    have right : loopEulerOperator (base * gauge)
        = loopEulerOperator base * gauge + base * (PowerSeries.X * pole) := by
      rw [loopEulerOperator_mul, gaugeEuler]
    have combined : PowerSeries.X * pole * transformedBase
        + gauge * loopEulerOperator transformedBase
        = loopEulerOperator base * gauge + base * (PowerSeries.X * pole) := by
      rw [← left, baseLaw, right]
    have solved := eq_sub_of_add_eq' combined
    rw [solved, mul_assoc]
    have shifted : base * (PowerSeries.X * pole) = PowerSeries.X * (base * pole) := by
      have := moveLoopCoordinate 1 pole
      rwa [pow_one] at this
    rw [shifted]
  have productLaw : gauge * (transformedLoop * transformedBase)
      = loop * base * gauge - PowerSeries.X ^ 2 * (pole * transformedBase) := by
    rw [← mul_assoc, loopLaw, sub_mul, mul_assoc, baseLaw]
    noncomm_ring
  have reversedProductLaw : gauge * (transformedBase * transformedLoop)
      = base * loop * gauge - PowerSeries.X ^ 2 * (base * pole) := by
    rw [← mul_assoc, baseLaw, mul_assoc, loopLaw, mul_sub, ← mul_assoc, moveLoopCoordinate]
  refine eq_zero_of_modificationGauge_mul_eq_zero ?_
  have flatMultiplied : (loop * base - base * loop
      + PowerSeries.X * (seriesDerivation derivation loop - loopEulerOperator base + base))
        * gauge = 0 := by
    rw [show (loop * base - base * loop
      + PowerSeries.X * (seriesDerivation derivation loop - loopEulerOperator base + base)) = 0
      from flat, zero_mul]
  have central : gauge * (PowerSeries.X * (seriesDerivation derivation transformedLoop
        - loopEulerOperator transformedBase + transformedBase))
      = PowerSeries.X * (gauge * (seriesDerivation derivation transformedLoop
        - loopEulerOperator transformedBase + transformedBase)) := by
    rw [← mul_assoc, (PowerSeries.commute_X gauge).eq, mul_assoc]
  calc gauge * (transformedLoop * transformedBase - transformedBase * transformedLoop
          + PowerSeries.X * (seriesDerivation derivation transformedLoop
            - loopEulerOperator transformedBase + transformedBase))
      = gauge * (transformedLoop * transformedBase)
          - gauge * (transformedBase * transformedLoop)
          + PowerSeries.X * (gauge * seriesDerivation derivation transformedLoop
            - gauge * loopEulerOperator transformedBase + gauge * transformedBase) := by
        rw [mul_add, mul_sub, central]
        noncomm_ring
    _ = (loop * base - base * loop
          + PowerSeries.X * (seriesDerivation derivation loop
            - loopEulerOperator base + base)) * gauge := by
        rw [productLaw, reversedProductLaw, derivationLaw, eulerLaw, baseLaw]
        noncomm_ring
    _ = 0 := flatMultiplied

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
