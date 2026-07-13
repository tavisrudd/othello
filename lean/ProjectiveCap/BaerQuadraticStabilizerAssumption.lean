import ProjectiveCap.BaerQuadraticDescent
import Mathlib.LinearAlgebra.QuadraticForm.Radical

/-!
# Imported quadratic-stabilizer theorem

This module deliberately quarantines the one literature theorem not yet proved locally.  It is an
axiom, so every downstream theorem using it must remain outside the strict no-axiom trust tier.

The statement is the standard identification of the projective stabilizer of a nondegenerate
quadric with its projective semisimilarity group, specialized to a relative-Frobenius semilinear
representative.
-/

namespace ProjectiveCap
namespace Projective
namespace BaerSemilinear

variable (F K : Type*) [Field F] [Fintype F] [Field K] [Fintype K] [Algebra F K]

/-- **Imported assumption.** An injective relative-Frobenius semilinear map preserving the null
cone of a nondegenerate quadratic form is a semisimilitude of that form. -/
axiom exists_semisimilitudeMultiplier_of_preserves_zeroLocus
    {V : Type*} [AddCommGroup V] [Module K V] [FiniteDimensional K V]
    (hchar : ringChar K ≠ 2) (hdim : 3 ≤ Module.finrank K V)
    (Q : QuadraticForm K V) (hQ : Q.Nondegenerate)
    (S : V →ₛₗ[FiniteHermitian.conjRingHom F K] V) (hSinj : Function.Injective S)
    (hzero : ∀ v, Q (S v) = 0 ↔ Q v = 0) :
    ∃ μ : K, μ ≠ 0 ∧ ∀ v, Q (S v) = μ * FiniteHermitian.conj F K (Q v)

end BaerSemilinear
end Projective
end ProjectiveCap
