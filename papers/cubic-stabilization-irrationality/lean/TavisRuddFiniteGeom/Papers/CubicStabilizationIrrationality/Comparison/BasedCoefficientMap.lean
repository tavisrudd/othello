import Mathlib.Algebra.Ring.Units

/-!
# Maps of coefficient rings with fixed basepoints

A formal comparison between completed germs must preserve their chosen
basepoints before continuity or completeness can be considered.  This module
packages that elementary requirement as a commuting residue square.  It proves
that based maps compose and that a coordinate in the source augmentation ideal
cannot be sent to a target coordinate plus a term with nonzero residue.

The last lemma records the corresponding Artin obstruction: an element whose
residue is a unit cannot become nilpotent.  These results do not construct a
completion or an analytic continuation; they isolate conditions required of
any such construction.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.BasedCoefficientMap

universe uk uA uB uC

/-- A commutative coefficient ring with a chosen residue map to the base
ring. -/
structure PointedRing (k : Type uk) [CommRing k] where
  Carrier : Type uA
  [carrierCommRing : CommRing Carrier]
  residue : Carrier →+* k

attribute [instance] PointedRing.carrierCommRing

/-- A ring homomorphism preserving the chosen residue maps. -/
structure BasedHom
    {k : Type uk} [CommRing k]
    (source : PointedRing k) (target : PointedRing k) where
  map : source.Carrier →+* target.Carrier
  residueNaturality : target.residue.comp map = source.residue

namespace BasedHom

variable
    {k : Type uk} [CommRing k]
    {source : PointedRing.{uk, uA} k}
    {middle : PointedRing.{uk, uB} k}
    {target : PointedRing.{uk, uC} k}

@[simp]
theorem residue_map (hom : BasedHom source target) (x : source.Carrier) :
    target.residue (hom.map x) = source.residue x := by
  exact DFunLike.congr_fun hom.residueNaturality x

/-- Based coefficient maps compose without changing the chosen basepoint. -/
def trans (first : BasedHom source middle) (second : BasedHom middle target) :
    BasedHom source target where
  map := second.map.comp first.map
  residueNaturality := by
    ext x
    simp

/-- A based map carries the source augmentation ideal into the target
augmentation ideal. -/
theorem mapsAugmentationIdeal
    (hom : BasedHom source target) (x : source.Carrier)
    (sourceResidue : source.residue x = 0) :
    target.residue (hom.map x) = 0 := by
  rw [hom.residue_map, sourceResidue]

/-- If a source coordinate and a target coordinate both vanish at their
basepoints, then the constant term in an equality
`map sourceCoordinate = targetCoordinate + constant` must also vanish at the
target basepoint. -/
theorem translatedConstant_residue_eq_zero
    (hom : BasedHom source target)
    (sourceCoordinate : source.Carrier)
    (targetCoordinate constant : target.Carrier)
    (sourceVanishes : source.residue sourceCoordinate = 0)
    (targetVanishes : target.residue targetCoordinate = 0)
    (translation : hom.map sourceCoordinate = targetCoordinate + constant) :
    target.residue constant = 0 := by
  have mappedVanishes := hom.mapsAugmentationIdeal sourceCoordinate sourceVanishes
  rw [translation, map_add, targetVanishes, zero_add] at mappedVanishes
  exact mappedVanishes

end BasedHom

/-- Taking a residue commutes with powers, so nilpotence upstairs implies
nilpotence of the residue. -/
theorem residue_pow_eq_zero_of_pow_eq_zero
    {k : Type uk} [CommRing k]
    (ring : PointedRing.{uk, uA} k) (x : ring.Carrier) (n : ℕ)
    (powerVanishes : x ^ n = 0) :
    ring.residue x ^ n = 0 := by
  rw [← map_pow, powerVanishes, map_zero]

/-- Over a nontrivial residue ring, an element with unit residue cannot be
nilpotent.  Thus an Artin coordinate cannot be translated by a unit constant
while preserving the chosen basepoint. -/
theorem pow_ne_zero_of_isUnit_residue
    {k : Type uk} [CommRing k] [Nontrivial k]
    (ring : PointedRing.{uk, uA} k) (x : ring.Carrier) (n : ℕ)
    (unitResidue : IsUnit (ring.residue x)) :
    x ^ n ≠ 0 := by
  intro powerVanishes
  have residuePowerVanishes :=
    residue_pow_eq_zero_of_pow_eq_zero ring x n powerVanishes
  obtain ⟨unit, unitValue⟩ := unitResidue
  rw [← unitValue] at residuePowerVanishes
  exact (one_ne_zero : (1 : k) ≠ 0) <| by
    calc
      (1 : k) = ((unit⁻¹ : kˣ) : k) ^ n * ((unit : kˣ) : k) ^ n := by
        rw [← mul_pow]
        simp
      _ = 0 := by rw [residuePowerVanishes, mul_zero]

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.BasedCoefficientMap
