import RelativeConicArcs.SixArcConcurrence

/-!
# Triple-concurrence points and concurrent chord matchings of a six-arc

Let `A` be a six-arc in a projective plane.  A *chord matching* of `A` is a set of three chords of
`A` — three two-element subsets, each carried by the unique line through its endpoints — whose
endpoint pairs are pairwise disjoint, so that they partition the six points of `A`.  A chord
matching is *concurrent* when some point of the plane lies on all three of its lines.

This file identifies the triple-concurrence points of `A`, the off-arc points lying on three
secants, with the concurrent chord matchings: sending such a point to the set of chords through it
is a bijection onto the concurrent chord matchings.  Consequently the two sets have the same
cardinality, so counting the triple-concurrence points of a six-arc is counting its concurrent
chord matchings.

A second section collects the chord-level combinatorics used to construct and recognize chord
matchings: existence of the chord on two distinct points of `A`, the chord matching formed by three
chords with pairwise disjoint endpoint pairs, and the fact that a chord matching of a six-element
set containing two given chords consists of those two and the chord on the two remaining points.
These statements involve no incidence structure.

Both directions of the bijection are incidence-theoretic and hold in an arbitrary finite projective
plane; neither coordinates nor a hypothesis on the characteristic enters.  Injectivity uses that two distinct
chords through two distinct points would force both points onto one line meeting the arc four
times, and surjectivity uses that the concurrence point of a chord matching cannot itself lie on
the arc, so that the bound of three secants through an off-arc point of a six-arc applies to it.
-/

namespace RelativeConicArcs
namespace SixArcChordMatchings

open Finset Configuration

section Plane

variable {P L : Type*} [Membership P L] [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

noncomputable local instance instDecidableIncidence (p : P) (l : L) : Decidable (p ∈ l) :=
  Classical.propDecidable _

/-- A chord matching of `A`: three chords of `A` with pairwise disjoint endpoint pairs.  For a
six-arc the three pairs then partition `A`. -/
def IsChordMatching (A : Finset P) (M : Finset (ArcPair A)) : Prop :=
  M.card = 3 ∧ (M : Set (ArcPair A)).PairwiseDisjoint fun e => e.1

/-- A chord matching is concurrent at `x` when all three of its chords pass through `x`. -/
def ConcurrentAt (A : Finset P) (M : Finset (ArcPair A)) (x : P) : Prop :=
  ∀ e ∈ M, x ∈ e.line (L := L)

/-- The chord matchings of `A` whose three chords share a point. -/
noncomputable def concurrentMatchings (A : Finset P) : Finset (Finset (ArcPair A)) := by
  classical
  exact Finset.univ.filter fun M =>
    IsChordMatching A M ∧ ∃ x : P, ConcurrentAt (L := L) A M x

omit [Fintype L] [DecidableEq L] in
/-- Membership in the finite set of concurrent chord matchings: three chords with pairwise disjoint
endpoint pairs, all passing through a common point of the plane. -/
theorem mem_concurrentMatchings {A : Finset P} {M : Finset (ArcPair A)} :
    M ∈ concurrentMatchings (L := L) A ↔
      IsChordMatching A M ∧ ∃ x : P, ConcurrentAt (L := L) A M x := by
  classical
  simp [concurrentMatchings]

omit [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L] in
/-- Two lines through the same two distinct points coincide. -/
private theorem line_eq_of_two_points {l m : L} {x y : P} (hxy : x ≠ y)
    (hxl : x ∈ l) (hyl : y ∈ l) (hxm : x ∈ m) (hym : y ∈ m) : l = m := by
  obtain ⟨n, _hn, huniq⟩ := Configuration.HasLines.existsUnique_line (P := P) (L := L) x y hxy
  rw [huniq l ⟨hxl, hyl⟩, huniq m ⟨hxm, hym⟩]

/-- The chords through a triple-concurrence point of a six-arc form a chord matching. -/
theorem isChordMatching_pairsThrough {A : Finset P} (hA : Arc (L := L) A)
    {x : P} (hx : x ∈ SixArcConcurrence.triplePoints (L := L) A) :
    IsChordMatching A (pairsThrough (L := L) A x) := by
  classical
  obtain ⟨hxA, hidx⟩ := SixArcConcurrence.mem_triplePoints.mp hx
  refine ⟨?_, pairsThrough_pairwiseDisjoint (L := L) hA hxA⟩
  rw [← pointIndex_eq_card_pairsThrough (L := L) hA x]
  exact hidx

omit [Fintype P] [Fintype L] [DecidableEq L] in
/-- The chords through a point are concurrent at that point. -/
theorem concurrentAt_pairsThrough {A : Finset P} (x : P) :
    ConcurrentAt (L := L) A (pairsThrough (L := L) A x) x :=
  fun _e he => mem_pairsThrough.mp he

omit [Fintype P] in
/-- The three pairs of a chord matching of a six-arc cover the arc. -/
theorem biUnion_eq_of_isChordMatching {A : Finset P} (hcard : A.card = 6)
    {M : Finset (ArcPair A)} (hM : IsChordMatching A M) :
    (M.biUnion fun e => e.1) = A := by
  classical
  have hsub : (M.biUnion fun e => e.1) ⊆ A := by
    intro p hp
    obtain ⟨e, _he, hpe⟩ := Finset.mem_biUnion.mp hp
    exact e.subset hpe
  refine Finset.eq_of_subset_of_card_le hsub ?_
  have : (M.biUnion fun e => e.1).card = 6 := by
    rw [Finset.card_biUnion hM.2]
    calc
      (∑ e ∈ M, e.1.card) = ∑ _e ∈ M, 2 := Finset.sum_congr rfl fun e _ => e.card
      _ = 6 := by simp [Finset.sum_const, hM.1]
  omega

omit [Fintype P] [Fintype L] [DecidableEq L] in
/-- A point at which a chord matching of a six-arc is concurrent lies off the arc: it lies on two
chords whose four endpoints are distinct from it, and an arc point on a chord not through it would
put three arc points on one line. -/
theorem notMem_of_concurrentAt {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 6)
    {M : Finset (ArcPair A)} (hM : IsChordMatching A M) {x : P}
    (hx : ConcurrentAt (L := L) A M x) : x ∉ A := by
  classical
  intro hxA
  have hxU : x ∈ M.biUnion fun e => e.1 := by
    rw [biUnion_eq_of_isChordMatching hcard hM]; exact hxA
  obtain ⟨e, heM, hxe⟩ := Finset.mem_biUnion.mp hxU
  -- a second chord of the matching, which therefore misses `x`
  obtain ⟨f, hfM, hfe⟩ : ∃ f ∈ M, f ≠ e := by
    have h1 : 1 < M.card := by rw [hM.1]; omega
    obtain ⟨a, ha, b, hb, hab⟩ := Finset.one_lt_card.mp h1
    by_cases h : a = e
    · exact ⟨b, hb, fun hbe => hab (by rw [h, hbe])⟩
    · exact ⟨a, ha, h⟩
  have hxf : x ∉ f.1 := fun hmem =>
    Finset.disjoint_left.mp (hM.2 hfM heM hfe) hmem hxe
  obtain ⟨p, q, hpq, hfpq⟩ := f.exists_eq_pair
  have hpf : p ∈ f.1 := by rw [hfpq]; simp
  have hqf : q ∈ f.1 := by rw [hfpq]; simp
  have hxp : x ≠ p := fun h => hxf (h ▸ hpf)
  have hxq : x ≠ q := fun h => hxf (h ▸ hqf)
  exact hA hxA (f.subset hpf) (f.subset hqf) hxp hxq hpq
    ⟨f.line (L := L), hx f hfM, f.mem_line hpf, f.mem_line hqf⟩

/-- A chord matching of a six-arc concurrent at `x` consists of exactly the chords through `x`, and
`x` is a triple-concurrence point of the arc. -/
theorem triplePoint_of_concurrentAt {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 6)
    {M : Finset (ArcPair A)} (hM : IsChordMatching A M) {x : P}
    (hx : ConcurrentAt (L := L) A M x) :
    x ∈ SixArcConcurrence.triplePoints (L := L) A ∧ pairsThrough (L := L) A x = M := by
  classical
  have hxA : x ∉ A := notMem_of_concurrentAt (L := L) hA hcard hM hx
  have hsub : M ⊆ pairsThrough (L := L) A x := fun e he => mem_pairsThrough.mpr (hx e he)
  have hle : (pairsThrough (L := L) A x).card ≤ 3 := by
    have := pointIndex_le_half_card (L := L) hA hxA
    rw [pointIndex_eq_card_pairsThrough (L := L) hA x, hcard] at this
    simpa using this
  have heq : pairsThrough (L := L) A x = M :=
    (Finset.eq_of_subset_of_card_le hsub (by rw [hM.1]; exact hle)).symm
  refine ⟨SixArcConcurrence.mem_triplePoints.mpr ⟨hxA, ?_⟩, heq⟩
  rw [pointIndex_eq_card_pairsThrough (L := L) hA x, heq, hM.1]

/-- Distinct triple-concurrence points of a six-arc carry different chord matchings: two chords
through both points would both be the line joining them, putting four arc points on one line. -/
theorem eq_of_pairsThrough_eq {A : Finset P} (hA : Arc (L := L) A)
    {x y : P} (hx : x ∈ SixArcConcurrence.triplePoints (L := L) A)
    (hxy : pairsThrough (L := L) A x = pairsThrough (L := L) A y) : x = y := by
  classical
  by_contra hne
  have hcardx : (pairsThrough (L := L) A x).card = 3 :=
    (isChordMatching_pairsThrough (L := L) hA hx).1
  obtain ⟨e, he, f, hf, hef⟩ := Finset.one_lt_card.mp (by rw [hcardx]; omega)
  have hxe : x ∈ e.line (L := L) := mem_pairsThrough.mp he
  have hxf : x ∈ f.line (L := L) := mem_pairsThrough.mp hf
  have hye : y ∈ e.line (L := L) := mem_pairsThrough.mp (by rw [← hxy]; exact he)
  have hyf : y ∈ f.line (L := L) := mem_pairsThrough.mp (by rw [← hxy]; exact hf)
  exact hef (ArcPair.line_injective (L := L) hA
    (line_eq_of_two_points (L := L) hne hxe hye hxf hyf))

/-- **The chord-pairing bijection.**  For a six-arc, sending a triple-concurrence point to the set
of chords through it is a bijection onto the concurrent chord matchings, so the two sets have the
same cardinality. -/
theorem card_concurrentMatchings_eq_card_triplePoints {A : Finset P} (hA : Arc (L := L) A)
    (hcard : A.card = 6) :
    (concurrentMatchings (L := L) A).card =
      (SixArcConcurrence.triplePoints (L := L) A).card := by
  classical
  refine (Finset.card_bij (fun x _ => pairsThrough (L := L) A x) ?_ ?_ ?_).symm
  · intro x hx
    exact mem_concurrentMatchings.mpr
      ⟨isChordMatching_pairsThrough (L := L) hA hx, x, concurrentAt_pairsThrough (L := L) x⟩
  · intro x hx y _hy hxy
    exact eq_of_pairsThrough_eq (L := L) hA hx hxy
  · intro M hM
    obtain ⟨hmatch, x, hconc⟩ := mem_concurrentMatchings.mp hM
    obtain ⟨hxtriple, heq⟩ := triplePoint_of_concurrentAt (L := L) hA hcard hmatch hconc
    exact ⟨x, hxtriple, heq⟩

end Plane

section ChordCombinatorics

variable {P : Type*} [DecidableEq P]

/-- Two distinct points of `A` are the endpoint pair of a chord of `A`. -/
theorem exists_arcPair_val {A : Finset P} {a b : P} (ha : a ∈ A) (hb : b ∈ A) (hab : a ≠ b) :
    ∃ e : ArcPair A, e.1 = {a, b} := by
  refine ⟨⟨{a, b}, ?_⟩, rfl⟩
  rw [Finset.mem_powersetCard]
  refine ⟨?_, Finset.card_pair hab⟩
  intro p hp
  simp only [Finset.mem_insert, Finset.mem_singleton] at hp
  rcases hp with rfl | rfl
  · exact ha
  · exact hb

omit [DecidableEq P] in
/-- Two chords with disjoint endpoint pairs are distinct. -/
theorem ne_of_disjoint_val {A : Finset P} {e f : ArcPair A} (hef : Disjoint e.1 f.1) : e ≠ f := by
  intro h
  obtain ⟨p, hp⟩ : e.1.Nonempty := Finset.card_pos.mp (by rw [e.card]; norm_num)
  exact Finset.disjoint_left.mp hef hp (h ▸ hp)

/-- Three chords with pairwise disjoint endpoint pairs form a chord matching. -/
theorem isChordMatching_triple {A : Finset P} {e f g : ArcPair A}
    (hef : Disjoint e.1 f.1) (heg : Disjoint e.1 g.1) (hfg : Disjoint f.1 g.1) :
    IsChordMatching A ({e, f, g} : Finset (ArcPair A)) := by
  classical
  refine ⟨?_, ?_⟩
  · rw [Finset.card_insert_of_notMem (by simp [ne_of_disjoint_val hef, ne_of_disjoint_val heg]),
      Finset.card_insert_of_notMem (by simp [ne_of_disjoint_val hfg]), Finset.card_singleton]
  · intro x hx y hy hxy
    simp only [Finset.coe_insert, Set.mem_insert_iff, Finset.coe_singleton,
      Set.mem_singleton_iff] at hx hy
    rcases hx with rfl | rfl | rfl <;> rcases hy with rfl | rfl | rfl <;>
      first
        | exact absurd rfl hxy
        | exact hef
        | exact heg
        | exact hfg
        | exact hef.symm
        | exact heg.symm
        | exact hfg.symm

/-- A chord matching of a six-element set that contains two given chords consists of those two and
the chord on the two remaining points. -/
theorem eq_triple_of_mem {A : Finset P} (hcard : A.card = 6)
    {M : Finset (ArcPair A)} (hM : IsChordMatching A M) {e f g : ArcPair A}
    (he : e ∈ M) (hf : f ∈ M) (hef : e ≠ f) (hg : g.1 = A \ (e.1 ∪ f.1)) :
    M = {e, f, g} := by
  classical
  have hsub : ({e, f} : Finset (ArcPair A)) ⊆ M := by
    intro x hx
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl
    · exact he
    · exact hf
  have hone : (M \ {e, f}).card = 1 := by
    rw [Finset.card_sdiff_of_subset hsub, hM.1, Finset.card_pair hef]
  obtain ⟨g', hg'⟩ := Finset.card_eq_one.mp hone
  have hg'mem : g' ∈ M \ {e, f} := by rw [hg']; exact Finset.mem_singleton_self g'
  have hg'M : g' ∈ M := (Finset.mem_sdiff.mp hg'mem).1
  have hg'ef : g' ∉ ({e, f} : Finset (ArcPair A)) := (Finset.mem_sdiff.mp hg'mem).2
  have hg'e : g' ≠ e := fun h => hg'ef (by rw [h]; simp)
  have hg'f : g' ≠ f := fun h => hg'ef (by rw [h]; simp)
  have hMeq : M = {e, f, g'} := by
    rw [← Finset.union_sdiff_of_subset hsub, hg']
    ext x
    simp only [Finset.mem_union, Finset.mem_insert, Finset.mem_singleton]
    tauto
  have hg'val : g'.1 = A \ (e.1 ∪ f.1) := by
    apply Finset.Subset.antisymm
    · intro p hp
      refine Finset.mem_sdiff.mpr ⟨g'.subset hp, ?_⟩
      intro hpef
      rcases Finset.mem_union.mp hpef with hpe | hpf
      · exact Finset.disjoint_left.mp (hM.2 hg'M he hg'e) hp hpe
      · exact Finset.disjoint_left.mp (hM.2 hg'M hf hg'f) hp hpf
    · intro p hp
      obtain ⟨hpA, hpef⟩ := Finset.mem_sdiff.mp hp
      have hpU : p ∈ M.biUnion fun c => c.1 := by
        rw [biUnion_eq_of_isChordMatching hcard hM]; exact hpA
      obtain ⟨c, hcM, hpc⟩ := Finset.mem_biUnion.mp hpU
      rw [hMeq] at hcM
      simp only [Finset.mem_insert, Finset.mem_singleton] at hcM
      rcases hcM with rfl | rfl | rfl
      · exact absurd (Finset.mem_union_left _ hpc) hpef
      · exact absurd (Finset.mem_union_right _ hpc) hpef
      · exact hpc
  have hgg' : g' = g := Subtype.ext (by rw [hg'val, hg])
  rw [hMeq, hgg']

/-- The chord of a chord matching of a six-element set through a given point, described by that
point and its partner. -/
theorem exists_mem_val_pair {A : Finset P} (hcard : A.card = 6)
    {M : Finset (ArcPair A)} (hM : IsChordMatching A M) {p : P} (hp : p ∈ A) :
    ∃ (e : ArcPair A) (q : P), e ∈ M ∧ q ≠ p ∧ e.1 = {p, q} := by
  classical
  have hpU : p ∈ M.biUnion fun c => c.1 := by
    rw [biUnion_eq_of_isChordMatching hcard hM]; exact hp
  obtain ⟨e, heM, hpe⟩ := Finset.mem_biUnion.mp hpU
  obtain ⟨s, t, hst, hevalue⟩ := e.exists_eq_pair
  obtain ⟨q, hq, hqp⟩ : ∃ q ∈ e.1, q ≠ p := by
    rw [hevalue] at hpe ⊢
    simp only [Finset.mem_insert, Finset.mem_singleton] at hpe
    rcases hpe with rfl | rfl
    · exact ⟨t, by simp, fun h => hst h.symm⟩
    · exact ⟨s, by simp, hst⟩
  refine ⟨e, q, heM, hqp, ?_⟩
  refine (Finset.eq_of_subset_of_card_le ?_ ?_).symm
  · intro r hr
    simp only [Finset.mem_insert, Finset.mem_singleton] at hr
    rcases hr with rfl | rfl
    · exact hpe
    · exact hq
  · simp [e.card, Finset.card_pair (Ne.symm hqp)]

end ChordCombinatorics

end SixArcChordMatchings
end RelativeConicArcs
