import FiniteGeom.BaerCompletion.PairExtension

/-!
# Finite orbit-counting inputs for quadratic pair extension

The quadratic candidate count is a two-to-one fiber count, not a coordinate calculation.  These
lemmas isolate that fact and reduce the geometric input to an explicit mate-orbit map.
-/

namespace FiniteGeom.BaerCompletion

open Finset

variable {P Q : Type*} [DecidableEq P] [DecidableEq Q]

omit [DecidableEq P] in
/-- A map from a finite source onto a finite target, with every target fiber of size `d`, counts
the source as `d` times the target. -/
theorem card_eq_card_mul_of_constant_fibers (S : Finset P) (T : Finset Q) (f : P → Q) (d : ℕ)
    (hmaps : ∀ p ∈ S, f p ∈ T)
    (hfiber : ∀ q ∈ T, (S.filter fun p => f p = q).card = d) :
    S.card = T.card * d := by
  rw [Finset.card_eq_sum_card_fiberwise hmaps]
  exact Finset.sum_const_nat hfiber

omit [DecidableEq P] in
/-- The candidate-pair count `(s²-s)/2` follows whenever the nonfixed points on a fixed line have
cardinality `s²-s` and the mate-pair map has exactly two preimages per candidate. -/
theorem quadraticCandidate_card_of_two_fibers (S : Finset P) (T : Finset Q) (matePair : P → Q)
    (s : ℕ) (hS : S.card = s * s - s)
    (hmaps : ∀ p ∈ S, matePair p ∈ T)
    (hfiber : ∀ q ∈ T, (S.filter fun p => matePair p = q).card = 2) :
    T.card = (s * s - s) / 2 := by
  have hcount := card_eq_card_mul_of_constant_fibers S T matePair 2 hmaps hfiber
  rw [hS] at hcount
  omega

/-- If the fixed-line universe is partitioned into occupied and empty lines, its empty-line count
is total minus occupied. -/
theorem emptyLine_card_of_complement {L : Type*} [DecidableEq L]
    (all occupied empty : Finset L) (hpart : empty = all \ occupied) (hsub : occupied ⊆ all) :
    empty.card = all.card - occupied.card := by
  rw [hpart, Finset.card_sdiff_of_subset hsub]

/-- A finite family of traces of size at most two is counted by its incidences minus its
two-point traces.  This is the abstract double-counting identity behind the occupied Baer-line
formula: a one-point trace contributes once to both sides, while a two-point trace contributes
twice to the incidence sum and once to the correction term. -/
theorem occupied_card_eq_sum_sub_twoTraces {L P : Type*} [DecidableEq L] [DecidableEq P]
    (lines : Finset L) (trace : L → Finset P)
    (hle : ∀ l ∈ lines, (trace l).card ≤ 2) :
    (lines.filter fun l => (trace l).Nonempty).card =
      (∑ l ∈ lines, (trace l).card) -
        (lines.filter fun l => (trace l).card = 2).card := by
  classical
  let occupied := lines.filter fun l => (trace l).Nonempty
  let double := lines.filter fun l => (trace l).card = 2
  have hsum : (∑ l ∈ lines, (trace l).card) = occupied.card + double.card := by
    rw [Finset.card_eq_sum_ones, Finset.card_eq_sum_ones]
    simp only [occupied, double, Finset.sum_filter]
    rw [← Finset.sum_add_distrib]
    apply Finset.sum_congr rfl
    intro l hl
    have hcard := hle l hl
    by_cases h0 : (trace l).card = 0
    · have hempty : trace l = ∅ := Finset.card_eq_zero.mp h0
      simp [hempty]
    by_cases h2 : (trace l).card = 2
    · have hne : (trace l).Nonempty := Finset.card_pos.mp (by omega)
      simp [h2, hne]
    have h1 : (trace l).card = 1 := by omega
    have hne : (trace l).Nonempty := Finset.card_pos.mp (by omega)
    simp [h1, hne]
  change occupied.card = _
  rw [hsum]
  simp [double]

/-- Numerical specialization of `occupied_card_eq_sum_sub_twoTraces`.  If the total incidence
sum is `f*r+2e`, the two-point traces number `choose(f,2)+e`, and the elementary star count is
large enough to contain all fixed-point joins, then the occupied-line count is
`f*r-choose(f,2)+e`. -/
theorem occupied_card_of_baer_trace_profile {L P : Type*} [DecidableEq L] [DecidableEq P]
    (lines : Finset L) (trace : L → Finset P) (f e r : ℕ)
    (hle : ∀ l ∈ lines, (trace l).card ≤ 2)
    (hsum : (∑ l ∈ lines, (trace l).card) = f * r + 2 * e)
    (htwo : (lines.filter fun l => (trace l).card = 2).card = f.choose 2 + e)
    (hchoose : f.choose 2 ≤ f * r) :
    (lines.filter fun l => (trace l).Nonempty).card = f * r - f.choose 2 + e := by
  rw [occupied_card_eq_sum_sub_twoTraces lines trace hle, hsum, htwo]
  omega

omit [DecidableEq Q] in
/-- A finite injective charging map bounds the forbidden candidates by the available obstruction
orbits. This is the exact combinatorial content needed by `forbidden_bound`. -/
theorem forbidden_card_le_of_injOn {R : Type*} [DecidableEq R]
    (forbidden : Finset Q) (orbits : Finset R) (charge : Q → R)
    (hmaps : ∀ q ∈ forbidden, charge q ∈ orbits)
    (hinj : Set.InjOn charge forbidden) :
    forbidden.card ≤ orbits.card := by
  rw [← Finset.card_image_of_injOn hinj]
  exact Finset.card_le_card fun r hr => by
    obtain ⟨q, hq, rfl⟩ := Finset.mem_image.mp hr
    exact hmaps q hq

end FiniteGeom.BaerCompletion
