import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.PrimaryPolynomialProjectors
import Mathlib.LinearAlgebra.FiniteDimensional.Basic

/-!
# Rank-one even primary factors have no odd vectors

Let a nonzero central idempotent cut out a primary summand of an associative
algebra with nondegenerate Frobenius trace. If its even subspace has dimension
one and contains the idempotent, supercommutativity forces all odd products to
vanish. The restricted trace pairing then forces the full odd subspace to be
zero. The dimension-one hypothesis is converted to scalar spanning inside
the proof; scalar-product vanishing and restricted nondegeneracy are not inputs.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- A primary image with one-dimensional even part has zero odd subspace.
All vectors and products belong to the original algebra; the identity of the
primary image is the supplied nonzero central idempotent. -/
theorem primary_odd_eq_bot_of_even_finrank_one
    {K A : Type*} [Field K] [CharZero K] [Ring A] [Algebra K A]
    [FiniteDimensional K A]
    (e : A) (idempotent : e*e=e) (central : ∀ x : A, Commute e x) (nonzero : e ≠ 0)
    (even odd : Submodule K A) (unitEven : e ∈ even) (rankOne : Module.finrank K even = 1)
    (oddImage : ∀ x ∈ odd, x ∈ LinearMap.range (Algebra.lmul K A e))
    (spanning : ∀ y ∈ LinearMap.range (Algebra.lmul K A e),
      ∃ u ∈ even, ∃ v ∈ odd, y=u+v)
    (oddProductEven : ∀ x ∈ odd, ∀ y ∈ odd, x*y ∈ even)
    (anticommute : ∀ x ∈ odd, ∀ y ∈ odd, x*y=-(y*x))
    (trace : A →ₗ[K] K) (traceOdd : ∀ x ∈ odd, trace x=0)
    (nondegenerate : ∀ x : A, (∀ y : A, trace (x*y)=0) → x=0) :
    odd=⊥ := by
  have scalar : ∀ x ∈ even, ∃ c : K, c • e=x := by
    intro x hx
    have he : (⟨e,unitEven⟩ : even) ≠ 0 := by
      intro h
      exact nonzero (congrArg Subtype.val h)
    obtain ⟨c,hc⟩ := (finrank_eq_one_iff_of_nonzero' (K := K)
      (⟨e,unitEven⟩ : even) he).mp rankOne ⟨x,hx⟩
    exact ⟨c,congrArg Subtype.val hc⟩
  have products : ∀ x ∈ odd, ∀ y ∈ odd, x*y=0 := by
    intro x hx y hy
    have nilpotent : (x*y)*(x*y)=0 := by
      calc
        (x*y)*(x*y) = x*(y*x)*y := by simp only [mul_assoc]
        _ = x*(-(x*y))*y := by rw [anticommute y hy x hx]
        _ = -(x*x)*(y*y) := by noncomm_ring
        _ = 0 := by rw [odd_square_eq_zero anticommute hx]; simp
    obtain ⟨c,hc⟩ := scalar (x*y) (oddProductEven x hx y hy)
    have square : (c*c) • e=0 := by
      rw [← hc] at nilpotent
      simpa only [smul_mul_assoc, mul_smul_comm, smul_smul, idempotent] using nilpotent
    have cZero : c=0 := mul_self_eq_zero.mp ((smul_eq_zero.mp square).resolve_right nonzero)
    simpa [cZero] using hc.symm
  apply le_antisymm _ bot_le
  intro x hx
  change x=0
  apply centralIdempotent_tracePairing_nondegenerate e idempotent central trace
    nondegenerate (oddImage x hx)
  intro y hy
  obtain ⟨u,hu,v,hv,rfl⟩ := spanning y hy
  obtain ⟨c,rfl⟩ := scalar u hu
  rw [mul_add, map_add, products x hx v hv, map_zero, add_zero]
  rw [mul_smul_comm, (centralIdempotent_fixes_range e idempotent central (oddImage x hx)).2,
    map_smul, traceOdd x hx, smul_zero]

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
