import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.NumericalNovikovCompletion

/-!
# Faithfulness of directional exponential tagging on completed series

A degree-compatible effective-class map has finite fibers. Tag its source
coefficients by exponential characters of injective integral pairing vectors,
then sum over each actual fiber. The family of all integral one-parameter
restrictions of this completed pushforward is jointly injective. The proof
uses the finite fiber itself and the Vandermonde theorem, without supplied
initial-form detectors or noncancellation assumptions.

The source and target are actual completed coefficient families. These
statements concern directional character substitutions; they do not identify
a geometric fixed base or construct its multivariate coordinate isomorphism.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- Vanishing of a finite exponential relation in every integral direction
forces every coefficient to vanish. The direction separating its finite
integral pairing vectors is constructed by the Vandermonde argument. -/
theorem coefficients_zero_of_all_integral_character_relations
    {K ι : Type*} [Field K] [CharZero K] [Fintype ι] {rank : ℕ}
    (vector : ι → Fin rank → ℤ) (injective : Function.Injective vector)
    (coefficient : ι → K)
    (relations : ∀ direction : Fin rank → ℤ,
      ∑ i, coefficient i • formalExponentialCharacter
        ((∑ j, direction j * vector i j : ℤ) : K) = 0) :
    coefficient=0 := by
  classical
  let enumeration := (Fintype.equivFin ι).symm
  obtain ⟨direction,_,independent⟩ := exists_integralDirection_separating_formalExponentialCharacters
    (K := K) (fun i => vector (enumeration i)) (injective.comp enumeration.injective)
  have relation : ∑ i, coefficient (enumeration i) • formalExponentialCharacter
      ((∑ j, direction j * vector (enumeration i) j : ℤ) : K) = 0 := by
    exact (Equiv.sum_comp enumeration (fun i => coefficient i • formalExponentialCharacter
      ((∑ j, direction j * vector i j : ℤ) : K))).trans (relations direction)
  have zero := independent (fun i => coefficient (enumeration i)) relation
  funext i
  have value := congrFun zero (enumeration.symm i)
  simpa using value

/-- Multiplication of each completed coefficient by its directional
exponential character and a scalar monomial weight. -/
noncomputable def completedDirectionalTag
    {Curve K : Type*} [Field K] [CharZero K] {length : Curve → ℕ} {rank : ℕ}
    (vector : Curve → Fin rank → ℤ) (weight : Curve → K) (direction : Fin rank → ℤ)
    (series : CompletedNovikovSeries Curve K length) :
    CompletedNovikovSeries Curve (PowerSeries K) length where
  coefficient curve := (series.coefficient curve * weight curve) •
    formalExponentialCharacter ((∑ j, direction j * vector curve j : ℤ) : K)
  finite_below cutoff := (series.finite_below cutoff).subset <| by
    intro curve h
    refine ⟨?_,h.2⟩
    intro zero
    exact h.1 (by simp [zero])

/-- The completed directional pushforward sums the tagged coefficients over
the actual finite fibers of a degree-compatible class map. -/
noncomputable def completedDirectionalTaggedPushforward
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {rank : ℕ}
    (data : NumericallyFiniteEffectiveQuotient (Homology := Curve) (Numerical := TargetCurve))
    (vector : Curve → Fin rank → ℤ) (weight : Curve → K) (direction : Fin rank → ℤ)
    (series : CompletedNovikovSeries Curve K data.homologicalDegree) :
    CompletedNovikovSeries TargetCurve (PowerSeries K) data.numericalDegree :=
  data.completedCoefficientPushforward (completedDirectionalTag vector weight direction series)

/-- The actual target coefficient is a finite exponential sum over its exact
source fiber. This identity is proved by unfolding the constructed map. -/
theorem completedDirectionalTaggedPushforward_coefficient
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {rank : ℕ}
    (data : NumericallyFiniteEffectiveQuotient (Homology := Curve) (Numerical := TargetCurve))
    (vector : Curve → Fin rank → ℤ) (weight : Curve → K) (direction : Fin rank → ℤ)
    (series : CompletedNovikovSeries Curve K data.homologicalDegree) (target : TargetCurve) :
    (completedDirectionalTaggedPushforward data vector weight direction series).coefficient target =
      ∑ curve ∈ data.fiber target, (series.coefficient curve * weight curve) •
        formalExponentialCharacter ((∑ j, direction j * vector curve j : ℤ) : K) := rfl

/-- The directional completed pushforward is additive. -/
noncomputable def completedDirectionalTaggedPushforwardAddHom
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {rank : ℕ}
    (data : NumericallyFiniteEffectiveQuotient (Homology := Curve) (Numerical := TargetCurve))
    (vector : Curve → Fin rank → ℤ) (weight : Curve → K) (direction : Fin rank → ℤ) :
    CompletedNovikovSeries Curve K data.homologicalDegree →+
      CompletedNovikovSeries TargetCurve (PowerSeries K) data.numericalDegree where
  toFun := completedDirectionalTaggedPushforward data vector weight direction
  map_zero' := by
    apply CompletedNovikovSeries.ext
    funext target
    simp [completedDirectionalTaggedPushforward_coefficient]
  map_add' left right := by
    apply CompletedNovikovSeries.ext
    funext target
    simp [completedDirectionalTaggedPushforward_coefficient, add_mul, add_smul,
      Finset.sum_add_distrib]

/-- The complete family of directional pushforwards reflects zero. Fiber
finiteness and separation of the integral pairing vectors are sufficient;
no initial-form compatibility or injectivity assertion is assumed. -/
theorem completedDirectionalTaggedPushforward_jointly_reflects_zero
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {rank : ℕ}
    (data : NumericallyFiniteEffectiveQuotient (Homology := Curve) (Numerical := TargetCurve))
    (vector : Curve → Fin rank → ℤ) (injective : Function.Injective vector)
    (weight : Curve → K) (nonzero : ∀ curve, weight curve ≠ 0)
    (series : CompletedNovikovSeries Curve K data.homologicalDegree)
    (zero : ∀ direction, completedDirectionalTaggedPushforward data vector weight direction series=0) :
    series=0 := by
  classical
  apply CompletedNovikovSeries.ext
  funext curve
  let fiber := data.fiber (data.quotient curve)
  have hcurve : curve ∈ fiber := (data.mem_fiber_iff curve (data.quotient curve)).mpr rfl
  have coefficients := coefficients_zero_of_all_integral_character_relations
    (K := K) (fun x : fiber => vector x) (injective.comp Subtype.val_injective)
    (fun x : fiber => series.coefficient x * weight x) (by
      intro direction
      have h := congrArg (fun s : CompletedNovikovSeries TargetCurve (PowerSeries K)
        data.numericalDegree => s.coefficient (data.quotient curve)) (zero direction)
      simp only [completedDirectionalTaggedPushforward_coefficient,
        CompletedNovikovSeries.coefficient_zero] at h
      exact (Finset.sum_coe_sort fiber (fun x : Curve =>
        (series.coefficient x * weight x) • formalExponentialCharacter
          ((∑ j, direction j * vector x j : ℤ) : K))).trans h)
  have value := congrFun coefficients (⟨curve,hcurve⟩ : fiber)
  exact (mul_eq_zero.mp value).resolve_right (nonzero curve)

/-- Directional exponential tagging is jointly injective on the completed
source, not merely on finite packets or a supplied associated-graded model. -/
theorem completedDirectionalTaggedPushforward_jointly_injective
    {Curve TargetCurve K : Type*} [AddCommMonoid Curve] [AddCommMonoid TargetCurve]
    [Field K] [CharZero K] {rank : ℕ}
    (data : NumericallyFiniteEffectiveQuotient (Homology := Curve) (Numerical := TargetCurve))
    (vector : Curve → Fin rank → ℤ) (injective : Function.Injective vector)
    (weight : Curve → K) (nonzero : ∀ curve, weight curve ≠ 0) :
    Function.Injective (fun series direction =>
      completedDirectionalTaggedPushforward data vector weight direction series) := by
  intro left right equal
  apply sub_eq_zero.mp
  apply completedDirectionalTaggedPushforward_jointly_reflects_zero data vector injective weight nonzero
  intro direction
  change completedDirectionalTaggedPushforwardAddHom data vector weight direction (left-right)=0
  rw [map_sub]
  exact sub_eq_zero.mpr (congrFun equal direction)

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
