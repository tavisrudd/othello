import Mathlib
import NodeKayles.Grundy

/-!
# The Burnside-group reformulation Φ_T (Proposition 11.1)

This file formalizes Section 11 of
`notes/2026-07-12-dihedral-schreier-node-kayles-submission.md`.

The paper defines, for a finite group `G` and a finite involution set `T`,
`Φ_T(Ω) = 𝒢(R_T(Ω))`, the Grundy value of the fixed-point-deleted Schreier graph of the
`G`-set `Ω`. Proposition 11.1 asserts:

* `Φ_T` is additive under disjoint union into `(ℕ₀, ⊕)` (⊕ = binary XOR of Grundy values);
* it extends uniquely to a group homomorphism `A(G) → (ℕ₀, ⊕)` — using that the additive
  group of the Burnside ring `A(G)` is *free* on the transitive `G`-sets;
* it vanishes on `2·A(G)`, hence factors through the mod-two Burnside group
  `A(G) ⊗_ℤ F₂`;
* Corollary 11.2 (bulk cancellation): `f` generic free orbits contribute `(f mod 2)·Φ_T(G/1)`.

## Formalization strategy

Two layers, matching the paper's own remark that 11.1 "is a convenient reformulation of
Theorem 3.1, not an additional source of computational information":

1. **Target group.** `(ℕ₀, ⊕)` is formalized as `GrundyXor`, a type synonym of `ℕ`
   carrying the `AddCommGroup` structure whose addition is `Nat.xor`. Every element is its
   own inverse, so it is a `2`-torsion abelian group (an `F₂`-vector space).

2. **Burnside additive group.** `A(G)`'s additive group is free on the transitive `G`-sets;
   we model it as `FreeAbelianGroup ι`, where `ι` indexes the transitive types `[K]`, and
   the template table `t : ι → GrundyXor` records the paper's `t_K = 𝒢(R(G,K,T))`. Then
   `Φ_T = FreeAbelianGroup.lift t`, whose existence/uniqueness is exactly the
   Grothendieck-group universal property invoked in the paper.

The concrete input "Grundy values XOR over graph components" is the already-certified
`NodeKayles.grundy_sum`; `phi_add_realized` below records that the abstract group
operation `⊕` of `GrundyXor` is literally realized by disjoint-union Grundy values, tying
the abstract homomorphism to the concrete Sprague–Grundy fact.
-/

namespace DihedralSchreier

namespace Burnside

/-! ### The target group `(ℕ₀, ⊕)` -/

/-- The additive group `(ℕ₀, ⊕)` of the paper: natural numbers under XOR. -/
def GrundyXor : Type := ℕ

namespace GrundyXor

/-- Bundle a natural number (e.g. a Grundy value) as an element of `(ℕ₀, ⊕)`. -/
def ofNat (n : ℕ) : GrundyXor := n

instance : Zero GrundyXor := ⟨(0 : ℕ)⟩
instance : Add GrundyXor := ⟨Nat.xor⟩
instance : Neg GrundyXor := ⟨id⟩

instance : AddCommGroup GrundyXor where
  add_assoc := Nat.xor_assoc
  zero_add := Nat.zero_xor
  add_zero := Nat.xor_zero
  nsmul := nsmulRec
  zsmul := zsmulRec
  neg_add_cancel := Nat.xor_self
  add_comm := Nat.xor_comm

@[simp] theorem add_def (a b : GrundyXor) : a + b = Nat.xor a b := rfl

/-- `(ℕ₀, ⊕)` is `2`-torsion: every element is its own inverse. -/
@[simp] theorem add_self (g : GrundyXor) : g + g = 0 := Nat.xor_self g

theorem two_nsmul_eq_zero (g : GrundyXor) : (2 : ℕ) • g = 0 := by
  rw [two_nsmul, add_self]

/-- A count of identical contributions collapses to a single parity bit — the algebraic
heart of both `2·A(G) ⊆ ker Φ_T` and Corollary 11.2's bulk cancellation. -/
theorem nsmul_eq_ite (f : ℕ) (g : GrundyXor) :
    f • g = if Even f then 0 else g := by
  rcases Nat.even_or_odd f with hf | hf
  · obtain ⟨m, rfl⟩ := hf
    rw [if_pos ⟨m, rfl⟩, ← two_mul, mul_nsmul, two_nsmul_eq_zero, nsmul_zero]
  · obtain ⟨m, rfl⟩ := hf
    rw [if_neg (by simp [parity_simps]),
      add_nsmul, mul_nsmul, two_nsmul_eq_zero, nsmul_zero, one_nsmul, zero_add]

end GrundyXor

/-! ### The homomorphism `Φ_T : A(G) → (ℕ₀, ⊕)` -/

variable {ι : Type*}

/-- **Φ_T (Proposition 11.1).** Given the finite template table `t K = 𝒢(R(G,K,T))`
indexed by transitive types `ι`, the map `Φ_T` is the unique group homomorphism from the
additive Burnside group `A(G) = FreeAbelianGroup ι` to `(ℕ₀, ⊕)` sending each transitive
generator `[K]` to its template Grundy value. Its existence and uniqueness are the
Grothendieck-group universal property. -/
noncomputable def phi (t : ι → GrundyXor) : FreeAbelianGroup ι →+ GrundyXor :=
  FreeAbelianGroup.lift t

/-- `Φ_T` sends the transitive generator `[K]` to its template value `t K`. -/
@[simp] theorem phi_of (t : ι → GrundyXor) (K : ι) :
    phi t (FreeAbelianGroup.of K) = t K :=
  FreeAbelianGroup.lift_apply_of _ _

/-- **Additivity under disjoint union (Prop 11.1, eq. 11.1).** Disjoint union of `G`-sets
is addition in `A(G)`; `Φ_T` is a homomorphism, so `Φ_T(Ω ⊔ Ω') = Φ_T(Ω) ⊕ Φ_T(Ω')`. -/
theorem phi_add (t : ι → GrundyXor) (Ω Ω' : FreeAbelianGroup ι) :
    phi t (Ω + Ω') = phi t Ω + phi t Ω' :=
  map_add _ _ _

/-- **Uniqueness of the extension (Prop 11.1).** Any homomorphism agreeing with the
template table on the transitive generators equals `Φ_T`. This is the "extends uniquely"
clause: the Grothendieck-group universal property. -/
theorem phi_unique (t : ι → GrundyXor) (ψ : FreeAbelianGroup ι →+ GrundyXor)
    (hψ : ∀ K, ψ (FreeAbelianGroup.of K) = t K) : ψ = phi t :=
  FreeAbelianGroup.lift_ext _ _ (fun K => by rw [hψ, phi_of])

/-- **Vanishing on `2·A(G)` (Prop 11.1, toward eq. 11.2).** Every doubled class lies in the
kernel, because the target is `2`-torsion. -/
theorem phi_two_nsmul (t : ι → GrundyXor) (Ω : FreeAbelianGroup ι) :
    phi t ((2 : ℕ) • Ω) = 0 := by
  rw [map_nsmul, GrundyXor.two_nsmul_eq_zero]

/-- The doubling endomorphism `Ω ↦ Ω + Ω` of `A(G)`. -/
def doubleHom (ι : Type*) : FreeAbelianGroup ι →+ FreeAbelianGroup ι where
  toFun Ω := Ω + Ω
  map_zero' := by simp
  map_add' a b := by abel

/-- The image of the doubling endomorphism of `A(G)`; this subgroup is `2·A(G)`. -/
def twoA (ι : Type*) : AddSubgroup (FreeAbelianGroup ι) :=
  (doubleHom ι).range

/-- `Φ_T` annihilates `2·A(G)`. -/
theorem phi_vanishes_on_twoA (t : ι → GrundyXor) :
    ∀ Ω ∈ twoA ι, phi t Ω = 0 := by
  rintro Ω ⟨x, rfl⟩
  show phi t (x + x) = 0
  rw [map_add, GrundyXor.add_self]

/-- **Factorization through the mod-two Burnside group (Prop 11.1, eq. 11.2).**
`Φ_T` descends to a homomorphism out of `A(G) ⧸ 2·A(G)`. This quotient is the mod-two
Burnside group `A(G) ⊗_ℤ F₂` (for the free `A(G)`, `A(G)/2A(G) ≅ A(G) ⊗_ℤ F₂`
canonically). -/
noncomputable def phiBar (t : ι → GrundyXor) :
    (FreeAbelianGroup ι ⧸ twoA ι) →+ GrundyXor :=
  QuotientAddGroup.lift (twoA ι) (phi t) (phi_vanishes_on_twoA t)

/-- The descended map composed with the mod-two reduction recovers `Φ_T`: it genuinely
*factors through* the mod-two Burnside group. -/
@[simp] theorem phiBar_mk (t : ι → GrundyXor) (Ω : FreeAbelianGroup ι) :
    phiBar t (QuotientAddGroup.mk Ω) = phi t Ω :=
  rfl

/-! ### Corollary 11.2: bulk cancellation -/

/-- **Corollary 11.2 (bulk cancellation).** If a `G`-set has `f` free orbits (of the
transitive type `free = [1]`) plus an exceptional part `Ω_exc`, then
`Φ_T(Ω) = (f mod 2)·Φ_T(G/1) ⊕ Φ_T(Ω_exc)`: arbitrarily many generic free orbits
contribute either nothing or a single parity bit. -/
theorem bulk_cancellation (t : ι → GrundyXor) (free : ι) (f : ℕ)
    (Ωexc : FreeAbelianGroup ι) :
    phi t (f • FreeAbelianGroup.of free + Ωexc)
      = (if Even f then 0 else t free) + phi t Ωexc := by
  rw [map_add, map_nsmul, phi_of, GrundyXor.nsmul_eq_ite]

/-! ### Grounding in the concrete Sprague–Grundy fact

The abstract additivity of `Φ_T` is *realized* by the certified component-XOR sum
`NodeKayles.grundy_sum`: a Node-Kayles position splitting into two live sets with no edges
between them has Grundy value the XOR of the parts. Casting the Grundy values into
`(ℕ₀, ⊕)`, disjoint-union Grundy is exactly the group operation `⊕`. -/
theorem phi_add_realized {k : ℕ} (G : NodeKayles.Graph k) (S₁ S₂ : Finset (Fin k))
    (hdisj : Disjoint S₁ S₂) (hnoedge : ∀ a ∈ S₁, ∀ b ∈ S₂, G.adj a b = false) :
    GrundyXor.ofNat (NodeKayles.grundy G (S₁ ∪ S₂))
      = GrundyXor.ofNat (NodeKayles.grundy G S₁)
          + GrundyXor.ofNat (NodeKayles.grundy G S₂) := by
  rw [GrundyXor.add_def, NodeKayles.grundy_sum G S₁ S₂ hdisj hnoedge]
  rfl

end Burnside

end DihedralSchreier
