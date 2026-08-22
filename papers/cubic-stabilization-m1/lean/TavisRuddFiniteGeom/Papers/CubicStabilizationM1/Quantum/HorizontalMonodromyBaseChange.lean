import Mathlib.LinearAlgebra.Charpoly.BaseChange
import Mathlib.LinearAlgebra.TensorProduct.Basis
import Mathlib.RingTheory.Flat.Equalizer
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CompatibleMonodromySystem
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FilteredCoefficientQuotients

/-!
# Horizontal monodromy under coefficient extension

Let `d` and `m` be commuting linear endomorphisms of a vector space over a
field.  The kernel of `d` is the horizontal subspace, and commutation lets `m`
restrict to it.  For every commutative coefficient algebra `B`, flatness over
the field gives a canonical equivalence

`B ⊗ ker(d) ≃ ker(1 ⊗ d)`.

Lean proves that this equivalence intertwines the scalar extension of the
restricted endomorphism with the restriction of `1 ⊗ m`.  Consequently the
extended horizontal monodromy is conjugate to scalar extension of the original
horizontal monodromy, whose characteristic polynomial is obtained by applying
the coefficient map.  For a commutative algebra with a decreasing ideal
filtration, Lean also constructs the coefficient-algebra tower from the actual
quotients.  In particular, powers of one ideal give the adic tower, and the
canonical adjacent reductions induce maps between the horizontal kernels that
intertwine their monodromy operators.  The horizontal characteristic
polynomials commute with the same reductions.  Each fixed polynomial
coefficient is packaged as a compatible quotient family represented by its
corresponding coefficient over the base algebra.  More generally, every tensor
over the base algebra with an original horizontal vector determines a
compatible family over all quotient levels.  On pure tensors only the
coefficient is reduced, and pointwise monodromy is induced by the original
restricted endomorphism.

This is the horizontal-module linear algebra in coefficientwise base change.
It assumes the derivative and commuting monodromy operator; it does not
construct a formal differential module, Levelt--Turrittin solution algebra,
fundamental solution, inverse-limit differential module, or analytic framed
monodromy.  The supplied coefficient algebra and ideal are not identified with
the manuscript's geometric coefficient data.  Without completeness and
separatedness the compatible-family map is not claimed injective or surjective.
For a finite-dimensional source and a filtration satisfying the explicit
coefficientwise completeness and zero-intersection hypotheses, Lean proves
that the map is bijective.  This is not a topological or categorical inverse-limit
statement.  All proofs are symbolic and kernel checked, with no external
computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

open TensorProduct

/-- A linear endomorphism commuting with a derivative restricts to the
derivative's kernel. -/
noncomputable def horizontalEndomorphism
    {k V : Type*} [CommRing k] [AddCommGroup V] [Module k V]
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative) :
    LinearMap.ker derivative →ₗ[k] LinearMap.ker derivative where
  toFun value := ⟨monodromy value, by
    change derivative (monodromy value) = 0
    have equality := LinearMap.congr_fun commutes value
    change derivative (monodromy value) = monodromy (derivative value) at equality
    rw [equality, value.property, map_zero]⟩
  map_add' left right := by
    apply Subtype.ext
    simp
  map_smul' scalar value := by
    apply Subtype.ext
    simp

/-- The scalar-extended monodromy restricts to the kernel of the
scalar-extended derivative. -/
noncomputable def extendedHorizontalEndomorphism
    {k V B : Type*} [CommRing k] [AddCommGroup V] [Module k V]
    [CommRing B] [Algebra k B]
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative) :
    LinearMap.ker (derivative.baseChange B) →ₗ[B]
      LinearMap.ker (derivative.baseChange B) where
  toFun value := ⟨monodromy.baseChange B value, by
    change derivative.baseChange B (monodromy.baseChange B value) = 0
    calc
      derivative.baseChange B (monodromy.baseChange B value) =
          (derivative.comp monodromy).baseChange B value := by
            rw [LinearMap.baseChange_comp]
            rfl
      _ = (monodromy.comp derivative).baseChange B value := by rw [commutes]
      _ = monodromy.baseChange B (derivative.baseChange B value) := by
            rw [LinearMap.baseChange_comp]
            rfl
      _ = 0 := by rw [value.property, map_zero]⟩
  map_add' left right := by
    apply Subtype.ext
    simp
  map_smul' scalar value := by
    apply Subtype.ext
    simp

/-- The canonical flat-base-change equivalence between the scalar extension
of the horizontal subspace and the kernel of the extended derivative. -/
noncomputable def horizontalBaseChangeEquiv
    {k V B : Type*} [CommRing k] [AddCommGroup V] [Module k V]
    [CommRing B] [Algebra k B] [Module.Flat k B]
    (derivative : V →ₗ[k] V) :
    B ⊗[k] LinearMap.ker derivative ≃ₗ[B]
      LinearMap.ker (derivative.baseChange B) :=
  LinearMap.tensorKerEquiv B B derivative

/-- Over a field every coefficient algebra is flat, so the canonical
horizontal-space base-change equivalence needs no additional flatness premise. -/
noncomputable def horizontalBaseChangeEquivOfField
    {k V B : Type*} [Field k] [AddCommGroup V] [Module k V]
    [CommRing B] [Algebra k B]
    (derivative : V →ₗ[k] V) :
    B ⊗[k] LinearMap.ker derivative ≃ₗ[B]
      LinearMap.ker (derivative.baseChange B) := by
  letI : Module.Free k B := Module.Free.of_divisionRing k B
  letI : Module.Flat k B := Module.Flat.of_free
  exact horizontalBaseChangeEquiv derivative

/-- The canonical horizontal-space equivalence intertwines the scalar-extended
restricted monodromy and the restriction of the extended monodromy. -/
theorem horizontalBaseChangeEquiv_intertwines
    {k V B : Type*} [CommRing k] [AddCommGroup V] [Module k V]
    [CommRing B] [Algebra k B] [Module.Flat k B]
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative) :
    (extendedHorizontalEndomorphism derivative monodromy commutes).comp
        (horizontalBaseChangeEquiv derivative).toLinearMap =
      (horizontalBaseChangeEquiv derivative).toLinearMap.comp
        ((horizontalEndomorphism derivative monodromy commutes).baseChange B) := by
  apply LinearMap.ext
  intro tensor
  induction tensor using TensorProduct.induction_on with
  | zero => simp
  | add left right hleft hright =>
      rw [map_add, map_add]
      exact congrArg₂ (· + ·) hleft hright
  | tmul coefficient value =>
      apply Subtype.ext
      rfl

/-- The extended horizontal monodromy is the conjugate, through the canonical
kernel base-change equivalence, of the scalar-extended original horizontal
monodromy. -/
theorem extendedHorizontalEndomorphism_eq_conj
    {k V B : Type*} [CommRing k] [AddCommGroup V] [Module k V]
    [CommRing B] [Algebra k B] [Module.Flat k B]
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative) :
    extendedHorizontalEndomorphism derivative monodromy commutes =
      (horizontalBaseChangeEquiv derivative).conj
        ((horizontalEndomorphism derivative monodromy commutes).baseChange B) := by
  apply LinearMap.ext
  intro value
  obtain ⟨preimage, rfl⟩ :=
    (horizontalBaseChangeEquiv derivative).surjective value
  have equality := LinearMap.congr_fun
    (horizontalBaseChangeEquiv_intertwines derivative monodromy commutes) preimage
  simpa using equality

/-- Over a field, the canonical base-change equivalence intertwines the two
horizontal monodromy operators without a separately supplied flatness
hypothesis. -/
theorem horizontalBaseChangeEquivOfField_intertwines
    {k V B : Type*} [Field k] [AddCommGroup V] [Module k V]
    [CommRing B] [Algebra k B]
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative) :
    (extendedHorizontalEndomorphism derivative monodromy commutes).comp
        (horizontalBaseChangeEquivOfField derivative).toLinearMap =
      (horizontalBaseChangeEquivOfField derivative).toLinearMap.comp
        ((horizontalEndomorphism derivative monodromy commutes).baseChange B) := by
  letI : Module.Free k B := Module.Free.of_divisionRing k B
  letI : Module.Flat k B := Module.Flat.of_free
  simpa only [horizontalBaseChangeEquivOfField] using
    horizontalBaseChangeEquiv_intertwines derivative monodromy commutes

/-- Over a field, restriction to the extended horizontal subspace is conjugate
to scalar extension of the original restricted monodromy. -/
theorem extendedHorizontalEndomorphism_eq_conj_ofField
    {k V B : Type*} [Field k] [AddCommGroup V] [Module k V]
    [CommRing B] [Algebra k B]
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative) :
    extendedHorizontalEndomorphism derivative monodromy commutes =
      (horizontalBaseChangeEquivOfField derivative).conj
        ((horizontalEndomorphism derivative monodromy commutes).baseChange B) := by
  letI : Module.Free k B := Module.Free.of_divisionRing k B
  letI : Module.Flat k B := Module.Flat.of_free
  simpa only [horizontalBaseChangeEquivOfField] using
    extendedHorizontalEndomorphism_eq_conj derivative monodromy commutes

/-- For finite-dimensional horizontal space, scalar extension maps every
coefficient of the horizontal-monodromy characteristic polynomial along the
coefficient algebra map. -/
theorem horizontalEndomorphism_charpoly_baseChange
    {k V B : Type*} [Field k] [AddCommGroup V] [Module k V]
    [CommRing B] [Algebra k B]
    (derivative monodromy : V →ₗ[k] V)
    [FiniteDimensional k (LinearMap.ker derivative)]
    (commutes : derivative.comp monodromy = monodromy.comp derivative) :
    ((horizontalEndomorphism derivative monodromy commutes).baseChange B).charpoly =
      (horizontalEndomorphism derivative monodromy commutes).charpoly.map
        (algebraMap k B) :=
  LinearMap.charpoly_baseChange _ B

/-- A tower of coefficient algebras for one finite-dimensional commuting
derivative--monodromy pair.  The adjacent reductions preserve the ground
field because they are algebra homomorphisms. -/
structure HorizontalMonodromyCoefficientTower
    (k V : Type*) [Field k] [AddCommGroup V] [Module k V] where
  Coefficient : ℕ → Type*
  coefficientCommRing : ∀ level, CommRing (Coefficient level)
  coefficientAlgebra : ∀ level, Algebra k (Coefficient level)
  reduction : ∀ level, Coefficient (level + 1) →ₐ[k] Coefficient level
  derivative : V →ₗ[k] V
  monodromy : V →ₗ[k] V
  commutes : derivative.comp monodromy = monodromy.comp derivative

attribute [instance]
  HorizontalMonodromyCoefficientTower.coefficientCommRing
  HorizontalMonodromyCoefficientTower.coefficientAlgebra

namespace HorizontalMonodromyCoefficientTower

variable {k V : Type*} [Field k] [AddCommGroup V] [Module k V]
  [FiniteDimensional k V]

/-- The coefficient-algebra tower obtained from the actual quotient rings of
a decreasing ideal filtration.  Its reductions are the canonical quotient
maps. -/
noncomputable def ofIdealFiltration
    {B : Type*} [CommRing B] [Algebra k B]
    (filtration : DecreasingIdealFiltration B)
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative) :
    HorizontalMonodromyCoefficientTower k V where
  Coefficient level := filtration.QuotientRing level
  coefficientCommRing _ := inferInstance
  coefficientAlgebra _ := inferInstance
  reduction level :=
    { filtration.reduction level with
      commutes' := by
        intro scalar
        change filtration.reduction level
            (Ideal.Quotient.mk (filtration.ideal (level + 1))
              (algebraMap k B scalar)) =
          Ideal.Quotient.mk (filtration.ideal level) (algebraMap k B scalar)
        exact filtration.reduction_mk level (algebraMap k B scalar) }
  derivative := derivative
  monodromy := monodromy
  commutes := commutes

/-- The horizontal-monodromy coefficient tower attached to the powers of one
ideal.  Level `n` is the actual quotient by `I^n`. -/
noncomputable def ofAdicIdeal
    {B : Type*} [CommRing B] [Algebra k B]
    (ideal : Ideal B)
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative) :
    HorizontalMonodromyCoefficientTower k V :=
  ofIdealFiltration (adicFiltration ideal) derivative monodromy commutes

/-- The horizontal-monodromy characteristic polynomial after extending its
coefficients from the ground field to a commutative coefficient algebra. -/
noncomputable def horizontalCharacteristicPolynomialOver
    {B : Type*} [CommRing B] [Algebra k B]
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative) :
    Polynomial B :=
  (horizontalEndomorphism derivative monodromy commutes).charpoly.map
    (algebraMap k B)

/-- The canonical reduction between horizontal kernels at two adjacent
coefficient levels.  It transports a horizontal vector to the scalar-extended
original kernel, maps its coefficient factor, and transports back. -/
noncomputable def horizontalKernelReduction
    (tower : HorizontalMonodromyCoefficientTower k V) (level : ℕ) :
    LinearMap.ker (tower.derivative.baseChange (tower.Coefficient (level + 1))) →ₗ[k]
      LinearMap.ker (tower.derivative.baseChange (tower.Coefficient level)) :=
  ((horizontalBaseChangeEquivOfField
      (B := tower.Coefficient level) tower.derivative).toLinearMap.restrictScalars k).comp
    ((TensorProduct.map (tower.reduction level).toLinearMap LinearMap.id).comp
      ((horizontalBaseChangeEquivOfField
        (B := tower.Coefficient (level + 1)) tower.derivative).symm.toLinearMap.restrictScalars k))

omit [FiniteDimensional k V] in
/-- Adjacent horizontal-kernel reduction maps a pure scalar extension of an
original horizontal vector by applying the coefficient reduction. -/
theorem horizontalKernelReduction_baseChange_tmul
    (tower : HorizontalMonodromyCoefficientTower k V) (level : ℕ)
    (coefficient : tower.Coefficient (level + 1))
    (value : LinearMap.ker tower.derivative) :
    tower.horizontalKernelReduction level
        (horizontalBaseChangeEquivOfField tower.derivative
          (coefficient ⊗ₜ[k] value)) =
      horizontalBaseChangeEquivOfField tower.derivative
        (tower.reduction level coefficient ⊗ₜ[k] value) := by
  simp [horizontalKernelReduction]

omit [FiniteDimensional k V] in
/-- Canonical adjacent reduction of horizontal kernels intertwines the
extended horizontal monodromy operators. -/
theorem horizontalKernelReduction_intertwines
    (tower : HorizontalMonodromyCoefficientTower k V) (level : ℕ) :
    (tower.horizontalKernelReduction level).comp
        ((extendedHorizontalEndomorphism (B := tower.Coefficient (level + 1))
          tower.derivative tower.monodromy tower.commutes).restrictScalars k) =
      ((extendedHorizontalEndomorphism (B := tower.Coefficient level)
          tower.derivative tower.monodromy tower.commutes).restrictScalars k).comp
        (tower.horizontalKernelReduction level) := by
  apply LinearMap.ext
  intro value
  obtain ⟨tensor, rfl⟩ :=
    (horizontalBaseChangeEquivOfField
      (B := tower.Coefficient (level + 1)) tower.derivative).surjective value
  induction tensor using TensorProduct.induction_on with
  | zero => simp
  | add left right hleft hright =>
      simpa only [map_add] using congrArg₂ (fun x y => x + y) hleft hright
  | tmul coefficient horizontal =>
      have highIntertwines := LinearMap.congr_fun
        (horizontalBaseChangeEquivOfField_intertwines
          (B := tower.Coefficient (level + 1)) tower.derivative
          tower.monodromy tower.commutes)
        (coefficient ⊗ₜ[k] horizontal)
      have lowIntertwines := LinearMap.congr_fun
        (horizontalBaseChangeEquivOfField_intertwines
          (B := tower.Coefficient level) tower.derivative
          tower.monodromy tower.commutes)
        (tower.reduction level coefficient ⊗ₜ[k] horizontal)
      simp only [LinearMap.comp_apply] at highIntertwines lowIntertwines
      have highPure :
          extendedHorizontalEndomorphism
              (B := tower.Coefficient (level + 1)) tower.derivative
              tower.monodromy tower.commutes
                (horizontalBaseChangeEquivOfField tower.derivative
                  (coefficient ⊗ₜ[k] horizontal)) =
            horizontalBaseChangeEquivOfField tower.derivative
              (coefficient ⊗ₜ[k]
                horizontalEndomorphism tower.derivative tower.monodromy
                  tower.commutes horizontal) := by
        simpa using highIntertwines
      have lowPure :
          extendedHorizontalEndomorphism (B := tower.Coefficient level)
              tower.derivative tower.monodromy tower.commutes
                (horizontalBaseChangeEquivOfField tower.derivative
                  (tower.reduction level coefficient ⊗ₜ[k] horizontal)) =
            horizontalBaseChangeEquivOfField tower.derivative
              (tower.reduction level coefficient ⊗ₜ[k]
                horizontalEndomorphism tower.derivative tower.monodromy
                  tower.commutes horizontal) := by
        simpa using lowIntertwines
      simp only [LinearMap.comp_apply]
      calc
        tower.horizontalKernelReduction level
            (extendedHorizontalEndomorphism
              (B := tower.Coefficient (level + 1)) tower.derivative
              tower.monodromy tower.commutes
                (horizontalBaseChangeEquivOfField tower.derivative
                  (coefficient ⊗ₜ[k] horizontal))) =
          tower.horizontalKernelReduction level
            (horizontalBaseChangeEquivOfField tower.derivative
              (coefficient ⊗ₜ[k]
                horizontalEndomorphism tower.derivative tower.monodromy
                  tower.commutes horizontal)) :=
            congrArg (tower.horizontalKernelReduction level) highPure
        _ = horizontalBaseChangeEquivOfField tower.derivative
              (tower.reduction level coefficient ⊗ₜ[k]
                horizontalEndomorphism tower.derivative tower.monodromy
                  tower.commutes horizontal) :=
            horizontalKernelReduction_baseChange_tmul tower level coefficient
              (horizontalEndomorphism tower.derivative tower.monodromy
                tower.commutes horizontal)
        _ = extendedHorizontalEndomorphism (B := tower.Coefficient level)
              tower.derivative tower.monodromy tower.commutes
                (horizontalBaseChangeEquivOfField tower.derivative
                  (tower.reduction level coefficient ⊗ₜ[k] horizontal)) :=
            lowPure.symm
        _ = extendedHorizontalEndomorphism (B := tower.Coefficient level)
              tower.derivative tower.monodromy tower.commutes
                (tower.horizontalKernelReduction level
                  (horizontalBaseChangeEquivOfField tower.derivative
                    (coefficient ⊗ₜ[k] horizontal))) := by
            apply congrArg
            exact (horizontalKernelReduction_baseChange_tmul
              tower level coefficient horizontal).symm

/-- A compatible family of horizontal vectors in a coefficient-algebra tower.
Compatibility uses the canonical adjacent horizontal-kernel reductions. -/
structure CompatibleHorizontalKernelFamily
    (tower : HorizontalMonodromyCoefficientTower k V) where
  value : ∀ level,
    LinearMap.ker (tower.derivative.baseChange (tower.Coefficient level))
  compatible : ∀ level,
    tower.horizontalKernelReduction level (value (level + 1)) = value level

omit [FiniteDimensional k V] in
/-- Two compatible horizontal families are equal when their values agree at
every coefficient level. -/
@[ext]
theorem CompatibleHorizontalKernelFamily.ext
    {tower : HorizontalMonodromyCoefficientTower k V}
    {left right : CompatibleHorizontalKernelFamily tower}
    (equality : ∀ level, left.value level = right.value level) : left = right := by
  cases left with
  | mk leftValue leftCompatible =>
    cases right with
    | mk rightValue rightCompatible =>
      have valueEquality : leftValue = rightValue := funext equality
      subst rightValue
      rfl

/-- Base change of coefficients commutes with every coordinate in a
base-changed module basis. -/
theorem basisBaseChange_repr_tensorProduct_map
    {H B C ι : Type*} [AddCommGroup H] [Module k H]
    [CommRing B] [Algebra k B] [CommRing C] [Algebra k C]
    (basis : Module.Basis ι k H) (coefficientMap : B →ₐ[k] C)
    (tensor : B ⊗[k] H) (index : ι) :
    coefficientMap ((basis.baseChange B).repr tensor index) =
      (basis.baseChange C).repr
        (TensorProduct.map coefficientMap.toLinearMap LinearMap.id tensor)
        index := by
  induction tensor using TensorProduct.induction_on with
  | zero => simp
  | add left right hleft hright =>
      simpa only [map_add, Finsupp.add_apply] using
        congrArg₂ (fun x y => x + y) hleft hright
  | tmul coefficient value =>
      simp [Module.Basis.baseChange_repr_tmul]

omit [FiniteDimensional k V] in
/-- Compatible coefficient maps from one module into a coefficient-algebra
tower send a tensor with an original horizontal vector to a compatible family
of extended horizontal vectors. -/
noncomputable def compatibleHorizontalKernelFamilyOfTensor
    (tower : HorizontalMonodromyCoefficientTower k V)
    {B : Type*} [AddCommGroup B] [Module k B]
    (coefficientMap : ∀ level, B →ₗ[k] tower.Coefficient level)
    (coefficientMap_compatible : ∀ level coefficient,
      tower.reduction level (coefficientMap (level + 1) coefficient) =
        coefficientMap level coefficient)
    (tensor : B ⊗[k] LinearMap.ker tower.derivative) :
    CompatibleHorizontalKernelFamily tower where
  value level :=
    horizontalBaseChangeEquivOfField tower.derivative
      (TensorProduct.map (coefficientMap level) LinearMap.id tensor)
  compatible level := by
    induction tensor using TensorProduct.induction_on with
    | zero => simp
    | add left right hleft hright =>
        simpa only [map_add] using congrArg₂ (fun x y => x + y) hleft hright
    | tmul coefficient horizontal =>
        rw [TensorProduct.map_tmul, TensorProduct.map_tmul,
          horizontalKernelReduction_baseChange_tmul,
          coefficientMap_compatible]

omit [FiniteDimensional k V] in
/-- The extended horizontal monodromy acts pointwise on the compatible family
by applying the original restricted monodromy to the horizontal tensor factor. -/
theorem compatibleHorizontalKernelFamilyOfTensor_monodromy
    (tower : HorizontalMonodromyCoefficientTower k V)
    {B : Type*} [AddCommGroup B] [Module k B]
    (coefficientMap : ∀ level, B →ₗ[k] tower.Coefficient level)
    (coefficientMap_compatible : ∀ level coefficient,
      tower.reduction level (coefficientMap (level + 1) coefficient) =
        coefficientMap level coefficient)
    (tensor : B ⊗[k] LinearMap.ker tower.derivative) (level : ℕ) :
    extendedHorizontalEndomorphism (B := tower.Coefficient level)
        tower.derivative tower.monodromy tower.commutes
        ((compatibleHorizontalKernelFamilyOfTensor tower coefficientMap
          coefficientMap_compatible tensor).value level) =
      (compatibleHorizontalKernelFamilyOfTensor tower coefficientMap
        coefficientMap_compatible
        (TensorProduct.map LinearMap.id
          (horizontalEndomorphism tower.derivative tower.monodromy
            tower.commutes) tensor)).value level := by
  induction tensor using TensorProduct.induction_on with
  | zero => simp [compatibleHorizontalKernelFamilyOfTensor]
  | add left right hleft hright =>
      simpa [compatibleHorizontalKernelFamilyOfTensor] using
        congrArg₂ (fun x y => x + y) hleft hright
  | tmul coefficient horizontal =>
      have equality := LinearMap.congr_fun
        (horizontalBaseChangeEquivOfField_intertwines
          (B := tower.Coefficient level) tower.derivative tower.monodromy
          tower.commutes)
        (coefficientMap level coefficient ⊗ₜ[k] horizontal)
      simpa [compatibleHorizontalKernelFamilyOfTensor] using equality

omit [FiniteDimensional k V] in
/-- A horizontal tensor over the base coefficient algebra determines a
compatible family over every quotient of a decreasing ideal filtration. -/
noncomputable def horizontalKernelFamilyOfBaseTensor
    {B : Type*} [CommRing B] [Algebra k B]
    (filtration : DecreasingIdealFiltration B)
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative)
    (tensor : B ⊗[k] LinearMap.ker derivative) :
    CompatibleHorizontalKernelFamily
      (ofIdealFiltration filtration derivative monodromy commutes) :=
  compatibleHorizontalKernelFamilyOfTensor
    (ofIdealFiltration filtration derivative monodromy commutes)
    (fun level =>
      (Ideal.Quotient.mkₐ k (filtration.ideal level)).toLinearMap)
    (by
      intro level coefficient
      exact filtration.reduction_mk level coefficient)
    tensor

omit [FiniteDimensional k V] in
/-- At each level, the family represented by a pure base tensor is obtained by
mapping its coefficient to that quotient and leaving its horizontal vector
unchanged. -/
theorem horizontalKernelFamilyOfBaseTensor_value_tmul
    {B : Type*} [CommRing B] [Algebra k B]
    (filtration : DecreasingIdealFiltration B)
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative)
    (coefficient : B) (horizontal : LinearMap.ker derivative) (level : ℕ) :
    (horizontalKernelFamilyOfBaseTensor filtration derivative monodromy
      commutes (coefficient ⊗ₜ[k] horizontal)).value level =
        horizontalBaseChangeEquivOfField derivative
          (Ideal.Quotient.mk (filtration.ideal level) coefficient ⊗ₜ[k]
            horizontal) := by
  change horizontalBaseChangeEquivOfField derivative
      (TensorProduct.map
        (Ideal.Quotient.mkₐ k (filtration.ideal level)).toLinearMap
        LinearMap.id (coefficient ⊗ₜ[k] horizontal)) = _
  simp

omit [FiniteDimensional k V] in
/-- At each quotient level, extended horizontal monodromy on the family of a
base tensor is the family of the tensor obtained by applying the original
restricted horizontal monodromy to its horizontal factor. -/
theorem horizontalKernelFamilyOfBaseTensor_monodromy
    {B : Type*} [CommRing B] [Algebra k B]
    (filtration : DecreasingIdealFiltration B)
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative)
    (tensor : B ⊗[k] LinearMap.ker derivative) (level : ℕ) :
    extendedHorizontalEndomorphism (B := filtration.QuotientRing level)
        derivative monodromy commutes
        ((horizontalKernelFamilyOfBaseTensor filtration derivative monodromy
          commutes tensor).value level) =
      (horizontalKernelFamilyOfBaseTensor filtration derivative monodromy
        commutes
        (TensorProduct.map LinearMap.id
          (horizontalEndomorphism derivative monodromy commutes) tensor)).value
            level := by
  exact compatibleHorizontalKernelFamilyOfTensor_monodromy
    (ofIdealFiltration filtration derivative monodromy commutes)
    (fun quotientLevel =>
      (Ideal.Quotient.mkₐ k
        (filtration.ideal quotientLevel)).toLinearMap)
    (by
      intro quotientLevel coefficient
      exact filtration.reduction_mk quotientLevel coefficient)
    tensor level

omit [FiniteDimensional k V] in
/-- Relative to a basis of the original horizontal subspace, this is one
coefficient of a compatible horizontal family at a selected tower level. -/
noncomputable def compatibleHorizontalKernelFamilyCoordinateValue
    {ι : Type*} (tower : HorizontalMonodromyCoefficientTower k V)
    (basis : Module.Basis ι k (LinearMap.ker tower.derivative))
    (family : CompatibleHorizontalKernelFamily tower)
    (index : ι) (level : ℕ) : tower.Coefficient level :=
  (basis.baseChange (tower.Coefficient level)).repr
    ((horizontalBaseChangeEquivOfField tower.derivative).symm
      (family.value level)) index

omit [FiniteDimensional k V] in
/-- Coordinates of a compatible horizontal family commute with every adjacent
coefficient reduction. -/
theorem compatibleHorizontalKernelFamilyCoordinateValue_compatible
    {ι : Type*} (tower : HorizontalMonodromyCoefficientTower k V)
    (basis : Module.Basis ι k (LinearMap.ker tower.derivative))
    (family : CompatibleHorizontalKernelFamily tower)
    (index : ι) (level : ℕ) :
    tower.reduction level
        (compatibleHorizontalKernelFamilyCoordinateValue tower basis family
          index (level + 1)) =
      compatibleHorizontalKernelFamilyCoordinateValue tower basis family
        index level := by
    have tensorCompatible :
        TensorProduct.map
            (tower.reduction level).toLinearMap LinearMap.id
            ((horizontalBaseChangeEquivOfField tower.derivative).symm
              (family.value (level + 1))) =
          (horizontalBaseChangeEquivOfField tower.derivative).symm
            (family.value level) := by
      apply (horizontalBaseChangeEquivOfField
        (B := tower.Coefficient level) tower.derivative).injective
      rw [(horizontalBaseChangeEquivOfField
        (B := tower.Coefficient level) tower.derivative).apply_symm_apply]
      change tower.horizontalKernelReduction level (family.value (level + 1)) =
        family.value level
      exact family.compatible level
    calc
      tower.reduction level
          ((basis.baseChange (tower.Coefficient (level + 1))).repr
            ((horizontalBaseChangeEquivOfField tower.derivative).symm
              (family.value (level + 1))) index) =
        (basis.baseChange (tower.Coefficient level)).repr
          (TensorProduct.map
            (tower.reduction level).toLinearMap
            LinearMap.id
            ((horizontalBaseChangeEquivOfField tower.derivative).symm
              (family.value (level + 1)))) index :=
        basisBaseChange_repr_tensorProduct_map basis
          (tower.reduction level)
          ((horizontalBaseChangeEquivOfField tower.derivative).symm
            (family.value (level + 1))) index
      _ = (basis.baseChange (tower.Coefficient level)).repr
          ((horizontalBaseChangeEquivOfField tower.derivative).symm
            (family.value level)) index :=
        congrArg
          (fun tensor =>
            (basis.baseChange (tower.Coefficient level)).repr tensor index)
          tensorCompatible

omit [FiniteDimensional k V] in
/-- Relative to a basis of the original horizontal subspace, one coordinate of
a compatible horizontal family over quotient rings is a compatible quotient
family. -/
noncomputable def compatibleHorizontalKernelFamilyCoordinate
    {B ι : Type*} [CommRing B] [Algebra k B]
    (filtration : DecreasingIdealFiltration B)
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative)
    (basis : Module.Basis ι k (LinearMap.ker derivative))
    (family : CompatibleHorizontalKernelFamily
      (ofIdealFiltration filtration derivative monodromy commutes))
    (index : ι) : filtration.CompatibleQuotientFamily where
  value level := compatibleHorizontalKernelFamilyCoordinateValue
    (ofIdealFiltration filtration derivative monodromy commutes) basis family
      index level
  compatible level :=
    compatibleHorizontalKernelFamilyCoordinateValue_compatible
      (ofIdealFiltration filtration derivative monodromy commutes) basis family
        index level

omit [FiniteDimensional k V] in
/-- Every coordinate family of the horizontal family represented by a base
tensor is the compatible quotient family represented by the corresponding
base-tensor coordinate. -/
theorem compatibleHorizontalKernelFamilyCoordinate_ofBaseTensor
    {B ι : Type*} [CommRing B] [Algebra k B]
    (filtration : DecreasingIdealFiltration B)
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative)
    (basis : Module.Basis ι k (LinearMap.ker derivative))
    (tensor : B ⊗[k] LinearMap.ker derivative) (index : ι) :
    compatibleHorizontalKernelFamilyCoordinate filtration derivative monodromy
        commutes basis
        (horizontalKernelFamilyOfBaseTensor filtration derivative monodromy
          commutes tensor) index =
      filtration.ofRingElement ((basis.baseChange B).repr tensor index) := by
  ext level
  change (basis.baseChange (filtration.QuotientRing level)).repr
      ((horizontalBaseChangeEquivOfField derivative).symm
        (horizontalBaseChangeEquivOfField derivative
          (TensorProduct.map
            (Ideal.Quotient.mkₐ k (filtration.ideal level)).toLinearMap
            LinearMap.id tensor))) index =
    Ideal.Quotient.mk (filtration.ideal level)
      ((basis.baseChange B).repr tensor index)
  rw [(horizontalBaseChangeEquivOfField derivative).symm_apply_apply]
  exact (basisBaseChange_repr_tensorProduct_map basis
    (Ideal.Quotient.mkₐ k (filtration.ideal level)) tensor index).symm

omit [FiniteDimensional k V] in
/-- Zero intersection of the filtration ideals makes the canonical map from
base horizontal tensors to compatible horizontal quotient families injective. -/
theorem horizontalKernelFamilyOfBaseTensor_injective
    {B : Type*} [CommRing B] [Algebra k B]
    (filtration : DecreasingIdealFiltration B)
    (derivative monodromy : V →ₗ[k] V)
    [FiniteDimensional k (LinearMap.ker derivative)]
    (commutes : derivative.comp monodromy = monodromy.comp derivative)
    (separated : iInf filtration.ideal = ⊥) :
    Function.Injective
      (horizontalKernelFamilyOfBaseTensor filtration derivative monodromy
        commutes) := by
  let basis := Module.finBasis k (LinearMap.ker derivative)
  intro left right familiesEqual
  apply (basis.baseChange B).repr.injective
  apply Finsupp.ext
  intro index
  have coordinateFamiliesEqual := congrArg
    (fun family => compatibleHorizontalKernelFamilyCoordinate filtration
      derivative monodromy commutes basis family index)
    familiesEqual
  rw [compatibleHorizontalKernelFamilyCoordinate_ofBaseTensor,
    compatibleHorizontalKernelFamilyCoordinate_ofBaseTensor]
    at coordinateFamiliesEqual
  exact (filtration.ofRingElement_injective_iff_iInf_eq_bot.mpr separated)
    coordinateFamiliesEqual

omit [FiniteDimensional k V] in
/-- Coefficientwise completeness makes every compatible horizontal quotient
family arise from a tensor over the base coefficient algebra. -/
theorem horizontalKernelFamilyOfBaseTensor_surjective
    {B : Type*} [CommRing B] [Algebra k B]
    (filtration : DecreasingIdealFiltration B)
    (derivative monodromy : V →ₗ[k] V)
    [FiniteDimensional k (LinearMap.ker derivative)]
    (commutes : derivative.comp monodromy = monodromy.comp derivative)
    (complete : filtration.IsComplete) :
    Function.Surjective
      (horizontalKernelFamilyOfBaseTensor filtration derivative monodromy
        commutes) := by
  let basis := Module.finBasis k (LinearMap.ker derivative)
  intro family
  choose coefficient coefficientRepresents using fun index =>
    complete (compatibleHorizontalKernelFamilyCoordinate filtration derivative
      monodromy commutes basis family index)
  let tensor : B ⊗[k] LinearMap.ker derivative :=
    (basis.baseChange B).repr.symm
      (Finsupp.equivFunOnFinite.symm coefficient)
  refine ⟨tensor, ?_⟩
  apply CompatibleHorizontalKernelFamily.ext
  intro level
  apply (horizontalBaseChangeEquivOfField
    (B := filtration.QuotientRing level) derivative).symm.injective
  apply (basis.baseChange (filtration.QuotientRing level)).repr.injective
  apply Finsupp.ext
  intro index
  have coordinateEquality :
      compatibleHorizontalKernelFamilyCoordinate filtration derivative
          monodromy commutes basis
          (horizontalKernelFamilyOfBaseTensor filtration derivative monodromy
            commutes tensor) index =
        compatibleHorizontalKernelFamilyCoordinate filtration derivative
          monodromy commutes basis family index := by
    rw [compatibleHorizontalKernelFamilyCoordinate_ofBaseTensor]
    have representation : (basis.baseChange B).repr tensor index =
        coefficient index := by simp [tensor]
    rw [representation]
    change filtration.ofRingElement (coefficient index) = _
    exact coefficientRepresents index
  exact congrArg
    (fun coefficientFamily : filtration.CompatibleQuotientFamily =>
      coefficientFamily.value level)
    coordinateEquality

omit [FiniteDimensional k V] in
/-- The canonical map from base horizontal tensors to compatible horizontal
quotient families is bijective for a coefficientwise complete and separated
filtration. -/
theorem horizontalKernelFamilyOfBaseTensor_bijective
    {B : Type*} [CommRing B] [Algebra k B]
    (filtration : DecreasingIdealFiltration B)
    (derivative monodromy : V →ₗ[k] V)
    [FiniteDimensional k (LinearMap.ker derivative)]
    (commutes : derivative.comp monodromy = monodromy.comp derivative)
    (complete : filtration.IsComplete)
    (separated : iInf filtration.ideal = ⊥) :
    Function.Bijective
      (horizontalKernelFamilyOfBaseTensor filtration derivative monodromy
        commutes) :=
  ⟨horizontalKernelFamilyOfBaseTensor_injective filtration derivative monodromy
      commutes separated,
    horizontalKernelFamilyOfBaseTensor_surjective filtration derivative monodromy
      commutes complete⟩

/-- The horizontal monodromy characteristic polynomials at all coefficient
levels form an explicit compatible polynomial system. -/
noncomputable def characteristicPolynomialSystem
    (tower : HorizontalMonodromyCoefficientTower k V) :
    CompatibleCharacteristicPolynomialSystem where
  Coefficient := tower.Coefficient
  coefficientRing := tower.coefficientCommRing
  reduction level := (tower.reduction level).toRingHom
  characteristicPolynomial level :=
    ((horizontalEndomorphism tower.derivative tower.monodromy tower.commutes).baseChange
      (tower.Coefficient level)).charpoly
  compatible level := by
    rw [horizontalEndomorphism_charpoly_baseChange,
      horizontalEndomorphism_charpoly_baseChange, Polynomial.map_map]
    congr 1
    ext scalar
    exact (tower.reduction level).commutes scalar

/-- At every level, the compatible polynomial system is the coefficientwise
image of the original horizontal-monodromy characteristic polynomial. -/
theorem characteristicPolynomialSystem_level
    (tower : HorizontalMonodromyCoefficientTower k V) (level : ℕ) :
    tower.characteristicPolynomialSystem.characteristicPolynomial level =
      (horizontalEndomorphism tower.derivative tower.monodromy tower.commutes).charpoly.map
        (algebraMap k (tower.Coefficient level)) :=
  horizontalEndomorphism_charpoly_baseChange
    tower.derivative tower.monodromy tower.commutes

/-- In the adic realization, every level polynomial is the image of the
original horizontal characteristic polynomial in `B/I^n`, and the canonical
reduction `B/I^(n+1) → B/I^n` maps the higher polynomial to the lower one. -/
theorem ofAdicIdeal_characteristicPolynomialSystem_level_and_compatible
    {B : Type*} [CommRing B] [Algebra k B]
    (ideal : Ideal B)
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative) :
    let tower := ofAdicIdeal ideal derivative monodromy commutes
    (∀ level,
      tower.characteristicPolynomialSystem.characteristicPolynomial level =
        (horizontalEndomorphism derivative monodromy commutes).charpoly.map
          ((Ideal.Quotient.mk (ideal ^ level)).comp (algebraMap k B))) ∧
    (∀ level,
      Polynomial.map ((adicFiltration ideal).reduction level)
          (tower.characteristicPolynomialSystem.characteristicPolynomial
            (level + 1)) =
        tower.characteristicPolynomialSystem.characteristicPolynomial level) := by
  dsimp only
  constructor
  · intro level
    rw [characteristicPolynomialSystem_level]
    rfl
  · exact
      (ofAdicIdeal ideal derivative monodromy commutes).characteristicPolynomialSystem.compatible

/-- The characteristic polynomial over the base coefficient algebra reduces
to the horizontal characteristic polynomial at every adic quotient level. -/
theorem horizontalCharacteristicPolynomialOver_map_adicQuotient
    {B : Type*} [CommRing B] [Algebra k B]
    (ideal : Ideal B)
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative)
    (level : ℕ) :
    let tower := ofAdicIdeal ideal derivative monodromy commutes
    Polynomial.map (Ideal.Quotient.mk (ideal ^ level))
        (horizontalCharacteristicPolynomialOver (B := B)
          derivative monodromy commutes) =
      tower.characteristicPolynomialSystem.characteristicPolynomial level := by
  dsimp only
  rw [horizontalCharacteristicPolynomialOver, Polynomial.map_map]
  exact
    ((ofAdicIdeal_characteristicPolynomialSystem_level_and_compatible
      ideal derivative monodromy commutes).1 level).symm

/-- For one polynomial degree, the coefficients of the horizontal-monodromy
characteristic polynomials over all adic quotients form a compatible quotient
family. -/
noncomputable def adicCharacteristicPolynomialCoefficientFamily
    {B : Type*} [CommRing B] [Algebra k B]
    (ideal : Ideal B)
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative)
    (degree : ℕ) :
    (adicFiltration ideal).CompatibleQuotientFamily where
  value level :=
    Ideal.Quotient.mk (ideal ^ level)
      (algebraMap k B
        ((horizontalEndomorphism derivative monodromy commutes).charpoly.coeff degree))
  compatible level :=
    (adicFiltration ideal).reduction_mk level
      (algebraMap k B
        ((horizontalEndomorphism derivative monodromy commutes).charpoly.coeff degree))

/-- The value of the compatible coefficient family at each level is literally
the corresponding coefficient of that level's horizontal characteristic
polynomial. -/
theorem adicCharacteristicPolynomialCoefficientFamily_value
    {B : Type*} [CommRing B] [Algebra k B]
    (ideal : Ideal B)
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative)
    (degree level : ℕ) :
    (adicCharacteristicPolynomialCoefficientFamily ideal derivative monodromy
      commutes degree).value level =
      ((horizontalEndomorphism derivative monodromy commutes).charpoly.map
        ((Ideal.Quotient.mk (ideal ^ level)).comp (algebraMap k B))).coeff degree := by
  simp [adicCharacteristicPolynomialCoefficientFamily, Polynomial.coeff_map]

/-- Each compatible adic coefficient family is the family represented by the
corresponding coefficient of the original horizontal characteristic polynomial,
mapped first into the base coefficient algebra. -/
theorem adicCharacteristicPolynomialCoefficientFamily_eq_ofRingElement
    {B : Type*} [CommRing B] [Algebra k B]
    (ideal : Ideal B)
    (derivative monodromy : V →ₗ[k] V)
    (commutes : derivative.comp monodromy = monodromy.comp derivative)
    (degree : ℕ) :
    adicCharacteristicPolynomialCoefficientFamily ideal derivative monodromy
        commutes degree =
      (adicFiltration ideal).ofRingElement
        (algebraMap k B
          ((horizontalEndomorphism derivative monodromy commutes).charpoly.coeff degree)) := by
  rfl

end HorizontalMonodromyCoefficientTower

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
