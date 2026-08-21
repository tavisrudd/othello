import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.MarkedLocalSystem
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.PointedDirectSum

/-!
# Rowed decompositions of marked monodromy representations

A direct-sum comparison can preserve a distinguished scalar row without
selecting a vector which represents that row through a pairing.  This module
combines that row-only comparison with one based-loop representation.  The
comparison is required to intertwine every loop before any incoming or target
loop is selected.

Consequently all directed diagrams selected from one endpoint-to-loop
assignment use the same comparison map and the same row equation.  This is an
algebraic coherence interface: constructing the representations and the path
interpretation from a quantum connection remains an external input.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedRepresentationDecomposition

open MarkedLocalSystem
open MarkedMonodromyDiagram
open PointedDirectSum

universe uR uLoop uV uW uC uIndex

variable
    (R : Type uR) [CommRing R]
    (Loop : Type uLoop) [Group Loop]
    (V : Type uV) (W : Type uW) (C : Type uC)
    [AddCommGroup V] [Module R V]
    [AddCommGroup W] [Module R W]
    [AddCommGroup C] [Module R C]

/-- A rowed direct-sum decomposition natural for one whole based-loop
representation.  The source and ambient scalar rows belong to the two named
representations; the correction factor carries monodromy but no marked row. -/
structure Data
    (source : MarkedLocalSystem.Representation R Loop V)
    (ambient : MarkedLocalSystem.Representation R Loop W) where
  comparison : V ≃ₗ[R] W × C
  correctionMonodromy : Loop →* (C ≃ₗ[R] C)
  scale : Rˣ
  rowComparison : ∀ x,
    source.row x = (scale : R) * ambient.row (comparison x).1
  monodromyComparison : ∀ loop x,
    comparison (source.monodromy loop x) =
      (ambient.monodromy loop (comparison x).1,
        correctionMonodromy loop (comparison x).2)

namespace Data

variable
    {R Loop V W C}
    {source : MarkedLocalSystem.Representation R Loop V}
    {ambient : MarkedLocalSystem.Representation R Loop W}

/-- Forget whole-loop naturality while retaining the row-only direct-sum
comparison consumed by the Boolean row argument. -/
def toRowedComparison
    (data : Data R Loop V W C source ambient) :
    TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.PointedDirectSum.RowedComparison
      R V W C where
  comparison := data.comparison
  sourceRow := source.row
  ambientRow := ambient.row
  scale := data.scale
  rowComparison := data.rowComparison

/-- The direct-sum monodromy representation induced by the ambient and
correction representations.  Its marked row ignores the correction factor
and includes the same unit normalization as the source row. -/
def targetRepresentation
    (data : Data R Loop V W C source ambient) :
    MarkedLocalSystem.Representation R Loop (W × C) where
  monodromy :=
    { toFun := fun loop =>
        LinearEquiv.prodCongr (ambient.monodromy loop)
          (data.correctionMonodromy loop)
      map_one' := by
        ext <;> simp
      map_mul' := by
        intro first second
        ext <;> simp }
  row := data.scale • (ambient.row.comp (LinearMap.fst R W C))

/-- Whole-loop naturality descends to an exact marked equivalence for every
pair of loops selected from one endpoint assignment. -/
def selectedDiagramEquivalence
    (data : Data R Loop V W C source ambient)
    {Index : Type uIndex} (assignment : LoopAssignment Index Loop)
    (sourceIndex targetIndex : Index) :
    DiagramEquivalence R
      (source.select sourceIndex targetIndex
        (assignment.loop sourceIndex) (assignment.loop targetIndex))
      (data.targetRepresentation.select sourceIndex targetIndex
        (assignment.loop sourceIndex) (assignment.loop targetIndex)) where
  map := data.comparison
  naturality := by
    intro selectedLoop x
    cases selectedLoop with
    | incoming => exact data.monodromyComparison (assignment.loop sourceIndex) x
    | target => exact data.monodromyComparison (assignment.loop targetIndex) x
  rowNaturality := by
    intro x
    change data.targetRepresentation.row (data.comparison x) = source.row x
    change (data.scale : R) * ambient.row (data.comparison x).1 = source.row x
    exact (data.rowComparison x).symm

/-- Ambient projection intertwines every based-loop operator.  Thus a
projector formed functorially from an assigned loop cannot silently change
which loop it uses when passing through the direct-sum comparison. -/
theorem ambientProjection_monodromy
    (data : Data R Loop V W C source ambient)
    (loop : Loop) (x : V) :
    data.toRowedComparison.ambientProjection (source.monodromy loop x) =
      ambient.monodromy loop (data.toRowedComparison.ambientProjection x) := by
  have naturality := data.monodromyComparison loop x
  exact congrArg Prod.fst naturality

/-- Ambient projection intertwines every forward iterate of one selected
based-loop operator. -/
theorem ambientProjection_monodromy_iterate
    (data : Data R Loop V W C source ambient)
    (loop : Loop) (n : ℕ) (x : V) :
    data.toRowedComparison.ambientProjection
        (((source.monodromy loop : V → V)^[n]) x) =
      ((ambient.monodromy loop : W → W)^[n])
        (data.toRowedComparison.ambientProjection x) := by
  induction n generalizing x with
  | zero => rfl
  | succ n inductionHypothesis =>
      rw [Function.iterate_succ_apply, Function.iterate_succ_apply]
      rw [inductionHypothesis, data.ambientProjection_monodromy]

/-- Ambient inclusion intertwines every based-loop operator. -/
theorem ambientInclusion_monodromy
    (data : Data R Loop V W C source ambient)
    (loop : Loop) (x : W) :
    source.monodromy loop (data.toRowedComparison.ambientInclusion x) =
      data.toRowedComparison.ambientInclusion (ambient.monodromy loop x) := by
  apply data.comparison.injective
  rw [data.monodromyComparison]
  simp [toRowedComparison, PointedDirectSum.RowedComparison.ambientInclusion]

/-- The generalized-eigenvector predicate for one invertible operator.  The
integer `n` is the nilpotence exponent used to present a primary block. -/
def IsGeneralizedEigenvector
    {M : Type*} [AddCommGroup M] [Module R M]
    (monodromy : M ≃ₗ[R] M) (eigenvalue : R) (n : ℕ) (x : M) : Prop :=
  (((fun y => monodromy y - eigenvalue • y)^[n]) x) = 0

/-- Ambient projection intertwines the shifted operator used to present a
generalized eigenspace. -/
theorem ambientProjection_shiftedMonodromy
    (data : Data R Loop V W C source ambient)
    (loop : Loop) (eigenvalue : R) (x : V) :
    data.toRowedComparison.ambientProjection
        (source.monodromy loop x - eigenvalue • x) =
      ambient.monodromy loop (data.toRowedComparison.ambientProjection x) -
        eigenvalue • data.toRowedComparison.ambientProjection x := by
  rw [map_sub, map_smul, data.ambientProjection_monodromy]

/-- Ambient inclusion intertwines the shifted operator used to present a
generalized eigenspace. -/
theorem ambientInclusion_shiftedMonodromy
    (data : Data R Loop V W C source ambient)
    (loop : Loop) (eigenvalue : R) (x : W) :
    data.toRowedComparison.ambientInclusion
        (ambient.monodromy loop x - eigenvalue • x) =
      source.monodromy loop (data.toRowedComparison.ambientInclusion x) -
        eigenvalue • data.toRowedComparison.ambientInclusion x := by
  rw [map_sub, map_smul, data.ambientInclusion_monodromy]

/-- Ambient projection carries generalized eigenvectors for a selected loop
to generalized eigenvectors with the same eigenvalue and exponent. -/
theorem ambientProjection_isGeneralizedEigenvector
    (data : Data R Loop V W C source ambient)
    (loop : Loop) (eigenvalue : R) (n : ℕ) (x : V)
    (primary : IsGeneralizedEigenvector (source.monodromy loop) eigenvalue n x) :
    IsGeneralizedEigenvector (ambient.monodromy loop) eigenvalue n
      (data.toRowedComparison.ambientProjection x) := by
  unfold IsGeneralizedEigenvector at primary ⊢
  induction n generalizing x with
  | zero =>
      simpa using congrArg
        (fun y => data.toRowedComparison.ambientProjection y) primary
  | succ n inductionHypothesis =>
      rw [Function.iterate_succ_apply] at primary ⊢
      rw [← data.ambientProjection_shiftedMonodromy]
      exact inductionHypothesis
        (source.monodromy loop x - eigenvalue • x) primary

/-- Ambient inclusion carries generalized eigenvectors for a selected loop
to generalized eigenvectors with the same eigenvalue and exponent. -/
theorem ambientInclusion_isGeneralizedEigenvector
    (data : Data R Loop V W C source ambient)
    (loop : Loop) (eigenvalue : R) (n : ℕ) (x : W)
    (primary : IsGeneralizedEigenvector (ambient.monodromy loop) eigenvalue n x) :
    IsGeneralizedEigenvector (source.monodromy loop) eigenvalue n
      (data.toRowedComparison.ambientInclusion x) := by
  unfold IsGeneralizedEigenvector at primary ⊢
  induction n generalizing x with
  | zero =>
      simpa using congrArg
        (fun y => data.toRowedComparison.ambientInclusion y) primary
  | succ n inductionHypothesis =>
      rw [Function.iterate_succ_apply] at primary ⊢
      rw [← data.ambientInclusion_shiftedMonodromy]
      exact inductionHypothesis
        (ambient.monodromy loop x - eigenvalue • x) primary

/-- A marked row detects a generalized eigenspace when it is nonzero on at
least one generalized eigenvector with the specified exponent. -/
def DetectsGeneralizedEigenspace
    {M : Type*} [AddCommGroup M] [Module R M]
    (row : M →ₗ[R] R) (monodromy : M ≃ₗ[R] M)
    (eigenvalue : R) (n : ℕ) : Prop :=
  ∃ x, IsGeneralizedEigenvector monodromy eigenvalue n x ∧ row x ≠ 0

/-- A whole-loop-natural rowed direct sum preserves, in both directions, the
Boolean detected support of every generalized eigenspace.  Correction
summands may contain the same eigenvalue; the proof uses only row
factorization through ambient projection. -/
theorem detectsGeneralizedEigenspace_iff
    (data : Data R Loop V W C source ambient)
    (loop : Loop) (eigenvalue : R) (n : ℕ) :
    DetectsGeneralizedEigenspace source.row (source.monodromy loop) eigenvalue n ↔
      DetectsGeneralizedEigenspace ambient.row (ambient.monodromy loop) eigenvalue n := by
  constructor
  · rintro ⟨x, primary, rowNonzero⟩
    exact ⟨data.toRowedComparison.ambientProjection x,
      data.ambientProjection_isGeneralizedEigenvector loop eigenvalue n x primary,
      data.toRowedComparison.ambientRow_projection_ne_zero rowNonzero⟩
  · rintro ⟨x, primary, rowNonzero⟩
    refine ⟨data.toRowedComparison.ambientInclusion x,
      data.ambientInclusion_isGeneralizedEigenvector loop eigenvalue n x primary, ?_⟩
    intro sourceVanishes
    have ambientVanishes :=
      (data.toRowedComparison.sourceRow_eq_zero_iff_ambientRow_projection_eq_zero
        (data.toRowedComparison.ambientInclusion x)).mp sourceVanishes
    apply rowNonzero
    simpa [toRowedComparison, PointedDirectSum.RowedComparison.ambientProjection,
      PointedDirectSum.RowedComparison.ambientInclusion] using ambientVanishes

end Data

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedRepresentationDecomposition
