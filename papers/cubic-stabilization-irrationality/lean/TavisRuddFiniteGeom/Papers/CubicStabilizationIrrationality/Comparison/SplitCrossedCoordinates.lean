import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ModelCrossedCoordinates

/-!
# A split crossed-edge monodromy model

A linear retraction of the combined crossed and moving map constructs an
explicit monodromy-image model for a crossed edge. The incoming monodromy is a
shear. The target monodromy is the involution that exchanges the source module
with its split image in the target common-plus-moving module. The scalar row is
the direct sum of the three rows carried by the edge.

This is an algebraic realization theorem. It does not identify the constructed
monodromies with loops of a quantum connection.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.SplitCrossedCoordinates

open FixedPhaseReader
open MonodromyImage
open ModelCrossedCoordinates

universe uι uR uC₀ uC₁ uM₀ uM₁

variable
    {R : Type uR} [CommRing R]
    {Occurrence CoeffParameter ChamberPath QdmPath Phase Character Direction : Type uι}
    {source target : ReaderIndex Occurrence CoeffParameter ChamberPath QdmPath Phase
      Character Direction}
    {C₀ : Type uC₀} {C₁ : Type uC₁} {M₀ : Type uM₀} {M₁ : Type uM₁}
    [AddCommGroup C₀] [Module R C₀]
    [AddCommGroup C₁] [Module R C₁]
    [AddCommGroup M₀] [Module R M₀]
    [AddCommGroup M₁] [Module R M₁]

abbrev Nearby (M₀ : Type uM₀) (C₁ : Type uC₁) (M₁ : Type uM₁) :=
  M₀ × (C₁ × M₁)

/-- A retraction of the combined crossed and moving map. -/
structure SplitMovingTarget
    (edge : CrossedEdge R source target C₀ C₁ M₀ M₁) where
  retraction : C₁ × M₁ →ₗ[R] M₀
  leftInverse : ∀ x, retraction (edge.movingTargetMap x) = x

namespace SplitMovingTarget

variable {edge : CrossedEdge R source target C₀ C₁ M₀ M₁}

/-- An invertible full upper-triangular edge supplies a retraction of its
combined crossed and moving blocks. -/
def ofFullMapEquivalence
    (comparison : (C₀ × M₀) ≃ₗ[R] (C₁ × M₁))
    (comparisonAgrees : comparison.toLinearMap = edge.fullMap) :
    SplitMovingTarget edge where
  retraction :=
    { toFun := fun value => (comparison.symm value).2
      map_add' := by intro left right; simp
      map_smul' := by intro scalar value; simp }
  leftInverse := by
    intro value
    have comparisonValue : comparison (0, value) = edge.movingTargetMap value := by
      change comparison.toLinearMap (0, value) = edge.movingTargetMap value
      rw [comparisonAgrees]
      simp [CrossedEdge.fullMap, CrossedEdge.movingTargetMap]
    change (comparison.symm (edge.movingTargetMap value)).2 = value
    rw [← comparisonValue, LinearEquiv.symm_apply_apply]

/-- The incoming shear whose identity-minus-monodromy image is the first
`M₀` summand. -/
def incoming (split : SplitMovingTarget edge) :
    Nearby M₀ C₁ M₁ ≃ₗ[R] Nearby M₀ C₁ M₁ where
  toFun value := (value.1 - split.retraction value.2, value.2)
  invFun value := (value.1 + split.retraction value.2, value.2)
  left_inv value := by ext <;> simp
  right_inv value := by ext <;> simp
  map_add' left right := by ext <;> simp [sub_eq_add_neg, add_assoc, add_left_comm, add_comm]
  map_smul' scalar value := by ext <;> simp [smul_sub]

/-- The target involution exchanging `M₀` with the split image of the
combined crossed and moving map. -/
def targetMonodromy (split : SplitMovingTarget edge) :
    Nearby M₀ C₁ M₁ ≃ₗ[R] Nearby M₀ C₁ M₁ where
  toFun value :=
    (split.retraction value.2,
      edge.movingTargetMap value.1 + value.2 -
        edge.movingTargetMap (split.retraction value.2))
  invFun value :=
    (split.retraction value.2,
      edge.movingTargetMap value.1 + value.2 -
        edge.movingTargetMap (split.retraction value.2))
  left_inv value := by
    ext <;> simp [split.leftInverse, add_comm]
  right_inv value := by
    ext <;> simp [split.leftInverse, add_comm]
  map_add' left right := by
    ext <;> simp [sub_eq_add_neg, add_assoc, add_left_comm, add_comm]
  map_smul' scalar value := by ext <;> simp [smul_add, smul_sub]

/-- The target operator in the split construction is an involution. -/
theorem targetMonodromy_involutive (split : SplitMovingTarget edge)
    (value : Nearby M₀ C₁ M₁) :
    split.targetMonodromy (split.targetMonodromy value) = value := by
  exact split.targetMonodromy.left_inv value

/-- The direct-sum row on the split model. -/
def row (edge : CrossedEdge R source target C₀ C₁ M₀ M₁) :
    Nearby M₀ C₁ M₁ →ₗ[R] R where
  toFun value := edge.sourceMovingRow value.1 +
    edge.targetCommonRow value.2.1 + edge.targetMovingRow value.2.2
  map_add' left right := by simp; ring
  map_smul' scalar value := by simp; ring

/-- The source moving module inside the incoming image. -/
def sourceValue : M₀ →ₗ[R] Nearby M₀ C₁ M₁ where
  toFun value := (value, 0)
  map_add' left right := by ext <;> simp
  map_smul' scalar value := by ext <;> simp

/-- The target common coordinate inclusion. -/
def targetCommonValue : C₁ →ₗ[R] Nearby M₀ C₁ M₁ where
  toFun value := (0, (value, 0))
  map_add' left right := by ext <;> simp
  map_smul' scalar value := by ext <;> simp

/-- The target moving coordinate inclusion. -/
def targetMovingValue : M₁ →ₗ[R] Nearby M₀ C₁ M₁ where
  toFun value := (0, (0, value))
  map_add' left right := by ext <;> simp
  map_smul' scalar value := by ext <;> simp

/-- The incoming defect of the split model is the chosen retraction in the
source coordinate and zero in the target coordinates. -/
theorem defectOperator_incoming_apply (split : SplitMovingTarget edge)
    (value : Nearby M₀ C₁ M₁) :
    defectOperator split.incoming.toLinearMap value = (split.retraction value.2, 0) := by
  ext <;> simp [defectOperator, incoming]

/-- The source module maps onto the canonical incoming monodromy image. -/
def sourceToIncomingImage (split : SplitMovingTarget edge) :
    M₀ →ₗ[R] LinearMap.range (defectOperator split.incoming.toLinearMap) where
  toFun value :=
    ⟨sourceValue (R := R) (C₁ := C₁) (M₁ := M₁) value,
      ⟨((0 : M₀), edge.movingTargetMap value), by
        rw [defectOperator_incoming_apply, split.leftInverse]
        rfl⟩⟩
  map_add' left right := by apply Subtype.ext; simp [sourceValue]
  map_smul' scalar value := by apply Subtype.ext; simp [sourceValue]

/-- The canonical source-to-image map retains the source value in the first
coordinate. -/
theorem sourceToIncomingImage_value (split : SplitMovingTarget edge) (value : M₀) :
    (split.sourceToIncomingImage value).1 =
      sourceValue (R := R) (C₁ := C₁) (M₁ := M₁) value :=
  rfl

/-- The canonical source realization covers the entire incoming monodromy
image of the split model. -/
theorem sourceToIncomingImage_surjective (split : SplitMovingTarget edge) :
    Function.Surjective split.sourceToIncomingImage := by
  intro value
  refine ⟨value.1.1, ?_⟩
  apply Subtype.ext
  rcases value.2 with ⟨preimage, hpreimage⟩
  have secondVanishes : value.1.2 = 0 := by
    rw [← hpreimage, defectOperator_incoming_apply]
  rw [sourceToIncomingImage_value]
  change (value.1.1, (0 : C₁ × M₁)) = value.1
  apply Prod.ext
  · rfl
  · exact secondVanishes.symm

/-- A split combined crossed-and-moving map supplies every algebraic field of
the crossed-coordinate monodromy model. -/
def coordinates (split : SplitMovingTarget edge) :
    Coordinates R R (RingHom.id R) edge (Nearby M₀ C₁ M₁) where
  incoming := split.incoming
  targetMonodromy := split.targetMonodromy
  row := row edge
  sourceValue := sourceValue
  targetCommonValue := targetCommonValue
  targetMovingValue := targetMovingValue
  sourceToIncomingImage := split.sourceToIncomingImage
  sourceToIncomingImage_value := sourceToIncomingImage_value split
  sourceToIncomingImage_surjective := split.sourceToIncomingImage_surjective
  targetDefectCoordinates := by
    intro value
    ext <;> simp [defectOperator, targetMonodromy, sourceValue,
      targetMovingValue, targetCommonValue, CrossedEdge.movingTargetMap]
  sourceRowCoordinates := by intro value; simp [row, sourceValue]
  targetCommonRowCoordinates := by intro value; simp [row, targetCommonValue]
  targetMovingRowCoordinates := by intro value; simp [row, targetMovingValue]

end SplitMovingTarget

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.SplitCrossedCoordinates
