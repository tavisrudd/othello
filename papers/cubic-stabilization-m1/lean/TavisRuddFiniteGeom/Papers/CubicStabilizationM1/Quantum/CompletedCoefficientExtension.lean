import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompletedNovikovConvolution

/-!
# Coefficient extension for completed convolution rings

A coefficient-ring homomorphism acts pointwise on bounded-degree completed
Novikov series. It preserves the finite convolution sums and unit, hence is
an actual ring homomorphism. Injective coefficient extension is injective on
the completed ring. No completion of an arbitrary injective ring map is used.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- Pointwise coefficient extension of a completed Novikov series. -/
noncomputable def completedCoefficientExtension
    {Curve R S : Type*} [AddCommMonoid Curve] [CommRing R] [CommRing S]
    (grading : FiniteDegreeAddCommMonoid Curve) (f : R →+* S)
    (series : grading.CompletedNovikovRing R) : grading.CompletedNovikovRing S where
  coefficient curve := f (series.coefficient curve)
  finite_below cutoff := (series.finite_below cutoff).subset <| by
    intro curve h
    exact ⟨fun zero => h.1 (by simp [zero]), h.2⟩

/-- Coefficient extension commutes with the completed finite convolution and
unit. The resulting map is a unital ring homomorphism. -/
noncomputable def completedCoefficientExtensionRingHom
    {Curve R S : Type*} [AddCommMonoid Curve] [CommRing R] [CommRing S]
    (grading : FiniteDegreeAddCommMonoid Curve) (f : R →+* S) :
    grading.CompletedNovikovRing R →+* grading.CompletedNovikovRing S where
  toFun := completedCoefficientExtension grading f
  map_zero' := by
    apply CompletedNovikovSeries.ext
    funext curve
    simp [completedCoefficientExtension]
  map_add' left right := by
    apply CompletedNovikovSeries.ext
    funext curve
    simp [completedCoefficientExtension]
  map_one' := by
    classical
    apply CompletedNovikovSeries.ext
    funext curve
    by_cases zero : curve=0 <;>
      simp [completedCoefficientExtension, FiniteDegreeAddCommMonoid.CompletedNovikovRing.one_def,
        FiniteDegreeAddCommMonoid.convolutionUnit, zero]
  map_mul' left right := by
    apply CompletedNovikovSeries.ext
    funext curve
    simp [completedCoefficientExtension, FiniteDegreeAddCommMonoid.CompletedNovikovRing.mul_def,
      FiniteDegreeAddCommMonoid.convolution_coefficient, map_sum, map_mul]

/-- An injective coefficient map induces an injective map on the actual
completed convolution rings. -/
theorem completedCoefficientExtensionRingHom_injective
    {Curve R S : Type*} [AddCommMonoid Curve] [CommRing R] [CommRing S]
    (grading : FiniteDegreeAddCommMonoid Curve) (f : R →+* S) (injective : Function.Injective f) :
    Function.Injective (completedCoefficientExtensionRingHom grading f) := by
  intro left right equal
  apply CompletedNovikovSeries.ext
  funext curve
  apply injective
  exact congrArg (fun s : grading.CompletedNovikovRing S => s.coefficient curve) equal

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
