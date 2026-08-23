import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.Generated.UnitFixedWeylCoweightData
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.EffectiveReesCalibrationCertificate

/-!
# Unit-fixed Weyl-position certificate

Consider the rank-six cubic dual-number algebra

`Q[r][x,e]/(x^3-r^3,e^2)`

with graded basis `(1,e,x,xe,x^2,x^2e)`, weights
`(0,1,1,2,2,3)`, and the anti-diagonal Poincare pairing.  This module checks
the eight monomial self-dual relative positions which fix the unit/top pair
and permute or reverse the two middle hyperbolic pairs.

The generated table is reconstructed from the three Boolean position
parameters.  Lean checks its permutations, sorted coweights, inverse images
of the marked divisor, special binary cubics, and hard-Lefschetz determinants.
Among positions where the marked divisor generates the reduced cubic quotient,
right composition by the Kummer algebra involution leaves exactly two classes,
represented by positions `0` and `2`.  The calculation is cellwise: arbitrary
effective unipotent factors on both sides cannot make any of the other four
positions satisfy the cubic branch-separation discriminant fingerprint.

This is an exhaustive certificate for the displayed eight-position domain.
It does not prove that every effective self-dual calibration admits such a
monomial Bruhat representative, nor that a geometric quantum connection
supplies an integral marked calibration.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.UnitFixedWeylCoweightCertificate

open Generated.UnitFixedWeylCoweightData
open EffectiveReesCalibrationCertificate

abbrev Position := Generated.UnitFixedWeylCoweightData.Position
abbrev Index := Generated.UnitFixedWeylCoweightData.Index

set_option maxHeartbeats 1600000

/-- Cohomological weights of `(1,e,x,xe,x^2,x^2e)`. -/
def cohomologicalWeight : Index → ℤ := ![0, 1, 1, 2, 2, 3]

/-- Sorted zero coweight. -/
def zeroCoweight : Index → ℤ := ![0, 0, 0, 0, 0, 0]

/-- Sorted coweight of a single middle-pair reversal. -/
def singleReversalCoweight : Index → ℤ := ![-1, 0, 0, 0, 0, 1]

/-- Sorted coweight of two middle-pair reversals. -/
def doubleReversalCoweight : Index → ℤ := ![-1, -1, 0, 0, 1, 1]

/-- The permutation reconstructed from pair exchange and the two reversal
bits. -/
def reconstructedPermutation (p : Position) : Index → Index :=
  ![0,
    if swapPairs p then (if reverseFirst p then 3 else 2)
      else (if reverseFirst p then 4 else 1),
    if swapPairs p then (if reverseSecond p then 4 else 1)
      else (if reverseSecond p then 3 else 2),
    if swapPairs p then (if reverseSecond p then 1 else 4)
      else (if reverseSecond p then 2 else 3),
    if swapPairs p then (if reverseFirst p then 2 else 3)
      else (if reverseFirst p then 1 else 4),
    5]

/-- The generated permutation table agrees with the Boolean construction. -/
theorem permutation_correspondence (p : Position) :
    permutation p = reconstructedPermutation p := by
  ext i
  fin_cases p <;> fin_cases i <;>
    decide

/-- The raw coweight before sorting. -/
def rawCoweight (p : Position) (i : Index) : ℤ :=
  cohomologicalWeight i - cohomologicalWeight (permutation p i)

/-- The canonical sorted coweight determined by the two reversal bits. -/
def reconstructedSortedCoweight (p : Position) : Index → ℤ :=
  if reverseFirst p then
    if reverseSecond p then doubleReversalCoweight else singleReversalCoweight
  else if reverseSecond p then singleReversalCoweight else zeroCoweight

/-- The generated sorted coweight has the stated Boolean normal form. -/
theorem sortedCoweight_correspondence (p : Position) :
    sortedCoweight p = reconstructedSortedCoweight p := by
  ext i
  fin_cases p <;> fin_cases i <;>
    decide

/-- Sorting changes only the order of the six raw coweight entries. -/
theorem sortedCoweight_perm_raw (p : Position) :
    (List.ofFn (rawCoweight p)).Perm (List.ofFn (sortedCoweight p)) := by
  fin_cases p <;>
    decide

/-- The generated inverse table is a left inverse to every Weyl position. -/
theorem inversePermutation_left (p : Position) (i : Index) :
    inversePermutation p (permutation p i) = i := by
  fin_cases p <;> fin_cases i <;>
    decide

/-- The generated inverse table is a right inverse to every Weyl position. -/
theorem inversePermutation_right (p : Position) (i : Index) :
    permutation p (inversePermutation p i) = i := by
  fin_cases p <;> fin_cases i <;>
    decide

/-- Exponent of `x` in a basis monomial. -/
def basisXPower : Index → ℕ := ![0, 0, 1, 1, 2, 2]

/-- Exponent of `e` in a basis monomial. -/
def basisEPower : Index → ℕ := ![0, 1, 0, 1, 0, 1]

/-- Intrinsic condition that the transported marked divisor comes from `x`
or `x^2`, rather than from the square-zero ideal. -/
def DivisorGeneratesCubicQuotient (p : Position) : Prop :=
  basisEPower (inversePermutation p 2) = 0 ∧
    basisXPower (inversePermutation p 2) ≠ 0

/-- The generated Boolean records precisely the divisor-generation
condition. -/
theorem divisorGenerates_correspondence (p : Position) :
    divisorGeneratesCubicQuotient p = true ↔
      DivisorGeneratesCubicQuotient p := by
  fin_cases p <;>
    simp [DivisorGeneratesCubicQuotient, basisEPower, basisXPower,
      inversePermutation, divisorGeneratesCubicQuotient]

/-- A Laurent basis term records an `r`-exponent and one of the six basis
monomials. -/
structure LaurentBasisTerm where
  exponent : ℤ
  basis : Index
  deriving DecidableEq

/-- Basis index for exponents in the ranges `0 ≤ xPower ≤ 2` and
`0 ≤ ePower ≤ 1`; other inputs are sent to the unit and are not used by the
product constructor. -/
def basisIndex (xPower ePower : ℕ) : Index :=
  match xPower, ePower with
  | 0, 0 => 0
  | 0, 1 => 1
  | 1, 0 => 2
  | 1, 1 => 3
  | 2, 0 => 4
  | 2, 1 => 5
  | _, _ => 0

/-- Product of two basis monomials in
`Q[r,r⁻¹][x,e]/(x^3-r^3,e^2)`. -/
def genericBasisProduct (i j : Index) : Option LaurentBasisTerm :=
  let ePower := basisEPower i + basisEPower j
  if ePower ≥ 2 then none
  else
    let xPower := basisXPower i + basisXPower j
    if xPower ≥ 3 then
      some ⟨3, basisIndex (xPower - 3) ePower⟩
    else
      some ⟨0, basisIndex xPower ePower⟩

/-- Laurent exponent of a monomial calibration column. -/
def calibrationExponent (p : Position) (i : Index) : ℤ :=
  cohomologicalWeight i - cohomologicalWeight (permutation p i)

/-- Image of one Laurent basis term under a monomial calibration. -/
def mapLaurentTerm (p : Position) (term : LaurentBasisTerm) : LaurentBasisTerm :=
  ⟨term.exponent + calibrationExponent p term.basis,
    permutation p term.basis⟩

/-- Map the product of two source basis elements. -/
def mappedSourceProduct (p : Position) (i j : Index) : Option LaurentBasisTerm :=
  (genericBasisProduct i j).map (mapLaurentTerm p)

/-- Multiply the two mapped source basis elements. -/
def productOfMappedSources (p : Position) (i j : Index) :
    Option LaurentBasisTerm :=
  (genericBasisProduct (permutation p i) (permutation p j)).map
    (fun term =>
      ⟨calibrationExponent p i + calibrationExponent p j + term.exponent,
        term.basis⟩)

/-- Position `7` is a Laurent algebra automorphism: it sends
`x` to `x^2/r` and `e` to `xe/r`. -/
theorem kummerInvolution_preserves_genericProduct (i j : Index) :
    mappedSourceProduct 7 i j = productOfMappedSources 7 i j := by
  fin_cases i <;> fin_cases j <;>
    decide

/-- Position `7` is an involution on the six basis monomials. -/
theorem kummerInvolution_sq (i : Index) :
    permutation 7 (permutation 7 i) = i := by
  fin_cases i <;>
    decide

/-- Right composition by the Kummer involution on a Weyl position. -/
def rightKummerTranslate (p : Position) : Index → Index :=
  fun i => permutation p (permutation 7 i)

/-- Equality of monomial positions modulo right composition by the Kummer
algebra involution. -/
def SameModuloKummerInvolution (p q : Position) : Prop :=
  permutation p = permutation q ∨ permutation p = rightKummerTranslate q

/-- The four positions whose marked divisor generates the cubic quotient. -/
theorem generating_positions (p : Position) :
    DivisorGeneratesCubicQuotient p ↔
      p = 0 ∨ p = 2 ∨ p = 6 ∨ p = 7 := by
  fin_cases p <;>
    simp [DivisorGeneratesCubicQuotient, basisEPower, basisXPower,
      inversePermutation]

/-- Source index of the target divisor under a monomial Weyl position.  This
reducible table isolates the only generated datum needed by the cellwise
calculation. -/
def divisorSourceIndex (p : Position) : Index :=
  match p.val with
  | 0 | 2 => 2
  | 1 | 3 => 3
  | 4 | 5 => 1
  | 6 | 7 => 4
  | _ => 0

/-- The reducible source-index table agrees with the inverse permutation in
the generated certificate. -/
theorem divisorSourceIndex_correspondence (p : Position) :
    divisorSourceIndex p = inversePermutation p 2 := by
  fin_cases p <;>
    decide

/-- Sparse form of the monomially pulled-back target divisor: a unit shift
plus the basis vector mapping to target index `2`. -/
def monomialDivisorSource
    (p : Position) (leftUnitShift : ℚ) (i : Index) : ℚ :=
  (match p.val with
    | 0 | 2 => ![-leftUnitShift, 0, 1, 0, 0, 0]
    | 1 | 3 => ![-leftUnitShift, 0, 0, 1, 0, 0]
    | 4 | 5 => ![-leftUnitShift, 1, 0, 0, 0, 0]
    | 6 | 7 => ![-leftUnitShift, 0, 0, 0, 1, 0]
    | _ => ![-leftUnitShift, 0, 0, 0, 0, 0]) i

/-- The direct sparse table is the unit shift plus the basis vector selected
by the generated inverse permutation. -/
theorem monomialDivisorSource_correspondence
    (p : Position) (leftUnitShift : ℚ) (i : Index) :
    monomialDivisorSource p leftUnitShift i =
      if i.val = 0 then -leftUnitShift
      else if i.val = (inversePermutation p 2).val then 1
      else 0 := by
  rw [← divisorSourceIndex_correspondence p]
  fin_cases p <;> fin_cases i <;>
    norm_num [monomialDivisorSource, divisorSourceIndex]

/-- Source coordinates of the target divisor after a left effective
unipotent calibration, a monomial Weyl position, and a right effective
unipotent calibration.  Only the left unit-shift parameter and the five right
parameters can enter. -/
def bruhatDivisorSource
    (p : Position) (leftUnitShift : ℚ) (a b c d f : ℚ) : Index → ℚ :=
  (generalCalibrationInverse a b c d f).mulVec
    (monomialDivisorSource p leftUnitShift)

/-- Normal form of the full divisor pullback on each monomial cell. -/
def bruhatDivisorSourceNormalForm
    (p : Position) (leftUnitShift : ℚ) (a b c d f : ℚ) (i : Index) : ℚ :=
  match p.val, i.val with
  | 0, 0 | 2, 0 => -leftUnitShift - b
  | 0, 2 | 2, 2 => 1
  | 1, 0 | 3, 0 => -leftUnitShift - c + f * a
  | 1, 1 | 3, 1 => -f
  | 1, 3 | 3, 3 => 1
  | 4, 0 | 5, 0 => -leftUnitShift - a
  | 4, 1 | 5, 1 => 1
  | 6, 0 | 7, 0 => -leftUnitShift - d - f * b
  | 6, 2 | 7, 2 => f
  | 6, 4 | 7, 4 => 1
  | _, _ => 0

/-- The effective right-unipotent inverse sends every sparse monomial divisor
to the displayed full normal form. -/
theorem bruhatDivisorSource_formula
    (p : Position) (leftUnitShift : ℚ) (a b c d f : ℚ) :
    bruhatDivisorSource p leftUnitShift a b c d f =
      bruhatDivisorSourceNormalForm p leftUnitShift a b c d f := by
  ext i
  fin_cases p <;> fin_cases i <;>
    norm_num [bruhatDivisorSource, bruhatDivisorSourceNormalForm,
      monomialDivisorSource, generalCalibrationInverse,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ]
  all_goals ring

/-- Coefficients of `x` and `x^2` in the reduced cubic quotient of the source
divisor. -/
def bruhatReducedDivisor (p : Position) (_leftUnitShift : ℚ)
    (_a _b _c _d f : ℚ) : Fin 2 → ℚ :=
  match p.val with
  | 0 | 2 => ![1, 0]
  | 6 | 7 => ![f, 1]
  | _ => ![0, 0]

/-- The two displayed reduced coefficients are exactly coordinates `2` and
`4` of the full right-unipotent pullback. -/
theorem bruhatReducedDivisor_eq_sourceCoordinates
    (p : Position) (leftUnitShift : ℚ) (a b c d f : ℚ) :
    bruhatReducedDivisor p leftUnitShift a b c d f =
      ![bruhatDivisorSource p leftUnitShift a b c d f 2,
        bruhatDivisorSource p leftUnitShift a b c d f 4] := by
  rw [bruhatDivisorSource_formula]
  ext i
  fin_cases p <;> fin_cases i <;>
    norm_num [bruhatReducedDivisor, bruhatDivisorSourceNormalForm]

/-- The reduced divisor is constant on the four non-generating cells.  On
the reference cells it is `x`; on their Kummer translates it is `f*x+x^2`.
Thus the left unipotent and four of the five right-unipotent parameters are
irrelevant to divisor generation. -/
theorem bruhatReducedDivisor_formula
    (p : Position) (leftUnitShift : ℚ) (a b c d f : ℚ) :
    bruhatReducedDivisor p leftUnitShift a b c d f =
      match p.val with
      | 0 | 2 => ![1, 0]
      | 6 | 7 => ![f, 1]
      | _ => ![0, 0] := by
  rfl

/-- Discriminant fingerprint for a reduced divisor `alpha*x+beta*x^2` on the
split cubic quotient.  Identifying this predicate with separation of the
geometric divisor eigenbranches is an external occurrence hypothesis. -/
def CubicBranchSeparationFingerprint (coefficients : Fin 2 → ℚ) : Prop :=
  coefficients 0 ^ 3 ≠ coefficients 1 ^ 3

/-- No point of any of the four non-generating monomial Bruhat cells can
separate the cubic quotient, even after arbitrary effective unipotent factors
on both sides. -/
theorem cubicBranchSeparationFingerprint_forces_generating_position
    (p : Position) (leftUnitShift : ℚ) (a b c d f : ℚ)
    (separates : CubicBranchSeparationFingerprint
      (bruhatReducedDivisor p leftUnitShift a b c d f)) :
    p = 0 ∨ p = 2 ∨ p = 6 ∨ p = 7 := by
  fin_cases p <;>
    simp [CubicBranchSeparationFingerprint, bruhatReducedDivisor] at separates ⊢

/-- On the two reference cells the divisor always separates the cubic
branches; on the two Kummer-translated cells separation is exactly
`f^3 != 1`. -/
theorem cubicBranchSeparationFingerprint_on_generating_positions
    (leftUnitShift : ℚ) (a b c d f : ℚ) :
    CubicBranchSeparationFingerprint
        (bruhatReducedDivisor 0 leftUnitShift a b c d f) ∧
      CubicBranchSeparationFingerprint
        (bruhatReducedDivisor 2 leftUnitShift a b c d f) ∧
      (CubicBranchSeparationFingerprint
          (bruhatReducedDivisor 6 leftUnitShift a b c d f) ↔ f ^ 3 ≠ 1) ∧
      (CubicBranchSeparationFingerprint
          (bruhatReducedDivisor 7 leftUnitShift a b c d f) ↔ f ^ 3 ≠ 1) := by
  constructor
  · simp [CubicBranchSeparationFingerprint, bruhatReducedDivisor]
  constructor
  · simp [CubicBranchSeparationFingerprint, bruhatReducedDivisor]
  constructor
  · simp [CubicBranchSeparationFingerprint, bruhatReducedDivisor]
  · simp [CubicBranchSeparationFingerprint, bruhatReducedDivisor]

/-- Every divisor-generating position belongs, modulo the Kummer involution,
to the reference class `0` or the single-reversal class `2`. -/
theorem generating_position_two_classes
    (p : Position) (h : DivisorGeneratesCubicQuotient p) :
    SameModuloKummerInvolution p 0 ∨ SameModuloKummerInvolution p 2 := by
  rcases (generating_positions p).mp h with rfl | rfl | rfl | rfl
  · exact Or.inl (Or.inl rfl)
  · exact Or.inr (Or.inl rfl)
  · right
    right
    funext i
    fin_cases i <;> rfl
  · left
    right
    funext i
    fin_cases i <;> rfl

/-- The generated representative table is sound and exhaustive on the
divisor-generating positions. -/
theorem generated_representative_correspondence
    (p : Position) (h : DivisorGeneratesCubicQuotient p) :
    ∃ q : Position,
      representativeModKummerInvolution p = some q ∧
      (q = 0 ∨ q = 2) ∧ SameModuloKummerInvolution p q := by
  rcases (generating_positions p).mp h with rfl | rfl | rfl | rfl
  · exact ⟨0, rfl, Or.inl rfl, Or.inl rfl⟩
  · exact ⟨2, rfl, Or.inr rfl, Or.inl rfl⟩
  · refine ⟨2, rfl, Or.inr rfl, Or.inr ?_⟩
    funext i
    fin_cases i <;> rfl
  · refine ⟨0, rfl, Or.inl rfl, Or.inr ?_⟩
    funext i
    fin_cases i <;> rfl

/-- Coefficient of the top basis vector in a triple product of old basis
monomials. -/
def oldTripleTopCoefficient (i j k : Index) : ℤ :=
  if basisEPower i + basisEPower j + basisEPower k = 1 ∧
      (basisXPower i + basisXPower j + basisXPower k) % 3 = 2
  then 1 else 0

/-- Binary cubic of the special fibre obtained from a monomial Weyl
position.  The entries are the coefficients of `u^3,u^2v,uv^2,v^3`. -/
def reconstructedSpecialBinaryCubic (p : Position) : Fin 4 → ℤ :=
  let u := inversePermutation p 1
  let v := inversePermutation p 2
  ![oldTripleTopCoefficient u u u,
    oldTripleTopCoefficient u u v,
    oldTripleTopCoefficient u v v,
    oldTripleTopCoefficient v v v]

/-- The emitted special binary cubics agree with direct multiplication in the
dual-number algebra. -/
theorem specialBinaryCubic_correspondence (p : Position) :
    specialBinaryCubic p = reconstructedSpecialBinaryCubic p := by
  ext i
  fin_cases p <;> fin_cases i <;>
    decide

/-- Determinant coefficients of multiplication by `αu+βv`, written as the
coefficients of `α^2,αβ,β^2`. -/
def reconstructedHardLefschetzDeterminant (p : Position) : Fin 3 → ℤ :=
  let cubic := reconstructedSpecialBinaryCubic p
  let a := cubic 0
  let b := cubic 1
  let c := cubic 2
  let d := cubic 3
  ![b * b - a * c, b * c - a * d, c * c - b * d]

/-- The emitted hard-Lefschetz determinants are recomputed from the emitted
special binary cubics. -/
theorem hardLefschetzDeterminant_correspondence (p : Position) :
    hardLefschetzDeterminant p = reconstructedHardLefschetzDeterminant p := by
  ext i
  fin_cases p <;> fin_cases i <;>
    decide

/-- The two class representatives have coweights zero and
`(-1,0,0,0,0,1)`, respectively. -/
theorem representative_coweights :
    sortedCoweight 0 = zeroCoweight ∧
      sortedCoweight 2 = singleReversalCoweight := by
  constructor <;> rfl

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.UnitFixedWeylCoweightCertificate
