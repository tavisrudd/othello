import Mathlib

/-!
# Residue-field pinching and its conductor

Let `A` be a commutative algebra over a field `k`, let `E/k` be a field
extension, and let `residue : A →ₐ[k] E` be a surjective residue map.  The
subalgebra obtained by restricting only the residue constants from `E` to `k`
is the inverse image of the bottom `k`-subalgebra of `E`.

The conductor of this pinched subalgebra in `A` is defined intrinsically as
the set of elements that send all of `A` back into the pinched algebra.  If
`E ≠ k`, its conductor is exactly the kernel of the residue map.  The proof
uses only surjectivity and the existence of one residue-field element outside
`k`; no presentation of `A` by power-series coordinates is used.
-/

namespace RelativeConicArcs.QuadraticPinching

variable {k E A : Type*} [Field k] [Field E] [CommRing A]
variable [Algebra k E] [Algebra k A]

/-- The subalgebra whose residue lies in the ground field. -/
def residuePinching (residue : A →ₐ[k] E) : Subalgebra k A :=
  (⊥ : Subalgebra k E).comap residue

@[simp]
theorem mem_residuePinching_iff (residue : A →ₐ[k] E) (x : A) :
    x ∈ residuePinching residue ↔ residue x ∈ (⊥ : Subalgebra k E) :=
  Iff.rfl

/-- The conductor of a subalgebra `R ⊆ A`, viewed as an ideal of `A`. -/
def subalgebraConductor (R : Subalgebra k A) : Ideal A where
  carrier := {x | ∀ y : A, x * y ∈ R}
  zero_mem' y := by simp
  add_mem' hx hy z := by
    rw [add_mul]
    exact R.add_mem (hx z) (hy z)
  smul_mem' c x hx y := by
    change (c * x) * y ∈ R
    rw [mul_assoc, mul_comm c x, ← mul_assoc]
    exact hx (c * y)

@[simp]
theorem mem_subalgebraConductor_iff (R : Subalgebra k A) (x : A) :
    x ∈ subalgebraConductor R ↔ ∀ y : A, x * y ∈ R :=
  Iff.rfl

/-- Every element of the conductor belongs to the pinched subalgebra. -/
theorem subalgebraConductor_le (R : Subalgebra k A) :
    (subalgebraConductor R : Set A) ⊆ R := by
  intro x hx
  simpa using hx 1

/-- The residue kernel is contained in the conductor of the residue-field
pinching. -/
theorem ker_le_conductor (residue : A →ₐ[k] E) :
    RingHom.ker residue.toRingHom ≤ subalgebraConductor (residuePinching residue) := by
  intro x hx y
  change residue (x * y) ∈ (⊥ : Subalgebra k E)
  rw [map_mul, hx, zero_mul]
  exact (⊥ : Subalgebra k E).zero_mem

/-- Multiplying every element of a proper field extension into the ground
field forces the multiplier to vanish. -/
theorem eq_zero_of_mul_mem_ground
    {c : E} (hproper : ∃ u : E, u ∉ (⊥ : Subalgebra k E))
    (hcmul : ∀ u : E, c * u ∈ (⊥ : Subalgebra k E)) : c = 0 := by
  by_contra hc
  obtain ⟨u, hu⟩ := hproper
  have hc_ground : c ∈ (⊥ : Subalgebra k E) := by
    simpa using hcmul 1
  have hc_inv_ground : c⁻¹ ∈ (⊥ : Subalgebra k E) :=
    (⊥ : Subalgebra k E).inv_mem hc_ground
  have hcu_ground : c * u ∈ (⊥ : Subalgebra k E) := hcmul u
  have : u ∈ (⊥ : Subalgebra k E) := by
    have hprod := (⊥ : Subalgebra k E).mul_mem hc_inv_ground hcu_ground
    simpa [hc] using hprod
  exact hu this

/-- For a surjective residue map with a proper residue-field extension, the
conductor of the residue-field pinching is exactly the residue kernel. -/
theorem conductor_eq_ker (residue : A →ₐ[k] E)
    (hsurj : Function.Surjective residue)
    (hproper : ∃ u : E, u ∉ (⊥ : Subalgebra k E)) :
    subalgebraConductor (residuePinching residue) = RingHom.ker residue.toRingHom := by
  apply le_antisymm
  · intro x hx
    rw [RingHom.mem_ker]
    apply eq_zero_of_mul_mem_ground hproper
    intro u
    obtain ⟨y, rfl⟩ := hsurj u
    exact hx y
  · exact ker_le_conductor residue

/-- The quotient by the conductor has the same residue as `E`: equality
modulo the conductor is equivalent to equality of residues. -/
theorem sub_eq_mem_conductor_iff (residue : A →ₐ[k] E)
    (hsurj : Function.Surjective residue)
    (hproper : ∃ u : E, u ∉ (⊥ : Subalgebra k E)) (x y : A) :
    x - y ∈ subalgebraConductor (residuePinching residue) ↔ residue x = residue y := by
  rw [conductor_eq_ker residue hsurj hproper, RingHom.mem_ker, map_sub, sub_eq_zero]

end RelativeConicArcs.QuadraticPinching
