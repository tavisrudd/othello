import Mathlib.RingTheory.Localization.Basic

/-!
# Faithful localization of coefficient maps

An injective coefficient-ring map induces an injective map when the target
is localized at exactly the image of the source denominators. For a larger
target denominator set, injectivity follows under the explicit domain and
nonzero-denominator conditions. These statements use actual localization
maps, not a quotient of an injection with an unspecified kernel.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- Localizing source denominators and precisely their images preserves
injectivity without an additional domain hypothesis. -/
theorem faithfulCoefficientMap_imageLocalization
    {R S L M : Type*} [CommRing R] [CommRing S] [CommRing L] [CommRing M]
    (f : R →+* S) (injective : Function.Injective f) (denominators : Submonoid R)
    [Algebra R L] [IsLocalization denominators L]
    [Algebra S M] [IsLocalization (denominators.map f) M] :
    Function.Injective (IsLocalization.map M f denominators.le_comap_map : L →+* M) :=
  IsLocalization.map_injective_of_injective denominators L M injective

/-- A larger target localization also preserves injectivity when the target
coefficient ring is a domain and none of its denominators is zero. -/
theorem faithfulCoefficientMap_largerLocalization
    {R S L M : Type*} [CommRing R] [CommRing S] [IsDomain S]
    [CommRing L] [CommRing M]
    (f : R →+* S) (injective : Function.Injective f)
    (sourceDenominators : Submonoid R) (targetDenominators : Submonoid S)
    [Algebra R L] [IsLocalization sourceDenominators L]
    [Algebra S M] [IsLocalization targetDenominators M]
    (compatible : sourceDenominators ≤ targetDenominators.comap f)
    (nonzero : 0 ∉ targetDenominators) :
    Function.Injective (IsLocalization.map M f compatible : L →+* M) :=
  IsLocalization.map_injective_of_injective' sourceDenominators S M compatible nonzero injective

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
