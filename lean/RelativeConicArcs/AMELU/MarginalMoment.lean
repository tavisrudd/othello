import RelativeConicArcs.AMELU.StabilizerDictionary

/-!
# Triple-marginal ranks and the six-point concurrency count

A four-party marginal is indexed by the omitted pair of parties, hence by
an edge of the complete graph on six vertices.  An unordered choice of three
such marginals is represented by `MarginalTriple`.  This module proves the
finite graph facts behind the marginal-moment count: there are 455 triples,
60 stars, and 15 perfect matchings, and stars and perfect matchings are
disjoint.

`MarginalMomentModel` records the two mathematical bridges used for a
stabilizer state.  Its trace field states

`Tr(A_T A_U A_V) = |𝔽|⁻rank(L(T)+L(U)+L(V))`,

and its incidence field states that rank four occurs exactly for a star or
for a perfect matching whose three chords concur in both the six-arc and its
Gale dual.  These bridges are explicit hypotheses: this module proves their
counting and arithmetic consequences, but does not derive them from density
matrices or projective coordinates.

The terminal separator says that ten common concurrent matchings on one side
and at most six on the other forbid local-unitary equivalence whenever local
unitaries preserve the rank-four marginal multiplicity.  The three finite
graph cardinalities are exhaustively discharged by `native_decide`; the
structural reduction and arithmetic separator are ordinary kernel-checked
proofs.  There is no generated certificate, project-specific axiom, or
admitted declaration.
-/

namespace RelativeConicArcs.AMELU

open Finset

/-- An edge of the complete graph on the six parties. -/
abbrev OmittedPair := {e : Finset Party // e.card = 2}

/-- An unordered triple of distinct omitted pairs, equivalently an unordered
triple of four-party marginals. -/
abbrev MarginalTriple := {E : Finset OmittedPair // E.card = 3}

/-- Three omitted pairs form a star when they have a common party. -/
def IsMarginalStar (E : MarginalTriple) : Prop :=
  ∃ i : Party, ∀ e ∈ E.1, i ∈ e.1

/-- Three omitted pairs form a perfect matching when every party occurs in
exactly one of them. -/
def IsPerfectMatching (E : MarginalTriple) : Prop :=
  ∀ i : Party, (E.1.filter fun e => i ∈ e.1).card = 1

instance (E : MarginalTriple) : Decidable (IsMarginalStar E) :=
  by
    unfold IsMarginalStar
    infer_instance

instance (E : MarginalTriple) : Decidable (IsPerfectMatching E) :=
  by
    unfold IsPerfectMatching
    infer_instance

/-- The 455 unordered triples of four-party marginals. -/
theorem card_marginalTriples : Fintype.card MarginalTriple = 455 := by
  native_decide

/-- Exactly 60 triples of omitted pairs are three-edge stars. -/
theorem card_marginalStars :
    (Finset.univ.filter IsMarginalStar).card = 60 := by
  native_decide

/-- Exactly 15 triples of omitted pairs are perfect matchings. -/
theorem card_perfectMatchings :
    (Finset.univ.filter IsPerfectMatching).card = 15 := by
  native_decide

/-- A three-edge star cannot be a perfect matching. -/
theorem marginalStar_not_perfectMatching (E : MarginalTriple)
    (hstar : IsMarginalStar E) : ¬ IsPerfectMatching E := by
  intro hmatching
  obtain ⟨i, hi⟩ := hstar
  obtain ⟨e₀, he₀⟩ := Finset.card_eq_one.mp (hmatching i)
  have hsubset : E.1 ⊆ {e₀} := by
    intro e he
    have hei : i ∈ e.1 := hi e he
    have hefilter : e ∈ E.1.filter fun f => i ∈ f.1 :=
      Finset.mem_filter.mpr ⟨he, hei⟩
    rw [he₀] at hefilter
    exact hefilter
  have hcard := Finset.card_le_card hsubset
  rw [E.2] at hcard
  simp at hcard

/-- The four-party subsystem indexed by an omitted pair. -/
def fourPartySet (e : OmittedPair) : Finset Party :=
  e.1ᶜ

/-- Sum of the three supported CSS stabilizer-label spaces indexed by a
triple of omitted pairs. -/
def tripleSupportedLabelSpace {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    (C : Submodule 𝔽 (BasisLabel 𝔽)) (E : MarginalTriple) :
    Submodule 𝔽 (PauliLabel 𝔽) :=
  ∑ e ∈ E.1, cssSupportedLabelSpace C (fourPartySet e)

/-- Rank of the sum of the three supported CSS stabilizer-label spaces. -/
noncomputable def stabilizerMarginalRank
    {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    (C : Submodule 𝔽 (BasisLabel 𝔽)) (E : MarginalTriple) : ℕ :=
  Module.finrank 𝔽 (tripleSupportedLabelSpace C E)

/-- Rank and trace data for the triple four-party marginals of the
equal-phase state of `C`.  The Boolean `commonConcurrent` marks the perfect
matchings whose three chords concur in both the six-arc and its Gale dual.

The two proof fields expose, rather than assume silently, the stabilizer
trace/rank identity and the geometric rank-four criterion. -/
structure MarginalMomentModel
    (𝔽 : Type*) [Field 𝔽] [Fintype 𝔽]
    (C : Submodule 𝔽 (BasisLabel 𝔽)) where
  /-- Triple marginal trace `Tr(A_T A_U A_V)`. -/
  traceMoment : MarginalTriple → ℝ
  /-- Common chord concurrency for a perfect matching in the arc and Gale
  dual. -/
  commonConcurrent : MarginalTriple → Bool
  /-- Stabilizer expansion of the triple marginal trace. -/
  trace_eq_card_pow_rank :
    ∀ E, traceMoment E =
      (((Fintype.card 𝔽 : ℝ) ^ stabilizerMarginalRank C E)⁻¹)
  /-- Geometric reduction of rank four to stars and common concurrent
  perfect matchings. -/
  rank_eq_four_iff :
    ∀ E, stabilizerMarginalRank C E = 4 ↔
      IsMarginalStar E ∨
        (IsPerfectMatching E ∧ commonConcurrent E = true)

/-- Number of triple marginal moments whose stabilizer rank is four. -/
noncomputable def rankFourMultiplicity
    {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    {C : Submodule 𝔽 (BasisLabel 𝔽)}
    (_M : MarginalMomentModel 𝔽 C) : ℕ :=
  (Finset.univ.filter fun E => stabilizerMarginalRank C E = 4).card

/-- Number of perfect matchings concurrent in both the arc and its Gale
dual. -/
noncomputable def commonConcurrentMatchingCount
    {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    {C : Submodule 𝔽 (BasisLabel 𝔽)}
    (M : MarginalMomentModel 𝔽 C) : ℕ := by
  classical
  exact
    (Finset.univ.filter fun E =>
      IsPerfectMatching E ∧ M.commonConcurrent E = true).card

/-- The stabilizer trace of every rank-four triple is `|𝔽|⁻⁴`. -/
theorem traceMoment_eq_card_pow_four_of_rank_eq_four
    {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    {C : Submodule 𝔽 (BasisLabel 𝔽)}
    (M : MarginalMomentModel 𝔽 C)
    {E : MarginalTriple} (hE : stabilizerMarginalRank C E = 4) :
    M.traceMoment E = (((Fintype.card 𝔽 : ℝ) ^ 4)⁻¹) := by
  rw [M.trace_eq_card_pow_rank E, hE]

/-- The concurrency-count reduction
`#{rank-four triples} = 60 + #{common concurrent perfect matchings}`. -/
theorem rankFourMultiplicity_eq_sixty_add_concurrency
    {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    {C : Submodule 𝔽 (BasisLabel 𝔽)}
    (M : MarginalMomentModel 𝔽 C) :
    rankFourMultiplicity M = 60 + commonConcurrentMatchingCount M := by
  classical
  let stars : Finset MarginalTriple :=
    Finset.univ.filter IsMarginalStar
  let concurrent : Finset MarginalTriple :=
    Finset.univ.filter fun E =>
      IsPerfectMatching E ∧ M.commonConcurrent E = true
  have hfilter :
      Finset.univ.filter (fun E => stabilizerMarginalRank C E = 4) =
        stars ∪ concurrent := by
    ext E
    simp only [Finset.mem_filter, Finset.mem_univ, true_and,
      Finset.mem_union, stars, concurrent]
    exact M.rank_eq_four_iff E
  have hdisjoint : Disjoint stars concurrent := by
    refine Finset.disjoint_left.mpr ?_
    intro E hstar hconcurrent
    have hs : IsMarginalStar E := by
      simpa [stars] using hstar
    have hm : IsPerfectMatching E := by
      have hc :
          IsPerfectMatching E ∧ M.commonConcurrent E = true := by
        simpa [concurrent] using hconcurrent
      exact hc.1
    exact marginalStar_not_perfectMatching E hs hm
  rw [rankFourMultiplicity, commonConcurrentMatchingCount, hfilter,
    Finset.card_union_of_disjoint hdisjoint]
  change stars.card + concurrent.card = 60 + concurrent.card
  rw [show stars.card = 60 by
    simpa [stars] using card_marginalStars]

/-- Ten common concurrent matchings give exactly 70 rank-four moments. -/
theorem rankFourMultiplicity_eq_seventy_of_concurrency_eq_ten
    {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    {C : Submodule 𝔽 (BasisLabel 𝔽)}
    (M : MarginalMomentModel 𝔽 C)
    (hM : commonConcurrentMatchingCount M = 10) :
    rankFourMultiplicity M = 70 := by
  rw [rankFourMultiplicity_eq_sixty_add_concurrency M, hM]

/-- At most six common concurrent matchings give at most 66 rank-four
moments. -/
theorem rankFourMultiplicity_le_sixtySix_of_concurrency_le_six
    {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽]
    {C : Submodule 𝔽 (BasisLabel 𝔽)}
    (M : MarginalMomentModel 𝔽 C)
    (hM : commonConcurrentMatchingCount M ≤ 6) :
    rankFourMultiplicity M ≤ 66 := by
  rw [rankFourMultiplicity_eq_sixty_add_concurrency M]
  omega

/-- Exact inputs for the marginal-moment LU separator between two states.
The final field is the basis-independent content of the trace invariant:
an LU equivalence, including a party permutation, preserves the
multiplicity of the rank-four trace value. -/
structure MarginalLUSeparatorInputs
    (𝔽 : Type*) [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    (C D : Submodule 𝔽 (BasisLabel 𝔽)) : Type where
  /-- Marginal rank and concurrency data for the equal-phase state of `C`. -/
  source : MarginalMomentModel 𝔽 C
  /-- Marginal rank and concurrency data for the equal-phase state of `D`. -/
  target : MarginalMomentModel 𝔽 D
  /-- The source has ten common concurrent perfect matchings. -/
  source_concurrency : commonConcurrentMatchingCount source = 10
  /-- The target has at most six common concurrent perfect matchings. -/
  target_concurrency : commonConcurrentMatchingCount target ≤ 6
  /-- LU equivalence preserves the rank-four marginal-moment
  multiplicity. -/
  lu_implies_equal_rankFourMultiplicity :
    LocallyUnitaryEquivalent (equalPhaseState C) (equalPhaseState D) →
      rankFourMultiplicity source = rankFourMultiplicity target

/-- The exact arithmetic implication used by the uniform H3-versus-GRS
separator: a `70` versus `≤ 66` rank-four marginal-moment gap rules out
local-unitary equivalence, including party permutations. -/
theorem not_locallyUnitaryEquivalent_of_ten_vs_atMostSix_concurrences
    {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]
    {C D : Submodule 𝔽 (BasisLabel 𝔽)}
    (inputs : MarginalLUSeparatorInputs 𝔽 C D) :
    ¬ LocallyUnitaryEquivalent (equalPhaseState C) (equalPhaseState D) := by
  intro hlu
  have hsource : rankFourMultiplicity inputs.source = 70 :=
    rankFourMultiplicity_eq_seventy_of_concurrency_eq_ten
      inputs.source inputs.source_concurrency
  have htarget : rankFourMultiplicity inputs.target ≤ 66 :=
    rankFourMultiplicity_le_sixtySix_of_concurrency_le_six
      inputs.target inputs.target_concurrency
  have heq := inputs.lu_implies_equal_rankFourMultiplicity hlu
  omega

end RelativeConicArcs.AMELU
