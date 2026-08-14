import Mathlib.LinearAlgebra.Charpoly.BaseChange
import Mathlib.RingTheory.Flat.Equalizer
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.CompatibleMonodromySystem
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.FilteredCoefficientQuotients

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
horizontal characteristic polynomials commute with its canonical adjacent
reductions.

This is the horizontal-module linear algebra in coefficientwise base change.
It assumes the derivative and commuting monodromy operator; it does not
construct a formal differential module, Levelt--Turrittin solution algebra,
fundamental solution, inverse-limit differential module, or analytic framed
monodromy.  The supplied coefficient algebra and ideal are not identified with
the manuscript's geometric coefficient data.  All proofs are symbolic and
kernel checked, with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

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
    [FiniteDimensional k V]
    [CommRing B] [Algebra k B]
    (derivative monodromy : V →ₗ[k] V)
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

end HorizontalMonodromyCoefficientTower

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
