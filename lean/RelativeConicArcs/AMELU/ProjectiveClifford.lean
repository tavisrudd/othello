import RelativeConicArcs.AMELU.UnitaryConjugation
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Algebra.Polynomial.Roots
import Mathlib.Topology.Instances.Matrix

/-!
# Projective finite-field Clifford matrices

For a finite field and a nontrivial complex additive character, the quotient
of the one-site Clifford normalizer by nonzero scalar matrices is finite.
The proof records the exact conjugate of every Weyl matrix.  Its Weyl-axis
label has finitely many choices, while its scalar is constrained by
determinant preservation to lie in a finite polynomial root set.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Matrix Polynomial

noncomputable section

variable {𝔽 : Type*} [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- Multiplication in the finite-field Weyl system, including its central
character factor. -/
theorem weylMatrix_mul (w : WeylConvention 𝔽) (a b c d : 𝔽) :
    weylMatrix w a b * weylMatrix w c d =
      w.character (b * c) • weylMatrix w (a + c) (b + d) := by
  classical
  ext y x
  simp only [Matrix.mul_apply, weylMatrix_apply]
  rw [Finset.sum_eq_single (x + c)]
  · simp only [if_pos]
    rw [show x + c + a = x + (a + c) by ring]
    by_cases hy : y = x + (a + c)
    · subst y
      simp only [Matrix.smul_apply, weylMatrix_apply, if_pos, smul_eq_mul]
      rw [← AddChar.map_add_eq_mul]
      conv_rhs => rw [← AddChar.map_add_eq_mul]
      apply congrArg w.character
      ring
    · simp only [if_neg hy, Matrix.smul_apply, weylMatrix_apply, smul_zero]
      exact zero_mul _
  · intro z _ hz
    by_cases hzx : z = x + c
    · exact (hz hzx).elim
    · simp [hzx]
  · simp

/-- Every Weyl matrix is invertible; an explicit right inverse is another
Weyl matrix times a character value. -/
theorem weylMatrix_mul_inverseCandidate (w : WeylConvention 𝔽) (a b : 𝔽) :
    weylMatrix w a b *
        (w.character (b * a) • weylMatrix w (-a) (-b)) = 1 := by
  rw [Matrix.mul_smul, weylMatrix_mul]
  simp only [add_neg_cancel, weylMatrix_zero_zero]
  rw [smul_smul]
  have harg : b * a + b * -a = 0 := by ring
  rw [← AddChar.map_add_eq_mul, harg]
  simp

/-- A Weyl matrix has nonzero determinant. -/
theorem det_weylMatrix_ne_zero (w : WeylConvention 𝔽) (a b : 𝔽) :
    (weylMatrix w a b).det ≠ 0 := by
  intro hdet
  have h := congrArg Matrix.det (weylMatrix_mul_inverseCandidate w a b)
  rw [Matrix.det_mul, hdet, zero_mul, Matrix.det_one] at h
  exact zero_ne_one h

omit [Field 𝔽] in
/-- Unitary conjugation preserves the determinant of every local matrix. -/
theorem det_unitaryConjugation (U A : LocalMatrix 𝔽)
    (hU : IsUnitaryMatrix U) :
    (U * A * U.conjTranspose).det = A.det := by
  have hdet :=
    congrArg Matrix.det
      (conjTranspose_mul_self_eq_one_of_isUnitaryMatrix hU)
  rw [Matrix.det_mul, Matrix.det_one] at hdet
  rw [Matrix.det_mul, Matrix.det_mul]
  calc
    U.det * A.det * U.conjTranspose.det =
        A.det * (U.conjTranspose.det * U.det) := by ring
    _ = A.det := by rw [hdet, mul_one]

/-- The polynomial whose roots are the possible scalar factors when the
`v`-labelled Weyl matrix is conjugated onto the `u`-labelled Weyl axis. -/
noncomputable def cliffordConjugationScalarPolynomial
    (w : WeylConvention 𝔽) (u v : 𝔽 × 𝔽) : ℂ[X] :=
  C (weylMatrix w u.1 u.2).det * X ^ Fintype.card 𝔽 -
    C (weylMatrix w v.1 v.2).det

/-- The determinant constraint polynomial for two Weyl labels is nonzero. -/
theorem cliffordConjugationScalarPolynomial_ne_zero
    (w : WeylConvention 𝔽) (u v : 𝔽 × 𝔽) :
    cliffordConjugationScalarPolynomial w u v ≠ 0 := by
  intro hzero
  have heval := congrArg (Polynomial.eval 0) hzero
  simp [cliffordConjugationScalarPolynomial, Fintype.card_ne_zero,
    det_weylMatrix_ne_zero] at heval

/-- The scalar in a Clifford conjugation of one Weyl matrix onto another
lies in the corresponding determinant root set. -/
theorem isRoot_cliffordConjugationScalarPolynomial
    (w : WeylConvention 𝔽) (U : LocalMatrix 𝔽)
    (hU : IsUnitaryMatrix U) (u v : 𝔽 × 𝔽) (z : ℂ)
    (hconj :
      U * weylMatrix w v.1 v.2 * U.conjTranspose =
        z • weylMatrix w u.1 u.2) :
    IsRoot (cliffordConjugationScalarPolynomial w u v) z := by
  rw [IsRoot, cliffordConjugationScalarPolynomial]
  have hdet := congrArg Matrix.det hconj
  rw [det_unitaryConjugation U _ hU] at hdet
  rw [Matrix.det_smul] at hdet
  simp only [eval_sub, eval_mul, eval_C, eval_pow, eval_X]
  rw [mul_comm]
  exact sub_eq_zero.mpr hdet.symm

/-- Matrices that can occur as the exact Clifford conjugate of a fixed
Weyl matrix. -/
def cliffordConjugateSet (w : WeylConvention 𝔽) (v : 𝔽 × 𝔽) :
    Set (LocalMatrix 𝔽) :=
  {A | ∃ U, IsCliffordMatrix w U ∧
    A = U * weylMatrix w v.1 v.2 * U.conjTranspose}

/-- A fixed Weyl matrix has only finitely many exact conjugates under the
one-site Clifford normalizer. -/
theorem cliffordConjugateSet_finite
    (w : WeylConvention 𝔽) (v : 𝔽 × 𝔽) :
    (cliffordConjugateSet w v).Finite := by
  classical
  let rootsFor (u : 𝔽 × 𝔽) : Set ℂ :=
    {z | IsRoot (cliffordConjugationScalarPolynomial w u v) z}
  let candidates : Set (LocalMatrix 𝔽) :=
    ⋃ u : 𝔽 × 𝔽,
      (fun z : ℂ => z • weylMatrix w u.1 u.2) '' rootsFor u
  have hroots (u : 𝔽 × 𝔽) : (rootsFor u).Finite :=
    finite_setOf_isRoot
      (cliffordConjugationScalarPolynomial_ne_zero w u v)
  have hcandidates : candidates.Finite :=
    Set.finite_iUnion fun u => (hroots u).image _
  refine hcandidates.subset ?_
  intro A hA
  obtain ⟨U, hClifford, rfl⟩ := hA
  obtain ⟨u₁, u₂, z, hz, hconj⟩ := hClifford.2 v.1 v.2
  refine Set.mem_iUnion.mpr ⟨(u₁, u₂), ?_⟩
  refine ⟨z, ?_, hconj.symm⟩
  exact isRoot_cliffordConjugationScalarPolynomial
    w U hClifford.1 (u₁, u₂) v z hconj

/-- The exact adjoint action of a local matrix on the Weyl basis. -/
noncomputable def cliffordConjugationSignature
    (w : WeylConvention 𝔽) (U : LocalMatrix 𝔽) :
    𝔽 × 𝔽 → LocalMatrix 𝔽 :=
  fun v => U * weylMatrix w v.1 v.2 * U.conjTranspose

/-- Exact adjoint signatures realized by one-site Clifford matrices. -/
def projectiveCliffordSignatureSet (w : WeylConvention 𝔽) :
    Set (𝔽 × 𝔽 → LocalMatrix 𝔽) :=
  {s | ∃ U, IsCliffordMatrix w U ∧
    s = cliffordConjugationSignature w U}

/-- The exact adjoint signatures of one-site Clifford matrices form a finite
set. -/
theorem projectiveCliffordSignatureSet_finite
    (w : WeylConvention 𝔽) :
    (projectiveCliffordSignatureSet w).Finite := by
  classical
  have hpi :
      (Set.pi Set.univ (fun v : 𝔽 × 𝔽 => cliffordConjugateSet w v)).Finite :=
    Set.Finite.pi fun v => cliffordConjugateSet_finite w v
  refine hpi.subset ?_
  intro s hs
  obtain ⟨U, hU, rfl⟩ := hs
  intro v _
  exact ⟨U, hU, rfl⟩

/-- The finite type of exact adjoint signatures of one-site Clifford
matrices.  Equal signatures are precisely equal projective Clifford
transformations. -/
noncomputable def ProjectiveCliffordSignature (w : WeylConvention 𝔽) :=
  {s // s ∈ projectiveCliffordSignatureSet w}
deriving TopologicalSpace, T2Space

noncomputable instance (w : WeylConvention 𝔽) :
    Fintype (ProjectiveCliffordSignature w) :=
  (projectiveCliffordSignatureSet_finite w).fintype

/-- The matrix unit with its only nonzero entry in row `i`, column `j`. -/
def localMatrixUnit (i j : 𝔽) : LocalMatrix 𝔽 :=
  fun r c => if r = i ∧ c = j then 1 else 0

/-- A square matrix commuting with every square matrix is scalar. -/
theorem matrix_eq_smul_one_of_commutes
    (T : LocalMatrix 𝔽) (hcomm : ∀ A : LocalMatrix 𝔽, T * A = A * T) :
    ∃ z : ℂ, T = z • 1 := by
  classical
  refine ⟨T 0 0, ?_⟩
  ext i j
  by_cases hij : i = j
  · subst j
    have hentry :=
      congrFun (congrFun
        (hcomm (localMatrixUnit i 0)) i) 0
    simpa [Matrix.mul_apply, localMatrixUnit] using hentry
  · have hentry :=
      congrFun (congrFun
        (hcomm (localMatrixUnit j j)) i) j
    have hoff : T i j = 0 := by
      simpa [Matrix.mul_apply, localMatrixUnit, hij] using hentry
    simp [hij, hoff]

/-- Two unitaries with the same conjugation on every local matrix differ by
a nonzero scalar. -/
theorem sameMatrixAxis_of_unitaryConjugation_eq
    (U V : LocalMatrix 𝔽) (hU : IsUnitaryMatrix U)
    (hV : IsUnitaryMatrix V)
    (hconj : ∀ A : LocalMatrix 𝔽,
      U * A * U.conjTranspose = V * A * V.conjTranspose) :
    SameMatrixAxis U V := by
  let T := V.conjTranspose * U
  have hcomm (A : LocalMatrix 𝔽) : T * A = A * T := by
    calc
      T * A = V.conjTranspose * (U * A * U.conjTranspose) * U := by
        change (V.conjTranspose * U) * A =
          V.conjTranspose * (U * A * U.conjTranspose) * U
        symm
        calc
          V.conjTranspose * (U * A * U.conjTranspose) * U =
              V.conjTranspose * U * A * (U.conjTranspose * U) := by
                noncomm_ring
          _ = (V.conjTranspose * U) * A := by
            rw [conjTranspose_mul_self_eq_one_of_isUnitaryMatrix hU]
            simp
      _ = V.conjTranspose * (V * A * V.conjTranspose) * U := by
        rw [hconj A]
      _ = A * T := by
        change V.conjTranspose * (V * A * V.conjTranspose) * U =
          A * (V.conjTranspose * U)
        calc
          V.conjTranspose * (V * A * V.conjTranspose) * U =
              (V.conjTranspose * V) * A * V.conjTranspose * U := by
                noncomm_ring
          _ = A * (V.conjTranspose * U) := by
            rw [conjTranspose_mul_self_eq_one_of_isUnitaryMatrix hV]
            simp [Matrix.mul_assoc]
  obtain ⟨z, hzT⟩ := matrix_eq_smul_one_of_commutes T hcomm
  have hUV : U = z • V := by
    calc
      U = (V * V.conjTranspose) * U := by
        rw [self_mul_conjTranspose_eq_one_of_isUnitaryMatrix hV]
        simp
      _ = V * T := by simp [T, Matrix.mul_assoc]
      _ = V * (z • 1) := by rw [hzT]
      _ = z • V := by simp
  refine ⟨z, ?_, hUV⟩
  intro hz
  have hunit := conjTranspose_mul_self_eq_one_of_isUnitaryMatrix hU
  rw [hUV, hz, zero_smul] at hunit
  have hentry := congrFun (congrFun hunit 0) 0
  simp at hentry

/-- Equal exact Weyl-conjugation signatures of two unitaries imply equality
of their nonzero matrix axes. -/
theorem sameMatrixAxis_of_cliffordConjugationSignature_eq
    (w : WeylConvention 𝔽) (U V : LocalMatrix 𝔽)
    (hU : IsUnitaryMatrix U) (hV : IsUnitaryMatrix V)
    (hsig :
      cliffordConjugationSignature w U =
        cliffordConjugationSignature w V) :
    SameMatrixAxis U V := by
  apply sameMatrixAxis_of_unitaryConjugation_eq U V hU hV
  intro A
  let fU := (unitaryConjugationLinearEquiv U hU).toLinearMap
  let fV := (unitaryConjugationLinearEquiv V hV).toLinearMap
  have hmaps : fU = fV := by
    apply (weylBasis w).ext
    intro v
    simpa [fU, fV, unitaryConjugationLinearEquiv,
      cliffordConjugationSignature, weylBasis_apply]
      using congrFun hsig v
  exact LinearMap.congr_fun hmaps A

/-- One-site Clifford matrices as a subtype of local matrices. -/
def CliffordMatrix (w : WeylConvention 𝔽) :=
  {U : LocalMatrix 𝔽 // IsCliffordMatrix w U}

/-- Scalar-axis equivalence on one-site Clifford matrices. -/
def cliffordScalarSetoid (w : WeylConvention 𝔽) :
    Setoid (CliffordMatrix w) where
  r U V := SameMatrixAxis U.1 V.1
  iseqv := by
    constructor
    · intro U
      exact ⟨1, one_ne_zero, by simp⟩
    · intro U V hUV
      obtain ⟨z, hz, hUV⟩ := hUV
      refine ⟨z⁻¹, inv_ne_zero hz, ?_⟩
      rw [hUV, smul_smul]
      simp [hz]
    · intro U V W hUV hVW
      obtain ⟨z, hz, hUV⟩ := hUV
      obtain ⟨t, ht, hVW⟩ := hVW
      refine ⟨z * t, mul_ne_zero hz ht, ?_⟩
      rw [hUV, hVW, smul_smul]

/-- The projective one-site Clifford normalizer: Clifford matrices modulo
nonzero scalar multiplication. -/
def ProjectiveClifford (w : WeylConvention 𝔽) :=
  Quotient (cliffordScalarSetoid w)

/-- A chosen Clifford matrix realizing an exact projective signature. -/
noncomputable def projectiveCliffordSignatureRepresentative
    (w : WeylConvention 𝔽) (s : ProjectiveCliffordSignature w) :
    LocalMatrix 𝔽 :=
  Classical.choose s.property

/-- The chosen signature representative is Clifford. -/
theorem projectiveCliffordSignatureRepresentative_isClifford
    (w : WeylConvention 𝔽) (s : ProjectiveCliffordSignature w) :
    IsCliffordMatrix w (projectiveCliffordSignatureRepresentative w s) :=
  (Classical.choose_spec s.property).1

/-- The chosen representative realizes its prescribed exact adjoint
signature. -/
theorem projectiveCliffordSignatureRepresentative_signature
    (w : WeylConvention 𝔽) (s : ProjectiveCliffordSignature w) :
    s.1 =
      cliffordConjugationSignature w
        (projectiveCliffordSignatureRepresentative w s) :=
  (Classical.choose_spec s.property).2

/-- Map an exact adjoint signature to its projective Clifford class. -/
noncomputable def projectiveCliffordClassOfSignature
    (w : WeylConvention 𝔽) :
    ProjectiveCliffordSignature w → ProjectiveClifford w :=
  fun s => Quotient.mk (cliffordScalarSetoid w)
    ⟨projectiveCliffordSignatureRepresentative w s,
      projectiveCliffordSignatureRepresentative_isClifford w s⟩

/-- Every projective Clifford class is represented by an exact adjoint
signature. -/
theorem projectiveCliffordClassOfSignature_surjective
    (w : WeylConvention 𝔽) :
    Function.Surjective (projectiveCliffordClassOfSignature w) := by
  intro q
  refine Quotient.inductionOn q ?_
  intro U
  let s : ProjectiveCliffordSignature w :=
    ⟨cliffordConjugationSignature w U.1, U.1, U.2, rfl⟩
  refine ⟨s, ?_⟩
  change
    Quotient.mk (cliffordScalarSetoid w)
        (⟨projectiveCliffordSignatureRepresentative w s,
          projectiveCliffordSignatureRepresentative_isClifford w s⟩ :
          CliffordMatrix w) =
      Quotient.mk (cliffordScalarSetoid w) U
  apply Quotient.sound
  apply sameMatrixAxis_of_cliffordConjugationSignature_eq w
    (projectiveCliffordSignatureRepresentative w s) U.1
    (projectiveCliffordSignatureRepresentative_isClifford w s).1 U.2.1
  exact (projectiveCliffordSignatureRepresentative_signature w s).symm

/-- The projective one-site Clifford normalizer over a finite field is
finite. -/
noncomputable instance projectiveClifford_finite
    (w : WeylConvention 𝔽) : Finite (ProjectiveClifford w) :=
  Finite.of_surjective (projectiveCliffordClassOfSignature w)
    (projectiveCliffordClassOfSignature_surjective w)

end

end RelativeConicArcs.AMELU
