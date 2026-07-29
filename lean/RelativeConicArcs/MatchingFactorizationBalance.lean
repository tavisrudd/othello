import Mathlib

/-!
# Edge multiplicity and the size of a matching sheet

Let `S` be a finite family of matchings in a finite edge set.  If every
matching contains `m` edges and every edge occurs in exactly `λ` members of
`S`, double counting incident pairs gives

`|S| m = |E| λ`.

For perfect matchings on `q + 1 = 2 (r + 1)` vertices, one has
`m = r + 1` and `|E| = q (r + 1)`.  Cancellation therefore gives
`|S| = q λ`.  In particular, an ordinary one-factorization (`λ = 1`) has
exactly `q` matchings.

The statements are incidence-theoretic.  They do not assume a group action
or a conic-quotient realization; those structures are used separately to
establish constant edge multiplicity.
-/

namespace RelativeConicArcs.MatchingFactorizationBalance

open scoped BigOperators

variable {Matching Edge : Type*}

/-! ### A transitive orbit and a stable trade line -/

/-- A nonzero function spanning a group-stable line on a transitive
`G`-set has full support.  Indeed, its zero set is invariant, and a
transitive set has no proper nonempty invariant subset. -/
theorem stableLine_fullSupport
    {G Ω k : Type*} [Group G] [MulAction G Ω]
    [MulAction.IsPretransitive G Ω] [Field k]
    (weight : Ω → k) (hne : weight ≠ 0)
    (hstable : ∀ g : G, ∃ c : k, ∀ i, weight (g • i) = c * weight i) :
    ∀ i, weight i ≠ 0 := by
  have hexists : ∃ j, weight j ≠ 0 := by
    by_contra h
    push Not at h
    apply hne
    funext j
    exact h j
  obtain ⟨j, hj⟩ := hexists
  intro i hi
  obtain ⟨g, hg⟩ := MulAction.exists_smul_eq G i j
  obtain ⟨c, hc⟩ := hstable g
  apply hj
  rw [← hg, hc i, hi, mul_zero]

/-! ### Incidence double counting -/

/-- Double counting pairs `(M, e)` with `M ∈ S` and `e` incident with `M`.
Every member of `S` has `m` incident edges and every edge has multiplicity
`λ`, so `|S| m = |E| λ`. -/
theorem card_mul_edgesPerMatching_eq_card_mul_edgeMultiplicity
    [DecidableEq Matching] [DecidableEq Edge] [Fintype Edge]
    (S : Finset Matching) (incidentEdges : Matching → Finset Edge)
    (m index : ℕ)
    (hmatching : ∀ M ∈ S, (incidentEdges M).card = m)
    (hedge : ∀ e : Edge, (S.filter fun M => e ∈ incidentEdges M).card = index) :
    S.card * m = Fintype.card Edge * index := by
  calc
    S.card * m = ∑ M ∈ S, m := by simp
    _ = ∑ M ∈ S, (incidentEdges M).card := by
      apply Finset.sum_congr rfl
      intro M hM
      exact (hmatching M hM).symm
    _ = ∑ M ∈ S, ∑ e : Edge, if e ∈ incidentEdges M then 1 else 0 := by
      apply Finset.sum_congr rfl
      intro M _
      simp
    _ = ∑ e : Edge, ∑ M ∈ S, if e ∈ incidentEdges M then 1 else 0 := by
      rw [Finset.sum_comm]
    _ = ∑ e : Edge, (S.filter fun M => e ∈ incidentEdges M).card := by
      apply Finset.sum_congr rfl
      intro e _
      simp
    _ = Fintype.card Edge * index := by simp [hedge]

/-- If every matching has `r + 1` edges and the complete edge set has
`q (r + 1)` elements, a constant edge multiplicity `λ` forces the sheet to
have `q λ` matchings.  The equality `q + 1 = 2 (r + 1)` that identifies
`r + 1` as the size of a perfect matching is deliberately kept outside this
arithmetic cancellation lemma. -/
theorem sheet_card_eq_q_mul_index
    [DecidableEq Matching] [DecidableEq Edge] [Fintype Edge]
    (S : Finset Matching) (incidentEdges : Matching → Finset Edge)
    (q r index : ℕ)
    (hedgesCard : Fintype.card Edge = q * (r + 1))
    (hmatching : ∀ M ∈ S, (incidentEdges M).card = r + 1)
    (hedge : ∀ e : Edge, (S.filter fun M => e ∈ incidentEdges M).card = index) :
    S.card = q * index := by
  have hcount :=
    card_mul_edgesPerMatching_eq_card_mul_edgeMultiplicity
      S incidentEdges (r + 1) index hmatching hedge
  rw [hedgesCard] at hcount
  have hreordered : S.card * (r + 1) = (q * index) * (r + 1) := by
    simpa [mul_assoc, mul_comm, mul_left_comm] using hcount
  exact Nat.eq_of_mul_eq_mul_right (by omega : 0 < r + 1) hreordered

/-- An index-one factorization sheet on `q + 1` vertices has exactly `q`
perfect matchings. -/
theorem oneFactorization_card_eq_q
    [DecidableEq Matching] [DecidableEq Edge] [Fintype Edge]
    (S : Finset Matching) (incidentEdges : Matching → Finset Edge)
    (q r : ℕ)
    (hedgesCard : Fintype.card Edge = q * (r + 1))
    (hmatching : ∀ M ∈ S, (incidentEdges M).card = r + 1)
    (hedge : ∀ e : Edge, (S.filter fun M => e ∈ incidentEdges M).card = 1) :
    S.card = q := by
  simpa using
    sheet_card_eq_q_mul_index S incidentEdges q r 1 hedgesCard hmatching hedge

/-- Conversely, a constant-multiplicity sheet of cardinality `q` has
edge multiplicity one, provided `q` is positive.  Together with
`sheet_card_eq_q_mul_index`, this shows that ruling out sheets with
`index > 1` is equivalent to proving the ordinary factorization size. -/
theorem edgeMultiplicity_eq_one_of_sheet_card_eq_q
    [DecidableEq Matching] [DecidableEq Edge] [Fintype Edge]
    (S : Finset Matching) (incidentEdges : Matching → Finset Edge)
    (q r index : ℕ) (hq : 0 < q)
    (hedgesCard : Fintype.card Edge = q * (r + 1))
    (hmatching : ∀ M ∈ S, (incidentEdges M).card = r + 1)
    (hedge : ∀ e : Edge, (S.filter fun M => e ∈ incidentEdges M).card = index)
    (hcard : S.card = q) :
    index = 1 := by
  have hsheet :=
    sheet_card_eq_q_mul_index
      S incidentEdges q r index hedgesCard hmatching hedge
  have hproduct : q * index = q * 1 := by
    omega
  exact Nat.eq_of_mul_eq_mul_left hq hproduct

/-- Two disjoint index-one factorization sheets have total size `2q`.
This is the formal `q + q` conclusion used after the intrinsic trade line
has recovered the two sheets. -/
theorem twoOneFactorizationSheets_card_eq_two_mul_q
    [DecidableEq Matching]
    (positive negative : Finset Matching) (q : ℕ)
    (hdisjoint : Disjoint positive negative)
    (hpositive : positive.card = q)
    (hnegative : negative.card = q) :
    (positive ∪ negative).card = 2 * q := by
  rw [Finset.card_union_of_disjoint hdisjoint, hpositive, hnegative]
  omega

end RelativeConicArcs.MatchingFactorizationBalance
