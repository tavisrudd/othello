import RelativeConicArcs.ClebschArithmeticGluingData
import RelativeConicArcs.ClebschInvariantMatchingCriterion

/-!
# The two cardinality-eleven invariant matchings

For each projective endpoint, this module selects one explicit matrix in the
corresponding sixty-row stabilizer table.  The selected matrix fixes exactly
that endpoint and its displayed matching partner.  Hence any fixed-point-free
partner map equivariant for the whole table must choose the displayed partner.

The two twelve-row witness families are small certificates, not matching
censuses.  Lean checks matrix membership and the two-point fixed sets by
kernel reduction.  Identifying the sixty-row tables with abstract
icosahedral subgroups remains outside these statements.
-/

namespace RelativeConicArcs.ClebschH3InvariantMatchings

open ClebschArithmeticGluing
open ClebschInvariantMatchingCriterion

set_option maxRecDepth 100000
set_option maxHeartbeats 2000000

/-- The literal sixty-row table attached to the first displayed matching. -/
def baseStabilizerRows : Finset (ProjectiveMatrix 11) :=
  h3BaseStabilizerCertificate.toFinset

/-- The literal sixty-row table attached to the second displayed matching. -/
def conjugateStabilizerRows : Finset (ProjectiveMatrix 11) :=
  h3ConjugateStabilizerCertificate.toFinset

/-- One matrix in the first stabilizer table for each endpoint.  Its fixed
points are that endpoint and its first displayed partner. -/
def basePointStabilizerWitness : ProjectivePoint 11 → ProjectiveMatrix 11
  | none => projectiveMatrix 1 3 0 9
  | some x => (![projectiveMatrix 1 0 3 9, projectiveMatrix 1 0 3 9,
      projectiveMatrix 1 1 1 5, projectiveMatrix 1 1 1 2,
      projectiveMatrix 0 1 7 8, projectiveMatrix 1 1 1 5,
      projectiveMatrix 0 1 8 9, projectiveMatrix 1 1 1 2,
      projectiveMatrix 0 1 8 9, projectiveMatrix 0 1 7 8,
      projectiveMatrix 1 3 0 9] : Fin 11 → ProjectiveMatrix 11) x

/-- One matrix in the second stabilizer table for each endpoint.  Its fixed
points are that endpoint and its second displayed partner. -/
def conjugatePointStabilizerWitness : ProjectivePoint 11 → ProjectiveMatrix 11
  | none => projectiveMatrix 1 2 0 3
  | some x => (![projectiveMatrix 1 0 2 3, projectiveMatrix 1 2 0 3,
      projectiveMatrix 0 1 7 3, projectiveMatrix 0 1 8 2,
      projectiveMatrix 1 4 4 8, projectiveMatrix 0 1 8 2,
      projectiveMatrix 1 7 7 6, projectiveMatrix 0 1 7 3,
      projectiveMatrix 1 4 4 8, projectiveMatrix 1 7 7 6,
      projectiveMatrix 1 0 2 3] : Fin 11 → ProjectiveMatrix 11) x

/-- Every first-family witness belongs to the first stabilizer table. -/
theorem basePointStabilizerWitness_mem (x : ProjectivePoint 11) :
    basePointStabilizerWitness x ∈ baseStabilizerRows := by
  fin_cases x <;> decide

/-- Every second-family witness belongs to the second stabilizer table. -/
theorem conjugatePointStabilizerWitness_mem (x : ProjectivePoint 11) :
    conjugatePointStabilizerWitness x ∈ conjugateStabilizerRows := by
  fin_cases x <;> decide

/-- The fixed set of a first-family witness is exactly an endpoint and its
displayed partner. -/
theorem basePointStabilizerWitness_fixed_iff (x y : ProjectivePoint 11) :
    projectiveAction (basePointStabilizerWitness x) y = y ↔
      y = x ∨ y = matchingMate h3BaseMatchingEdges x := by
  fin_cases x <;> fin_cases y <;> decide

/-- The fixed set of a second-family witness is exactly an endpoint and its
displayed partner. -/
theorem conjugatePointStabilizerWitness_fixed_iff (x y : ProjectivePoint 11) :
    projectiveAction (conjugatePointStabilizerWitness x) y = y ↔
      y = x ∨ y = matchingMate h3ConjugateMatchingEdges x := by
  fin_cases x <;> fin_cases y <;> decide

/-- A row of the first stabilizer table together with its membership proof. -/
abbrev BaseStabilizerRow := {g // g ∈ baseStabilizerRows}

/-- A row of the second stabilizer table together with its membership proof. -/
abbrev ConjugateStabilizerRow := {g // g ∈ conjugateStabilizerRows}

/-- Each endpoint stabilizer in the first table forces the displayed
partner. -/
theorem base_pointStabilizers_force_partner :
    PointStabilizersForcePartner (fun g : BaseStabilizerRow ↦ g.1) projectiveAction
      (matchingMate h3BaseMatchingEdges) := by
  intro x y hne hfixed
  have hwitness := hfixed
    ⟨basePointStabilizerWitness x, basePointStabilizerWitness_mem x⟩
    ((basePointStabilizerWitness_fixed_iff x x).2 (Or.inl rfl))
  exact ((basePointStabilizerWitness_fixed_iff x y).1 hwitness).resolve_left hne

/-- Each endpoint stabilizer in the second table forces the displayed
partner. -/
theorem conjugate_pointStabilizers_force_partner :
    PointStabilizersForcePartner (fun g : ConjugateStabilizerRow ↦ g.1)
      projectiveAction (matchingMate h3ConjugateMatchingEdges) := by
  intro x y hne hfixed
  have hwitness := hfixed
    ⟨conjugatePointStabilizerWitness x, conjugatePointStabilizerWitness_mem x⟩
    ((conjugatePointStabilizerWitness_fixed_iff x x).2 (Or.inl rfl))
  exact ((conjugatePointStabilizerWitness_fixed_iff x y).1 hwitness).resolve_left hne

/-- Every fixed-point-free partner map equivariant for the first table is
the first displayed matching. -/
theorem base_invariantMatching_eq
    (m : ProjectivePoint 11 → ProjectivePoint 11)
    (hfree : ∀ x, m x ≠ x)
    (hequivariant : ∀ g ∈ baseStabilizerRows, ∀ x,
      projectiveAction g (m x) = m (projectiveAction g x)) :
    m = matchingMate h3BaseMatchingEdges :=
  equivariant_fixedPointFree_eq_of_pointStabilizersForcePartner
    base_pointStabilizers_force_partner hfree
      (fun g x ↦ hequivariant g.1 g.2 x)

/-- Every fixed-point-free partner map equivariant for the second table is
the second displayed matching. -/
theorem conjugate_invariantMatching_eq
    (m : ProjectivePoint 11 → ProjectivePoint 11)
    (hfree : ∀ x, m x ≠ x)
    (hequivariant : ∀ g ∈ conjugateStabilizerRows, ∀ x,
      projectiveAction g (m x) = m (projectiveAction g x)) :
    m = matchingMate h3ConjugateMatchingEdges :=
  equivariant_fixedPointFree_eq_of_pointStabilizersForcePartner
    conjugate_pointStabilizers_force_partner hfree
      (fun g x ↦ hequivariant g.1 g.2 x)

end RelativeConicArcs.ClebschH3InvariantMatchings
