import Mathlib

/-!
# The free-orbit core of the Klein-four boundary

For the `V₄` boundary theorem, deletion removes every point fixed by a nonidentity group
element. The remaining action is free. Since the generator triple is exactly the three
nonidentity elements, every free orbit carries a complete graph `K₄`.

The lemmas below isolate the group-action argument. They are stated for an arbitrary
group with the full nonidentity generating set; specializing to a group of order four
gives the paper's `K₄` components.
-/

namespace DihedralSchreier

namespace KleinFour

variable {G Ω : Type*} [Group G] [MulAction G Ω]

/-- A point is deleted when some nonidentity group element fixes it. For `V₄`, the three
nonidentity elements are exactly the three pair products in the involution triple. -/
def Deleted (x : Ω) : Prop :=
  ∃ g : G, g ≠ 1 ∧ g • x = x

/-- The simple Schreier adjacency obtained by using every nonidentity group element. -/
def FullAdj (x y : Ω) : Prop :=
  x ≠ y ∧ ∃ g : G, g ≠ 1 ∧ y = g • x

/-- On a live point, the orbit map is injective; equivalently, its orbit is free. -/
theorem orbitMap_injective {x : Ω} (hx : ¬ Deleted (G := G) x) :
    Function.Injective (fun g : G => g • x) := by
  intro g h hgh
  have hfix : (h⁻¹ * g) • x = x := by
    calc
      (h⁻¹ * g) • x = h⁻¹ • (g • x) := mul_smul _ _ _
      _ = h⁻¹ • (h • x) := congrArg (fun y => h⁻¹ • y) hgh
      _ = x := inv_smul_smul h x
  have hone : h⁻¹ * g = 1 := by
    by_contra hne
    exact hx ⟨h⁻¹ * g, hne, hfix⟩
  exact (inv_mul_eq_one.mp hone).symm

/-- Any two distinct points in one orbit are adjacent for the full nonidentity generating
set. Thus a free orbit of a group of order four induces `K₄`. -/
theorem fullAdj_of_mem_orbit {x : Ω} {g h : G} (hneq : g • x ≠ h • x) :
    FullAdj (G := G) (g • x) (h • x) := by
  refine ⟨hneq, h * g⁻¹, ?_, ?_⟩
  · intro hone
    have : h = g := mul_inv_eq_one.mp hone
    exact hneq (by rw [this])
  · rw [mul_smul, inv_smul_smul]

/-- The full Schreier adjacency is symmetric. -/
theorem fullAdj_symm {x y : Ω} (hxy : FullAdj (G := G) x y) :
    FullAdj (G := G) y x := by
  rcases hxy with ⟨hneq, g, hg, rfl⟩
  refine ⟨Ne.symm hneq, g⁻¹, inv_ne_one.mpr hg, ?_⟩
  simp

end KleinFour

end DihedralSchreier
