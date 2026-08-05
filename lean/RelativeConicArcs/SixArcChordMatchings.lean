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

Both directions are incidence-theoretic and hold in an arbitrary finite projective plane; neither
coordinates nor a hypothesis on the characteristic enters.  Injectivity uses that two distinct
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

end SixArcChordMatchings
end RelativeConicArcs
