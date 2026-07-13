import RelativeConicArcs.Arc
import Mathlib.Data.Fintype.BigOperators
import Mathlib.Data.Nat.Choose.Basic

/-!
# Classical secant-index equations

This file proves the maximum-index lemma and the first two classical moment equations for an arc
in a finite projective plane.  Unordered endpoint pairs are represented literally by two-subsets
of the arc; their canonical joining line connects that representation to `pointIndex`.
-/

namespace RelativeConicArcs

open Configuration Finset

variable {P L : Type*} [Membership P L]

/-- Unordered two-subsets of `A`. -/
abbrev ArcPair (A : Finset P) := {s : Finset P // s ∈ A.powersetCard 2}

namespace ArcPair

variable [DecidableEq P]

omit [DecidableEq P] in
theorem subset {A : Finset P} (e : ArcPair A) : e.1 ⊆ A :=
  (Finset.mem_powersetCard.mp e.2).1

omit [DecidableEq P] in
theorem card {A : Finset P} (e : ArcPair A) : e.1.card = 2 :=
  (Finset.mem_powersetCard.mp e.2).2

theorem exists_eq_pair {A : Finset P} (e : ArcPair A) :
    ∃ a b : P, a ≠ b ∧ e.1 = {a, b} :=
  Finset.card_eq_two.mp e.card

variable [Configuration.HasLines P L]

theorem existsUnique_line {A : Finset P} (e : ArcPair A) :
    ∃! l : L, ∀ p ∈ e.1, p ∈ l := by
  obtain ⟨a, b, hab, he⟩ := e.exists_eq_pair
  rw [he]
  obtain ⟨l, hl, huniq⟩ := Configuration.HasLines.existsUnique_line (P := P) (L := L) a b hab
  refine ⟨l, ?_, ?_⟩
  · intro p hp
    simp only [Finset.mem_insert, Finset.mem_singleton] at hp
    rcases hp with rfl | rfl
    · exact hl.1
    · exact hl.2
  · intro m hm
    apply huniq
    exact ⟨hm a (by simp), hm b (by simp)⟩

/-- The unique projective line through an unordered endpoint pair. -/
noncomputable def line {A : Finset P} (e : ArcPair A) : L :=
  Classical.choose e.existsUnique_line

theorem mem_line {A : Finset P} (e : ArcPair A) {p : P} (hp : p ∈ e.1) :
    p ∈ e.line (L := L) :=
  (Classical.choose_spec e.existsUnique_line).1 p hp

theorem line_unique {A : Finset P} (e : ArcPair A) {l : L}
    (hl : ∀ p ∈ e.1, p ∈ l) : e.line (L := L) = l :=
  ((Classical.choose_spec e.existsUnique_line).2 l hl).symm

theorem line_injective {A : Finset P} (hA : Arc (L := L) A) :
    Function.Injective (line (L := L) : ArcPair A → L) := by
  intro e f hef
  apply Subtype.ext
  apply Finset.Subset.antisymm
  · intro p hp
    by_contra hpf
    obtain ⟨a, b, hab, hf⟩ := f.exists_eq_pair
    have ha : a ∈ A := f.subset (by simp [hf])
    have hb : b ∈ A := f.subset (by simp [hf])
    have hpA : p ∈ A := e.subset hp
    have hpa : p ≠ a := fun h => hpf (by simp [hf, h])
    have hpb : p ≠ b := fun h => hpf (by simp [hf, h])
    apply hA hpA ha hb hpa hpb hab
    refine ⟨f.line (L := L), ?_, f.mem_line (by simp [hf]), f.mem_line (by simp [hf])⟩
    rw [← hef]
    exact e.mem_line hp
  · intro p hp
    by_contra hpe
    obtain ⟨a, b, hab, he⟩ := e.exists_eq_pair
    have ha : a ∈ A := e.subset (by simp [he])
    have hb : b ∈ A := e.subset (by simp [he])
    have hpA : p ∈ A := f.subset hp
    have hpa : p ≠ a := fun h => hpe (by simp [he, h])
    have hpb : p ≠ b := fun h => hpe (by simp [he, h])
    apply hA hpA ha hb hpa hpb hab
    refine ⟨e.line (L := L), ?_, e.mem_line (by simp [he]), e.mem_line (by simp [he])⟩
    rw [hef]
    exact f.mem_line hp

theorem mem_of_mem_arc_of_mem_line {A : Finset P} (hA : Arc (L := L) A)
    (e : ArcPair A) {p : P} (hpA : p ∈ A) (hpl : p ∈ e.line (L := L)) :
    p ∈ e.1 := by
  by_contra hpe
  obtain ⟨a, b, hab, he⟩ := e.exists_eq_pair
  have ha : a ∈ A := e.subset (by simp [he])
  have hb : b ∈ A := e.subset (by simp [he])
  have hpa : p ≠ a := fun h => hpe (by simp [he, h])
  have hpb : p ≠ b := fun h => hpe (by simp [he, h])
  exact hA hpA ha hb hpa hpb hab
    ⟨e.line (L := L), hpl, e.mem_line (by simp [he]), e.mem_line (by simp [he])⟩

end ArcPair

section FinitePlane

variable [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

noncomputable local instance instDecidableIncidence (p : P) (l : L) : Decidable (p ∈ l) :=
  Classical.propDecidable _

omit [Fintype P] in
/-- Secant lines of an arc are exactly the images of its unordered endpoint pairs. -/
theorem secants_eq_image_pairLine {A : Finset P} :
    secants (L := L) A = Finset.univ.image (ArcPair.line (L := L) : ArcPair A → L) := by
  classical
  ext l
  simp only [mem_secants, Finset.mem_image, Finset.mem_univ, true_and]
  constructor
  · rintro ⟨a, ha, b, hb, hab, hal, hbl⟩
    let e : ArcPair A := ⟨{a, b}, by
      rw [Finset.mem_powersetCard]
      refine ⟨?_, by simp [hab]⟩
      intro p hp
      simp only [Finset.mem_insert, Finset.mem_singleton] at hp
      rcases hp with rfl | rfl
      · exact ha
      · exact hb⟩
    refine ⟨e, ?_⟩
    apply e.line_unique
    intro p hp
    simp only [e, Finset.mem_insert, Finset.mem_singleton] at hp
    rcases hp with rfl | rfl
    · exact hal
    · exact hbl
  · rintro ⟨e, rfl⟩
    obtain ⟨a, b, hab, he⟩ := e.exists_eq_pair
    exact ⟨a, e.subset (by simp [he]), b, e.subset (by simp [he]), hab,
      e.mem_line (by simp [he]), e.mem_line (by simp [he])⟩

omit [Fintype P] in
theorem card_secants {A : Finset P} (hA : Arc (L := L) A) :
    (secants (L := L) A).card = Nat.choose A.card 2 := by
  classical
  rw [secants_eq_image_pairLine (L := L),
    Finset.card_image_of_injOn (ArcPair.line_injective (L := L) hA).injOn,
    Finset.card_univ]
  change Fintype.card ↥(A.powersetCard 2) = Nat.choose A.card 2
  rw [Fintype.card_coe, Finset.card_powersetCard]

omit [Fintype P] [DecidableEq P] in
theorem card_arcPair (A : Finset P) :
    Fintype.card (ArcPair A) = Nat.choose A.card 2 := by
  change Fintype.card ↥(A.powersetCard 2) = Nat.choose A.card 2
  rw [Fintype.card_coe, Finset.card_powersetCard]

/-- Endpoint pairs whose secant passes through `x`. -/
noncomputable def pairsThrough (A : Finset P) (x : P) : Finset (ArcPair A) := by
  classical
  exact Finset.univ.filter fun e => x ∈ e.line (L := L)

omit [Fintype P] [Fintype L] [DecidableEq L] in
@[simp] theorem mem_pairsThrough {A : Finset P} {x : P} {e : ArcPair A} :
    e ∈ pairsThrough (L := L) A x ↔ x ∈ e.line (L := L) := by
  classical
  simp [pairsThrough]

omit [Fintype P] in
/-- The line-based point index equals the number of unordered endpoint pairs through the point. -/
theorem pointIndex_eq_card_pairsThrough {A : Finset P} (hA : Arc (L := L) A) (x : P) :
    pointIndex (L := L) A x = (pairsThrough (L := L) A x).card := by
  classical
  rw [pointIndex, secants_eq_image_pairLine (L := L), Finset.filter_image,
    Finset.card_image_of_injOn (ArcPair.line_injective (L := L) hA).injOn]
  rfl

omit [Fintype P] [Fintype L] [DecidableEq L] in
theorem pairsThrough_pairwiseDisjoint {A : Finset P} (hA : Arc (L := L) A)
    {x : P} (hx : x ∉ A) :
    ((pairsThrough (L := L) A x : Finset (ArcPair A)) : Set (ArcPair A)).PairwiseDisjoint
      fun e => e.1 := by
  intro e he f hf hef
  change Disjoint e.1 f.1
  rw [Finset.disjoint_left]
  intro p hpe hpf
  have hxe : x ∈ e.line (L := L) := mem_pairsThrough.mp he
  have hxf : x ∈ f.line (L := L) := mem_pairsThrough.mp hf
  have hxp : x ≠ p := fun h => hx (h ▸ e.subset hpe)
  have hlines : e.line (L := L) = f.line (L := L) :=
    (Configuration.Nondegenerate.eq_or_eq hxe (e.mem_line hpe) hxf (f.mem_line hpf)).resolve_left hxp
  exact hef (ArcPair.line_injective (L := L) hA hlines)

omit [Fintype P] in
/-- No external point lies on more than `floor (|A|/2)` secants of an arc. -/
theorem pointIndex_le_half_card {A : Finset P} (hA : Arc (L := L) A)
    {x : P} (hx : x ∉ A) :
    pointIndex (L := L) A x ≤ A.card / 2 := by
  classical
  let E := pairsThrough (L := L) A x
  let U := E.biUnion fun e => e.1
  have hUsub : U ⊆ A := by
    intro p hp
    obtain ⟨e, he, hpe⟩ := Finset.mem_biUnion.mp hp
    exact e.subset hpe
  have hUcard : U.card = 2 * E.card := by
    change (E.biUnion fun e => e.1).card = 2 * E.card
    have hdisj : ((E : Finset (ArcPair A)) : Set (ArcPair A)).PairwiseDisjoint
        fun e => e.1 := by
      simpa [E] using pairsThrough_pairwiseDisjoint (L := L) hA hx
    rw [Finset.card_biUnion hdisj]
    calc
      (∑ e ∈ E, e.1.card) = ∑ _e ∈ E, 2 := by
        apply Finset.sum_congr rfl
        intro e _he
        exact e.card
      _ = 2 * E.card := by simp [Nat.mul_comm]
  rw [pointIndex_eq_card_pairsThrough hA, Nat.le_div_iff_mul_le (by omega)]
  change E.card * 2 ≤ A.card
  have hle := Finset.card_le_card hUsub
  omega

/-- The point set incident with a line. -/
noncomputable def pointsOnLine (l : L) : Finset P := by
  classical
  exact Finset.univ.filter fun p => p ∈ l

omit [Fintype L] [DecidableEq P] [DecidableEq L] [Configuration.ProjectivePlane P L] in
@[simp] theorem mem_pointsOnLine {l : L} {p : P} :
    p ∈ pointsOnLine (P := P) l ↔ p ∈ l := by
  classical
  simp [pointsOnLine]

omit [DecidableEq P] [DecidableEq L] in
theorem card_pointsOnLine (l : L) :
    (pointsOnLine (P := P) l).card = PlaneOrder P L + 1 := by
  classical
  rw [pointsOnLine, ← Fintype.card_subtype (fun p : P => p ∈ l),
    ← Nat.card_eq_fintype_card]
  exact card_points_on_line l

omit [Fintype L] [DecidableEq L] in
theorem pointsOnPairLine_inter_arc {A : Finset P} (hA : Arc (L := L) A)
    (e : ArcPair A) :
    pointsOnLine (P := P) (e.line (L := L)) ∩ A = e.1 := by
  ext p
  simp only [Finset.mem_inter, mem_pointsOnLine]
  constructor
  · rintro ⟨hpl, hpA⟩
    exact e.mem_of_mem_arc_of_mem_line hA hpA hpl
  · intro hpe
    exact ⟨e.mem_line hpe, e.subset hpe⟩

omit [DecidableEq L] in
theorem card_external_pointsOnPairLine {A : Finset P} (hA : Arc (L := L) A)
    (e : ArcPair A) :
    (pointsOnLine (P := P) (e.line (L := L)) \ A).card = PlaneOrder P L - 1 := by
  rw [Finset.card_sdiff, Finset.inter_comm, pointsOnPairLine_inter_arc hA e,
    e.card, card_pointsOnLine]
  have hq := Configuration.ProjectivePlane.one_lt_order P L
  omega

omit [Fintype P] [Fintype L] [DecidableEq L] in
theorem card_pairsThrough_eq_sum_indicator {A : Finset P} (x : P) :
    (pairsThrough (L := L) A x).card =
      ∑ e : ArcPair A, if x ∈ e.line (L := L) then 1 else 0 := by
  classical
  rw [pairsThrough]
  rw [Finset.sum_ite, Finset.sum_const_zero, add_zero, Finset.card_eq_sum_ones]

omit [Fintype L] [DecidableEq L] [Configuration.ProjectivePlane P L] in
theorem card_external_pointsOnLine_eq_sum_indicator (A : Finset P) (l : L) :
    (pointsOnLine (P := P) l \ A).card =
      ∑ x ∈ (Finset.univ \ A), if x ∈ l then 1 else 0 := by
  classical
  have heq : pointsOnLine (P := P) l \ A =
      (Finset.univ \ A).filter fun x => x ∈ l := by
    ext x
    simp [pointsOnLine, and_comm]
  rw [heq]
  rw [Finset.card_eq_sum_ones, Finset.sum_ite, Finset.sum_const_zero, add_zero]

/-- The classical first secant-index equation. -/
theorem first_secant_moment {A : Finset P} (hA : Arc (L := L) A) :
    (∑ x ∈ (Finset.univ \ A), pointIndex (L := L) A x) =
      Nat.choose A.card 2 * (PlaneOrder P L - 1) := by
  classical
  calc
    (∑ x ∈ (Finset.univ \ A), pointIndex (L := L) A x) =
        ∑ x ∈ (Finset.univ \ A),
          ∑ e : ArcPair A, if x ∈ e.line (L := L) then 1 else 0 := by
            apply Finset.sum_congr rfl
            intro x _hx
            rw [pointIndex_eq_card_pairsThrough hA,
              card_pairsThrough_eq_sum_indicator]
    _ = ∑ e : ArcPair A, ∑ x ∈ (Finset.univ \ A),
          if x ∈ e.line (L := L) then 1 else 0 := by
            rw [Finset.sum_comm]
    _ = ∑ e : ArcPair A,
          (pointsOnLine (P := P) (e.line (L := L)) \ A).card := by
            apply Finset.sum_congr rfl
            intro e _he
            rw [card_external_pointsOnLine_eq_sum_indicator]
    _ = ∑ _e : ArcPair A, (PlaneOrder P L - 1) := by
            apply Finset.sum_congr rfl
            intro e _he
            exact card_external_pointsOnPairLine hA e
    _ = Nat.choose A.card 2 * (PlaneOrder P L - 1) := by
            simp

/-- Endpoint pairs disjoint from a fixed endpoint pair. -/
noncomputable def disjointPartners (A : Finset P) (e : ArcPair A) : Finset (ArcPair A) := by
  classical
  exact Finset.univ.filter fun f => Disjoint e.1 f.1

omit [Fintype P] in
@[simp] theorem mem_disjointPartners {A : Finset P} {e f : ArcPair A} :
    f ∈ disjointPartners A e ↔ Disjoint e.1 f.1 := by
  classical
  simp [disjointPartners]

omit [Fintype P] in
theorem powersetCard_filter_disjoint (A : Finset P) (e : ArcPair A) :
    (A.powersetCard 2).filter (Disjoint e.1) = (A \ e.1).powersetCard 2 := by
  ext f
  simp only [Finset.mem_filter, Finset.mem_powersetCard]
  constructor
  · rintro ⟨⟨hfA, hfcard⟩, hdisj⟩
    refine ⟨?_, hfcard⟩
    intro p hpf
    exact Finset.mem_sdiff.mpr
      ⟨hfA hpf, fun hpe => (Finset.disjoint_left.mp hdisj) hpe hpf⟩
  · rintro ⟨hfsub, hfcard⟩
    refine ⟨⟨hfsub.trans Finset.sdiff_subset, hfcard⟩, ?_⟩
    rw [Finset.disjoint_left]
    intro p hpe hpf
    exact (Finset.mem_sdiff.mp (hfsub hpf)).2 hpe

omit [Fintype P] in
theorem card_disjointPartners (A : Finset P) (e : ArcPair A) :
    (disjointPartners A e).card = Nat.choose (A.card - 2) 2 := by
  classical
  let val : ArcPair A → Finset P := fun f => f.1
  have hval : Function.Injective val := fun _ _ h => Subtype.ext h
  have himage : Finset.univ.image val = A.powersetCard 2 := by
    ext f
    simp [val, ArcPair]
  calc
    (disjointPartners A e).card =
        ((Finset.univ.image val).filter (Disjoint e.1)).card := by
          rw [Finset.filter_image]
          rw [Finset.card_image_of_injOn hval.injOn]
          rfl
    _ = ((A.powersetCard 2).filter (Disjoint e.1)).card := by rw [himage]
    _ = ((A \ e.1).powersetCard 2).card := by rw [powersetCard_filter_disjoint]
    _ = Nat.choose (A.card - 2) 2 := by
          rw [Finset.card_powersetCard, Finset.card_sdiff_of_subset e.subset, e.card]

/-- Ordered disjoint endpoint-pair pairs. -/
noncomputable def disjointOrderedPairs (A : Finset P) : Finset (ArcPair A × ArcPair A) := by
  classical
  exact Finset.univ.biUnion fun e =>
    (disjointPartners A e).image fun f => (e, f)

omit [Fintype P] in
@[simp] theorem mem_disjointOrderedPairs {A : Finset P} {e f : ArcPair A} :
    (e, f) ∈ disjointOrderedPairs A ↔ Disjoint e.1 f.1 := by
  classical
  simp [disjointOrderedPairs]

omit [Fintype P] in
theorem card_disjointOrderedPairs (A : Finset P) :
    (disjointOrderedPairs A).card =
      Nat.choose A.card 2 * Nat.choose (A.card - 2) 2 := by
  classical
  have hdisj : ((Finset.univ : Finset (ArcPair A)) : Set (ArcPair A)).PairwiseDisjoint
      (fun e => (disjointPartners A e).image fun f => (e, f)) := by
    intro e _he f _hf hef
    change Disjoint
      ((disjointPartners A e).image fun g => (e, g))
      ((disjointPartners A f).image fun g => (f, g))
    rw [Finset.disjoint_left]
    rintro z hze hzf
    obtain ⟨g, _hg, hzg⟩ := Finset.mem_image.mp hze
    obtain ⟨h, _hh, hzh⟩ := Finset.mem_image.mp hzf
    exact hef (congrArg Prod.fst (hzg.trans hzh.symm))
  rw [disjointOrderedPairs, Finset.card_biUnion hdisj]
  calc
    (∑ e : ArcPair A, ((disjointPartners A e).image fun f => (e, f)).card) =
        ∑ e : ArcPair A, (disjointPartners A e).card := by
          apply Finset.sum_congr rfl
          intro e _he
          rw [Finset.card_image_of_injective]
          intro f g hfg
          exact congrArg Prod.snd hfg
    _ = ∑ _e : ArcPair A, Nat.choose (A.card - 2) 2 := by
          apply Finset.sum_congr rfl
          intro e _he
          exact card_disjointPartners A e
    _ = Nat.choose A.card 2 * Nat.choose (A.card - 2) 2 := by
          simp

/-- Ordered pairs of distinct secants through `x`, represented by their endpoint pairs. -/
noncomputable def orderedPairsThrough (A : Finset P) (x : P) :
    Finset (ArcPair A × ArcPair A) := by
  classical
  exact (pairsThrough (L := L) A x).offDiag

omit [Fintype P] [Fintype L] [DecidableEq L] in
@[simp] theorem mem_orderedPairsThrough {A : Finset P} {x : P} {e f : ArcPair A} :
    (e, f) ∈ orderedPairsThrough (L := L) A x ↔
      x ∈ e.line (L := L) ∧ x ∈ f.line (L := L) ∧ e ≠ f := by
  classical
  rw [orderedPairsThrough, Finset.mem_offDiag]
  simp only [mem_pairsThrough]

omit [Fintype P] in
theorem card_orderedPairsThrough {A : Finset P} (hA : Arc (L := L) A) (x : P) :
    (orderedPairsThrough (L := L) A x).card =
      pointIndex (L := L) A x * (pointIndex (L := L) A x - 1) := by
  rw [orderedPairsThrough, Finset.offDiag_card, pointIndex_eq_card_pairsThrough hA]
  rw [Nat.mul_sub_left_distrib]
  simp

/-- The disjoint union of ordered secant-pair fibers over external intersection points. -/
noncomputable def externalOrderedPairs (A : Finset P) : Finset (ArcPair A × ArcPair A) := by
  classical
  exact (Finset.univ \ A).biUnion fun x => orderedPairsThrough (L := L) A x

omit [Fintype L] [DecidableEq L] in
theorem orderedPairsThrough_pairwiseDisjoint {A : Finset P} (hA : Arc (L := L) A) :
    (((Finset.univ \ A : Finset P) : Set P).PairwiseDisjoint
      fun x => orderedPairsThrough (L := L) A x) := by
  intro x _hx y _hy hxy
  change Disjoint (orderedPairsThrough (L := L) A x) (orderedPairsThrough (L := L) A y)
  rw [Finset.disjoint_left]
  intro z hzx hzy
  obtain ⟨e, f⟩ := z
  have hxmem := mem_orderedPairsThrough.mp hzx
  have hymem := mem_orderedPairsThrough.mp hzy
  have hlines : e.line (L := L) ≠ f.line (L := L) := fun h =>
    hxmem.2.2 (ArcPair.line_injective (L := L) hA h)
  exact hxy ((Configuration.Nondegenerate.eq_or_eq
    hxmem.1 hymem.1 hxmem.2.1 hymem.2.1).resolve_right hlines)

omit [Fintype L] [DecidableEq L] in
theorem externalOrderedPairs_eq_disjointOrderedPairs {A : Finset P}
    (hA : Arc (L := L) A) :
    externalOrderedPairs (L := L) A = disjointOrderedPairs A := by
  classical
  ext z
  obtain ⟨e, f⟩ := z
  constructor
  · intro hz
    obtain ⟨x, hxext, hzthrough⟩ := Finset.mem_biUnion.mp hz
    have hxA : x ∉ A := (Finset.mem_sdiff.mp hxext).2
    have hthrough := mem_orderedPairsThrough.mp hzthrough
    apply mem_disjointOrderedPairs.mpr
    exact pairsThrough_pairwiseDisjoint (L := L) hA hxA
      (mem_pairsThrough.mpr hthrough.1) (mem_pairsThrough.mpr hthrough.2.1) hthrough.2.2
  · intro hz
    have hdisj : Disjoint e.1 f.1 := mem_disjointOrderedPairs.mp hz
    have hef : e ≠ f := by
      intro hef
      subst f
      obtain ⟨a, b, hab, he⟩ := e.exists_eq_pair
      have hae : a ∈ e.1 := by simp [he]
      exact (Finset.disjoint_left.mp hdisj) hae hae
    have hlines : e.line (L := L) ≠ f.line (L := L) := fun h =>
      hef (ArcPair.line_injective (L := L) hA h)
    let x : P := Configuration.HasPoints.mkPoint (P := P) (L := L) hlines
    have hxlines := Configuration.HasPoints.mkPoint_ax (P := P) (L := L) hlines
    have hxA : x ∉ A := by
      intro hxA
      have hxe : x ∈ e.1 := e.mem_of_mem_arc_of_mem_line hA hxA hxlines.1
      have hxf : x ∈ f.1 := f.mem_of_mem_arc_of_mem_line hA hxA hxlines.2
      exact (Finset.disjoint_left.mp hdisj) hxe hxf
    apply Finset.mem_biUnion.mpr
    refine ⟨x, Finset.mem_sdiff.mpr ⟨Finset.mem_univ _, hxA⟩, ?_⟩
    exact mem_orderedPairsThrough.mpr ⟨hxlines.1, hxlines.2, hef⟩

theorem card_externalOrderedPairs {A : Finset P} (hA : Arc (L := L) A) :
    (externalOrderedPairs (L := L) A).card =
      ∑ x ∈ (Finset.univ \ A),
        pointIndex (L := L) A x * (pointIndex (L := L) A x - 1) := by
  rw [externalOrderedPairs,
    Finset.card_biUnion (orderedPairsThrough_pairwiseDisjoint (L := L) hA)]
  apply Finset.sum_congr rfl
  intro x _hx
  exact card_orderedPairsThrough hA x

theorem two_mul_choose_two (n : ℕ) :
    2 * Nat.choose n 2 = n * (n - 1) := by
  have h := Nat.choose_succ_right_eq n 1
  simpa [Nat.mul_comm] using h

theorem choose_two_mul_choose_sub_two (n : ℕ) :
    Nat.choose n 2 * Nat.choose (n - 2) 2 = 6 * Nat.choose n 4 := by
  have h := Nat.choose_mul (n := n) (k := 4) (s := 2) (by omega)
  norm_num [Nat.choose] at h
  simpa [Nat.mul_comm] using h.symm

/-- The classical second secant-index equation. -/
theorem second_secant_moment {A : Finset P} (hA : Arc (L := L) A) :
    (∑ x ∈ (Finset.univ \ A), Nat.choose (pointIndex (L := L) A x) 2) =
      3 * Nat.choose A.card 4 := by
  apply Nat.mul_left_cancel (by omega : 0 < 2)
  calc
    2 * (∑ x ∈ (Finset.univ \ A), Nat.choose (pointIndex (L := L) A x) 2) =
        ∑ x ∈ (Finset.univ \ A),
          pointIndex (L := L) A x * (pointIndex (L := L) A x - 1) := by
            rw [Finset.mul_sum]
            apply Finset.sum_congr rfl
            intro x _hx
            exact two_mul_choose_two (pointIndex (L := L) A x)
    _ = (externalOrderedPairs (L := L) A).card :=
          (card_externalOrderedPairs hA).symm
    _ = (disjointOrderedPairs A).card := by
          rw [externalOrderedPairs_eq_disjointOrderedPairs hA]
    _ = Nat.choose A.card 2 * Nat.choose (A.card - 2) 2 :=
          card_disjointOrderedPairs A
    _ = 6 * Nat.choose A.card 4 := choose_two_mul_choose_sub_two A.card
    _ = 2 * (3 * Nat.choose A.card 4) := by ring

end FinitePlane

end RelativeConicArcs
