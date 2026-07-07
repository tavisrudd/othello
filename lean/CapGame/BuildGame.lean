import Mathlib.Data.Finset.Basic
import Mathlib.Tactic

/-!
# Finite normal-play building games

This is a small reusable kernel for games where a position is a finite set of
chosen objects and a move adds one fresh object while preserving a validity
predicate.  The cap achievement games are instances with `Valid = Cap`.
-/

namespace FiniteBuildGame

variable {α : Type*} [Fintype α] [DecidableEq α]

/-- A legal move adds a fresh element and leaves a valid position. -/
def Move (Valid : Finset α -> Prop) (S : Finset α) (x : α) : Prop :=
  x ∉ S ∧ Valid (insert x S)

/-- All legal one-point extensions of a position. -/
noncomputable def LegalExtensions (Valid : Finset α -> Prop) (S : Finset α) : Finset α := by
  classical
  exact Finset.univ.filter (fun x => Move Valid S x)

theorem mem_legalExtensions {Valid : Finset α -> Prop} {S : Finset α} {x : α} :
    x ∈ LegalExtensions Valid S ↔ Move Valid S x := by
  classical
  simp [LegalExtensions]

omit [DecidableEq α] in
private theorem card_lt_univ_of_notMem {S : Finset α} {x : α} (hx : x ∉ S) :
    S.card < Fintype.card α := by
  have hsubset : S ⊆ (Finset.univ : Finset α) := by
    intro y _; exact Finset.mem_univ y
  have hproper : S ⊂ (Finset.univ : Finset α) :=
    (Finset.ssubset_iff_of_subset hsubset).mpr ⟨x, Finset.mem_univ x, hx⟩
  simpa using Finset.card_lt_card hproper

/--
Normal-play win predicate for a finite building game.

The player to move wins from `S` iff there is a legal extension whose child is
losing for the next player.
-/
def Win (Valid : Finset α -> Prop) (S : Finset α) : Prop :=
  ∃ x : LegalExtensions Valid S, ¬ Win Valid (insert (x : α) S)
termination_by Fintype.card α - S.card
decreasing_by
  classical
  have hxmove : Move Valid S (x : α) := mem_legalExtensions.mp x.2
  have hx : (x : α) ∉ S := hxmove.1
  have hcard : (insert (x : α) S).card = S.card + 1 :=
    Finset.card_insert_of_notMem hx
  have hlt : S.card < Fintype.card α := card_lt_univ_of_notMem hx
  rw [hcard]
  omega

/-- A P-position is a position from which the next player has no winning move. -/
def IsP (Valid : Finset α -> Prop) (S : Finset α) : Prop :=
  ¬ Win Valid S

theorem win_iff_exists_move {Valid : Finset α -> Prop} {S : Finset α} :
    Win Valid S ↔ ∃ x : α, Move Valid S x ∧ ¬ Win Valid (insert x S) := by
  rw [Win.eq_def]
  constructor
  · rintro ⟨x, hxlose⟩
    exact ⟨x, mem_legalExtensions.mp x.2, hxlose⟩
  · rintro ⟨x, hxmove, hxlose⟩
    exact ⟨⟨x, mem_legalExtensions.mpr hxmove⟩, hxlose⟩

/-- The empty game is P if there are no legal first moves. -/
theorem isP_of_no_moves {Valid : Finset α -> Prop} {S : Finset α}
    (h : ∀ x : α, ¬ Move Valid S x) : IsP Valid S := by
  rw [IsP, win_iff_exists_move]
  rintro ⟨x, hx, _⟩
  exact h x hx

/-- A single certified move to a P-position proves an N-position. -/
theorem win_of_move_to_isP {Valid : Finset α -> Prop} {S : Finset α} {x : α}
    (hx : Move Valid S x) (hchild : IsP Valid (insert x S)) : Win Valid S := by
  rw [win_iff_exists_move]
  exact ⟨x, hx, hchild⟩

/-- N-position iff there is a legal move to a P-position. -/
theorem win_iff_exists_isP_child {Valid : Finset α -> Prop} {S : Finset α} :
    Win Valid S ↔ ∃ x : α, Move Valid S x ∧ IsP Valid (insert x S) := by
  rw [win_iff_exists_move]
  rfl

/-- P-position iff every legal child is an N-position. -/
theorem isP_iff_all_children_win {Valid : Finset α -> Prop} {S : Finset α} :
    IsP Valid S ↔ ∀ x : α, Move Valid S x -> Win Valid (insert x S) := by
  constructor
  · intro hP x hxmove
    by_contra hchild
    exact hP (win_of_move_to_isP hxmove hchild)
  · intro hall hwin
    rcases win_iff_exists_isP_child.mp hwin with ⟨x, hxmove, hxP⟩
    exact hxP (hall x hxmove)

/--
A one-position P-certificate: every legal move has a legal reply to a
P-grandchild.
-/
def PairReplyBook (Valid : Finset α -> Prop) (S : Finset α) : Prop :=
  ∀ x : α, Move Valid S x ->
    ∃ y : α, Move Valid (insert x S) y ∧ IsP Valid (insert y (insert x S))

/-- A one-position reply book proves that the current position is P. -/
theorem isP_of_pairReplyBook {Valid : Finset α -> Prop} {S : Finset α}
    (hbook : PairReplyBook Valid S) : IsP Valid S := by
  rw [isP_iff_all_children_win]
  intro x hxmove
  rcases hbook x hxmove with ⟨y, hymove, hyP⟩
  exact win_of_move_to_isP hymove hyP

/-- Reusable N-certificate: one legal move to a P-position. -/
structure NCert (Valid : Finset α -> Prop) (S : Finset α) where
  move : α
  legal : Move Valid S move
  childP : IsP Valid (insert move S)

/-- Reusable P-certificate: a reply book from the current position. -/
structure PCert (Valid : Finset α -> Prop) (S : Finset α) where
  reply : PairReplyBook Valid S

/-- P-certificates are sound. -/
theorem pcert_sound {Valid : Finset α -> Prop} {S : Finset α}
    (c : PCert Valid S) : IsP Valid S :=
  isP_of_pairReplyBook c.reply

/-- N-certificates are sound. -/
theorem ncert_sound {Valid : Finset α -> Prop} {S : Finset α}
    (c : NCert Valid S) : Win Valid S :=
  win_of_move_to_isP c.legal c.childP

/--
A reusable second-player strategy criterion.

If every move from a `Good` position has a legal reply that returns to a
`Good` position, then every `Good` position is a P-position.
-/
theorem isP_of_replyStrategy {Valid : Finset α -> Prop} {Good : Finset α -> Prop}
    (hstep : ∀ {S : Finset α}, Good S -> ∀ x : α, Move Valid S x ->
      ∃ y : α, Move Valid (insert x S) y ∧ Good (insert y (insert x S)))
    (S : Finset α) (hgood : Good S) : IsP Valid S := by
  rw [IsP, win_iff_exists_move]
  rintro ⟨x, hxmove, hxlose⟩
  rcases hstep hgood x hxmove with ⟨y, hymove, hnext⟩
  apply hxlose
  exact win_of_move_to_isP hymove
    (isP_of_replyStrategy (Valid := Valid) (Good := Good) hstep _ hnext)
termination_by Fintype.card α - S.card
decreasing_by
  classical
  have hx : x ∉ S := hxmove.1
  have hy : y ∉ insert x S := hymove.1
  have hcardx : (insert x S).card = S.card + 1 := Finset.card_insert_of_notMem hx
  have hcardy : (insert y (insert x S)).card = (insert x S).card + 1 :=
    Finset.card_insert_of_notMem hy
  have hlt : S.card + 1 ≤ Fintype.card α := by
    rw [← hcardx]
    exact Finset.card_le_univ _
  rw [hcardy, hcardx]
  omega

/-! ## Generic Grundy values -/

/-- Minimal excludant of a finite set of natural numbers. -/
noncomputable def mex (T : Finset ℕ) : ℕ :=
  Nat.find (Infinite.exists_notMem_finset T)

/-- The mex is not in the finite set. -/
theorem mex_not_mem (T : Finset ℕ) : mex T ∉ T :=
  Nat.find_spec (Infinite.exists_notMem_finset T)

/-- Every natural below the mex is in the finite set. -/
theorem lt_mex_mem {T : Finset ℕ} {m : ℕ} (h : m < mex T) : m ∈ T := by
  have := Nat.find_min (Infinite.exists_notMem_finset T) h
  simpa using this

/-- The mex is zero exactly when zero is absent. -/
theorem mex_eq_zero_iff {T : Finset ℕ} : mex T = 0 ↔ (0 : ℕ) ∉ T := by
  constructor
  · intro h hmem
    rw [← h] at hmem
    exact mex_not_mem T hmem
  · intro h
    rcases Nat.eq_zero_or_pos (mex T) with h0 | hpos
    · exact h0
    · exact absurd (lt_mex_mem hpos) h

/-- The mex is nonzero exactly when zero is present. -/
theorem mex_ne_zero_iff {T : Finset ℕ} : mex T ≠ 0 ↔ (0 : ℕ) ∈ T := by
  rw [ne_eq, mex_eq_zero_iff, not_not]

/-- Characterize the mex by lower containment and self-exclusion. -/
theorem mex_eq_of {T : Finset ℕ} {n : ℕ}
    (hlt : ∀ c < n, c ∈ T) (hn : n ∉ T) :
    mex T = n := by
  apply le_antisymm
  · exact Nat.find_min' (Infinite.exists_notMem_finset T) hn
  · by_contra h
    push Not at h
    exact mex_not_mem T (hlt _ h)

/-- The mex of `{0}` is `1`. -/
theorem mex_singleton_zero : mex ({0} : Finset ℕ) = 1 := by
  apply mex_eq_of
  · intro c hc
    interval_cases c
    simp
  · simp

/-- Grundy value of a finite normal-play building-game position. -/
noncomputable def Grundy (Valid : Finset α -> Prop) (S : Finset α) : ℕ :=
  mex ((LegalExtensions Valid S).attach.image
    fun x : {x // x ∈ LegalExtensions Valid S} => Grundy Valid (insert (x : α) S))
termination_by Fintype.card α - S.card
decreasing_by
  classical
  have hxmove : Move Valid S x := mem_legalExtensions.mp x.2
  have hx : (x : α) ∉ S := hxmove.1
  have hcard : (insert (x : α) S).card = S.card + 1 :=
    Finset.card_insert_of_notMem hx
  have hlt : S.card < Fintype.card α := card_lt_univ_of_notMem hx
  rw [hcard]
  omega

/-- Normal-play wins are exactly the positions with nonzero Grundy value. -/
theorem win_iff_grundy_ne_zero {Valid : Finset α -> Prop} {S : Finset α} :
    Win Valid S ↔ Grundy Valid S ≠ 0 := by
  rw [Win.eq_def, Grundy.eq_def, mex_ne_zero_iff, Finset.mem_image]
  simp only [Finset.mem_attach, true_and]
  refine exists_congr (fun x => ?_)
  rw [win_iff_grundy_ne_zero (Valid := Valid) (S := insert (x : α) S)]
  exact not_ne_iff
termination_by Fintype.card α - S.card
decreasing_by
  classical
  have hxmove : Move Valid S (x : α) := mem_legalExtensions.mp x.2
  have hx : (x : α) ∉ S := hxmove.1
  have hcard : (insert (x : α) S).card = S.card + 1 :=
    Finset.card_insert_of_notMem hx
  have hlt : S.card < Fintype.card α := card_lt_univ_of_notMem hx
  rw [hcard]
  omega

/-- P-positions are exactly the positions with Grundy value zero. -/
theorem isP_iff_grundy_eq_zero {Valid : Finset α -> Prop} {S : Finset α} :
    IsP Valid S ↔ Grundy Valid S = 0 := by
  rw [IsP, win_iff_grundy_ne_zero]
  exact not_ne_iff

/-! ## Game-value transport along board symmetries -/

omit [Fintype α] in
theorem move_map {Valid : Finset α -> Prop} (e : α ≃ α)
    (hValid : ∀ S : Finset α, Valid (S.map e.toEmbedding) ↔ Valid S)
    {S : Finset α} {x : α} :
    Move Valid (S.map e.toEmbedding) (e x) ↔ Move Valid S x := by
  have hmem : e x ∈ S.map e.toEmbedding ↔ x ∈ S := by
    rw [Finset.mem_map_equiv, Equiv.symm_apply_apply]
  have hins : insert (e x) (S.map e.toEmbedding) = (insert x S).map e.toEmbedding := by
    simp [Finset.map_insert]
  unfold Move
  rw [hins, hValid, hmem]

/-- Normal-play game values are invariant under a validity-preserving
permutation of the board. -/
theorem win_map {Valid : Finset α -> Prop} (e : α ≃ α)
    (hValid : ∀ S : Finset α, Valid (S.map e.toEmbedding) ↔ Valid S)
    (S : Finset α) : Win Valid (S.map e.toEmbedding) ↔ Win Valid S := by
  rw [win_iff_exists_move, win_iff_exists_move]
  constructor
  · rintro ⟨y, hymove, hylose⟩
    have hy : e (e.symm y) = y := e.apply_symm_apply y
    rw [← hy] at hymove hylose
    have hxmove : Move Valid S (e.symm y) := (move_map e hValid).mp hymove
    refine ⟨e.symm y, hxmove, fun hwin => hylose ?_⟩
    have hins : insert (e (e.symm y)) (S.map e.toEmbedding) =
        (insert (e.symm y) S).map e.toEmbedding := by
      simp [Finset.map_insert]
    rw [hins]
    exact (win_map e hValid (insert (e.symm y) S)).mpr hwin
  · rintro ⟨x, hxmove, hxlose⟩
    refine ⟨e x, (move_map e hValid).mpr hxmove, fun hwin => hxlose ?_⟩
    have hins : insert (e x) (S.map e.toEmbedding) =
        (insert x S).map e.toEmbedding := by
      simp [Finset.map_insert]
    rw [hins] at hwin
    exact (win_map e hValid (insert x S)).mp hwin
termination_by Fintype.card α - S.card
decreasing_by
  · classical
    have hx : e.symm y ∉ S := hxmove.1
    have hcard : (insert (e.symm y) S).card = S.card + 1 :=
      Finset.card_insert_of_notMem hx
    have hlt : S.card < Fintype.card α := card_lt_univ_of_notMem hx
    rw [hcard]
    omega
  · classical
    have hx : x ∉ S := hxmove.1
    have hcard : (insert x S).card = S.card + 1 :=
      Finset.card_insert_of_notMem hx
    have hlt : S.card < Fintype.card α := card_lt_univ_of_notMem hx
    rw [hcard]
    omega

theorem isP_map {Valid : Finset α -> Prop} (e : α ≃ α)
    (hValid : ∀ S : Finset α, Valid (S.map e.toEmbedding) ↔ Valid S)
    (S : Finset α) : IsP Valid (S.map e.toEmbedding) ↔ IsP Valid S :=
  not_congr (win_map e hValid S)

omit [Fintype α] in
/-- Legal moves are transported by an equivalence between two board types when
the validity predicates match under the equivalence. -/
theorem move_equiv {β : Type*} [Fintype β] [DecidableEq β]
    {Validα : Finset α -> Prop} {Validβ : Finset β -> Prop} (e : α ≃ β)
    (hValid : ∀ S : Finset α, Validβ (S.map e.toEmbedding) ↔ Validα S)
    {S : Finset α} {x : α} :
    Move Validβ (S.map e.toEmbedding) (e x) ↔ Move Validα S x := by
  have hmem : e x ∈ S.map e.toEmbedding ↔ x ∈ S := by
    rw [Finset.mem_map_equiv, Equiv.symm_apply_apply]
  have hins : insert (e x) (S.map e.toEmbedding) = (insert x S).map e.toEmbedding := by
    simp [Finset.map_insert]
  unfold Move
  rw [hins, hValid, hmem]

/-- Normal-play game values are invariant under a validity-preserving
equivalence between two board types. -/
theorem win_equiv {β : Type*} [Fintype β] [DecidableEq β]
    {Validα : Finset α -> Prop} {Validβ : Finset β -> Prop} (e : α ≃ β)
    (hValid : ∀ S : Finset α, Validβ (S.map e.toEmbedding) ↔ Validα S)
    (S : Finset α) : Win Validβ (S.map e.toEmbedding) ↔ Win Validα S := by
  rw [win_iff_exists_move, win_iff_exists_move]
  constructor
  · rintro ⟨y, hymove, hylose⟩
    let x : α := e.symm y
    have hy : e x = y := e.apply_symm_apply y
    rw [← hy] at hymove hylose
    have hxmove : Move Validα S x := (move_equiv e hValid).mp hymove
    refine ⟨x, hxmove, fun hwin => hylose ?_⟩
    have hins : insert (e x) (S.map e.toEmbedding) =
        (insert x S).map e.toEmbedding := by
      simp [Finset.map_insert]
    rw [hins]
    exact (win_equiv e hValid (insert x S)).mpr hwin
  · rintro ⟨x, hxmove, hxlose⟩
    refine ⟨e x, (move_equiv e hValid).mpr hxmove, fun hwin => hxlose ?_⟩
    have hins : insert (e x) (S.map e.toEmbedding) =
        (insert x S).map e.toEmbedding := by
      simp [Finset.map_insert]
    rw [hins] at hwin
    exact (win_equiv e hValid (insert x S)).mp hwin
termination_by Fintype.card α - S.card
decreasing_by
  · classical
    have hx : x ∉ S := hxmove.1
    have hcard : (insert x S).card = S.card + 1 :=
      Finset.card_insert_of_notMem hx
    have hlt : S.card < Fintype.card α := card_lt_univ_of_notMem hx
    rw [hcard]
    omega
  · classical
    have hx : x ∉ S := hxmove.1
    have hcard : (insert x S).card = S.card + 1 :=
      Finset.card_insert_of_notMem hx
    have hlt : S.card < Fintype.card α := card_lt_univ_of_notMem hx
    rw [hcard]
    omega

theorem isP_equiv {β : Type*} [Fintype β] [DecidableEq β]
    {Validα : Finset α -> Prop} {Validβ : Finset β -> Prop} (e : α ≃ β)
    (hValid : ∀ S : Finset α, Validβ (S.map e.toEmbedding) ↔ Validα S)
    (S : Finset α) : IsP Validβ (S.map e.toEmbedding) ↔ IsP Validα S :=
  not_congr (win_equiv e hValid S)

/-! ## Size-orbit value chains -/

/-- All valid positions of one size share a single game value. -/
def SizeValueConstant (Valid : Finset α -> Prop) (k : ℕ) : Prop :=
  ∀ ⦃S T : Finset α⦄, Valid S -> Valid T -> S.card = k -> T.card = k ->
    (Win Valid S ↔ Win Valid T)

/-- Single-orbit transitivity under validity-preserving symmetries forces a
single game value on each size layer. -/
theorem sizeValueConstant_of_transitive {Valid : Finset α -> Prop} {k : ℕ}
    (htrans : ∀ ⦃S T : Finset α⦄, Valid S -> Valid T -> S.card = k -> T.card = k ->
      ∃ e : α ≃ α, (∀ U : Finset α, Valid (U.map e.toEmbedding) ↔ Valid U) ∧
        S.map e.toEmbedding = T) :
    SizeValueConstant Valid k := by
  intro S T hS hT hSk hTk
  obtain ⟨e, hVe, hST⟩ := htrans hS hT hSk hTk
  rw [← hST, win_map e hVe]

/-- Value alternation across one size layer: if the next layer has a single
value and the position can move at all, its value is the negation of the next
layer's value. -/
theorem win_iff_not_win_succ {Valid : Finset α -> Prop} {k : ℕ}
    (hconst : SizeValueConstant Valid (k + 1))
    {S T : Finset α} (hSk : S.card = k) (hmove : ∃ x, Move Valid S x)
    (hT : Valid T) (hTk : T.card = k + 1) :
    Win Valid S ↔ ¬ Win Valid T := by
  constructor
  · intro hwin hTwin
    rcases win_iff_exists_isP_child.mp hwin with ⟨x, hxmove, hxP⟩
    have hcard : (insert x S).card = k + 1 := by
      rw [Finset.card_insert_of_notMem hxmove.1, hSk]
    exact hxP ((hconst hxmove.2 hT hcard hTk).mpr hTwin)
  · intro hTlose
    rcases hmove with ⟨x, hxmove⟩
    have hcard : (insert x S).card = k + 1 := by
      rw [Finset.card_insert_of_notMem hxmove.1, hSk]
    refine win_of_move_to_isP hxmove ?_
    exact fun hwin => hTlose ((hconst hxmove.2 hT hcard hTk).mp hwin)

/--
Frame chain: if sizes `1..4` each carry a single game value and every valid
position of size at most `3` can still move, the empty position and any valid
size-`4` position have the same outcome.

This is the game-theoretic half of the projective frame reduction; the
geometric half supplies the four `SizeValueConstant` hypotheses from
`PGL`-transitivity on points, pairs, triangles, and frames.
-/
theorem isP_empty_iff_isP_of_frame_chain {Valid : Finset α -> Prop}
    (h1 : SizeValueConstant Valid 1) (h2 : SizeValueConstant Valid 2)
    (h3 : SizeValueConstant Valid 3) (h4 : SizeValueConstant Valid 4)
    (hext : ∀ S : Finset α, Valid S -> S.card ≤ 3 -> ∃ x, Move Valid S x)
    (hempty : Valid (∅ : Finset α))
    {F : Finset α} (hF : Valid F) (hFcard : F.card = 4) :
    (IsP Valid (∅ : Finset α) ↔ IsP Valid F) := by
  classical
  obtain ⟨x1, hm1⟩ := hext ∅ hempty (by simp)
  set S1 : Finset α := insert x1 ∅ with hS1def
  have hS1 : Valid S1 := hm1.2
  have hS1card : S1.card = 1 := by simp [hS1def]
  obtain ⟨x2, hm2⟩ := hext S1 hS1 (by omega)
  set S2 : Finset α := insert x2 S1 with hS2def
  have hS2 : Valid S2 := hm2.2
  have hS2card : S2.card = 2 := by
    rw [hS2def, Finset.card_insert_of_notMem hm2.1, hS1card]
  obtain ⟨x3, hm3⟩ := hext S2 hS2 (by omega)
  set S3 : Finset α := insert x3 S2 with hS3def
  have hS3 : Valid S3 := hm3.2
  have hS3card : S3.card = 3 := by
    rw [hS3def, Finset.card_insert_of_notMem hm3.1, hS2card]
  have c01 : Win Valid (∅ : Finset α) ↔ ¬ Win Valid S1 :=
    win_iff_not_win_succ h1 (by simp) ⟨x1, hm1⟩ hS1 hS1card
  have c12 : Win Valid S1 ↔ ¬ Win Valid S2 :=
    win_iff_not_win_succ h2 hS1card ⟨x2, hm2⟩ hS2 hS2card
  have c23 : Win Valid S2 ↔ ¬ Win Valid S3 :=
    win_iff_not_win_succ h3 hS2card ⟨x3, hm3⟩ hS3 hS3card
  have c34 : Win Valid S3 ↔ ¬ Win Valid F :=
    win_iff_not_win_succ h4 hS3card (hext S3 hS3 (by omega)) hF hFcard
  unfold IsP
  rw [c01, c12, c23, c34]
  tauto

end FiniteBuildGame
