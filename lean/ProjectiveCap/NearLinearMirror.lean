import ProjectiveCap.CapCMirror

/-!
# Capacity-2 near-linear mirror engine, with the rook-grid (`Q⁺(3,q)`) instance

A capacity-2 specialisation of the fixed-point-free mirror method, continuing the
C48 harvest (`ProjectiveCap.HyperbolicQuadricMirror`).  This file provides the
abstract *near-linear* c = 2 engine and its one concrete Lean instance, the
rook-lines grid game.  It is the intended engine for the C51 (symplectic polar
space) and C52 (Segre product) Nofil programs — see the scope note below for what
is and is not formalised here.

## The engine — capacity-2 near-linear mirror

`FiniteBuildGame.initialCapCP_of_no_chord` (`ProjectiveCap.CapCMirror`) reduces a
capacity-`c` mirror to a single per-move *chord* obligation.  At `c = 2` the chord
discharges from one geometric fact — **two distinct points lie on at most one
line** (a *near-linear space* / partial linear space).  We package that discharge
as `initialCapC2P_of_nearLinear_mirror`: for an abstract downward-closed
"collinearity" predicate `Coll` obeying the near-linearity law

  `a ≠ b → Coll {a,b,z} → Coll {a,b,w} → Coll {a,z,w}`,

a fixed-point-free `Coll`-preserving involution gives a second-player win.  This is
the intended shared heart of every capacity-2 near-linear Nofil game.

## What is formalised here (Lean-proven)

`GridRook.gridRook_isP`: the capacity-2 rook-lines game on `A × ZMod (2t)` (rows
`A` arbitrary finite, `2t` columns) is P, via the column-shift mirror
`(i,j) ↦ (i, j+t)`.  With `A = ZMod (q+1)`, `2t = q+1`, odd `q`, this abstract rook
grid *models* the C52 base family `Q⁺(3,q) = PG(1,q)×PG(1,q)` — but that
identification is standard finite geometry and is **not** itself formalised (there
is no Lean bridge from the projective `Point`/quadric types to `A × ZMod (2t)`, and
no `q`-specialisation is instantiated).

## Not formalised here — external evidence and future work

The C51/C52 targets this engine is meant for have **no Lean content**.  The
"machine-verified" cases below are external Python/Nofil enumerations of specific
small `(n,q)`, strictly weaker than an all-`q` theorem, recorded in the cited
notes:

* **C51 symplectic Nofil** `W(2n−1,q)`: `Coll` = "on a common totally-isotropic
  line" of an alternating form; the elliptic block map `(a,b)↦(δ b,a)` is
  (conjecturally) a symplectic similitude scaling the form by `−δ`.  No alternating
  form or isotropic-line predicate is defined in Lean.  Machine-verified (Python):
  `W(3,3)`, `W(3,5)`, `W(5,3)` — see `notes/2026-07-09-codex-polar-space-nofil.md`.
* **C52 Segre / product Nofil** `PG(a,q)×PG(b,q)` (beyond the rook grid above):
  `Coll` = "on a common ruling line"; mirror `σ = id × (elliptic fpf involution on
  the odd factor)`.  No general Segre board is defined in Lean.  Machine-verified
  (Python): `PG(1,3)²`, `PG(2,3)×PG(1,3)`, `PG(1,3)×PG(3,3)` — see
  `notes/2026-07-09-codex-segre-product-nofil.md`.

Wiring either family into `initialCapC2P_of_nearLinear_mirror` requires first
building its geometric `Coll` predicate in mathlib and proving it near-linear.
-/

namespace FiniteBuildGame

variable {α : Type*} [Fintype α] [DecidableEq α]

omit [Fintype α] in
/--
Capacity-2 chord discharge from near-linearity.

For a downward-closed collinearity predicate `Coll` preserved by a
fixed-point-free involution `σ`, and satisfying the near-linear law
`hLinear`, the mirror-chord obstruction of the capacity-2 game is impossible: a
collinear set through both `x` and `σ x` cannot exceed 2 points.  This is the sole
capacity-dependent step of `initialCapCP_of_no_chord`; the near-linear law is what
the ordinary cap game gets for free from projective collinearity.
-/
theorem capC2Chord_of_nearLinear {Coll : Finset α -> Prop}
    (σ : α ≃ α) (hσ : ∀ x : α, σ (σ x) = x) (hfixed : ∀ x : α, σ x ≠ x)
    (hDown : ∀ {L L' : Finset α}, L ⊆ L' -> Coll L' -> Coll L)
    (hCollMap : ∀ L : Finset α, Coll (L.map σ.toEmbedding) ↔ Coll L)
    (hLinear : ∀ {a b z w : α}, a ≠ b ->
      Coll {a, b, z} -> Coll {a, b, w} -> Coll {a, z, w}) :
    ∀ {S : Finset α}, CapCValid Coll 2 S -> MirrorInvariant σ S ->
      ∀ x : α, Move (CapCValid Coll 2) S x ->
        ∀ L : Finset α, L ⊆ insert (σ x) (insert x S) ->
          x ∈ L -> σ x ∈ L -> Coll L -> L.card ≤ 2 := by
  intro S _hval hInv x hmove L hLsub hxL hσxL hLcoll
  by_contra hcard
  push Not at hcard  -- hcard : 2 < L.card
  have hxσx : x ≠ σ x := (hfixed x).symm
  -- extract a third point z ∈ L, distinct from x and σ x, so z ∈ S
  have hcard2 : ({x, σ x} : Finset α).card = 2 := by
    rw [Finset.card_insert_of_notMem (by simp [hxσx]), Finset.card_singleton]
  have hdiff : (L \ {x, σ x}).Nonempty := by
    rw [Finset.sdiff_nonempty]
    intro hsub
    have hcle : L.card ≤ ({x, σ x} : Finset α).card := Finset.card_le_card hsub
    rw [hcard2] at hcle
    omega
  obtain ⟨z, hz⟩ := hdiff
  rw [Finset.mem_sdiff] at hz
  obtain ⟨hzL, hzne⟩ := hz
  simp only [Finset.mem_insert, Finset.mem_singleton, not_or] at hzne
  obtain ⟨hzx, hzσx⟩ := hzne
  have hzS : z ∈ S := by
    have hzmem := hLsub hzL
    simp only [Finset.mem_insert] at hzmem
    rcases hzmem with h | h | h
    · exact absurd h hzσx
    · exact absurd h hzx
    · exact h
  -- Coll {x, σ x, z}
  have htri_sub : ({x, σ x, z} : Finset α) ⊆ L := by
    intro a ha
    simp only [Finset.mem_insert, Finset.mem_singleton] at ha
    rcases ha with rfl | rfl | rfl
    · exact hxL
    · exact hσxL
    · exact hzL
  have hColl1 : Coll {x, σ x, z} := hDown htri_sub hLcoll
  -- push through σ: Coll {x, σ x, σ z}
  have hmapeq : ({x, σ x, z} : Finset α).map σ.toEmbedding = {σ x, x, σ z} := by
    simp only [Finset.map_insert, Finset.map_singleton, Equiv.coe_toEmbedding, hσ]
  have hColl2' : Coll (({x, σ x, z} : Finset α).map σ.toEmbedding) :=
    (hCollMap _).mpr hColl1
  rw [hmapeq] at hColl2'
  have hColl2 : Coll {x, σ x, σ z} := by
    have hset : ({σ x, x, σ z} : Finset α) = {x, σ x, σ z} := by
      ext a; simp only [Finset.mem_insert, Finset.mem_singleton]; tauto
    rwa [hset] at hColl2'
  have hColl3 : Coll {x, z, σ z} := hLinear hxσx hColl1 hColl2
  -- {x, z, σ z} ⊆ insert x S has card 3, contradicting x's legality
  have hσzS : σ z ∈ S := apply_mem_of_mirrorInvariant hInv hzS
  have hxnotS : x ∉ S := hmove.1
  have hxz : x ≠ z := fun h => hxnotS (h ▸ hzS)
  have hxσz : x ≠ σ z := fun h => hxnotS (h ▸ hσzS)
  have hzσz : z ≠ σ z := (hfixed z).symm
  have htri2_sub : ({x, z, σ z} : Finset α) ⊆ insert x S := by
    intro a ha
    simp only [Finset.mem_insert, Finset.mem_singleton] at ha ⊢
    rcases ha with h | h | h
    · exact Or.inl h
    · exact Or.inr (h ▸ hzS)
    · exact Or.inr (h ▸ hσzS)
  have hcard3 : ({x, z, σ z} : Finset α).card = 3 := by
    rw [Finset.card_insert_of_notMem (by simp [hxz, hxσz]),
      Finset.card_insert_of_notMem (by simp [hzσz]), Finset.card_singleton]
  have hle : ({x, z, σ z} : Finset α).card ≤ 2 := hmove.2 htri2_sub hColl3
  rw [hcard3] at hle
  omega

/--
Capacity-2 near-linear mirror theorem.

A fixed-point-free involution `σ` preserving a downward-closed near-linear
collinearity predicate `Coll` gives a second-player win from the empty
capacity-2 position.  The one Lean instantiation is `GridRook.gridRook_isP` (the
rook-lines grid, C52 base family); the projective cap game and the symplectic (C51)
and general Segre (C52) instances are intended but not yet wired in Lean (see the
file header).
-/
theorem initialCapC2P_of_nearLinear_mirror {Coll : Finset α -> Prop}
    (σ : α ≃ α) (hσ : ∀ x : α, σ (σ x) = x) (hfixed : ∀ x : α, σ x ≠ x)
    (hDown : ∀ {L L' : Finset α}, L ⊆ L' -> Coll L' -> Coll L)
    (hCollMap : ∀ L : Finset α, Coll (L.map σ.toEmbedding) ↔ Coll L)
    (hLinear : ∀ {a b z w : α}, a ≠ b ->
      Coll {a, b, z} -> Coll {a, b, w} -> Coll {a, z, w}) :
    IsP (CapCValid Coll 2) (∅ : Finset α) :=
  initialCapCP_of_no_chord σ hσ hfixed hCollMap
    (capC2Chord_of_nearLinear σ hσ hfixed hDown hCollMap hLinear)

end FiniteBuildGame

/-!
## Concrete instantiation: the capacity-2 rook-lines game (C52 base family)

As a partial linear space, `Q⁺(3,q) = PG(1,q) × PG(1,q)` is the `(q+1)×(q+1)` grid
whose ≥3-point lines are exactly the rows and columns — the capacity-2 rook-lines
game.  We prove the general version (`A` rows, `2t` columns) P via the column-shift
mirror; with `A = ZMod (q+1)`, `2t = q+1`, odd `q`, this is the `Q⁺(3,q)` base
family (the quadric identification is standard finite geometry, not formalised here).
-/

namespace GridRook

open FiniteBuildGame

variable {A : Type*} [Fintype A] [DecidableEq A]
variable {t : ℕ} [NeZero (2 * t)]

/-- A set of grid cells is "collinear" iff it lies in one row or one column. -/
def rookColl (L : Finset (A × ZMod (2 * t))) : Prop :=
  (∃ i : A, ∀ p ∈ L, p.1 = i) ∨ (∃ j : ZMod (2 * t), ∀ p ∈ L, p.2 = j)

/-- Column shift by `t` (half the width): an involution of the grid. -/
def shift : A × ZMod (2 * t) ≃ A × ZMod (2 * t) :=
  (Equiv.refl A).prodCongr (Equiv.addRight (t : ZMod (2 * t)))

omit [Fintype A] [DecidableEq A] [NeZero (2 * t)] in
@[simp] theorem shift_apply (p : A × ZMod (2 * t)) :
    shift p = (p.1, p.2 + (t : ZMod (2 * t))) := rfl

omit [NeZero (2 * t)] in
theorem two_t_cast_zero : ((t : ZMod (2 * t)) + (t : ZMod (2 * t))) = 0 := by
  have : ((2 * t : ℕ) : ZMod (2 * t)) = 0 := ZMod.natCast_self (2 * t)
  push_cast at this
  linear_combination this

omit [Fintype A] [DecidableEq A] [NeZero (2 * t)] in
theorem shift_involutive (p : A × ZMod (2 * t)) : shift (shift p) = p := by
  simp only [shift_apply]
  ext
  · rfl
  · show p.2 + (t : ZMod (2 * t)) + (t : ZMod (2 * t)) = p.2
    rw [add_assoc, two_t_cast_zero, add_zero]

omit [NeZero (2 * t)] in
theorem t_cast_ne_zero (ht : 0 < t) : (t : ZMod (2 * t)) ≠ 0 := by
  rw [Ne, CharP.cast_eq_zero_iff (ZMod (2 * t)) (2 * t) t]
  intro hdvd
  have hle := Nat.le_of_dvd ht hdvd
  omega

omit [Fintype A] [DecidableEq A] [NeZero (2 * t)] in
theorem shift_fixed (ht : 0 < t) (p : A × ZMod (2 * t)) : shift p ≠ p := by
  intro h
  have hcol : p.2 + (t : ZMod (2 * t)) = p.2 := by
    have h2 := congrArg Prod.snd h
    simpa [shift_apply] using h2
  have hcol0 : p.2 + (t : ZMod (2 * t)) = p.2 + 0 := by rw [add_zero]; exact hcol
  exact t_cast_ne_zero ht (add_left_cancel hcol0)

omit [Fintype A] [DecidableEq A] [NeZero (2 * t)] in
/-- The rook-collinearity predicate is downward closed. -/
theorem rookColl_down {L L' : Finset (A × ZMod (2 * t))}
    (hsub : L ⊆ L') (h : rookColl L') : rookColl L := by
  rcases h with ⟨i, hi⟩ | ⟨j, hj⟩
  · exact Or.inl ⟨i, fun p hp => hi p (hsub hp)⟩
  · exact Or.inr ⟨j, fun p hp => hj p (hsub hp)⟩

omit [Fintype A] [DecidableEq A] [NeZero (2 * t)] in
/-- The column shift preserves rook-collinearity. -/
theorem rookColl_map (L : Finset (A × ZMod (2 * t))) :
    rookColl (L.map (shift (A := A) (t := t)).toEmbedding) ↔ rookColl L := by
  constructor
  · rintro (⟨i, hi⟩ | ⟨j, hj⟩)
    · refine Or.inl ⟨i, fun p hp => ?_⟩
      have := hi (shift p) (Finset.mem_map.mpr ⟨p, hp, rfl⟩)
      simpa [shift_apply] using this
    · refine Or.inr ⟨j - (t : ZMod (2 * t)), fun p hp => ?_⟩
      have := hj (shift p) (Finset.mem_map.mpr ⟨p, hp, rfl⟩)
      simp only [shift_apply] at this
      rw [eq_sub_iff_add_eq]; exact this
  · rintro (⟨i, hi⟩ | ⟨j, hj⟩)
    · refine Or.inl ⟨i, fun p hp => ?_⟩
      rcases Finset.mem_map.mp hp with ⟨q, hq, rfl⟩
      simpa [shift_apply] using hi q hq
    · refine Or.inr ⟨j + (t : ZMod (2 * t)), fun p hp => ?_⟩
      rcases Finset.mem_map.mp hp with ⟨q, hq, rfl⟩
      simp only [Equiv.coe_toEmbedding, shift_apply]; rw [hj q hq]

omit [Fintype A] [NeZero (2 * t)] in
/-- Near-linearity of the rook grid: two distinct cells force any collinear set
through them to be all-row or all-column, and that carries to `{a,z,w}`. -/
theorem rookColl_linear {a b z w : A × ZMod (2 * t)} (hab : a ≠ b)
    (h1 : rookColl {a, b, z}) (h2 : rookColl {a, b, w}) : rookColl {a, z, w} := by
  have mem_a : a ∈ ({a, b, z} : Finset (A × ZMod (2 * t))) := by simp
  have mem_b : b ∈ ({a, b, z} : Finset (A × ZMod (2 * t))) := by simp
  have mem_z : z ∈ ({a, b, z} : Finset (A × ZMod (2 * t))) := by simp
  have mem_a' : a ∈ ({a, b, w} : Finset (A × ZMod (2 * t))) := by simp
  have mem_b' : b ∈ ({a, b, w} : Finset (A × ZMod (2 * t))) := by simp
  have mem_w' : w ∈ ({a, b, w} : Finset (A × ZMod (2 * t))) := by simp
  by_cases hrow : a.1 = b.1
  · -- rows agree ⇒ columns differ ⇒ both sets are all-column
    have hcol : a.2 ≠ b.2 := fun h => hab (Prod.ext hrow h)
    have hz1 : z.1 = a.1 := by
      rcases h1 with ⟨i, hi⟩ | ⟨j, hj⟩
      · exact (hi z mem_z).trans (hi a mem_a).symm
      · exact absurd ((hj a mem_a).trans (hj b mem_b).symm) hcol
    have hw1 : w.1 = a.1 := by
      rcases h2 with ⟨i, hi⟩ | ⟨j, hj⟩
      · exact (hi w mem_w').trans (hi a mem_a').symm
      · exact absurd ((hj a mem_a').trans (hj b mem_b').symm) hcol
    refine Or.inl ⟨a.1, fun p hp => ?_⟩
    rcases Finset.mem_insert.mp hp with rfl | hp
    · rfl
    rcases Finset.mem_insert.mp hp with rfl | hp
    · exact hz1
    · rw [Finset.mem_singleton] at hp; subst hp; exact hw1
  · -- rows differ ⇒ both sets are all-row (row case is impossible)
    have hz2 : z.2 = a.2 := by
      rcases h1 with ⟨i, hi⟩ | ⟨j, hj⟩
      · exact absurd ((hi a mem_a).trans (hi b mem_b).symm) hrow
      · exact (hj z mem_z).trans (hj a mem_a).symm
    have hw2 : w.2 = a.2 := by
      rcases h2 with ⟨i, hi⟩ | ⟨j, hj⟩
      · exact absurd ((hi a mem_a').trans (hi b mem_b').symm) hrow
      · exact (hj w mem_w').trans (hj a mem_a').symm
    refine Or.inr ⟨a.2, fun p hp => ?_⟩
    rcases Finset.mem_insert.mp hp with rfl | hp
    · rfl
    rcases Finset.mem_insert.mp hp with rfl | hp
    · exact hz2
    · rw [Finset.mem_singleton] at hp; subst hp; exact hw2

/--
The capacity-2 rook-lines game on `A × ZMod (2t)` is a P-position: the
column-shift mirror `(i,j) ↦ (i, j+t)` is a fixed-point-free rook-collinearity-
preserving involution.
-/
theorem gridRook_isP (ht : 0 < t) :
    IsP (CapCValid (rookColl (A := A) (t := t)) 2)
      (∅ : Finset (A × ZMod (2 * t))) :=
  initialCapC2P_of_nearLinear_mirror (shift (A := A) (t := t))
    shift_involutive (shift_fixed ht) rookColl_down rookColl_map rookColl_linear

end GridRook
