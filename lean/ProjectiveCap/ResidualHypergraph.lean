import ProjectiveCap.GridGame

/-!
# Rank-three hypergraph structure of residual grid-cap games

A residual position in the projective-plane grid game is governed by
constraints involving at most three cells.  This module separates that static
fact from the recursive game semantics.  It also records general mex bounds
that explain why repeated follower types do not increase a Grundy value.

The main geometric statement, `gridCap_iff_all_small_subsets`, says that a
finite grid set is a cap exactly when all of its subsets of cardinality at
most three are caps.  Consequently every inclusion-minimal forbidden set has
cardinality two or three.  Cardinality-two obstructions are the residual
conflict-graph edges; cardinality-three obstructions are the genuinely
hypergraphic part that disappears in a Node--Kayles residual.
-/

namespace FiniteBuildGame

variable {α : Type*} [Fintype α] [DecidableEq α]

/-- The mex of a finite set is at most the cardinality of that set. -/
theorem mex_le_card (T : Finset ℕ) : mex T ≤ T.card := by
  have hsub : Finset.range (mex T) ⊆ T := by
    intro n hn
    exact lt_mex_mem (Finset.mem_range.mp hn)
  simpa using Finset.card_le_card hsub

/-- The set of Grundy values of the legal followers of a position. -/
noncomputable def FollowerValues (Valid : Finset α -> Prop) (S : Finset α) : Finset ℕ :=
  (LegalExtensions Valid S).attach.image
    fun x : {x // x ∈ LegalExtensions Valid S} => Grundy Valid (insert (x : α) S)

/--
A position's Grundy value is bounded by the number of distinct follower
values.  In particular, duplicate or game-equivalent followers do not enlarge
the mex.
-/
theorem grundy_le_followerValues_card (Valid : Finset α -> Prop) (S : Finset α) :
    Grundy Valid S ≤ (FollowerValues Valid S).card := by
  rw [Grundy.eq_def]
  exact mex_le_card _

/--
If follower values factor through a finite signature type, the Grundy value is
at most the number of signatures.  Stabilizer orbits and rooted game-tree
isomorphism classes are standard sources of such signatures.
-/
theorem grundy_le_card_of_follower_signature
    {β : Type*} [Fintype β] [DecidableEq β]
    (Valid : Finset α -> Prop) (S : Finset α)
    (signature : {x // x ∈ LegalExtensions Valid S} -> β)
    (value : β -> ℕ)
    (hfactor : ∀ x : {x // x ∈ LegalExtensions Valid S},
      Grundy Valid (insert (x : α) S) = value (signature x)) :
    Grundy Valid S ≤ Fintype.card β := by
  calc
    Grundy Valid S ≤ (FollowerValues Valid S).card :=
      grundy_le_followerValues_card Valid S
    _ ≤ ((Finset.univ : Finset β).image value).card := by
      apply Finset.card_le_card
      intro n hn
      rcases Finset.mem_image.mp hn with ⟨x, _hx, rfl⟩
      apply Finset.mem_image.mpr
      exact ⟨signature x, Finset.mem_univ _, (hfactor x).symm⟩
    _ ≤ Fintype.card β := by
      simpa using
        (Finset.card_image_le : ((Finset.univ : Finset β).image value).card ≤
          (Finset.univ : Finset β).card)

/--
The Grundy value of a finite building-game position is at most the number of
unchosen board elements.  This is the usual game-height bound for games in
which each move adjoins one fresh element.
-/
theorem grundy_le_remaining (Valid : Finset α -> Prop) (S : Finset α) :
    Grundy Valid S ≤ Fintype.card α - S.card := by
  calc
    Grundy Valid S ≤ (FollowerValues Valid S).card :=
      grundy_le_followerValues_card Valid S
    _ ≤ (LegalExtensions Valid S).card := by
      simpa [FollowerValues] using
        (Finset.card_image_le :
          ((LegalExtensions Valid S).attach.image
            fun x : {x // x ∈ LegalExtensions Valid S} =>
              Grundy Valid (insert (x : α) S)).card ≤
            (LegalExtensions Valid S).attach.card)
    _ ≤ ((Finset.univ : Finset α) \ S).card := by
      apply Finset.card_le_card
      intro x hx
      have hxmove : Move Valid S x := mem_legalExtensions.mp hx
      simp [hxmove.1]
    _ = Fintype.card α - S.card := by
      simp [Finset.card_sdiff]

/--
A uniform cardinality bound on valid continuations bounds the Grundy value by
the remaining attainable height.  Unlike `grundy_le_remaining`, this theorem
uses a bound on valid positions rather than the size of the ambient board.
-/
theorem grundy_le_of_valid_card_bound
    (Valid : Finset α -> Prop) (M : ℕ) (S : Finset α)
    (hbound : ∀ T : Finset α, S ⊆ T -> Valid T -> T.card ≤ M) :
    Grundy Valid S ≤ M - S.card := by
  rw [Grundy.eq_def]
  by_contra hle
  push Not at hle
  have hmem := lt_mex_mem hle
  rcases Finset.mem_image.mp hmem with ⟨x, _hxattach, hxvalue⟩
  have hxmove : Move Valid S (x : α) := mem_legalExtensions.mp x.2
  have hxcard : (insert (x : α) S).card = S.card + 1 :=
    Finset.card_insert_of_notMem hxmove.1
  have hchildBound :
      ∀ T : Finset α, insert (x : α) S ⊆ T -> Valid T -> T.card ≤ M := by
    intro T hsub hT
    apply hbound T _ hT
    exact Finset.Subset.trans (Finset.subset_insert _ _) hsub
  have hchild :=
    grundy_le_of_valid_card_bound Valid M (insert (x : α) S) hchildBound
  have hxM : S.card + 1 ≤ M := by
    simpa [hxcard] using hbound (insert (x : α) S) (Finset.subset_insert _ _) hxmove.2
  rw [hxvalue] at hchild
  omega
termination_by Fintype.card α - S.card
decreasing_by
  classical
  have hxmove : Move Valid S (x : α) := mem_legalExtensions.mp x.2
  have hxcard : (insert (x : α) S).card = S.card + 1 :=
    Finset.card_insert_of_notMem hxmove.1
  have hsubset : S ⊆ (Finset.univ : Finset α) := Finset.subset_univ S
  have hproper : S ⊂ (Finset.univ : Finset α) :=
    (Finset.ssubset_iff_of_subset hsubset).mpr
      ⟨(x : α), Finset.mem_univ _, hxmove.1⟩
  have hxlt : S.card < Fintype.card α := by
    simpa using Finset.card_lt_card hproper
  rw [hxcard]
  omega

/--
The isolated rank-three gadget on a finite board: at most two vertices may be
selected.  After its first move the remaining legal vertices form a clique,
because any second selection makes every third vertex illegal.
-/
def AtMostTwo (S : Finset α) : Prop :=
  S.card ≤ 2

/--
An isolated gadget containing at least two vertices is a P-position and hence
has Grundy value zero.  The statement includes every overloaded gadget
(`Fintype.card α ≥ 3`).
-/
theorem grundy_atMostTwo_empty_eq_zero (hcard : 2 ≤ Fintype.card α) :
    Grundy (AtMostTwo (α := α)) ∅ = 0 := by
  apply isP_iff_grundy_eq_zero.mp
  apply isP_of_pairReplyBook
  intro x _hxmove
  have hyexists : ∃ y : α, y ≠ x := by
    by_contra h
    simp only [not_exists, not_not] at h
    have huniv : (Finset.univ : Finset α) ⊆ {x} := by
      intro y _hy
      simpa [h y]
    have hle := Finset.card_le_card huniv
    simp only [Finset.card_univ, Finset.card_singleton] at hle
    omega
  rcases hyexists with ⟨y, hyx⟩
  refine ⟨y, ?_, ?_⟩
  · constructor
    · simp [hyx]
    · change ({y, x} : Finset α).card ≤ 2
      have hpair : ({y, x} : Finset α).card = 2 :=
        Finset.card_pair_eq_two_iff.mpr hyx
      omega
  · apply isP_of_no_moves
    intro z hzmove
    rcases hzmove with ⟨hz, hzvalid⟩
    have hzcard :
        (insert z (insert y (insert x ∅ : Finset α))).card = 3 := by
      rw [Finset.card_insert_of_notMem hz]
      change ({y, x} : Finset α).card + 1 = 3
      rw [Finset.card_pair_eq_two_iff.mpr hyx]
    exact (by
      change (insert z (insert y (insert x ∅ : Finset α))).card ≤ 2 at hzvalid
      omega)

end FiniteBuildGame

namespace ProjectiveCap
namespace ResidualHypergraph

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

/--
Residual-grid specialization of the valid-card height bound.  Supplying the
odd-plane arc bound `T.card ≤ q - 1` gives
`Grundy(S) ≤ q - 1 - S.card`.
-/
theorem gridGrundy_le_of_extension_card_bound
    (M : ℕ) (S : Finset (GridPoint K))
    (hbound : ∀ T : Finset (GridPoint K), S ⊆ T -> GridCap T -> T.card ≤ M) :
    FiniteBuildGame.Grundy (GridCap (K := K)) S ≤ M - S.card :=
  FiniteBuildGame.grundy_le_of_valid_card_bound (GridCap (K := K)) M S hbound

/--
A grid set satisfies all rank-three tests when each of its subsets containing
at most three cells is a grid cap.
-/
def AllSmallSubsetsCap (S : Finset (GridPoint K)) : Prop :=
  ∀ T : Finset (GridPoint K), T ⊆ S -> T.card ≤ 3 -> GridCap T

/--
Grid-cap validity is exactly a rank-at-most-three condition: it is enough to
check every subset of cardinality at most three.
-/
theorem gridCap_iff_allSmallSubsetsCap (S : Finset (GridPoint K)) :
    GridCap S ↔ AllSmallSubsetsCap S := by
  constructor
  · intro hS T hTS _hcard
    exact gridCap_mono hTS hS
  · intro hlocal
    constructor
    · constructor
      · intro p q hp hq hpq
        have hpair : ({p, q} : Finset (GridPoint K)) ⊆ S := by
          intro x hx
          simp only [Finset.mem_insert, Finset.mem_singleton] at hx
          rcases hx with rfl | rfl
          · exact hp
          · exact hq
        have hcard : ({p, q} : Finset (GridPoint K)).card ≤ 3 := by
          have hle := Finset.card_insert_le p ({q} : Finset (GridPoint K))
          simp only [Finset.card_singleton] at hle
          omega
        have hcap := hlocal {p, q} hpair hcard
        exact hcap.1.1 (by simp) (by simp) hpq
      · intro p q hp hq hpq
        have hpair : ({p, q} : Finset (GridPoint K)) ⊆ S := by
          intro x hx
          simp only [Finset.mem_insert, Finset.mem_singleton] at hx
          rcases hx with rfl | rfl
          · exact hp
          · exact hq
        have hcard : ({p, q} : Finset (GridPoint K)).card ≤ 3 := by
          have hle := Finset.card_insert_le p ({q} : Finset (GridPoint K))
          simp only [Finset.card_singleton] at hle
          omega
        have hcap := hlocal {p, q} hpair hcard
        exact hcap.1.2 (by simp) (by simp) hpq
    · intro a b c ha hb hc hab hac hbc hcol
      have htriple : ({a, b, c} : Finset (GridPoint K)) ⊆ S := by
        intro x hx
        simp only [Finset.mem_insert, Finset.mem_singleton] at hx
        rcases hx with rfl | rfl | rfl
        · exact ha
        · exact hb
        · exact hc
      have hcard : ({a, b, c} : Finset (GridPoint K)).card ≤ 3 := by
        have hle₁ := Finset.card_insert_le b ({c} : Finset (GridPoint K))
        have hle₂ := Finset.card_insert_le a ({b, c} : Finset (GridPoint K))
        simp only [Finset.card_singleton] at hle₁
        omega
      have hcap := hlocal {a, b, c} htriple hcard
      exact hcap.2 (by simp) (by simp) (by simp) hab hac hbc hcol

/-- Every singleton grid set is a grid cap. -/
theorem gridCap_singleton (p : GridPoint K) : GridCap ({p} : Finset (GridPoint K)) := by
  rw [gridCap_iff_allSmallSubsetsCap]
  intro T hT _hcard
  have hcases : T = ∅ ∨ T = {p} := by
    simpa [Finset.subset_singleton_iff] using hT
  rcases hcases with rfl | rfl
  · constructor
    · exact ⟨by simp [RowSparse], by simp [ColSparse]⟩
    · simp [AffineCap]
  · constructor
    · constructor <;> intro a b ha hb _ <;> simp_all
    · intro a b c ha hb hc hab _hac _hbc
      simp_all

/--
For two distinct residual cells, the only forbidden configurations are a
shared row or a shared column.  These are precisely the load-one projective
lines through the two fixed opening points.
-/
theorem gridCap_pair_iff
    {p q : GridPoint K} (hpq : p ≠ q) :
    GridCap ({p, q} : Finset (GridPoint K)) ↔
      p.1 ≠ q.1 ∧ p.2 ≠ q.2 := by
  constructor
  · intro hcap
    constructor
    · intro hrow
      exact hpq (hcap.1.1 (by simp) (by simp) hrow)
    · intro hcol
      exact hpq (hcap.1.2 (by simp) (by simp) hcol)
  · rintro ⟨hrow, hcol⟩
    constructor
    · constructor
      · intro a b ha hb hab
        simp only [Finset.mem_insert, Finset.mem_singleton] at ha hb
        rcases ha with rfl | rfl <;> rcases hb with rfl | rfl
        · rfl
        · exact absurd hab hrow
        · exact absurd hab hrow.symm
        · rfl
      · intro a b ha hb hab
        simp only [Finset.mem_insert, Finset.mem_singleton] at ha hb
        rcases ha with rfl | rfl <;> rcases hb with rfl | rfl
        · rfl
        · exact absurd hab hcol
        · exact absurd hab hcol.symm
        · rfl
    · intro a b c ha hb hc hab hac hbc
      simp only [Finset.mem_insert, Finset.mem_singleton] at ha hb hc
      rcases ha with rfl | rfl <;>
        rcases hb with rfl | rfl <;>
          rcases hc with rfl | rfl <;> simp_all

/--
An inclusion-minimal forbidden grid configuration has cardinality two or
three.  This is the precise rank bound behind the residual hypergraph.
-/
theorem minimal_not_gridCap_card
    {S : Finset (GridPoint K)}
    (hbad : ¬ GridCap S)
    (hminimal : ∀ T : Finset (GridPoint K), T ⊂ S -> GridCap T) :
    S.card = 2 ∨ S.card = 3 := by
  have hnotlocal : ¬ AllSmallSubsetsCap S := by
    simpa [gridCap_iff_allSmallSubsetsCap] using hbad
  unfold AllSmallSubsetsCap at hnotlocal
  simp only [not_forall] at hnotlocal
  rcases hnotlocal with ⟨T, hTS, hcard, hTbad⟩
  have hTS_eq : T = S := by
    by_contra hne
    exact hTbad (hminimal T (Finset.ssubset_iff_subset_ne.mpr ⟨hTS, hne⟩))
  subst T
  have hpos : 2 ≤ S.card := by
    by_contra hlt
    have hle : S.card ≤ 1 := by omega
    have hcases : S.card = 0 ∨ S.card = 1 := by omega
    rcases hcases with hzero | hone
    · rw [Finset.card_eq_zero.mp hzero] at hbad
      exact hbad ⟨⟨by simp [RowSparse], by simp [ColSparse]⟩, by simp [AffineCap]⟩
    · rcases Finset.card_eq_one.mp hone with ⟨p, rfl⟩
      exact hbad (gridCap_singleton p)
  omega

/--
Every invalid continuation contains an invalid subcontinuation of cardinality
at most three.  The old state `S` remains fixed; only newly adjoined cells are
counted.
-/
theorem exists_small_bad_extension
    {S T : Finset (GridPoint K)}
    (hbad : ¬ GridCap (S ∪ T)) :
    ∃ U : Finset (GridPoint K),
      U ⊆ T ∧ U.card ≤ 3 ∧ ¬ GridCap (S ∪ U) := by
  have hnotlocal : ¬ AllSmallSubsetsCap (S ∪ T) := by
    simpa [gridCap_iff_allSmallSubsetsCap] using hbad
  unfold AllSmallSubsetsCap at hnotlocal
  simp only [not_forall] at hnotlocal
  rcases hnotlocal with ⟨W, hW, hWcard, hWbad⟩
  refine ⟨W \ S, ?_, ?_, ?_⟩
  · intro x hx
    have hxW := (Finset.mem_sdiff.mp hx).1
    have hxUnion := hW hxW
    exact (Finset.mem_union.mp hxUnion).resolve_left (Finset.mem_sdiff.mp hx).2
  · exact (Finset.card_le_card (Finset.sdiff_subset : W \ S ⊆ W)).trans hWcard
  · intro hcap
    apply hWbad
    apply gridCap_mono (T := S ∪ (W \ S)) _ hcap
    intro x hxW
    by_cases hxS : x ∈ S
    · exact Finset.mem_union_left _ hxS
    · exact Finset.mem_union_right _ (Finset.mem_sdiff.mpr ⟨hxW, hxS⟩)

/--
A bad extension made entirely of individually legal moves contains at least
two new cells.
-/
theorem two_le_card_of_bad_extension
    {S U : Finset (GridPoint K)}
    (hS : GridCap S)
    (hlegal : U ⊆ GridGame.LegalExtensions (K := K) S)
    (hbad : ¬ GridCap (S ∪ U)) :
    2 ≤ U.card := by
  by_contra hlt
  have hle : U.card ≤ 1 := by omega
  have hcases : U.card = 0 ∨ U.card = 1 := by omega
  rcases hcases with hzero | hone
  · rw [Finset.card_eq_zero.mp hzero] at hbad
    simp only [Finset.union_empty] at hbad
    exact hbad hS
  · obtain ⟨x, hU⟩ := Finset.card_eq_one.mp hone
    subst U
    have hxmem : x ∈ ({x} : Finset (GridPoint K)) := Finset.mem_singleton_self x
    have hxlegal := GridGame.mem_legalExtensions.mp (hlegal hxmem)
    exact hbad (by simpa [Finset.union_singleton] using hxlegal.2)

/--
For a valid residual state, every inclusion-minimal forbidden extension made
of legal vertices is a pair or a triple.
-/
theorem minimal_bad_extension_card
    {S U : Finset (GridPoint K)}
    (hS : GridCap S)
    (hlegal : U ⊆ GridGame.LegalExtensions (K := K) S)
    (hbad : ¬ GridCap (S ∪ U))
    (hminimal : ∀ W : Finset (GridPoint K), W ⊂ U -> GridCap (S ∪ W)) :
    U.card = 2 ∨ U.card = 3 := by
  rcases exists_small_bad_extension (K := K) hbad with
    ⟨W, hWU, hWcard, hWbad⟩
  have hWUeq : W = U := by
    by_contra hne
    exact hWbad (hminimal W (Finset.ssubset_iff_subset_ne.mpr ⟨hWU, hne⟩))
  subst W
  have htwo := two_le_card_of_bad_extension hS hlegal hbad
  omega

/--
There are no active residual triples at `S` when every minimal forbidden
extension on legal vertices is already a pair.  This is the static hypothesis
under which the rank-three residual collapses to its conflict graph.
-/
def NoActiveResidualTriples (S : Finset (GridPoint K)) : Prop :=
  ∀ U : Finset (GridPoint K),
    U ⊆ GridGame.LegalExtensions (K := K) S ->
    ¬ GridCap (S ∪ U) ->
    (∀ W : Finset (GridPoint K), W ⊂ U -> GridCap (S ∪ W)) ->
    U.card = 2

/--
Under `NoActiveResidualTriples`, a continuation is valid exactly when each of
its two-element subcontinuations is valid.  This is the static `Y_NK`
specialization: the remaining game is governed solely by the residual
conflict graph.
-/
theorem gridCap_union_iff_all_pairs
    {S T : Finset (GridPoint K)}
    (hS : GridCap S)
    (hTlegal : T ⊆ GridGame.LegalExtensions (K := K) S)
    (hNoTriples : NoActiveResidualTriples (K := K) S) :
    GridCap (S ∪ T) ↔
      ∀ U : Finset (GridPoint K), U ⊆ T -> U.card = 2 -> GridCap (S ∪ U) := by
  constructor
  · intro hcap U hUT _hcard
    apply gridCap_mono _ hcap
    intro x hx
    rcases Finset.mem_union.mp hx with hxS | hxU
    · exact Finset.mem_union_left _ hxS
    · exact Finset.mem_union_right _ (hUT hxU)
  · intro hpairs
    by_contra hbad
    rcases exists_small_bad_extension (K := K) hbad with
      ⟨U, hUT, hUcard, hUbad⟩
    have hUlegal : U ⊆ GridGame.LegalExtensions (K := K) S :=
      hUT.trans hTlegal
    have hUtwo := two_le_card_of_bad_extension hS hUlegal hUbad
    have hcases : U.card = 2 ∨ U.card = 3 := by omega
    rcases hcases with htwo | hthree
    · exact hUbad (hpairs U hUT htwo)
    · by_cases hminimal :
        ∀ W : Finset (GridPoint K), W ⊂ U -> GridCap (S ∪ W)
      · have := hNoTriples U hUlegal hUbad hminimal
        omega
      · simp only [not_forall] at hminimal
        rcases hminimal with ⟨W, hWU, hWbad⟩
        have hWlegal : W ⊆ GridGame.LegalExtensions (K := K) S :=
          hWU.1.trans hUlegal
        have hWtwo := two_le_card_of_bad_extension hS hWlegal hWbad
        have hWlt := Finset.card_lt_card hWU
        have hWcard : W.card = 2 := by omega
        exact hWbad (hpairs W (hWU.1.trans hUT) hWcard)

end ResidualHypergraph
end ProjectiveCap

#print axioms FiniteBuildGame.grundy_atMostTwo_empty_eq_zero
#print axioms ProjectiveCap.ResidualHypergraph.gridCap_union_iff_all_pairs
#print axioms FiniteBuildGame.grundy_le_card_of_follower_signature
