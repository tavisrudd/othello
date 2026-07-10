import CapGame.Mirror

/-!
# Conflict-graph (capacity-1) mirror for finite building games

The queens / Node-Kayles achievement game is the **capacity-1** instance of the
cap/Nofil family: a position is a set of vertices with no two in conflict, i.e.
an *independent set* of a conflict graph, and a move adds one fresh non-conflicting
vertex.  This file records the capacity-1 specialisation of the shared normal-play
mirror engine (`FiniteBuildGame.isP_of_invariant_mirror`, `CapGame/Mirror.lean`):
a fixed-point-free adjacency-preserving involution `σ` gives a second-player win,
provided the single per-vertex **chord** condition `¬ adj x (σ x)` holds.

Compared with the projective cap mirror (`ProjectiveCap/Mirror.lean`) the argument
is strictly simpler: at capacity 1 an obstruction is a single *edge* (two points),
so there is no three-point "line closure" subtlety — the mirror-chord obstruction
is exactly the pair `{x, σ x}`, killed by the chord hypothesis, and every old-old
obstruction `{σ x, z}` reflects under `σ` to `{x, σ z}`, already excluded by `x`'s
legality.

The abstract "fpf involution ⇒ P" fact here is folklore (the copycat / pairing
strategy that the queens P-position proofs use unnamed); the content this file
adds is the clean statement of the capacity-1 **pair-extension condition** and its
Cayley-graph instance, where the chord condition becomes a single membership test.

**Relation to `NodeKayles.Graph.win`.** The repo already has a Node-Kayles
formalisation (`NodeKayles/Basic.lean`) using the *vertex-deletion* encoding
`Graph.win` (a mover deletes `{v} ∪ N(v)`).  The `IndepValid` game here is the
*independent-set-building* encoding; the two compute the same normal-play value,
but this file does **not** prove them equal — that bridge is
`NodeKayles.ConflictGameEquiv` (`indepGame_isP_iff`), a separate game-equivalence
proof.
-/

namespace ConflictGraph

open FiniteBuildGame

variable {α : Type*} [Fintype α] [DecidableEq α]

/--
Independent-set validity for a conflict relation `adj`: a position `S` is valid
iff no two distinct chosen vertices conflict.  Building an independent set is the
capacity-1 cap/Nofil game.  (`adj` is intended symmetric and irreflexive; the
`x ≠ y` guard already discounts self-loops, so only symmetry is used below.)
-/
def IndepValid (adj : α -> α -> Prop) (S : Finset α) : Prop :=
  ∀ x ∈ S, ∀ y ∈ S, x ≠ y -> ¬ adj x y

omit [Fintype α] in
/-- Inserting a vertex non-adjacent to every current vertex preserves independence. -/
theorem indepValid_insert {adj : α -> α -> Prop}
    (hsymm : ∀ x y : α, adj x y -> adj y x)
    {S : Finset α} {y : α} (hS : IndepValid adj S)
    (hnew : ∀ z ∈ S, ¬ adj y z) :
    IndepValid adj (insert y S) := by
  intro a ha b hb hab
  simp only [Finset.mem_insert] at ha hb
  rcases ha with ha | haS
  · rcases hb with hb | hbS
    · exact absurd (ha.trans hb.symm) hab
    · rw [ha]; exact hnew b hbS
  · rcases hb with hb | hbS
    · rw [hb]; exact fun h => hnew a haS (hsymm a y h)
    · exact hS a haS b hbS hab

omit [Fintype α] in
/--
Capacity-1 mirror step.

For a fixed-point-free adjacency-preserving involution `σ`, if the chord
`¬ adj x (σ x)` holds for the move `x`, then the mirror reply `σ x` is legal after
`x` from any `σ`-invariant independent position.  The old-old obstruction is
reflected by adjacency preservation; the only genuinely new obstruction is the
mirror chord itself.
-/
theorem mirrorStepGood_of_adjPreserving (adj : α -> α -> Prop)
    (hsymm : ∀ x y : α, adj x y -> adj y x)
    (σ : α ≃ α) (hσ : ∀ x : α, σ (σ x) = x)
    (hfixed : ∀ x : α, σ x ≠ x)
    (hadj : ∀ x y : α, adj (σ x) (σ y) ↔ adj x y)
    {S : Finset α} (hInv : MirrorInvariant σ S)
    (hchord : ∀ x : α, ¬ adj x (σ x)) :
    MirrorStepGood (IndepValid adj) σ S := by
  intro x hxmove
  have hxnotS : x ∉ S := hxmove.1
  have hxindep : IndepValid adj (insert x S) := hxmove.2
  have hsigNotS : σ x ∉ S := fun hxS =>
    hxnotS (mem_of_apply_mem_mirrorInvariant hσ hInv hxS)
  have hsigNot : σ x ∉ insert x S := by
    intro hxIns
    rcases Finset.mem_insert.mp hxIns with hEq | hxS
    · exact hfixed x hEq
    · exact hsigNotS hxS
  refine ⟨hsigNot, ?_⟩
  refine indepValid_insert hsymm hxindep ?_
  intro z hz
  rcases Finset.mem_insert.mp hz with hzx | hzS
  · -- mirror chord: `z = x`, need `¬ adj (σ x) x`
    rw [hzx]
    exact fun h => hchord x (hsymm (σ x) x h)
  · -- old-old: `z ∈ S`, reflect `adj (σ x) z` to `adj x (σ z)`
    intro hadjc
    have hσzS : σ z ∈ S := apply_mem_of_mirrorInvariant hInv hzS
    have hxsz : adj x (σ z) := by
      have h := hadj x (σ z)
      rw [hσ z] at h
      exact h.mp hadjc
    have hx_ne : x ≠ σ z := fun he => hxnotS (by rw [he]; exact hσzS)
    exact hxindep x (Finset.mem_insert_self x S) (σ z)
      (Finset.mem_insert_of_mem hσzS) hx_ne hxsz

/--
Capacity-1 fixed-point-free mirror theorem.

A symmetric conflict relation with a fixed-point-free adjacency-preserving
involution `σ` all of whose chords `x — σ x` are non-edges gives a second-player
win from the empty position: the independent-set-building game on the graph is a
P-position.
-/
theorem initialIndepP_of_fpf_adjPreserving_involution (adj : α -> α -> Prop)
    (hsymm : ∀ x y : α, adj x y -> adj y x)
    (σ : α ≃ α) (hσ : ∀ x : α, σ (σ x) = x)
    (hfixed : ∀ x : α, σ x ≠ x)
    (hadj : ∀ x y : α, adj (σ x) (σ y) ↔ adj x y)
    (hchord : ∀ x : α, ¬ adj x (σ x)) :
    IsP (IndepValid adj) (∅ : Finset α) := by
  refine isP_of_invariant_mirror (Valid := IndepValid adj) σ hσ
    (fun {_S} _ hInv =>
      mirrorStepGood_of_adjPreserving adj hsymm σ hσ hfixed hadj hInv hchord)
    ?_ ?_
  · intro a ha; simp at ha
  · simp [MirrorInvariant]

/-! ## Cayley-graph instance

For a finite group `G` and a symmetric connection set `S : Finset G`, the Cayley
conflict `x ~ y := x⁻¹ * y ∈ S` is symmetric.  (`1 ∉ S` would make it irreflexive,
but the P-theorems below never need irreflexivity — `IndepValid`'s `x ≠ y` guard
already discounts self-loops — so it is not assumed; `cayleyAdj_irrefl` records it.)
An order-two element `g` gives the left-translation involution
`σ x = g * x`, which is fixed-point-free and preserves the Cayley adjacency.  The
chord condition becomes `x⁻¹ * (g * x) ∉ S` — the whole conjugacy class of `g`
avoids `S`; for a commutative group this collapses to the single test `g ∉ S`.
-/

namespace Cayley

open FiniteBuildGame

variable {G : Type*} [Group G] [Fintype G] [DecidableEq G]

/-- Cayley conflict relation for a connection set `S`: `x ~ y` iff `x⁻¹ * y ∈ S`. -/
def cayleyAdj (S : Finset G) (x y : G) : Prop := x⁻¹ * y ∈ S

omit [Fintype G] [DecidableEq G] in
/-- The Cayley conflict is symmetric when `S` is closed under inversion. -/
theorem cayleyAdj_symm (S : Finset G) (hS : ∀ s ∈ S, s⁻¹ ∈ S) :
    ∀ x y : G, cayleyAdj S x y -> cayleyAdj S y x := by
  intro x y h
  have hrw : y⁻¹ * x = (x⁻¹ * y)⁻¹ := by group
  rw [cayleyAdj, hrw]
  exact hS _ h

omit [Fintype G] [DecidableEq G] in
/-- The Cayley conflict is irreflexive when the identity is not a connection. -/
theorem cayleyAdj_irrefl (S : Finset G) (hS : (1 : G) ∉ S) (x : G) :
    ¬ cayleyAdj S x x := by
  have hrw : x⁻¹ * x = 1 := inv_mul_cancel x
  rw [cayleyAdj, hrw]
  exact hS

/-- Left translation by an order-two element `g`, packaged as an involution. -/
def leftMulEquiv (g : G) (hg2 : g * g = 1) : G ≃ G where
  toFun x := g * x
  invFun x := g * x
  left_inv x := by show g * (g * x) = x; rw [← mul_assoc, hg2, one_mul]
  right_inv x := by show g * (g * x) = x; rw [← mul_assoc, hg2, one_mul]

/--
Cayley Node-Kayles mirror (general group): for a symmetric connection set `S` and
an order-two element `g` whose conjugacy class avoids `S` (`∀ x, x⁻¹ * (g * x) ∉ S`),
the independent-set game on the Cayley graph `Cay(G, S)` is a P-position.
-/
theorem initialIndepP_cayley_of_involution_chord (S : Finset G)
    (hSsymm : ∀ s ∈ S, s⁻¹ ∈ S) (g : G) (hg2 : g * g = 1) (hg1 : g ≠ 1)
    (hchord : ∀ x : G, x⁻¹ * (g * x) ∉ S) :
    IsP (IndepValid (cayleyAdj S)) (∅ : Finset G) := by
  refine initialIndepP_of_fpf_adjPreserving_involution (cayleyAdj S)
    (cayleyAdj_symm S hSsymm) (leftMulEquiv g hg2) ?_ ?_ ?_ ?_
  · intro x
    show g * (g * x) = x
    rw [← mul_assoc, hg2, one_mul]
  · intro x hx
    apply hg1
    have hgx : g * x = x := hx
    have hrw : g * x = 1 * x := by rw [one_mul]; exact hgx
    exact mul_right_cancel hrw
  · intro x y
    show cayleyAdj S (g * x) (g * y) ↔ cayleyAdj S x y
    have hrw : (g * x)⁻¹ * (g * y) = x⁻¹ * y := by group
    rw [cayleyAdj, cayleyAdj, hrw]
  · intro x
    show ¬ cayleyAdj S x (g * x)
    exact hchord x

end Cayley

/-! ### Commutative Cayley graphs -/

namespace Cayley

variable {G : Type*} [CommGroup G] [Fintype G] [DecidableEq G]

/--
Cayley Node-Kayles mirror (commutative group).

For a commutative group the conjugacy class of `g` is the singleton `{g}`, so the
chord condition collapses to the single membership test `g ∉ S`: if `S` is a
symmetric connection set and `g` is an order-two element with `g ∉ S`, the
independent-set game on `Cay(G, S)` is a P-position.

This is the group-theoretic shadow of the sum-free `z = t + n/2` breaker: an
order-two translation whose step `g` (there `n/2`) is not itself a forbidden
connection supplies a fixed-point-free pairing of the whole board.
-/
theorem initialIndepP_cayley_abelian_of_involution_notMem (S : Finset G)
    (hSsymm : ∀ s ∈ S, s⁻¹ ∈ S) (g : G) (hg2 : g * g = 1) (hg1 : g ≠ 1)
    (hgS : g ∉ S) :
    IsP (IndepValid (cayleyAdj S)) (∅ : Finset G) := by
  refine initialIndepP_cayley_of_involution_chord S hSsymm g hg2 hg1 ?_
  intro x
  have hrw : x⁻¹ * (g * x) = g := by
    rw [mul_comm g x, ← mul_assoc, inv_mul_cancel, one_mul]
  rw [hrw]
  exact hgS

end Cayley

end ConflictGraph
