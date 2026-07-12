import DihedralSchreier.FixedDeleted
import DihedralSchreier.KleinFour

/-!
# Bridge from involution triples to the Klein-four free-orbit core

The abstract `KleinFour` file deletes points fixed by any nonidentity group element.
`FixedDeleted` deletes pair-product fixed points of a labelled involution triple. For a
Klein-four triple these definitions agree because its three unordered pair products are
exactly its three nonidentity elements. The theorem below packages that bridge for any
realization of this elementary group fact.
-/

namespace DihedralSchreier

namespace KleinFourBridge

variable {G : Type*} [Group G] {k : ℕ} [MulAction G (Fin k)]

/-- A labelled involution triple realized by three group elements whose unordered pair
products enumerate all nonidentity elements. -/
structure Realization (T : InvolutionTriple k) where
  label : Fin 3 → G
  act_eq_smul : ∀ i x, T.act i x = label i • x
  pairProducts : ∀ g : G,
    g ≠ 1 ↔ ∃ i j : Fin 3, i < j ∧ label i * label j = g

variable {T : InvolutionTriple k}

/-- Under a Klein-four realization, pair-product deletion is exactly deletion by a
nontrivial stabilizer. -/
theorem pairFixed_iff_deleted (R : Realization (G := G) T) (x : Fin k) :
    T.PairFixed x ↔ KleinFour.Deleted (G := G) x := by
  constructor
  · rintro ⟨i, j, hij, hfix⟩
    refine ⟨R.label i * R.label j, (R.pairProducts _).2 ⟨i, j, hij, rfl⟩, ?_⟩
    rw [mul_smul, ← R.act_eq_smul, ← R.act_eq_smul]
    exact hfix
  · rintro ⟨g, hg, hfix⟩
    obtain ⟨i, j, hij, hprod⟩ := (R.pairProducts g).1 hg
    refine ⟨i, j, hij, ?_⟩
    rw [R.act_eq_smul, R.act_eq_smul, ← mul_smul, hprod]
    exact hfix

/-- Hence a `FixedDeleted.live` point has an injective Klein-four orbit map, the premise
used by `KleinFour.fullAdj_of_mem_orbit` to obtain a complete four-vertex orbit. -/
theorem live_orbitMap_injective (R : Realization (G := G) T) {x : Fin k}
    (hx : x ∈ T.live) : Function.Injective (fun g : G => g • x) := by
  apply KleinFour.orbitMap_injective
  rw [← pairFixed_iff_deleted R x]
  exact (T.mem_live_iff x).mp hx

end KleinFourBridge

end DihedralSchreier
