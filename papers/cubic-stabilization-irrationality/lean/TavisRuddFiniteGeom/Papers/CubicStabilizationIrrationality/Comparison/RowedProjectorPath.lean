import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorDecomposition

/-!
# Paths of rowed marked-projector decompositions

An edgewise rowed-projector comparison does not by itself identify the two
copies of an intermediate variety used by consecutive edges.  This module
removes that freedom by assigning one carrier, row, and marked projector to
every vertex.  Each edge is indexed by the exact source and target values of
that family, so adjacent edges share their intermediate datum by construction.
An oriented step may follow such an edge or traverse it in reverse.

The terminal theorem transports row-visible marked support along a finite
path.  Constructing this vertex family from native quantum modules over one
common coefficient base, or proving that every edge occurrence is a faithful
pullback of it, remains an external geometric hypothesis.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorPath

open RowedProjectorDecomposition

universe uR uA uVertex uCarrier

/-- One native rowed marked-projector datum attached to a path vertex. -/
structure VertexDatum
    (R : Type uR) [CommRing R]
    (A : Type uA) [AddCommGroup A] [Module R A] where
  Carrier : Type uCarrier
  [carrierAddCommGroup : AddCommGroup Carrier]
  [carrierModule : Module R Carrier]
  row : Carrier →ₗ[R] A
  projector : Projector R Carrier

attribute [instance] VertexDatum.carrierAddCommGroup
attribute [instance] VertexDatum.carrierModule

/-- A rowed direct-sum edge between two fixed values of a vertex family.
Only the correction module and its marked projector are edge-local. -/
structure Edge
    {R : Type uR} [CommRing R]
    {A : Type uA} [AddCommGroup A] [Module R A]
    {Vertex : Type uVertex}
    (system : Vertex → VertexDatum.{uR, uA, uCarrier} R A)
    (source target : Vertex) where
  Correction : Type uCarrier
  [correctionAddCommGroup : AddCommGroup Correction]
  [correctionModule : Module R Correction]
  correctionProjector : Projector R Correction
  comparison : (system source).Carrier ≃ₗ[R]
    (system target).Carrier × Correction
  rowScale : Rˣ
  rowComparison : ∀ x,
    (system source).row x =
      (rowScale : R) • (system target).row (comparison x).1
  projectorComparison : ∀ x,
    comparison ((system source).projector.map x) =
      ((system target).projector.map (comparison x).1,
        correctionProjector.map (comparison x).2)

attribute [instance] Edge.correctionAddCommGroup
attribute [instance] Edge.correctionModule

namespace Edge

variable
    {R : Type uR} [CommRing R]
    {A : Type uA} [AddCommGroup A] [Module R A]
    {Vertex : Type uVertex}
    (system : Vertex → VertexDatum.{uR, uA, uCarrier} R A)

/-- Forgetting the vertex indices gives the one-edge consumer datum. -/
def toUnitScaledData
    {source target : Vertex}
    (edge : Edge system source target) :
    UnitScaledData R A (system source).Carrier
      (system target).Carrier edge.Correction where
  sourceProjector := (system source).projector
  ambientProjector := (system target).projector
  correctionProjector := edge.correctionProjector
  comparison := edge.comparison
  sourceRow := (system source).row
  ambientRow := (system target).row
  rowScale := edge.rowScale
  rowComparison := edge.rowComparison
  projectorComparison := edge.projectorComparison

end Edge

/-- An oriented traversal of a rowed direct-sum edge.  A forward step follows
the direct-sum comparison from its source to its ambient factor; a reverse
step traverses the same comparison in the opposite direction. -/
inductive Step
    {R : Type uR} [CommRing R]
    {A : Type uA} [AddCommGroup A] [Module R A]
    {Vertex : Type uVertex}
    (system : Vertex → VertexDatum.{uR, uA, uCarrier} R A) :
    Vertex → Vertex → Type (max (uCarrier + 1) (max uVertex (max uA uR)))
  | forward {source target : Vertex} :
      Edge system source target → Step system source target
  | reverse {source target : Vertex} :
      Edge system target source → Step system source target

/-- A finite oriented path whose adjacent steps use definitionally the same
native carrier, row, and marked projector at their shared vertex. -/
inductive Path
    {R : Type uR} [CommRing R]
    {A : Type uA} [AddCommGroup A] [Module R A]
    {Vertex : Type uVertex}
    (system : Vertex → VertexDatum.{uR, uA, uCarrier} R A) :
    Vertex → Vertex → Type (max (uCarrier + 1) (max uVertex (max uA uR)))
  | nil (vertex : Vertex) : Path system vertex vertex
  | cons {source middle target : Vertex}
      (step : Step system source middle)
      (tail : Path system middle target) : Path system source target

variable
    {R : Type uR} [CommRing R]
    {A : Type uA} [AddCommGroup A] [Module R A]
    {Vertex : Type uVertex}
    (system : Vertex → VertexDatum.{uR, uA, uCarrier} R A)

/-- Row-visible marked support at one native vertex. -/
def DetectsAt (vertex : Vertex) : Prop :=
  Detects R A (system vertex).row (system vertex).projector

/-- One typed edge preserves row-visible marked support. -/
theorem Edge.detectsAt_iff
    {source target : Vertex}
    (edge : Edge system source target) :
    DetectsAt system source ↔ DetectsAt system target :=
  edge.toUnitScaledData system |>.detects_iff

/-- Either orientation of one typed direct-sum edge preserves row-visible
marked support. -/
theorem Step.detectsAt_iff
    {source target : Vertex}
    (step : Step system source target) :
    DetectsAt system source ↔ DetectsAt system target := by
  cases step with
  | forward edge => exact edge.detectsAt_iff system
  | reverse edge => exact (edge.detectsAt_iff system).symm

/-- Row-visible marked support is constant along a typed finite path. -/
theorem Path.detectsAt_iff
    {source target : Vertex}
    (path : Path system source target) :
    DetectsAt system source ↔ DetectsAt system target := by
  induction path with
  | nil => exact Iff.rfl
  | cons step tail inductionHypothesis =>
      exact (step.detectsAt_iff system).trans inductionHypothesis

/-- A detected source cannot be joined by a typed path to a vertex whose
native marked projector is zero. -/
theorem Path.false_of_source_detects_of_target_projector_zero
    {source target : Vertex}
    (path : Path system source target)
    (sourceDetects : DetectsAt system source)
    (targetProjectorZero :
      (system target).projector = Projector.zero) : False := by
  have targetDetects := (path.detectsAt_iff system).mp sourceDetects
  change Detects R A (system target).row (system target).projector at targetDetects
  rw [targetProjectorZero] at targetDetects
  exact not_detects_zero R A (system target).row targetDetects

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorPath
