import RelativeConicArcs.Moments

/-!
# The line-counting spine for the odd six-arc bound

Let `A` be a six-arc in a finite projective plane and let `l` be a line.  The intended
odd-characteristic theorem says that at least six points of `l` are either in `A` or covered by a
secant of `A`; equivalently, at most `q - 5` points of `l` are ordinary uncovered points.

This file isolates the incidence-theoretic part of that argument.  It proves that a nonsecant line
receives total secant index `15`, and consequently that a line disjoint from `A` has at least five
covered points.  In the equality case the five points must all have index three, so geometrically
they encode a one-factorization of the fifteen chords.  The one remaining, genuinely Desarguesian
odd-characteristic step is to exclude that equality case by the affine triangular-prism argument.
Chord lines are disposed of
completely here, and the final cardinal reduction is stated independently of coordinates so the
later affine lemma has a small interface.
-/

namespace RelativeConicArcs
namespace OddSixArcLineBound

open Configuration Finset

section OddFieldArithmetic

variable {K : Type*} [Field K]

/-- The last scalar contradiction in the triangular-prism argument.  Keeping it separate makes
clear that odd characteristic is used only after the projective configuration has supplied the two
opposite parallelism equations. -/
theorem triangularPrism_parallelism_contradiction
    (hodd : (2 : K) ≠ 0) (a b : K)
    (hminus : a * (b - 1) = -1) (hplus : a * (b - 1) = 1) : False := by
  have hneg : (-1 : K) = 1 := hminus.symm.trans hplus
  apply hodd
  calc
    (2 : K) = 1 - (-1) := by ring
    _ = 0 := by rw [hneg]; ring

end OddFieldArithmetic

variable {P L : Type*} [Membership P L]
  [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

noncomputable local instance instDecidableIncidence (p : P) (l : L) : Decidable (p ∈ l) :=
  Classical.propDecidable _

/-- Ordinary uncovered points, with no prescribed hole set. -/
noncomputable def ordinaryUncovered (A : Finset P) : Finset P := by
  classical
  exact uncovered (L := L) A ∅

/-- Ordinary uncovered points lying on a specified line. -/
noncomputable def uncoveredOnLine (A : Finset P) (l : L) : Finset P := by
  classical
  exact pointsOnLine (P := P) l ∩ ordinaryUncovered (L := L) A

/-- Covered points lying on a specified line. -/
noncomputable def coveredOnLine (A : Finset P) (l : L) : Finset P := by
  classical
  exact (pointsOnLine (P := P) l).filter (Covered (L := L) A)

@[simp] theorem mem_ordinaryUncovered {A : Finset P} {x : P} :
    x ∈ ordinaryUncovered (L := L) A ↔ x ∉ A ∧ ¬ Covered (L := L) A x := by
  classical
  simp [ordinaryUncovered, uncovered, requiredLocus]

@[simp] theorem mem_uncoveredOnLine {A : Finset P} {l : L} {x : P} :
    x ∈ uncoveredOnLine (P := P) A l ↔
      x ∈ l ∧ x ∉ A ∧ ¬ Covered (L := L) A x := by
  classical
  simp [uncoveredOnLine]

@[simp] theorem mem_coveredOnLine {A : Finset P} {l : L} {x : P} :
    x ∈ coveredOnLine (P := P) A l ↔ x ∈ l ∧ Covered (L := L) A x := by
  classical
  simp [coveredOnLine]

/-- The intersection point of two distinct projective lines. -/
noncomputable def lineIntersection (l m : L) (h : l ≠ m) : P :=
  Configuration.HasPoints.mkPoint (P := P) (L := L) h

theorem lineIntersection_mem_left (l m : L) (h : l ≠ m) :
    lineIntersection (P := P) l m h ∈ l :=
  (Configuration.HasPoints.mkPoint_ax (P := P) (L := L) h).1

theorem lineIntersection_mem_right (l m : L) (h : l ≠ m) :
    lineIntersection (P := P) l m h ∈ m :=
  (Configuration.HasPoints.mkPoint_ax (P := P) (L := L) h).2

/-- Two distinct projective lines have exactly one common point, in finset form. -/
theorem filter_pointsOnLine_incident_eq_singleton (l m : L) (h : l ≠ m) :
    (pointsOnLine (P := P) l).filter (fun x => x ∈ m) =
      {lineIntersection (P := P) l m h} := by
  classical
  ext x
  simp only [Finset.mem_filter, mem_pointsOnLine, Finset.mem_singleton]
  constructor
  · rintro ⟨hxl, hxm⟩
    exact (Configuration.Nondegenerate.eq_or_eq hxl
      (lineIntersection_mem_left (P := P) l m h) hxm
      (lineIntersection_mem_right (P := P) l m h)).resolve_right h
  · rintro rfl
    exact ⟨lineIntersection_mem_left (P := P) l m h,
      lineIntersection_mem_right (P := P) l m h⟩

/-- The incidence indicator of a second line sums to one along a distinct line. -/
theorem sum_incidence_indicator_eq_one (l m : L) (h : l ≠ m) :
    (∑ x ∈ pointsOnLine (P := P) l, if x ∈ m then 1 else 0) = 1 := by
  classical
  calc
    (∑ x ∈ pointsOnLine (P := P) l, if x ∈ m then 1 else 0) =
        ((pointsOnLine (P := P) l).filter fun x => x ∈ m).card := by simp
    _ = 1 := by
      rw [filter_pointsOnLine_incident_eq_singleton (P := P) l m h]
      simp

/-- A line which is not itself a secant receives one unit of incidence from every secant.
Thus its total secant index is the number of chords. -/
theorem sum_pointIndex_on_nonsecant_line {A : Finset P} (hA : Arc (L := L) A)
    (l : L) (hl : l ∉ secants (L := L) A) :
    (∑ x ∈ pointsOnLine (P := P) l, pointIndex (L := L) A x) =
      Nat.choose A.card 2 := by
  classical
  have hindex (x : P) : pointIndex (L := L) A x =
      ∑ m ∈ secants (L := L) A, if x ∈ m then 1 else 0 := by
    rw [pointIndex, Finset.card_eq_sum_ones]
    simp
  calc
    (∑ x ∈ pointsOnLine (P := P) l, pointIndex (L := L) A x) =
        ∑ x ∈ pointsOnLine (P := P) l,
          ∑ m ∈ secants (L := L) A, if x ∈ m then 1 else 0 := by
            apply Finset.sum_congr rfl
            intro x _hx
            exact hindex x
    _ = ∑ m ∈ secants (L := L) A,
          ∑ x ∈ pointsOnLine (P := P) l, if x ∈ m then 1 else 0 := by
            rw [Finset.sum_comm]
    _ = ∑ _m ∈ secants (L := L) A, 1 := by
            apply Finset.sum_congr rfl
            intro m hm
            exact sum_incidence_indicator_eq_one (P := P) l m
              (fun h => hl (h ▸ hm))
    _ = (secants (L := L) A).card := by simp
    _ = Nat.choose A.card 2 := card_secants hA

/-- Removing the zero-index points does not change the secant-index sum along a line. -/
theorem sum_pointIndex_coveredOnLine (A : Finset P) (l : L) :
    (∑ x ∈ coveredOnLine (P := P) A l, pointIndex (L := L) A x) =
      ∑ x ∈ pointsOnLine (P := P) l, pointIndex (L := L) A x := by
  classical
  rw [coveredOnLine]
  apply Finset.sum_subset (Finset.filter_subset _ _)
  intro x hxline hxnot
  have hxnotCovered : ¬ Covered (L := L) A x := by
    intro hxcovered
    exact hxnot (Finset.mem_filter.mpr ⟨hxline, hxcovered⟩)
  simp only [Covered, Nat.not_lt] at hxnotCovered
  omega

/-- A line disjoint from the arc cannot itself be a secant. -/
theorem nonsecant_of_disjoint {A : Finset P} {l : L}
    (hdisj : Disjoint (pointsOnLine (P := P) l) A) :
    l ∉ secants (L := L) A := by
  classical
  intro hl
  obtain ⟨a, ha, b, hb, _hab, hal, _hbl⟩ := mem_secants.mp hl
  exact (Finset.disjoint_left.mp hdisj) (mem_pointsOnLine.mpr hal) ha

/-- On a line disjoint from a six-arc, each point lies on at most three chords. -/
theorem pointIndex_le_three_on_disjoint_line {A : Finset P} (hA : Arc (L := L) A)
    (hcard : A.card = 6) {l : L}
    (hdisj : Disjoint (pointsOnLine (P := P) l) A)
    {x : P} (hxl : x ∈ l) :
    pointIndex (L := L) A x ≤ 3 := by
  have hxA : x ∉ A := by
    intro hxA
    exact (Finset.disjoint_left.mp hdisj) (mem_pointsOnLine.mpr hxl) hxA
  have hle := pointIndex_le_half_card hA hxA
  rw [hcard] at hle
  norm_num at hle
  exact hle

/-- At a point of an arc, the incident secants are indexed by the other arc points.  This is kept
local to the line-bound module because it is also the weight-five contribution in the one-vertex
line case. -/
theorem pointIndex_eq_card_sub_one_of_mem {A : Finset P} (hA : Arc (L := L) A)
    {p : P} (hp : p ∈ A) : pointIndex (L := L) A p = A.card - 1 := by
  classical
  rw [pointIndex_eq_card_pairsThrough hA]
  have hthrough : pairsThrough (L := L) A p =
      (Finset.univ : Finset (ArcPair A)).filter fun e => p ∈ e.1 := by
    ext e
    simp only [Finset.mem_filter, Finset.mem_univ, true_and, mem_pairsThrough]
    constructor
    · exact fun h => e.mem_of_mem_arc_of_mem_line hA hp h
    · exact e.mem_line
  rw [hthrough]
  have huniv : (Finset.univ : Finset (ArcPair A)) = (A.powersetCard 2).attach := by
    ext e
    simp [ArcPair]
  rw [huniv, Finset.filter_attach', Finset.card_map, Finset.card_attach]
  have hfilter :
      (A.powersetCard 2).filter
          (fun s => ∃ _h : s ∈ A.powersetCard 2, p ∈ s) =
        (A.powersetCard 2).filter fun s => p ∈ s := by
    ext s
    simp
  rw [hfilter]
  have hcontain : ({p} : Finset P) ⊆ A := by simpa using hp
  have hpred : (A.powersetCard 2).filter (fun s => p ∈ s) =
      (A.powersetCard 2).filter (fun s => ({p} : Finset P) ⊆ s) := by
    ext s
    simp
  calc
    ((A.powersetCard 2).filter (fun s => p ∈ s)).card =
        ((A.powersetCard 2).filter (fun s => ({p} : Finset P) ⊆ s)).card :=
      congrArg Finset.card hpred
    _ = Nat.choose (A.card - 1) 1 :=
      Finset.card_filter_powersetCard_subset {p} A 2 hcontain (by simp)
    _ = A.card - 1 := by simp

/-- Away from the unique arc point on a line, at most two chords can pass through a point of that
line.  The proof packages the pairwise-disjoint chord fibers into the remaining five endpoints. -/
theorem pointIndex_le_two_on_one_vertex_line
    {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 6)
    {l : L} {p x : P}
    (hlineA : pointsOnLine (P := P) l ∩ A = {p})
    (hxl : x ∈ l) (hxp : x ≠ p) :
    pointIndex (L := L) A x ≤ 2 := by
  classical
  have hpinter : p ∈ pointsOnLine (P := P) l ∩ A := by rw [hlineA]; simp
  have hpl : p ∈ l := mem_pointsOnLine.mp (Finset.mem_inter.mp hpinter).1
  have hpA : p ∈ A := (Finset.mem_inter.mp hpinter).2
  have hxA : x ∉ A := by
    intro hxA
    have hxinter : x ∈ pointsOnLine (P := P) l ∩ A :=
      Finset.mem_inter.mpr ⟨mem_pointsOnLine.mpr hxl, hxA⟩
    rw [hlineA] at hxinter
    exact hxp (Finset.mem_singleton.mp hxinter)
  let E := pairsThrough (L := L) A x
  let U := E.biUnion fun e => e.1
  have hpairAvoids (e : ArcPair A) (he : e ∈ E) : p ∉ e.1 := by
    intro hpe
    have hxe : x ∈ e.line (L := L) := mem_pairsThrough.mp he
    have heq : e.line (L := L) = l :=
      (Configuration.Nondegenerate.eq_or_eq hxe (e.mem_line hpe) hxl hpl).resolve_left hxp
    have hesub : e.1 ⊆ {p} := by
      intro y hye
      have hyinter : y ∈ pointsOnLine (P := P) l ∩ A := by
        apply Finset.mem_inter.mpr
        refine ⟨mem_pointsOnLine.mpr ?_, e.subset hye⟩
        rw [← heq]
        exact e.mem_line hye
      rw [hlineA] at hyinter
      exact hyinter
    have hle := Finset.card_le_card hesub
    rw [e.card] at hle
    simp at hle
  have hUsub : U ⊆ A.erase p := by
    intro y hy
    obtain ⟨e, he, hye⟩ := Finset.mem_biUnion.mp hy
    exact Finset.mem_erase.mpr ⟨fun hyp => hpairAvoids e he (hyp ▸ hye), e.subset hye⟩
  have hUcard : U.card = 2 * E.card := by
    change (E.biUnion fun e => e.1).card = 2 * E.card
    have hdisj : ((E : Finset (ArcPair A)) : Set (ArcPair A)).PairwiseDisjoint
        fun e => e.1 := by
      simpa [E] using pairsThrough_pairwiseDisjoint (L := L) hA hxA
    rw [Finset.card_biUnion hdisj]
    calc
      (∑ e ∈ E, e.1.card) = ∑ _e ∈ E, 2 := by
        apply Finset.sum_congr rfl
        intro e _he
        exact e.card
      _ = 2 * E.card := by simp [Nat.mul_comm]
  have hUle := Finset.card_le_card hUsub
  have hErase : (A.erase p).card = 5 := by
    rw [Finset.card_erase_of_mem hpA, hcard]
  rw [hUcard, hErase] at hUle
  rw [pointIndex_eq_card_pairsThrough hA]
  change E.card ≤ 2
  omega

/-- A line meeting a six-arc in exactly one point contains at least six covered points: the arc
point has index five, the other ten secant incidences have local index at most two. -/
theorem six_le_card_coveredOnLine_of_one_vertex
    {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 6)
    {l : L} {p : P}
    (hlineA : pointsOnLine (P := P) l ∩ A = {p}) :
    6 ≤ (coveredOnLine (P := P) A l).card := by
  classical
  have hpinter : p ∈ pointsOnLine (P := P) l ∩ A := by rw [hlineA]; simp
  have hpl : p ∈ l := mem_pointsOnLine.mp (Finset.mem_inter.mp hpinter).1
  have hpA : p ∈ A := (Finset.mem_inter.mp hpinter).2
  have hlNonsecant : l ∉ secants (L := L) A := by
    intro hl
    obtain ⟨a, ha, b, hb, hab, hal, hbl⟩ := mem_secants.mp hl
    have haInter : a ∈ pointsOnLine (P := P) l ∩ A :=
      Finset.mem_inter.mpr ⟨mem_pointsOnLine.mpr hal, ha⟩
    have hbInter : b ∈ pointsOnLine (P := P) l ∩ A :=
      Finset.mem_inter.mpr ⟨mem_pointsOnLine.mpr hbl, hb⟩
    rw [hlineA] at haInter hbInter
    exact hab ((Finset.mem_singleton.mp haInter).trans (Finset.mem_singleton.mp hbInter).symm)
  let S := coveredOnLine (P := P) A l
  have hpIndex : pointIndex (L := L) A p = 5 := by
    rw [pointIndex_eq_card_sub_one_of_mem hA hpA, hcard]
  have hpS : p ∈ S := by
    refine mem_coveredOnLine.mpr ⟨hpl, ?_⟩
    simp [Covered, hpIndex]
  have hsumLine := sum_pointIndex_on_nonsecant_line hA l hlNonsecant
  rw [hcard] at hsumLine
  norm_num [Nat.choose] at hsumLine
  have hsumCovered := sum_pointIndex_coveredOnLine (P := P) A l
  have hsum : (∑ x ∈ S, pointIndex (L := L) A x) = 15 := by
    simpa [S, hsumLine] using hsumCovered
  have hsplit := Finset.sum_erase_add S
    (fun x => pointIndex (L := L) A x) hpS
  rw [hsum, hpIndex] at hsplit
  have hrest :
      (∑ x ∈ S.erase p, pointIndex (L := L) A x) ≤
        ∑ _x ∈ S.erase p, 2 := by
    apply Finset.sum_le_sum
    intro x hx
    have hxS := Finset.mem_of_mem_erase hx
    have hxp := (Finset.mem_erase.mp hx).1
    exact pointIndex_le_two_on_one_vertex_line hA hcard hlineA
      (mem_coveredOnLine.mp hxS).1 hxp
  simp at hrest
  have hcardSplit := Finset.card_erase_add_one hpS
  change 6 ≤ S.card
  omega

/-- The incidence equations alone force five covered points on every line disjoint from a
six-arc.  The odd-characteristic affine argument is precisely what improves `5` to `6`. -/
theorem five_le_card_coveredOnLine_of_disjoint {A : Finset P} (hA : Arc (L := L) A)
    (hcard : A.card = 6) (l : L)
    (hdisj : Disjoint (pointsOnLine (P := P) l) A) :
    5 ≤ (coveredOnLine (P := P) A l).card := by
  have hsum := sum_pointIndex_on_nonsecant_line hA l (nonsecant_of_disjoint hdisj)
  rw [hcard] at hsum
  norm_num [Nat.choose] at hsum
  have hsum' := sum_pointIndex_coveredOnLine (P := P) A l
  have hle :
      (∑ x ∈ coveredOnLine (P := P) A l, pointIndex (L := L) A x) ≤
        ∑ _x ∈ coveredOnLine (P := P) A l, 3 := by
    apply Finset.sum_le_sum
    intro x hx
    exact pointIndex_le_three_on_disjoint_line hA hcard hdisj
      (mem_coveredOnLine.mp hx).1
  simp at hle
  rw [hsum', hsum] at hle
  omega

/-- Equality in the preceding incidence bound forces every covered point on the disjoint line to
have the maximum possible index three.  Geometrically, the five fibers are the five perfect
matchings in a one-factorization of the six arc vertices. -/
theorem pointIndex_eq_three_of_disjoint_of_card_covered_eq_five
    {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 6) (l : L)
    (hdisj : Disjoint (pointsOnLine (P := P) l) A)
    (hfive : (coveredOnLine (P := P) A l).card = 5)
    {x : P} (hx : x ∈ coveredOnLine (P := P) A l) :
    pointIndex (L := L) A x = 3 := by
  let S := coveredOnLine (P := P) A l
  have hsumLine := sum_pointIndex_on_nonsecant_line hA l (nonsecant_of_disjoint hdisj)
  rw [hcard] at hsumLine
  norm_num [Nat.choose] at hsumLine
  have hsumCovered := sum_pointIndex_coveredOnLine (P := P) A l
  have hsum : (∑ y ∈ S, pointIndex (L := L) A y) = 15 := by
    simpa [S, hsumLine] using hsumCovered
  have hxle : pointIndex (L := L) A x ≤ 3 :=
    pointIndex_le_three_on_disjoint_line hA hcard hdisj (mem_coveredOnLine.mp hx).1
  by_contra hne
  have hxleTwo : pointIndex (L := L) A x ≤ 2 := by omega
  have hrest :
      (∑ y ∈ S.erase x, pointIndex (L := L) A y) ≤
        ∑ _y ∈ S.erase x, 3 := by
    apply Finset.sum_le_sum
    intro y hy
    exact pointIndex_le_three_on_disjoint_line hA hcard hdisj
      (mem_coveredOnLine.mp (Finset.mem_of_mem_erase hy)).1
  have hcardErase : (S.erase x).card = 4 := by
    rw [Finset.card_erase_of_mem]
    · simpa [S] using hfive
    · simpa [S] using hx
  simp [hcardErase] at hrest
  have hsplit := Finset.sum_erase_add S
    (fun y => pointIndex (L := L) A y) (by simpa [S] using hx)
  rw [hsum] at hsplit
  omega

/-- On a disjoint line, covered and ordinary-uncovered points partition the whole line. -/
theorem card_covered_add_card_uncovered_eq_order_add_one {A : Finset P} {l : L}
    (hdisj : Disjoint (pointsOnLine (P := P) l) A) :
    (coveredOnLine (P := P) A l).card + (uncoveredOnLine (P := P) A l).card =
      PlaneOrder P L + 1 := by
  classical
  let S := pointsOnLine (P := P) l
  have hpart := Finset.card_filter_add_card_filter_not
    (s := S) (p := Covered (L := L) A)
  have hcovered : S.filter (Covered (L := L) A) = coveredOnLine (P := P) A l := by
    simp [S, coveredOnLine]
  have huncovered : S.filter (fun x => ¬ Covered (L := L) A x) =
      uncoveredOnLine (P := P) A l := by
    ext x
    simp only [Finset.mem_filter, S, mem_pointsOnLine, mem_uncoveredOnLine]
    constructor
    · rintro ⟨hxl, hxnot⟩
      exact ⟨hxl, fun hxA => (Finset.disjoint_left.mp hdisj)
        (mem_pointsOnLine.mpr hxl) hxA, hxnot⟩
    · rintro ⟨hxl, _hxA, hxnot⟩
      exact ⟨hxl, hxnot⟩
  rw [hcovered, huncovered] at hpart
  calc
    (coveredOnLine (P := P) A l).card + (uncoveredOnLine (P := P) A l).card =
        S.card := hpart
    _ = PlaneOrder P L + 1 := by simp [S, card_pointsOnLine]

/-- Incidence alone gives the one-short bound `q - 4` on a disjoint line. -/
theorem uncoveredOnLine_card_le_order_sub_four_of_disjoint
    {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 6) (l : L)
    (hdisj : Disjoint (pointsOnLine (P := P) l) A) :
    (uncoveredOnLine (P := P) A l).card ≤ PlaneOrder P L - 4 := by
  have hfive := five_le_card_coveredOnLine_of_disjoint hA hcard l hdisj
  have hpart := card_covered_add_card_uncovered_eq_order_add_one (P := P) hdisj
  omega

/-- A chord contains no ordinary uncovered point. -/
theorem uncoveredOnLine_pairLine_eq_empty {A : Finset P} (hA : Arc (L := L) A)
    (e : ArcPair A) :
    uncoveredOnLine (P := P) A (e.line (L := L)) = ∅ := by
  classical
  apply Finset.eq_empty_iff_forall_notMem.mpr
  intro x hx
  have hxl : x ∈ e.line (L := L) := (mem_uncoveredOnLine.mp hx).1
  have hxnotCovered : ¬ Covered (L := L) A x := (mem_uncoveredOnLine.mp hx).2.2
  apply hxnotCovered
  exact covered_iff_exists_secant.mpr
    ⟨e.line (L := L), (by
      obtain ⟨a, b, hab, he⟩ := e.exists_eq_pair
      exact ⟨a, e.subset (by simp [he]), b, e.subset (by simp [he]), hab,
        e.mem_line (by simp [he]), e.mem_line (by simp [he])⟩), hxl⟩

/-- Any line through two distinct arc points contains no ordinary uncovered point.  This version
avoids choosing an `ArcPair`, which is convenient when the line is classified by its intersection
cardinality with the arc. -/
theorem uncoveredOnLine_eq_empty_of_two_arc_points
    {A : Finset P} {l : L} {a b : P}
    (haA : a ∈ A) (hbA : b ∈ A) (hab : a ≠ b) (hal : a ∈ l) (hbl : b ∈ l) :
    uncoveredOnLine (P := P) A l = ∅ := by
  classical
  apply Finset.eq_empty_iff_forall_notMem.mpr
  intro x hx
  exact (mem_uncoveredOnLine.mp hx).2.2 <|
    covered_iff_exists_secant.mpr
      ⟨l, ⟨a, haA, b, hbA, hab, hal, hbl⟩, (mem_uncoveredOnLine.mp hx).1⟩

/-- Final cardinal reduction: once six points on a line are known not to be ordinary uncovered,
the desired `q - 5` bound is pure bookkeeping.  The odd affine lemma will supply `hsix` for a line
disjoint from the six-arc; the one-vertex and chord cases have separate geometric proofs. -/
theorem uncoveredOnLine_card_le_order_sub_five_of_six_complement
    (A : Finset P) (l : L)
    (hsix : 6 ≤ ((pointsOnLine (P := P) l) \ uncoveredOnLine (P := P) A l).card) :
    (uncoveredOnLine (P := P) A l).card ≤ PlaneOrder P L - 5 := by
  have hsub : uncoveredOnLine (P := P) A l ⊆ pointsOnLine (P := P) l :=
    Finset.inter_subset_left
  have hcard := Finset.card_sdiff_add_card_eq_card hsub
  rw [card_pointsOnLine] at hcard
  omega

/-- The one-vertex case of the desired line bound is already purely incidence-theoretic. -/
theorem uncoveredOnLine_card_le_order_sub_five_of_one_vertex
    {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 6)
    {l : L} {p : P}
    (hlineA : pointsOnLine (P := P) l ∩ A = {p}) :
    (uncoveredOnLine (P := P) A l).card ≤ PlaneOrder P L - 5 := by
  have hsixCovered := six_le_card_coveredOnLine_of_one_vertex hA hcard hlineA
  have hsub : coveredOnLine (P := P) A l ⊆
      pointsOnLine (P := P) l \ uncoveredOnLine (P := P) A l := by
    intro x hx
    apply Finset.mem_sdiff.mpr
    refine ⟨mem_pointsOnLine.mpr (mem_coveredOnLine.mp hx).1, ?_⟩
    intro hxu
    exact (mem_uncoveredOnLine.mp hxu).2.2 (mem_coveredOnLine.mp hx).2
  apply uncoveredOnLine_card_le_order_sub_five_of_six_complement A l
  exact hsixCovered.trans (Finset.card_le_card hsub)

/-- For a disjoint line, excluding the five-covered-point equality case is exactly enough to
upgrade the incidence bound from five to six. -/
theorem six_le_card_coveredOnLine_of_disjoint_of_ne_five
    {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 6) (l : L)
    (hdisj : Disjoint (pointsOnLine (P := P) l) A)
    (hne : (coveredOnLine (P := P) A l).card ≠ 5) :
    6 ≤ (coveredOnLine (P := P) A l).card := by
  have hfive := five_le_card_coveredOnLine_of_disjoint hA hcard l hdisj
  omega

/-- The disjoint-line case reduced to the sole affine seam.  Over an odd field the triangular-prism
parallelism argument proves `hne`. -/
theorem uncoveredOnLine_card_le_order_sub_five_of_disjoint_of_ne_five
    {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 6) (l : L)
    (hdisj : Disjoint (pointsOnLine (P := P) l) A)
    (hne : (coveredOnLine (P := P) A l).card ≠ 5) :
    (uncoveredOnLine (P := P) A l).card ≤ PlaneOrder P L - 5 := by
  have hsix := six_le_card_coveredOnLine_of_disjoint_of_ne_five
    hA hcard l hdisj hne
  have hpart := card_covered_add_card_uncovered_eq_order_add_one (P := P) hdisj
  omega

/-- Complete incidence reduction for the odd six-arc line bound.  The only coordinate-geometric
input is the impossibility of the five-covered-point equality case on a line disjoint from the
arc.  The affine triangular-prism argument over an odd field supplies `hfiveImpossible`. -/
theorem uncoveredOnLine_card_le_order_sub_five
    {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 6)
    (hfiveImpossible : ∀ m : L,
      Disjoint (pointsOnLine (P := P) m) A →
        (coveredOnLine (P := P) A m).card ≠ 5)
    (l : L) :
    (uncoveredOnLine (P := P) A l).card ≤ PlaneOrder P L - 5 := by
  classical
  let I := pointsOnLine (P := P) l ∩ A
  have hIle : I.card ≤ 2 := by
    by_contra h
    rw [Nat.not_le, Finset.two_lt_card_iff] at h
    obtain ⟨a, b, c, ha, hb, hc, hab, hac, hbc⟩ := h
    exact hA (Finset.mem_inter.mp ha).2 (Finset.mem_inter.mp hb).2
      (Finset.mem_inter.mp hc).2 hab hac hbc
      ⟨l, mem_pointsOnLine.mp (Finset.mem_inter.mp ha).1,
        mem_pointsOnLine.mp (Finset.mem_inter.mp hb).1,
        mem_pointsOnLine.mp (Finset.mem_inter.mp hc).1⟩
  interval_cases hIcard : I.card
  · have hIempty : I = ∅ := Finset.card_eq_zero.mp hIcard
    have hdisj : Disjoint (pointsOnLine (P := P) l) A := by
      rw [Finset.disjoint_iff_inter_eq_empty]
      simpa [I] using hIempty
    exact uncoveredOnLine_card_le_order_sub_five_of_disjoint_of_ne_five
      hA hcard l hdisj (hfiveImpossible l hdisj)
  · obtain ⟨p, hp⟩ := Finset.card_eq_one.mp hIcard
    apply uncoveredOnLine_card_le_order_sub_five_of_one_vertex hA hcard
    simpa [I] using hp
  · obtain ⟨a, b, hab, hI⟩ := Finset.card_eq_two.mp hIcard
    have ha : a ∈ I := by simp [hI]
    have hb : b ∈ I := by simp [hI]
    have hempty := uncoveredOnLine_eq_empty_of_two_arc_points
      (A := A) (l := l)
      (Finset.mem_inter.mp ha).2 (Finset.mem_inter.mp hb).2 hab
      (mem_pointsOnLine.mp (Finset.mem_inter.mp ha).1)
      (mem_pointsOnLine.mp (Finset.mem_inter.mp hb).1)
    rw [hempty]
    simp

#print axioms triangularPrism_parallelism_contradiction
#print axioms uncoveredOnLine_card_le_order_sub_five

end OddSixArcLineBound
end RelativeConicArcs
