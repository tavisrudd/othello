import RelativeConicArcs.ClebschOrbitOrderReduction
import RelativeConicArcs.ClebschRegularMatching

/-!
# Exceptional-order endgame for balanced matching orbits

Suppose `q` is odd and at least five, a matching stabilizer has order `k`,
and orbit--stabilizer gives `2k = q² - 1`.  After the projective subgroup
reduction restricts `k` to `12`, `24`, or `60`, and the fused `q = 5` row
is excluded, the remaining parameters are exactly `(q,k) = (7,24)` and
`(11,60)`.  These are recorded as the `B₃` and `H₃` endpoints.

The final theorem combines this arithmetic classification with the exact
classification of matchings invariant under a regular group action.  It is
an if-and-only-if statement: each surviving endpoint and each nonidentity
involution supplies a matching, and every matching in the stated domain
arises in this way.

This module does not assert the projective subgroup reduction or the
geometric exclusion of the fused row.  They occur as the explicit order
and inequality hypotheses of the arithmetic domain below.
-/

namespace RelativeConicArcs.ClebschBalancedOrbitEndgame

open ClebschOrbitOrderReduction ClebschRegularMatching

/-- The two rank-three endpoints surviving the exceptional-order reduction. -/
inductive Endpoint
  | b3
  | h3
  deriving DecidableEq

/-- The field cardinality attached to a surviving endpoint. -/
def Endpoint.fieldCardinality : Endpoint → ℕ
  | .b3 => 7
  | .h3 => 11

/-- The matching-stabilizer order attached to a surviving endpoint. -/
def Endpoint.stabilizerOrder : Endpoint → ℕ
  | .b3 => 24
  | .h3 => 60

/-- The explicit arithmetic domain after the exceptional subgroup orders
have been identified and the fused field-cardinality-five row has been
excluded. -/
def ExceptionalSplitDomain (q k : ℕ) : Prop :=
  Odd q ∧ 5 ≤ q ∧ 2 * k = q * q - 1 ∧
    (k = 12 ∨ k = 24 ∨ k = 60) ∧ q ≠ 5

/-- The exceptional split domain consists exactly of the `B₃` and `H₃`
parameter pairs.  The existential endpoint records which pair occurs. -/
theorem exceptionalSplitDomain_iff_exists_endpoint {q k : ℕ} :
    ExceptionalSplitDomain q k ↔
      ∃ endpoint : Endpoint,
        q = endpoint.fieldCardinality ∧ k = endpoint.stabilizerOrder := by
  constructor
  · rintro ⟨hqOdd, hqLower, hstabilizer, hk, hqFive⟩
    have hcandidates :=
      exceptional_order_candidates hqOdd hqLower hstabilizer (by omega : k ≤ 60)
    rcases exceptional_pairs hcandidates hstabilizer hk with h | h | h
    · exact (hqFive h.1).elim
    · exact ⟨Endpoint.b3, by simpa [Endpoint.fieldCardinality] using h.1,
        by simpa [Endpoint.stabilizerOrder] using h.2⟩
    · exact ⟨Endpoint.h3, by simpa [Endpoint.fieldCardinality] using h.1,
        by simpa [Endpoint.stabilizerOrder] using h.2⟩
  · rintro ⟨endpoint, rfl, rfl⟩
    cases endpoint
    · refine ⟨⟨3, by norm_num [Endpoint.fieldCardinality]⟩,
        by norm_num [Endpoint.fieldCardinality],
        by norm_num [Endpoint.fieldCardinality, Endpoint.stabilizerOrder], ?_,
        by norm_num [Endpoint.fieldCardinality]⟩
      exact Or.inr (Or.inl rfl)
    · refine ⟨⟨5, by norm_num [Endpoint.fieldCardinality]⟩,
        by norm_num [Endpoint.fieldCardinality],
        by norm_num [Endpoint.fieldCardinality, Endpoint.stabilizerOrder], ?_,
        by norm_num [Endpoint.fieldCardinality]⟩
      exact Or.inr (Or.inr rfl)

/-- In the exceptional split domain, invariant perfect matchings for a
regular group action are exactly right multiplications by nonidentity
involutions, with an explicit `B₃` or `H₃` endpoint witness. -/
theorem exceptionalSplit_regularMatching_iff
    {K : Type*} [Group K] {q k : ℕ} (m : K → K) :
    ExceptionalSplitDomain q k ∧
        LeftRegularEquivariant m ∧ IsPerfectMatching m ↔
      ∃ endpoint : Endpoint, ∃ c : K,
        q = endpoint.fieldCardinality ∧
        k = endpoint.stabilizerOrder ∧
        m = rightMultiplication c ∧ c * c = 1 ∧ c ≠ 1 := by
  constructor
  · rintro ⟨hdomain, hequivariant, hmatching⟩
    obtain ⟨endpoint, hq, hk⟩ :=
      exceptionalSplitDomain_iff_exists_endpoint.mp hdomain
    obtain ⟨c, hm, hsquare, hne⟩ :=
      (leftRegularEquivariant_perfectMatching_iff m).mp
        ⟨hequivariant, hmatching⟩
    exact ⟨endpoint, c, hq, hk, hm, hsquare, hne⟩
  · rintro ⟨endpoint, c, hq, hk, hm, hsquare, hne⟩
    have hdomain : ExceptionalSplitDomain q k :=
      exceptionalSplitDomain_iff_exists_endpoint.mpr ⟨endpoint, hq, hk⟩
    have hmatching : LeftRegularEquivariant m ∧ IsPerfectMatching m :=
      (leftRegularEquivariant_perfectMatching_iff m).mpr
        ⟨c, hm, hsquare, hne⟩
    exact ⟨hdomain, hmatching.1, hmatching.2⟩

end RelativeConicArcs.ClebschBalancedOrbitEndgame
