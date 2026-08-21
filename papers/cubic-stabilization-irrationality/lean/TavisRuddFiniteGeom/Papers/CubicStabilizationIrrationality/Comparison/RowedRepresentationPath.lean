import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedRepresentationDecomposition

/-!
# Paths of rowed monodromy decompositions

An edgewise direct-sum theorem does not by itself identify the two copies of
an intermediate object used by consecutive edges.  This module removes that
freedom by assigning one marked loop representation to every vertex.  Each
edge is then indexed by the exact source and target values of that family.
Consequently consecutive edges share their intermediate carrier, monodromy,
and scalar row by construction.

The terminal theorem composes the edgewise preservation of row-detected
generalized eigenspaces along a finite directed path.  Constructing the
vertex family from quantum connections over one common coefficient base is
an external hypothesis; in particular, the type does not identify completed
germs based at different parameter values.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedRepresentationPath

open MarkedLocalSystem
open RowedRepresentationDecomposition
open RowedRepresentationDecomposition.Data

universe uR uLoop uVertex uCarrier

/-- A module together with one marked representation of a fixed based-loop
group.  Bundling the carrier and its representation makes a vertex value a
single object rather than a name attached to independently chosen data. -/
structure VertexRepresentation
    (R : Type uR) [CommRing R]
    (Loop : Type uLoop) [Group Loop] where
  Carrier : Type uCarrier
  [carrierAddCommGroup : AddCommGroup Carrier]
  [carrierModule : Module R Carrier]
  marked : MarkedLocalSystem.Representation R Loop Carrier

attribute [instance] VertexRepresentation.carrierAddCommGroup
attribute [instance] VertexRepresentation.carrierModule

/-- A rowed direct-sum edge between two fixed values of a vertex family.  The
correction representation is local to the edge, while both endpoint marked
representations are definitionally the values selected by the endpoint
indices. -/
structure Edge
    {R : Type uR} [CommRing R]
    {Loop : Type uLoop} [Group Loop]
    {Vertex : Type uVertex}
    (system : Vertex → VertexRepresentation.{uR, uLoop, uCarrier} R Loop)
    (source target : Vertex) where
  Correction : Type uCarrier
  [correctionAddCommGroup : AddCommGroup Correction]
  [correctionModule : Module R Correction]
  decomposition :
    RowedRepresentationDecomposition.Data R Loop
      (system source).Carrier (system target).Carrier Correction
      (system source).marked (system target).marked

attribute [instance] Edge.correctionAddCommGroup
attribute [instance] Edge.correctionModule

/-- A finite directed path whose adjacent edges use definitionally the same
marked representation at their shared vertex. -/
inductive Path
    {R : Type uR} [CommRing R]
    {Loop : Type uLoop} [Group Loop]
    {Vertex : Type uVertex}
    (system : Vertex → VertexRepresentation.{uR, uLoop, uCarrier} R Loop) :
    Vertex → Vertex →
      Type (max (uCarrier + 1) (max uVertex (max uLoop uR)))
  | nil (vertex : Vertex) : Path system vertex vertex
  | cons {source middle target : Vertex}
      (edge : Edge system source middle)
      (tail : Path system middle target) : Path system source target

variable
    {R : Type uR} [CommRing R]
    {Loop : Type uLoop} [Group Loop]
    {Vertex : Type uVertex}
    (system : Vertex → VertexRepresentation.{uR, uLoop, uCarrier} R Loop)

/-- The marked row at a vertex detects the generalized eigenspace of the
chosen loop, eigenvalue, and nilpotence exponent. -/
def DetectsAt
    (vertex : Vertex) (loop : Loop) (eigenvalue : R) (exponent : ℕ) : Prop :=
  DetectsGeneralizedEigenspace
    (system vertex).marked.row
    ((system vertex).marked.monodromy loop)
    eigenvalue exponent

/-- One path edge preserves the row-detected generalized-eigenspace
Boolean. -/
theorem Edge.detectsAt_iff
    {source target : Vertex}
    (edge : Edge system source target)
    (loop : Loop) (eigenvalue : R) (exponent : ℕ) :
    DetectsAt system source loop eigenvalue exponent ↔
      DetectsAt system target loop eigenvalue exponent :=
  edge.decomposition.detectsGeneralizedEigenspace_iff
    loop eigenvalue exponent

/-- Along a typed finite path, the endpoint row-detected
generalized-eigenspace Booleans agree.  No separate adjacent-overlap theorem
appears in the proof because each intermediate marked representation is one
value of `system`. -/
theorem Path.detectsAt_iff
    {source target : Vertex}
    (path : Path system source target)
    (loop : Loop) (eigenvalue : R) (exponent : ℕ) :
    DetectsAt system source loop eigenvalue exponent ↔
      DetectsAt system target loop eigenvalue exponent := by
  induction path with
  | nil => exact Iff.rfl
  | cons edge tail inductionHypothesis =>
      exact (edge.detectsAt_iff system loop eigenvalue exponent).trans
        inductionHypothesis

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedRepresentationPath
