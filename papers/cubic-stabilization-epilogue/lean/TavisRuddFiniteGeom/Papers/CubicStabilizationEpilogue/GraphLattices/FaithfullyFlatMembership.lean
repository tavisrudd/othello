import Mathlib.RingTheory.Flat.FaithfullyFlat.Algebra
import Mathlib.LinearAlgebra.Quotient.Defs

/-!
# Faithfully flat reflection of lattice membership

This module isolates the exact quotient argument used to descend membership
in an integral product lattice from a faithfully flat splitting ring.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

/-- If the class of an element in a quotient module vanishes after the
canonical map to a faithfully flat scalar extension, then the element already
belongs to the original submodule.  No finite-generation hypothesis is
needed. -/
theorem mem_submodule_of_faithfullyFlat_tensor_quotient_zero
    {R S M : Type*} [CommRing R] [CommRing S] [Algebra R S]
    [AddCommGroup M] [Module R M] [Module.FaithfullyFlat R S]
    (submodule : Submodule R M) (element : M)
    (extendedQuotientZero :
      TensorProduct.mk R S (M ⧸ submodule) 1
          (Submodule.Quotient.mk element) = 0) :
    element ∈ submodule := by
  apply (Submodule.Quotient.mk_eq_zero submodule).mp
  apply Module.FaithfullyFlat.tensorProduct_mk_injective
    (A := R) (B := S) (M ⧸ submodule)
  simpa using extendedQuotientZero

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
