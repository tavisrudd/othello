import CapGame.BuildGame

/-!
# Private vertices attached through a labelled boundary

Consider a finite building game whose board is the disjoint union of ambient
vertices `γ` and private vertices `U`.  A fixed set of ambient vertices is the
boundary of one rank-three gadget.  Validity consists of an arbitrary
constraint on the selected ambient vertices together with the condition that
at most two selected vertices lie in the gadget.

The private vertices occur in no other constraint.  The main theorem proves
that the rooted game depends on their total number only through its truncation
at two, and on a position only through its ambient part and its selected
private occupancy.  The proof is a two-sided move bisimulation, so it preserves
the complete rooted normal-play game and in particular its Grundy value.
-/

namespace FiniteBuildGame

variable {α β : Type*} [Fintype α] [DecidableEq α]
  [Fintype β] [DecidableEq β]

/--
Two finite building-game positions have equal Grundy values when they are
related by a two-sided move bisimulation.  Matching moves need not be unique;
this allows several indistinguishable moves to collapse to one option type.
-/
theorem grundy_eq_of_move_bisimulation
    {Validα : Finset α -> Prop} {Validβ : Finset β -> Prop}
    (Related : Finset α -> Finset β -> Prop)
    (forward : ∀ {S T}, Related S T -> ∀ x, Move Validα S x ->
      ∃ y, Move Validβ T y ∧ Related (insert x S) (insert y T))
    (backward : ∀ {S T}, Related S T -> ∀ y, Move Validβ T y ->
      ∃ x, Move Validα S x ∧ Related (insert x S) (insert y T))
    {S : Finset α} {T : Finset β} (hST : Related S T) :
    Grundy Validα S = Grundy Validβ T := by
  rw [Grundy.eq_def, Grundy.eq_def]
  congr 1
  ext n
  simp only [Finset.mem_image, Finset.mem_attach, true_and]
  constructor
  · rintro ⟨x, rfl⟩
    have hx : Move Validα S (x : α) := mem_legalExtensions.mp x.2
    rcases forward hST (x : α) hx with ⟨y, hy, hchild⟩
    let y' : {y // y ∈ LegalExtensions Validβ T} :=
      ⟨y, mem_legalExtensions.mpr hy⟩
    refine ⟨y', ?_⟩
    exact (grundy_eq_of_move_bisimulation Related forward backward hchild).symm
  · rintro ⟨y, rfl⟩
    have hy : Move Validβ T (y : β) := mem_legalExtensions.mp y.2
    rcases backward hST (y : β) hy with ⟨x, hx, hchild⟩
    let x' : {x // x ∈ LegalExtensions Validα S} :=
      ⟨x, mem_legalExtensions.mpr hx⟩
    refine ⟨x', ?_⟩
    exact grundy_eq_of_move_bisimulation Related forward backward hchild
termination_by Fintype.card α - S.card
decreasing_by
  · classical
    have hx : (x : α) ∉ S := hx.1
    have hcard : (insert (x : α) S).card = S.card + 1 :=
      Finset.card_insert_of_notMem hx
    have hlt : S.card < Fintype.card α := by
      have hsubset : S ⊆ (Finset.univ : Finset α) := Finset.subset_univ S
      have hproper : S ⊂ (Finset.univ : Finset α) :=
        (Finset.ssubset_iff_of_subset hsubset).mpr
          ⟨(x : α), Finset.mem_univ _, hx⟩
      simpa using Finset.card_lt_card hproper
    rw [hcard]
    omega
  · classical
    have hx : x ∉ S := hx.1
    have hcard : (insert x S).card = S.card + 1 :=
      Finset.card_insert_of_notMem hx
    have hlt : S.card < Fintype.card α := by
      have hsubset : S ⊆ (Finset.univ : Finset α) := Finset.subset_univ S
      have hproper : S ⊂ (Finset.univ : Finset α) :=
        (Finset.ssubset_iff_of_subset hsubset).mpr
          ⟨x, Finset.mem_univ _, hx⟩
      simpa using Finset.card_lt_card hproper
    rw [hcard]
    omega

namespace PrivateBoundary

variable {γ U V : Type*} [Fintype γ] [DecidableEq γ]
  [Fintype U] [DecidableEq U] [Fintype V] [DecidableEq V]

/-- The selected ambient vertices of a position on `γ ⊕ U`. -/
def ambientPart (S : Finset (γ ⊕ U)) : Finset γ :=
  Finset.univ.filter fun x => Sum.inl x ∈ S

/-- The selected private vertices of a position on `γ ⊕ U`. -/
def privatePart (S : Finset (γ ⊕ U)) : Finset U :=
  Finset.univ.filter fun u => Sum.inr u ∈ S

/--
Validity for one rank-three gadget attached through `boundary`.  The predicate
`ambientValid` contains every constraint not involving a private vertex.
-/
def Valid (boundary : Finset γ) (ambientValid : Finset γ -> Prop)
    (S : Finset (γ ⊕ U)) : Prop :=
  ambientValid (ambientPart S) ∧
    ((ambientPart S ∩ boundary).card + (privatePart S).card ≤ 2)

/--
Positions over different private vertex types have the same boundary
signature when their selected ambient sets and private occupancies agree.
-/
def SameSignature (S : Finset (γ ⊕ U)) (T : Finset (γ ⊕ V)) : Prop :=
  ambientPart S = ambientPart T ∧ (privatePart S).card = (privatePart T).card

omit [Fintype U] in
@[simp] theorem ambientPart_insert_ambient (S : Finset (γ ⊕ U)) (x : γ) :
    ambientPart (insert (Sum.inl x) S) = insert x (ambientPart S) := by
  ext y
  simp [ambientPart]

omit [Fintype U] in
@[simp] theorem ambientPart_insert_private (S : Finset (γ ⊕ U)) (u : U) :
    ambientPart (insert (Sum.inr u) S) = ambientPart S := by
  ext x
  simp [ambientPart]

omit [Fintype γ] in
@[simp] theorem privatePart_insert_ambient (S : Finset (γ ⊕ U)) (x : γ) :
    privatePart (insert (Sum.inl x) S) = privatePart S := by
  ext u
  simp [privatePart]

omit [Fintype γ] in
@[simp] theorem privatePart_insert_private (S : Finset (γ ⊕ U)) (u : U) :
    privatePart (insert (Sum.inr u) S) = insert u (privatePart S) := by
  ext v
  simp [privatePart]

theorem valid_iff_of_sameSignature
    (boundary : Finset γ) (ambientValid : Finset γ -> Prop)
    {S : Finset (γ ⊕ U)} {T : Finset (γ ⊕ V)}
    (hST : SameSignature S T) :
    Valid boundary ambientValid S ↔ Valid boundary ambientValid T := by
  rcases hST with ⟨hambient, hprivate⟩
  simp only [Valid]
  rw [hambient, hprivate]

private theorem exists_unselected_private
    {S : Finset (γ ⊕ U)} {T : Finset (γ ⊕ V)} {u : U}
    (hcard : min 2 (Fintype.card U) = min 2 (Fintype.card V))
    (hsig : SameSignature S T)
    (hu : Sum.inr u ∉ S)
    (hroom : (privatePart S).card < 2) :
    ∃ v : V, Sum.inr v ∉ T := by
  have hu' : u ∉ privatePart S := by simpa [privatePart] using hu
  have hselected_lt_U : (privatePart S).card < Fintype.card U := by
    have hproper : privatePart S ⊂ (Finset.univ : Finset U) :=
      (Finset.ssubset_iff_of_subset (Finset.subset_univ _)).mpr
        ⟨u, Finset.mem_univ _, hu'⟩
    simpa using Finset.card_lt_card hproper
  have hselected_eq : (privatePart S).card = (privatePart T).card := hsig.2
  have hselected_lt_V : (privatePart T).card < Fintype.card V := by
    rw [← hselected_eq]
    omega
  by_contra h
  push Not at h
  have huniv_subset : (Finset.univ : Finset V) ⊆ privatePart T := by
    intro v _hv
    simpa [privatePart] using h v
  have hle := Finset.card_le_card huniv_subset
  simp only [Finset.card_univ] at hle
  omega

private theorem forward_moves
    (boundary : Finset γ) (ambientValid : Finset γ -> Prop)
    (hcard : min 2 (Fintype.card U) = min 2 (Fintype.card V))
    {S : Finset (γ ⊕ U)} {T : Finset (γ ⊕ V)}
    (hST : SameSignature S T) (x : γ ⊕ U)
    (hx : Move (Valid boundary ambientValid) S x) :
    ∃ y, Move (Valid boundary ambientValid) T y ∧
      SameSignature (insert x S) (insert y T) := by
  cases x with
  | inl x =>
      refine ⟨Sum.inl x, ?_, ?_⟩
      · constructor
        · have hxambient : x ∉ ambientPart S := by
            simpa [ambientPart] using hx.1
          have hxambientT : x ∉ ambientPart T := by
            rwa [← hST.1]
          simpa [ambientPart] using hxambientT
        · apply (valid_iff_of_sameSignature boundary ambientValid ?_).mp hx.2
          exact ⟨by simp [hST.1], by simp [hST.2]⟩
      · exact ⟨by simp [hST.1], by simp [hST.2]⟩
  | inr u =>
      have hroom : (privatePart S).card < 2 := by
        have hvalid := hx.2.2
        simp only [ambientPart_insert_private, privatePart_insert_private] at hvalid
        have hu' : u ∉ privatePart S := by
          simpa [privatePart] using hx.1
        rw [Finset.card_insert_of_notMem hu'] at hvalid
        omega
      rcases exists_unselected_private hcard hST hx.1 hroom with ⟨v, hv⟩
      refine ⟨Sum.inr v, ?_, ?_⟩
      · constructor
        · exact hv
        · apply (valid_iff_of_sameSignature boundary ambientValid ?_).mp hx.2
          have hu' : u ∉ privatePart S := by
            simpa [privatePart] using hx.1
          have hv' : v ∉ privatePart T := by
            simpa [privatePart] using hv
          constructor
          · simp [hST.1]
          · simp [Finset.card_insert_of_notMem hu',
              Finset.card_insert_of_notMem hv', hST.2]
      · have hu' : u ∉ privatePart S := by
          simpa [privatePart] using hx.1
        have hv' : v ∉ privatePart T := by
          simpa [privatePart] using hv
        exact ⟨by simp [hST.1], by
          simp [Finset.card_insert_of_notMem hu',
            Finset.card_insert_of_notMem hv', hST.2]⟩

/--
Private-boundary truncation theorem.

If two private vertex sets have the same cardinality after truncation at two,
then positions with the same ambient selection and the same selected private
occupancy have equal Grundy values.  Thus a private set may be replaced by
sets of cardinality zero, one, or two according as its original cardinality is
zero, one, or at least two.
-/
theorem grundy_eq_of_truncated_private_card
    (boundary : Finset γ) (ambientValid : Finset γ -> Prop)
    (hcard : min 2 (Fintype.card U) = min 2 (Fintype.card V))
    {S : Finset (γ ⊕ U)} {T : Finset (γ ⊕ V)}
    (hST : SameSignature S T) :
    Grundy (Valid boundary ambientValid) S =
      Grundy (Valid boundary ambientValid) T := by
  apply grundy_eq_of_move_bisimulation SameSignature
    (forward_moves boundary ambientValid hcard)
    (fun hTS y hy => by
      rcases forward_moves boundary ambientValid hcard.symm
          ⟨hTS.1.symm, hTS.2.symm⟩ y hy with
        ⟨x, hx, hchild⟩
      exact ⟨x, hx, ⟨hchild.1.symm, hchild.2.symm⟩⟩)
    hST

end PrivateBoundary
end FiniteBuildGame

#print axioms FiniteBuildGame.PrivateBoundary.grundy_eq_of_truncated_private_card
