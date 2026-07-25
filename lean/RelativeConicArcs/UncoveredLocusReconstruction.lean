import RelativeConicArcs.Nucleus

/-!
# Reconstruction from an uncovered locus

Let two finite families of lines in a projective plane cover the same points.  If every line has
more points than either family has lines, then the families coincide: a line missing from the
second family would inject its points into the second family by choosing a covering line, since
each competing line meets it in at most one point.

For an arc, the line family is its family of secants.  Consequently, above the strict threshold
`q + 1 > choose k 2`, equality of the ordinary uncovered loci recovers the complete secant family.
No coordinates, field structure, characteristic assumption, or prescribed conic enters the
argument.
-/

namespace RelativeConicArcs

open Finset

variable {P L : Type*} [Membership P L]

/-- The points covered by at least one line in a finite line family. -/
def CoveredByLineFamily (S : Finset L) (p : P) : Prop :=
  ∃ l ∈ S, p ∈ l

section LineFamilies

variable [Fintype P] [DecidableEq L]
  [Configuration.Nondegenerate P L]

/-- A line family is determined by its covered points when each of its lines has more points than
the competing family has lines.  This is the one-sided inclusion form of line-union recovery. -/
theorem lineFamily_subset_of_cover_imp
    {S T : Finset L}
    (hlarge : ∀ l ∈ S, T.card < Nat.card {p : P // p ∈ l})
    (hcover : ∀ p, CoveredByLineFamily S p → CoveredByLineFamily T p) :
    S ⊆ T := by
  classical
  intro l hlS
  by_contra hlT
  letI : Fintype {p : P // p ∈ l} := Fintype.ofFinite _
  have hcovered (p : {p : P // p ∈ l}) :
      ∃ t, t ∈ T ∧ p.1 ∈ t :=
    hcover p.1 ⟨l, hlS, p.2⟩
  let f : {p : P // p ∈ l} → {t : L // t ∈ T} :=
    fun p => ⟨(hcovered p).choose, (hcovered p).choose_spec.1⟩
  have hfmem (p : {p : P // p ∈ l}) : p.1 ∈ (f p).1 :=
    (hcovered p).choose_spec.2
  have hfinj : Function.Injective f := by
    intro p q hpq
    apply Subtype.ext
    have hqmem : q.1 ∈ (f p).1 := by
      simpa [hpq] using hfmem q
    have hline : l ≠ (f p).1 := by
      intro heq
      exact hlT (heq ▸ (f p).2)
    exact (Configuration.Nondegenerate.eq_or_eq p.2 q.2 (hfmem p) hqmem).resolve_right hline
  have hcard := Fintype.card_le_of_injective f hfinj
  rw [Fintype.card_coe] at hcard
  have hcard' : Nat.card {p : P // p ∈ l} ≤ T.card := by
    simpa only [Nat.card_eq_fintype_card] using hcard
  exact (Nat.not_lt_of_ge hcard') (hlarge l hlS)

/-- Two line families with the same covered points coincide whenever every line in either family
has more points than the opposite family has lines. -/
theorem lineFamily_eq_of_cover_iff
    {S T : Finset L}
    (hlargeS : ∀ l ∈ S, T.card < Nat.card {p : P // p ∈ l})
    (hlargeT : ∀ l ∈ T, S.card < Nat.card {p : P // p ∈ l})
    (hcover : ∀ p, CoveredByLineFamily S p ↔ CoveredByLineFamily T p) :
    S = T := by
  apply Finset.Subset.antisymm
  · exact lineFamily_subset_of_cover_imp hlargeS fun p => (hcover p).mp
  · exact lineFamily_subset_of_cover_imp hlargeT fun p => (hcover p).mpr

/-- The points of a fixed line that are covered by a finite line family. -/
noncomputable def coveredPointsOnLine (S : Finset L) (l : L) : Finset P := by
  classical
  exact Finset.univ.filter fun p => p ∈ l ∧ CoveredByLineFamily S p

omit [DecidableEq L] in
/-- A line outside a family contains at most one family-covered point per family line. -/
theorem card_coveredPointsOnLine_le
    (S : Finset L) {l : L} (hl : l ∉ S) :
    (coveredPointsOnLine S l).card ≤ S.card := by
  classical
  have hcovered (p : {p : P // p ∈ coveredPointsOnLine S l}) :
      ∃ t, t ∈ S ∧ p.1 ∈ t := by
    have hp := (Finset.mem_filter.mp p.2).2.2
    exact hp
  let f : {p : P // p ∈ coveredPointsOnLine S l} → {t : L // t ∈ S} :=
    fun p => ⟨(hcovered p).choose, (hcovered p).choose_spec.1⟩
  have hfmem (p : {p : P // p ∈ coveredPointsOnLine S l}) : p.1 ∈ (f p).1 :=
    (hcovered p).choose_spec.2
  have hfinj : Function.Injective f := by
    intro p q hpq
    apply Subtype.ext
    have hpl : p.1 ∈ l := (Finset.mem_filter.mp p.2).2.1
    have hql : q.1 ∈ l := (Finset.mem_filter.mp q.2).2.1
    have hqmem : q.1 ∈ (f p).1 := by
      simpa [hpq] using hfmem q
    have hline : l ≠ (f p).1 := by
      intro heq
      exact hl (heq ▸ (f p).2)
    exact (Configuration.Nondegenerate.eq_or_eq hpl hql (hfmem p) hqmem).resolve_right hline
  have hcard := Fintype.card_le_of_injective f hfinj
  simpa only [Fintype.card_coe] using hcard

end LineFamilies

section ArcReconstruction

variable [Fintype P] [Fintype L] [DecidableEq P]
  [Configuration.ProjectivePlane P L]

/-- The ordinary uncovered locus is the complement of the union of all secants.  Unlike the
prescribed-hole definition, this incidence-invariant form does not separately remove the arc
vertices; vertices of an arc of size at least two already lie on secants. -/
noncomputable def ordinaryUncovered (A : Finset P) : Finset P := by
  classical
  exact Finset.univ.filter fun p => ¬ Covered (L := L) A p

/-- The points on a line that lie outside a specified uncovered locus. -/
noncomputable def pointsOutsideUncoveredOnLine (U : Finset P) (l : L) : Finset P := by
  classical
  exact (Finset.univ \ U).filter fun p => p ∈ l

/-- Lines selected canonically from an uncovered locus by requiring more than `N` covered
points. -/
noncomputable def linesAboveUncoveredThreshold (U : Finset P) (N : ℕ) : Finset L := by
  classical
  exact Finset.univ.filter fun l =>
    N < (pointsOutsideUncoveredOnLine U l).card

/-- Points incident with exactly `k - 1` lines in a finite line family. -/
noncomputable def verticesOfLineFamily (S : Finset L) (k : ℕ) : Finset P := by
  classical
  exact Finset.univ.filter fun p => (S.filter fun l => p ∈ l).card = k - 1

omit [DecidableEq P] [Configuration.ProjectivePlane P L] in
@[simp] theorem mem_ordinaryUncovered {A : Finset P} {p : P} :
    p ∈ ordinaryUncovered (L := L) A ↔ ¬ Covered (L := L) A p := by
  classical
  simp [ordinaryUncovered]

omit [DecidableEq P] [Configuration.ProjectivePlane P L] in
/-- Equality of ordinary uncovered loci is equivalent to equality of the corresponding secant
coverage predicates. -/
theorem covered_iff_of_ordinaryUncovered_eq {A B : Finset P}
    (hU : ordinaryUncovered (L := L) A = ordinaryUncovered (L := L) B) (p : P) :
    Covered (L := L) A p ↔ Covered (L := L) B p := by
  have hm :
      p ∈ ordinaryUncovered (L := L) A ↔
        p ∈ ordinaryUncovered (L := L) B := by
    rw [hU]
  simpa only [mem_ordinaryUncovered, not_iff_not] using not_congr hm

omit [Configuration.ProjectivePlane P L] in
/-- The points covered on a line by the secant family are exactly the points on that line outside
the ordinary uncovered locus. -/
theorem coveredPointsOnLine_secants_eq
    (A : Finset P) (l : L) :
    coveredPointsOnLine (secants (L := L) A) l =
      pointsOutsideUncoveredOnLine (ordinaryUncovered (L := L) A) l := by
  classical
  ext p
  simp [coveredPointsOnLine, pointsOutsideUncoveredOnLine, ordinaryUncovered,
    CoveredByLineFamily, covered_iff_exists_secant, mem_secants, and_comm]

omit [DecidableEq P] in
/-- A genuine secant has every one of its points covered by the secant family. -/
theorem card_coveredPointsOnLine_secant
    {A : Finset P} {l : L} (hl : l ∈ secants (L := L) A) :
    (coveredPointsOnLine (secants (L := L) A) l).card = PlaneOrder P L + 1 := by
  classical
  have hfull :
      coveredPointsOnLine (secants (L := L) A) l =
        Finset.univ.filter fun p => p ∈ l := by
    ext p
    simp only [coveredPointsOnLine, Finset.mem_filter, Finset.mem_univ, true_and,
      CoveredByLineFamily]
    constructor
    · exact fun h => h.1
    · exact fun hp => ⟨hp, l, hl, hp⟩
  rw [hfull]
  calc
    (Finset.univ.filter fun p : P => p ∈ l).card =
        (↑(Finset.univ.filter fun p : P => p ∈ l) : Set P).ncard :=
      (Set.ncard_coe_finset (Finset.univ.filter fun p : P => p ∈ l)).symm
    _ = ({p : P | p ∈ l} : Set P).ncard := by
      congr 1
      ext p
      simp
    _ = Nat.card {p : P // p ∈ l} := (Nat.card_coe_set_eq _).symm
    _ = PlaneOrder P L + 1 := card_points_on_line (P := P) l

/-- The manuscript's canonical first inverse step: the secants are exactly the lines containing
more than `choose k 2` points outside the ordinary uncovered locus. -/
theorem linesAboveUncoveredThreshold_eq_secants
    {A : Finset P} (hA : Arc (L := L) A)
    (hthreshold : Nat.choose A.card 2 < PlaneOrder P L + 1) :
    linesAboveUncoveredThreshold (L := L) (ordinaryUncovered (L := L) A)
        (Nat.choose A.card 2) =
      secants (L := L) A := by
  classical
  ext l
  rw [linesAboveUncoveredThreshold, Finset.mem_filter]
  simp only [Finset.mem_univ, true_and]
  rw [← coveredPointsOnLine_secants_eq (L := L)]
  constructor
  · intro hlarge
    by_contra hl
    have hle := card_coveredPointsOnLine_le (secants (L := L) A) hl
    rw [card_secants hA] at hle
    omega
  · intro hl
    rw [card_coveredPointsOnLine_secant (L := L) hl]
    exact hthreshold

omit [Fintype P] in
/-- For arcs of the same size at least three, equality of secant families recovers the arc itself.
The vertices are distinguished from external concurrence points by their secant multiplicity. -/
theorem eq_of_secants_eq
    {A B : Finset P} (hA : Arc (L := L) A) (hB : Arc (L := L) B)
    (hcard : A.card = B.card) (hthree : 3 ≤ A.card)
    (hsec : secants (L := L) A = secants (L := L) B) :
    A = B := by
  classical
  apply Finset.Subset.antisymm
  · intro a ha
    by_contra haB
    have hvertex := Nucleus.pointIndex_eq_card_sub_one_of_mem (L := L) hA ha
    have hupper := pointIndex_le_half_card (L := L) hB haB
    have hindex :
        pointIndex (L := L) A a = pointIndex (L := L) B a := by
      simp only [pointIndex, hsec]
    omega
  · intro b hb
    by_contra hbA
    have hvertex := Nucleus.pointIndex_eq_card_sub_one_of_mem (L := L) hB hb
    have hupper := pointIndex_le_half_card (L := L) hA hbA
    have hindex :
        pointIndex (L := L) B b = pointIndex (L := L) A b := by
      simp only [pointIndex, hsec]
    omega

/-- The manuscript's canonical second inverse step: for an arc of size at least three, the points
incident with exactly `k - 1` secants are precisely the arc vertices. -/
theorem verticesOfLineFamily_secants_eq
    {A : Finset P} (hA : Arc (L := L) A) (hthree : 3 ≤ A.card) :
    verticesOfLineFamily (P := P) (secants (L := L) A) A.card = A := by
  classical
  ext p
  rw [verticesOfLineFamily, Finset.mem_filter]
  simp only [Finset.mem_univ, true_and]
  change pointIndex (L := L) A p = A.card - 1 ↔ p ∈ A
  constructor
  · intro hindex
    by_contra hpA
    have hupper := pointIndex_le_half_card (L := L) hA hpA
    omega
  · intro hp
    exact Nucleus.pointIndex_eq_card_sub_one_of_mem (L := L) hA hp

/-- Above the strict incidence threshold, the ordinary uncovered locus and the arc size determine
the complete family of secant lines. -/
theorem secants_eq_of_ordinaryUncovered_eq
    {A B : Finset P} (hA : Arc (L := L) A) (hB : Arc (L := L) B)
    (hcard : A.card = B.card)
    (hthreshold : Nat.choose A.card 2 < PlaneOrder P L + 1)
    (hU : ordinaryUncovered (L := L) A = ordinaryUncovered (L := L) B) :
    secants (L := L) A = secants (L := L) B := by
  classical
  apply lineFamily_eq_of_cover_iff
  · intro l hl
    rw [card_secants hB, ← hcard, card_points_on_line (P := P) l]
    exact hthreshold
  · intro l hl
    rw [card_secants hA, card_points_on_line (P := P) l]
    exact hthreshold
  · intro p
    simpa only [CoveredByLineFamily, mem_secants, covered_iff_exists_secant] using
      covered_iff_of_ordinaryUncovered_eq (L := L) hU p

/-- Above the strict incidence threshold, equal ordinary uncovered loci of equal-sized arcs
recover the arcs exactly. -/
theorem eq_of_ordinaryUncovered_eq
    {A B : Finset P} (hA : Arc (L := L) A) (hB : Arc (L := L) B)
    (hcard : A.card = B.card) (hthree : 3 ≤ A.card)
    (hthreshold : Nat.choose A.card 2 < PlaneOrder P L + 1)
    (hU : ordinaryUncovered (L := L) A = ordinaryUncovered (L := L) B) :
    A = B :=
  eq_of_secants_eq (L := L) hA hB hcard hthree
    (secants_eq_of_ordinaryUncovered_eq (L := L) hA hB hcard hthreshold hU)

/-- The two canonical reconstruction stages recover first the secant family and then the arc from
its ordinary uncovered locus. -/
theorem canonical_reconstruction
    {A : Finset P} (hA : Arc (L := L) A) (hthree : 3 ≤ A.card)
    (hthreshold : Nat.choose A.card 2 < PlaneOrder P L + 1) :
    linesAboveUncoveredThreshold (L := L) (ordinaryUncovered (L := L) A)
          (Nat.choose A.card 2) =
        secants (L := L) A ∧
      verticesOfLineFamily (P := P) (secants (L := L) A) A.card = A :=
  ⟨linesAboveUncoveredThreshold_eq_secants (L := L) hA hthreshold,
    verticesOfLineFamily_secants_eq (L := L) hA hthree⟩

/-- An equivariant transformation stabilizes an arc exactly when it stabilizes the arc's ordinary
uncovered locus.  Incidence-preserving projective and semilinear transformations satisfy the
equivariance hypotheses. -/
theorem stabilizes_iff_stabilizes_ordinaryUncovered
    {G : Type*} {A : Finset P} (hA : Arc (L := L) A) (hthree : 3 ≤ A.card)
    (hthreshold : Nat.choose A.card 2 < PlaneOrder P L + 1)
    (act : G → Finset P → Finset P)
    (hcard : ∀ g, (act g A).card = A.card)
    (harc : ∀ g, Arc (L := L) (act g A))
    (hequivariant : ∀ g,
      ordinaryUncovered (L := L) (act g A) =
        act g (ordinaryUncovered (L := L) A)) (g : G) :
    act g A = A ↔
      act g (ordinaryUncovered (L := L) A) =
        ordinaryUncovered (L := L) A := by
  constructor
  · intro hfix
    rw [← hequivariant, hfix]
  · intro hfix
    apply eq_of_ordinaryUncovered_eq (L := L) (harc g) hA (hcard g) (hcard g ▸ hthree)
    · simpa only [hcard] using hthreshold
    · simpa only [hequivariant] using hfix

end ArcReconstruction

end RelativeConicArcs
