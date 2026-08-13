import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.ProLaurent
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.Quantum.MonodromyBaseChange

/-!
# Compatible finite-level monodromy matrices

A coefficientwise compatible inverse system of finite square matrices produces
a compatible inverse system of characteristic polynomials.  This module proves
that compatibility rather than taking the polynomial system as unrelated input.
It is the finite-level algebra used when a compatible family of framed
monodromy operators has already been constructed.

No differential module, horizontal solution space, analytic monodromy, or
filtered quotient ring is constructed here.  No theorem relates the supplied
matrix system to the represented pro-Laurent gauges or proves gauge invariance
of the characteristic-polynomial system.  All proofs are symbolic and kernel
checked, with no external computation or oracle.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace Quantum

universe u

/-- An inverse system of finite square matrices compatible entrywise with
coefficient reduction. -/
structure CompatibleMonodromyMatrixSystem
    (Index : Type*) [Fintype Index] [DecidableEq Index] where
  Coefficient : ℕ → Type u
  coefficientRing : ∀ level, CommRing (Coefficient level)
  reduction : ∀ level, Coefficient (level + 1) →+* Coefficient level
  monodromy : ∀ level, Matrix Index Index (Coefficient level)
  compatible : ∀ level row column,
    reduction level (monodromy (level + 1) row column) =
      monodromy level row column

namespace CompatibleMonodromyMatrixSystem

/-- Entrywise compatibility identifies the mapped higher-level matrix with
the preceding matrix. -/
theorem map_monodromy
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleMonodromyMatrixSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    letI := system.coefficientRing (level + 1)
    (system.monodromy (level + 1)).map (system.reduction level) =
      system.monodromy level := by
  letI := system.coefficientRing level
  letI := system.coefficientRing (level + 1)
  ext row column
  exact system.compatible level row column

/-- The characteristic polynomials of compatible monodromy matrices form a
compatible coefficient-reduction system. -/
noncomputable def characteristicPolynomialSystem
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleMonodromyMatrixSystem Index) :
    CompatibleCharacteristicPolynomialSystem where
  Coefficient := system.Coefficient
  coefficientRing := system.coefficientRing
  reduction := system.reduction
  characteristicPolynomial level := by
    letI := system.coefficientRing level
    exact (system.monodromy level).charpoly
  compatible level := by
    letI := system.coefficientRing level
    letI := system.coefficientRing (level + 1)
    rw [← framedCharacteristicPolynomial_map,
      system.map_monodromy level]

/-- At every level, the derived compatible polynomial is literally the
characteristic polynomial of that level's monodromy matrix. -/
theorem characteristicPolynomialSystem_level
    {Index : Type*} [Fintype Index] [DecidableEq Index]
    (system : CompatibleMonodromyMatrixSystem Index) (level : ℕ) :
    letI := system.coefficientRing level
    system.characteristicPolynomialSystem.characteristicPolynomial level =
      (system.monodromy level).charpoly :=
  rfl

end CompatibleMonodromyMatrixSystem

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
