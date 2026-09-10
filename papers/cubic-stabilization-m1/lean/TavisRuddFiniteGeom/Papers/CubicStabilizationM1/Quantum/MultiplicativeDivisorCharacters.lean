import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.MultivariateExponentialCharacters

/-!
# Multiplicative multivariate divisor characters

Taking the product of the one-coordinate formal exponentials constructs a
multiplicative character of an additive integral pairing vector. Restriction
to an integral line is its dot-product exponential. This supplies both the
ring-homomorphism law and the finite-fiber separation needed for completed
Novikov substitutions, without postulating an exponential character.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The formal exponential at zero is the unit series. -/
theorem formalExponentialCharacter_zero {K : Type*} [Field K] [CharZero K] :
    formalExponentialCharacter (0 : K)=1 := by
  rw [formalExponentialCharacter_eq_rescale_exp]
  simp

/-- Formal exponential characters convert addition of exponents into multiplication. -/
theorem formalExponentialCharacter_add {K : Type*} [Field K] [CharZero K] (a b : K) :
    formalExponentialCharacter (a+b)=formalExponentialCharacter a * formalExponentialCharacter b := by
  simp only [formalExponentialCharacter_eq_rescale_exp]
  exact (PowerSeries.exp_mul_exp_eq_exp_add a b).symm

/-- Products of finitely many formal characters have the sum of the exponents. -/
theorem formalExponentialCharacter_sum {K ι : Type*} [Field K] [CharZero K]
    (s : Finset ι) (exponent : ι → K) :
    formalExponentialCharacter (∑ i ∈ s, exponent i)=∏ i ∈ s, formalExponentialCharacter (exponent i) := by
  classical
  induction s using Finset.induction_on with
  | empty => simp [formalExponentialCharacter_zero]
  | @insert i s hi ih => simp [hi, formalExponentialCharacter_add, ih]

/-- The product of one-coordinate exponentials for an integral pairing vector. -/
noncomputable def multiplicativeDivisorCharacter
    {K : Type*} [Field K] [CharZero K] {rank : ℕ}
    (vector : Fin rank → ℤ) : MvPowerSeries (Fin rank) K :=
  ∏ j, PowerSeries.substAlgHom (PowerSeries.HasSubst.X (S := K) j)
    (formalExponentialCharacter (vector j : K))

/-- The zero pairing vector has unit character. -/
theorem multiplicativeDivisorCharacter_zero
    {K : Type*} [Field K] [CharZero K] {rank : ℕ} :
    multiplicativeDivisorCharacter (K := K) (0 : Fin rank → ℤ)=1 := by
  simp [multiplicativeDivisorCharacter, formalExponentialCharacter_zero]

/-- Addition of integral pairing vectors becomes multiplication of their
constructed multivariate characters. -/
theorem multiplicativeDivisorCharacter_add
    {K : Type*} [Field K] [CharZero K] {rank : ℕ}
    (left right : Fin rank → ℤ) :
    multiplicativeDivisorCharacter (K := K) (left+right)=
      multiplicativeDivisorCharacter left * multiplicativeDivisorCharacter right := by
  simp [multiplicativeDivisorCharacter, formalExponentialCharacter_add, Finset.prod_mul_distrib]

/-- Line restriction of a single-coordinate character multiplies its exponent
by the corresponding integral direction coordinate. -/
theorem integralLineRestriction_coordinateCharacter
    {K : Type*} [Field K] [CharZero K] {rank : ℕ}
    (direction : Fin rank → ℤ) (j : Fin rank) (a : K) :
    integralLineRestriction direction
      (PowerSeries.substAlgHom (PowerSeries.HasSubst.X (S := K) j)
        (formalExponentialCharacter a)) =
      formalExponentialCharacter ((direction j : K)*a) := by
  rw [integralLineRestriction, MvPowerSeries.substAlgHom_apply,
    PowerSeries.coe_substAlgHom, PowerSeries.subst,
    MvPowerSeries.subst_comp_subst_apply (PowerSeries.HasSubst.X (S := K) j).const
      (integralLine_hasSubst (K := K) direction)]
  simp only [MvPowerSeries.subst_X (integralLine_hasSubst direction)]
  change PowerSeries.subst ((direction j : K) • PowerSeries.X) (formalExponentialCharacter a) = _
  rw [← PowerSeries.rescale_eq_subst]
  ext n
  simp [formalExponentialCharacter, mul_pow, div_eq_mul_inv, mul_assoc]

/-- Restriction of the multiplicative multivariate character is the
factorial-normalized exponential of the integral dot product. -/
theorem integralLineRestriction_multiplicativeCharacter
    {K : Type*} [Field K] [CharZero K] {rank : ℕ}
    (direction vector : Fin rank → ℤ) :
    integralLineRestriction direction (multiplicativeDivisorCharacter (K := K) vector) =
      formalExponentialCharacter ((∑ j, direction j * vector j : ℤ) : K) := by
  simp only [multiplicativeDivisorCharacter, map_prod,
    integralLineRestriction_coordinateCharacter, Int.cast_sum, Int.cast_mul,
    formalExponentialCharacter_sum]

/-- An additive integral divisor pairing produces an actual multiplicative
character on effective classes. -/
noncomputable def integralPairingCharacter
    {Curve K : Type*} [AddCommMonoid Curve] [Field K] [CharZero K] {rank : ℕ}
    (pairing : Curve →+ (Fin rank → ℤ)) :
    Multiplicative Curve →* MvPowerSeries (Fin rank) K where
  toFun curve := multiplicativeDivisorCharacter (pairing curve.toAdd)
  map_one' := by simp [multiplicativeDivisorCharacter_zero]
  map_mul' left right := by
    simpa using multiplicativeDivisorCharacter_add (K := K) (pairing left.toAdd) (pairing right.toAdd)

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
