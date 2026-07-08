import ProjectiveCap.ConicLocalization

/-!
# Intrusion calculus: the free conic and the bare-counter theorem

Game-theoretic layer of the intrusion calculus
(`notes/2026-07-07-onconic-intrusion-calculus.md`).  While the played set stays
on a fixed hyperbola, every unplayed hyperbola cell is a legal move (Lemma II,
"the free conic").  Consequently, if no off-conic cell is ever legal above a
position, the residual game is a bare move counter: the game value is the
parity of the unplayed conic cells.

Composed with the geometric no-intrusion kernel
(`NoIntrusionAboveFourStatement` — Theorem IV's finite-geometry input, true
for `q = 5, 7` by the tangency bound, false from `q = 11` on), this proves the
on-conic escape statement, hence the full plane outcome, for those `q`.
-/

namespace ProjectiveCap
namespace ConicLocalization

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

/-- Free conic (Lemma II): as long as the played set stays on a hyperbola,
every unplayed hyperbola cell is a legal move. -/
theorem freeConic_mem_legalExtensions
    {rho A B : K} (hB : B ≠ 0) {S : Finset (GridPoint K)}
    (hS : S ⊆ HyperbolaCells (K := K) rho A B)
    {x : GridPoint K} (hx : x ∈ HyperbolaCells (K := K) rho A B) (hxS : x ∉ S) :
    x ∈ GridGame.LegalExtensions (K := K) S := by
  rw [GridGame.mem_legalExtensions]
  exact ⟨hxS, gridCap_mono (Finset.insert_subset hx hS)
    (gridCap_hyperbolaCells (K := K) hB)⟩

/-- No intruder is ever legal above `S`: every legal move from every
intermediate on-conic position lies on the conic. -/
def ConicOnlyAbove (rho A B : K) (S : Finset (GridPoint K)) : Prop :=
  ∀ T : Finset (GridPoint K), S ⊆ T ->
    T ⊆ HyperbolaCells (K := K) rho A B ->
    ∀ x : GridPoint K, x ∈ GridGame.LegalExtensions (K := K) T ->
      x ∈ HyperbolaCells (K := K) rho A B

/-- Under the no-intrusion hypothesis the legal moves from an on-conic
position are exactly the unplayed conic cells. -/
theorem legalExtensions_eq_sdiff_of_conicOnlyAbove
    {rho A B : K} (hB : B ≠ 0) {S T : Finset (GridPoint K)}
    (honly : ConicOnlyAbove (K := K) rho A B S)
    (hST : S ⊆ T) (hT : T ⊆ HyperbolaCells (K := K) rho A B) :
    GridGame.LegalExtensions (K := K) T =
      HyperbolaCells (K := K) rho A B \ T := by
  ext x
  rw [Finset.mem_sdiff]
  constructor
  · intro hx
    exact ⟨honly T hST hT x hx, (GridGame.mem_legalExtensions.mp hx).1⟩
  · rintro ⟨hxC, hxT⟩
    exact freeConic_mem_legalExtensions (K := K) hB hT hxC hxT

/-- The bare-counter theorem: with no intrusion available above `S`, the game
value of any on-conic position is the parity of its unplayed conic cells. -/
theorem isP_iff_even_card_sdiff_of_conicOnlyAbove
    {rho A B : K} (hB : B ≠ 0) {S : Finset (GridPoint K)}
    (honly : ConicOnlyAbove (K := K) rho A B S)
    (hS : S ⊆ HyperbolaCells (K := K) rho A B) :
    (GridGame.IsP (K := K) S ↔
      Even ((HyperbolaCells (K := K) rho A B \ S).card)) := by
  suffices h : ∀ n : ℕ, ∀ T : Finset (GridPoint K), S ⊆ T ->
      T ⊆ HyperbolaCells (K := K) rho A B ->
      (HyperbolaCells (K := K) rho A B \ T).card = n ->
      (GridGame.IsP (K := K) T ↔ Even n) by
    exact h _ S subset_rfl hS rfl
  intro n
  induction n using Nat.strong_induction_on with
  | _ n ih =>
    intro T hST hTC hcard
    have hlegal :=
      legalExtensions_eq_sdiff_of_conicOnlyAbove (K := K) hB honly hST hTC
    by_cases hn : n = 0
    · subst hn
      have hempty : HyperbolaCells (K := K) rho A B \ T = ∅ :=
        Finset.card_eq_zero.mp hcard
      have hnomove : ∀ x : GridPoint K, ¬ GridGame.Move (K := K) T x := by
        intro x hx
        have hmem : x ∈ GridGame.LegalExtensions (K := K) T :=
          GridGame.mem_legalExtensions.mpr ⟨hx.1, hx.2⟩
        rw [hlegal, hempty] at hmem
        exact absurd hmem (Finset.notMem_empty x)
      exact ⟨fun _ => ⟨0, by omega⟩,
        fun _ => FiniteBuildGame.isP_of_no_moves hnomove⟩
    · have hnpos : 0 < n := Nat.pos_of_ne_zero hn
      have hchild : ∀ x : GridPoint K,
          x ∈ HyperbolaCells (K := K) rho A B \ T ->
            (GridGame.IsP (K := K) (insert x T) ↔ Even (n - 1)) := by
        intro x hx
        rcases Finset.mem_sdiff.mp hx with ⟨hxC, hxT⟩
        refine ih (n - 1) (by omega) (insert x T)
          (hST.trans (Finset.subset_insert x T))
          (Finset.insert_subset hxC hTC) ?_
        have hsd : HyperbolaCells (K := K) rho A B \ insert x T =
            (HyperbolaCells (K := K) rho A B \ T).erase x := by
          ext y
          simp only [Finset.mem_sdiff, Finset.mem_erase, Finset.mem_insert,
            not_or]
          tauto
        rw [hsd, Finset.card_erase_of_mem hx, hcard]
      constructor
      · intro hP
        obtain ⟨x, hx⟩ := Finset.card_pos.mp (hcard ▸ hnpos)
        have hxmove : GridGame.Move (K := K) T x := by
          have hmem : x ∈ GridGame.LegalExtensions (K := K) T := by
            rw [hlegal]; exact hx
          exact GridGame.mem_legalExtensions.mp hmem
        have hxWin := (GridGame.isP_iff_all_children_win.mp hP) x hxmove
        have hxNotP : ¬ GridGame.IsP (K := K) (insert x T) := fun h => h hxWin
        have hnotEven : ¬ Even (n - 1) := fun h =>
          hxNotP ((hchild x hx).mpr h)
        rcases Nat.even_or_odd n with he | ho
        · exact he
        · obtain ⟨k, hk⟩ := ho
          exact absurd ⟨k, by omega⟩ hnotEven
      · intro hEven
        rw [GridGame.isP_iff_all_children_win]
        intro x hxmove
        have hxmem : x ∈ HyperbolaCells (K := K) rho A B \ T := by
          rw [← hlegal]
          exact GridGame.mem_legalExtensions.mpr ⟨hxmove.1, hxmove.2⟩
        have hnotEven : ¬ Even (n - 1) := by
          obtain ⟨k, hk⟩ := hEven
          rintro ⟨m, hm⟩
          omega
        have hxNotP : ¬ GridGame.IsP (K := K) (insert x T) := fun h =>
          hnotEven ((hchild x hxmem).mp h)
        exact of_not_not hxNotP

/-- No-intrusion propagates upward: if every legal extension of `S` itself
lies on the conic, the same holds above every intermediate on-conic `T`,
because legality is antitone in the position.  This collapses the
no-intrusion obligation to the size-four seed alone. -/
theorem conicOnlyAbove_of_forall_legal_mem
    {rho A B : K} {S : Finset (GridPoint K)}
    (h : ∀ x : GridPoint K, x ∈ GridGame.LegalExtensions (K := K) S ->
      x ∈ HyperbolaCells (K := K) rho A B) :
    ConicOnlyAbove (K := K) rho A B S := by
  intro T hST _hTC x hx
  rw [GridGame.mem_legalExtensions] at hx
  refine h x ?_
  rw [GridGame.mem_legalExtensions]
  exact ⟨fun hxS => hx.1 (hST hxS),
    gridCap_mono (Finset.insert_subset_insert x hST) hx.2⟩

/--
Geometric no-intrusion kernel: above every on-conic size-four position, no
off-conic cell is ever legal.  This is Theorem IV's finite-geometry input
(the tangency-count bound, Lemma III(4) of the intrusion note).

WARNING (route status): per-`q` target only — PROVEN below for `q = 5`
(`noIntrusionAboveFourStatement_of_card_eq_five`) and `q = 7`
(`noIntrusionAboveFourStatement_of_card_eq_seven`), FALSE from `q = 11` on:
legal intruders exist in the intrusion census
(`notes/2026-07-07-onconic-intrusion-calculus.md` §7).  Do not proof-search
the universal statement.
-/
def NoIntrusionAboveFourStatement : Prop :=
  ∀ rho A B : K, B ≠ 0 ->
    ∀ S : Finset (GridPoint K), S.card = 4 ->
      S ⊆ HyperbolaCells (K := K) rho A B ->
      ConicOnlyAbove (K := K) rho A B S

/-- With no intrusion available, every on-conic size-four position of an odd
plane is a bare counter of even length, hence a P-position. -/
theorem isP_of_card_four_of_conicOnlyAbove
    (hq : Odd (Fintype.card K))
    {rho A B : K} (hB : B ≠ 0) {S : Finset (GridPoint K)}
    (hcard : S.card = 4) (hS : S ⊆ HyperbolaCells (K := K) rho A B)
    (honly : ConicOnlyAbove (K := K) rho A B S) :
    GridGame.IsP (K := K) S := by
  rw [isP_iff_even_card_sdiff_of_conicOnlyAbove (K := K) hB honly hS,
    Finset.card_sdiff_of_subset hS, card_hyperbolaCells (K := K) hB, hcard]
  obtain ⟨k, hk⟩ := hq
  exact ⟨k - 2, by omega⟩

/-- A field of odd cardinality has `2 ≠ 0`: the shift `x ↦ x + 1` would
otherwise be a fixed-point-free involution pairing up the whole field. -/
theorem two_ne_zero_of_odd_card (hq : Odd (Fintype.card K)) : (2 : K) ≠ 0 := by
  intro h2
  have heven : Even (Finset.univ : Finset K).card :=
    even_card_of_involutive_fpf_on_finset (Finset.univ : Finset K)
      (fun x => x + 1)
      (fun x _ => Finset.mem_univ _)
      (fun x _ => by rw [add_assoc, one_add_one_eq_two, h2, add_zero])
      (fun x _ hfix => by
        have h0 : x + 1 = x + 0 := by rw [add_zero]; exact hfix
        exact one_ne_zero (add_left_cancel h0))
  rw [Finset.card_univ] at heven
  exact (Nat.not_even_iff_odd.mpr hq) heven

/--
**The order-five no-intrusion kernel (Theorem IV, `q = 5` case).**  Over a
field of cardinality five the conic has `q − 1 = 4` affine cells, so an
on-conic size-four position IS the whole affine conic — which is a maximal
grid cap in odd characteristic.  No intruder is ever legal, with no case
analysis at all.
-/
theorem noIntrusionAboveFourStatement_of_card_eq_five
    (hcard : Fintype.card K = 5) :
    NoIntrusionAboveFourStatement (K := K) := by
  intro rho A B hB S hS4 hSsub T hST hTC x hx
  exfalso
  have h2 : (2 : K) ≠ 0 :=
    two_ne_zero_of_odd_card (K := K) (by rw [hcard]; exact ⟨2, rfl⟩)
  have hCcard : (HyperbolaCells (K := K) rho A B).card = 4 := by
    rw [card_hyperbolaCells (K := K) hB, hcard]
  have hSC : S = HyperbolaCells (K := K) rho A B :=
    Finset.eq_of_subset_of_card_le hSsub (le_of_eq (hCcard.trans hS4.symm))
  have hTeq : T = HyperbolaCells (K := K) rho A B :=
    subset_antisymm hTC (hSC ▸ hST)
  rw [GridGame.mem_legalExtensions, hTeq] at hx
  exact (maximalGridCap_hyperbolaCells_of_two_ne_zero (K := K) h2 hB).2
    x hx.1 hx.2

/-! ## The order-seven kernel: the secant involution `σ_x`

For a legal off-conic intruder `x = (rho + u, A + v)` of an on-conic position,
the map `σ(t) = B(t − u) / (tv − B)` sends a conic parameter `t` to the
parameter of the second intersection of line `x p_t` with the conic.  Row,
column, and cap legality force `σ` to map every played parameter either to
itself or OUT of the played/blocked set; `σ` is injective; and its fixed
points satisfy the quadratic `vt² − 2Bt + Bu = 0`.  Over `GF(7)` the played
set leaves only one free landing value, so at least three played parameters
would be fixed points — contradiction.  This is Lemma III(4) of the intrusion
note specialized to `q = 7`, done entirely by field algebra. -/

omit [Fintype K] [DecidableEq K] in
/-- The secant criterion: a cell `(rho + u, A + v)` is collinear with the two
conic cells at parameters `s ≠ t` exactly when `Bu + stv = B(s + t)`; this is
the sufficiency direction. -/
theorem collinear_hyperbolaParamPoint_of_secant
    {rho A B s t u v : K} (hs : s ≠ 0) (ht : t ≠ 0) (_hst : s ≠ t)
    (hsec : B * u + s * t * v = B * (s + t)) :
    Collinear (K := K) (hyperbolaParamPoint rho A B s)
      (hyperbolaParamPoint rho A B t) (rho + u, A + v) := by
  unfold Collinear hyperbolaParamPoint
  field_simp
  linear_combination t * hsec - s * hsec

/--
**The order-seven no-intrusion kernel (Theorem IV, `q = 7` case).**  Over a
field of cardinality seven, no off-conic cell is ever a legal extension of an
on-conic size-four position: the secant involution of a putative intruder
would need at least three fixed points among the played parameters, but its
fixed-point equation is a nondegenerate quadratic.
-/
theorem offConic_not_legal_of_card_eq_seven
    (hcard : Fintype.card K = 7)
    {rho A B : K} (hB : B ≠ 0) {S : Finset (GridPoint K)}
    (hS4 : S.card = 4) (hSsub : S ⊆ HyperbolaCells (K := K) rho A B)
    {x : GridPoint K} (hx : x ∈ GridGame.LegalExtensions (K := K) S) :
    x ∈ HyperbolaCells (K := K) rho A B := by
  by_contra hxC
  have h2 : (2 : K) ≠ 0 :=
    two_ne_zero_of_odd_card (K := K) (by rw [hcard]; exact ⟨3, rfl⟩)
  rw [GridGame.mem_legalExtensions] at hx
  obtain ⟨hxS, hcap⟩ := hx
  obtain ⟨⟨hrow, hcol⟩, haff⟩ := hcap
  set u : K := x.1 - rho with hu
  set v : K := x.2 - A with hv
  have hx1 : x.1 = rho + u := by rw [hu]; ring
  have hx2 : x.2 = A + v := by rw [hv]; ring
  have hxpair : x = (rho + u, A + v) := by
    rw [← hx1, ← hx2]
  have hUV : u * v ≠ B := by
    intro h
    exact hxC (mem_hyperbolaCells.mpr h)
  -- the played parameter set
  set T : Finset K := S.image (fun p => p.1 - rho) with hT
  have hcell : ∀ t ∈ T, t ≠ 0 ∧ hyperbolaParamPoint rho A B t ∈ S := by
    intro t htT
    obtain ⟨p, hp, rfl⟩ := Finset.mem_image.mp htT
    have hpOn := mem_hyperbolaCells.mp (hSsub hp)
    refine ⟨?_, ?_⟩
    · intro hz
      exact onHyperbola_first_ne_rho (K := K) hB hpOn (sub_eq_zero.mp hz)
    · rw [← onHyperbola_eq_hyperbolaParamPoint (K := K) hB hpOn]
      exact hp
  have hTcard : T.card = 4 := by
    rw [hT, Finset.card_image_of_injOn, hS4]
    intro p hp q hq hpq
    exact rowSparse_hyperbolaCells (K := K) hB (hSsub hp) (hSsub hq)
      (sub_left_inj.mp hpq)
  -- row constraint: no played parameter equals u
  have c_row : ∀ t ∈ T, t ≠ u := by
    intro t htT htu
    have hptS := (hcell t htT).2
    have : hyperbolaParamPoint rho A B t = x := by
      refine hrow (Finset.mem_insert_of_mem hptS) (Finset.mem_insert_self x _) ?_
      rw [hxpair]
      show rho + t = rho + u
      rw [htu]
    exact hxS (this ▸ hptS)
  -- column constraint: no played parameter has tv = B
  have c_col : ∀ t ∈ T, t * v ≠ B := by
    intro t htT htv
    have ht0 := (hcell t htT).1
    have hptS := (hcell t htT).2
    have : hyperbolaParamPoint rho A B t = x := by
      refine hcol (Finset.mem_insert_of_mem hptS) (Finset.mem_insert_self x _) ?_
      rw [hxpair]
      show A + B / t = A + v
      have hbv : B / t = v := by
        rw [div_eq_iff ht0, ← htv]; ring
      rw [hbv]
    exact hxS (this ▸ hptS)
  have hden : ∀ t ∈ T, t * v - B ≠ 0 := fun t htT =>
    sub_ne_zero.mpr (c_col t htT)
  -- secant constraint: no line through x meets two played parameters
  have c_sec : ∀ s ∈ T, ∀ t ∈ T, s ≠ t ->
      B * u + s * t * v ≠ B * (s + t) := by
    intro s hsT t htT hst hsec
    have hs0 := (hcell s hsT).1
    have ht0 := (hcell t htT).1
    have hpsS := (hcell s hsT).2
    have hptS := (hcell t htT).2
    have hpspt : hyperbolaParamPoint rho A B s ≠ hyperbolaParamPoint rho A B t :=
      (hyperbolaParamPoint_injective (K := K) rho A B).ne hst
    have hpsx : hyperbolaParamPoint rho A B s ≠ x := fun h => hxS (h ▸ hpsS)
    have hptx : hyperbolaParamPoint rho A B t ≠ x := fun h => hxS (h ▸ hptS)
    refine haff (Finset.mem_insert_of_mem hpsS) (Finset.mem_insert_of_mem hptS)
      (Finset.mem_insert_self x _) hpspt hpsx hptx ?_
    rw [hxpair]
    exact collinear_hyperbolaParamPoint_of_secant (K := K) hs0 ht0 hst hsec
  -- the secant involution and its constraints on played parameters
  have hσ_ne_zero : ∀ t ∈ T, B * (t - u) / (t * v - B) ≠ 0 := by
    intro t htT
    exact div_ne_zero
      (mul_ne_zero hB (sub_ne_zero.mpr (c_row t htT))) (hden t htT)
  have hσ_ne_mem : ∀ t ∈ T, ∀ s ∈ T, s ≠ t ->
      B * (t - u) / (t * v - B) ≠ s := by
    intro t htT s hsT hst h
    rw [div_eq_iff (hden t htT)] at h
    exact c_sec s hsT t htT hst (by linear_combination -h)
  have hσ_inj : ∀ s ∈ T, ∀ t ∈ T,
      B * (s - u) / (s * v - B) = B * (t - u) / (t * v - B) -> s = t := by
    intro s hsT t htT h
    rw [div_eq_div_iff (hden s hsT) (hden t htT)] at h
    have hz : (t - s) * (B * (B - u * v)) = 0 := by linear_combination h
    rcases mul_eq_zero.mp hz with h0 | h0
    · exact (sub_eq_zero.mp h0).symm
    · rcases mul_eq_zero.mp h0 with h1 | h1
      · exact absurd h1 hB
      · exact absurd (sub_eq_zero.mp h1).symm hUV
  -- fixed points of the involution satisfy the quadratic
  have hfix : ∀ t ∈ T, B * (t - u) / (t * v - B) = t ->
      B * (t - u) = t * (t * v - B) := by
    intro t htT h
    exact (div_eq_iff (hden t htT)).mp h
  -- the non-fixed played parameters and their landing zone
  set N : Finset K :=
    T.filter (fun t => ¬ B * (t - u) / (t * v - B) = t) with hN
  set F : Finset K :=
    T.filter (fun t => B * (t - u) / (t * v - B) = t) with hF
  have hFN : F.card + N.card = 4 := by
    rw [hF, hN, ← hTcard]
    exact Finset.card_filter_add_card_filter_not (s := T) _
  have hKstar : ((Finset.univ : Finset K).erase 0).card = 6 := by
    rw [Finset.card_erase_of_mem (Finset.mem_univ 0), Finset.card_univ, hcard]
  -- count the landing zone in the two column-geometry cases
  rcases eq_or_ne v 0 with hv0 | hvne
  · -- x in the conic's center row: σ is affine, one fixed point
    have hmaps : ∀ t ∈ N, B * (t - u) / (t * v - B) ∈
        ((Finset.univ : Finset K).erase 0) \ T := by
      intro t htN
      obtain ⟨htT, htnf⟩ := Finset.mem_filter.mp htN
      refine Finset.mem_sdiff.mpr
        ⟨Finset.mem_erase.mpr ⟨hσ_ne_zero t htT, Finset.mem_univ _⟩, ?_⟩
      intro hσT
      rcases eq_or_ne (B * (t - u) / (t * v - B)) t with heq | hne
      · exact htnf heq
      · exact hσ_ne_mem t htT _ hσT hne rfl
    have hNle : N.card ≤ 2 := by
      have hsub : T ⊆ (Finset.univ : Finset K).erase 0 := by
        intro t htT
        exact Finset.mem_erase.mpr ⟨(hcell t htT).1, Finset.mem_univ _⟩
      have hcards : (((Finset.univ : Finset K).erase 0) \ T).card = 2 := by
        rw [Finset.card_sdiff_of_subset hsub, hKstar, hTcard]
      calc N.card ≤ (((Finset.univ : Finset K).erase 0) \ T).card :=
            Finset.card_le_card_of_injOn _ hmaps (fun s hs t ht h =>
              hσ_inj s (Finset.mem_filter.mp hs).1 t (Finset.mem_filter.mp ht).1 h)
        _ = 2 := hcards
    have hF2 : 1 < F.card := by omega
    obtain ⟨t₁, ht₁, t₂, ht₂, h12⟩ := Finset.one_lt_card.mp hF2
    have e₁ := hfix t₁ (Finset.mem_filter.mp ht₁).1 (Finset.mem_filter.mp ht₁).2
    have e₂ := hfix t₂ (Finset.mem_filter.mp ht₂).1 (Finset.mem_filter.mp ht₂).2
    rw [hv0] at e₁ e₂
    have hz : (t₁ - t₂) * (2 * B) = 0 := by linear_combination e₁ - e₂
    rcases mul_eq_zero.mp hz with h0 | h0
    · exact h12 (sub_eq_zero.mp h0)
    · exact mul_ne_zero h2 hB h0
  · -- generic x: the blocked set has five elements, forcing three fixed points
    have hBv0 : B / v ≠ 0 := div_ne_zero hB hvne
    have hBvT : B / v ∉ T := by
      intro hmem
      exact c_col _ hmem (by rw [div_mul_cancel₀ _ hvne])
    have hσ_ne_Bv : ∀ t ∈ T, B * (t - u) / (t * v - B) ≠ B / v := by
      intro t htT h
      rw [div_eq_div_iff (hden t htT) hvne] at h
      have hz : B * (u * v - B) = 0 := by linear_combination -h
      rcases mul_eq_zero.mp hz with h0 | h0
      · exact hB h0
      · exact hUV (sub_eq_zero.mp h0)
    have hmaps : ∀ t ∈ N, B * (t - u) / (t * v - B) ∈
        ((Finset.univ : Finset K).erase 0) \ insert (B / v) T := by
      intro t htN
      obtain ⟨htT, htnf⟩ := Finset.mem_filter.mp htN
      refine Finset.mem_sdiff.mpr
        ⟨Finset.mem_erase.mpr ⟨hσ_ne_zero t htT, Finset.mem_univ _⟩, ?_⟩
      intro hmem
      rcases Finset.mem_insert.mp hmem with heq | hσT
      · exact hσ_ne_Bv t htT heq
      · rcases eq_or_ne (B * (t - u) / (t * v - B)) t with heq | hne
        · exact htnf heq
        · exact hσ_ne_mem t htT _ hσT hne rfl
    have hNle : N.card ≤ 1 := by
      have hsub : insert (B / v) T ⊆ (Finset.univ : Finset K).erase 0 := by
        intro t htT
        rcases Finset.mem_insert.mp htT with rfl | hmem
        · exact Finset.mem_erase.mpr ⟨hBv0, Finset.mem_univ _⟩
        · exact Finset.mem_erase.mpr ⟨(hcell t hmem).1, Finset.mem_univ _⟩
      have hcards :
          (((Finset.univ : Finset K).erase 0) \ insert (B / v) T).card = 1 := by
        rw [Finset.card_sdiff_of_subset hsub, hKstar,
          Finset.card_insert_of_notMem hBvT, hTcard]
      calc N.card
          ≤ (((Finset.univ : Finset K).erase 0) \ insert (B / v) T).card :=
            Finset.card_le_card_of_injOn _ hmaps (fun s hs t ht h =>
              hσ_inj s (Finset.mem_filter.mp hs).1 t (Finset.mem_filter.mp ht).1 h)
        _ = 1 := hcards
    have hF3 : 2 < F.card := by omega
    obtain ⟨t₁, t₂, t₃, ht₁, ht₂, ht₃, h12, h13, h23⟩ :=
      Finset.two_lt_card_iff.mp hF3
    have e₁ := hfix t₁ (Finset.mem_filter.mp ht₁).1 (Finset.mem_filter.mp ht₁).2
    have e₂ := hfix t₂ (Finset.mem_filter.mp ht₂).1 (Finset.mem_filter.mp ht₂).2
    have e₃ := hfix t₃ (Finset.mem_filter.mp ht₃).1 (Finset.mem_filter.mp ht₃).2
    have h12' : (t₁ - t₂) * (v * (t₁ + t₂) - 2 * B) = 0 := by
      linear_combination e₂ - e₁
    have h13' : (t₁ - t₃) * (v * (t₁ + t₃) - 2 * B) = 0 := by
      linear_combination e₃ - e₁
    have hq12 : v * (t₁ + t₂) - 2 * B = 0 := by
      rcases mul_eq_zero.mp h12' with h0 | h0
      · exact absurd (sub_eq_zero.mp h0) h12
      · exact h0
    have hq13 : v * (t₁ + t₃) - 2 * B = 0 := by
      rcases mul_eq_zero.mp h13' with h0 | h0
      · exact absurd (sub_eq_zero.mp h0) h13
      · exact h0
    have hz : v * (t₂ - t₃) = 0 := by linear_combination hq12 - hq13
    rcases mul_eq_zero.mp hz with h0 | h0
    · exact hvne h0
    · exact h23 (sub_eq_zero.mp h0)

/--
**The order-seven no-intrusion kernel, packaged.**  Combined with the
antitone reduction, the size-four statement gives the full
`NoIntrusionAboveFourStatement` over any field of cardinality seven.
-/
theorem noIntrusionAboveFourStatement_of_card_eq_seven
    (hcard : Fintype.card K = 7) :
    NoIntrusionAboveFourStatement (K := K) := by
  intro rho A B hB S hS4 hSsub
  exact conicOnlyAbove_of_forall_legal_mem (K := K)
    (fun x hx => offConic_not_legal_of_card_eq_seven (K := K)
      hcard hB hS4 hSsub hx)

/-- Theorem IV, game half: the per-`q` no-intrusion kernel yields the on-conic
escape statement for odd `q` — every size-three seed's conic completions are
all escapes. -/
theorem onConicEscapeStatement_of_noIntrusionAboveFour
    (hq : Odd (Fintype.card K))
    (hno : NoIntrusionAboveFourStatement (K := K)) :
    OnConicEscapeStatement (K := K) := by
  intro S hcard hS
  obtain ⟨rho, A, B, hB, hfit⟩ :=
    exists_hyperbolaNormalForm (K := K) hcard hS
  have hSsub : S ⊆ HyperbolaCells (K := K) rho A B := fun p hp =>
    mem_hyperbolaCells.mpr (hfit p hp)
  have hcards : S.card ≤ (HyperbolaCells (K := K) rho A B).card :=
    Finset.card_le_card hSsub
  have hq5 : 5 ≤ Fintype.card K := by
    rw [card_hyperbolaCells (K := K) hB, hcard] at hcards
    obtain ⟨k, hk⟩ := hq
    omega
  have hpos : 0 < (HyperbolaCells (K := K) rho A B \ S).card := by
    rw [Finset.card_sdiff_of_subset hSsub, card_hyperbolaCells (K := K) hB, hcard]
    omega
  obtain ⟨p, hp⟩ := Finset.card_pos.mp hpos
  rcases Finset.mem_sdiff.mp hp with ⟨hpC, hpS⟩
  have hS4card : (insert p S).card = 4 := by
    rw [Finset.card_insert_of_notMem hpS, hcard]
  have hS4sub : insert p S ⊆ HyperbolaCells (K := K) rho A B :=
    Finset.insert_subset hpC hSsub
  have hP : GridGame.IsP (K := K) (insert p S) :=
    isP_of_card_four_of_conicOnlyAbove (K := K) hq hB hS4card hS4sub
      (hno rho A B hB (insert p S) hS4card hS4sub)
  have hpLegal : p ∈ GridGame.LegalExtensions (K := K) S :=
    freeConic_mem_legalExtensions (K := K) hB hSsub hpC hpS
  exact ⟨rho, A, B, p, hB, hfit,
    mem_onConicLegalExtensions.mpr ⟨mem_hyperbolaCells.mp hpC, hpLegal⟩, hP⟩

end ConicLocalization
end ProjectiveCap
