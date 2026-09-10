import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.PrimaryPolynomialProjectors

/-!
# Full primary summands and parity-preserving projections

Complementary orthogonal idempotents split the entire underlying vector space
into their multiplication images. Polynomial projectors preserve every submodule
stable under the Euler element; in a graded algebra this applies separately to
the even and odd subspaces. Orthogonality of distinct central idempotent images
holds for actual algebra products, and therefore for every trace pairing.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- Complementary orthogonal idempotents split the full algebra as a vector
space into the two actual multiplication images. The inverse adds the vectors. -/
noncomputable def complementaryIdempotents_linearEquiv
    {K A : Type*} [Field K] [Ring A] [Algebra K A]
    (p q : A) (sum : p+q=1) (pp : p*p=p) (qq : q*q=q)
    (pq : p*q=0) (qp : q*p=0) :
    A ≃ₗ[K] LinearMap.range (Algebra.lmul K A p) × LinearMap.range (Algebra.lmul K A q) where
  toFun x := (⟨p*x,⟨x,rfl⟩⟩,⟨q*x,⟨x,rfl⟩⟩)
  invFun x := (x.1 : A)+(x.2 : A)
  left_inv x := by change p*x+q*x=x; rw [← add_mul, sum, one_mul]
  right_inv x := by
    rcases x with ⟨⟨x,⟨u,hu⟩⟩,⟨y,⟨v,hv⟩⟩⟩
    change p*u=x at hu
    change q*v=y at hv
    apply Prod.ext <;> apply Subtype.ext
    · change p*(x+y)=x
      rw [← hu, ← hv, mul_add, ← mul_assoc, pp, ← mul_assoc, pq, zero_mul, add_zero]
    · change q*(x+y)=y
      rw [← hu, ← hv, mul_add, ← mul_assoc, qp, zero_mul, ← mul_assoc, qq, zero_add]
  map_add' x y := by
    apply Prod.ext <;> apply Subtype.ext
    · change p*(x+y)=p*x+p*y
      exact mul_add p x y
    · change q*(x+y)=q*x+q*y
      exact mul_add q x y
  map_smul' c x := by
    apply Prod.ext <;> apply Subtype.ext
    · change p*(c • x)=c • (p*x)
      exact mul_smul_comm c p x
    · change q*(c • x)=c • (q*x)
      exact mul_smul_comm c q x

/-- Polynomial multiplication in the Euler element preserves every submodule
stable under multiplication by that element. This derives parity preservation
for polynomial primary projectors from the parity of Euler multiplication. -/
theorem polynomial_projector_preserves_submodule
    {K A : Type*} [Field K] [Ring A] [Algebra K A]
    (euler : A) (sub : Submodule K A)
    (stable : ∀ x ∈ sub, euler*x ∈ sub)
    (p : Polynomial K) {x : A} (hx : x ∈ sub) :
    Polynomial.aeval euler p*x ∈ sub := by
  have power : ∀ n : ℕ, euler^n*x ∈ sub := by
    intro n
    induction n with
    | zero => simpa using hx
    | succ n ih => simpa [pow_succ', mul_assoc] using stable (euler^n*x) ih
  induction p using Polynomial.induction_on' with
  | add p q hp hq => simpa [map_add, add_mul] using sub.add_mem hp hq
  | monomial n c =>
    simpa [Polynomial.aeval_monomial, Algebra.smul_def, mul_assoc] using sub.smul_mem c (power n)

/-- Orthogonal central idempotents have mutually annihilating full images,
which in particular makes those images orthogonal for any Frobenius trace. -/
theorem centralIdempotent_images_mul_eq_zero
    {K A : Type*} [Field K] [Ring A] [Algebra K A]
    (p q : A) (central : ∀ x : A, Commute q x) (orthogonal : p*q=0)
    {x y : A} (hx : x ∈ LinearMap.range (Algebra.lmul K A p))
    (hy : y ∈ LinearMap.range (Algebra.lmul K A q)) : x*y=0 := by
  obtain ⟨u,rfl⟩ := hx
  obtain ⟨v,rfl⟩ := hy
  change (p*u)*(q*v)=0
  rw [← mul_assoc, mul_assoc p u q, ← (central u).eq, ← mul_assoc p q u,
    orthogonal, zero_mul, zero_mul]

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
