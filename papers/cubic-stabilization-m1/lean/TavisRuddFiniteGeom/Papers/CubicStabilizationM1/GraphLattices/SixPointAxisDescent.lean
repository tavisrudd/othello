import Mathlib.LinearAlgebra.Isomorphisms
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.GraphLattices.SixPointAxisTransport

/-!
# Descent of the six rational axis vectors

The six rational axis vectors have coordinate `5` at their own label and
`-1` at the other labels.  This module proves that their sum is zero and that
the resulting synthesis map from the six-coordinate permutation module has
kernel exactly the constant line and image exactly the augmentation module.
Consequently it induces a linear equivalence from the quotient by the
constant line to the five-dimensional augmentation representation.

This is the coefficient-space descent used by the six-axis source.  No
elliptic scheme, inclusion into a Jacobian, homomorphism of abelian schemes,
polarization, or geometric generic-fibre comparison is constructed here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace GraphLattices

/-- The constant line in the rational six-coordinate permutation module. -/
def sixPointRationalConstantLine : Submodule ℚ (Fin 6 → ℚ) :=
  ℚ ∙ (fun _ ↦ (1 : ℚ))

/-- The quotient of the rational six-coordinate permutation module by its
constant line. -/
abbrev SixPointRationalCoefficientQuotient :=
  (Fin 6 → ℚ) ⧸ sixPointRationalConstantLine

/-- The sum of the six displayed rational axis vectors is zero. -/
theorem sum_sixPointRationalAxisVector :
    ∑ label, sixPointRationalAxisVector label = 0 := by
  apply Subtype.ext
  funext coordinate
  change (∑ label, if coordinate = label then (5 : ℚ) else -1) = 0
  calc
    (∑ label, if coordinate = label then (5 : ℚ) else -1) =
        ∑ label, (-1 + if coordinate = label then (6 : ℚ) else 0) := by
      apply Finset.sum_congr rfl
      intro label _
      by_cases equality : coordinate = label
      · norm_num [equality]
      · simp [equality]
    _ = 0 := by simp [Finset.sum_add_distrib]

/-- Synthesis from six scalar coefficients to the corresponding linear
combination of rational axis vectors. -/
noncomputable def sixPointRationalAxisSynthesis :
    (Fin 6 → ℚ) →ₗ[ℚ] SixPointRationalAugmentation where
  toFun coefficient :=
    ∑ label, coefficient label • sixPointRationalAxisVector label
  map_add' left right := by
    simp [add_smul, Finset.sum_add_distrib]
  map_smul' scalar coefficient := by
    rw [Finset.smul_sum]
    apply Finset.sum_congr rfl
    intro label _
    simp only [Pi.smul_apply, RingHom.id_apply, smul_eq_mul]
    rw [smul_smul]

/-- Coordinate formula for rational axis synthesis. -/
theorem sixPointRationalAxisSynthesis_apply
    (coefficient : Fin 6 → ℚ) (coordinate : Fin 6) :
    (sixPointRationalAxisSynthesis coefficient).1 coordinate =
      6 * coefficient coordinate - ∑ label, coefficient label := by
  classical
  change (∑ label, coefficient label *
      (if coordinate = label then (5 : ℚ) else -1)) = _
  calc
    (∑ label, coefficient label *
        (if coordinate = label then (5 : ℚ) else -1)) =
      ∑ label, (-coefficient label +
        if coordinate = label then 6 * coefficient label else 0) := by
      apply Finset.sum_congr rfl
      intro label _
      by_cases equality : coordinate = label
      · subst label
        simp
        ring
      · simp [equality]
    _ = 6 * coefficient coordinate - ∑ label, coefficient label := by
      simp [Finset.sum_add_distrib]
      ring

/-- A constant coefficient family synthesizes to zero. -/
theorem sixPointRationalAxisSynthesis_constant
    (scalar : ℚ) :
    sixPointRationalAxisSynthesis (fun _ ↦ scalar) = 0 := by
  change (∑ label, scalar • sixPointRationalAxisVector label) = 0
  rw [← Finset.smul_sum, sum_sixPointRationalAxisVector, smul_zero]

/-- The kernel of rational axis synthesis is exactly the constant line. -/
theorem sixPointRationalAxisSynthesis_ker :
    LinearMap.ker sixPointRationalAxisSynthesis =
      sixPointRationalConstantLine := by
  apply le_antisymm
  · intro coefficient kernel
    rw [sixPointRationalConstantLine, Submodule.mem_span_singleton]
    refine ⟨coefficient 0, ?_⟩
    funext coordinate
    have coordinateEquation := congrArg
      (fun vector : SixPointRationalAugmentation ↦ vector.1 coordinate)
      (show sixPointRationalAxisSynthesis coefficient = 0 from kernel)
    have zeroEquation := congrArg
      (fun vector : SixPointRationalAugmentation ↦ vector.1 0)
      (show sixPointRationalAxisSynthesis coefficient = 0 from kernel)
    rw [sixPointRationalAxisSynthesis_apply] at coordinateEquation zeroEquation
    simp only [Submodule.coe_zero, Pi.zero_apply] at coordinateEquation zeroEquation
    simp only [Pi.smul_apply, smul_eq_mul]
    linarith
  · intro coefficient member
    rw [sixPointRationalConstantLine, Submodule.mem_span_singleton] at member
    obtain ⟨scalar, rfl⟩ := member
    rw [LinearMap.mem_ker]
    rw [show scalar • (fun _ : Fin 6 ↦ (1 : ℚ)) =
        (fun _ ↦ scalar) by
      funext label
      simp]
    exact sixPointRationalAxisSynthesis_constant scalar

/-- Rational axis synthesis is onto the augmentation representation. -/
theorem sixPointRationalAxisSynthesis_surjective :
    Function.Surjective sixPointRationalAxisSynthesis := by
  intro vector
  refine ⟨fun label ↦ vector.1 label / 6, ?_⟩
  apply Subtype.ext
  funext coordinate
  rw [sixPointRationalAxisSynthesis_apply]
  have sumZero : ∑ label, vector.1 label = 0 := vector.property
  rw [← Finset.sum_div, sumZero]
  norm_num
  ring

/-- Rational axis synthesis descended to the quotient by the constant line. -/
noncomputable def sixPointRationalAxisDescent :
    SixPointRationalCoefficientQuotient →ₗ[ℚ]
      SixPointRationalAugmentation :=
  sixPointRationalConstantLine.liftQ sixPointRationalAxisSynthesis (by
    rw [← sixPointRationalAxisSynthesis_ker])

/-- The descended synthesis map is bijective. -/
theorem sixPointRationalAxisDescent_bijective :
    Function.Bijective sixPointRationalAxisDescent := by
  constructor
  · apply LinearMap.ker_eq_bot.mp
    exact Submodule.ker_liftQ_eq_bot'
      sixPointRationalConstantLine sixPointRationalAxisSynthesis
      sixPointRationalAxisSynthesis_ker.symm
  · intro vector
    obtain ⟨coefficient, equality⟩ :=
      sixPointRationalAxisSynthesis_surjective vector
    refine ⟨Submodule.Quotient.mk coefficient, ?_⟩
    simpa [sixPointRationalAxisDescent] using equality

/-- The quotient of the six-coordinate permutation module by the constant
line is linearly equivalent to the rational augmentation representation. -/
noncomputable def sixPointRationalCoefficientQuotientEquivAugmentation :
    SixPointRationalCoefficientQuotient ≃ₗ[ℚ]
      SixPointRationalAugmentation :=
  LinearEquiv.ofBijective sixPointRationalAxisDescent
    sixPointRationalAxisDescent_bijective

/-- The quotient equivalence is induced by rational axis synthesis: on a
coefficient representative it returns the corresponding axis combination. -/
@[simp]
theorem sixPointRationalCoefficientQuotientEquivAugmentation_mk
    (coefficient : Fin 6 → ℚ) :
    sixPointRationalCoefficientQuotientEquivAugmentation
        (Submodule.Quotient.mk coefficient) =
      sixPointRationalAxisSynthesis coefficient := by
  rfl

/-- The full alternating group acts on rational six-coordinate coefficient
families by permuting their labels. -/
noncomputable def sixPointRationalPermutationRepresentation :
    Representation ℚ (alternatingGroup (Fin 5)) (Fin 6 → ℚ) where
  toFun transformation :=
    { toFun := fun vector other ↦
        vector (alternatingFiveSixPointAction transformation⁻¹ other)
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

/-- The full alternating group acts on the rational augmentation module by
the same coordinate permutations. -/
noncomputable def sixPointRationalAugmentationRepresentation :
    Representation ℚ (alternatingGroup (Fin 5))
      SixPointRationalAugmentation where
  toFun transformation :=
    { toFun := fun vector ↦
        ⟨fun other ↦ vector.1
            (alternatingFiveSixPointAction transformation⁻¹ other), by
          change (∑ other, vector.1
            (alternatingFiveSixPointAction transformation⁻¹ other)) = 0
          rw [Fintype.sum_equiv
            (alternatingFiveSixPointAction transformation⁻¹)
            (fun other ↦ vector.1
              (alternatingFiveSixPointAction transformation⁻¹ other))
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

/-- The full alternating-group action carries the axis at one label to the
axis at the transported label. -/
theorem sixPointRationalAugmentationRepresentation_axisVector
    (transformation : alternatingGroup (Fin 5)) (label : Fin 6) :
    sixPointRationalAugmentationRepresentation transformation
        (sixPointRationalAxisVector label) =
      sixPointRationalAxisVector
        (alternatingFiveSixPointAction transformation label) := by
  apply Subtype.ext
  funext other
  change (if alternatingFiveSixPointAction transformation⁻¹ other = label
      then (5 : ℚ) else -1) =
    (if other = alternatingFiveSixPointAction transformation label
      then (5 : ℚ) else -1)
  congr 1
  apply propext
  constructor
  · intro equality
    rw [← equality]
    simp
  · intro equality
    rw [equality]
    simp

/-- Rational axis synthesis intertwines the full alternating-group actions
on six-coordinate coefficients and on the augmentation representation. -/
theorem sixPointRationalAxisSynthesis_equivariant
    (transformation : alternatingGroup (Fin 5))
    (coefficient : Fin 6 → ℚ) :
    sixPointRationalAxisSynthesis
        (sixPointRationalPermutationRepresentation transformation coefficient) =
      sixPointRationalAugmentationRepresentation transformation
        (sixPointRationalAxisSynthesis coefficient) := by
  apply Subtype.ext
  funext coordinate
  rw [sixPointRationalAxisSynthesis_apply]
  change 6 * coefficient
      (alternatingFiveSixPointAction transformation⁻¹ coordinate) -
      ∑ label, coefficient
        (alternatingFiveSixPointAction transformation⁻¹ label) = _
  rw [Fintype.sum_equiv
    (alternatingFiveSixPointAction transformation⁻¹)
    (fun label ↦ coefficient
      (alternatingFiveSixPointAction transformation⁻¹ label))
    coefficient (fun _ ↦ rfl)]
  change 6 * coefficient
      (alternatingFiveSixPointAction transformation⁻¹ coordinate) -
      ∑ label, coefficient label =
    (sixPointRationalAxisSynthesis coefficient).1
      (alternatingFiveSixPointAction transformation⁻¹ coordinate)
  rw [sixPointRationalAxisSynthesis_apply]

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
