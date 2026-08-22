import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.RowedProjectorPath
import Mathlib.LinearAlgebra.TensorProduct.Tower

/-!
# Rowed projector edges over two native coefficient rings

The source and target may carry scalar-valued rows and marked projectors over
different commutative coefficient rings.  An edge compares faithful scalar
extensions of both data to one common ring.  A direct-sum equivalence, a
unit-scaled row square, and a block-projector square then imply equivalence of
the two native detection propositions.

The semantic adapter may identify these two native propositions with any
vertex-indexed semantic property.  It does not infer those identifications or
construct the faithful algebra maps and geometric comparison.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.TwoBaseRowedProjectorEdge

open RowedProjectorDecomposition RowedProjectorPath
open scoped TensorProduct

universe uR uS uK uV uW uC uVertex

/-- Scalar extension of a scalar-valued row, with the canonical tensor copy
of the coefficient ring contracted back to the extension ring. -/
noncomputable def scalarBaseChangeRow
    {R K V : Type*}
    [CommRing R] [CommRing K] [Algebra R K]
    [AddCommGroup V] [Module R V]
    (row : V →ₗ[R] R) : (K ⊗[R] V) →ₗ[K] K :=
  (TensorProduct.AlgebraTensorModule.rid R K K).toLinearMap.comp
    (baseChangeRow R R row)

/-- Faithful scalar extension preserves and reflects scalar-row detection. -/
theorem detects_scalarBaseChange_iff
    {R K V : Type*}
    [CommRing R] [CommRing K] [Algebra R K]
    [Module.FaithfullyFlat R K]
    [AddCommGroup V] [Module R V]
    (row : V →ₗ[R] R) (projector : Projector R V) :
    RowedProjectorDecomposition.Detects K K
        (scalarBaseChangeRow row) projector.baseChange ↔
      RowedProjectorDecomposition.Detects R R row projector := by
  calc
    RowedProjectorDecomposition.Detects K K
        (scalarBaseChangeRow row) projector.baseChange ↔
      RowedProjectorDecomposition.Detects K (K ⊗[R] R)
        (baseChangeRow R R row) projector.baseChange :=
      detects_comp_injective_iff K (K ⊗[R] R)
        (baseChangeRow R R row) projector.baseChange
        (TensorProduct.AlgebraTensorModule.rid R K K).toLinearMap
        (TensorProduct.AlgebraTensorModule.rid R K K).injective
    _ ↔ RowedProjectorDecomposition.Detects R R row projector :=
      detects_baseChange_iff R R row projector

/-- A direct-sum comparison after faithfully extending two independently
based native data to one common coefficient ring. -/
structure Data
    (R : Type uR) (S : Type uS) (K : Type uK)
    [CommRing R] [CommRing S] [CommRing K]
    [Algebra R K] [Algebra S K]
    [Module.FaithfullyFlat R K] [Module.FaithfullyFlat S K]
    (V : Type uV) (W : Type uW) (C : Type uC)
    [AddCommGroup V] [Module R V]
    [AddCommGroup W] [Module S W]
    [AddCommGroup C] [Module K C] where
  sourceRow : V →ₗ[R] R
  targetRow : W →ₗ[S] S
  sourceProjector : Projector R V
  targetProjector : Projector S W
  correctionProjector : Projector K C
  comparison : (K ⊗[R] V) ≃ₗ[K] (K ⊗[S] W) × C
  rowScale : Kˣ
  rowComparison : ∀ x,
    scalarBaseChangeRow sourceRow x =
      (rowScale : K) • scalarBaseChangeRow targetRow (comparison x).1
  projectorComparison : ∀ x,
    comparison (sourceProjector.baseChange.map x) =
      (targetProjector.baseChange.map (comparison x).1,
        correctionProjector.map (comparison x).2)

namespace Data

variable
    {R : Type uR} {S : Type uS} {K : Type uK}
    [CommRing R] [CommRing S] [CommRing K]
    [Algebra R K] [Algebra S K]
    [Module.FaithfullyFlat R K] [Module.FaithfullyFlat S K]
    {V : Type uV} {W : Type uW} {C : Type uC}
    [AddCommGroup V] [Module R V]
    [AddCommGroup W] [Module S W]
    [AddCommGroup C] [Module K C]

/-- Forgetting the two native coefficient rings gives the common-ring
one-edge consumer datum. -/
noncomputable def toUnitScaledData
    (data : Data R S K V W C) :
    UnitScaledData K K (K ⊗[R] V) (K ⊗[S] W) C where
  sourceProjector := data.sourceProjector.baseChange
  ambientProjector := data.targetProjector.baseChange
  correctionProjector := data.correctionProjector
  comparison := data.comparison
  sourceRow := scalarBaseChangeRow data.sourceRow
  ambientRow := scalarBaseChangeRow data.targetRow
  rowScale := data.rowScale
  rowComparison := data.rowComparison
  projectorComparison := data.projectorComparison

/-- A two-base faithful comparison preserves native row-visible marked
support. -/
theorem detects_iff
    (data : Data R S K V W C) :
    RowedProjectorDecomposition.Detects R R
        data.sourceRow data.sourceProjector ↔
      RowedProjectorDecomposition.Detects S S
        data.targetRow data.targetProjector := by
  calc
    RowedProjectorDecomposition.Detects R R
        data.sourceRow data.sourceProjector ↔
      RowedProjectorDecomposition.Detects K K
        (scalarBaseChangeRow data.sourceRow)
        data.sourceProjector.baseChange :=
      (detects_scalarBaseChange_iff
        data.sourceRow data.sourceProjector).symm
    _ ↔ RowedProjectorDecomposition.Detects K K
        (scalarBaseChangeRow data.targetRow)
        data.targetProjector.baseChange :=
      data.toUnitScaledData.detects_iff
    _ ↔ RowedProjectorDecomposition.Detects S S
        data.targetRow data.targetProjector :=
      detects_scalarBaseChange_iff data.targetRow data.targetProjector

/-- Semantic endpoint identifications turn a two-base comparison into the
proposition-valued edge used by the intrinsic path telescope. -/
theorem toIntrinsicEdge
    {Vertex : Type uVertex} (Property : Vertex → Prop)
    (source target : Vertex)
    (data : Data R S K V W C)
    (sourceIdentification : Property source ↔
      RowedProjectorDecomposition.Detects R R
        data.sourceRow data.sourceProjector)
    (targetIdentification : Property target ↔
      RowedProjectorDecomposition.Detects S S
        data.targetRow data.targetProjector) :
    IntrinsicEdge Property source target where
  property_iff := sourceIdentification.trans <|
    data.detects_iff.trans targetIdentification.symm

end Data

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.TwoBaseRowedProjectorEdge
