import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.SuperRankOneVanishing

/-!
# Polynomial primary projectors and Frobenius restriction

A coprime factorization of a polynomial annihilating an algebra element gives
complementary orthogonal idempotents by a Bezout identity. These idempotents
are actual elements of the algebra, obtained by polynomial evaluation. For a
central idempotent, the range of its multiplication map inherits the
nondegeneracy of a Frobenius trace from the whole algebra. These statements
apply to full primary summands, including their odd vectors; no passage to
invariant vectors is involved. Geometric quantum algebras are not constructed.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- A coprime annihilating factorization constructs complementary orthogonal
idempotents, with the first killed by the first polynomial and the second by
the second polynomial. No projectors are supplied as hypotheses. -/
theorem exists_primaryPolynomial_idempotents {K A : Type*} [Field K] [Ring A] [Algebra K A]
    (euler : A) (f g : Polynomial K) (coprime : IsCoprime f g)
    (annihilates : Polynomial.aeval euler (f*g) = 0) :
    ∃ p q : A, p+q=1 ∧ p*q=0 ∧ q*p=0 ∧ p*p=p ∧ q*q=q ∧
      Polynomial.aeval euler f*p=0 ∧ Polynomial.aeval euler g*q=0 ∧
      (∃ r : Polynomial K, p=Polynomial.aeval euler r) ∧
      (∃ r : Polynomial K, q=Polynomial.aeval euler r) := by
  obtain ⟨u,v,bezout⟩ := coprime
  let p := Polynomial.aeval euler (v*g)
  let q := Polynomial.aeval euler (u*f)
  have sum : p+q=1 := by
    change Polynomial.aeval euler (v*g) + Polynomial.aeval euler (u*f) = 1
    rw [← map_add, add_comm, bezout, map_one]
  have pq : p*q=0 := by
    change Polynomial.aeval euler (v*g) * Polynomial.aeval euler (u*f) = 0
    rw [← map_mul]
    have identity : (v*g)*(u*f) = (u*v)*(f*g) := by ring
    rw [identity, map_mul, annihilates, mul_zero]
  have qp : q*p=0 := by
    change Polynomial.aeval euler (u*f) * Polynomial.aeval euler (v*g) = 0
    rw [← map_mul, mul_comm, map_mul]
    exact pq
  have pp : p*p=p := by
    have h := congrArg (fun x : A => p*x) sum
    rw [mul_add, pq, add_zero, mul_one] at h
    exact h
  have qq : q*q=q := by
    have h := congrArg (fun x : A => q*x) sum
    rw [mul_add, qp, zero_add, mul_one] at h
    exact h
  refine ⟨p,q,sum,pq,qp,pp,qq,?_,?_,⟨v*g,rfl⟩,⟨u*f,rfl⟩⟩
  · change Polynomial.aeval euler f * Polynomial.aeval euler (v*g) = 0
    rw [← map_mul]
    have identity : f*(v*g) = v*(f*g) := by ring
    rw [identity, map_mul, annihilates, mul_zero]
  · change Polynomial.aeval euler g * Polynomial.aeval euler (u*f) = 0
    rw [← map_mul]
    have identity : g*(u*f) = u*(f*g) := by ring
    rw [identity, map_mul, annihilates, mul_zero]

/-- Polynomial evaluation at a central element remains central, so the
polynomial primary idempotents define full two-sided summands. -/
theorem polynomial_aeval_central {K A : Type*} [Field K] [Ring A] [Algebra K A]
    (euler : A) (central : ∀ x : A, Commute euler x) (p : Polynomial K) (x : A) :
    Commute (Polynomial.aeval euler p) x := by
  induction p using Polynomial.induction_on' with
  | add p q hp hq => simpa only [map_add] using hp.add_left hq
  | monomial n a =>
    simpa using (Algebra.commute_algebraMap_left a x).mul_left ((central x).pow_left n)

/-- Left multiplication by a central idempotent fixes every vector of its
image on both sides. -/
theorem centralIdempotent_fixes_range {K A : Type*} [Field K] [Ring A] [Algebra K A]
    (e : A) (idempotent : e*e=e) (central : ∀ x : A, Commute e x)
    {x : A} (member : x ∈ LinearMap.range (Algebra.lmul K A e)) :
    e*x=x ∧ x*e=x := by
  obtain ⟨y,rfl⟩ := member
  change e*(e*y)=e*y ∧ (e*y)*e=e*y
  constructor
  · rw [← mul_assoc, idempotent]
  · rw [← (central (e*y)).eq, ← mul_assoc, idempotent]

/-- The Frobenius trace pairing restricted to a central idempotent's image is
nondegenerate if the original trace pairing is nondegenerate. The restricted
nondegeneracy is derived using projection of arbitrary test vectors. -/
theorem centralIdempotent_tracePairing_nondegenerate
    {K A : Type*} [Field K] [Ring A] [Algebra K A]
    (e : A) (idempotent : e*e=e) (central : ∀ x : A, Commute e x)
    (trace : A →ₗ[K] K)
    (nondegenerate : ∀ x : A, (∀ y : A, trace (x*y)=0) → x=0)
    {x : A} (member : x ∈ LinearMap.range (Algebra.lmul K A e))
    (orthogonal : ∀ y ∈ LinearMap.range (Algebra.lmul K A e), trace (x*y)=0) :
    x=0 := by
  apply nondegenerate x
  intro y
  have h := orthogonal (e*y) ⟨y,rfl⟩
  rw [← mul_assoc, (centralIdempotent_fixes_range e idempotent central member).2] at h
  exact h

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
