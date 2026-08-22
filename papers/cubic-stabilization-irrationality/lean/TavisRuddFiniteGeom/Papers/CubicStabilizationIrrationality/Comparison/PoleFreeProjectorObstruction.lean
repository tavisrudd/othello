import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorDecomposition

/-!
# Algebraic vectors in a proper formal summand

Let an algebraic module map into a larger module carrying an idempotent
projector.  The algebraic vectors fixed by the projector form a submodule by
pullback.  If connection stability makes that submodule subject to an
irreducibility theorem, it is either zero or the whole algebraic module.
Properness of the projector on the included algebraic module excludes the
second case.  No scalar row can therefore detect a fixed algebraic vector.

This is linear algebra relative to an abstract stability predicate.  The file
derives connection stability from horizontal inclusion and projector maps.
Applying it to a differential module still requires those horizontal maps,
irreducibility of the algebraic module, and properness of the formal projector
on the included module.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.PoleFreeProjectorObstruction

open RowedProjectorDecomposition

universe uK uV uW uA

variable
    (K : Type uK) [CommRing K]
    (V : Type uV) [AddCommGroup V] [Module K V]
    (W : Type uW) [AddCommGroup W] [Module K W]
    (A : Type uA) [AddCommGroup A] [Module K A]

/-- Algebraic vectors whose images are fixed by a projector on a larger
module. -/
def pullbackFixedSubmodule
    (inclusion : V →ₗ[K] W) (projector : Projector K W) : Submodule K V :=
  (projector.map - LinearMap.id).ker.comap inclusion

/-- Membership in the pullback fixed submodule is the expected projector
equation. -/
theorem mem_pullbackFixedSubmodule_iff
    (inclusion : V →ₗ[K] W) (projector : Projector K W) (x : V) :
    x ∈ pullbackFixedSubmodule K V W inclusion projector ↔
      projector.map (inclusion x) = inclusion x := by
  simp [pullbackFixedSubmodule, sub_eq_zero]

/-- A row detects the part of the larger projector which is represented by an
algebraic vector from the included module. -/
def DetectsOnIncludedModule
    (inclusion : V →ₗ[K] W) (row : W →ₗ[K] A)
    (projector : Projector K W) : Prop :=
  ∃ x : V, projector.map (inclusion x) = inclusion x ∧ row (inclusion x) ≠ 0

/-- If the pullback fixed submodule is either zero or the whole carrier and
the projector is not the identity on the included module, no row detects an
included fixed vector. -/
theorem not_detectsOnIncludedModule_of_fixedSubmodule_trivial
    (inclusion : V →ₗ[K] W) (row : W →ₗ[K] A)
    (projector : Projector K W)
    (fixedSubmoduleTrivial :
      pullbackFixedSubmodule K V W inclusion projector = ⊥ ∨
        pullbackFixedSubmodule K V W inclusion projector = ⊤)
    (properOnIncludedModule :
      ∃ y : V, projector.map (inclusion y) ≠ inclusion y) :
    ¬ DetectsOnIncludedModule K V W A inclusion row projector := by
  rintro ⟨x, fixed, visible⟩
  have xMem : x ∈ pullbackFixedSubmodule K V W inclusion projector :=
    (mem_pullbackFixedSubmodule_iff K V W inclusion projector x).2 fixed
  rcases fixedSubmoduleTrivial with fixedBottom | fixedTop
  · have xZero : x = 0 := by
      rw [fixedBottom] at xMem
      simpa using xMem
    subst x
    simp at visible
  · rcases properOnIncludedModule with ⟨y, notFixed⟩
    have yMem : y ∈ pullbackFixedSubmodule K V W inclusion projector := by
      rw [fixedTop]
      exact Submodule.mem_top
    exact notFixed <|
      (mem_pullbackFixedSubmodule_iff K V W inclusion projector y).1 yMem

/-- An abstract irreducibility hypothesis relative to a specified notion of
connection-stable submodule. -/
def IrreducibleFor
    (stable : Submodule K V → Prop) : Prop :=
  ∀ submodule : Submodule K V, stable submodule → submodule = ⊥ ∨ submodule = ⊤

/-- A submodule is invariant under a family of connection operators.  The
operators need not be linear; this accommodates the Leibniz rule of a
differential-module connection. -/
def InvariantUnder
    {I : Type*} (connection : I → V → V) (submodule : Submodule K V) : Prop :=
  ∀ i x, x ∈ submodule → connection i x ∈ submodule

/-- Horizontal inclusion and horizontal projector make the algebraic
pullback of the formal fixed summand invariant under the connection. -/
theorem pullbackFixedSubmodule_invariantUnder
    {I : Type*}
    (inclusion : V →ₗ[K] W) (projector : Projector K W)
    (connectionV : I → V → V) (connectionW : I → W → W)
    (inclusionHorizontal : ∀ i x,
      inclusion (connectionV i x) = connectionW i (inclusion x))
    (projectorHorizontal : ∀ i x,
      projector.map (connectionW i x) = connectionW i (projector.map x)) :
    InvariantUnder K V connectionV
      (pullbackFixedSubmodule K V W inclusion projector) := by
  intro i x xMem
  apply (mem_pullbackFixedSubmodule_iff K V W inclusion projector _).2
  rw [inclusionHorizontal, projectorHorizontal]
  rw [(mem_pullbackFixedSubmodule_iff K V W inclusion projector x).1 xMem]

/-- A connection-stable proper formal summand cannot contain a row-visible
algebraic vector when the algebraic differential module is irreducible. -/
theorem not_detectsOnIncludedModule_of_irreducible
    (inclusion : V →ₗ[K] W) (row : W →ₗ[K] A)
    (projector : Projector K W)
    (stable : Submodule K V → Prop)
    (irreducible : IrreducibleFor K V stable)
    (fixedStable : stable (pullbackFixedSubmodule K V W inclusion projector))
    (properOnIncludedModule :
      ∃ y : V, projector.map (inclusion y) ≠ inclusion y) :
    ¬ DetectsOnIncludedModule K V W A inclusion row projector :=
  not_detectsOnIncludedModule_of_fixedSubmodule_trivial K V W A
    inclusion row projector
    (irreducible (pullbackFixedSubmodule K V W inclusion projector) fixedStable)
    properOnIncludedModule

/-- For horizontal data, irreducibility and properness force the algebraic
pullback of the formal fixed summand to be zero. -/
theorem pullbackFixedSubmodule_eq_bot_of_horizontal_irreducible
    {I : Type*}
    (inclusion : V →ₗ[K] W) (projector : Projector K W)
    (connectionV : I → V → V) (connectionW : I → W → W)
    (inclusionHorizontal : ∀ i x,
      inclusion (connectionV i x) = connectionW i (inclusion x))
    (projectorHorizontal : ∀ i x,
      projector.map (connectionW i x) = connectionW i (projector.map x))
    (irreducible : IrreducibleFor K V (InvariantUnder K V connectionV))
    (properOnIncludedModule :
      ∃ y : V, projector.map (inclusion y) ≠ inclusion y) :
    pullbackFixedSubmodule K V W inclusion projector = ⊥ := by
  rcases irreducible (pullbackFixedSubmodule K V W inclusion projector)
      (pullbackFixedSubmodule_invariantUnder K V W inclusion projector
        connectionV connectionW inclusionHorizontal projectorHorizontal) with
    fixedBottom | fixedTop
  · exact fixedBottom
  · rcases properOnIncludedModule with ⟨y, notFixed⟩
    exfalso
    apply notFixed
    apply (mem_pullbackFixedSubmodule_iff K V W inclusion projector y).1
    rw [fixedTop]
    exact Submodule.mem_top

/-- A horizontal proper formal summand has no row-visible algebraic vector
when the algebraic differential module has no nontrivial invariant
submodule. -/
theorem not_detectsOnIncludedModule_of_horizontal_irreducible
    {I : Type*}
    (inclusion : V →ₗ[K] W) (row : W →ₗ[K] A)
    (projector : Projector K W)
    (connectionV : I → V → V) (connectionW : I → W → W)
    (inclusionHorizontal : ∀ i x,
      inclusion (connectionV i x) = connectionW i (inclusion x))
    (projectorHorizontal : ∀ i x,
      projector.map (connectionW i x) = connectionW i (projector.map x))
    (irreducible : IrreducibleFor K V (InvariantUnder K V connectionV))
    (properOnIncludedModule :
      ∃ y : V, projector.map (inclusion y) ≠ inclusion y) :
    ¬ DetectsOnIncludedModule K V W A inclusion row projector :=
  not_detectsOnIncludedModule_of_fixedSubmodule_trivial K V W A
    inclusion row projector
    (Or.inl <| pullbackFixedSubmodule_eq_bot_of_horizontal_irreducible K V W
      inclusion projector connectionV connectionW inclusionHorizontal
      projectorHorizontal irreducible properOnIncludedModule)
    properOnIncludedModule

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.PoleFreeProjectorObstruction
