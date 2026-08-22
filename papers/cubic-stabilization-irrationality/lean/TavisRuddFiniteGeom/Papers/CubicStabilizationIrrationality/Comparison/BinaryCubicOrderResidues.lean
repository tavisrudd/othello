import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.BinaryCubicJordanStrata
import TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.ThreefoldKummerCompatibility

/-!
# Modified residues for the two binary-cubic classical orders

A connected graded Frobenius algebra with dimensions `(1, 2, 2, 1)` has two
possible local Artin Gorenstein algebra types over the complex numbers.  This
external classification is Proposition 3.6 of Juan Elias and Maria Evelina
Rossi, *Isomorphism classes of short Gorenstein local rings via Macaulay's
inverse system*, Transactions of the American Mathematical Society 364
(2012), 4589--4604, arXiv:0911.3565.  This file studies one normalized
marked-divisor reduction for each type.  At the
generic cubic branch with eigenvalue one, an explicit rank-two projector and
normalized block-off-diagonal reducing gauge determine the first two
coefficients of the reduced `z`-connection.

For the dual-number order, the reduced grading preserves the image of the
leading nilpotent and the elementary-modified residue has discriminant zero.
For the distinct-root order, the reduced grading does not preserve that line,
so the same elementary modification is not a regular lattice operation.  A
finite two-case theorem therefore excludes discriminant `4/9` for these two
normalized reductions.

Every matrix identity is checked by kernel reduction over the rationals.  The
file does not prove the external classification, identify the displayed
matrices with a geometric quantum-D-module occurrence, show that such a carrier
extends to a regular unital classical order, or prove that an occurrence
comparison preserves either chosen normalization and lattice.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.BinaryCubicOrderResidues

open ThreefoldKummerCompatibility

abbrev OrderIndex := Fin 6
abbrev BlockIndex := Fin 2

set_option maxHeartbeats 800000

/-- The selected rank-two Jordan block `I + 2 E_{12}`. -/
def selectedJordan : Matrix BlockIndex BlockIndex ℚ :=
  !![1, 2; 0, 1]

/-- Matrix data for a normalized rank-two primary reduction inside a
six-dimensional graded multiplication operator. -/
structure NormalizedPrimaryReduction where
  multiplication : Matrix OrderIndex OrderIndex ℚ
  projector : Matrix OrderIndex OrderIndex ℚ
  selectedBasis : Matrix OrderIndex BlockIndex ℚ
  leftInverse : Matrix BlockIndex OrderIndex ℚ
  firstGauge : Matrix OrderIndex OrderIndex ℚ

/-- Proposition that the displayed matrices form the claimed normalized
primary reduction. -/
structure IsNormalized (data : NormalizedPrimaryReduction) : Prop where
  leftInverse_selected : data.leftInverse * data.selectedBasis = 1
  projector_factorization :
    data.projector = data.selectedBasis * data.leftInverse
  multiplication_selected :
    data.multiplication * data.selectedBasis =
      data.selectedBasis * selectedJordan
  projector_commutes :
    data.projector * data.multiplication =
      data.multiplication * data.projector
  reducedGrading_commutes :
    data.projector *
        (-productGrading + data.multiplication * data.firstGauge -
          data.firstGauge * data.multiplication) =
      (-productGrading + data.multiplication * data.firstGauge -
          data.firstGauge * data.multiplication) * data.projector
  gauge_selected_zero :
    data.projector * data.firstGauge * data.projector = 0
  gauge_complement_zero :
    (1 - data.projector) * data.firstGauge * (1 - data.projector) = 0

/-- The grading coefficient after the first normalized off-block gauge. -/
def blockGrading (data : NormalizedPrimaryReduction) :
    Matrix OrderIndex OrderIndex ℚ :=
  -productGrading + data.multiplication * data.firstGauge -
    data.firstGauge * data.multiplication

/-- The next coefficient in the normalized gauge recurrence. -/
def secondCoefficient (data : NormalizedPrimaryReduction) :
    Matrix OrderIndex OrderIndex ℚ :=
  let connectionGrading := -productGrading
  let commutator := data.multiplication * data.firstGauge -
    data.firstGauge * data.multiplication
  connectionGrading * data.firstGauge -
    data.firstGauge * connectionGrading -
    data.firstGauge * commutator - data.firstGauge

/-- Compression of the first reduced grading coefficient to the selected
rank-two primary factor. -/
def selectedBlockGrading (data : NormalizedPrimaryReduction) :
    Matrix BlockIndex BlockIndex ℚ :=
  data.leftInverse * blockGrading data * data.selectedBasis

/-- Compression of the second recurrence coefficient to the selected
rank-two primary factor. -/
def selectedSecondCoefficient (data : NormalizedPrimaryReduction) :
    Matrix BlockIndex BlockIndex ℚ :=
  data.leftInverse * secondCoefficient data * data.selectedBasis

/-- The reduced grading preserves the image of the leading nilpotent exactly
when its lower-left entry vanishes in the selected Jordan basis. -/
def LeadingLinePreserved (data : NormalizedPrimaryReduction) : Prop :=
  selectedBlockGrading data 1 0 = 0

/-- The residue matrix obtained by elementary modification along the leading
nilpotent line.  Its geometric use requires `LeadingLinePreserved data`. -/
def modifiedResidue (data : NormalizedPrimaryReduction) :
    Matrix BlockIndex BlockIndex ℚ :=
  !![selectedBlockGrading data 0 0, selectedJordan 0 1;
     selectedSecondCoefficient data 1 0,
       selectedBlockGrading data 1 1 - 1]

/-- The trace-square-minus-four-determinant invariant of the displayed
modified residue. -/
def residueDiscriminant (data : NormalizedPrimaryReduction) : ℚ :=
  (modifiedResidue data).trace ^ 2 - 4 * (modifiedResidue data).det

private def dualMultiplication : Matrix OrderIndex OrderIndex ℚ :=
  !![0, 0, 0, 0, 1, 0;
     -1 / 3, 0, 0, 0, 0, 1;
     1, 0, 0, 0, 0, 0;
     0, 1, -1 / 3, 0, 0, 0;
     0, 0, 1, 0, 0, 0;
     0, 0, 0, 1, -1 / 3, 0]

private def dualProjector : Matrix OrderIndex OrderIndex ℚ :=
  !![1 / 3, 0, 1 / 3, 0, 1 / 3, 0;
     0, 1 / 3, 0, 1 / 3, 0, 1 / 3;
     1 / 3, 0, 1 / 3, 0, 1 / 3, 0;
     0, 1 / 3, 0, 1 / 3, 0, 1 / 3;
     1 / 3, 0, 1 / 3, 0, 1 / 3, 0;
     0, 1 / 3, 0, 1 / 3, 0, 1 / 3]

private def dualSelectedBasis : Matrix OrderIndex BlockIndex ℚ :=
  !![0, -6;
     1, 0;
     0, -6;
     1, 0;
     0, -6;
     1, 0]

private def dualLeftInverse : Matrix BlockIndex OrderIndex ℚ :=
  !![0, 1 / 3, 0, 1 / 3, 0, 1 / 3;
     -1 / 18, 0, -1 / 18, 0, -1 / 18, 0]

private def dualFirstGauge : Matrix OrderIndex OrderIndex ℚ :=
  !![-1 / 9, 0, 2 / 9, 0, 2 / 9, 0;
     0, -1 / 9, 0, 2 / 9, 0, 2 / 9;
     -1 / 9, 0, 2 / 9, 0, 2 / 9, 0;
     0, -1 / 9, 0, 2 / 9, 0, 2 / 9;
     -4 / 9, 0, -1 / 9, 0, -1 / 9, 0;
     0, -4 / 9, 0, -1 / 9, 0, -1 / 9]

/-- The normalized generic primary reduction for multiplication by
`x-e/3` in the cubic dual-number order. -/
def dualNumberReduction : NormalizedPrimaryReduction := by
  exact ⟨dualMultiplication, dualProjector, dualSelectedBasis,
    dualLeftInverse, dualFirstGauge⟩

private theorem dual_leftInverse_selected :
    dualLeftInverse * dualSelectedBasis = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [dualLeftInverse, dualSelectedBasis, Matrix.mul_apply,
      Fin.sum_univ_succ]

private theorem dual_projector_factorization :
    dualProjector = dualSelectedBasis * dualLeftInverse := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [dualProjector, dualSelectedBasis, dualLeftInverse,
      Matrix.mul_apply, Fin.sum_univ_succ]

private theorem dual_multiplication_selected :
    dualMultiplication * dualSelectedBasis =
      dualSelectedBasis * selectedJordan := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [dualMultiplication, dualSelectedBasis, selectedJordan,
      Matrix.mul_apply, Fin.sum_univ_succ]

private theorem dual_projector_commutes :
    dualProjector * dualMultiplication = dualMultiplication * dualProjector := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [dualProjector, dualMultiplication, Matrix.mul_apply,
      Fin.sum_univ_succ]

private theorem dual_reducedGrading_commutes :
    dualProjector *
        (-productGrading + dualMultiplication * dualFirstGauge -
          dualFirstGauge * dualMultiplication) =
      (-productGrading + dualMultiplication * dualFirstGauge -
          dualFirstGauge * dualMultiplication) * dualProjector := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [dualMultiplication, dualFirstGauge, dualProjector,
      productGrading, Matrix.mul_apply, Matrix.vecMul_apply_eq_sum,
      Fin.sum_univ_succ]

private theorem dual_gauge_selected_zero :
    dualProjector * dualFirstGauge * dualProjector = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [dualProjector, dualFirstGauge, Matrix.mul_apply,
      Fin.sum_univ_succ]

private theorem dual_gauge_complement_zero :
    (1 - dualProjector) * dualFirstGauge * (1 - dualProjector) = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [dualProjector, dualFirstGauge, Matrix.one_apply, Matrix.mul_apply,
      Fin.sum_univ_succ] <;>
    norm_num

/-- The dual-number matrices satisfy every normalized-primary identity. -/
theorem dualNumber_isNormalized : IsNormalized dualNumberReduction := by
  exact ⟨dual_leftInverse_selected, dual_projector_factorization,
    dual_multiplication_selected, dual_projector_commutes,
    dual_reducedGrading_commutes, dual_gauge_selected_zero,
    dual_gauge_complement_zero⟩

private def distinctMultiplication : Matrix OrderIndex OrderIndex ℚ :=
  !![0, 0, 1, -2, 0, 0;
     1, 0, 0, 0, 0, 0;
     0, 0, 0, 0, 1, 0;
     0, -1, 0, 0, 0, 0;
     0, 0, 0, 0, 0, 1;
     0, 0, 0, 1, 0, 0]

private def distinctProjector : Matrix OrderIndex OrderIndex ℚ :=
  !![1 / 3, 4 / 9, 2 / 9, -5 / 9, 1 / 9, 0;
     2 / 9, 1 / 3, 1 / 9, -4 / 9, 0, -1 / 9;
     2 / 9, 1 / 9, 1 / 3, 0, 4 / 9, 5 / 9;
     -1 / 9, -2 / 9, 0, 1 / 3, 1 / 9, 2 / 9;
     1 / 9, 0, 2 / 9, 1 / 9, 1 / 3, 4 / 9;
     0, -1 / 9, 1 / 9, 2 / 9, 2 / 9, 1 / 3]

private def distinctSelectedBasis : Matrix OrderIndex BlockIndex ℚ :=
  !![-1, -6;
     -1, -4;
     1, -4;
     1, 2;
     1, -2;
     1, 0]

private def distinctLeftInverse : Matrix BlockIndex OrderIndex ℚ :=
  !![0, -1 / 9, 1 / 9, 2 / 9, 2 / 9, 1 / 3;
     -1 / 18, -1 / 18, -1 / 18, 1 / 18, -1 / 18, -1 / 18]

private def distinctFirstGauge : Matrix OrderIndex OrderIndex ℚ :=
  !![-2 / 81, 20 / 81, 2 / 27, -8 / 27, 20 / 81, 16 / 81;
     -2 / 27, 4 / 27, 0, -8 / 27, 2 / 27, -4 / 27;
     4 / 81, 8 / 81, 0, 10 / 27, 20 / 81, 88 / 81;
     16 / 81, 8 / 81, 2 / 27, 2 / 27, 2 / 81, 28 / 81;
     -2 / 27, 2 / 27, -8 / 27, 4 / 27, -8 / 27, 2 / 9;
     8 / 81, 16 / 81, -4 / 27, -2 / 27, -20 / 81, 8 / 81]

/-- The normalized generic primary reduction for multiplication by `a` in
the distinct-root binary-cubic order. -/
def distinctRootReduction : NormalizedPrimaryReduction := by
  exact ⟨distinctMultiplication, distinctProjector, distinctSelectedBasis,
    distinctLeftInverse, distinctFirstGauge⟩

private theorem distinct_leftInverse_selected :
    distinctLeftInverse * distinctSelectedBasis = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [distinctLeftInverse, distinctSelectedBasis, Matrix.mul_apply,
      Fin.sum_univ_succ]

private theorem distinct_projector_factorization :
    distinctProjector = distinctSelectedBasis * distinctLeftInverse := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [distinctProjector, distinctSelectedBasis, distinctLeftInverse,
      Matrix.mul_apply, Fin.sum_univ_succ]

private theorem distinct_multiplication_selected :
    distinctMultiplication * distinctSelectedBasis =
      distinctSelectedBasis * selectedJordan := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [distinctMultiplication, distinctSelectedBasis, selectedJordan,
      Matrix.mul_apply, Fin.sum_univ_succ]

private theorem distinct_projector_commutes :
    distinctProjector * distinctMultiplication =
      distinctMultiplication * distinctProjector := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [distinctProjector, distinctMultiplication, Matrix.mul_apply,
      Fin.sum_univ_succ]

private theorem distinct_reducedGrading_commutes :
    distinctProjector *
        (-productGrading + distinctMultiplication * distinctFirstGauge -
          distinctFirstGauge * distinctMultiplication) =
      (-productGrading + distinctMultiplication * distinctFirstGauge -
          distinctFirstGauge * distinctMultiplication) * distinctProjector := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [distinctMultiplication, distinctFirstGauge, distinctProjector,
      productGrading, Matrix.mul_apply, Matrix.vecMul_apply_eq_sum,
      Fin.sum_univ_succ]

private theorem distinct_gauge_selected_zero :
    distinctProjector * distinctFirstGauge * distinctProjector = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [distinctProjector, distinctFirstGauge, Matrix.mul_apply,
      Fin.sum_univ_succ]

private theorem distinct_gauge_complement_zero :
    (1 - distinctProjector) * distinctFirstGauge *
        (1 - distinctProjector) = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [distinctProjector, distinctFirstGauge, Matrix.one_apply,
      Matrix.mul_apply, Fin.sum_univ_succ] <;>
    norm_num

/-- The distinct-root matrices satisfy every normalized-primary identity. -/
theorem distinctRoot_isNormalized : IsNormalized distinctRootReduction := by
  exact ⟨distinct_leftInverse_selected, distinct_projector_factorization,
    distinct_multiplication_selected, distinct_projector_commutes,
    distinct_reducedGrading_commutes, distinct_gauge_selected_zero,
    distinct_gauge_complement_zero⟩

/-- On the dual-number order, the selected grading is diagonal with entries
`-1/2, 1/2`. -/
theorem dualNumber_selectedBlockGrading_value :
    selectedBlockGrading dualNumberReduction = !![-1 / 2, 0; 0, 1 / 2] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [selectedBlockGrading, blockGrading, dualNumberReduction,
      dualMultiplication, dualSelectedBasis, dualLeftInverse, dualFirstGauge,
      productGrading, Matrix.mul_apply, Fin.sum_univ_succ]

/-- On the dual-number order, the selected second recurrence coefficient is
the scalar matrix `1/3`. -/
theorem dualNumber_selectedSecondCoefficient_value :
    selectedSecondCoefficient dualNumberReduction = !![1 / 3, 0; 0, 1 / 3] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [selectedSecondCoefficient, secondCoefficient,
      dualNumberReduction, dualMultiplication, dualSelectedBasis,
      dualLeftInverse, dualFirstGauge, productGrading, Matrix.mul_apply,
      Fin.sum_univ_succ]

/-- The dual-number reduction preserves the leading nilpotent line. -/
theorem dualNumber_leadingLinePreserved :
    LeadingLinePreserved dualNumberReduction := by
  unfold LeadingLinePreserved
  rw [dualNumber_selectedBlockGrading_value]
  norm_num

/-- The dual-number modified residue has discriminant zero. -/
theorem dualNumber_residueDiscriminant_zero :
    residueDiscriminant dualNumberReduction = 0 := by
  unfold residueDiscriminant modifiedResidue
  rw [dualNumber_selectedBlockGrading_value,
    dualNumber_selectedSecondCoefficient_value]
  norm_num [selectedJordan, Matrix.trace, Matrix.det_fin_two]

/-- On the distinct-root order, the selected grading has the displayed
nonzero lower-left entry. -/
theorem distinctRoot_selectedBlockGrading_value :
    selectedBlockGrading distinctRootReduction =
      !![-11 / 18, 0; 1 / 6, 11 / 18] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [selectedBlockGrading, blockGrading, distinctRootReduction,
      distinctMultiplication, distinctSelectedBasis, distinctLeftInverse,
      distinctFirstGauge, productGrading, Matrix.mul_apply,
      Fin.sum_univ_succ]

/-- On the distinct-root order, the selected second recurrence coefficient
has the displayed value. -/
theorem distinctRoot_selectedSecondCoefficient_value :
    selectedSecondCoefficient distinctRootReduction =
      !![4 / 9, 16 / 81; -8 / 81, 8 / 27] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [selectedSecondCoefficient, secondCoefficient,
      distinctRootReduction, distinctMultiplication, distinctSelectedBasis,
      distinctLeftInverse, distinctFirstGauge, productGrading,
      Matrix.mul_apply, Fin.sum_univ_succ]

/-- The distinct-root reduced grading fails to preserve the image of the
leading nilpotent. -/
theorem distinctRoot_not_leadingLinePreserved :
    ¬ LeadingLinePreserved distinctRootReduction := by
  intro h
  unfold LeadingLinePreserved at h
  rw [distinctRoot_selectedBlockGrading_value] at h
  norm_num at h

/-- The two normalized classical order models. -/
inductive ClassicalOrderModel
  | dualNumber
  | distinctRoot
  deriving DecidableEq

/-- The normalized reduction attached to a classical order model. -/
def ClassicalOrderModel.reduction :
    ClassicalOrderModel → NormalizedPrimaryReduction
  | .dualNumber => dualNumberReduction
  | .distinctRoot => distinctRootReduction

/-- The finite conditions needed for one of the normalized reductions to
carry the cubic marker: a regular elementary-modification line and residue
discriminant `4/9`. -/
def CarriesCubicMarker (model : ClassicalOrderModel) : Prop :=
  LeadingLinePreserved model.reduction ∧
    residueDiscriminant model.reduction = 4 / 9

/-- Neither normalized classical order reduction carries the cubic marker. -/
theorem no_classicalOrderModel_carriesCubicMarker
    (model : ClassicalOrderModel) : ¬ CarriesCubicMarker model := by
  cases model with
  | dualNumber =>
      rintro ⟨_, hdisc⟩
      change residueDiscriminant dualNumberReduction = 4 / 9 at hdisc
      rw [dualNumber_residueDiscriminant_zero] at hdisc
      norm_num at hdisc
  | distinctRoot =>
      rintro ⟨hline, _⟩
      change LeadingLinePreserved distinctRootReduction at hline
      exact distinctRoot_not_leadingLinePreserved hline

/-- The marked divisor in the dual-number special fibre has Jordan type
`J4 direct-sum J2`. -/
def dualNumberSpecialJordanCertificate :
    BinaryCubicJordanStrata.JordanCertificate
      (BinaryCubicJordanStrata.divisorMultiplication (-1 : ℚ) 1 0)
      BinaryCubicJordanStrata.jordanFourTwo :=
  BinaryCubicJordanStrata.fourTwoCertificate (-1 : ℚ) 1 0
    (by norm_num) (by norm_num)

/-- The marked divisor in the distinct-root special fibre has Jordan type
`J4 direct-sum J1 direct-sum J1`. -/
def distinctRootSpecialJordanCertificate :
    BinaryCubicJordanStrata.JordanCertificate
      (BinaryCubicJordanStrata.divisorMultiplication (-1 : ℚ) 0 0)
      BinaryCubicJordanStrata.jordanFourOneOne :=
  BinaryCubicJordanStrata.fourOneOneCertificate (-1 : ℚ) 0 0
    (by norm_num) (by norm_num)

end TavisRuddFiniteGeom.Papers.CubicStabilizationIrrationality.Comparison.BinaryCubicOrderResidues
