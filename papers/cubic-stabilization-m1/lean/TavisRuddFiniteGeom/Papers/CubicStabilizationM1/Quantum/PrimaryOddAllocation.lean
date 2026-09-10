import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.PrimaryScalarEvenVanishing

/-!
# Allocation of the full odd part to a primary factor

In a finite-dimensional graded Frobenius algebra, a central-idempotent summand
with even dimension one has zero odd intersection. If a finite family of
parity-preserving central idempotents sums to one and every summand except a
distinguished one has even dimension one, then the entire odd subspace lies
in the distinguished summand. The proof derives the allocation from products,
parity, dimensions and the whole trace pairing; it does not assume vanishing
of the other odd intersections.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- Intersecting an even-rank-one central-idempotent image with the full odd
subspace gives zero. The primary parity decomposition is obtained by projecting
the original even/odd decomposition, rather than supplied separately. -/
theorem odd_inter_primary_eq_bot_of_even_rank_one
    {K A : Type*} [Field K] [CharZero K] [Ring A] [Algebra K A]
    [FiniteDimensional K A]
    (even odd : Submodule K A) (e : A)
    (idempotent : e*e=e) (central : ∀ x : A, Commute e x) (nonzero : e ≠ 0)
    (unitEven : e ∈ even)
    (evenStable : ∀ x ∈ even, e*x ∈ even)
    (oddStable : ∀ x ∈ odd, e*x ∈ odd)
    (rankOne : Module.finrank K ↥(even ⊓ LinearMap.range (Algebra.lmul K A e)) = 1)
    (spanning : ∀ y : A, ∃ u ∈ even, ∃ v ∈ odd, y=u+v)
    (oddProductEven : ∀ x ∈ odd, ∀ y ∈ odd, x*y ∈ even)
    (anticommute : ∀ x ∈ odd, ∀ y ∈ odd, x*y=-(y*x))
    (trace : A →ₗ[K] K) (traceOdd : ∀ x ∈ odd, trace x=0)
    (nondegenerate : ∀ x : A, (∀ y : A, trace (x*y)=0) → x=0) :
    odd ⊓ LinearMap.range (Algebra.lmul K A e) = ⊥ := by
  apply primary_odd_eq_bot_of_even_finrank_one (trace := trace) e idempotent central nonzero
    (even ⊓ LinearMap.range (Algebra.lmul K A e))
    (odd ⊓ LinearMap.range (Algebra.lmul K A e))
  · exact ⟨unitEven, ⟨e,idempotent⟩⟩
  · exact rankOne
  · exact fun _ h => h.2
  · intro y hy
    obtain ⟨u,hu,v,hv,eq⟩ := spanning y
    refine ⟨e*u,⟨evenStable u hu,⟨u,rfl⟩⟩,e*v,⟨oddStable v hv,⟨v,rfl⟩⟩,?_⟩
    rw [← mul_add, ← eq, (centralIdempotent_fixes_range e idempotent central hy).1]
  · intro x hx y hy
    refine ⟨oddProductEven x hx.1 y hy.1,⟨x*y,?_⟩⟩
    change e*(x*y)=x*y
    rw [← mul_assoc, (centralIdempotent_fixes_range e idempotent central hx.2).1]
  · exact fun x hx y hy => anticommute x hx.1 y hy.1
  · exact fun x hx => traceOdd x hx.1
  · exact nondegenerate

/-- If all other even primary summands have dimension one, the full odd
subspace equals its intersection with the distinguished primary image. This
covers both a `2+1+1` and a `3+1` even-rank pattern, without fixing the number
of summands or assuming any odd allocation. -/
theorem odd_eq_distinguished_primary_intersection
    {K A ι : Type*} [Field K] [CharZero K] [Ring A] [Algebra K A]
    [FiniteDimensional K A] [Fintype ι]
    (even odd : Submodule K A) (e : ι → A) (selected : ι)
    (sum : ∑ i, e i = 1)
    (idempotent : ∀ i, e i*e i=e i)
    (central : ∀ i x, Commute (e i) x) (nonzero : ∀ i, e i ≠ 0)
    (unitEven : ∀ i, e i ∈ even)
    (evenStable : ∀ i x, x ∈ even → e i*x ∈ even)
    (oddStable : ∀ i x, x ∈ odd → e i*x ∈ odd)
    (rankOne : ∀ i, i ≠ selected →
      Module.finrank K ↥(even ⊓ LinearMap.range (Algebra.lmul K A (e i))) = 1)
    (spanning : ∀ y : A, ∃ u ∈ even, ∃ v ∈ odd, y=u+v)
    (oddProductEven : ∀ x ∈ odd, ∀ y ∈ odd, x*y ∈ even)
    (anticommute : ∀ x ∈ odd, ∀ y ∈ odd, x*y=-(y*x))
    (trace : A →ₗ[K] K) (traceOdd : ∀ x ∈ odd, trace x=0)
    (nondegenerate : ∀ x : A, (∀ y : A, trace (x*y)=0) → x=0) :
    odd = odd ⊓ LinearMap.range (Algebra.lmul K A (e selected)) := by
  classical
  have outside : ∀ i, i ≠ selected →
      odd ⊓ LinearMap.range (Algebra.lmul K A (e i)) = ⊥ := by
    intro i hi
    exact odd_inter_primary_eq_bot_of_even_rank_one even odd (e i) (idempotent i)
      (central i) (nonzero i) (unitEven i) (evenStable i) (oddStable i)
      (rankOne i hi) spanning oddProductEven anticommute trace traceOdd nondegenerate
  apply le_antisymm _ inf_le_left
  intro x hx
  have vanishing : ∀ i, i ≠ selected → e i*x=0 := by
    intro i hi
    have member : e i*x ∈ odd ⊓ LinearMap.range (Algebra.lmul K A (e i)) :=
      ⟨oddStable i x hx,⟨x,rfl⟩⟩
    simpa only [outside i hi, Submodule.mem_bot] using member
  have equality : x=e selected*x := by
    calc
      x = (∑ i, e i)*x := by rw [sum, one_mul]
      _ = ∑ i, e i*x := Finset.sum_mul _ _ _
      _ = e selected*x := by
        apply Finset.sum_eq_single selected
        · intro i _ hi
          exact vanishing i hi
        · simp
  exact ⟨hx,⟨x,equality.symm⟩⟩

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
