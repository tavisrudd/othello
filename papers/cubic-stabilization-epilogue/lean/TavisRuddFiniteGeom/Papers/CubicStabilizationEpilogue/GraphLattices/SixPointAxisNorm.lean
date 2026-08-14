import Mathlib.RepresentationTheory.Invariants
import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixPointAxisFixedLine

/-!
# Norm projectors for the rational six-point axis representation

For a chosen label, the corresponding ten-element dihedral subgroup acts on
the rational augmentation representation of the six labels.  This module
defines its group norm as the sum of the ten action operators.

Lean proves that the norm has image exactly the one-dimensional fixed line and
satisfies `N * N = 10 * N`.  Thus one tenth of the norm is the projector onto
the axis line.  This is the finite representation-theoretic norm calculation;
no abelian scheme, geometric endomorphism, elliptic subvariety, or isogeny is
constructed here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

noncomputable local instance sixPointAxisStabilizerFintype (label : Fin 6) :
    Fintype (alternatingFiveSixPointStabilizer label) :=
  Fintype.ofFinite _

/-- The point stabilizer acts on the rational augmentation representation by
permuting its six coordinates. -/
noncomputable def sixPointAxisRepresentation (label : Fin 6) :
    Representation ℚ (alternatingFiveSixPointStabilizer label)
      SixPointRationalAugmentation where
  toFun transformation :=
    { toFun := fun vector ↦
        ⟨fun other ↦ vector.1
            (alternatingFiveSixPointAction transformation.1⁻¹ other), by
          change (∑ other, vector.1
            (alternatingFiveSixPointAction transformation.1⁻¹ other)) = 0
          rw [Fintype.sum_equiv
            (alternatingFiveSixPointAction transformation.1⁻¹)
            (fun other ↦ vector.1
              (alternatingFiveSixPointAction transformation.1⁻¹ other))
            vector.1 (fun _ ↦ rfl)]
          exact vector.property⟩
      map_add' := by
        intro left right
        rfl
      map_smul' := by
        intro scalar vector
        rfl }
  map_one' := by
    ext vector other
    simp
  map_mul' left right := by
    ext vector other
    simp [mul_inv_rev]

/-- Coordinate formula for the stabilizer action on rational augmentation
vectors. -/
@[simp]
theorem sixPointAxisRepresentation_apply
    (label : Fin 6)
    (transformation : alternatingFiveSixPointStabilizer label)
    (vector : SixPointRationalAugmentation) (other : Fin 6) :
    (sixPointAxisRepresentation label transformation vector).1 other =
      vector.1 (alternatingFiveSixPointAction transformation.1⁻¹ other) :=
  rfl

/-- The unnormalized group norm of one ten-element axis stabilizer on the
rational augmentation representation. -/
noncomputable def sixPointAxisNorm (label : Fin 6) :
    SixPointRationalAugmentation →ₗ[ℚ] SixPointRationalAugmentation :=
  ∑ transformation : alternatingFiveSixPointStabilizer label,
    sixPointAxisRepresentation label transformation

/-- Applying a stabilizer element after the group norm leaves the norm
unchanged. -/
theorem sixPointAxisRepresentation_norm
    (label : Fin 6)
    (transformation : alternatingFiveSixPointStabilizer label)
    (vector : SixPointRationalAugmentation) :
    sixPointAxisRepresentation label transformation
        (sixPointAxisNorm label vector) =
      sixPointAxisNorm label vector := by
  rw [sixPointAxisNorm]
  simp only [LinearMap.sum_apply, map_sum]
  simp_rw [← Module.End.mul_apply, ← map_mul]
  exact Fintype.sum_equiv (Equiv.mulLeft transformation) _ _ (fun _ ↦ rfl)

/-- The image of the stabilizer norm is fixed by the whole stabilizer. -/
theorem sixPointAxisNorm_mem_fixedSubspace
    (label : Fin 6) (vector : SixPointRationalAugmentation) :
    sixPointAxisNorm label vector ∈ sixPointAxisFixedSubspace label := by
  intro transformation member other
  let stabilizerElement : alternatingFiveSixPointStabilizer label :=
    ⟨transformation, member⟩
  have fixedByInverse := sixPointAxisRepresentation_norm label
    stabilizerElement⁻¹ vector
  have coordinateEquality := congrArg
    (fun fixedVector : SixPointRationalAugmentation ↦ fixedVector.1 other)
    fixedByInverse
  simpa [stabilizerElement] using coordinateEquality

/-- On the fixed subspace, the group norm is multiplication by the stabilizer
order ten. -/
theorem sixPointAxisNorm_apply_of_mem_fixedSubspace
    (label : Fin 6) (vector : SixPointRationalAugmentation)
    (fixed : vector ∈ sixPointAxisFixedSubspace label) :
    sixPointAxisNorm label vector = (10 : ℚ) • vector := by
  rw [sixPointAxisNorm, LinearMap.sum_apply]
  have eachFixed : ∀ transformation : alternatingFiveSixPointStabilizer label,
      sixPointAxisRepresentation label transformation vector = vector := by
    intro transformation
    apply Subtype.ext
    funext other
    exact fixed (transformation⁻¹).1 (transformation⁻¹).2 other
  simp_rw [eachFixed]
  rw [Finset.sum_const, Finset.card_univ, Fintype.card_eq_nat_card,
    alternatingFiveSixPointStabilizer_card]
  rfl

/-- The stabilizer norm satisfies the quadratic identity `N² = 10N`. -/
theorem sixPointAxisNorm_square
    (label : Fin 6) (vector : SixPointRationalAugmentation) :
    sixPointAxisNorm label (sixPointAxisNorm label vector) =
      (10 : ℚ) • sixPointAxisNorm label vector :=
  sixPointAxisNorm_apply_of_mem_fixedSubspace label _
    (sixPointAxisNorm_mem_fixedSubspace label vector)

/-- The range of the stabilizer norm is exactly its one-dimensional fixed
subspace. -/
theorem sixPointAxisNorm_range
    (label : Fin 6) :
    LinearMap.range (sixPointAxisNorm label) =
      sixPointAxisFixedSubspace label := by
  apply le_antisymm
  · rintro vector ⟨source, rfl⟩
    exact sixPointAxisNorm_mem_fixedSubspace label source
  · intro vector fixed
    refine ⟨(1 / 10 : ℚ) • vector, ?_⟩
    rw [map_smul, sixPointAxisNorm_apply_of_mem_fixedSubspace label vector fixed]
    norm_num [smul_smul]

/-- The range of the stabilizer norm is the line generated by the displayed
axis vector. -/
theorem sixPointAxisNorm_range_eq_span
    (label : Fin 6) :
    LinearMap.range (sixPointAxisNorm label) =
      ℚ ∙ sixPointRationalAxisVector label := by
  rw [sixPointAxisNorm_range, sixPointAxisFixedSubspace_eq_span]

/-- One tenth of the group norm is an idempotent projector onto the rational
axis line. -/
theorem sixPointAxisNormalizedNorm_idempotent
    (label : Fin 6) (vector : SixPointRationalAugmentation) :
    ((1 / 10 : ℚ) • sixPointAxisNorm label)
        (((1 / 10 : ℚ) • sixPointAxisNorm label) vector) =
      ((1 / 10 : ℚ) • sixPointAxisNorm label) vector := by
  simp only [LinearMap.smul_apply, map_smul]
  rw [sixPointAxisNorm_square]
  norm_num [smul_smul]

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
