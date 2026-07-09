import CapGame.Mirror
import ProjectiveCap.Projective

/-!
# Capacity-`c` cap/Nofil mirror, and where capacity-blindness stops

The projective cap game forbids `3` collinear points.  Its capacity-`c`
generalisation forbids `c + 1` collinear points ("no line carries more than `c`
chosen points"); the standard `Cap` is the `c = 2` case.  This file records how
far the shared normal-play mirror engine (`FiniteBuildGame.isP_of_invariant_mirror`)
reaches for the capacity-`c` game — and, more usefully, the sharp point where it
stops.

## What is capacity-blind, and what is not

Take a fixed-point-free involution `σ` that preserves the collinearity structure,
and let the second player answer every move `x` by its mirror `σ x`.  Working
through the mirror step for the capacity-`c` game (below, `capCMirrorStep_of_no_chord`)
splits the possible obstructions in `insert (σ x) (insert x S)` into two groups:

* **old-old / reflectable** (a forbidden collinear set through `σ x` but not `x`):
  reflected by `σ` to a forbidden set through `x` already inside `insert x S`,
  contradicting `x`'s legality.  **This part never inspects `c`** — it is genuinely
  capacity-blind, and is discharged here for every `c`.
* **mirror-chord** (a forbidden collinear set containing *both* `x` and `σ x`):
  isolated here as an explicit hypothesis `hchord`.  This is the *only* place the
  capacity enters.

So the general capacity-`c` mirror theorem is `initialCapCP_of_no_chord`, fully
proved, with the chord as an explicit obligation.

## The chord discharge is `c = 2`-only (the method boundary)

For the ordinary cap game (`c = 2`) the chord discharges automatically: a forbidden
config through the chord is a triple `{x, σ x, z}` collinear with `z ∈ S`; reflecting
gives `{x, σ x, σ z}` collinear, so `z` and `σ z` lie on the line `x — σ x`, whence
`{x, z, σ z}` is `3` collinear inside `insert x S`.  Since `σ` is fixed-point-free,
`z ≠ σ z`, so this is a genuine `3`-point violation — contradicting `x`'s legality.
(This is exactly `ProjectiveCap.Projective.mirrorStepGood_of_collinearity_preserving`,
left untouched; the `c = 2` game is the maintained instance.)

For `c ≥ 3` the same discharge **fails**, and the failure is not an artifact of the
proof — the pairing strategy genuinely loses.  A forbidden config through the chord
now has `c - 1 ≥ 2` old points `M ⊆ S` on the line `x — σ x`.  Reflecting bounds
`{x} ∪ M ∪ σ M` inside `insert x S`, which is a violation only if `|M ∪ σ M| ≥ c`,
i.e. only if `σ M ⊄ M`.  When `M` is `σ`-invariant (a union of `σ`-pairs, possible
once `|M| ≥ 2`) it is not, and there is a concrete counterexample:

> In `PG(2, q)` (`q` odd), take a `σ`-invariant line `ℓ` and a `σ`-pair
> `{a, σ a} ⊆ ℓ`.  Under mirror play `S ⊇ {a, σ a}`; the first player plays a
> third point `x ∈ ℓ`.  For `c = 3` the position `{a, σ a, x}` has only `3`
> collinear points, so `x` is **legal**; but the forced reply `σ x ∈ ℓ` completes
> `{a, σ a, x, σ x}` — `4` collinear — so `σ x` is **illegal**.  The pairing
> strategy is stuck.

The reason `c = 2` is safe is the same fact stated positively: a `σ`-pair already
*fills a line to its capacity* (`2`), so no legal move can add a third point that a
mirror reply would overflow.  At `c ≥ 3` a `σ`-pair leaves room, and the opponent
exploits it.

**Consequence.** The odd-`PG(2m−1,q)` and hyperbolic-quadric `Q⁺(2m−1,q)` P-results
(`ProjectiveCap.Mirror`, `ProjectiveCap.HyperbolicQuadricMirror`) do **not** lift to
the capacity-`c` game for `c ≥ 3` via this pairing argument; the capacity-`c`
question for `c ≥ 3` is genuinely open to this method, not a free corollary.  See
`notes/2026-07-09-mirror-unification.md`.
-/

namespace FiniteBuildGame

variable {α : Type*} [Fintype α] [DecidableEq α]

/--
Capacity-`c` avoidance game for an abstract "collinearity" (flat) predicate `Coll`
on finite sets: a position `S` is valid iff every collinear subset carries at most
`c` points.  Geometric `Cap` is the instance `Coll L = IsCollinear ↑L`, `c = 2`.
-/
def CapCValid (Coll : Finset α -> Prop) (c : ℕ) (S : Finset α) : Prop :=
  ∀ ⦃L : Finset α⦄, L ⊆ S -> Coll L -> L.card ≤ c

omit [Fintype α] [DecidableEq α] in
/-- The empty position is capacity-`c` valid. -/
theorem capCValid_empty {Coll : Finset α -> Prop} {c : ℕ} :
    CapCValid Coll c (∅ : Finset α) := by
  intro L hL _
  rw [Finset.subset_empty.mp hL, Finset.card_empty]
  exact Nat.zero_le c

omit [Fintype α] in
/--
Capacity-`c` mirror step, chord isolated.

The old-old obstruction (a collinear violation through `σ x` but not `x`) is
reflected across `σ` and discharged for **every** `c` using only collinearity
preservation and `σ`-invariance.  The mirror-chord obstruction (a collinear
violation containing both `x` and `σ x`) is left as the explicit hypothesis
`hchord`; discharging it is where capacity enters (see the file header).
-/
theorem capCMirrorStep_of_no_chord {Coll : Finset α -> Prop} {c : ℕ}
    (σ : α ≃ α) (hσ : ∀ x : α, σ (σ x) = x) (hfixed : ∀ x : α, σ x ≠ x)
    (hCollMap : ∀ L : Finset α, Coll (L.map σ.toEmbedding) ↔ Coll L)
    {S : Finset α} (hInv : MirrorInvariant σ S)
    (hchord : ∀ x : α, Move (CapCValid Coll c) S x ->
      ∀ L : Finset α, L ⊆ insert (σ x) (insert x S) ->
        x ∈ L -> σ x ∈ L -> Coll L -> L.card ≤ c) :
    MirrorStepGood (CapCValid Coll c) σ S := by
  intro x hxmove
  have hxnotS : x ∉ S := hxmove.1
  have hxvalid : CapCValid Coll c (insert x S) := hxmove.2
  have hsigNotS : σ x ∉ S := fun hxS =>
    hxnotS (mem_of_apply_mem_mirrorInvariant hσ hInv hxS)
  have hsigNot : σ x ∉ insert x S := by
    intro hxIns
    rcases Finset.mem_insert.mp hxIns with hEq | hxS
    · exact hfixed x hEq
    · exact hsigNotS hxS
  refine ⟨hsigNot, ?_⟩
  intro L hLsub hLcoll
  by_cases hσxL : σ x ∈ L
  · by_cases hxL : x ∈ L
    · -- mirror chord: both `x` and `σ x` are in the collinear set
      exact hchord x hxmove L hLsub hxL hσxL hLcoll
    · -- reflectable: `σ x ∈ L`, `x ∉ L`; map `L` by `σ` into `insert x S`
      have hLsub' : L ⊆ insert (σ x) S := by
        intro a ha
        rcases Finset.mem_insert.mp (hLsub ha) with h | h
        · rw [h]; exact Finset.mem_insert_self _ _
        · rcases Finset.mem_insert.mp h with hx | hS
          · rw [hx] at ha; exact absurd ha hxL
          · exact Finset.mem_insert_of_mem hS
      have hmap : (insert (σ x) S).map σ.toEmbedding = insert x S := by
        rw [Finset.map_insert, hInv]
        congr 1
        simp [hσ x]
      have hmapsub : L.map σ.toEmbedding ⊆ insert x S := by
        have hsub : L.map σ.toEmbedding ⊆ (insert (σ x) S).map σ.toEmbedding :=
          Finset.map_subset_map.mpr hLsub'
        rwa [hmap] at hsub
      have hmapcoll : Coll (L.map σ.toEmbedding) := (hCollMap L).mpr hLcoll
      have hcard := hxvalid hmapsub hmapcoll
      rwa [Finset.card_map] at hcard
  · -- `σ x ∉ L`, so `L ⊆ insert x S` and `x`'s legality already bounds it
    have hLsub' : L ⊆ insert x S := by
      intro a ha
      rcases Finset.mem_insert.mp (hLsub ha) with h | h
      · rw [h] at ha; exact absurd ha hσxL
      · exact h
    exact hxvalid hLsub' hLcoll

/--
General capacity-`c` mirror theorem (chord explicit).

A fixed-point-free collinearity-preserving involution `σ` with the per-move chord
bound gives a second-player win from the empty capacity-`c` position.  Every
hypothesis except `hchord` is capacity-blind; `hchord` is the only capacity gate
(discharged automatically at `c = 2`, but not for `c ≥ 3` — see the file header).
-/
theorem initialCapCP_of_no_chord {Coll : Finset α -> Prop} {c : ℕ}
    (σ : α ≃ α) (hσ : ∀ x : α, σ (σ x) = x) (hfixed : ∀ x : α, σ x ≠ x)
    (hCollMap : ∀ L : Finset α, Coll (L.map σ.toEmbedding) ↔ Coll L)
    (hchord : ∀ {S : Finset α}, CapCValid Coll c S -> MirrorInvariant σ S ->
      ∀ x : α, Move (CapCValid Coll c) S x ->
        ∀ L : Finset α, L ⊆ insert (σ x) (insert x S) ->
          x ∈ L -> σ x ∈ L -> Coll L -> L.card ≤ c) :
    IsP (CapCValid Coll c) (∅ : Finset α) := by
  refine isP_of_invariant_mirror (Valid := CapCValid Coll c) σ hσ
    (fun {_S} hVal hInv =>
      capCMirrorStep_of_no_chord σ hσ hfixed hCollMap hInv (hchord hVal hInv))
    capCValid_empty ?_
  simp [MirrorInvariant]

end FiniteBuildGame

/-! ## Geometric capacity-`c` projective cap game -/

open scoped LinearAlgebra.Projectivization

namespace ProjectiveCap
namespace Projective

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]
variable [Fintype (Point K V)] [DecidableEq (Point K V)]

/--
Capacity-`c` projective cap game: a position is valid iff every collinear subset
of it carries at most `c` points (equivalently, no `c + 1` chosen points are
collinear).  This is `FiniteBuildGame.CapCValid` for the geometric collinearity
predicate; the ordinary cap game is the `c = 2` case.
-/
def CapC (c : ℕ) (S : Finset (Point K V)) : Prop :=
  FiniteBuildGame.CapCValid
    (fun L => Projectivization.IsCollinear (↑L : Set (Point K V))) c S

/--
Geometric capacity-`c` mirror theorem (chord explicit).

Specialisation of `FiniteBuildGame.initialCapCP_of_no_chord` to the projective
board with mathlib collinearity.  The collinearity-transport hypothesis `hCollMap`
is the set-level analogue of `collinear_mapEquiv` (the `hcol` input the existing
`c = 2` elliptic mirror discharges); the chord obligation `hchord` is the capacity
gate discussed in the file header.
-/
theorem initialCapCP_of_setCollinearity_preserving_no_chord (c : ℕ)
    (σ : Point K V ≃ Point K V) (hσ : ∀ x : Point K V, σ (σ x) = x)
    (hfixed : ∀ x : Point K V, σ x ≠ x)
    (hCollMap : ∀ L : Finset (Point K V),
      Projectivization.IsCollinear (↑(L.map σ.toEmbedding) : Set (Point K V)) ↔
        Projectivization.IsCollinear (↑L : Set (Point K V)))
    (hchord : ∀ {S : Finset (Point K V)}, CapC c S ->
      FiniteBuildGame.MirrorInvariant σ S ->
      ∀ x : Point K V, FiniteBuildGame.Move (CapC c) S x ->
        ∀ L : Finset (Point K V), L ⊆ insert (σ x) (insert x S) ->
          x ∈ L -> σ x ∈ L ->
          Projectivization.IsCollinear (↑L : Set (Point K V)) -> L.card ≤ c) :
    FiniteBuildGame.IsP (CapC c) (∅ : Finset (Point K V)) :=
  FiniteBuildGame.initialCapCP_of_no_chord σ hσ hfixed hCollMap hchord

end Projective
end ProjectiveCap
