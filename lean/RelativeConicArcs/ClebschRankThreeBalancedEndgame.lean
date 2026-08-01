import RelativeConicArcs.ClebschArithmeticGluing
import RelativeConicArcs.ClebschA3InvariantMatching
import RelativeConicArcs.ClebschB3InvariantMatchings
import RelativeConicArcs.ClebschH3InvariantMatchings
import RelativeConicArcs.ClebschBalancedOrbitEndgame

/-!
# Rank-three endpoint composition for balanced matching sheets

Five explicit matching models occur in the bounded exceptional-order
endgame: one cardinality-five model and two models at each of cardinalities
seven and eleven.  A model has certified balanced sheets when the tracked
full-orbit and half-orbit tables have sizes `2q` and `q`, respectively.

The cardinality-five model is fused: its full and square-determinant orbits
coincide and have five members.  The cardinality-seven tables have a
fourteen-member full orbit and two disjoint seven-member halves.  The
cardinality-eleven certificate has twenty-two distinct full-orbit signatures
and two disjoint eleven-row halves.  Therefore certified balanced sheets are
equivalent to the existence of a `B₃` or `H₃` endpoint witness.  This
equivalence supplies the formerly separate `q ≠ 5` hypothesis to the
arithmetic endgame.

For characteristic eleven, the conclusion concerns the literal certificate
tables.  Their completeness as projective coset tables remains the separate
certificate-replay boundary stated by the imported arithmetic-gluing module.
-/

namespace RelativeConicArcs.ClebschRankThreeBalancedEndgame

open ClebschArithmeticGluing
open ClebschBalancedOrbitEndgame

/-- The five displayed matching models in the rank-three endpoint data. -/
inductive MatchingModel
  | a3
  | b3Negative
  | b3Positive
  | h3Base
  | h3Conjugate
  deriving DecidableEq

/-- The field cardinality of a displayed matching model. -/
def MatchingModel.fieldCardinality : MatchingModel → ℕ
  | .a3 => 5
  | .b3Negative | .b3Positive => 7
  | .h3Base | .h3Conjugate => 11

/-- The stabilizer order of a displayed matching model. -/
def MatchingModel.stabilizerOrder : MatchingModel → ℕ
  | .a3 => 12
  | .b3Negative | .b3Positive => 24
  | .h3Base | .h3Conjugate => 60

/-- The exact orbit-size assertion certifying two balanced sheets for a
displayed model.  The cardinality-eleven branch is stated at the literal
signature-table level. -/
def MatchingModel.HasCertifiedBalancedSheets : MatchingModel → Prop
  | .a3 => (mateOrbit pgl a3MatchingEdges).card = 10
  | .b3Negative | .b3Positive =>
      (mateOrbit pgl b3NegativeMatchingEdges).card = 14 ∧
      (mateOrbit psl b3NegativeMatchingEdges).card = 7 ∧
      (mateOrbit psl b3PositiveMatchingEdges).card = 7 ∧
      Disjoint (mateOrbit psl b3NegativeMatchingEdges)
        (mateOrbit psl b3PositiveMatchingEdges)
  | .h3Base | .h3Conjugate =>
      (certificateSignatures h3ProjectiveCosetRepresentatives
        h3BaseMatchingEdges).length = 22 ∧
      (certificateSignatures h3BaseSquareCosetRepresentatives
        h3BaseMatchingEdges).length = 11 ∧
      (certificateSignatures h3ConjugateSquareCosetRepresentatives
        h3ConjugateMatchingEdges).length = 11 ∧
      (∀ s ∈ certificateSignatures h3BaseSquareCosetRepresentatives
          h3BaseMatchingEdges,
        s ∉ certificateSignatures h3ConjugateSquareCosetRepresentatives
          h3ConjugateMatchingEdges)

/-- Every fixed-point-free partner map equivariant for the model's displayed
stabilizer data is the model's displayed matching. -/
def MatchingModel.InvariantPartnerUnique : MatchingModel → Prop
  | .a3 => ∀ m : ProjectivePoint 5 → ProjectivePoint 5,
      (∀ x, m x ≠ x) →
      (∀ g ∈ ClebschA3InvariantMatching.squareStabilizer, ∀ x,
        projectiveAction g (m x) = m (projectiveAction g x)) →
      m = matchingMate a3MatchingEdges
  | .b3Negative => ∀ m : ProjectivePoint 7 → ProjectivePoint 7,
      (∀ x, m x ≠ x) →
      (∀ g ∈ ClebschB3InvariantMatchings.negativeStabilizer, ∀ x,
        projectiveAction g (m x) = m (projectiveAction g x)) →
      m = matchingMate b3NegativeMatchingEdges
  | .b3Positive => ∀ m : ProjectivePoint 7 → ProjectivePoint 7,
      (∀ x, m x ≠ x) →
      (∀ g ∈ ClebschB3InvariantMatchings.positiveStabilizer, ∀ x,
        projectiveAction g (m x) = m (projectiveAction g x)) →
      m = matchingMate b3PositiveMatchingEdges
  | .h3Base => ∀ m : ProjectivePoint 11 → ProjectivePoint 11,
      (∀ x, m x ≠ x) →
      (∀ g ∈ ClebschH3InvariantMatchings.baseStabilizerRows, ∀ x,
        projectiveAction g (m x) = m (projectiveAction g x)) →
      m = matchingMate h3BaseMatchingEdges
  | .h3Conjugate => ∀ m : ProjectivePoint 11 → ProjectivePoint 11,
      (∀ x, m x ≠ x) →
      (∀ g ∈ ClebschH3InvariantMatchings.conjugateStabilizerRows, ∀ x,
        projectiveAction g (m x) = m (projectiveAction g x)) →
      m = matchingMate h3ConjugateMatchingEdges

/-- Every displayed rank-three model has a unique invariant partner map in
the precise sense specified by its stabilizer data. -/
theorem invariantPartnerUnique (model : MatchingModel) :
    model.InvariantPartnerUnique := by
  cases model
  · exact ClebschA3InvariantMatching.invariantMatching_eq
  · exact ClebschB3InvariantMatchings.negative_invariantMatching_eq
  · exact ClebschB3InvariantMatchings.positive_invariantMatching_eq
  · exact ClebschH3InvariantMatchings.base_invariantMatching_eq
  · exact ClebschH3InvariantMatchings.conjugate_invariantMatching_eq

/-- The cardinality-five model does not have a balanced ten-member full
orbit: its full orbit has five members. -/
theorem a3_not_hasCertifiedBalancedSheets :
    ¬ MatchingModel.a3.HasCertifiedBalancedSheets := by
  intro hbalanced
  have hfused := ClebschA3InvariantMatching.fullOrbit_eq_squareOrbit_and_card.2
  simp only [MatchingModel.HasCertifiedBalancedSheets] at hbalanced
  omega

/-- Both cardinality-seven matching models have the certified `7+7` orbit
split. -/
theorem b3_hasCertifiedBalancedSheets (model : MatchingModel)
    (hmodel : model = .b3Negative ∨ model = .b3Positive) :
    model.HasCertifiedBalancedSheets := by
  rcases hmodel with rfl | rfl <;>
    simpa only [MatchingModel.HasCertifiedBalancedSheets] using
      b3_split_stabilizers_and_orbits.2.2.2.2.2

/-- Both cardinality-eleven matching models have the certified `11+11`
signature split. -/
theorem h3_hasCertifiedBalancedSheets (model : MatchingModel)
    (hmodel : model = .h3Base ∨ model = .h3Conjugate) :
    model.HasCertifiedBalancedSheets := by
  rcases h3_certificate_literal_checks with
    ⟨_, _, _, _, _, _, hfull, _, hbase, _, hconjugate, hdisjoint⟩
  rcases hmodel with rfl | rfl <;>
    exact ⟨hfull, hbase, hconjugate, hdisjoint⟩

/-- A displayed model has certified balanced sheets exactly when its field
cardinality and stabilizer order are represented by a surviving endpoint. -/
theorem hasCertifiedBalancedSheets_iff_exists_endpoint (model : MatchingModel) :
    model.HasCertifiedBalancedSheets ↔
      ∃ endpoint : Endpoint,
        model.fieldCardinality = endpoint.fieldCardinality ∧
        model.stabilizerOrder = endpoint.stabilizerOrder := by
  cases model
  · constructor
    · exact fun h ↦ (a3_not_hasCertifiedBalancedSheets h).elim
    · rintro ⟨endpoint, hq, _⟩
      cases endpoint <;> simp [MatchingModel.fieldCardinality,
        Endpoint.fieldCardinality] at hq
  · constructor
    · intro _
      exact ⟨Endpoint.b3, rfl, rfl⟩
    · intro _
      exact b3_hasCertifiedBalancedSheets .b3Negative (Or.inl rfl)
  · constructor
    · intro _
      exact ⟨Endpoint.b3, rfl, rfl⟩
    · intro _
      exact b3_hasCertifiedBalancedSheets .b3Positive (Or.inr rfl)
  · constructor
    · intro _
      exact ⟨Endpoint.h3, rfl, rfl⟩
    · intro _
      exact h3_hasCertifiedBalancedSheets .h3Base (Or.inl rfl)
  · constructor
    · intro _
      exact ⟨Endpoint.h3, rfl, rfl⟩
    · intro _
      exact h3_hasCertifiedBalancedSheets .h3Conjugate (Or.inr rfl)

/-- For every displayed model, certified balanced sheets are equivalent to
the explicit exceptional split domain of the arithmetic endgame.  In
particular the fused cardinality-five row is excluded by its checked orbit,
not by an assumed inequality. -/
theorem hasCertifiedBalancedSheets_iff_exceptionalSplitDomain
    (model : MatchingModel) :
    model.HasCertifiedBalancedSheets ↔
      ExceptionalSplitDomain model.fieldCardinality model.stabilizerOrder := by
  rw [hasCertifiedBalancedSheets_iff_exists_endpoint,
    exceptionalSplitDomain_iff_exists_endpoint]

/-- A certified balanced model supplies both a surviving arithmetic endpoint
and the exact uniqueness theorem for its invariant matching partner. -/
theorem certifiedBalancedSheets_endpoint_and_uniquePartner
    (model : MatchingModel) (hbalanced : model.HasCertifiedBalancedSheets) :
    (∃ endpoint : Endpoint,
      model.fieldCardinality = endpoint.fieldCardinality ∧
      model.stabilizerOrder = endpoint.stabilizerOrder) ∧
      model.InvariantPartnerUnique :=
  ⟨(hasCertifiedBalancedSheets_iff_exists_endpoint model).mp hbalanced,
    invariantPartnerUnique model⟩

end RelativeConicArcs.ClebschRankThreeBalancedEndgame
