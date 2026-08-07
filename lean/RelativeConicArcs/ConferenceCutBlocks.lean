import Mathlib.Data.Matrix.Block
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Tactic.LinearCombination
import Mathlib.Tactic.Ring
import RelativeConicArcs.SubsetInclusionSums

/-!
# Cut blocks of a symmetric conference matrix

Order the coordinates of a symmetric matrix `C` by a subset and its
complement, so that

```
C = fromBlocks A B Bᵀ E
```

with `A` the principal block on the subset and `B` the cross block between the
subset and its complement.  This module records the symbolic content of the
exchange-spectrum calculation for such a cut, over an arbitrary commutative
ring and for an arbitrary index type.

The first theorem is the cross-block identity: if `C * C = q • 1`, then
`B * Bᵀ = q • 1 - A * A`.  Over the reals this is what makes the squared
singular values of `B / √q` the numbers `q - α²` for `α` an eigenvalue of `A`,
but no eigenvalue, singular value, or spectral statement is formalized here;
the identity itself is a polynomial consequence of the block product.

The second theorem is the trace of the square of a zero-diagonal matrix whose
off-diagonal entries square to one: it is `d(d-1)` for `d` the cardinality of
the index type, which is the first exchange moment's only input.

The third is the dichotomy for a four-set: the sum of the three signed
Hamilton-cycle products of a zero-diagonal symmetric sign matrix on four
labels is `3` or `-1`, because each edge occurs twice in the product of the
three cycles, so that product is one.  A four-set is aligned exactly when the
sum is `3`.

The fourth theorem sorts the fourth trace by the support of the closed
four-walks it counts.  A closed walk `i → j → k → l → i` of a zero-diagonal
matrix contributes nothing unless consecutive labels differ, so its support has
two, three or four elements; the first two classes contribute the counts
`d(d-1)` and `12·C(d,3)`, and the last contributes, for each four-element
support `K`, the sum `closedFourWalkSum A K` of the twenty-four walks through
`K`.  Only the zero diagonal and the pairwise reciprocity `A i j * A j i = 1`
enter that count, not symmetry.  For a symmetric sign matrix the four-element
supports each contribute eight times the four-set weight above, since each of
the three Hamilton cycles of `K` is traversed from four starting points in two
directions, hence `24` or `-8`.

The fifth theorem is the rigidity consequence used for a cut of a `2d`-element
label set into balanced halves: if the four-subset sums of the weights agree on
all `d`-subsets and `4 ≤ d`, then the weight is the same on every four-subset.
It is the swap descent of `RelativeConicArcs.SubsetInclusionSums`, not an
appeal to the rank formula for inclusion matrices.

No eigenvalue or singular-value statement is formalized here: the identity
`B * Bᵀ = q • 1 - A * A` is what turns the spectrum of the principal block into
the squared singular values of the cross block, but that step is not taken in
this module.
-/

namespace RelativeConicArcs.ConferenceCutBlocks

open Matrix

/-- The cross-block identity of a cut: if the blocked matrix squares to a
scalar, the cross block times its transpose is that scalar minus the square of
the principal block.  This is the principal block of the equation `C * C =
q • 1` on the chosen subset. -/
theorem mul_transpose_eq_of_sq_smul {R : Type*} [CommRing R]
    {n m : Type*} [Fintype n] [Fintype m] [DecidableEq n] [DecidableEq m]
    (A : Matrix n n R) (B : Matrix n m R) (E : Matrix m m R) (q : R)
    (h : fromBlocks A B Bᵀ E * fromBlocks A B Bᵀ E = q • 1) :
    B * Bᵀ = q • (1 : Matrix n n R) - A * A := by
  have h₁ := congrArg Matrix.toBlocks₁₁ h
  rw [fromBlocks_multiply, ← fromBlocks_one (l := n) (m := m), fromBlocks_smul,
    toBlocks_fromBlocks₁₁, toBlocks_fromBlocks₁₁] at h₁
  rw [eq_sub_iff_add_eq, add_comm]
  exact h₁

/-- The trace of the square of a zero-diagonal matrix whose off-diagonal
entries multiply pairwise to one is the number of ordered pairs of distinct
indices. -/
theorem trace_mul_self {R : Type*} [CommRing R] {n : Type*} [Fintype n]
    [DecidableEq n] (A : Matrix n n R) (hdiag : ∀ i, A i i = 0)
    (hoff : ∀ i j, i ≠ j → A i j * A j i = 1) :
    Matrix.trace (A * A) =
      (Fintype.card n : R) * ((Fintype.card n : R) - 1) := by
  have key : ∀ i : n, ∑ j, A i j * A j i = (Fintype.card n : R) - 1 := by
    intro i
    rw [← Finset.sum_erase_add _ _ (Finset.mem_univ i), hdiag i, mul_zero,
      add_zero,
      Finset.sum_congr rfl fun j hj => hoff i j (Ne.symm (Finset.ne_of_mem_erase hj))]
    rw [Finset.sum_const, Finset.card_erase_of_mem (Finset.mem_univ i)]
    have hpos : 1 ≤ Fintype.card n := Fintype.card_pos_iff.mpr ⟨i⟩
    simp [Finset.card_univ, Nat.cast_sub hpos]
  simp only [Matrix.trace, Matrix.diag_apply, Matrix.mul_apply, key]
  simp only [Finset.sum_const, Finset.card_univ, nsmul_eq_mul]

/-- The three signed Hamilton-cycle products of a matrix on four labels, in
the cyclic orders `0123`, `0132` and `0213`. -/
def fourSetWeight {R : Type*} [CommRing R] (M : Matrix (Fin 4) (Fin 4) R) : R :=
  M 0 1 * M 1 2 * M 2 3 * M 3 0 +
  M 0 1 * M 1 3 * M 3 2 * M 2 0 +
  M 0 2 * M 2 1 * M 1 3 * M 3 0

/-- Three ring elements that square to one and multiply to one have sum `3` or
`-1`. -/
private theorem sum_eq_three_or_neg_one {R : Type*} [CommRing R] (p q r : R)
    (hp : p * p = 1) (hq : q * q = 1) (hr : r * r = 1) (hpqr : p * q * r = 1) :
    (p + q + r - 3) * (p + q + r + 1) = 0 := by
  have hpq : p * q = r :=
    calc p * q = p * q * (r * r) := by rw [hr]; ring
      _ = p * q * r * r := by ring
      _ = r := by rw [hpqr]; ring
  have hpr : p * r = q :=
    calc p * r = p * r * (q * q) := by rw [hq]; ring
      _ = p * q * r * q := by ring
      _ = q := by rw [hpqr]; ring
  have hqr : q * r = p :=
    calc q * r = q * r * (p * p) := by rw [hp]; ring
      _ = p * q * r * p := by ring
      _ = p := by rw [hpqr]; ring
  linear_combination hp + hq + hr + 2 * hpq + 2 * hpr + 2 * hqr

/-- The dichotomy in the six edge signs of a four-set: the three Hamilton-cycle
products of signs squaring to one sum to `3` or to `-1`, because every edge
occurs twice in their product. -/
private theorem sum_hamiltonCycles_eq_three_or_neg_one {R : Type*} [CommRing R]
    (a b c d e f : R) (ha : a * a = 1) (hb : b * b = 1) (hc : c * c = 1)
    (hd : d * d = 1) (he : e * e = 1) (hf : f * f = 1) :
    (a * d * f * c + a * e * f * b + b * d * e * c - 3) *
      (a * d * f * c + a * e * f * b + b * d * e * c + 1) = 0 := by
  refine sum_eq_three_or_neg_one _ _ _ ?_ ?_ ?_ ?_
  · calc a * d * f * c * (a * d * f * c)
        = a * a * (d * d) * (f * f) * (c * c) := by ring
      _ = 1 := by rw [ha, hd, hf, hc]; ring
  · calc a * e * f * b * (a * e * f * b)
        = a * a * (e * e) * (f * f) * (b * b) := by ring
      _ = 1 := by rw [ha, he, hf, hb]; ring
  · calc b * d * e * c * (b * d * e * c)
        = b * b * (d * d) * (e * e) * (c * c) := by ring
      _ = 1 := by rw [hb, hd, he, hc]; ring
  · calc a * d * f * c * (a * e * f * b) * (b * d * e * c)
        = a * a * (b * b) * (c * c) * (d * d) * (e * e) * (f * f) := by ring
      _ = 1 := by rw [ha, hb, hc, hd, he, hf]; ring

/-- A four-set of a zero-diagonal symmetric sign matrix has Hamilton-cycle
weight `3` or `-1`.  A four-set is aligned exactly when the weight is `3`. -/
theorem fourSetWeight_eq_three_or_neg_one {R : Type*} [CommRing R]
    (M : Matrix (Fin 4) (Fin 4) R) (hsym : ∀ i j, M j i = M i j)
    (hsq : ∀ i j, i ≠ j → M i j * M i j = 1) :
    (fourSetWeight M - 3) * (fourSetWeight M + 1) = 0 := by
  simp only [fourSetWeight, hsym 0 2, hsym 0 3, hsym 1 2, hsym 2 3]
  exact sum_hamiltonCycles_eq_three_or_neg_one (M 0 1) (M 0 2) (M 0 3) (M 1 2)
    (M 1 3) (M 2 3) (hsq 0 1 (by decide)) (hsq 0 2 (by decide))
    (hsq 0 3 (by decide)) (hsq 1 2 (by decide)) (hsq 1 3 (by decide))
    (hsq 2 3 (by decide))

section ClosedFourWalks

variable {R : Type*} [CommRing R] {n : Type*} [Fintype n] [DecidableEq n]

/-- The signed weight `A i j * A j k * A k l * A l i` of the closed walk
`i → j → k → l → i`. -/
private def walkTerm (A : Matrix n n R) (i j k l : n) : R :=
  A i j * A j k * A k l * A l i

/-- The four labels of a closed four-walk are pairwise distinct. -/
private def WalkInjective (i j k l : n) : Prop :=
  i ≠ j ∧ i ≠ k ∧ i ≠ l ∧ j ≠ k ∧ j ≠ l ∧ k ≠ l

instance (i j k l : n) : Decidable (WalkInjective i j k l) := by
  unfold WalkInjective; infer_instance

/-- The sum of the weights `A i j * A j k * A k l * A l i` of the closed
four-walks whose four labels are pairwise distinct and lie in `K`.  When `K`
has four elements these are the twenty-four traversals of the three Hamilton
cycles on `K`, four starting points and two directions each, so the sum is
eight times `fourSetWeight` read on any labelling of `K`. -/
def closedFourWalkSum (A : Matrix n n R) (K : Finset n) : R :=
  ∑ i ∈ K, ∑ j ∈ K, ∑ k ∈ K, ∑ l ∈ K,
    if WalkInjective i j k l then walkTerm A i j k l else 0

omit [Fintype n] in
/-- Sorting a sum over quadruples of labels of `Y` that vanishes off the
injective ones by the four-element support of the quadruple. -/
private theorem sum_eq_sum_powersetCard_four (Y : Finset n) (F : n → n → n → n → R)
    (hF : ∀ i j k l, ¬ WalkInjective i j k l → F i j k l = 0) :
    ∑ K ∈ Y.powersetCard 4, (∑ i ∈ K, ∑ j ∈ K, ∑ k ∈ K, ∑ l ∈ K, F i j k l)
      = ∑ i ∈ Y, ∑ j ∈ Y, ∑ k ∈ Y, ∑ l ∈ Y, F i j k l := by
  classical
  have hprod : ∀ K : Finset n, K ⊆ Y →
      (∑ i ∈ K, ∑ j ∈ K, ∑ k ∈ K, ∑ l ∈ K, F i j k l)
        = ∑ p ∈ Y ×ˢ Y ×ˢ Y ×ˢ Y, if p ∈ K ×ˢ K ×ˢ K ×ˢ K then
            F p.1 p.2.1 p.2.2.1 p.2.2.2 else 0 := by
    intro K hK
    have hsub : K ×ˢ K ×ˢ K ×ˢ K ⊆ Y ×ˢ Y ×ˢ Y ×ˢ Y :=
      Finset.product_subset_product hK (Finset.product_subset_product hK
        (Finset.product_subset_product hK hK))
    rw [Finset.sum_ite_mem, Finset.inter_eq_right.mpr hsub]
    simp [Finset.sum_product]
  have hpoint : ∀ p ∈ Y ×ˢ Y ×ˢ Y ×ˢ Y,
      (∑ K ∈ Y.powersetCard 4,
        if p ∈ K ×ˢ K ×ˢ K ×ˢ K then F p.1 p.2.1 p.2.2.1 p.2.2.2 else 0)
        = F p.1 p.2.1 p.2.2.1 p.2.2.2 := by
    rintro ⟨a, b, c, d⟩ hp
    simp only [Finset.mem_product] at hp
    obtain ⟨haY, hbY, hcY, hdY⟩ := hp
    by_cases hinj : WalkInjective a b c d
    · obtain ⟨hab, hac, had, hbc, hbd, hcd⟩ := hinj
      have hsupp : ({a, b, c, d} : Finset n).card = 4 := by
        rw [Finset.card_insert_of_notMem (by simp [hab, hac, had]),
          Finset.card_insert_of_notMem (by simp [hbc, hbd]),
          Finset.card_insert_of_notMem (by simp [hcd]), Finset.card_singleton]
      have hsuppY : ({a, b, c, d} : Finset n) ⊆ Y := by
        intro x hx
        simp only [Finset.mem_insert, Finset.mem_singleton] at hx
        rcases hx with rfl | rfl | rfl | rfl <;> assumption
      have hfilter : (Y.powersetCard 4).filter
          (fun K => ((a, b, c, d) : n × n × n × n) ∈ K ×ˢ K ×ˢ K ×ˢ K)
          = {({a, b, c, d} : Finset n)} := by
        ext K
        simp only [Finset.mem_filter, Finset.mem_powersetCard, Finset.mem_singleton,
          Finset.mem_product]
        constructor
        · rintro ⟨⟨-, hK⟩, ha, hb, hc, hd⟩
          have hsub : ({a, b, c, d} : Finset n) ⊆ K := by
            intro x hx
            simp only [Finset.mem_insert, Finset.mem_singleton] at hx
            rcases hx with rfl | rfl | rfl | rfl <;> assumption
          exact (Finset.eq_of_subset_of_card_le hsub (by rw [hK, hsupp])).symm
        · rintro rfl
          exact ⟨⟨hsuppY, hsupp⟩, by simp, by simp, by simp, by simp⟩
      rw [Finset.sum_ite, Finset.sum_const_zero, add_zero, hfilter, Finset.sum_const,
        Finset.card_singleton, one_smul]
    · rw [hF a b c d hinj]
      simp
  calc ∑ K ∈ Y.powersetCard 4, (∑ i ∈ K, ∑ j ∈ K, ∑ k ∈ K, ∑ l ∈ K, F i j k l)
      = ∑ K ∈ Y.powersetCard 4, ∑ p ∈ Y ×ˢ Y ×ˢ Y ×ˢ Y,
          (if p ∈ K ×ˢ K ×ˢ K ×ˢ K then F p.1 p.2.1 p.2.2.1 p.2.2.2 else 0) :=
        Finset.sum_congr rfl fun K hK => hprod K (Finset.mem_powersetCard.mp hK).1
    _ = ∑ p ∈ Y ×ˢ Y ×ˢ Y ×ˢ Y, ∑ K ∈ Y.powersetCard 4,
          (if p ∈ K ×ˢ K ×ˢ K ×ˢ K then F p.1 p.2.1 p.2.2.1 p.2.2.2 else 0) :=
        Finset.sum_comm
    _ = ∑ p ∈ Y ×ˢ Y ×ˢ Y ×ˢ Y, F p.1 p.2.1 p.2.2.1 p.2.2.2 :=
        Finset.sum_congr rfl hpoint
    _ = ∑ i ∈ Y, ∑ j ∈ Y, ∑ k ∈ Y, ∑ l ∈ Y, F i j k l := by
        simp [Finset.sum_product]

omit [Fintype n] in
/-- The fourth walk sum over a set `Y` of labels, sorted by the support of the
closed four-walks it counts.  For a zero-diagonal matrix whose off-diagonal
entries multiply pairwise to one, the two-element supports contribute
`|Y|(|Y|-1)`, the three-element supports contribute `12·C(|Y|,3)`, and each
four-element support `K` contributes the sum of the twenty-four closed
four-walks through `K`.  The sum on the left is the fourth trace of the
principal block of the matrix on `Y`.  Symmetry is not used; for a symmetric
sign matrix the hypothesis is that the off-diagonal entries square to one, and
then each four-element support contributes `24` or `-8`. -/
theorem sum_walkTerm_eq_add_sum_powersetCard (A : Matrix n n R) (hdiag : ∀ i, A i i = 0)
    (hone : ∀ i j, i ≠ j → A i j * A j i = 1) (Y : Finset n) :
    (∑ i ∈ Y, ∑ j ∈ Y, ∑ k ∈ Y, ∑ l ∈ Y, A i j * A j k * A k l * A l i) =
      (Y.card : R) * ((Y.card : R) - 1) + 12 * (Y.card.choose 3 : R)
        + ∑ K ∈ Y.powersetCard 4, closedFourWalkSum A K := by
  classical
  show (∑ i ∈ Y, ∑ j ∈ Y, ∑ k ∈ Y, ∑ l ∈ Y, walkTerm A i j k l) = _
  have hsplit : ∀ i ∈ Y, ∀ j ∈ Y, (∑ k ∈ Y, ∑ l ∈ Y, walkTerm A i j k l)
      = walkTerm A i j i j + (∑ l ∈ Y.erase j, walkTerm A i j i l)
        + (∑ k ∈ Y.erase i, walkTerm A i j k j)
        + ∑ k ∈ Y.erase i, ∑ l ∈ Y.erase j, walkTerm A i j k l := by
    intro i hi j hj
    have e1 : (∑ k ∈ Y, ∑ l ∈ Y, walkTerm A i j k l)
        = (∑ l ∈ Y, walkTerm A i j i l) + ∑ k ∈ Y.erase i, ∑ l ∈ Y, walkTerm A i j k l :=
      (Finset.add_sum_erase _ _ hi).symm
    have e2 : (∑ l ∈ Y, walkTerm A i j i l)
        = walkTerm A i j i j + ∑ l ∈ Y.erase j, walkTerm A i j i l :=
      (Finset.add_sum_erase _ _ hj).symm
    have e3 : ∀ k : n, (∑ l ∈ Y, walkTerm A i j k l)
        = walkTerm A i j k j + ∑ l ∈ Y.erase j, walkTerm A i j k l :=
      fun k => (Finset.add_sum_erase _ _ hj).symm
    rw [e1, e2, Finset.sum_congr rfl (fun k _ => e3 k), Finset.sum_add_distrib]
    ring
  have expand : (∑ i ∈ Y, ∑ j ∈ Y, ∑ k ∈ Y, ∑ l ∈ Y, walkTerm A i j k l)
      = (∑ i ∈ Y, ∑ j ∈ Y, walkTerm A i j i j)
        + (∑ i ∈ Y, ∑ j ∈ Y, ∑ l ∈ Y.erase j, walkTerm A i j i l)
        + (∑ i ∈ Y, ∑ j ∈ Y, ∑ k ∈ Y.erase i, walkTerm A i j k j)
        + (∑ i ∈ Y, ∑ j ∈ Y, ∑ k ∈ Y.erase i, ∑ l ∈ Y.erase j, walkTerm A i j k l) := by
    rw [Finset.sum_congr rfl (fun i hi => Finset.sum_congr rfl (fun j hj => hsplit i hi j hj))]
    simp only [Finset.sum_add_distrib]
  -- the four-element supports
  have hDterm : ∀ i j k l : n, k ≠ i → l ≠ j →
      walkTerm A i j k l = if WalkInjective i j k l then walkTerm A i j k l else 0 := by
    intro i j k l hki hlj
    by_cases hinj : WalkInjective i j k l
    · rw [if_pos hinj]
    · rw [if_neg hinj]
      have hcases : i = j ∨ i = l ∨ j = k ∨ k = l := by
        by_contra hc
        simp only [not_or] at hc
        exact hinj ⟨hc.1, Ne.symm hki, hc.2.1, hc.2.2.1, Ne.symm hlj, hc.2.2.2⟩
      rcases hcases with rfl | rfl | rfl | rfl <;> simp [walkTerm, hdiag]
  have hD : (∑ i ∈ Y, ∑ j ∈ Y, ∑ k ∈ Y.erase i, ∑ l ∈ Y.erase j, walkTerm A i j k l)
      = ∑ K ∈ Y.powersetCard 4, closedFourWalkSum A K := by
    rw [show (∑ K ∈ Y.powersetCard 4, closedFourWalkSum A K)
        = ∑ i ∈ Y, ∑ j ∈ Y, ∑ k ∈ Y, ∑ l ∈ Y,
            (if WalkInjective i j k l then walkTerm A i j k l else 0) from
      sum_eq_sum_powersetCard_four Y _ (fun i j k l h => if_neg h)]
    refine Finset.sum_congr rfl fun i _ => Finset.sum_congr rfl fun j _ => ?_
    have inner : ∀ k : n, k ≠ i → (∑ l ∈ Y.erase j, walkTerm A i j k l)
        = ∑ l ∈ Y, (if WalkInjective i j k l then walkTerm A i j k l else 0) := by
      intro k hki
      calc (∑ l ∈ Y.erase j, walkTerm A i j k l)
          = ∑ l ∈ Y.erase j,
              (if WalkInjective i j k l then walkTerm A i j k l else 0) :=
            Finset.sum_congr rfl fun l hl => hDterm i j k l hki (Finset.ne_of_mem_erase hl)
        _ = ∑ l ∈ Y, (if WalkInjective i j k l then walkTerm A i j k l else 0) := by
            refine Finset.sum_subset (Finset.erase_subset j Y) fun l hlY hl => ?_
            have hlj : l = j := by
              by_contra hne
              exact hl (Finset.mem_erase.mpr ⟨hne, hlY⟩)
            subst hlj
            exact if_neg fun hinj => hinj.2.2.2.2.1 rfl
    calc (∑ k ∈ Y.erase i, ∑ l ∈ Y.erase j, walkTerm A i j k l)
        = ∑ k ∈ Y.erase i,
            ∑ l ∈ Y, (if WalkInjective i j k l then walkTerm A i j k l else 0) :=
          Finset.sum_congr rfl fun k hk => inner k (Finset.ne_of_mem_erase hk)
      _ = ∑ k ∈ Y, ∑ l ∈ Y, (if WalkInjective i j k l then walkTerm A i j k l else 0) := by
          refine Finset.sum_subset (Finset.erase_subset i Y) fun k hkY hk => ?_
          have hki : k = i := by
            by_contra hne
            exact hk (Finset.mem_erase.mpr ⟨hne, hkY⟩)
          subst hki
          exact Finset.sum_eq_zero fun l _ => if_neg fun hinj => hinj.2.1 rfl
  -- the two- and three-element supports
  have hAterm : ∀ i j : n, i ≠ j → walkTerm A i j i j = 1 := by
    intro i j hij
    calc walkTerm A i j i j = (A i j * A j i) * (A i j * A j i) := by unfold walkTerm; ring
      _ = 1 := by rw [hone i j hij]; ring
  have hBterm : ∀ i j l : n, i ≠ j → i ≠ l → walkTerm A i j i l = 1 := by
    intro i j l hij hil
    calc walkTerm A i j i l = (A i j * A j i) * (A i l * A l i) := by unfold walkTerm; ring
      _ = 1 := by rw [hone i j hij, hone i l hil]; ring
  have hCterm : ∀ i j k : n, j ≠ i → j ≠ k → walkTerm A i j k j = 1 := by
    intro i j k hji hjk
    calc walkTerm A i j k j = (A i j * A j i) * (A j k * A k j) := by unfold walkTerm; ring
      _ = 1 := by rw [hone i j (Ne.symm hji), hone j k hjk]; ring
  have hA : ∀ i ∈ Y, (∑ j ∈ Y, walkTerm A i j i j) = ((Y.card - 1 : ℕ) : R) := by
    intro i hi
    rw [← Finset.add_sum_erase _ _ hi,
      show walkTerm A i i i i = 0 by simp [walkTerm, hdiag], zero_add,
      Finset.sum_congr rfl (fun j hj => hAterm i j (Ne.symm (Finset.ne_of_mem_erase hj)))]
    rw [Finset.sum_const, Finset.card_erase_of_mem hi, nsmul_eq_mul, mul_one]
  have hB : ∀ i ∈ Y, (∑ j ∈ Y, ∑ l ∈ Y.erase j, walkTerm A i j i l)
      = (((Y.card - 1) * (Y.card - 2) : ℕ) : R) := by
    intro i hi
    rw [← Finset.add_sum_erase _ _ hi,
      show (∑ l ∈ Y.erase i, walkTerm A i i i l) = 0 from
        Finset.sum_eq_zero fun l _ => by simp [walkTerm, hdiag], zero_add]
    have hj : ∀ j ∈ Y.erase i,
        (∑ l ∈ Y.erase j, walkTerm A i j i l) = ((Y.card - 2 : ℕ) : R) := by
      intro j hjmem
      have hji : j ≠ i := Finset.ne_of_mem_erase hjmem
      have himem : i ∈ Y.erase j := Finset.mem_erase.mpr ⟨Ne.symm hji, hi⟩
      have hjY : j ∈ Y := Finset.mem_of_mem_erase hjmem
      rw [← Finset.add_sum_erase _ _ himem,
        show walkTerm A i j i i = 0 by simp [walkTerm, hdiag], zero_add,
        Finset.sum_congr rfl (fun l hl => hBterm i j l (Ne.symm hji)
          (Ne.symm (Finset.ne_of_mem_erase hl)))]
      rw [Finset.sum_const, Finset.card_erase_of_mem himem, Finset.card_erase_of_mem hjY,
        nsmul_eq_mul, mul_one]
      congr 1
    rw [Finset.sum_congr rfl hj, Finset.sum_const, Finset.card_erase_of_mem hi, nsmul_eq_mul]
    push_cast
    ring
  have hC : ∀ i ∈ Y, (∑ j ∈ Y, ∑ k ∈ Y.erase i, walkTerm A i j k j)
      = (((Y.card - 1) * (Y.card - 2) : ℕ) : R) := by
    intro i hi
    rw [← Finset.add_sum_erase _ _ hi,
      show (∑ k ∈ Y.erase i, walkTerm A i i k i) = 0 from
        Finset.sum_eq_zero fun k _ => by simp [walkTerm, hdiag], zero_add]
    have hj : ∀ j ∈ Y.erase i,
        (∑ k ∈ Y.erase i, walkTerm A i j k j) = ((Y.card - 2 : ℕ) : R) := by
      intro j hjmem
      have hji : j ≠ i := Finset.ne_of_mem_erase hjmem
      rw [← Finset.add_sum_erase _ _ hjmem,
        show walkTerm A i j j j = 0 by simp [walkTerm, hdiag], zero_add,
        Finset.sum_congr rfl (fun k hk => hCterm i j k hji
          (Ne.symm (Finset.ne_of_mem_erase hk)))]
      rw [Finset.sum_const, Finset.card_erase_of_mem hjmem, Finset.card_erase_of_mem hi,
        nsmul_eq_mul, mul_one]
      congr 1
    rw [Finset.sum_congr rfl hj, Finset.sum_const, Finset.card_erase_of_mem hi, nsmul_eq_mul]
    push_cast
    ring
  -- assembling the three support classes
  rcases Y.eq_empty_or_nonempty with rfl | hY
  · rw [Finset.powersetCard_eq_empty.mpr (by simp)]
    simp
  have hpos : 1 ≤ Y.card := Finset.card_pos.mpr hY
  have hnat : 2 * (Y.card * ((Y.card - 1) * (Y.card - 2))) = 12 * Y.card.choose 3 := by
    have hfac : Y.card.descFactorial 3 = 6 * Y.card.choose 3 := by
      rw [Nat.descFactorial_eq_factorial_mul_choose]
      norm_num [Nat.factorial]
    have hval : Y.card.descFactorial 3 = (Y.card - 2) * ((Y.card - 1) * Y.card) := by
      simp [Nat.descFactorial]
    calc 2 * (Y.card * ((Y.card - 1) * (Y.card - 2)))
        = 2 * ((Y.card - 2) * ((Y.card - 1) * Y.card)) := by ring
      _ = 2 * (6 * Y.card.choose 3) := by rw [← hval, hfac]
      _ = 12 * Y.card.choose 3 := by ring
  have hcast : ((Y.card - 1 : ℕ) : R) = (Y.card : R) - 1 := by
    push_cast [Nat.cast_sub hpos]
    ring
  have hcast2 : (Y.card : R) * (((Y.card - 1) * (Y.card - 2) : ℕ) : R)
      + (Y.card : R) * (((Y.card - 1) * (Y.card - 2) : ℕ) : R)
      = 12 * (Y.card.choose 3 : R) := by
    have hcastnat := congrArg (fun m : ℕ => (m : R)) hnat
    push_cast at hcastnat ⊢
    linear_combination hcastnat
  rw [expand, hD, Finset.sum_congr rfl hA, Finset.sum_congr rfl hB,
    Finset.sum_congr rfl hC]
  simp only [Finset.sum_const, nsmul_eq_mul]
  rw [hcast]
  linear_combination hcast2

/-- The fourth trace of a zero-diagonal matrix whose off-diagonal entries
multiply pairwise to one, sorted by the support of the closed four-walks it
counts: the two-element supports give `d(d-1)`, the three-element supports give
`12·C(d,3)`, and each four-element support `K` gives the sum of the twenty-four
closed four-walks through `K`, which for a symmetric sign matrix is `24` or
`-8`. -/
theorem trace_pow_four (A : Matrix n n R) (hdiag : ∀ i, A i i = 0)
    (hone : ∀ i j, i ≠ j → A i j * A j i = 1) :
    Matrix.trace (A * A * A * A) =
      (Fintype.card n : R) * ((Fintype.card n : R) - 1)
        + 12 * ((Fintype.card n).choose 3 : R)
        + ∑ K ∈ (Finset.univ : Finset n).powersetCard 4, closedFourWalkSum A K := by
  have htrace : Matrix.trace (A * A * A * A)
      = ∑ i, ∑ j, ∑ k, ∑ l, A i j * A j k * A k l * A l i := by
    simp only [Matrix.trace, Matrix.diag_apply, Matrix.mul_apply, Finset.sum_mul]
    refine Finset.sum_congr rfl fun i _ => ?_
    refine Eq.trans (Finset.sum_congr rfl fun _ _ => Finset.sum_comm) ?_
    refine Eq.trans Finset.sum_comm ?_
    exact Finset.sum_congr rfl fun _ _ => Finset.sum_comm
  rw [htrace, ← Finset.card_univ]
  exact sum_walkTerm_eq_add_sum_powersetCard A hdiag hone Finset.univ

omit [Fintype n] in
/-- On a four-element label set the closed four-walks are the twenty-four
traversals of its three Hamilton cycles, four starting points and two
directions each, so their weights sum to eight times the sum of the three
cycle products. -/
theorem closedFourWalkSum_labelled (A : Matrix n n R) (hsym : ∀ i j, A j i = A i j)
    {a b c d : n} (hab : a ≠ b) (hac : a ≠ c) (had : a ≠ d) (hbc : b ≠ c) (hbd : b ≠ d)
    (hcd : c ≠ d) :
    closedFourWalkSum A {a, b, c, d}
      = 8 * (A a b * A b c * A c d * A d a + A a b * A b d * A d c * A c a
          + A a c * A c b * A b d * A d a) := by
  have hsum4 : ∀ g : n → R, ∑ x ∈ ({a, b, c, d} : Finset n), g x = g a + g b + g c + g d := by
    intro g
    rw [Finset.sum_insert (by simp [hab, hac, had]), Finset.sum_insert (by simp [hbc, hbd]),
      Finset.sum_insert (by simp [hcd]), Finset.sum_singleton]
    ring
  simp only [closedFourWalkSum, hsum4]
  simp only [WalkInjective, walkTerm, ne_eq, hab, hac, had, hbc, hbd, hcd, Ne.symm hab,
    Ne.symm hac, Ne.symm had, Ne.symm hbc, Ne.symm hbd, Ne.symm hcd, not_false_eq_true,
    not_true_eq_false, and_true, and_false, if_true, if_false]
  simp only [hsym a b, hsym a c, hsym a d, hsym b c, hsym b d, hsym c d]
  ring

omit [Fintype n] in
/-- The same identity with the three cycle products read off a labelling of the
four-set as `fourSetWeight`. -/
theorem closedFourWalkSum_eq_eight_mul_fourSetWeight (A : Matrix n n R)
    (hsym : ∀ i j, A j i = A i j) (f : Fin 4 → n) (hf : Function.Injective f) :
    closedFourWalkSum A {f 0, f 1, f 2, f 3} = 8 * fourSetWeight (A.submatrix f f) := by
  rw [closedFourWalkSum_labelled A hsym (fun h => absurd (hf h) (by decide))
    (fun h => absurd (hf h) (by decide)) (fun h => absurd (hf h) (by decide))
    (fun h => absurd (hf h) (by decide)) (fun h => absurd (hf h) (by decide))
    (fun h => absurd (hf h) (by decide))]
  simp only [fourSetWeight, Matrix.submatrix_apply]

omit [Fintype n] in
/-- Every four-set of a zero-diagonal symmetric sign matrix carries closed
four-walk weight `24` or `-8`, that is eight times the four-set weight `3` or
`-1`. -/
theorem closedFourWalkSum_eq_twentyFour_or_neg_eight (A : Matrix n n R)
    (hsym : ∀ i j, A j i = A i j) (hsq : ∀ i j, i ≠ j → A i j * A i j = 1)
    {K : Finset n} (hK : K.card = 4) :
    (closedFourWalkSum A K - 24) * (closedFourWalkSum A K + 8) = 0 := by
  obtain ⟨a, b, c, d, hab, hac, had, hbc, hbd, hcd, rfl⟩ := Finset.card_eq_four.mp hK
  rw [closedFourWalkSum_labelled A hsym hab hac had hbc hbd hcd, hsym a d, hsym a c,
    hsym c d, hsym b c]
  have hw := sum_hamiltonCycles_eq_three_or_neg_one (A a b) (A a c) (A a d) (A b c) (A b d)
    (A c d) (hsq a b hab) (hsq a c hac) (hsq a d had) (hsq b c hbc) (hsq b d hbd)
    (hsq c d hcd)
  linear_combination 64 * hw

/-- Cut-independence of the second exchange moment forces the four-set weights
to agree.  If the label set has `2d` elements with `4 ≤ d`, and the sum of the
closed four-walk weights over the four-subsets of `Y` is the same for every
balanced half `Y`, then every four-subset carries the same weight.  This is the
inclusion-sum swap descent, not the rank formula for inclusion matrices. -/
theorem closedFourWalkSum_eq_of_sum_eq [CharZero R] [NoZeroDivisors R] (A : Matrix n n R)
    {d : ℕ} (hd : 4 ≤ d) (hn : Fintype.card n = 2 * d) {c : R}
    (h : ∀ Y ⊆ (Finset.univ : Finset n), Y.card = d →
      ∑ K ∈ Y.powersetCard 4, closedFourWalkSum A K = c) :
    ∀ K₁ ⊆ (Finset.univ : Finset n), K₁.card = 4 →
      ∀ K₂ ⊆ (Finset.univ : Finset n), K₂.card = 4 →
        closedFourWalkSum A K₁ = closedFourWalkSum A K₂ :=
  SubsetInclusionSums.eq_of_sum_powersetCard_eq (by omega) (by omega)
    (by rw [Finset.card_univ, hn]; omega) h

end ClosedFourWalks

end RelativeConicArcs.ConferenceCutBlocks
