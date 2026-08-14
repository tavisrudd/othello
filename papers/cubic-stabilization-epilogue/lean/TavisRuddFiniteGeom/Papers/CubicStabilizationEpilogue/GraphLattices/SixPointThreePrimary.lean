import TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue.GraphLattices.SixPointStableHalves
import Mathlib.LinearAlgebra.Matrix.NonsingularInverse

/-!
# The three-primary six-point coefficient packet

Let `H₃` be the quotient of the augmentation hyperplane in `F₃⁶` by its
constant line.  Normalizing the last coordinate to zero identifies `H₃` with
`F₃⁴`.  Translation and inversion on the six labels induce two explicit
matrices.  Lean proves that this four-dimensional representation is simple and
that the common commutant of the two matrices consists only of scalars.

The normalized coefficient pairing is minus the six-coordinate dot product.
It is symmetric and nondegenerate.  After choosing a symplectic basis of a
two-dimensional factor, its tensor product with the symplectic form is an
alternating nondegenerate form on `H₃ × H₃`.  The vertical copy and the three
scalar graphs form exactly the four-dimensional diagonally stable subspaces;
all four are maximal isotropic.

All finite identities in this module are checked by kernel reduction over the
explicit field `ZMod 3`; no native evaluation, external certificate, or oracle
is used.  The module does not identify this coefficient model with a geometric
three-primary discriminant kernel or a family local system.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

open scoped Matrix

set_option maxRecDepth 10000
set_option maxHeartbeats 2000000

/-- The field with three elements, used for the three-primary packet. -/
abbrev F3 := ZMod 3

/-- Multiplication by two is negation in the field with three elements. -/
theorem f3_mul_two (value : F3) : value * 2 = -value := by
  revert value
  decide

/-- The explicit four-coordinate model of the six-point three-primary heart. -/
abbrev SixPointThreeHeart := Fin 4 → F3

/-- Quotient coordinates obtained by subtracting the last coordinate. -/
def sixPointThreeHeartCoordinates (vector : Fin 6 → F3) : SixPointThreeHeart :=
  ![vector 0 - vector 5, vector 1 - vector 5,
    vector 2 - vector 5, vector 3 - vector 5]

/-- The augmentation representative whose last coordinate is zero. -/
def sixPointThreeHeartRepresentative (heart : SixPointThreeHeart) : Fin 6 → F3 :=
  ![heart 0, heart 1, heart 2, heart 3, -∑ index, heart index, 0]

/-- The normalized representative has coordinate sum zero. -/
theorem sixPointThreeHeartRepresentative_sum_zero (heart : SixPointThreeHeart) :
    ∑ point, sixPointThreeHeartRepresentative heart point = 0 := by
  simp [sixPointThreeHeartRepresentative, Fin.sum_univ_succ]
  ring

/-- Normalized representatives recover their four quotient coordinates. -/
theorem sixPointThreeHeartCoordinates_representative (heart : SixPointThreeHeart) :
    sixPointThreeHeartCoordinates (sixPointThreeHeartRepresentative heart) = heart := by
  ext index
  fin_cases index <;>
    simp [sixPointThreeHeartCoordinates, sixPointThreeHeartRepresentative]

/-- The induced translation matrix on the three-primary heart. -/
def sixPointThreeHeartTranslation : Matrix (Fin 4) (Fin 4) F3 :=
  !![2, 2, 2, 2;
     1, 0, 0, 0;
     0, 1, 0, 0;
     0, 0, 1, 0]

/-- The induced inversion matrix on the three-primary heart. -/
def sixPointThreeHeartInversion : Matrix (Fin 4) (Fin 4) F3 :=
  !![2, 0, 0, 0;
     1, 2, 2, 2;
     2, 0, 1, 0;
     2, 0, 0, 1]

/-- Inverse translation on normalized representatives induces the displayed
three-primary translation matrix. -/
theorem sixPointThreeHeartCoordinates_translation (heart : SixPointThreeHeart) :
    sixPointThreeHeartCoordinates
        (sixPointThreeHeartRepresentative heart ∘ sixPointTranslationPreimage) =
      Matrix.mulVec sixPointThreeHeartTranslation heart := by
  ext index
  fin_cases index <;>
    simp [sixPointThreeHeartCoordinates, sixPointThreeHeartRepresentative,
      sixPointTranslationPreimage, sixPointThreeHeartTranslation,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ,
      show (2 : F3) = -1 by decide]
  all_goals ring_nf

/-- Inverse inversion on normalized representatives induces the displayed
three-primary inversion matrix. -/
theorem sixPointThreeHeartCoordinates_inversion (heart : SixPointThreeHeart) :
    sixPointThreeHeartCoordinates
        (sixPointThreeHeartRepresentative heart ∘ sixPointInversionPreimage) =
      Matrix.mulVec sixPointThreeHeartInversion heart := by
  ext index
  fin_cases index <;>
    simp [sixPointThreeHeartCoordinates, sixPointThreeHeartRepresentative,
      sixPointInversionPreimage, sixPointThreeHeartInversion,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ,
      show (2 : F3) = -1 by decide]
  case «1» =>
    revert heart
    decide
  case «2» => ring
  case «3» => ring

/-- The matrix whose columns are the first four translation iterates of a
heart vector. -/
def sixPointThreeHeartCyclicMatrix (vector : SixPointThreeHeart) :
    Matrix (Fin 4) (Fin 4) F3 := fun row column =>
  Matrix.mulVec (sixPointThreeHeartTranslation ^ (column : Nat)) vector row

/-- Every nonzero vector is cyclic for the displayed translation matrix.  This
closed statement checks the eighty nonzero vectors by kernel reduction. -/
theorem sixPointThreeHeartCyclicMatrix_det_ne_zero
    (vector : SixPointThreeHeart) (nonzero : vector ≠ 0) :
    (sixPointThreeHeartCyclicMatrix vector).det ≠ 0 := by
  revert vector
  decide

/-- Stability under the displayed translation and inversion matrices. -/
def SixPointThreeHeartGeneratorStable
    (subspace : Submodule F3 SixPointThreeHeart) : Prop :=
  (∀ vector ∈ subspace,
    Matrix.mulVec sixPointThreeHeartTranslation vector ∈ subspace) ∧
  (∀ vector ∈ subspace,
    Matrix.mulVec sixPointThreeHeartInversion vector ∈ subspace)

/-- Translation stability is preserved by every natural power. -/
theorem sixPointThreeHeartGeneratorStable_translation_pow
    (subspace : Submodule F3 SixPointThreeHeart)
    (stable : SixPointThreeHeartGeneratorStable subspace)
    (power : Nat) (vector : SixPointThreeHeart) (member : vector ∈ subspace) :
    Matrix.mulVec (sixPointThreeHeartTranslation ^ power) vector ∈ subspace := by
  induction power with
  | zero => simpa using member
  | succ power induction =>
      rw [pow_succ', ← Matrix.mulVec_mulVec]
      exact stable.1 _ induction

/-- The explicit three-primary heart is simple for the generated action. -/
theorem sixPointThreeHeartGeneratorStable_simple
    (subspace : Submodule F3 SixPointThreeHeart)
    (stable : SixPointThreeHeartGeneratorStable subspace) :
    subspace = ⊥ ∨ subspace = ⊤ := by
  by_cases zero : subspace = ⊥
  · exact Or.inl zero
  · right
    obtain ⟨⟨vector, member⟩, nonzeroSubtype⟩ :=
      Submodule.nonzero_mem_of_bot_lt (bot_lt_iff_ne_bot.mpr zero)
    have nonzero : vector ≠ 0 := by
      intro equality
      apply nonzeroSubtype
      apply Subtype.ext
      exact equality
    let cyclic := sixPointThreeHeartCyclicMatrix vector
    apply top_unique
    intro arbitrary _
    have cyclicInjective : Function.Injective (Matrix.toLin' cyclic) := by
      intro left right equality
      apply sub_eq_zero.mp
      apply Matrix.eq_zero_of_mulVec_eq_zero
        (sixPointThreeHeartCyclicMatrix_det_ne_zero vector nonzero)
      change Matrix.mulVec cyclic left = Matrix.mulVec cyclic right at equality
      change Matrix.mulVec cyclic (left - right) = 0
      rw [Matrix.mulVec_sub, equality, sub_self]
    have cyclicSurjective : Function.Surjective (Matrix.toLin' cyclic) :=
      (LinearMap.injective_iff_surjective_of_finrank_eq_finrank rfl).mp
        cyclicInjective
    obtain ⟨coefficient, recovered⟩ := cyclicSurjective arbitrary
    have cyclicMember : Matrix.mulVec cyclic coefficient ∈ subspace := by
      have sumMember : (∑ column, coefficient column •
          (fun row => cyclic row column)) ∈ subspace := by
        apply subspace.sum_mem
        intro column _
        have iterateMember := sixPointThreeHeartGeneratorStable_translation_pow
          subspace stable (column : Nat) vector member
        simpa [cyclic, sixPointThreeHeartCyclicMatrix, Pi.smul_apply,
          smul_eq_mul] using subspace.smul_mem (coefficient column) iterateMember
      have sumEquality : Matrix.mulVec cyclic coefficient =
          ∑ column, coefficient column • (fun row => cyclic row column) := by
        ext row
        simp [Matrix.mulVec, dotProduct, Pi.smul_apply, smul_eq_mul, mul_comm]
      rwa [sumEquality]
    change Matrix.mulVec cyclic coefficient = arbitrary at recovered
    rwa [recovered] at cyclicMember

/-- The standard first basis vector of the coordinate heart. -/
def sixPointThreeHeartFirstBasis : SixPointThreeHeart := ![1, 0, 0, 0]

/-- The explicit inverse of the cyclic basis matrix generated by the first
basis vector. -/
def sixPointThreeHeartCyclicBasisInverse : Matrix (Fin 4) (Fin 4) F3 :=
  !![1, 1, 1, 1;
     0, 1, 1, 1;
     0, 0, 1, 1;
     0, 0, 0, 1]

/-- The displayed matrix is a right inverse to the cyclic basis matrix. -/
theorem sixPointThreeHeartCyclicBasis_mul_inverse :
    sixPointThreeHeartCyclicMatrix sixPointThreeHeartFirstBasis *
      sixPointThreeHeartCyclicBasisInverse = 1 := by
  decide

/-- The matrix commuting with translation whose first-column value is the
supplied vector. -/
def sixPointThreeHeartCommutantMatrix (vector : SixPointThreeHeart) :
    Matrix (Fin 4) (Fin 4) F3 :=
  sixPointThreeHeartCyclicMatrix vector *
    sixPointThreeHeartCyclicBasisInverse

/-- The translation-commuting matrix selected by a vector commutes with
inversion precisely when the vector is supported in its first coordinate. -/
theorem sixPointThreeHeartCommutantMatrix_commutes_inversion_iff
    (vector : SixPointThreeHeart) :
    sixPointThreeHeartCommutantMatrix vector * sixPointThreeHeartInversion =
        sixPointThreeHeartInversion * sixPointThreeHeartCommutantMatrix vector ↔
      vector 1 = 0 ∧ vector 2 = 0 ∧ vector 3 = 0 := by
  revert vector
  decide

/-- A first-coordinate vector produces the corresponding scalar commutant
matrix. -/
theorem sixPointThreeHeartCommutantMatrix_firstCoordinate (scalar : F3) :
    sixPointThreeHeartCommutantMatrix ![scalar, 0, 0, 0] =
      Matrix.scalar (Fin 4) scalar := by
  revert scalar
  decide

/-- Commutation with translation determines a matrix from its value on the
first basis vector. -/
theorem sixPointThreeHeartCommutantMatrix_mulVec_firstBasis
    (matrix : Matrix (Fin 4) (Fin 4) F3)
    (commutes : matrix * sixPointThreeHeartTranslation =
      sixPointThreeHeartTranslation * matrix) :
    sixPointThreeHeartCommutantMatrix
        (Matrix.mulVec matrix sixPointThreeHeartFirstBasis) = matrix := by
  have commutesPow (power : Nat) :
      matrix * sixPointThreeHeartTranslation ^ power =
        sixPointThreeHeartTranslation ^ power * matrix := by
    induction power with
    | zero => simp
    | succ power induction =>
        calc
          matrix * sixPointThreeHeartTranslation ^ (power + 1) =
              matrix * (sixPointThreeHeartTranslation *
                sixPointThreeHeartTranslation ^ power) := by rw [pow_succ']
          _ = (matrix * sixPointThreeHeartTranslation) *
                sixPointThreeHeartTranslation ^ power := by rw [Matrix.mul_assoc]
          _ = (sixPointThreeHeartTranslation * matrix) *
                sixPointThreeHeartTranslation ^ power := by rw [commutes]
          _ = sixPointThreeHeartTranslation *
                (matrix * sixPointThreeHeartTranslation ^ power) := by
              rw [Matrix.mul_assoc]
          _ = sixPointThreeHeartTranslation *
                (sixPointThreeHeartTranslation ^ power * matrix) := by
              rw [induction]
          _ = (sixPointThreeHeartTranslation *
                sixPointThreeHeartTranslation ^ power) * matrix := by
              rw [Matrix.mul_assoc]
          _ = sixPointThreeHeartTranslation ^ (power + 1) * matrix := by
              rw [pow_succ']
  have cyclicIntertwines :
      sixPointThreeHeartCyclicMatrix
          (Matrix.mulVec matrix sixPointThreeHeartFirstBasis) =
        matrix * sixPointThreeHeartCyclicMatrix
          sixPointThreeHeartFirstBasis := by
    ext row column
    change Matrix.mulVec (sixPointThreeHeartTranslation ^ (column : Nat))
        (Matrix.mulVec matrix sixPointThreeHeartFirstBasis) row =
      Matrix.mulVec matrix
        (Matrix.mulVec (sixPointThreeHeartTranslation ^ (column : Nat))
          sixPointThreeHeartFirstBasis) row
    have vectorEquality := congrArg
      (fun value => Matrix.mulVec value sixPointThreeHeartFirstBasis)
      (commutesPow (column : Nat)).symm
    exact congrFun (by simpa [Matrix.mulVec_mulVec] using vectorEquality) row
  rw [sixPointThreeHeartCommutantMatrix, cyclicIntertwines,
    Matrix.mul_assoc, sixPointThreeHeartCyclicBasis_mul_inverse, mul_one]

/-- Scalar matrices commute with both displayed generators. -/
theorem sixPointThreeHeart_scalar_commutes (scalar : F3) :
    Matrix.scalar (Fin 4) scalar * sixPointThreeHeartTranslation =
        sixPointThreeHeartTranslation * Matrix.scalar (Fin 4) scalar ∧
      Matrix.scalar (Fin 4) scalar * sixPointThreeHeartInversion =
        sixPointThreeHeartInversion * Matrix.scalar (Fin 4) scalar := by
  revert scalar
  decide

/-- The common commutant of the two three-primary heart generators consists
exactly of scalar matrices. -/
theorem sixPointThreeHeart_commonCommutant_classification
    (matrix : Matrix (Fin 4) (Fin 4) F3) :
    (matrix * sixPointThreeHeartTranslation =
        sixPointThreeHeartTranslation * matrix ∧
      matrix * sixPointThreeHeartInversion =
        sixPointThreeHeartInversion * matrix) ↔
      ∃ scalar : F3, matrix = Matrix.scalar (Fin 4) scalar := by
  constructor
  · rintro ⟨commutesTranslation, commutesInversion⟩
    let vector := Matrix.mulVec matrix sixPointThreeHeartFirstBasis
    have cyclicEquality : sixPointThreeHeartCommutantMatrix vector = matrix :=
      sixPointThreeHeartCommutantMatrix_mulVec_firstBasis matrix commutesTranslation
    have cyclicCommutes :
        sixPointThreeHeartCommutantMatrix vector * sixPointThreeHeartInversion =
          sixPointThreeHeartInversion * sixPointThreeHeartCommutantMatrix vector := by
      simpa only [cyclicEquality] using commutesInversion
    obtain ⟨secondZero, thirdZero, fourthZero⟩ :=
      (sixPointThreeHeartCommutantMatrix_commutes_inversion_iff vector).mp
        cyclicCommutes
    refine ⟨vector 0, ?_⟩
    rw [← cyclicEquality]
    have vectorEquality : vector = ![vector 0, 0, 0, 0] := by
      ext index
      fin_cases index <;> simp [secondZero, thirdZero, fourthZero]
    rw [vectorEquality, sixPointThreeHeartCommutantMatrix_firstCoordinate]
    rfl
  · rintro ⟨scalar, rfl⟩
    exact sixPointThreeHeart_scalar_commutes scalar

/-- Matrix of the normalized three-primary coefficient pairing in the
four-coordinate chart. -/
def sixPointThreeHeartCoefficientMatrix : Matrix (Fin 4) (Fin 4) F3 :=
  !![1, 2, 2, 2;
     2, 1, 2, 2;
     2, 2, 1, 2;
     2, 2, 2, 1]

/-- The normalized symmetric coefficient pairing on the three-primary heart. -/
def sixPointThreeHeartCoefficientForm :
    LinearMap.BilinForm F3 SixPointThreeHeart :=
  Matrix.toLinearMap₂' F3 sixPointThreeHeartCoefficientMatrix

/-- The coordinate pairing is minus the dot product of normalized
six-coordinate augmentation representatives. -/
theorem sixPointThreeHeartCoefficientForm_eq_negative_dotProduct
    (left right : SixPointThreeHeart) :
    sixPointThreeHeartCoefficientForm left right =
      -dotProduct (sixPointThreeHeartRepresentative left)
        (sixPointThreeHeartRepresentative right) := by
  revert left right
  decide

/-- The normalized three-primary coefficient pairing is symmetric. -/
theorem sixPointThreeHeartCoefficientForm_comm
    (left right : SixPointThreeHeart) :
    sixPointThreeHeartCoefficientForm left right =
      sixPointThreeHeartCoefficientForm right left := by
  rw [sixPointThreeHeartCoefficientForm_eq_negative_dotProduct,
    sixPointThreeHeartCoefficientForm_eq_negative_dotProduct]
  simp [dotProduct_comm]

/-- The coefficient pairing matrix is its own inverse. -/
theorem sixPointThreeHeartCoefficientMatrix_sq :
    sixPointThreeHeartCoefficientMatrix *
      sixPointThreeHeartCoefficientMatrix = 1 := by
  decide

/-- The normalized three-primary coefficient pairing is nondegenerate. -/
theorem sixPointThreeHeartCoefficientForm_nondegenerate :
    sixPointThreeHeartCoefficientForm.Nondegenerate := by
  apply LinearMap.nondegenerate_toLinearMap₂'_of_det_ne_zero'
  decide

/-- The tensor-product polarization form after choosing a symplectic basis of
the two-dimensional factor. -/
def sixPointThreeHeartPairPolarizationForm
    (left right : SixPointThreeHeart × SixPointThreeHeart) : F3 :=
  sixPointThreeHeartCoefficientForm left.1 right.2 -
    sixPointThreeHeartCoefficientForm left.2 right.1

/-- The tensor-product polarization pairing bundled as a bilinear form. -/
def sixPointThreeHeartPairPolarizationBilinForm :
    LinearMap.BilinForm F3 (SixPointThreeHeart × SixPointThreeHeart) :=
  LinearMap.mk₂ F3 sixPointThreeHeartPairPolarizationForm
    (by
      intro left₁ left₂ right
      simp [sixPointThreeHeartPairPolarizationForm]
      ring)
    (by
      intro scalar left right
      simp [sixPointThreeHeartPairPolarizationForm]
      ring)
    (by
      intro left right₁ right₂
      simp [sixPointThreeHeartPairPolarizationForm]
      ring)
    (by
      intro scalar left right
      simp [sixPointThreeHeartPairPolarizationForm]
      ring)

/-- Evaluation of the bundled tensor-product pairing. -/
@[simp]
theorem sixPointThreeHeartPairPolarizationBilinForm_apply
    (left right : SixPointThreeHeart × SixPointThreeHeart) :
    sixPointThreeHeartPairPolarizationBilinForm left right =
      sixPointThreeHeartPairPolarizationForm left right :=
  rfl

/-- The tensor-product polarization pairing is alternating. -/
theorem sixPointThreeHeartPairPolarizationBilinForm_isAlt :
    sixPointThreeHeartPairPolarizationBilinForm.IsAlt := by
  intro pair
  simp only [sixPointThreeHeartPairPolarizationBilinForm_apply,
    sixPointThreeHeartPairPolarizationForm]
  rw [sixPointThreeHeartCoefficientForm_comm pair.2 pair.1, sub_self]

/-- The tensor-product polarization pairing is nondegenerate. -/
theorem sixPointThreeHeartPairPolarizationBilinForm_nondegenerate :
    sixPointThreeHeartPairPolarizationBilinForm.Nondegenerate := by
  constructor
  · intro pair annihilates
    apply Prod.ext
    · apply sixPointThreeHeartCoefficientForm_nondegenerate.1
      intro test
      simpa [sixPointThreeHeartPairPolarizationForm] using annihilates (0, test)
    · apply sixPointThreeHeartCoefficientForm_nondegenerate.1
      intro test
      have evaluated := annihilates (test, 0)
      simpa [sixPointThreeHeartPairPolarizationForm] using evaluated
  · intro pair annihilates
    apply Prod.ext
    · apply sixPointThreeHeartCoefficientForm_nondegenerate.2
      intro test
      simpa [sixPointThreeHeartPairPolarizationForm] using annihilates (0, test)
    · apply sixPointThreeHeartCoefficientForm_nondegenerate.2
      intro test
      have evaluated := annihilates (test, 0)
      simpa [sixPointThreeHeartPairPolarizationForm] using evaluated

/-- Diagonal stability of a subspace of two three-primary heart copies. -/
def SixPointThreeHeartPairGeneratorStable
    (subspace : Submodule F3 (SixPointThreeHeart × SixPointThreeHeart)) : Prop :=
  (∀ vector ∈ subspace,
    (Matrix.mulVec sixPointThreeHeartTranslation vector.1,
      Matrix.mulVec sixPointThreeHeartTranslation vector.2) ∈ subspace) ∧
  (∀ vector ∈ subspace,
    (Matrix.mulVec sixPointThreeHeartInversion vector.1,
      Matrix.mulVec sixPointThreeHeartInversion vector.2) ∈ subspace)

/-- The vertical half for `none`, and the graph of scalar multiplication for
`some scalar`. -/
def sixPointThreeHeartStableHalf (slope : Option F3) :
    Submodule F3 (SixPointThreeHeart × SixPointThreeHeart) :=
  match slope with
  | none => LinearMap.range (verticalEmbedding (K := F3) (H := SixPointThreeHeart))
  | some scalar => LinearMap.range
      (graphEmbedding (K := F3)
        (Matrix.toLin' (Matrix.scalar (Fin 4) scalar)))

/-- The four displayed three-primary stable halves. -/
def SixPointThreeHeartStableHalfPacket : Set
    (Submodule F3 (SixPointThreeHeart × SixPointThreeHeart)) :=
  Set.range sixPointThreeHeartStableHalf

/-- Every displayed half is diagonally stable. -/
theorem sixPointThreeHeartStableHalf_generatorStable (slope : Option F3) :
    SixPointThreeHeartPairGeneratorStable
      (sixPointThreeHeartStableHalf slope) := by
  cases slope with
  | none =>
      constructor <;> rintro pair ⟨vector, rfl⟩
      · exact ⟨Matrix.mulVec sixPointThreeHeartTranslation vector, rfl⟩
      · exact ⟨Matrix.mulVec sixPointThreeHeartInversion vector, rfl⟩
  | some scalar =>
      have commutes := sixPointThreeHeart_scalar_commutes scalar
      constructor
      · rintro pair ⟨vector, rfl⟩
        refine ⟨Matrix.mulVec sixPointThreeHeartTranslation vector, ?_⟩
        apply Prod.ext
        · rfl
        · change Matrix.mulVec (Matrix.scalar (Fin 4) scalar)
              (Matrix.mulVec sixPointThreeHeartTranslation vector) =
            Matrix.mulVec sixPointThreeHeartTranslation
              (Matrix.mulVec (Matrix.scalar (Fin 4) scalar) vector)
          simpa only [Matrix.mulVec_mulVec] using
            congrArg (fun value => Matrix.mulVec value vector) commutes.1
      · rintro pair ⟨vector, rfl⟩
        refine ⟨Matrix.mulVec sixPointThreeHeartInversion vector, ?_⟩
        apply Prod.ext
        · rfl
        · change Matrix.mulVec (Matrix.scalar (Fin 4) scalar)
              (Matrix.mulVec sixPointThreeHeartInversion vector) =
            Matrix.mulVec sixPointThreeHeartInversion
              (Matrix.mulVec (Matrix.scalar (Fin 4) scalar) vector)
          simpa only [Matrix.mulVec_mulVec] using
            congrArg (fun value => Matrix.mulVec value vector) commutes.2

/-- Every displayed half has dimension four. -/
theorem sixPointThreeHeartStableHalf_finrank (slope : Option F3) :
    Module.finrank F3 (sixPointThreeHeartStableHalf slope) = 4 := by
  cases slope with
  | none =>
      calc
        Module.finrank F3 (sixPointThreeHeartStableHalf none) =
            Module.finrank F3 SixPointThreeHeart := by
          apply LinearMap.finrank_range_of_inj
          intro left right equality
          exact congrArg Prod.snd equality
        _ = 4 := by simp [SixPointThreeHeart]
  | some scalar =>
      calc
        Module.finrank F3 (sixPointThreeHeartStableHalf (some scalar)) =
            Module.finrank F3 SixPointThreeHeart := by
          exact finrank_graphEmbedding_range (K := F3) (H := SixPointThreeHeart)
            (Matrix.toLin' (Matrix.scalar (Fin 4) scalar))
        _ = 4 := by simp [SixPointThreeHeart]

/-- Every displayed half is isotropic for the tensor-product pairing. -/
theorem sixPointThreeHeartStableHalf_isotropic (slope : Option F3) :
    sixPointThreeHeartStableHalf slope ≤
      sixPointThreeHeartPairPolarizationBilinForm.orthogonal
        (sixPointThreeHeartStableHalf slope) := by
  cases slope with
  | none =>
      rintro _ ⟨left, rfl⟩ _ ⟨right, rfl⟩
      simp [sixPointThreeHeartPairPolarizationForm, verticalEmbedding]
  | some scalar =>
      rintro _ ⟨left, rfl⟩ _ ⟨right, rfl⟩
      simp only [sixPointThreeHeartPairPolarizationBilinForm_apply,
        sixPointThreeHeartPairPolarizationForm, graphEmbedding,
        LinearMap.prod_apply, LinearMap.id_coe, Function.prod_apply,
        id_eq, Matrix.toLin'_apply]
      simp

/-- Every displayed stable half is maximal isotropic. -/
theorem sixPointThreeHeartStableHalf_maximalIsotropic (slope : Option F3) :
    IsMaximalIsotropic sixPointThreeHeartPairPolarizationBilinForm
      (sixPointThreeHeartStableHalf slope) := by
  apply isMaximalIsotropic_of_isotropic_of_twice_finrank_eq
    sixPointThreeHeartPairPolarizationBilinForm
    sixPointThreeHeartPairPolarizationBilinForm_nondegenerate
    (sixPointThreeHeartStableHalf slope)
    (sixPointThreeHeartStableHalf_isotropic slope)
  rw [sixPointThreeHeartStableHalf_finrank, Module.finrank_prod]
  simp [SixPointThreeHeart]

/-- The image of a pair subspace under first projection. -/
def sixPointThreeHeartPairFirstRange
    (subspace : Submodule F3 (SixPointThreeHeart × SixPointThreeHeart)) :
    Submodule F3 SixPointThreeHeart :=
  subspace.map (LinearMap.fst F3 SixPointThreeHeart SixPointThreeHeart)

/-- The vertical part of a pair subspace. -/
def sixPointThreeHeartPairVerticalPart
    (subspace : Submodule F3 (SixPointThreeHeart × SixPointThreeHeart)) :
    Submodule F3 SixPointThreeHeart :=
  subspace.comap (LinearMap.inr F3 SixPointThreeHeart SixPointThreeHeart)

/-- Diagonal stability descends to the first projection. -/
theorem sixPointThreeHeartPairFirstRange_generatorStable
    (subspace : Submodule F3 (SixPointThreeHeart × SixPointThreeHeart))
    (stable : SixPointThreeHeartPairGeneratorStable subspace) :
    SixPointThreeHeartGeneratorStable
      (sixPointThreeHeartPairFirstRange subspace) := by
  constructor
  · intro vector member
    rcases member with ⟨pair, pairMember, rfl⟩
    exact ⟨(Matrix.mulVec sixPointThreeHeartTranslation pair.1,
      Matrix.mulVec sixPointThreeHeartTranslation pair.2),
      stable.1 pair pairMember, rfl⟩
  · intro vector member
    rcases member with ⟨pair, pairMember, rfl⟩
    exact ⟨(Matrix.mulVec sixPointThreeHeartInversion pair.1,
      Matrix.mulVec sixPointThreeHeartInversion pair.2),
      stable.2 pair pairMember, rfl⟩

/-- Diagonal stability descends to the vertical part. -/
theorem sixPointThreeHeartPairVerticalPart_generatorStable
    (subspace : Submodule F3 (SixPointThreeHeart × SixPointThreeHeart))
    (stable : SixPointThreeHeartPairGeneratorStable subspace) :
    SixPointThreeHeartGeneratorStable
      (sixPointThreeHeartPairVerticalPart subspace) := by
  constructor
  · intro vector member
    change (0, vector) ∈ subspace at member
    change (0, Matrix.mulVec sixPointThreeHeartTranslation vector) ∈ subspace
    simpa using stable.1 (0, vector) member
  · intro vector member
    change (0, vector) ∈ subspace at member
    change (0, Matrix.mulVec sixPointThreeHeartInversion vector) ∈ subspace
    simpa using stable.2 (0, vector) member

/-- Both projection modules of a stable pair subspace are simple. -/
theorem sixPointThreeHeartPair_projection_and_vertical_simple
    (subspace : Submodule F3 (SixPointThreeHeart × SixPointThreeHeart))
    (stable : SixPointThreeHeartPairGeneratorStable subspace) :
    (sixPointThreeHeartPairFirstRange subspace = ⊥ ∨
      sixPointThreeHeartPairFirstRange subspace = ⊤) ∧
    (sixPointThreeHeartPairVerticalPart subspace = ⊥ ∨
      sixPointThreeHeartPairVerticalPart subspace = ⊤) :=
  ⟨sixPointThreeHeartGeneratorStable_simple _
      (sixPointThreeHeartPairFirstRange_generatorStable subspace stable),
    sixPointThreeHeartGeneratorStable_simple _
      (sixPointThreeHeartPairVerticalPart_generatorStable subspace stable)⟩

/-- The range of a graph embedding determines its slope. -/
theorem sixPointThreeHeartGraphRange_injective : Function.Injective
    (fun slope : SixPointThreeHeart →ₗ[F3] SixPointThreeHeart ↦
      LinearMap.range (graphEmbedding (K := F3) slope)) := by
  intro left right rangeEquality
  change LinearMap.range (graphEmbedding (K := F3) left) =
    LinearMap.range (graphEmbedding (K := F3) right) at rangeEquality
  apply LinearMap.ext
  intro vector
  have member : graphEmbedding (K := F3) left vector ∈
      LinearMap.range (graphEmbedding (K := F3) right) := by
    have sourceMember : graphEmbedding (K := F3) left vector ∈
        LinearMap.range (graphEmbedding (K := F3) left) := ⟨vector, rfl⟩
    rw [← rangeEquality]
    exact sourceMember
  rcases member with ⟨preimage, equality⟩
  have firstEquality := congrArg Prod.fst equality
  have secondEquality := congrArg Prod.snd equality
  change preimage = vector at firstEquality
  change right preimage = left vector at secondEquality
  rw [firstEquality] at secondEquality
  exact secondEquality.symm

/-- The vertical range differs from every graph range. -/
theorem sixPointThreeHeartVertical_ne_graphRange
    (slope : SixPointThreeHeart →ₗ[F3] SixPointThreeHeart) :
    LinearMap.range (verticalEmbedding (K := F3) (H := SixPointThreeHeart)) ≠
      LinearMap.range (graphEmbedding (K := F3) slope) := by
  intro rangeEquality
  have member : graphEmbedding (K := F3) slope sixPointThreeHeartFirstBasis ∈
      LinearMap.range (verticalEmbedding (K := F3) (H := SixPointThreeHeart)) := by
    rw [rangeEquality]
    exact ⟨sixPointThreeHeartFirstBasis, rfl⟩
  rcases member with ⟨preimage, equality⟩
  have firstEquality := congrArg
    (fun pair : SixPointThreeHeart × SixPointThreeHeart => pair.1 0) equality
  norm_num [verticalEmbedding, graphEmbedding,
    sixPointThreeHeartFirstBasis] at firstEquality

/-- The four displayed halves are pairwise distinct. -/
theorem sixPointThreeHeartStableHalf_injective :
    Function.Injective sixPointThreeHeartStableHalf := by
  intro left right equality
  cases left with
  | none =>
      cases right with
      | none => rfl
      | some scalar =>
          exact (sixPointThreeHeartVertical_ne_graphRange
            (Matrix.toLin' (Matrix.scalar (Fin 4) scalar)) equality).elim
  | some leftScalar =>
      cases right with
      | none =>
          exact (sixPointThreeHeartVertical_ne_graphRange
            (Matrix.toLin' (Matrix.scalar (Fin 4) leftScalar)) equality.symm).elim
      | some rightScalar =>
          have linearEquality := sixPointThreeHeartGraphRange_injective equality
          have matrixEquality : Matrix.scalar (Fin 4) leftScalar =
              Matrix.scalar (Fin 4) rightScalar :=
            Matrix.toLin'.injective linearEquality
          have entryEquality := congrArg (fun matrix => matrix 0 0) matrixEquality
          simpa using entryEquality

/-- The displayed stable-half packet has four members. -/
theorem sixPointThreeHeartStableHalfPacket_ncard :
    SixPointThreeHeartStableHalfPacket.ncard = 4 := by
  classical
  rw [show SixPointThreeHeartStableHalfPacket =
      Set.range sixPointThreeHeartStableHalf by rfl]
  simpa using Set.ncard_range_of_injective
    sixPointThreeHeartStableHalf_injective

/-- Every four-dimensional diagonally stable subspace is one of the vertical
half or the three scalar graphs. -/
theorem sixPointThreeHeartPair_stableHalf_classification
    (subspace : Submodule F3 (SixPointThreeHeart × SixPointThreeHeart))
    (stable : SixPointThreeHeartPairGeneratorStable subspace)
    (halfDimension : Module.finrank F3 subspace = 4) :
    subspace ∈ SixPointThreeHeartStableHalfPacket := by
  classical
  obtain ⟨firstRangeSimple, verticalPartSimple⟩ :=
    sixPointThreeHeartPair_projection_and_vertical_simple subspace stable
  rcases firstRangeSimple with firstRangeZero | firstRangeFull
  · rcases verticalPartSimple with verticalPartZero | verticalPartFull
    · have subspaceZero : subspace = ⊥ := by
        apply bot_unique
        intro pair pairMember
        have firstMember : pair.1 ∈ sixPointThreeHeartPairFirstRange subspace :=
          ⟨pair, pairMember, rfl⟩
        have firstZero : pair.1 = 0 := by
          have : pair.1 ∈ (⊥ : Submodule F3 SixPointThreeHeart) := by
            simpa [firstRangeZero] using firstMember
          simpa using this
        have secondMember : pair.2 ∈
            sixPointThreeHeartPairVerticalPart subspace := by
          change (0, pair.2) ∈ subspace
          have pairEquality : pair = (0, pair.2) := by
            exact Prod.ext firstZero rfl
          rwa [← pairEquality]
        have secondZero : pair.2 = 0 := by
          have : pair.2 ∈ (⊥ : Submodule F3 SixPointThreeHeart) := by
            simpa [verticalPartZero] using secondMember
          simpa using this
        exact Prod.ext firstZero secondZero
      rw [subspaceZero] at halfDimension
      norm_num at halfDimension
    · have verticalEquality : subspace = sixPointThreeHeartStableHalf none := by
        ext pair
        constructor
        · intro pairMember
          have firstMember : pair.1 ∈ sixPointThreeHeartPairFirstRange subspace :=
            ⟨pair, pairMember, rfl⟩
          have firstZero : pair.1 = 0 := by
            have : pair.1 ∈ (⊥ : Submodule F3 SixPointThreeHeart) := by
              simpa [firstRangeZero] using firstMember
            simpa using this
          exact ⟨pair.2, by ext <;> simp [verticalEmbedding, firstZero]⟩
        · rintro ⟨vector, rfl⟩
          have vectorMember : vector ∈
              sixPointThreeHeartPairVerticalPart subspace := by
            simp [verticalPartFull]
          exact vectorMember
      exact ⟨none, verticalEquality.symm⟩
  · rcases verticalPartSimple with verticalPartZero | verticalPartFull
    · let projection : subspace →ₗ[F3] SixPointThreeHeart :=
        (LinearMap.fst F3 SixPointThreeHeart SixPointThreeHeart).domRestrict subspace
      have projectionInjective : Function.Injective projection := by
        intro left right equality
        apply Subtype.ext
        apply Prod.ext equality
        have differenceMember : left.1.2 - right.1.2 ∈
            sixPointThreeHeartPairVerticalPart subspace := by
          change (0, left.1.2 - right.1.2) ∈ subspace
          have member := subspace.sub_mem left.2 right.2
          have pairEquality : left.1 - right.1 =
              (0, left.1.2 - right.1.2) := by
            apply Prod.ext
            · exact sub_eq_zero.mpr equality
            · rfl
          rwa [← pairEquality]
        have differenceZero : left.1.2 - right.1.2 = 0 := by
          have : left.1.2 - right.1.2 ∈
              (⊥ : Submodule F3 SixPointThreeHeart) := by
            simpa [verticalPartZero] using differenceMember
          simpa using this
        exact sub_eq_zero.mp differenceZero
      have projectionSurjective : Function.Surjective projection := by
        intro vector
        have vectorMember : vector ∈ sixPointThreeHeartPairFirstRange subspace := by
          simp [firstRangeFull]
        rcases vectorMember with ⟨pair, pairMember, equality⟩
        exact ⟨⟨pair, pairMember⟩, equality⟩
      let projectionEquiv : subspace ≃ₗ[F3] SixPointThreeHeart :=
        LinearEquiv.ofBijective projection
          ⟨projectionInjective, projectionSurjective⟩
      let slope : SixPointThreeHeart →ₗ[F3] SixPointThreeHeart :=
        (LinearMap.snd F3 SixPointThreeHeart SixPointThreeHeart).comp
          (subspace.subtype.comp projectionEquiv.symm.toLinearMap)
      have graphValue (vector : SixPointThreeHeart) :
          (projectionEquiv.symm vector : subspace).1 =
            graphEmbedding (K := F3) slope vector := by
        apply Prod.ext
        · exact projectionEquiv.apply_symm_apply vector
        · rfl
      have subspaceGraph : subspace =
          LinearMap.range (graphEmbedding (K := F3) slope) := by
        ext pair
        constructor
        · intro pairMember
          let member : subspace := ⟨pair, pairMember⟩
          refine ⟨pair.1, ?_⟩
          rw [← graphValue]
          have subtypeEquality : projectionEquiv.symm pair.1 = member := by
            apply projectionEquiv.injective
            exact projectionEquiv.apply_symm_apply pair.1
          exact congrArg Subtype.val subtypeEquality
        · rintro ⟨vector, rfl⟩
          rw [← graphValue]
          exact (projectionEquiv.symm vector).2
      have slopeCommutes
          (generator : Matrix (Fin 4) (Fin 4) F3)
          (generatorStable : ∀ pair ∈ subspace,
            (Matrix.mulVec generator pair.1,
              Matrix.mulVec generator pair.2) ∈ subspace)
          (vector : SixPointThreeHeart) :
          slope (Matrix.mulVec generator vector) =
            Matrix.mulVec generator (slope vector) := by
        let lifted : subspace := projectionEquiv.symm vector
        let acted : subspace :=
          ⟨(Matrix.mulVec generator lifted.1.1,
              Matrix.mulVec generator lifted.1.2),
            generatorStable lifted.1 lifted.2⟩
        have actedEquality : acted =
            projectionEquiv.symm (Matrix.mulVec generator vector) := by
          apply projectionInjective
          calc
            projection acted = Matrix.mulVec generator vector := by
              change Matrix.mulVec generator lifted.1.1 =
                Matrix.mulVec generator vector
              rw [show lifted.1.1 = vector by
                exact projectionEquiv.apply_symm_apply vector]
            _ = projection
                (projectionEquiv.symm (Matrix.mulVec generator vector)) := by
              exact (projectionEquiv.apply_symm_apply _).symm
        have secondEquality := congrArg (fun value : subspace => value.1.2)
          actedEquality
        change Matrix.mulVec generator lifted.1.2 =
          slope (Matrix.mulVec generator vector) at secondEquality
        have liftedSecond : lifted.1.2 = slope vector := by
          have graphSecond : (projectionEquiv.symm vector : subspace).1.2 =
              (graphEmbedding (K := F3) slope vector).2 :=
            congrArg Prod.snd (graphValue vector)
          simpa [graphEmbedding] using graphSecond
        rw [liftedSecond] at secondEquality
        exact secondEquality.symm
      let slopeMatrix : Matrix (Fin 4) (Fin 4) F3 :=
        LinearMap.toMatrix' slope
      have matrixCommutesTranslation :
          slopeMatrix * sixPointThreeHeartTranslation =
            sixPointThreeHeartTranslation * slopeMatrix := by
        apply Matrix.toLin'.injective
        apply LinearMap.ext
        intro vector
        simpa [slopeMatrix] using
          slopeCommutes sixPointThreeHeartTranslation stable.1 vector
      have matrixCommutesInversion :
          slopeMatrix * sixPointThreeHeartInversion =
            sixPointThreeHeartInversion * slopeMatrix := by
        apply Matrix.toLin'.injective
        apply LinearMap.ext
        intro vector
        simpa [slopeMatrix] using
          slopeCommutes sixPointThreeHeartInversion stable.2 vector
      obtain ⟨scalar, matrixScalar⟩ :=
        (sixPointThreeHeart_commonCommutant_classification slopeMatrix).mp
          ⟨matrixCommutesTranslation, matrixCommutesInversion⟩
      have slopeFromMatrix : Matrix.toLin' slopeMatrix = slope := by
        simp [slopeMatrix]
      refine ⟨some scalar, ?_⟩
      rw [sixPointThreeHeartStableHalf, ← matrixScalar,
        slopeFromMatrix, subspaceGraph]
    · have subspaceFull : subspace = ⊤ := by
        apply top_unique
        intro pair _
        have firstMember : pair.1 ∈ sixPointThreeHeartPairFirstRange subspace := by
          simp [firstRangeFull]
        rcases firstMember with ⟨lift, liftMember, firstEquality⟩
        have verticalMember : pair.2 - lift.2 ∈
            sixPointThreeHeartPairVerticalPart subspace := by
          simp [verticalPartFull]
        change (0, pair.2 - lift.2) ∈ subspace at verticalMember
        have sumMember := subspace.add_mem liftMember verticalMember
        have pairEquality : lift + (0, pair.2 - lift.2) = pair := by
          apply Prod.ext
          · simpa using firstEquality
          · simp
        rwa [pairEquality] at sumMember
      rw [subspaceFull] at halfDimension
      norm_num [Module.finrank_prod] at halfDimension

/-- Membership in the packet is equivalent to diagonal stability and
four-dimensionality. -/
theorem sixPointThreeHeartStableHalfPacket_iff
    (subspace : Submodule F3 (SixPointThreeHeart × SixPointThreeHeart)) :
    subspace ∈ SixPointThreeHeartStableHalfPacket ↔
      SixPointThreeHeartPairGeneratorStable subspace ∧
        Module.finrank F3 subspace = 4 := by
  constructor
  · rintro ⟨slope, rfl⟩
    exact ⟨sixPointThreeHeartStableHalf_generatorStable slope,
      sixPointThreeHeartStableHalf_finrank slope⟩
  · rintro ⟨stable, dimension⟩
    exact sixPointThreeHeartPair_stableHalf_classification subspace stable dimension

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
