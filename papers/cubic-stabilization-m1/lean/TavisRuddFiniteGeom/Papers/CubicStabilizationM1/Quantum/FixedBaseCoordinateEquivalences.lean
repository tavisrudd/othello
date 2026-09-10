import Mathlib.Tactic
import Mathlib.Algebra.MvPolynomial.Equiv

/-!
# Fixed coordinate loci and polynomial translations

An equivariant coordinate equivalence restricts to an equivalence of actual
fixed-point loci; its inverse is equivariant as a consequence. Polynomial
translation in retained coordinates is an algebra equivalence, and extending
coefficients injectively before translating remains injective. These are
coordinate-ring and fixed-base statements. They do not replace a cohomology
fiber by its invariant vectors.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- The fixed locus of an action, with every fixed coordinate retained. -/
abbrev FixedCoordinateLocus (G X : Type*) [Monoid G] [MulAction G X] :=
  {x : X // ∀ g : G, g • x=x}

/-- Equivariance of a bijective coordinate change implies equivariance of its
inverse, with no separate inverse-equivariance hypothesis. -/
theorem coordinateEquiv_symm_equivariant
    {G X Y : Type*} [Monoid G] [MulAction G X] [MulAction G Y]
    (equiv : X ≃ Y) (equivariant : ∀ (g : G) (x : X), equiv (g • x)=g • equiv x) :
    ∀ (g : G) (y : Y), equiv.symm (g • y)=g • equiv.symm y := by
  intro g y
  apply equiv.injective
  rw [equiv.apply_symm_apply, equivariant, equiv.apply_symm_apply]

/-- The coordinate change and its inverse restrict to inverse maps on fixed
loci. This is restriction of the base coordinates, with no fiber operation. -/
def coordinateEquiv_fixedLoci
    {G X Y : Type*} [Monoid G] [MulAction G X] [MulAction G Y]
    (equiv : X ≃ Y) (equivariant : ∀ (g : G) (x : X), equiv (g • x)=g • equiv x) :
    FixedCoordinateLocus G X ≃ FixedCoordinateLocus G Y where
  toFun x := ⟨equiv x,fun g => by rw [← equivariant, x.property g]⟩
  invFun y := ⟨equiv.symm y,fun g => by
    rw [← coordinateEquiv_symm_equivariant equiv equivariant, y.property g]⟩
  left_inv x := Subtype.ext (equiv.symm_apply_apply x)
  right_inv y := Subtype.ext (equiv.apply_symm_apply y)

/-- Translation in polynomial coordinates, with constants in the coefficient ring. -/
noncomputable def polynomialCoordinateTranslation {R σ : Type*} [CommRing R]
    (shift : σ → R) : MvPolynomial σ R →ₐ[R] MvPolynomial σ R :=
  MvPolynomial.aeval fun i => MvPolynomial.X i + MvPolynomial.C (shift i)

/-- Translation by opposite constants is an inverse polynomial substitution. -/
theorem polynomialCoordinateTranslation_comp_neg {R σ : Type*} [CommRing R]
    (shift : σ → R) :
    (polynomialCoordinateTranslation shift).comp (polynomialCoordinateTranslation (-shift)) =
      AlgHom.id R (MvPolynomial σ R) := by
  ext i
  simp [polynomialCoordinateTranslation]

/-- Translation is an actual algebra equivalence of polynomial coordinate rings. -/
noncomputable def polynomialCoordinateTranslationEquiv {R σ : Type*} [CommRing R]
    (shift : σ → R) : MvPolynomial σ R ≃ₐ[R] MvPolynomial σ R :=
  AlgEquiv.ofAlgHom (polynomialCoordinateTranslation shift)
    (polynomialCoordinateTranslation (-shift))
    (polynomialCoordinateTranslation_comp_neg shift)
    (by simpa using polynomialCoordinateTranslation_comp_neg (-shift))

/-- Polynomial coefficient extension followed by translation is injective when
the coefficient-ring map is injective. Variables remain polynomial variables. -/
theorem polynomialCoefficientExtension_translation_injective
    {R S σ : Type*} [CommRing R] [CommRing S]
    (f : R →+* S) (injective : Function.Injective f) (shift : σ → S) :
    Function.Injective (fun p : MvPolynomial σ R =>
      polynomialCoordinateTranslation shift (MvPolynomial.map f p)) := by
  exact (polynomialCoordinateTranslationEquiv shift).injective.comp
    (MvPolynomial.map_injective f injective)

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
