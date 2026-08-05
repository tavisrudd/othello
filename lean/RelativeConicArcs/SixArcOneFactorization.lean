import RelativeConicArcs.SixArcChordMatchings
import RelativeConicArcs.SixArcConcurrenceBound

/-!
# The one-factorization carried by a six-arc with ten triple-concurrence points

A six-arc `A` in the projective plane over a field in which two is invertible has at most ten
triple-concurrence points, and each of its fifteen chords carries at most two of them.  This file
describes what equality forces.

Chord matchings of `A` are the sets of three chords with pairwise disjoint endpoint pairs, and each
chord of `A` lies in exactly three of them.  Counting chord–matching incidences shows that when
there are ten triple-concurrence points, hence ten concurrent chord matchings, every chord lies in
exactly two concurrent chord matchings and hence in exactly one chord matching that is not
concurrent.  The chord matchings that are not concurrent are therefore five in number and partition
the fifteen chords: they form a one-factorization of the arc's chords, and every chord matching
outside it is concurrent.

The counting statements are combinatorial and hold for any six-element point set.  Only the
per-chord bound of two, and hence the final theorem, needs the coordinate plane and the
invertibility of two.

The one-factorization produced here is the combinatorial half of the classification of the six-arcs
attaining the bound in R. H. Dye, "Hexagons, conics, \(A_5\) and \(\mathrm{PSL}_2(K)\)",
Journal of the London Mathematical Society (2) 44 (1991), 270--286,
doi:10.1112/jlms/s2-44.2.270, in the proof of Theorem 1, Section 2.3, page 275, where the five
triangles whose sides are chords of the hexagon and whose vertices are not its vertices are exactly
the chord matchings that are not concurrent.  What is established here is the partition of the chords by the non-concurrent matchings, not the projective
equivalence of the arcs attaining the bound.
-/

namespace RelativeConicArcs
namespace SixArcOneFactorization

open Finset Configuration
open SixArcChordMatchings

section Combinatorial

variable {P : Type*} [DecidableEq P]

/-- The chord matchings of `A`: sets of three chords with pairwise disjoint endpoint pairs. -/
noncomputable def matchings (A : Finset P) : Finset (Finset (ArcPair A)) := by
  classical
  exact Finset.univ.filter fun M => IsChordMatching A M

omit [DecidableEq P] in
/-- Membership in the finite set of chord matchings of `A`: three chords with pairwise disjoint
endpoint pairs. -/
@[simp] theorem mem_matchings {A : Finset P} {M : Finset (ArcPair A)} :
    M ∈ matchings A ↔ IsChordMatching A M := by
  classical
  simp [matchings]

/-- Removing two of four distinct points leaves the other two. -/
private theorem sdiff_pair_of_four {a b c d : P} (hac : a ≠ c) (had : a ≠ d) (hbc : b ≠ c)
    (hbd : b ≠ d) : ({a, b, c, d} : Finset P) \ {a, b} = {c, d} := by
  ext p
  simp only [Finset.mem_sdiff, Finset.mem_insert, Finset.mem_singleton]
  constructor
  · rintro ⟨hp, hp'⟩
    rcases hp with rfl | rfl | rfl | rfl
    · exact absurd (Or.inl rfl) hp'
    · exact absurd (Or.inr rfl) hp'
    · exact Or.inl rfl
    · exact Or.inr rfl
  · rintro (rfl | rfl)
    · exact ⟨by simp, by simp [Ne.symm hac, Ne.symm hbc]⟩
    · exact ⟨by simp, by simp [Ne.symm had, Ne.symm hbd]⟩

/-- **Each chord of a six-element set lies in exactly three chord matchings.**  Naming the four
points off the chord `a`, `b`, `c`, `d`, those matchings pair `a` with one of the other three and
join the two points left over. -/
theorem card_filter_mem_matchings {A : Finset P} (hcard : A.card = 6) (e : ArcPair A) :
    ((matchings A).filter fun M => e ∈ M).card = 3 := by
  classical
  have hQcard : (A \ e.1).card = 4 := by
    rw [Finset.card_sdiff_of_subset e.subset, hcard, e.card]
  obtain ⟨a, ha⟩ : (A \ e.1).Nonempty := Finset.card_pos.mp (by rw [hQcard]; norm_num)
  obtain ⟨b, c, d, hbc, hbd, hcd, hQ'⟩ :=
    Finset.card_eq_three.mp (show ((A \ e.1).erase a).card = 3 by
      rw [Finset.card_erase_of_mem ha, hQcard])
  have hQ : A \ e.1 = {a, b, c, d} := by
    rw [← Finset.insert_erase ha, hQ']
  have hba : b ≠ a := Finset.ne_of_mem_erase (by rw [hQ']; simp)
  have hca : c ≠ a := Finset.ne_of_mem_erase (by rw [hQ']; simp)
  have hda : d ≠ a := Finset.ne_of_mem_erase (by rw [hQ']; simp)
  have hab : a ≠ b := Ne.symm hba
  have hac : a ≠ c := Ne.symm hca
  have had : a ≠ d := Ne.symm hda
  have hpt : ∀ {p : P}, p ∈ ({a, b, c, d} : Finset P) → p ∈ A ∧ p ∉ e.1 := by
    intro p hp
    rw [← hQ] at hp
    exact Finset.mem_sdiff.mp hp
  obtain ⟨haA, hae⟩ := hpt (show a ∈ ({a, b, c, d} : Finset P) by simp)
  obtain ⟨hbA, hbe⟩ := hpt (show b ∈ ({a, b, c, d} : Finset P) by simp)
  obtain ⟨hcA, hce⟩ := hpt (show c ∈ ({a, b, c, d} : Finset P) by simp)
  obtain ⟨hdA, hde⟩ := hpt (show d ∈ ({a, b, c, d} : Finset P) by simp)
  -- the chords joining two points of `A`
  have hchord : ∀ {x y : P}, x ∈ A → y ∈ A → x ≠ y → ∃ t : ArcPair A, t.1 = {x, y} :=
    fun hx hy hxy => exists_arcPair_val hx hy hxy
  obtain ⟨eab, heab⟩ := hchord haA hbA hab
  obtain ⟨ecd, hecd⟩ := hchord hcA hdA hcd
  obtain ⟨eac, heac⟩ := hchord haA hcA hac
  obtain ⟨ebd, hebd⟩ := hchord hbA hdA hbd
  obtain ⟨ead, head⟩ := hchord haA hdA had
  obtain ⟨ebc, hebc⟩ := hchord hbA hcA hbc
  -- a chord on two points off `e` is disjoint from `e`
  have hdisje : ∀ {x y : P} {t : ArcPair A}, t.1 = {x, y} → x ∉ e.1 → y ∉ e.1 →
      Disjoint e.1 t.1 := by
    intro x y t ht hx hy
    rw [ht]
    refine Finset.disjoint_left.mpr ?_
    intro p hp hp'
    simp only [Finset.mem_insert, Finset.mem_singleton] at hp'
    rcases hp' with rfl | rfl
    · exact hx hp
    · exact hy hp
  -- two chords on four distinct points are disjoint
  have hdisjp : ∀ {w x y z : P} {s t : ArcPair A}, s.1 = {w, x} → t.1 = {y, z} →
      w ≠ y → w ≠ z → x ≠ y → x ≠ z → Disjoint s.1 t.1 := by
    intro w x y z s t hs ht hwy hwz hxy hxz
    rw [hs, ht]
    refine Finset.disjoint_left.mpr ?_
    intro p hp hp'
    simp only [Finset.mem_insert, Finset.mem_singleton] at hp hp'
    rcases hp with rfl | rfl <;> rcases hp' with rfl | rfl
    · exact hwy rfl
    · exact hwz rfl
    · exact hxy rfl
    · exact hxz rfl
  -- chords are distinguished by either endpoint
  have hnepair : ∀ {w x y z : P} {s t : ArcPair A}, s.1 = {w, x} → t.1 = {y, z} →
      x ≠ y → x ≠ z → s ≠ t := by
    intro w x y z s t hs ht hxy hxz h
    have hval : ({w, x} : Finset P) = {y, z} := by rw [← hs, ← ht, h]
    have hx : x ∈ ({y, z} : Finset P) := by rw [← hval]; simp
    simp only [Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl
    · exact hxy rfl
    · exact hxz rfl
  have hnepair' : ∀ {w x y z : P} {s t : ArcPair A}, s.1 = {w, x} → t.1 = {y, z} →
      w ≠ y → w ≠ z → s ≠ t := by
    intro w x y z s t hs ht hwy hwz h
    have hval : ({w, x} : Finset P) = {y, z} := by rw [← hs, ← ht, h]
    have hw : w ∈ ({y, z} : Finset P) := by rw [← hval]; simp
    simp only [Finset.mem_insert, Finset.mem_singleton] at hw
    rcases hw with rfl | rfl
    · exact hwy rfl
    · exact hwz rfl
  have hnee : ∀ {x y : P} {t : ArcPair A}, t.1 = {x, y} → x ∉ e.1 → t ≠ e := by
    intro x y t ht hx h
    apply hx
    rw [← h, ht]
    simp
  have hsplit : ∀ {x y : P}, A \ (e.1 ∪ ({x, y} : Finset P)) = (A \ e.1) \ {x, y} := by
    intro x y
    ext p
    simp only [Finset.mem_sdiff, Finset.mem_union]
    tauto
  have hcompl₁ : ecd.1 = A \ (e.1 ∪ eab.1) := by
    rw [hecd, heab, hsplit, hQ, sdiff_pair_of_four hac had hbc hbd]
  have hcompl₂ : ebd.1 = A \ (e.1 ∪ eac.1) := by
    rw [hebd, heac, hsplit, hQ,
      show ({a, b, c, d} : Finset P) = {a, c, b, d} by
        ext p; simp only [Finset.mem_insert, Finset.mem_singleton]; tauto,
      sdiff_pair_of_four hab had (Ne.symm hbc) hcd]
  have hcompl₃ : ebc.1 = A \ (e.1 ∪ ead.1) := by
    rw [hebc, head, hsplit, hQ,
      show ({a, b, c, d} : Finset P) = {a, d, b, c} by
        ext p; simp only [Finset.mem_insert, Finset.mem_singleton]; tauto,
      sdiff_pair_of_four hab hac (Ne.symm hbd) (Ne.symm hcd)]
  have hmatch₁ : IsChordMatching A ({e, eab, ecd} : Finset (ArcPair A)) :=
    isChordMatching_triple (hdisje heab hae hbe) (hdisje hecd hce hde)
      (hdisjp heab hecd hac had hbc hbd)
  have hmatch₂ : IsChordMatching A ({e, eac, ebd} : Finset (ArcPair A)) :=
    isChordMatching_triple (hdisje heac hae hce) (hdisje hebd hbe hde)
      (hdisjp heac hebd hab had (Ne.symm hbc) hcd)
  have hmatch₃ : IsChordMatching A ({e, ead, ebc} : Finset (ArcPair A)) :=
    isChordMatching_triple (hdisje head hae hde) (hdisje hebc hbe hce)
      (hdisjp head hebc hab hac (Ne.symm hbd) (Ne.symm hcd))
  have hset : ((matchings A).filter fun M => e ∈ M) =
      {({e, eab, ecd} : Finset (ArcPair A)), {e, eac, ebd}, {e, ead, ebc}} := by
    apply Finset.Subset.antisymm
    · intro M hMmem
      obtain ⟨hMset, heM⟩ := Finset.mem_filter.mp hMmem
      have hM := mem_matchings.mp hMset
      -- the chord of `M` through `a`
      have haU : a ∈ M.biUnion fun f => f.1 := by
        rw [biUnion_eq_of_isChordMatching hcard hM]; exact haA
      obtain ⟨f, hfM, haf⟩ := Finset.mem_biUnion.mp haU
      have hfe : f ≠ e := fun h => hae (h ▸ haf)
      obtain ⟨p, q, hpq, hfpq⟩ := f.exists_eq_pair
      obtain ⟨r, hrf, hra⟩ : ∃ r ∈ f.1, r ≠ a := by
        rw [hfpq] at haf ⊢
        simp only [Finset.mem_insert, Finset.mem_singleton] at haf
        rcases haf with rfl | rfl
        · exact ⟨q, by simp, fun h => hpq h.symm⟩
        · exact ⟨p, by simp, hpq⟩
      have hrA : r ∈ A := f.subset hrf
      have hre : r ∉ e.1 := fun hre =>
        Finset.disjoint_left.mp (hM.2 hfM heM hfe) hrf hre
      have hfval : f.1 = {a, r} := by
        refine (Finset.eq_of_subset_of_card_le ?_ ?_).symm
        · intro s hs
          simp only [Finset.mem_insert, Finset.mem_singleton] at hs
          rcases hs with rfl | rfl
          · exact haf
          · exact hrf
        · simp [f.card, Finset.card_pair (Ne.symm hra)]
      have hrQ : r ∈ ({a, b, c, d} : Finset P) := by
        rw [← hQ]; exact Finset.mem_sdiff.mpr ⟨hrA, hre⟩
      simp only [Finset.mem_insert, Finset.mem_singleton] at hrQ
      simp only [Finset.mem_insert, Finset.mem_singleton]
      rcases hrQ with rfl | rfl | rfl | rfl
      · exact absurd rfl hra
      · have hfeq : f = eab := Subtype.ext (by rw [hfval, heab])
        rw [hfeq] at hfM hfe
        exact Or.inl (eq_triple_of_mem hcard hM heM hfM (Ne.symm hfe) hcompl₁)
      · have hfeq : f = eac := Subtype.ext (by rw [hfval, heac])
        rw [hfeq] at hfM hfe
        exact Or.inr (Or.inl (eq_triple_of_mem hcard hM heM hfM (Ne.symm hfe) hcompl₂))
      · have hfeq : f = ead := Subtype.ext (by rw [hfval, head])
        rw [hfeq] at hfM hfe
        exact Or.inr (Or.inr (eq_triple_of_mem hcard hM heM hfM (Ne.symm hfe) hcompl₃))
    · intro M hMmem
      simp only [Finset.mem_insert, Finset.mem_singleton] at hMmem
      rcases hMmem with rfl | rfl | rfl
      · exact Finset.mem_filter.mpr ⟨mem_matchings.mpr hmatch₁, by simp⟩
      · exact Finset.mem_filter.mpr ⟨mem_matchings.mpr hmatch₂, by simp⟩
      · exact Finset.mem_filter.mpr ⟨mem_matchings.mpr hmatch₃, by simp⟩
  -- the three chord matchings are distinct: the chord through `a` differs
  have h₁₂ : ({e, eab, ecd} : Finset (ArcPair A)) ≠ {e, eac, ebd} := by
    intro h
    have hmem : eab ∈ ({e, eac, ebd} : Finset (ArcPair A)) := by rw [← h]; simp
    simp only [Finset.mem_insert, Finset.mem_singleton] at hmem
    rcases hmem with h' | h' | h'
    · exact hnee heab hae h'
    · exact hnepair heab heac hba hbc h'
    · exact hnepair' heab hebd hab had h'
  have h₁₃ : ({e, eab, ecd} : Finset (ArcPair A)) ≠ {e, ead, ebc} := by
    intro h
    have hmem : eab ∈ ({e, ead, ebc} : Finset (ArcPair A)) := by rw [← h]; simp
    simp only [Finset.mem_insert, Finset.mem_singleton] at hmem
    rcases hmem with h' | h' | h'
    · exact hnee heab hae h'
    · exact hnepair heab head hba hbd h'
    · exact hnepair' heab hebc hab hac h'
  have h₂₃ : ({e, eac, ebd} : Finset (ArcPair A)) ≠ {e, ead, ebc} := by
    intro h
    have hmem : eac ∈ ({e, ead, ebc} : Finset (ArcPair A)) := by rw [← h]; simp
    simp only [Finset.mem_insert, Finset.mem_singleton] at hmem
    rcases hmem with h' | h' | h'
    · exact hnee heac hae h'
    · exact hnepair heac head hca hcd h'
    · exact hnepair' heac hebc hab hac h'
  rw [hset, Finset.card_insert_of_notMem (by simp [h₁₂, h₁₃]),
    Finset.card_insert_of_notMem (by simp [h₂₃]), Finset.card_singleton]


/-- Counting chord–matching incidences in two ways: summing over the chords the number of matchings
in a family that contain them gives the same total as summing the sizes of those matchings. -/
theorem sum_card_filter_mem {A : Finset P} (S : Finset (Finset (ArcPair A))) :
    (∑ e : ArcPair A, (S.filter fun M => e ∈ M).card) = ∑ M ∈ S, M.card := by
  classical
  simp only [Finset.card_filter]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl ?_
  intro M _
  rw [← Finset.card_filter, Finset.filter_mem_eq_inter, Finset.univ_inter]

end Combinatorial

section Plane

variable {P L : Type*} [Membership P L] [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

noncomputable local instance instDecidableIncidence (p : P) (l : L) : Decidable (p ∈ l) :=
  Classical.propDecidable _

/-- The chord matchings of `A` whose three chords have no common point. -/
noncomputable def nonconcurrentMatchings (A : Finset P) : Finset (Finset (ArcPair A)) :=
  matchings A \ concurrentMatchings (L := L) A

omit [Fintype L] [DecidableEq L] in
/-- A concurrent chord matching is a chord matching. -/
theorem concurrentMatchings_subset_matchings {A : Finset P} :
    concurrentMatchings (L := L) A ⊆ matchings A := fun _M hM =>
  mem_matchings.mpr (mem_concurrentMatchings.mp hM).1

/-- The concurrent chord matchings containing a given chord are in bijection with the
triple-concurrence points on that chord's line. -/
theorem card_filter_mem_concurrentMatchings {A : Finset P} (hA : Arc (L := L) A)
    (hcard : A.card = 6) (e : ArcPair A) :
    ((concurrentMatchings (L := L) A).filter fun M => e ∈ M).card =
      ((SixArcConcurrence.triplePoints (L := L) A).filter
        fun x => x ∈ e.line (L := L)).card := by
  classical
  refine (Finset.card_bij (fun x _ => pairsThrough (L := L) A x) ?_ ?_ ?_).symm
  · intro x hx
    obtain ⟨hxT, hxe⟩ := Finset.mem_filter.mp hx
    refine Finset.mem_filter.mpr ⟨mem_concurrentMatchings.mpr
      ⟨isChordMatching_pairsThrough (L := L) hA hxT, x,
        concurrentAt_pairsThrough (L := L) x⟩, ?_⟩
    exact mem_pairsThrough.mpr hxe
  · intro x hx y _hy hxy
    exact eq_of_pairsThrough_eq (L := L) hA (Finset.mem_filter.mp hx).1 hxy
  · intro M hM
    obtain ⟨hMc, heM⟩ := Finset.mem_filter.mp hM
    obtain ⟨hmatch, x, hconc⟩ := mem_concurrentMatchings.mp hMc
    obtain ⟨hxT, heq⟩ := triplePoint_of_concurrentAt (L := L) hA hcard hmatch hconc
    exact ⟨x, Finset.mem_filter.mpr ⟨hxT, by rw [← heq] at heM; exact mem_pairsThrough.mp heM⟩, heq⟩

omit [Fintype L] [DecidableEq L] in
/-- Each chord lies in three chord matchings, so the number of matchings through it that are not
concurrent is three minus the number that are. -/
theorem card_filter_mem_nonconcurrentMatchings_add {A : Finset P} (hcard : A.card = 6)
    (e : ArcPair A) :
    ((nonconcurrentMatchings (L := L) A).filter fun M => e ∈ M).card +
      ((concurrentMatchings (L := L) A).filter fun M => e ∈ M).card = 3 := by
  classical
  have hsub : ((concurrentMatchings (L := L) A).filter fun M => e ∈ M) ⊆
      ((matchings A).filter fun M => e ∈ M) :=
    Finset.filter_subset_filter _ concurrentMatchings_subset_matchings
  have hsdiff : ((nonconcurrentMatchings (L := L) A).filter fun M => e ∈ M) =
      ((matchings A).filter fun M => e ∈ M) \
        ((concurrentMatchings (L := L) A).filter fun M => e ∈ M) := by
    ext M
    simp only [nonconcurrentMatchings, Finset.mem_filter, Finset.mem_sdiff]
    tauto
  rw [hsdiff, Finset.card_sdiff_of_subset hsub,
    card_filter_mem_matchings hcard e]
  have hle : ((concurrentMatchings (L := L) A).filter fun M => e ∈ M).card ≤ 3 := by
    rw [← card_filter_mem_matchings (A := A) hcard e]
    exact Finset.card_le_card hsub
  omega

end Plane

section Coordinate

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

noncomputable local instance instFintypePoint : Fintype (ProjectiveBridge.Point K) :=
  Fintype.ofFinite _

noncomputable local instance instDecidableEqPoint : DecidableEq (ProjectiveBridge.Point K) :=
  Classical.decEq _

noncomputable local instance instDecidableCoordinateIncidence
    (p l : ProjectiveBridge.Point K) : Decidable (p ∈ l) :=
  Classical.propDecidable _

/-- **Ten triple-concurrence points force every chord into exactly two concurrent chord
matchings.**  Each concurrent chord matching has three chords and each of the fifteen chords lies in
at most two of them, so ten concurrent matchings saturate the incidence count. -/
theorem card_filter_mem_concurrentMatchings_eq_two (h2 : (2 : K) ≠ 0)
    {A : Finset (ProjectiveBridge.Point K)}
    (hA : Arc (L := ProjectiveBridge.Point K) A) (hcard : A.card = 6)
    (hten : (SixArcConcurrence.triplePoints (L := ProjectiveBridge.Point K) A).card = 10)
    (e : ArcPair A) :
    ((concurrentMatchings (L := ProjectiveBridge.Point K) A).filter fun M => e ∈ M).card = 2 := by
  classical
  have hCcard : (concurrentMatchings (L := ProjectiveBridge.Point K) A).card = 10 := by
    rw [card_concurrentMatchings_eq_card_triplePoints (L := ProjectiveBridge.Point K) hA hcard,
      hten]
  have hbound : ∀ f : ArcPair A,
      ((concurrentMatchings (L := ProjectiveBridge.Point K) A).filter fun M => f ∈ M).card ≤ 2 := by
    intro f
    rw [card_filter_mem_concurrentMatchings (L := ProjectiveBridge.Point K) hA hcard f]
    exact SixArcConcurrence.card_triplePoints_on_secant_le_two h2 hA hcard f
  have hchords : (Finset.univ : Finset (ArcPair A)).card = 15 := by
    rw [Finset.card_univ, card_arcPair A, hcard]
    rfl
  have htotal : (∑ f : ArcPair A,
      ((concurrentMatchings (L := ProjectiveBridge.Point K) A).filter
        fun M => f ∈ M).card) = 30 := by
    rw [sum_card_filter_mem (concurrentMatchings (L := ProjectiveBridge.Point K) A),
      Finset.sum_congr rfl fun M hM => (mem_concurrentMatchings.mp hM).1.1]
    simp [Finset.sum_const, hCcard]
  by_contra hne
  have hlt := Finset.sum_lt_sum (f := fun f : ArcPair A =>
      ((concurrentMatchings (L := ProjectiveBridge.Point K) A).filter fun M => f ∈ M).card)
    (g := fun _ : ArcPair A => 2) (fun f _ => hbound f)
    ⟨e, Finset.mem_univ e, lt_of_le_of_ne (hbound e) hne⟩
  rw [htotal] at hlt
  simp only [Finset.sum_const, hchords, smul_eq_mul] at hlt
  omega

/-- **Equality in the ten-point bound produces a one-factorization.**  In the projective plane over
a field in which two is invertible, a six-arc with ten triple-concurrence points has every chord in
exactly one chord matching that is not concurrent. -/
theorem card_filter_mem_nonconcurrentMatchings (h2 : (2 : K) ≠ 0)
    {A : Finset (ProjectiveBridge.Point K)}
    (hA : Arc (L := ProjectiveBridge.Point K) A) (hcard : A.card = 6)
    (hten : (SixArcConcurrence.triplePoints (L := ProjectiveBridge.Point K) A).card = 10)
    (e : ArcPair A) :
    ((nonconcurrentMatchings (L := ProjectiveBridge.Point K) A).filter
      fun M => e ∈ M).card = 1 := by
  have hadd := card_filter_mem_nonconcurrentMatchings_add
    (L := ProjectiveBridge.Point K) hcard e
  have htwo := card_filter_mem_concurrentMatchings_eq_two h2 hA hcard hten e
  omega

/-- The chord matchings of such an arc that are not concurrent are five in number. -/
theorem card_nonconcurrentMatchings (h2 : (2 : K) ≠ 0)
    {A : Finset (ProjectiveBridge.Point K)}
    (hA : Arc (L := ProjectiveBridge.Point K) A) (hcard : A.card = 6)
    (hten : (SixArcConcurrence.triplePoints (L := ProjectiveBridge.Point K) A).card = 10) :
    (nonconcurrentMatchings (L := ProjectiveBridge.Point K) A).card = 5 := by
  classical
  have hsize : ∀ M ∈ nonconcurrentMatchings (L := ProjectiveBridge.Point K) A, M.card = 3 := by
    intro M hM
    rw [nonconcurrentMatchings] at hM
    exact (mem_matchings.mp (Finset.mem_sdiff.mp hM).1).1
  have hchords : (Finset.univ : Finset (ArcPair A)).card = 15 := by
    rw [Finset.card_univ, card_arcPair A, hcard]
    rfl
  have hone : (∑ f : ArcPair A,
      ((nonconcurrentMatchings (L := ProjectiveBridge.Point K) A).filter
        fun M => f ∈ M).card) = 15 := by
    rw [Finset.sum_congr rfl fun f _ =>
      card_filter_mem_nonconcurrentMatchings h2 hA hcard hten f,
      Finset.sum_const, smul_eq_mul, mul_one, hchords]
  rw [sum_card_filter_mem (nonconcurrentMatchings (L := ProjectiveBridge.Point K) A),
    Finset.sum_congr rfl hsize] at hone
  simp only [Finset.sum_const, smul_eq_mul] at hone
  omega

/-- Distinct chord matchings of such an arc that are not concurrent share no chord, so the five of
them partition the fifteen chords. -/
theorem disjoint_of_mem_nonconcurrentMatchings (h2 : (2 : K) ≠ 0)
    {A : Finset (ProjectiveBridge.Point K)}
    (hA : Arc (L := ProjectiveBridge.Point K) A) (hcard : A.card = 6)
    (hten : (SixArcConcurrence.triplePoints (L := ProjectiveBridge.Point K) A).card = 10)
    {M N : Finset (ArcPair A)}
    (hM : M ∈ nonconcurrentMatchings (L := ProjectiveBridge.Point K) A)
    (hN : N ∈ nonconcurrentMatchings (L := ProjectiveBridge.Point K) A) (hMN : M ≠ N) :
    Disjoint M N := by
  classical
  refine Finset.disjoint_left.mpr ?_
  intro e heM heN
  have hone := card_filter_mem_nonconcurrentMatchings h2 hA hcard hten e
  have htwo : 1 < ((nonconcurrentMatchings (L := ProjectiveBridge.Point K) A).filter
      fun M' => e ∈ M').card :=
    Finset.one_lt_card.mpr ⟨M, Finset.mem_filter.mpr ⟨hM, heM⟩, N,
      Finset.mem_filter.mpr ⟨hN, heN⟩, hMN⟩
  omega

end Coordinate
end SixArcOneFactorization
end RelativeConicArcs
