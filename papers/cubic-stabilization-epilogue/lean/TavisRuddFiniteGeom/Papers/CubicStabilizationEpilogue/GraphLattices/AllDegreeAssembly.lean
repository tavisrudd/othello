import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.DVRRankOne
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.DividedPowers
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.LocalGlobalMembership
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.FaithfullyFlatMembership
import Mathlib.Tactic

/-!
# Finite rank-one lists and all-degree assembly

This module connects the exact rank-one generation criterion to the
division-free square-zero expansion.  It extracts an actual finite list of
internal rank-one matrices from span membership, then transports that list
through an additive realization whose internal rank-one images square to
zero.  Geometry, cohomological realization, and descent are deliberately
parameters rather than hidden assertions.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

variable {Index R : Type*} [CommRing R]

/-- Scalar multiples of internal rank-one matrices are again internal
rank-one matrices. -/
theorem smul_mem_weightedRankOneSet
    (uniformizer : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (scalar : R) (form : Matrix Index Index R)
    (member : form ∈ weightedRankOneSet uniformizer diagonal cross) :
    scalar • form ∈ weightedRankOneSet uniformizer diagonal cross := by
  rcases member with ⟨coefficient, vector, equality, latticeMember⟩
  refine ⟨scalar * coefficient, vector, ?_, ?_⟩
  · rw [equality]
    ext row column
    simp [matrixRankOne]
    ring
  · exact (weightedMatrixSubmodule uniformizer diagonal cross).smul_mem
      scalar latticeMember

/-- Every element of the internal rank-one span is the sum of an actual
finite list of internal rank-one matrices. -/
theorem exists_internalRankOneList_of_mem_weightedRankOneSpan
    (uniformizer : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (form : Matrix Index Index R)
    (member : form ∈ weightedRankOneSpan uniformizer diagonal cross) :
    ∃ forms : List (Matrix Index Index R),
      (∀ candidate ∈ forms,
        candidate ∈ weightedRankOneSet uniformizer diagonal cross) ∧
      forms.sum = form := by
  change form ∈ Submodule.span R
    (weightedRankOneSet uniformizer diagonal cross) at member
  refine Submodule.span_induction (p := fun candidate _ ↦
      ∃ forms : List (Matrix Index Index R),
        (∀ entry ∈ forms,
          entry ∈ weightedRankOneSet uniformizer diagonal cross) ∧
        forms.sum = candidate) ?_ ?_ ?_ ?_ member
  · intro candidate generator
    exact ⟨[candidate], by simpa using generator, by simp⟩
  · exact ⟨[], by simp, by simp⟩
  · intro left right _ _ leftList rightList
    rcases leftList with ⟨leftForms, leftInternal, leftSum⟩
    rcases rightList with ⟨rightForms, rightInternal, rightSum⟩
    refine ⟨leftForms ++ rightForms, ?_, ?_⟩
    · intro candidate membership
      rcases List.mem_append.mp membership with inLeft | inRight
      · exact leftInternal candidate inLeft
      · exact rightInternal candidate inRight
    · simp [leftSum, rightSum]
  · intro scalar candidate _ candidateList
    rcases candidateList with ⟨forms, internal, sumEquality⟩
    refine ⟨forms.map (scalar • ·), ?_, ?_⟩
    · intro entry membership
      rcases List.mem_map.mp membership with ⟨source, sourceMember, rfl⟩
      exact smul_mem_weightedRankOneSet
        uniformizer diagonal cross scalar source (internal source sourceMember)
    · calc
        (forms.map (scalar • ·)).sum = scalar • forms.sum :=
          (List.smul_sum (r := scalar) (l := forms)).symm
        _ = scalar • candidate := congrArg (scalar • ·) sumEquality

/-- If the weighted lattice is rank-one generated and an additive realization
sends every internal rank-one matrix to a square-zero element, then every
realized lattice member has the division-free all-degree expansion attached
to a finite internal rank-one decomposition. -/
theorem allDegree_squareZeroAssembly_of_rankOneGenerated
    {Target : Type*} [CommRing Target]
    (uniformizer : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (generated : WeightedMatrixRankOneGenerated uniformizer diagonal cross)
    (realization : Matrix Index Index R →+ Target)
    (rankOneSquareZero : ∀ candidate,
      candidate ∈ weightedRankOneSet uniformizer diagonal cross →
        realization candidate * realization candidate = 0)
    (form : Matrix Index Index R)
    (member : form ∈ weightedMatrixSubmodule uniformizer diagonal cross)
    (degree : ℕ) :
    ∃ forms : List (Matrix Index Index R),
      (∀ candidate ∈ forms,
        candidate ∈ weightedRankOneSet uniformizer diagonal cross) ∧
      forms.sum = form ∧
      realization form ^ degree =
        (degree.factorial : Target) *
          squarefreeProductSum (forms.map realization) degree := by
  have spanMember : form ∈ weightedRankOneSpan uniformizer diagonal cross := by
    rw [← generated]
    exact member
  obtain ⟨forms, internal, sumEquality⟩ :=
    exists_internalRankOneList_of_mem_weightedRankOneSpan
      uniformizer diagonal cross form spanMember
  have squareZero : ∀ term ∈ forms.map realization, term * term = 0 := by
    intro term membership
    rcases List.mem_map.mp membership with ⟨candidate, candidateMember, rfl⟩
    exact rankOneSquareZero candidate (internal candidate candidateMember)
  have realizedSum : (forms.map realization).sum = realization form := by
    calc
      (forms.map realization).sum = realization forms.sum :=
        (map_list_sum realization forms).symm
      _ = realization form := congrArg realization sumEquality
  refine ⟨forms, internal, sumEquality, ?_⟩
  rw [← realizedSum]
  exact sum_pow_eq_factorial_mul_squarefreeProductSum
    (forms.map realization) squareZero degree

/-- Exact algebraic composition of rank-one assembly and prime-denominator
descent.  If every internal rank-one presentation of `form` supplies local
denominator witnesses for its squarefree degree-`degree` product, then one
such product belongs to the prescribed integral product subgroup globally,
and its factorial multiple is the realized power. -/
theorem allDegree_integralProductMember_of_primeDenominators
    {Target : Type*} [CommRing Target]
    (uniformizer : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (generated : WeightedMatrixRankOneGenerated uniformizer diagonal cross)
    (realization : Matrix Index Index R →+ Target)
    (rankOneSquareZero : ∀ candidate,
      candidate ∈ weightedRankOneSet uniformizer diagonal cross →
        realization candidate * realization candidate = 0)
    (integralProducts : AddSubgroup Target)
    (form : Matrix Index Index R)
    (member : form ∈ weightedMatrixSubmodule uniformizer diagonal cross)
    (degree : ℕ)
    (localProducts : ∀ forms : List (Matrix Index Index R),
      (∀ candidate ∈ forms,
        candidate ∈ weightedRankOneSet uniformizer diagonal cross) →
      forms.sum = form →
      ∀ p : ℕ, p.Prime →
        PrimeDenominatorMember integralProducts
          (squarefreeProductSum (forms.map realization) degree) p) :
    ∃ forms : List (Matrix Index Index R),
      (∀ candidate ∈ forms,
        candidate ∈ weightedRankOneSet uniformizer diagonal cross) ∧
      forms.sum = form ∧
      squarefreeProductSum (forms.map realization) degree ∈ integralProducts ∧
      realization form ^ degree =
        (degree.factorial : Target) *
          squarefreeProductSum (forms.map realization) degree := by
  obtain ⟨forms, internal, sumEquality, powerEquality⟩ :=
    allDegree_squareZeroAssembly_of_rankOneGenerated
      uniformizer diagonal cross generated realization rankOneSquareZero
      form member degree
  have globalMember :
      squarefreeProductSum (forms.map realization) degree ∈ integralProducts :=
    mem_of_primeDenominatorMember_all integralProducts _
      (localProducts forms internal sumEquality)
  exact ⟨forms, internal, sumEquality, globalMember, powerEquality⟩

/-- Exact algebraic composition of rank-one assembly and faithfully flat
descent through the quotient by the integral product submodule.  This is the
module-theoretic descent step used after passage to an unramified splitting
ring in the manuscript. -/
theorem allDegree_integralProductMember_of_faithfullyFlatQuotient
    {S Target : Type*} [CommRing S] [Algebra R S]
    [CommRing Target] [Module R Target] [Module.FaithfullyFlat R S]
    (uniformizer : R) (diagonal : Index → ℕ) (cross : Index → Index → ℕ)
    (generated : WeightedMatrixRankOneGenerated uniformizer diagonal cross)
    (realization : Matrix Index Index R →+ Target)
    (rankOneSquareZero : ∀ candidate,
      candidate ∈ weightedRankOneSet uniformizer diagonal cross →
        realization candidate * realization candidate = 0)
    (integralProducts : Submodule R Target)
    (form : Matrix Index Index R)
    (member : form ∈ weightedMatrixSubmodule uniformizer diagonal cross)
    (degree : ℕ)
    (extendedProducts : ∀ forms : List (Matrix Index Index R),
      (∀ candidate ∈ forms,
        candidate ∈ weightedRankOneSet uniformizer diagonal cross) →
      forms.sum = form →
      TensorProduct.mk R S (Target ⧸ integralProducts) 1
        (Submodule.Quotient.mk
          (squarefreeProductSum (forms.map realization) degree)) = 0) :
    ∃ forms : List (Matrix Index Index R),
      (∀ candidate ∈ forms,
        candidate ∈ weightedRankOneSet uniformizer diagonal cross) ∧
      forms.sum = form ∧
      squarefreeProductSum (forms.map realization) degree ∈ integralProducts ∧
      realization form ^ degree =
        (degree.factorial : Target) *
          squarefreeProductSum (forms.map realization) degree := by
  obtain ⟨forms, internal, sumEquality, powerEquality⟩ :=
    allDegree_squareZeroAssembly_of_rankOneGenerated
      uniformizer diagonal cross generated realization rankOneSquareZero
      form member degree
  have globalMember :
      squarefreeProductSum (forms.map realization) degree ∈ integralProducts :=
    mem_submodule_of_faithfullyFlat_tensor_quotient_zero integralProducts _
      (extendedProducts forms internal sumEquality)
  exact ⟨forms, internal, sumEquality, globalMember, powerEquality⟩

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
