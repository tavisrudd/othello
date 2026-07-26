import RelativeConicArcs.Defect

/-!
# Secant concurrence and maximum-matching rigidity

The secants of a finite arc are indexed by the two-element subsets of its vertices.  Secants
through a point outside the arc therefore form a matching.  Moreover, every pair of disjoint
edges has a unique concurrence point, so these matchings partition the edges of the Kneser graph
on the vertex pairs.

When the prescribed-hole defect vanishes, every concurrence matching has the maximum size
`floor (k / 2)`.  The second secant-index equation then gives the exact number of concurrence
centres.  For arbitrary defect, deleting at most the integer-normalized defect many secants
removes every edge belonging to a nonmaximum concurrence matching.  These statements use only
finite projective-plane incidence and the formal defect identity; they do not use coordinates, a
conic, or a classification of abstract matching designs.
-/

namespace RelativeConicArcs

open Finset

variable {P L : Type*} [Membership P L]

section FinitePlane

variable [Fintype P] [Fintype L] [DecidableEq P]
  [Configuration.ProjectivePlane P L]

/-- External points incident with at least two secants of an arc. -/
noncomputable def concurrenceCenters (A : Finset P) : Finset P := by
  classical
  exact (Finset.univ \ A).filter fun x => 2 ≤ pointIndex (L := L) A x

/-- Concurrence centres lying on the secant indexed by a fixed arc pair. -/
noncomputable def concurrenceCentersOnPair (A : Finset P) (e : ArcPair A) : Finset P := by
  classical
  exact (concurrenceCenters (L := L) A).filter fun x =>
    e ∈ pairsThrough (L := L) A x

omit [Configuration.ProjectivePlane P L] in
@[simp] theorem mem_concurrenceCenters {A : Finset P} {x : P} :
    x ∈ concurrenceCenters (L := L) A ↔
      x ∉ A ∧ 2 ≤ pointIndex (L := L) A x := by
  classical
  simp [concurrenceCenters]

@[simp] theorem mem_concurrenceCentersOnPair
    {A : Finset P} {e : ArcPair A} {x : P} :
    x ∈ concurrenceCentersOnPair (L := L) A e ↔
      x ∉ A ∧ 2 ≤ pointIndex (L := L) A x ∧
        e ∈ pairsThrough (L := L) A x := by
  classical
  simp [concurrenceCentersOnPair, and_assoc]

omit [Fintype P] [Fintype L] in
/-- At every external point, the endpoint pairs of incident secants are pairwise disjoint and
hence form a matching on the arc vertices. -/
theorem concurrence_matching {A : Finset P} (hA : Arc (L := L) A)
    {x : P} (hx : x ∉ A) :
    ((pairsThrough (L := L) A x : Finset (ArcPair A)) : Set (ArcPair A)).PairwiseDisjoint
      fun e => e.1 :=
  pairsThrough_pairwiseDisjoint (L := L) hA hx

omit [Fintype P] [Fintype L] in
/-- Two disjoint secant edges have a unique concurrence point, and that point lies outside the
arc.  This is the clique-decomposition form of the Kneser-edge partition. -/
theorem disjoint_arcPairs_existsUnique_concurrence
    {A : Finset P} (hA : Arc (L := L) A) {e f : ArcPair A}
    (hef : e ≠ f) (hdisj : Disjoint e.1 f.1) :
    ∃! x : P,
      x ∉ A ∧
      e ∈ pairsThrough (L := L) A x ∧
      f ∈ pairsThrough (L := L) A x := by
  classical
  have hlines : e.line (L := L) ≠ f.line (L := L) := by
    intro h
    exact hef (ArcPair.line_injective (L := L) hA h)
  obtain ⟨x, hx, huniq⟩ :=
    Configuration.HasPoints.existsUnique_point (P := P) (L := L) (e.line (L := L))
      (f.line (L := L)) hlines
  have hxA : x ∉ A := by
    intro hxmem
    have hxe : x ∈ e.1 := e.mem_of_mem_arc_of_mem_line hA hxmem hx.1
    have hxf : x ∈ f.1 := f.mem_of_mem_arc_of_mem_line hA hxmem hx.2
    exact Finset.disjoint_left.mp hdisj hxe hxf
  refine ⟨x, ⟨hxA, mem_pairsThrough.mpr hx.1, mem_pairsThrough.mpr hx.2⟩, ?_⟩
  intro y hy
  exact huniq y ⟨mem_pairsThrough.mp hy.2.1, mem_pairsThrough.mp hy.2.2⟩

omit [Fintype P] [Fintype L] in
/-- Distinct concurrence centres cannot determine the same matching of size at least two. -/
theorem concurrence_matching_injective
    {A : Finset P} (hA : Arc (L := L) A) {x y : P}
    (htwo : 2 ≤ (pairsThrough (L := L) A x).card)
    (hmatch : pairsThrough (L := L) A x = pairsThrough (L := L) A y) :
    x = y := by
  classical
  obtain ⟨e, f, he, hf, hef⟩ :=
    Finset.one_lt_card_iff.mp (by omega : 1 < (pairsThrough (L := L) A x).card)
  have hxe : x ∈ e.line (L := L) := mem_pairsThrough.mp he
  have hxf : x ∈ f.line (L := L) := mem_pairsThrough.mp hf
  have hye : y ∈ e.line (L := L) := mem_pairsThrough.mp (hmatch ▸ he)
  have hyf : y ∈ f.line (L := L) := mem_pairsThrough.mp (hmatch ▸ hf)
  have hlines : e.line (L := L) ≠ f.line (L := L) := by
    intro h
    exact hef (ArcPair.line_injective (L := L) hA h)
  exact (Configuration.Nondegenerate.eq_or_eq hxe hye hxf hyf).resolve_right hlines

/-- At zero prescribed-hole defect, every external point has secant index zero, one, or the
maximum matching size. -/
theorem pointIndex_eq_zero_or_one_or_half_of_scaledDefect_eq_zero
    {A H : Finset P} (hA : Arc (L := L) A) (hdisj : Disjoint A H)
    (hzero : scaledDefect (L := L) A H = 0) {x : P} (hxA : x ∉ A) :
    pointIndex (L := L) A x = 0 ∨
      pointIndex (L := L) A x = 1 ∨
      pointIndex (L := L) A x = A.card / 2 := by
  classical
  have hcases := (scaledDefect_eq_zero_iff (L := L) hA hdisj).mp hzero
  by_cases hxH : x ∈ H
  · rcases hcases.2 x hxH with h0 | hm
    · exact Or.inl h0
    · exact Or.inr (Or.inr hm)
  · have hxcovered : Covered (L := L) A x ∨ ¬ Covered (L := L) A x :=
      Classical.em _
    rcases hxcovered with hcov | hcov
    · have hxreq : x ∈ coveredRequired (L := L) A H := by
        simp [coveredRequired, requiredLocus, hxA, hxH, hcov]
      rcases hcases.1 x hxreq with h1 | hm
      · exact Or.inr (Or.inl h1)
      · exact Or.inr (Or.inr hm)
    · have hindex : pointIndex (L := L) A x = 0 := by
        simpa [Covered] using hcov
      exact Or.inl hindex

/-- Zero defect forces every nontrivial concurrence matching to have maximum size. -/
theorem concurrenceCenter_pointIndex_eq_half
    {A H : Finset P} (hA : Arc (L := L) A) (hdisj : Disjoint A H)
    (hzero : scaledDefect (L := L) A H = 0)
    {x : P} (hx : x ∈ concurrenceCenters (L := L) A) :
    pointIndex (L := L) A x = A.card / 2 := by
  rcases mem_concurrenceCenters.mp hx with ⟨hxA, htwo⟩
  rcases pointIndex_eq_zero_or_one_or_half_of_scaledDefect_eq_zero
      (L := L) hA hdisj hzero hxA with h0 | h1 | hm
  · omega
  · omega
  · exact hm

/-- The second secant-index equation gives the exact multiplicative centre count at zero defect.
Equivalently, division by `choose (floor (k / 2)) 2` gives the usual number of blocks in a
`MATCH(k, floor(k/2), 1)` design. -/
theorem concurrenceCenters_card_mul_choose_half
    {A H : Finset P} (hA : Arc (L := L) A) (hdisj : Disjoint A H)
    (hzero : scaledDefect (L := L) A H = 0) :
    (concurrenceCenters (L := L) A).card * Nat.choose (A.card / 2) 2 =
      3 * Nat.choose A.card 4 := by
  classical
  have hrestrict :
      (∑ x ∈ (Finset.univ \ A), Nat.choose (pointIndex (L := L) A x) 2) =
        ∑ x ∈ concurrenceCenters (L := L) A,
          Nat.choose (pointIndex (L := L) A x) 2 := by
    rw [concurrenceCenters, Finset.sum_filter]
    apply Finset.sum_congr rfl
    intro x hx
    by_cases htwo : 2 ≤ pointIndex (L := L) A x
    · simp [htwo]
    · have hlt : pointIndex (L := L) A x < 2 := Nat.lt_of_not_ge htwo
      simp [htwo, Nat.choose_eq_zero_of_lt hlt]
  calc
    (concurrenceCenters (L := L) A).card * Nat.choose (A.card / 2) 2 =
        ∑ x ∈ concurrenceCenters (L := L) A, Nat.choose (A.card / 2) 2 := by
          simp [Finset.sum_const, Nat.mul_comm]
    _ = ∑ x ∈ concurrenceCenters (L := L) A,
          Nat.choose (pointIndex (L := L) A x) 2 := by
          apply Finset.sum_congr rfl
          intro x hx
          rw [concurrenceCenter_pointIndex_eq_half (L := L) hA hdisj hzero hx]
    _ = 3 * Nat.choose A.card 4 := by
          rw [← hrestrict]
          exact second_secant_moment (L := L) hA

/-- For arcs of size at least four, the exact centre count is the quotient appearing in the
matching-design formula. -/
theorem concurrenceCenters_card_eq_quotient
    {A H : Finset P} (hA : Arc (L := L) A) (hdisj : Disjoint A H)
    (hzero : scaledDefect (L := L) A H = 0) (hfour : 4 ≤ A.card) :
    (concurrenceCenters (L := L) A).card =
      (3 * Nat.choose A.card 4) / Nat.choose (A.card / 2) 2 := by
  have hdenom : Nat.choose (A.card / 2) 2 ≠ 0 := by
    rw [Nat.choose_ne_zero_iff]
    omega
  apply Nat.eq_div_of_mul_eq_right hdenom
  simpa [Nat.mul_comm] using
    concurrenceCenters_card_mul_choose_half (L := L) hA hdisj hzero

/-- The number of Kneser edges contained in nonmaximum concurrence cliques, counted separately
over required points and prescribed holes. -/
noncomputable def badConcurrenceEdgeCount (A H : Finset P) : ℤ :=
  (∑ x ∈ intermediateRequired (L := L) A H,
      (Nat.choose (pointIndex (L := L) A x) 2 : ℤ)) +
    ∑ y ∈ intermediateHoles (L := L) A H,
      (Nat.choose (pointIndex (L := L) A y) 2 : ℤ)

private theorem two_choose_le_required_weight (m r : ℕ)
    (hrtwo : 2 ≤ r) (hrm : r < m) :
    2 * (Nat.choose r 2 : ℤ) ≤
      ((m : ℤ) - 1) * (((r : ℤ) - 1) * ((m : ℤ) - r)) := by
  have hchoose : 2 * (Nat.choose r 2 : ℤ) = (r : ℤ) * ((r : ℤ) - 1) := by
    rw [show ((2 : ℤ) * (Nat.choose r 2 : ℤ)) =
      ((2 * Nat.choose r 2 : ℕ) : ℤ) by norm_num]
    rw [two_mul_choose_two]
    push_cast [Nat.cast_sub (by omega : 1 ≤ r)]
    rfl
  rw [hchoose]
  have h₁ : 0 ≤ (r : ℤ) - 1 := by omega
  have h₂ : 0 ≤ (m : ℤ) := by omega
  have h₃ : 0 ≤ (m : ℤ) - r - 1 := by omega
  nlinarith [mul_nonneg h₁ (mul_nonneg h₂ h₃)]

private theorem two_choose_le_hole_weight (m r : ℕ)
    (hrone : 1 ≤ r) (hrm : r < m) :
    2 * (Nat.choose r 2 : ℤ) ≤
      ((m : ℤ) - 1) * ((r : ℤ) * ((m : ℤ) - r)) := by
  have hchoose : 2 * (Nat.choose r 2 : ℤ) = (r : ℤ) * ((r : ℤ) - 1) := by
    rw [show ((2 : ℤ) * (Nat.choose r 2 : ℤ)) =
      ((2 * Nat.choose r 2 : ℕ) : ℤ) by norm_num]
    rw [two_mul_choose_two]
    push_cast [Nat.cast_sub hrone]
    rfl
  rw [hchoose]
  have h₁ : 0 ≤ (r : ℤ) := by omega
  have h₂ : 0 ≤ (m : ℤ) := by omega
  have h₃ : 0 ≤ (m : ℤ) - r - 1 := by omega
  nlinarith [mul_nonneg h₁ (mul_nonneg h₂ h₃)]

/-- Quantitative bad-edge stability.  Twice the number of Kneser edges in nonmaximum concurrence
cliques is at most `(floor(k/2) - 1)` times the integer-normalized defect.  Since the latter equals
`floor(k/2)` times the paper's defect, this is its stated
`floor(k/2) * (floor(k/2)-1) * Δ / 2` bound. -/
theorem two_mul_badConcurrenceEdgeCount_le
    {A H : Finset P} (hA : Arc (L := L) A) (hdisj : Disjoint A H) :
    2 * badConcurrenceEdgeCount (L := L) A H ≤
      (((A.card / 2 : ℕ) : ℤ) - 1) * scaledDefect (L := L) A H := by
  classical
  let m := A.card / 2
  let reqWeight : P → ℤ := fun x =>
    ((pointIndex (L := L) A x : ℤ) - 1) *
      ((m : ℤ) - pointIndex (L := L) A x)
  let holeWeight : P → ℤ := fun y =>
    (pointIndex (L := L) A y : ℤ) *
      ((m : ℤ) - pointIndex (L := L) A y)
  have hreqLocal :
      2 * (∑ x ∈ intermediateRequired (L := L) A H,
        (Nat.choose (pointIndex (L := L) A x) 2 : ℤ)) ≤
      ((m : ℤ) - 1) *
        ∑ x ∈ intermediateRequired (L := L) A H, reqWeight x := by
    rw [Finset.mul_sum, Finset.mul_sum]
    apply Finset.sum_le_sum
    intro x hx
    have hx' := Finset.mem_filter.mp hx
    exact two_choose_le_required_weight m (pointIndex (L := L) A x) hx'.2.1 hx'.2.2
  have hholeLocal :
      2 * (∑ y ∈ intermediateHoles (L := L) A H,
        (Nat.choose (pointIndex (L := L) A y) 2 : ℤ)) ≤
      ((m : ℤ) - 1) *
        ∑ y ∈ intermediateHoles (L := L) A H, holeWeight y := by
    rw [Finset.mul_sum, Finset.mul_sum]
    apply Finset.sum_le_sum
    intro y hy
    have hy' := Finset.mem_filter.mp hy
    exact two_choose_le_hole_weight m (pointIndex (L := L) A y) hy'.2.1 hy'.2.2
  have hreqNonneg (x : P) (hx : x ∈ coveredRequired (L := L) A H) :
      0 ≤ reqWeight x := by
    have hxA : x ∉ A := by
      have := Finset.mem_filter.mp hx
      have hxnot := (Finset.mem_sdiff.mp this.1).2
      exact fun hxA => hxnot (Finset.mem_union_left H hxA)
    have hupper := pointIndex_le_half_card (L := L) hA hxA
    have hpositive : 1 ≤ pointIndex (L := L) A x := by
      have := (Finset.mem_filter.mp hx).2
      have : 0 < pointIndex (L := L) A x := by simpa [Covered] using this
      omega
    dsimp [reqWeight, m]
    have hleft : 0 ≤ (pointIndex (L := L) A x : ℤ) - 1 := by omega
    have hright :
        0 ≤ ((A.card / 2 : ℕ) : ℤ) - pointIndex (L := L) A x := by omega
    exact mul_nonneg hleft hright
  have hholeNonneg (y : P) (hy : y ∈ H) :
      0 ≤ holeWeight y := by
    have hyA : y ∉ A := fun hyA => Finset.disjoint_left.mp hdisj hyA hy
    have hupper := pointIndex_le_half_card (L := L) hA hyA
    dsimp [holeWeight, m]
    have hleft : 0 ≤ (pointIndex (L := L) A y : ℤ) := by omega
    have hright :
        0 ≤ ((A.card / 2 : ℕ) : ℤ) - pointIndex (L := L) A y := by omega
    exact mul_nonneg hleft hright
  have hreqSubset :
      (∑ x ∈ intermediateRequired (L := L) A H, reqWeight x) ≤
        ∑ x ∈ coveredRequired (L := L) A H, reqWeight x :=
    Finset.sum_le_sum_of_subset_of_nonneg (Finset.filter_subset _ _)
      (fun x hx _ => hreqNonneg x hx)
  have hholeSubset :
      (∑ y ∈ intermediateHoles (L := L) A H, holeWeight y) ≤
        ∑ y ∈ H, holeWeight y :=
    Finset.sum_le_sum_of_subset_of_nonneg (Finset.filter_subset _ _)
      (fun y hy _ => hholeNonneg y hy)
  have hmnonneg : 0 ≤ (m : ℤ) - 1 ∨ (m : ℤ) - 1 < 0 := le_or_gt 0 _
  rcases hmnonneg with hmnonneg | hmneg
  · have hreq := hreqLocal.trans
      (mul_le_mul_of_nonneg_left hreqSubset hmnonneg)
    have hhole := hholeLocal.trans
      (mul_le_mul_of_nonneg_left hholeSubset hmnonneg)
    rw [scaledDefect_eq_remainders (L := L) hA hdisj]
    simp only [badConcurrenceEdgeCount, requiredRemainder, holeRemainder]
    nlinarith
  · have hmzero : m = 0 := by
      dsimp [m] at hmneg
      omega
    have hreqEmpty : intermediateRequired (L := L) A H = ∅ := by
      ext x
      simp [intermediateRequired, m, hmzero]
    have hholeEmpty : intermediateHoles (L := L) A H = ∅ := by
      ext y
      simp [intermediateHoles, m, hmzero]
    have hsmall : A.card < 2 := by
      dsimp [m] at hmzero
      omega
    have hchooseTwo : Nat.choose A.card 2 = 0 :=
      Nat.choose_eq_zero_of_lt hsmall
    have hchooseFour : Nat.choose A.card 4 = 0 :=
      Nat.choose_eq_zero_of_lt (by omega)
    have hhalf : A.card / 2 = 0 := by omega
    have hsecEmpty : secants (L := L) A = ∅ := by
      apply Finset.card_eq_zero.mp
      rw [card_secants hA, hchooseTwo]
    have hindexZero (x : P) : pointIndex (L := L) A x = 0 := by
      simp [pointIndex, hsecEmpty]
    have hscaledZero : scaledDefect (L := L) A H = 0 := by
      simp [scaledDefect, holeIncidence, hhalf, hchooseTwo, hchooseFour, hindexZero]
    simp [badConcurrenceEdgeCount, hreqEmpty, hholeEmpty, hscaledZero]

private noncomputable def allButOne {α : Type*} [DecidableEq α]
    (s : Finset α) : Finset α :=
  if h : s.Nonempty then s.erase h.choose else ∅

private theorem allButOne_subset {α : Type*} [DecidableEq α] (s : Finset α) :
    allButOne s ⊆ s := by
  classical
  by_cases h : s.Nonempty
  · simp only [allButOne, dif_pos h]
    exact Finset.erase_subset _ _
  · simp [allButOne, h]

private theorem card_allButOne {α : Type*} [DecidableEq α] {s : Finset α}
    (h : s.Nonempty) :
    (allButOne s).card = s.card - 1 := by
  classical
  simp [allButOne, h, Finset.card_erase_of_mem h.choose_spec]

private theorem eq_of_mem_of_not_mem_allButOne
    {α : Type*} [DecidableEq α] {s : Finset α} {e f : α}
    (he : e ∈ s) (he' : e ∉ allButOne s)
    (hf : f ∈ s) (hf' : f ∉ allButOne s) :
    e = f := by
  classical
  have h : s.Nonempty := ⟨e, he⟩
  have heq : e = h.choose := by
    simpa [allButOne, h, he] using he'
  have hfq : f = h.choose := by
    simpa [allButOne, h, hf] using hf'
  exact heq.trans hfq.symm

/-- Centrewise form of secant-deletion stability.  There is a set of at most
`scaledDefect A H` secants such that no two distinct surviving secants concur at a centre of index
below `floor (|A| / 2)`. -/
theorem exists_secantDeletionSet_at_centers
    {A H : Finset P} (hA : Arc (L := L) A) (hdisj : Disjoint A H) :
    ∃ D : Finset (ArcPair A),
      (D.card : ℤ) ≤ scaledDefect (L := L) A H ∧
        ∀ x : P, x ∈ concurrenceCenters (L := L) A →
          ∀ e ∈ pairsThrough (L := L) A x, e ∉ D →
            ∀ f ∈ pairsThrough (L := L) A x, f ∉ D → e ≠ f →
              pointIndex (L := L) A x = A.card / 2 := by
  classical
  let deletionAt : P → Finset (ArcPair A) := fun x =>
    allButOne (pairsThrough (L := L) A x)
  let Dreq : Finset (ArcPair A) :=
    (intermediateRequired (L := L) A H).biUnion deletionAt
  let Dhole : Finset (ArcPair A) :=
    (intermediateHoles (L := L) A H).biUnion deletionAt
  let D := Dreq ∪ Dhole
  refine ⟨D, ?_, ?_⟩
  · let m := A.card / 2
    let reqWeight : P → ℤ := fun x =>
      ((pointIndex (L := L) A x : ℤ) - 1) *
        ((m : ℤ) - pointIndex (L := L) A x)
    let holeWeight : P → ℤ := fun y =>
      (pointIndex (L := L) A y : ℤ) *
        ((m : ℤ) - pointIndex (L := L) A y)
    have hreqCard :
        (Dreq.card : ℤ) ≤
          ∑ x ∈ intermediateRequired (L := L) A H,
            ((pointIndex (L := L) A x - 1 : ℕ) : ℤ) := by
      have hcard :
          Dreq.card ≤
            ∑ x ∈ intermediateRequired (L := L) A H, (deletionAt x).card := by
        dsimp [Dreq]
        exact Finset.card_biUnion_le
      calc
        (Dreq.card : ℤ) ≤
            (↑(∑ x ∈ intermediateRequired (L := L) A H,
              (deletionAt x).card) : ℤ) := by exact_mod_cast hcard
        _ = ∑ x ∈ intermediateRequired (L := L) A H,
              ((pointIndex (L := L) A x - 1 : ℕ) : ℤ) := by
          push_cast
          apply Finset.sum_congr rfl
          intro x hx
          have hx' := Finset.mem_filter.mp hx
          have hnonempty :
              (pairsThrough (L := L) A x).Nonempty := by
            rw [← Finset.card_pos, ← pointIndex_eq_card_pairsThrough hA]
            omega
          have hdel :
              (deletionAt x).card = pointIndex (L := L) A x - 1 := by
            rw [show deletionAt x =
              allButOne (pairsThrough (L := L) A x) by rfl,
              card_allButOne hnonempty, pointIndex_eq_card_pairsThrough hA]
          exact_mod_cast hdel
    have hholeCard :
        (Dhole.card : ℤ) ≤
          ∑ y ∈ intermediateHoles (L := L) A H,
            ((pointIndex (L := L) A y - 1 : ℕ) : ℤ) := by
      have hcard :
          Dhole.card ≤
            ∑ y ∈ intermediateHoles (L := L) A H, (deletionAt y).card := by
        dsimp [Dhole]
        exact Finset.card_biUnion_le
      calc
        (Dhole.card : ℤ) ≤
            (↑(∑ y ∈ intermediateHoles (L := L) A H,
              (deletionAt y).card) : ℤ) := by exact_mod_cast hcard
        _ = ∑ y ∈ intermediateHoles (L := L) A H,
              ((pointIndex (L := L) A y - 1 : ℕ) : ℤ) := by
          push_cast
          apply Finset.sum_congr rfl
          intro y hy
          have hy' := Finset.mem_filter.mp hy
          have hnonempty :
              (pairsThrough (L := L) A y).Nonempty := by
            rw [← Finset.card_pos, ← pointIndex_eq_card_pairsThrough hA]
            omega
          have hdel :
              (deletionAt y).card = pointIndex (L := L) A y - 1 := by
            rw [show deletionAt y =
              allButOne (pairsThrough (L := L) A y) by rfl,
              card_allButOne hnonempty, pointIndex_eq_card_pairsThrough hA]
          exact_mod_cast hdel
    have hreqCost :
        (∑ x ∈ intermediateRequired (L := L) A H,
          ((pointIndex (L := L) A x - 1 : ℕ) : ℤ)) ≤
            ∑ x ∈ intermediateRequired (L := L) A H, reqWeight x := by
      apply Finset.sum_le_sum
      intro x hx
      have hx' := Finset.mem_filter.mp hx
      have hcast :
          ((pointIndex (L := L) A x - 1 : ℕ) : ℤ) =
            (pointIndex (L := L) A x : ℤ) - 1 := by
        omega
      rw [hcast]
      dsimp [reqWeight, m]
      have hleft : 0 ≤ (pointIndex (L := L) A x : ℤ) - 1 := by omega
      have hright :
          1 ≤ ((A.card / 2 : ℕ) : ℤ) - pointIndex (L := L) A x := by omega
      nlinarith
    have hholeCost :
        (∑ y ∈ intermediateHoles (L := L) A H,
          ((pointIndex (L := L) A y - 1 : ℕ) : ℤ)) ≤
            ∑ y ∈ intermediateHoles (L := L) A H, holeWeight y := by
      apply Finset.sum_le_sum
      intro y hy
      have hy' := Finset.mem_filter.mp hy
      have hcast :
          ((pointIndex (L := L) A y - 1 : ℕ) : ℤ) =
            (pointIndex (L := L) A y : ℤ) - 1 := by
        omega
      rw [hcast]
      dsimp [holeWeight, m]
      have hr : 1 ≤ (pointIndex (L := L) A y : ℤ) := by omega
      have hright :
          1 ≤ ((A.card / 2 : ℕ) : ℤ) - pointIndex (L := L) A y := by omega
      nlinarith
    have hreqNonneg (x : P) (hx : x ∈ coveredRequired (L := L) A H) :
        0 ≤ reqWeight x := by
      have hxA : x ∉ A := by
        have hx' := Finset.mem_filter.mp hx
        have hxnot := (Finset.mem_sdiff.mp hx'.1).2
        exact fun hxA => hxnot (Finset.mem_union_left H hxA)
      have hupper := pointIndex_le_half_card (L := L) hA hxA
      have hpositive : 1 ≤ pointIndex (L := L) A x := by
        have hx' := (Finset.mem_filter.mp hx).2
        have : 0 < pointIndex (L := L) A x := by simpa [Covered] using hx'
        omega
      dsimp [reqWeight, m]
      exact mul_nonneg (by omega) (by omega)
    have hholeNonneg (y : P) (hy : y ∈ H) :
        0 ≤ holeWeight y := by
      have hyA : y ∉ A := fun hyA => Finset.disjoint_left.mp hdisj hyA hy
      have hupper := pointIndex_le_half_card (L := L) hA hyA
      dsimp [holeWeight, m]
      exact mul_nonneg (by omega) (by omega)
    have hreqSubset :
        (∑ x ∈ intermediateRequired (L := L) A H, reqWeight x) ≤
          ∑ x ∈ coveredRequired (L := L) A H, reqWeight x :=
      Finset.sum_le_sum_of_subset_of_nonneg (Finset.filter_subset _ _)
        (fun x hx _ => hreqNonneg x hx)
    have hholeSubset :
        (∑ y ∈ intermediateHoles (L := L) A H, holeWeight y) ≤
          ∑ y ∈ H, holeWeight y :=
      Finset.sum_le_sum_of_subset_of_nonneg (Finset.filter_subset _ _)
        (fun y hy _ => hholeNonneg y hy)
    have hDcard : (D.card : ℤ) ≤ (Dreq.card : ℤ) + Dhole.card := by
      have := Finset.card_union_le Dreq Dhole
      dsimp [D]
      exact_mod_cast this
    rw [scaledDefect_eq_remainders (L := L) hA hdisj]
    simp only [requiredRemainder, holeRemainder]
    exact hDcard.trans <|
      add_le_add (hreqCard.trans <| hreqCost.trans hreqSubset)
        (hholeCard.trans <| hholeCost.trans hholeSubset)
  · intro x hx e he heD f hf hfD hef
    have hxA : x ∉ A := (mem_concurrenceCenters.mp hx).1
    have hupper := pointIndex_le_half_card (L := L) hA hxA
    by_contra hne
    have hlt : pointIndex (L := L) A x < A.card / 2 := by omega
    have htwo : 2 ≤ pointIndex (L := L) A x :=
      (mem_concurrenceCenters.mp hx).2
    have hxexternal : x ∈ Finset.univ \ A := Finset.mem_sdiff.mpr ⟨Finset.mem_univ _, hxA⟩
    rw [external_eq_holes_union_required hdisj] at hxexternal
    rcases Finset.mem_union.mp hxexternal with hxH | hxrequired
    · have hxIntermediate : x ∈ intermediateHoles (L := L) A H := by
        exact Finset.mem_filter.mpr ⟨hxH, by omega⟩
      have hxDelete : deletionAt x ⊆ D := by
        intro g hg
        exact Finset.mem_union_right Dreq <|
          Finset.mem_biUnion.mpr ⟨x, hxIntermediate, hg⟩
      have he' : e ∉ deletionAt x := fun he' => heD (hxDelete he')
      have hf' : f ∉ deletionAt x := fun hf' => hfD (hxDelete hf')
      exact hef (eq_of_mem_of_not_mem_allButOne he he' hf hf')
    · have hxCovered : x ∈ coveredRequired (L := L) A H := by
        exact Finset.mem_filter.mpr ⟨hxrequired, by simpa [Covered] using (show
          0 < pointIndex (L := L) A x by omega)⟩
      have hxIntermediate : x ∈ intermediateRequired (L := L) A H := by
        exact Finset.mem_filter.mpr ⟨hxCovered, htwo, hlt⟩
      have hxDelete : deletionAt x ⊆ D := by
        intro g hg
        exact Finset.mem_union_left Dhole <|
          Finset.mem_biUnion.mpr ⟨x, hxIntermediate, hg⟩
      have he' : e ∉ deletionAt x := fun he' => heD (hxDelete he')
      have hf' : f ∉ deletionAt x := fun hf' => hfD (hxDelete hf')
      exact hef (eq_of_mem_of_not_mem_allButOne he he' hf hf')

/-- Secant-deletion stability.  There is a set of at most `scaledDefect A H` secants such that
every two surviving secants with disjoint endpoint pairs have a unique concurrence point of index
`floor (|A| / 2)`.  Thus every surviving Kneser edge belongs, in the original concurrence
decomposition, to a maximum matching. -/
theorem exists_secantDeletionSet
    {A H : Finset P} (hA : Arc (L := L) A) (hdisj : Disjoint A H) :
    ∃ D : Finset (ArcPair A),
      (D.card : ℤ) ≤ scaledDefect (L := L) A H ∧
        ∀ e : ArcPair A, e ∉ D →
          ∀ f : ArcPair A, f ∉ D → e ≠ f → Disjoint e.1 f.1 →
            ∃! x : P,
              x ∉ A ∧
                e ∈ pairsThrough (L := L) A x ∧
                f ∈ pairsThrough (L := L) A x ∧
                pointIndex (L := L) A x = A.card / 2 := by
  classical
  obtain ⟨D, hcard, hmaximum⟩ :=
    exists_secantDeletionSet_at_centers (L := L) hA hdisj
  refine ⟨D, hcard, ?_⟩
  intro e heD f hfD hef hdisjef
  obtain ⟨x, hx, hunique⟩ :=
    disjoint_arcPairs_existsUnique_concurrence (L := L) hA hef hdisjef
  have htwo : 2 ≤ (pairsThrough (L := L) A x).card := by
    by_contra hnot
    have hcardOne : (pairsThrough (L := L) A x).card ≤ 1 := by omega
    exact hef (Finset.card_le_one.mp hcardOne e hx.2.1 f hx.2.2)
  have hxcenter : x ∈ concurrenceCenters (L := L) A := by
    exact mem_concurrenceCenters.mpr
      ⟨hx.1, by rw [pointIndex_eq_card_pairsThrough hA]; exact htwo⟩
  have hindex :
      pointIndex (L := L) A x = A.card / 2 :=
    hmaximum x hxcenter e hx.2.1 heD f hx.2.2 hfD hef
  refine ⟨x, ⟨hx.1, hx.2.1, hx.2.2, hindex⟩, ?_⟩
  intro y hy
  exact hunique y ⟨hy.1, hy.2.1, hy.2.2.1⟩

private noncomputable def orderedPairsWithFirst
    (A : Finset P) (e : ArcPair A) : Finset (ArcPair A × ArcPair A) := by
  classical
  exact (externalOrderedPairs (L := L) A).filter fun z => z.1 = e

private noncomputable def orderedPairsThroughWithFirst
    (A : Finset P) (e : ArcPair A) (x : P) : Finset (ArcPair A × ArcPair A) := by
  classical
  exact (orderedPairsThrough (L := L) A x).filter fun z => z.1 = e

omit [Fintype P] in
private theorem card_orderedPairsThroughWithFirst
    {A : Finset P} (hA : Arc (L := L) A) (e : ArcPair A) (x : P) :
    (orderedPairsThroughWithFirst (L := L) A e x).card =
      if e ∈ pairsThrough (L := L) A x
      then pointIndex (L := L) A x - 1 else 0 := by
  classical
  by_cases he : e ∈ pairsThrough (L := L) A x
  · have hset :
        orderedPairsThroughWithFirst (L := L) A e x =
          ((pairsThrough (L := L) A x).erase e).image fun f => (e, f) := by
      ext z
      obtain ⟨g, f⟩ := z
      constructor
      · intro hz
        have hz' := Finset.mem_filter.mp hz
        have hthrough := mem_orderedPairsThrough.mp hz'.1
        have hge : g = e := hz'.2
        cases hge
        exact Finset.mem_image.mpr
          ⟨f, Finset.mem_erase.mpr ⟨hthrough.2.2.symm,
            mem_pairsThrough.mpr hthrough.2.1⟩, rfl⟩
      · intro hz
        obtain ⟨f', hf', hpair⟩ := Finset.mem_image.mp hz
        have heg : e = g := congrArg Prod.fst hpair
        have hf'f : f' = f := congrArg Prod.snd hpair
        cases heg
        cases hf'f
        have hfmem := Finset.mem_erase.mp hf'
        exact Finset.mem_filter.mpr
          ⟨mem_orderedPairsThrough.mpr
            ⟨mem_pairsThrough.mp he, mem_pairsThrough.mp hfmem.2, hfmem.1.symm⟩, rfl⟩
    rw [hset, Finset.card_image_of_injective _ (by intro f g h; exact congrArg Prod.snd h)]
    rw [Finset.card_erase_of_mem he, pointIndex_eq_card_pairsThrough hA]
    simp [he]
  · have hempty : orderedPairsThroughWithFirst (L := L) A e x = ∅ := by
      ext z
      obtain ⟨g, f⟩ := z
      constructor
      · intro hz
        have hz' := Finset.mem_filter.mp hz
        have hthrough := mem_orderedPairsThrough.mp hz'.1
        have hge : g = e := hz'.2
        cases hge
        exact (he (mem_pairsThrough.mpr hthrough.1)).elim
      · simp
    simp [hempty, he]

omit [Fintype L] in
private theorem card_orderedPairsWithFirst
    {A : Finset P} (hA : Arc (L := L) A) (e : ArcPair A) :
    (orderedPairsWithFirst (L := L) A e).card = Nat.choose (A.card - 2) 2 := by
  classical
  have hset :
      orderedPairsWithFirst (L := L) A e =
        (disjointPartners A e).image fun f => (e, f) := by
    ext z
    obtain ⟨g, f⟩ := z
    constructor
    · intro hz
      have hz' := Finset.mem_filter.mp hz
      rw [externalOrderedPairs_eq_disjointOrderedPairs (L := L) hA] at hz'
      have hge : g = e := hz'.2
      cases hge
      exact Finset.mem_image.mpr ⟨f, mem_disjointPartners.mpr
        (mem_disjointOrderedPairs.mp hz'.1), rfl⟩
    · intro hz
      obtain ⟨f', hf', hpair⟩ := Finset.mem_image.mp hz
      have heg : e = g := congrArg Prod.fst hpair
      have hf'f : f' = f := congrArg Prod.snd hpair
      cases heg
      cases hf'f
      rw [orderedPairsWithFirst, Finset.mem_filter,
        externalOrderedPairs_eq_disjointOrderedPairs (L := L) hA]
      exact ⟨mem_disjointOrderedPairs.mpr (mem_disjointPartners.mp hf'), rfl⟩
  rw [hset, Finset.card_image_of_injective _ (by intro f g h; exact congrArg Prod.snd h)]
  exact card_disjointPartners A e

omit [Fintype L] in
private theorem orderedPairsWithFirst_eq_biUnion
    {A : Finset P} (e : ArcPair A) :
    orderedPairsWithFirst (L := L) A e =
      (Finset.univ \ A).biUnion fun x => orderedPairsThroughWithFirst (L := L) A e x := by
  classical
  ext z
  simp only [orderedPairsWithFirst, externalOrderedPairs, orderedPairsThroughWithFirst,
    Finset.mem_filter, Finset.mem_biUnion]
  aesop

omit [Fintype L] in
private theorem orderedPairsThroughWithFirst_pairwiseDisjoint
    {A : Finset P} (hA : Arc (L := L) A) (e : ArcPair A) :
    (((Finset.univ \ A : Finset P) : Set P).PairwiseDisjoint
      fun x => orderedPairsThroughWithFirst (L := L) A e x) := by
  intro x hx y hy hxy
  exact (orderedPairsThrough_pairwiseDisjoint (L := L) hA hx hy hxy).mono
    (Finset.filter_subset _ _) (Finset.filter_subset _ _)

/-- At zero defect, every fixed secant occurs in exactly enough maximum concurrence matchings to
account for all of its disjoint partner edges.  Division by `floor(k/2) - 1` gives the paper's
per-secant centre count. -/
theorem concurrenceCentersOnPair_card_mul_sub_one
    {A H : Finset P} (hA : Arc (L := L) A) (hdisj : Disjoint A H)
    (hzero : scaledDefect (L := L) A H = 0) (e : ArcPair A) :
    (concurrenceCentersOnPair (L := L) A e).card * (A.card / 2 - 1) =
      Nat.choose (A.card - 2) 2 := by
  classical
  have hcardSum :
      Nat.choose (A.card - 2) 2 =
        ∑ x ∈ (Finset.univ \ A),
          if e ∈ pairsThrough (L := L) A x
          then pointIndex (L := L) A x - 1 else 0 := by
    rw [← card_orderedPairsWithFirst (L := L) hA e,
      orderedPairsWithFirst_eq_biUnion (L := L) e,
      Finset.card_biUnion (orderedPairsThroughWithFirst_pairwiseDisjoint (L := L) hA e)]
    apply Finset.sum_congr rfl
    intro x hx
    exact card_orderedPairsThroughWithFirst (L := L) hA e x
  have hsummand (x : P) (hx : x ∈ Finset.univ \ A) :
      (if e ∈ pairsThrough (L := L) A x
        then pointIndex (L := L) A x - 1 else 0) =
      if x ∈ concurrenceCentersOnPair (L := L) A e
        then A.card / 2 - 1 else 0 := by
    have hxA : x ∉ A := (Finset.mem_sdiff.mp hx).2
    rcases pointIndex_eq_zero_or_one_or_half_of_scaledDefect_eq_zero
        (L := L) hA hdisj hzero hxA with h0 | h1 | hm
    · have he : e ∉ pairsThrough (L := L) A x := by
        intro he
        have : 0 < pointIndex (L := L) A x := by
          rw [pointIndex_eq_card_pairsThrough hA]
          exact Finset.card_pos.mpr ⟨e, he⟩
        omega
      simp [concurrenceCentersOnPair, concurrenceCenters, he, h0]
    · have hnotcenter : x ∉ concurrenceCentersOnPair (L := L) A e := by
        simp [concurrenceCentersOnPair, concurrenceCenters, h1]
      by_cases he : e ∈ pairsThrough (L := L) A x
      · simp [he, h1, hnotcenter]
      · simp [he, hnotcenter]
    · by_cases he : e ∈ pairsThrough (L := L) A x
      · by_cases htwo : 2 ≤ pointIndex (L := L) A x
        · have hcenter : x ∈ concurrenceCentersOnPair (L := L) A e := by
            exact mem_concurrenceCentersOnPair.mpr ⟨hxA, htwo, he⟩
          simp [he, hm, hcenter]
        · have hnotcenter : x ∉ concurrenceCentersOnPair (L := L) A e := by
            simp [concurrenceCentersOnPair, concurrenceCenters, htwo]
          simp [he, hm, hnotcenter]
          omega
      · have hnotcenter : x ∉ concurrenceCentersOnPair (L := L) A e := by
          intro hcenter
          exact he (mem_concurrenceCentersOnPair.mp hcenter).2.2
        simp [he, hnotcenter]
  calc
    (concurrenceCentersOnPair (L := L) A e).card * (A.card / 2 - 1) =
        ∑ x ∈ concurrenceCentersOnPair (L := L) A e, (A.card / 2 - 1) := by
          simp [Finset.sum_const, Nat.mul_comm]
    _ = ∑ x ∈ (Finset.univ \ A),
          if x ∈ concurrenceCentersOnPair (L := L) A e
        then A.card / 2 - 1 else 0 := by
          have hfilter :
              (Finset.univ \ A).filter
                  (fun x => x ∈ concurrenceCentersOnPair (L := L) A e) =
                concurrenceCentersOnPair (L := L) A e := by
            ext x
            simp
          symm
          rw [← Finset.sum_filter, hfilter]
    _ = ∑ x ∈ (Finset.univ \ A),
          if e ∈ pairsThrough (L := L) A x
          then pointIndex (L := L) A x - 1 else 0 := by
          apply Finset.sum_congr rfl
          intro x hx
          exact (hsummand x hx).symm
    _ = Nat.choose (A.card - 2) 2 := hcardSum.symm

/-- For arcs of size at least four, every secant has the exact quotient number of zero-defect
maximum-matching centres stated in the incidence double count. -/
theorem concurrenceCentersOnPair_card_eq_quotient
    {A H : Finset P} (hA : Arc (L := L) A) (hdisj : Disjoint A H)
    (hzero : scaledDefect (L := L) A H = 0) (hfour : 4 ≤ A.card)
    (e : ArcPair A) :
    (concurrenceCentersOnPair (L := L) A e).card =
      Nat.choose (A.card - 2) 2 / (A.card / 2 - 1) := by
  have hdenom : A.card / 2 - 1 ≠ 0 := by omega
  apply Nat.eq_div_of_mul_eq_right hdenom
  simpa [Nat.mul_comm] using
    concurrenceCentersOnPair_card_mul_sub_one (L := L) hA hdisj hzero e

end FinitePlane

end RelativeConicArcs
