import RelativeConicArcs.SmallKChordMoments

/-!
# Geometric small-arc chord-moment consequences

This file connects the integer identities in `SmallKChordMoments` to actual arcs in an
arbitrary finite projective plane.  The off-arc index fibers are defined from `pointIndex`, and
the classical first and second secant moments supply all of the arithmetic hypotheses.

For four- and five-arcs every off-arc point has index at most two.  For seven-arcs the maximum
is three, and the remaining free parameter is the cardinality of the index-three fiber.  Thus
the conclusions below concern the genuine `uncovered A ∅` locus, not abstract spectrum
variables.
-/

namespace RelativeConicArcs

open Configuration Finset

namespace SmallKGeometricBridge

variable {P L : Type*} [Membership P L]
  [Fintype P] [Fintype L] [DecidableEq P] [DecidableEq L]
  [Configuration.ProjectivePlane P L]

noncomputable local instance instDecidableIncidence (p : P) (l : L) : Decidable (p ∈ l) :=
  Classical.propDecidable _

/-- Off-arc points lying on exactly `i` secants of `A`. -/
noncomputable def offArcIndexFiber (A : Finset P) (i : ℕ) : Finset P := by
  classical
  exact (Finset.univ \ A).filter fun x => pointIndex (L := L) A x = i

omit [DecidableEq L] [Configuration.ProjectivePlane P L] in
@[simp] theorem mem_offArcIndexFiber {A : Finset P} {i : ℕ} {x : P} :
    x ∈ offArcIndexFiber (L := L) A i ↔ x ∉ A ∧ pointIndex (L := L) A x = i := by
  classical
  simp [offArcIndexFiber]

omit [DecidableEq L] [Configuration.ProjectivePlane P L] in
/-- With no prescribed hole set, the ordinary uncovered locus is the index-zero fiber. -/
theorem uncovered_empty_eq_offArcIndexFiber_zero (A : Finset P) :
    uncovered (L := L) A ∅ = offArcIndexFiber (L := L) A 0 := by
  classical
  ext x
  simp [uncovered, requiredLocus, Covered, offArcIndexFiber]

private theorem card_filter_cast_eq_sum_indicator
    {X : Type*} (E : Finset X) (p : X → Prop) [DecidablePred p] :
    ((E.filter p).card : ℤ) =
      ∑ x ∈ E, if p x then (1 : ℤ) else 0 := by
  calc
    ((E.filter p).card : ℤ) = ∑ _x ∈ E.filter p, (1 : ℤ) := by simp
    _ = ∑ x ∈ E, if p x then (1 : ℤ) else 0 := by
      rw [Finset.sum_filter]

omit [DecidableEq L] in
private theorem offArc_card_cast (A : Finset P) :
    (((Finset.univ \ A).card : ℕ) : ℤ) + (A.card : ℤ) =
      (PlaneOrder P L : ℤ) ^ 2 + (PlaneOrder P L : ℤ) + 1 := by
  have hsub : (Finset.univ \ A).card + A.card = Fintype.card P := by
    rw [Finset.card_sdiff_of_subset (Finset.subset_univ A), Finset.card_univ]
    have hle : A.card ≤ Fintype.card P := by
      simpa only [Finset.card_univ] using Finset.card_le_card (Finset.subset_univ A)
    omega
  have hpoints := card_points (P := P) (L := L)
  exact_mod_cast hsub.trans hpoints

private theorem offArc_index_le_three {A : Finset P}
    (hA : Arc (L := L) A) (hcard : A.card ≤ 7)
    {x : P} (hx : x ∈ Finset.univ \ A) :
    pointIndex (L := L) A x ≤ 3 := by
  have hxA : x ∉ A := (Finset.mem_sdiff.mp hx).2
  have hhalf := pointIndex_le_half_card (L := L) hA hxA
  omega

private theorem sum_index_eq_fibers_le_three {A : Finset P}
    (hA : Arc (L := L) A) (hcard : A.card ≤ 7) :
    (∑ x ∈ (Finset.univ \ A), (pointIndex (L := L) A x : ℤ)) =
      ((offArcIndexFiber (L := L) A 1).card : ℤ) +
        2 * ((offArcIndexFiber (L := L) A 2).card : ℤ) +
        3 * ((offArcIndexFiber (L := L) A 3).card : ℤ) := by
  classical
  let E : Finset P := Finset.univ \ A
  calc
    (∑ x ∈ E, (pointIndex (L := L) A x : ℤ)) =
        ∑ x ∈ E,
          ((if pointIndex (L := L) A x = 1 then (1 : ℤ) else 0) +
            2 * (if pointIndex (L := L) A x = 2 then (1 : ℤ) else 0) +
            3 * (if pointIndex (L := L) A x = 3 then (1 : ℤ) else 0)) := by
          apply Finset.sum_congr rfl
          intro x hx
          have hle := offArc_index_le_three (L := L) hA hcard hx
          interval_cases hidx : pointIndex (L := L) A x <;> norm_num [hidx]
    _ = (∑ x ∈ E, if pointIndex (L := L) A x = 1 then (1 : ℤ) else 0) +
          2 * (∑ x ∈ E, if pointIndex (L := L) A x = 2 then (1 : ℤ) else 0) +
          3 * (∑ x ∈ E, if pointIndex (L := L) A x = 3 then (1 : ℤ) else 0) := by
            simp only [Finset.sum_add_distrib, ← Finset.mul_sum]
    _ = ((offArcIndexFiber (L := L) A 1).card : ℤ) +
          2 * ((offArcIndexFiber (L := L) A 2).card : ℤ) +
          3 * ((offArcIndexFiber (L := L) A 3).card : ℤ) := by
            simp only [offArcIndexFiber]
            rw [← card_filter_cast_eq_sum_indicator,
              ← card_filter_cast_eq_sum_indicator,
              ← card_filter_cast_eq_sum_indicator]

private theorem sum_choose_two_eq_fibers_le_three {A : Finset P}
    (hA : Arc (L := L) A) (hcard : A.card ≤ 7) :
    (∑ x ∈ (Finset.univ \ A),
        (Nat.choose (pointIndex (L := L) A x) 2 : ℤ)) =
      ((offArcIndexFiber (L := L) A 2).card : ℤ) +
        3 * ((offArcIndexFiber (L := L) A 3).card : ℤ) := by
  classical
  let E : Finset P := Finset.univ \ A
  calc
    (∑ x ∈ E, (Nat.choose (pointIndex (L := L) A x) 2 : ℤ)) =
        ∑ x ∈ E,
          ((if pointIndex (L := L) A x = 2 then (1 : ℤ) else 0) +
            3 * (if pointIndex (L := L) A x = 3 then (1 : ℤ) else 0)) := by
          apply Finset.sum_congr rfl
          intro x hx
          have hle := offArc_index_le_three (L := L) hA hcard hx
          interval_cases hidx : pointIndex (L := L) A x <;>
            norm_num [hidx, Nat.choose]
    _ = (∑ x ∈ E, if pointIndex (L := L) A x = 2 then (1 : ℤ) else 0) +
          3 * (∑ x ∈ E, if pointIndex (L := L) A x = 3 then (1 : ℤ) else 0) := by
            simp only [Finset.sum_add_distrib, ← Finset.mul_sum]
    _ = ((offArcIndexFiber (L := L) A 2).card : ℤ) +
          3 * ((offArcIndexFiber (L := L) A 3).card : ℤ) := by
            simp only [offArcIndexFiber]
            rw [← card_filter_cast_eq_sum_indicator,
              ← card_filter_cast_eq_sum_indicator]

private theorem offArc_partition_le_three {A : Finset P}
    (hA : Arc (L := L) A) (hcard : A.card ≤ 7) :
    ((offArcIndexFiber (L := L) A 0).card : ℤ) +
        ((offArcIndexFiber (L := L) A 1).card : ℤ) +
        ((offArcIndexFiber (L := L) A 2).card : ℤ) +
        ((offArcIndexFiber (L := L) A 3).card : ℤ) =
      (((Finset.univ \ A).card : ℕ) : ℤ) := by
  classical
  let E : Finset P := Finset.univ \ A
  calc
    ((offArcIndexFiber (L := L) A 0).card : ℤ) +
          ((offArcIndexFiber (L := L) A 1).card : ℤ) +
          ((offArcIndexFiber (L := L) A 2).card : ℤ) +
          ((offArcIndexFiber (L := L) A 3).card : ℤ) =
        (∑ x ∈ E,
          ((if pointIndex (L := L) A x = 0 then (1 : ℤ) else 0) +
            (if pointIndex (L := L) A x = 1 then (1 : ℤ) else 0) +
            (if pointIndex (L := L) A x = 2 then (1 : ℤ) else 0) +
            (if pointIndex (L := L) A x = 3 then (1 : ℤ) else 0))) := by
              simp only [offArcIndexFiber, Finset.sum_add_distrib]
              rw [card_filter_cast_eq_sum_indicator,
                card_filter_cast_eq_sum_indicator,
                card_filter_cast_eq_sum_indicator,
                card_filter_cast_eq_sum_indicator]
    _ = ∑ _x ∈ E, (1 : ℤ) := by
          apply Finset.sum_congr rfl
          intro x hx
          have hle := offArc_index_le_three (L := L) hA hcard hx
          interval_cases hidx : pointIndex (L := L) A x <;> norm_num [hidx]
    _ = (E.card : ℤ) := by simp

private theorem offArcIndexFiber_three_eq_empty_of_card_le_five {A : Finset P}
    (hA : Arc (L := L) A) (hcard : A.card ≤ 5) :
    offArcIndexFiber (L := L) A 3 = ∅ := by
  classical
  apply Finset.eq_empty_iff_forall_notMem.mpr
  intro x hx
  have hxA : x ∉ A := (mem_offArcIndexFiber.mp hx).1
  have hindex := pointIndex_le_half_card (L := L) hA hxA
  have heq := (mem_offArcIndexFiber.mp hx).2
  omega

/-- The actual uncovered cardinality of a four-arc is `(q-2)(q-3)`. -/
theorem fourArc_uncovered_card
    {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 4) :
    ((uncovered (L := L) A ∅).card : ℤ) =
      ((PlaneOrder P L : ℤ) - 2) * ((PlaneOrder P L : ℤ) - 3) := by
  let q := PlaneOrder P L
  let n1 := (offArcIndexFiber (L := L) A 1).card
  let n2 := (offArcIndexFiber (L := L) A 2).card
  let u := (uncovered (L := L) A ∅).card
  have hle : A.card ≤ 7 := by omega
  have hn3 := offArcIndexFiber_three_eq_empty_of_card_le_five (L := L) hA (by omega)
  have hsum1 := sum_index_eq_fibers_le_three (L := L) hA hle
  have hsum2 := sum_choose_two_eq_fibers_le_three (L := L) hA hle
  have hpart := offArc_partition_le_three (L := L) hA hle
  have hm1Nat := first_secant_moment (L := L) hA
  have hm2Nat := second_secant_moment (L := L) hA
  have hq : 1 ≤ q := le_of_lt (Configuration.ProjectivePlane.one_lt_order P L)
  have hm1 : (∑ x ∈ (Finset.univ \ A),
      (pointIndex (L := L) A x : ℤ)) = 6 * ((q : ℤ) - 1) := by
    rw [hcard] at hm1Nat
    exact_mod_cast hm1Nat
  have hm2 : (∑ x ∈ (Finset.univ \ A),
      (Nat.choose (pointIndex (L := L) A x) 2 : ℤ)) = 3 := by
    rw [hcard] at hm2Nat
    norm_num at hm2Nat
    exact_mod_cast hm2Nat
  have htotal := offArc_card_cast (L := L) A
  have hfirst : (n1 : ℤ) + 2 * (n2 : ℤ) = 6 * ((q : ℤ) - 1) := by
    dsimp [n1, n2]
    rw [hn3] at hsum1
    simp only [Finset.card_empty, Nat.cast_zero, mul_zero, add_zero] at hsum1
    linarith
  have hsecond : (n2 : ℤ) = 3 := by
    dsimp [n2]
    rw [hn3] at hsum2
    simp only [Finset.card_empty, Nat.cast_zero, mul_zero, add_zero] at hsum2
    linarith
  have hpartition : (u : ℤ) + (n1 : ℤ) + (n2 : ℤ) =
      (q : ℤ) ^ 2 + (q : ℤ) - 3 := by
    dsimp [u, n1, n2]
    rw [← uncovered_empty_eq_offArcIndexFiber_zero (L := L), hn3] at hpart
    simp only [Finset.card_empty, Nat.cast_zero, add_zero] at hpart
    rw [hcard] at htotal
    dsimp [q] at htotal ⊢
    linarith
  exact SmallKChordMoments.fourArc_uncovered_of_moments q n1 n2 u
    hfirst hsecond hpartition

/-- Conic cardinality for a four-arc forces plane order five. -/
theorem fourArc_conic_card_order
    {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 4)
    (hq : IsPrimePow (PlaneOrder P L))
    (hu : (uncovered (L := L) A ∅).card = PlaneOrder P L + 1) :
    PlaneOrder P L = 5 := by
  have hformula := fourArc_uncovered_card (L := L) hA hcard
  let q := PlaneOrder P L
  let u := (uncovered (L := L) A ∅).card
  have hproduct : ((q : ℤ) - 1) * ((q : ℤ) - 5) = 0 := by
    dsimp [q, u] at hformula ⊢
    rw [hu] at hformula
    push_cast at hformula
    nlinarith
  rcases mul_eq_zero.mp hproduct with hq1 | hq5
  · have horder : PlaneOrder P L = 1 := by
      dsimp [q] at hq1
      omega
    rw [horder] at hq
    exact False.elim ((by decide : ¬ IsPrimePow 1) hq)
  · dsimp [q] at hq5
    omega

/-- The actual uncovered cardinality of a five-arc is `q²-9q+21`. -/
theorem fiveArc_uncovered_card
    {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 5) :
    ((uncovered (L := L) A ∅).card : ℤ) =
      (PlaneOrder P L : ℤ) ^ 2 - 9 * (PlaneOrder P L : ℤ) + 21 := by
  let q := PlaneOrder P L
  let n1 := (offArcIndexFiber (L := L) A 1).card
  let n2 := (offArcIndexFiber (L := L) A 2).card
  let u := (uncovered (L := L) A ∅).card
  have hle : A.card ≤ 7 := by omega
  have hn3 := offArcIndexFiber_three_eq_empty_of_card_le_five (L := L) hA (by omega)
  have hsum1 := sum_index_eq_fibers_le_three (L := L) hA hle
  have hsum2 := sum_choose_two_eq_fibers_le_three (L := L) hA hle
  have hpart := offArc_partition_le_three (L := L) hA hle
  have hm1Nat := first_secant_moment (L := L) hA
  have hm2Nat := second_secant_moment (L := L) hA
  have hq : 1 ≤ q := le_of_lt (Configuration.ProjectivePlane.one_lt_order P L)
  have hm1 : (∑ x ∈ (Finset.univ \ A),
      (pointIndex (L := L) A x : ℤ)) = 10 * ((q : ℤ) - 1) := by
    rw [hcard] at hm1Nat
    exact_mod_cast hm1Nat
  have hm2 : (∑ x ∈ (Finset.univ \ A),
      (Nat.choose (pointIndex (L := L) A x) 2 : ℤ)) = 15 := by
    rw [hcard] at hm2Nat
    norm_num at hm2Nat
    exact_mod_cast hm2Nat
  have htotal := offArc_card_cast (L := L) A
  have hfirst : (n1 : ℤ) + 2 * (n2 : ℤ) = 10 * ((q : ℤ) - 1) := by
    dsimp [n1, n2]
    rw [hn3] at hsum1
    simp only [Finset.card_empty, Nat.cast_zero, mul_zero, add_zero] at hsum1
    linarith
  have hsecond : (n2 : ℤ) = 15 := by
    dsimp [n2]
    rw [hn3] at hsum2
    simp only [Finset.card_empty, Nat.cast_zero, mul_zero, add_zero] at hsum2
    linarith
  have hpartition : (u : ℤ) + (n1 : ℤ) + (n2 : ℤ) =
      (q : ℤ) ^ 2 + (q : ℤ) - 4 := by
    dsimp [u, n1, n2]
    rw [← uncovered_empty_eq_offArcIndexFiber_zero (L := L), hn3] at hpart
    simp only [Finset.card_empty, Nat.cast_zero, add_zero] at hpart
    rw [hcard] at htotal
    dsimp [q] at htotal ⊢
    linarith
  exact SmallKChordMoments.fiveArc_uncovered_of_moments q n1 n2 u
    hfirst hsecond hpartition

/-- No five-arc has an ordinary uncovered locus of conic cardinality. -/
theorem fiveArc_not_conic_card
    {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 5) :
    (uncovered (L := L) A ∅).card ≠ PlaneOrder P L + 1 := by
  intro hu
  have hformula := fiveArc_uncovered_card (L := L) hA hcard
  rw [hu] at hformula
  push_cast at hformula
  have hq_le : PlaneOrder P L ≤ 10 := by
    by_contra hnot
    have hq11 : 11 ≤ PlaneOrder P L := by omega
    have hnonneg : 0 ≤ ((PlaneOrder P L : ℤ) - 10) * (PlaneOrder P L : ℤ) :=
      mul_nonneg (by omega) (by positivity)
    nlinarith
  interval_cases hq : PlaneOrder P L <;> norm_num [hq] at hformula

/-- The actual seven-arc uncovered cardinality, with the index-three fiber as defect. -/
theorem sevenArc_uncovered_card
    {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 7) :
    ((uncovered (L := L) A ∅).card : ℤ) =
      (PlaneOrder P L : ℤ) ^ 2 - 20 * (PlaneOrder P L : ℤ) + 120 -
        ((offArcIndexFiber (L := L) A 3).card : ℤ) := by
  let q := PlaneOrder P L
  let n1 := (offArcIndexFiber (L := L) A 1).card
  let n2 := (offArcIndexFiber (L := L) A 2).card
  let n3 := (offArcIndexFiber (L := L) A 3).card
  let u := (uncovered (L := L) A ∅).card
  have hle : A.card ≤ 7 := by omega
  have hsum1 := sum_index_eq_fibers_le_three (L := L) hA hle
  have hsum2 := sum_choose_two_eq_fibers_le_three (L := L) hA hle
  have hpart := offArc_partition_le_three (L := L) hA hle
  have hm1Nat := first_secant_moment (L := L) hA
  have hm2Nat := second_secant_moment (L := L) hA
  have hq : 1 ≤ q := le_of_lt (Configuration.ProjectivePlane.one_lt_order P L)
  have hm1 : (∑ x ∈ (Finset.univ \ A),
      (pointIndex (L := L) A x : ℤ)) = 21 * ((q : ℤ) - 1) := by
    rw [hcard] at hm1Nat
    exact_mod_cast hm1Nat
  have hm2 : (∑ x ∈ (Finset.univ \ A),
      (Nat.choose (pointIndex (L := L) A x) 2 : ℤ)) = 105 := by
    rw [hcard] at hm2Nat
    exact_mod_cast hm2Nat
  have htotal := offArc_card_cast (L := L) A
  have hfirst : (n1 : ℤ) + 2 * (n2 : ℤ) + 3 * (n3 : ℤ) =
      21 * ((q : ℤ) - 1) := by
    dsimp [n1, n2, n3]
    linarith
  have hsecond : (n2 : ℤ) + 3 * (n3 : ℤ) = 105 := by
    dsimp [n2, n3]
    linarith
  have hpartition : (u : ℤ) + (n1 : ℤ) + (n2 : ℤ) + (n3 : ℤ) =
      (q : ℤ) ^ 2 + (q : ℤ) - 6 := by
    dsimp [u, n1, n2, n3]
    rw [← uncovered_empty_eq_offArcIndexFiber_zero (L := L)] at hpart
    rw [hcard] at htotal
    dsimp [q] at htotal ⊢
    linarith
  exact SmallKChordMoments.sevenArc_uncovered_of_moments q n1 n2 n3 u
    hfirst hsecond hpartition

/-- If a seven-arc has conic-cardinality uncovered locus in a prime-power-order plane, then the
order and complete off-arc secant-index spectrum are one of the two arithmetically possible
cases.  Subsequent finite certificates exclude both geometrically. -/
theorem sevenArc_primePower_conic_card_spectra
    {A : Finset P} (hA : Arc (L := L) A) (hcard : A.card = 7)
    (hq : IsPrimePow (PlaneOrder P L))
    (hu : (uncovered (L := L) A ∅).card = PlaneOrder P L + 1) :
    (PlaneOrder P L = 11 ∧
        (offArcIndexFiber (L := L) A 1).card = 27 ∧
        (offArcIndexFiber (L := L) A 2).card = 78 ∧
        (offArcIndexFiber (L := L) A 3).card = 9) ∨
      (PlaneOrder P L = 13 ∧
        (offArcIndexFiber (L := L) A 1).card = 87 ∧
        (offArcIndexFiber (L := L) A 2).card = 60 ∧
        (offArcIndexFiber (L := L) A 3).card = 15) := by
  let q := PlaneOrder P L
  let n1 := (offArcIndexFiber (L := L) A 1).card
  let n2 := (offArcIndexFiber (L := L) A 2).card
  let n3 := (offArcIndexFiber (L := L) A 3).card
  let u := (uncovered (L := L) A ∅).card
  have hle : A.card ≤ 7 := by omega
  have hsum1 := sum_index_eq_fibers_le_three (L := L) hA hle
  have hsum2 := sum_choose_two_eq_fibers_le_three (L := L) hA hle
  have hpart := offArc_partition_le_three (L := L) hA hle
  have hm1Nat := first_secant_moment (L := L) hA
  have hm2Nat := second_secant_moment (L := L) hA
  have hq1 : 1 ≤ q := le_of_lt (Configuration.ProjectivePlane.one_lt_order P L)
  have hm1 : (∑ x ∈ (Finset.univ \ A),
      (pointIndex (L := L) A x : ℤ)) = 21 * ((q : ℤ) - 1) := by
    rw [hcard] at hm1Nat
    exact_mod_cast hm1Nat
  have hm2 : (∑ x ∈ (Finset.univ \ A),
      (Nat.choose (pointIndex (L := L) A x) 2 : ℤ)) = 105 := by
    rw [hcard] at hm2Nat
    exact_mod_cast hm2Nat
  have htotal := offArc_card_cast (L := L) A
  have hfirst : (n1 : ℤ) + 2 * (n2 : ℤ) + 3 * (n3 : ℤ) =
      21 * ((q : ℤ) - 1) := by
    dsimp [n1, n2, n3]
    linarith
  have hsecond : (n2 : ℤ) + 3 * (n3 : ℤ) = 105 := by
    dsimp [n2, n3]
    linarith
  have hpartition : (u : ℤ) + (n1 : ℤ) + (n2 : ℤ) + (n3 : ℤ) =
      (q : ℤ) ^ 2 + (q : ℤ) - 6 := by
    dsimp [u, n1, n2, n3]
    rw [← uncovered_empty_eq_offArcIndexFiber_zero (L := L)] at hpart
    rw [hcard] at htotal
    dsimp [q] at htotal ⊢
    linarith
  have hspectra := SmallKChordMoments.sevenArc_primePower_spectra_of_moments
    q n1 n2 n3 u hq hfirst hsecond hpartition (by simpa [q, u] using hu)
  simpa [q, n1, n2, n3] using hspectra

#print axioms fourArc_uncovered_card
#print axioms fourArc_conic_card_order
#print axioms fiveArc_uncovered_card
#print axioms fiveArc_not_conic_card
#print axioms sevenArc_uncovered_card
#print axioms sevenArc_primePower_conic_card_spectra

end SmallKGeometricBridge

end RelativeConicArcs
