import CapGame.BuildGame

/-!
# Generic mirror lemmas for finite building games

This file contains the game-theoretic part of mirror/copycat arguments.  It is
deliberately independent of affine/projective geometry: geometric files only
need to prove that their proposed mirror reply is legal and remains in the
closed class of mirrorable positions.
-/

namespace FiniteBuildGame

variable {α : Type*} [Fintype α] [DecidableEq α]

/-- A finite position is invariant under a board equivalence. -/
def MirrorInvariant (σ : α ≃ α) (S : Finset α) : Prop :=
  S.map σ.toEmbedding = S

omit [Fintype α] [DecidableEq α] in
theorem apply_mem_of_mirrorInvariant {σ : α ≃ α} {S : Finset α}
    (hS : MirrorInvariant σ S) {x : α} (hx : x ∈ S) : σ x ∈ S := by
  unfold MirrorInvariant at hS
  rw [← hS]
  exact Finset.mem_map.mpr ⟨x, hx, rfl⟩

omit [Fintype α] [DecidableEq α] in
theorem mem_of_apply_mem_mirrorInvariant {σ : α ≃ α}
    (hσ : ∀ x : α, σ (σ x) = x) {S : Finset α}
    (hS : MirrorInvariant σ S) {x : α} (hx : σ x ∈ S) : x ∈ S := by
  unfold MirrorInvariant at hS
  have hxmap : x ∈ S.map σ.toEmbedding :=
    Finset.mem_map.mpr ⟨σ x, hx, hσ x⟩
  simpa [hS] using hxmap

/--
A one-step mirror reply condition at a single position.

For every legal move `x` from `S`, the mirror point `σ x` is a legal reply
after `x` has been played.  This is stronger than saying that `σ x` is legal
from `S`.
-/
def MirrorStepGood (Valid : Finset α -> Prop) (σ : α ≃ α) (S : Finset α) : Prop :=
  ∀ x : α, Move Valid S x -> Move Valid (insert x S) (σ x)

omit [Fintype α] in
theorem mirrorInvariant_insert_pair {σ : α ≃ α} (hσ : ∀ x : α, σ (σ x) = x)
    {S : Finset α} (hS : MirrorInvariant σ S) (x : α) :
    MirrorInvariant σ (insert (σ x) (insert x S)) := by
  classical
  unfold MirrorInvariant at hS ⊢
  ext y
  simp only [Finset.mem_map, Function.Embedding.coeFn_mk, Finset.mem_insert]
  constructor
  · rintro ⟨z, hz, rfl⟩
    rcases hz with rfl | rfl | hzS
    · exact Or.inr (Or.inl (hσ x))
    · exact Or.inl rfl
    · have hy : σ z ∈ S := by
        rw [← hS]
        exact Finset.mem_map.mpr ⟨z, hzS, rfl⟩
      exact Or.inr (Or.inr hy)
  · intro hy
    rcases hy with hy | hy | hyS
    · exact ⟨x, Or.inr (Or.inl rfl), hy.symm⟩
    · exact ⟨σ x, Or.inl rfl, by simpa [hσ x] using hy.symm⟩
    · have hyMap : y ∈ S.map σ.toEmbedding := by
        simpa [hS] using hyS
      rcases Finset.mem_map.mp hyMap with ⟨z, hzS, hz⟩
      exact ⟨z, Or.inr (Or.inr hzS), hz⟩

/--
Closed mirror strategy criterion.

`Good` is the class of positions on which the mirror strategy is meant to
continue. If every move from a `Good` position can be answered by `σ`, and the
two-move follower is again `Good`, then every `Good` position is P.
-/
theorem isP_of_closedMirror
    {Valid : Finset α -> Prop} {Good : Finset α -> Prop} (σ : α ≃ α)
    (hstep : ∀ {S : Finset α}, Good S -> ∀ x : α, Move Valid S x ->
      Move Valid (insert x S) (σ x) ∧ Good (insert (σ x) (insert x S)))
    (S : Finset α) (hgood : Good S) : IsP Valid S := by
  refine isP_of_replyStrategy (Valid := Valid) (Good := Good) ?_ S hgood
  intro T hT x hx
  exact ⟨σ x, (hstep hT x hx).1, (hstep hT x hx).2⟩

/--
Variant phrased with an explicit `MirrorStepGood` hypothesis plus a closure
hypothesis for the mirror-pair follower.
-/
theorem isP_of_mirrorStep_closed
    {Valid : Finset α -> Prop} {Good : Finset α -> Prop} (σ : α ≃ α)
    (hstepGood : ∀ {S : Finset α}, Good S -> MirrorStepGood Valid σ S)
    (hclosed : ∀ {S : Finset α}, Good S -> ∀ x : α, Move Valid S x ->
      Good (insert (σ x) (insert x S)))
    (S : Finset α) (hgood : Good S) : IsP Valid S := by
  exact isP_of_closedMirror (Valid := Valid) (Good := Good) σ
    (fun hS x hx => ⟨hstepGood hS x hx, hclosed hS x hx⟩) S hgood

/--
Common mirror criterion where the closed class is all valid positions invariant
under an involutive board equivalence.
-/
theorem isP_of_invariant_mirror
    {Valid : Finset α -> Prop} (σ : α ≃ α)
    (hσ : ∀ x : α, σ (σ x) = x)
    (hstepGood : ∀ {S : Finset α}, Valid S -> MirrorInvariant σ S ->
      MirrorStepGood Valid σ S)
    {S : Finset α} (hValid : Valid S) (hInv : MirrorInvariant σ S) :
    IsP Valid S := by
  let Good : Finset α -> Prop := fun T => Valid T ∧ MirrorInvariant σ T
  refine isP_of_mirrorStep_closed (Valid := Valid) (Good := Good) σ ?_ ?_ S
    ⟨hValid, hInv⟩
  · intro T hT
    exact hstepGood hT.1 hT.2
  · intro T hT x hx
    exact ⟨(hstepGood hT.1 hT.2 x hx).2, mirrorInvariant_insert_pair hσ hT.2 x⟩

end FiniteBuildGame
