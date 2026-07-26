import RelativeConicArcs.AMELU.GenericLURigidity
import RelativeConicArcs.AMELU.LogicalPhase
import RelativeConicArcs.AMELU.ProductUnitaryAutomorphismGroup

/-!
# One-leg encoders and transversal Clifford actions

An equal-phase state from a linear `[2m,m,m+1]` MDS code can be read as the
normalized Choi state of a one-qudit encoder on `2m-1` output qudits.  This
module fixes the corresponding parameter, action, and transpose conventions.
It then transfers length-generic local-unitary rigidity to conversions between
two such encoders.

The exact generalized Reed--Solomon conclusion is stated for the affine
special-linear carrier `𝔽² × SL₂(𝔽)`.  `GRSTransversalInputs` separates the
constructive containment, obtained from dual multipliers and the two elementary
unipotent families, from the converse supplied by the encoder rigidity
theorem.  No existence or propagation assertion is introduced as an axiom.

All arguments are symbolic and kernel checked.  This module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open Matrix Set
open scoped ComplexConjugate

noncomputable section

variable {m : ℕ} {𝔽 : Type*}
  [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- Numerical parameters of a one-logical-qudit quantum code. -/
structure OneLogicalQuditCodeParameters where
  /-- Number of physical qudits. -/
  physicalLength : ℕ
  /-- Number of logical qudits. -/
  logicalDimension : ℕ
  /-- Quantum-code distance. -/
  distance : ℕ

/-- The physical length, logical dimension, and distance obtained by reading
one leg of a length-`2m` AME tensor as the input of an encoder. -/
def oneLegQuantumMDSParameters (m : ℕ) : OneLogicalQuditCodeParameters where
  physicalLength := 2 * m - 1
  logicalDimension := 1
  distance := m

/-- The one-leg parameters saturate the one-logical-qudit quantum Singleton
equality `n - 1 = 2(d - 1)`. -/
theorem oneLegQuantumMDSParameters_singletonEquality
    (hm : 1 ≤ m) :
    let p := oneLegQuantumMDSParameters m
    p.physicalLength - p.logicalDimension =
      2 * (p.distance - 1) := by
  simp [oneLegQuantumMDSParameters]
  omega

omit [Fintype 𝔽] in
/-- An exact `[2m,m,m+1]` code supplies the advertised
`[[2m-1,1,m]]` numerical parameter bridge. -/
theorem isMDSCode2m_oneLegQuantumMDSParameters
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (hC : IsMDSCode2m C) :
    Module.finrank 𝔽 C = m ∧
      FiniteGeom.minDist C = m + 1 ∧
      (oneLegQuantumMDSParameters m).physicalLength = 2 * m - 1 ∧
      (oneLegQuantumMDSParameters m).logicalDimension = 1 ∧
      (oneLegQuantumMDSParameters m).distance = m := by
  exact ⟨hC.1, hC.2, rfl, rfl, rfl⟩

/-- A family whose distinguished coordinate carries the logical matrix and
whose other coordinates carry the physical tensor factors. -/
def oneLegFactorFamily
    (input : GenericParty m)
    (L : LocalMatrix 𝔽)
    (U : {i : GenericParty m // i ≠ input} → LocalMatrix 𝔽) :
    GenericParty m → LocalMatrix 𝔽 :=
  fun i => if h : i = input then L else U ⟨i, h⟩

omit [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽] in
@[simp]
theorem oneLegFactorFamily_input
    (input : GenericParty m)
    (L : LocalMatrix 𝔽)
    (U : {i : GenericParty m // i ≠ input} → LocalMatrix 𝔽) :
    oneLegFactorFamily input L U input = L := by
  simp [oneLegFactorFamily]

omit [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽] in
@[simp]
theorem oneLegFactorFamily_physical
    (input : GenericParty m)
    (L : LocalMatrix 𝔽)
    (U : {i : GenericParty m // i ≠ input} → LocalMatrix 𝔽)
    (i : {i : GenericParty m // i ≠ input}) :
    oneLegFactorFamily input L U i = U i := by
  simp [oneLegFactorFamily, i.property]

omit [Field 𝔽] in
/-- For a finite coordinate space, an invertible linear map that carries
every nonzero coordinate axis to a coordinate axis has the same property in
the reverse direction. -/
theorem coordinateAxes_reflected_by_linearEquiv
    {κ : Type*} [Fintype κ] [DecidableEq κ]
    (A : (κ → ℂ) ≃ₗ[ℂ] (κ → ℂ))
    (haxes :
      ∀ x, IsNonzeroCoordinateAxis x →
        IsNonzeroCoordinateAxis (A x)) :
    ∀ x, IsNonzeroCoordinateAxis x →
      IsNonzeroCoordinateAxis (A.symm x) := by
  classical
  let target : κ → κ :=
    fun i => Classical.choose
      (haxes (coordinateVector i 1)
        ⟨i, 1, one_ne_zero, rfl⟩)
  have htarget :
      ∀ i, ∃ z, z ≠ 0 ∧
        A (coordinateVector i 1) =
          coordinateVector (target i) z := by
    intro i
    let h :=
      haxes (coordinateVector i 1)
        ⟨i, 1, one_ne_zero, rfl⟩
    exact
      ⟨Classical.choose h.choose_spec,
        h.choose_spec.choose_spec.1,
        h.choose_spec.choose_spec.2⟩
  have hinjective : Function.Injective target := by
    intro i j hij
    obtain ⟨z, hz, hi⟩ := htarget i
    obtain ⟨t, ht, hj⟩ := htarget j
    have hscaled :
        A (coordinateVector i 1) =
          (z * t⁻¹) • A (coordinateVector j 1) := by
      rw [hi, hj, hij]
      ext k
      by_cases hk : k = target j
      · subst k
        simp [coordinateVector, ht]
      · simp [coordinateVector, hk]
    have hpre :
        coordinateVector i 1 =
          (z * t⁻¹) • coordinateVector j 1 := by
      apply A.injective
      simpa using hscaled
    by_contra hij'
    have hiapply := congrFun hpre i
    simp [coordinateVector, hij'] at hiapply
  have hsurjective : Function.Surjective target :=
    (Finite.injective_iff_surjective).mp hinjective
  intro x hx
  obtain ⟨j, z, hz, rfl⟩ := hx
  obtain ⟨i, hi⟩ := hsurjective j
  obtain ⟨t, ht, hit⟩ := htarget i
  have hpre :
      A.symm (coordinateVector j z) =
        coordinateVector i (z * t⁻¹) := by
    apply A.injective
    rw [A.apply_symm_apply]
    have hcoord :
        coordinateVector i (z * t⁻¹) =
          (z * t⁻¹) • coordinateVector i 1 := by
      ext k
      simp [coordinateVector]
    rw [hcoord, map_smul, hit, hi]
    ext k
    by_cases hk : k = j
    · subst k
      simp [coordinateVector, ht]
    · simp [coordinateVector, hk]
  exact ⟨i, z * t⁻¹, mul_ne_zero hz (inv_ne_zero ht), hpre⟩

/-- The adjoint of a finite-field Clifford matrix is Clifford.  This is the
inverse-closure step for the projective Weyl normalizer. -/
theorem IsCliffordMatrix.conjTranspose
    (w : WeylConvention 𝔽) {U : LocalMatrix 𝔽}
    (hU : IsCliffordMatrix w U) :
    IsCliffordMatrix w U.conjTranspose := by
  let e := unitaryConjugationWeylEquiv w U hU.1
  have hforward :
      ∀ x, IsNonzeroCoordinateAxis x →
        IsNonzeroCoordinateAxis (e x) := by
    rintro _ ⟨v, z, hz, rfl⟩
    have hbase :
        IsNonzeroCoordinateAxis (e (coordinateVector v 1)) := by
      obtain ⟨a, b, hab⟩ := hU.2 v.1 v.2
      have haxis :
          IsNonzeroCoordinateAxis
            (weylCoordinateEquiv w
              (matrixProduct
                (matrixProduct U (weylMatrix w v.1 v.2))
                U.conjTranspose)) := by
        obtain ⟨t, ht, heq⟩ :=
          (weylCoordinate_axis_iff_sameMatrixAxis w
            (matrixProduct
              (matrixProduct U (weylMatrix w v.1 v.2))
              U.conjTranspose) (a, b)).2 hab
        exact ⟨(a, b), t, ht, heq⟩
      rw [← weylCoordinateEquiv_weylMatrix w v]
      simpa [e, unitaryConjugationWeylEquiv,
        unitaryConjugationLinearEquiv, matrixProduct] using haxis
    obtain ⟨j, t, ht, hbase⟩ := hbase
    refine ⟨j, z * t, mul_ne_zero hz ht, ?_⟩
    have hcoord :
        coordinateVector v z = z • coordinateVector v 1 := by
      ext k
      simp [coordinateVector]
    rw [hcoord, map_smul, hbase]
    ext k
    simp [coordinateVector]
  have hback :
      ∀ x, IsNonzeroCoordinateAxis x →
        IsNonzeroCoordinateAxis (e.symm x) :=
    coordinateAxes_reflected_by_linearEquiv e hforward
  have hadjoint : IsUnitaryMatrix U.conjTranspose :=
    hU.1.conjTranspose
  apply isCliffordMatrix_of_weylCoordinate_axes
    w U.conjTranspose hadjoint
  intro v
  have hv :=
    hback (coordinateVector v 1)
      ⟨v, 1, one_ne_zero, rfl⟩
  have heq :
      unitaryConjugationWeylEquiv w U.conjTranspose hadjoint
        (coordinateVector v 1) =
      e.symm (coordinateVector v 1) := by
    apply (weylCoordinateEquiv w).symm.injective
    simp [e, unitaryConjugationWeylEquiv,
      unitaryConjugationLinearEquiv]
  rwa [← heq] at hv

/-- Entrywise complex conjugation of a local matrix. -/
def conjugateLocalMatrix (U : LocalMatrix 𝔽) : LocalMatrix 𝔽 :=
  U.conjTranspose.transpose

omit [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽] in
@[simp]
theorem conjugateLocalMatrix_apply
    (U : LocalMatrix 𝔽) (x y : 𝔽) :
    conjugateLocalMatrix U x y = conj (U x y) := by
  simp [conjugateLocalMatrix, Matrix.conjTranspose_apply]

omit [Field 𝔽] [DecidableEq 𝔽] in
/-- Entrywise conjugation preserves matrix products. -/
theorem conjugateLocalMatrix_mul
    (U V : LocalMatrix 𝔽) :
    conjugateLocalMatrix (U * V) =
      conjugateLocalMatrix U * conjugateLocalMatrix V := by
  ext x y
  simp [Matrix.mul_apply, map_sum, map_mul]

omit [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Entrywise conjugation commutes with the adjoint. -/
theorem conjugateLocalMatrix_conjTranspose
    (U : LocalMatrix 𝔽) :
    conjugateLocalMatrix U.conjTranspose =
      (conjugateLocalMatrix U).conjTranspose := by
  ext x y
  simp [conjugateLocalMatrix, Matrix.conjTranspose_apply]

omit [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Entrywise conjugation conjugates complex scalar multiplication. -/
theorem conjugateLocalMatrix_smul
    (z : ℂ) (U : LocalMatrix 𝔽) :
    conjugateLocalMatrix (z • U) =
      conj z • conjugateLocalMatrix U := by
  ext x y
  simp

omit [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Conjugating twice recovers the original matrix. -/
@[simp]
theorem conjugateLocalMatrix_conjugateLocalMatrix
    (U : LocalMatrix 𝔽) :
    conjugateLocalMatrix (conjugateLocalMatrix U) = U := by
  ext x y
  simp

/-- Entrywise conjugation sends `W(a,b)` to `W(a,-b)`. -/
theorem conjugateLocalMatrix_weylMatrix
    (w : WeylConvention 𝔽) (a b : 𝔽) :
    conjugateLocalMatrix (weylMatrix w a b) =
      weylMatrix w a (-b) := by
  ext y x
  by_cases h : y = x + a
  · simp only [conjugateLocalMatrix_apply, weylMatrix_apply, h, if_true,
      neg_mul]
    rw [← AddChar.map_neg_eq_conj]
  · simp [weylMatrix, h]

omit [Field 𝔽] in
/-- Entrywise conjugation preserves column unitarity. -/
theorem IsUnitaryMatrix.conjugateLocalMatrix
    {U : LocalMatrix 𝔽} (hU : IsUnitaryMatrix U) :
    IsUnitaryMatrix (conjugateLocalMatrix U) := by
  apply isUnitaryMatrix_of_conjTranspose_mul_self_eq_one
  rw [← conjugateLocalMatrix_conjTranspose,
    ← conjugateLocalMatrix_mul,
    conjTranspose_mul_self_eq_one_of_isUnitaryMatrix hU]
  ext x y
  simp [Matrix.one_apply]

omit [Field 𝔽] in
/-- Transposition preserves column unitarity. -/
theorem IsUnitaryMatrix.transpose
    {U : LocalMatrix 𝔽} (hU : IsUnitaryMatrix U) :
    IsUnitaryMatrix U.transpose := by
  have h := hU.conjTranspose.conjugateLocalMatrix
  have heq :
      RelativeConicArcs.AMELU.conjugateLocalMatrix U.conjTranspose =
        U.transpose := by
    ext x y
    simp
  rwa [heq] at h

/-- Entrywise conjugation preserves the finite-field Clifford normalizer. -/
theorem IsCliffordMatrix.conjugate
    (w : WeylConvention 𝔽) {U : LocalMatrix 𝔽}
    (hU : IsCliffordMatrix w U) :
    IsCliffordMatrix w (conjugateLocalMatrix U) := by
  refine ⟨hU.1.conjugateLocalMatrix, ?_⟩
  intro a b
  obtain ⟨c, d, z, hz, hconj⟩ := hU.2 a (-b)
  refine ⟨c, -d, conj z, (map_ne_zero (starRingEnd ℂ)).2 hz, ?_⟩
  have hmatrix := congrArg conjugateLocalMatrix hconj
  simpa [matrixProduct, conjugateLocalMatrix_mul,
    conjugateLocalMatrix_conjTranspose,
    conjugateLocalMatrix_weylMatrix,
    conjugateLocalMatrix_smul] using hmatrix

/-- Transposition preserves the finite-field Clifford normalizer. -/
theorem IsCliffordMatrix.transpose
    (w : WeylConvention 𝔽) {U : LocalMatrix 𝔽}
    (hU : IsCliffordMatrix w U) :
    IsCliffordMatrix w U.transpose := by
  have h := (hU.conjTranspose w).conjugate w
  have heq : conjugateLocalMatrix U.conjTranspose = U.transpose := by
    ext x y
    simp [conjugateLocalMatrix]
  rw [heq] at h
  exact h

/-- The normalized Choi conversion equation in row-output, column-input
convention.  The physical action on the source equals the logical transpose
on the distinguished leg of the target:
`(I ⊗ U_phys) Ψ_C = (Lᵀ ⊗ I) Ψ_D`. -/
def NormalizedChoiEncoderConversion
    (input : GenericParty m)
    (C D : Submodule 𝔽 (GenericBasisLabel m 𝔽))
    (L : LocalMatrix 𝔽)
    (U : {i : GenericParty m // i ≠ input} → LocalMatrix 𝔽) : Prop :=
  genericLocalAction
      (oneLegFactorFamily input 1 U) (genericEqualPhaseState C) =
    genericLocalAction
      (oneLegFactorFamily input L.transpose (fun _ => 1))
      (genericEqualPhaseState D)

/-- Exact inverse-transpose data for a logical matrix.  For a unitary logical
matrix the canonical witness is its entrywise complex conjugate. -/
structure InverseTransposeWitness (L : LocalMatrix 𝔽) where
  /-- The matrix denoted `(Lᵀ)⁻¹`. -/
  inverseTranspose : LocalMatrix 𝔽
  /-- Left inverse identity for the displayed transpose. -/
  inverseTranspose_mul_transpose :
    inverseTranspose * L.transpose = 1
  /-- Right inverse identity for the displayed transpose. -/
  transpose_mul_inverseTranspose :
    L.transpose * inverseTranspose = 1
  /-- The inverse transpose is unitary. -/
  inverseTranspose_unitary : IsUnitaryMatrix inverseTranspose

/-- A unitary logical matrix has the canonical inverse-transpose witness
`(Lᵀ)ᴴ`. -/
def inverseTransposeWitness_of_isUnitaryMatrix
    (L : LocalMatrix 𝔽) (hL : IsUnitaryMatrix L) :
    InverseTransposeWitness L where
  inverseTranspose := L.transpose.conjTranspose
  inverseTranspose_mul_transpose :=
    conjTranspose_mul_self_eq_one_of_isUnitaryMatrix hL.transpose
  transpose_mul_inverseTranspose :=
    self_mul_conjTranspose_eq_one_of_isUnitaryMatrix hL.transpose
  inverseTranspose_unitary := hL.transpose.conjTranspose

/-- Data needed to turn a two-encoder conversion into the exact product action
to which the AME rigidity theorem applies. -/
structure EncoderConversionInputs
    (input : GenericParty m)
    (C D : Submodule 𝔽 (GenericBasisLabel m 𝔽))
    (L : LocalMatrix 𝔽)
    (U : {i : GenericParty m // i ≠ input} → LocalMatrix 𝔽) where
  /-- The source code has exact MDS parameters. -/
  source_mds : IsMDSCode2m C
  /-- The target code has exact MDS parameters. -/
  target_mds : IsMDSCode2m D
  /-- Every physical tensor factor is unitary. -/
  physical_unitary : ∀ i, IsUnitaryMatrix (U i)
  /-- The logical matrix is unitary. -/
  logical_unitary : IsUnitaryMatrix L
  /-- The forward normalized Choi conversion equation. -/
  choi_conversion : NormalizedChoiEncoderConversion input C D L U

/-- The exact inverse-transpose Choi orientation:
`((Lᵀ)⁻¹ ⊗ U_phys) Ψ_C = Ψ_D`. -/
theorem encoderConversion_inverseTranspose_chosenLeg
    (input : GenericParty m)
    {C D : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (L : LocalMatrix 𝔽)
    (U : {i : GenericParty m // i ≠ input} → LocalMatrix 𝔽)
    (inputs : EncoderConversionInputs input C D L U) :
    genericLocalAction
        (oneLegFactorFamily input
          L.transpose.conjTranspose U)
        (genericEqualPhaseState C) =
      genericEqualPhaseState D := by
  let witness :=
    inverseTransposeWitness_of_isUnitaryMatrix L inputs.logical_unitary
  let LinvT := L.transpose.conjTranspose
  let leftInverse : GenericParty m → LocalMatrix 𝔽 :=
    oneLegFactorFamily input LinvT (fun _ => 1)
  have hcompose :
      (fun i =>
          leftInverse i * oneLegFactorFamily input (1 : LocalMatrix 𝔽) U i) =
        oneLegFactorFamily input LinvT U := by
    funext i
    by_cases hi : i = input
    · subst i
      simp [leftInverse]
    · simp [leftInverse, oneLegFactorFamily, hi]
  have hcancel :
      (fun i =>
          leftInverse i *
            oneLegFactorFamily input L.transpose (fun _ => 1) i) =
        (1 : GenericParty m → LocalMatrix 𝔽) := by
    funext i
    by_cases hi : i = input
    · subst i
      simpa [leftInverse, LinvT, witness,
        inverseTransposeWitness_of_isUnitaryMatrix] using
        witness.inverseTranspose_mul_transpose
    · simp [leftInverse, oneLegFactorFamily, hi]
  calc
    genericLocalAction
        (oneLegFactorFamily input LinvT U)
        (genericEqualPhaseState C) =
        genericLocalAction leftInverse
          (genericLocalAction
            (oneLegFactorFamily input 1 U)
            (genericEqualPhaseState C)) := by
              rw [← genericLocalAction_mul, hcompose]
    _ = genericLocalAction leftInverse
          (genericLocalAction
            (oneLegFactorFamily input L.transpose (fun _ => 1))
            (genericEqualPhaseState D)) := by
              rw [inputs.choi_conversion]
    _ = genericLocalAction (1 : GenericParty m → LocalMatrix 𝔽)
          (genericEqualPhaseState D) := by
              rw [← genericLocalAction_mul, hcancel]
    _ = genericEqualPhaseState D := genericLocalAction_one _

/-- Every displayed factor in a two-encoder conversion is Clifford after
placing `(Lᵀ)⁻¹` on the distinguished input leg. -/
theorem encoderConversion_inverseTranspose_and_physical_isClifford
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    (input : GenericParty m)
    {C D : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (L : LocalMatrix 𝔽)
    (U : {i : GenericParty m // i ≠ input} → LocalMatrix 𝔽)
    (inputs : EncoderConversionInputs input C D L U) :
    IsCliffordMatrix w L.transpose.conjTranspose ∧
      ∀ i, IsCliffordMatrix w (U i) := by
  let factors :=
    oneLegFactorFamily input
      L.transpose.conjTranspose U
  have hunitary : ∀ i, IsUnitaryMatrix (factors i) := by
    intro i
    by_cases hi : i = input
    · subst i
      simpa [factors] using
        inputs.logical_unitary.transpose.conjTranspose
    · simpa [factors, oneLegFactorFamily, hi] using
        inputs.physical_unitary ⟨i, hi⟩
  have hcliff :=
    generic_all_isClifford_of_localAction_equalPhaseState
      hm w inputs.source_mds inputs.target_mds factors hunitary 1
      (by simp)
      (by
        simpa [factors] using
          encoderConversion_inverseTranspose_chosenLeg
            input L U inputs)
  constructor
  · simpa [factors] using hcliff input
  · intro i
    simpa [factors, oneLegFactorFamily, i.property] using hcliff i

/-- A transversal conversion between two associated one-leg encoders is
Clifford on the logical qudit and on every physical qudit. -/
theorem encoderConversion_logical_and_physical_isClifford
    (hm : 2 ≤ m) (w : WeylConvention 𝔽)
    (input : GenericParty m)
    {C D : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (L : LocalMatrix 𝔽)
    (U : {i : GenericParty m // i ≠ input} → LocalMatrix 𝔽)
    (inputs : EncoderConversionInputs input C D L U) :
    IsCliffordMatrix w L ∧
      ∀ i, IsCliffordMatrix w (U i) := by
  obtain ⟨hLinvT, hphysical⟩ :=
    encoderConversion_inverseTranspose_and_physical_isClifford
      hm w input L U inputs
  have hLt : IsCliffordMatrix w L.transpose := by
    simpa using hLinvT.conjTranspose w
  exact ⟨hLt.transpose w, hphysical⟩

/-- Coordinatewise multiplication by nonzero duality multipliers. -/
def scaleGenericLabel
    (s : GenericParty m → 𝔽ˣ)
    (x : GenericBasisLabel m 𝔽) :
    GenericBasisLabel m 𝔽 :=
  fun i => (s i : 𝔽) * x i

/-- Coordinatewise multiplication by the inverse duality multipliers. -/
def inverseScaleGenericLabel
    (s : GenericParty m → 𝔽ˣ)
    (x : GenericBasisLabel m 𝔽) :
    GenericBasisLabel m 𝔽 :=
  fun i => ((s i)⁻¹ : 𝔽ˣ) * x i

/-- A diagonal self-duality witness `S C = Cᗮ` for a half-dimensional
code, stated in both directions needed by the lower and upper shears. -/
structure GenericDiagonalDuality
    (C : Submodule 𝔽 (GenericBasisLabel m 𝔽)) where
  /-- Nonzero diagonal entries. -/
  multiplier : GenericParty m → 𝔽ˣ
  /-- Multiplication by `S` identifies the code with its dual. -/
  scale_mem_dual_iff :
    ∀ x, scaleGenericLabel multiplier x ∈ FiniteGeom.dualCode C ↔ x ∈ C
  /-- Multiplication by `S⁻¹` identifies the dual with the code. -/
  inverseScale_mem_code_iff :
    ∀ x, inverseScaleGenericLabel multiplier x ∈ C ↔
      x ∈ FiniteGeom.dualCode C

/-- The lower dual-multiplier shear on the generic CSS label space. -/
def lowerDualityShear
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (duality : GenericDiagonalDuality C) (a : 𝔽)
    (p : GenericBasisLabel m 𝔽 × GenericBasisLabel m 𝔽) :
    GenericBasisLabel m 𝔽 × GenericBasisLabel m 𝔽 :=
  (p.1, p.2 + a • scaleGenericLabel duality.multiplier p.1)

/-- The upper inverse-dual-multiplier shear on the generic CSS label space. -/
def upperDualityShear
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (duality : GenericDiagonalDuality C) (μ : 𝔽)
    (p : GenericBasisLabel m 𝔽 × GenericBasisLabel m 𝔽) :
    GenericBasisLabel m 𝔽 × GenericBasisLabel m 𝔽 :=
  (p.1 + μ • inverseScaleGenericLabel duality.multiplier p.2, p.2)

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Every lower dual-multiplier shear preserves `C × Cᗮ`. -/
theorem genericCSSLabel_lowerDualityShear
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (duality : GenericDiagonalDuality C) (a : 𝔽)
    {p : GenericBasisLabel m 𝔽 × GenericBasisLabel m 𝔽}
    (hp : GenericCSSLabel C p) :
    GenericCSSLabel C (lowerDualityShear duality a p) := by
  refine ⟨hp.1, (FiniteGeom.dualCode C).add_mem hp.2 ?_⟩
  exact (FiniteGeom.dualCode C).smul_mem a
    ((duality.scale_mem_dual_iff p.1).2 hp.1)

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Every upper inverse-dual-multiplier shear preserves `C × Cᗮ`. -/
theorem genericCSSLabel_upperDualityShear
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (duality : GenericDiagonalDuality C) (μ : 𝔽)
    {p : GenericBasisLabel m 𝔽 × GenericBasisLabel m 𝔽}
    (hp : GenericCSSLabel C p) :
    GenericCSSLabel C (upperDualityShear duality μ p) := by
  refine ⟨C.add_mem hp.1 ?_, hp.2⟩
  exact C.smul_mem μ
    ((duality.inverseScale_mem_code_iff p.2).2 hp.2)

/-- The lower elementary unipotent in `SL₂(𝔽)`. -/
def lowerUnipotent (r : 𝔽) : LogicalBlock 𝔽 :=
  !![1, 0; r, 1]

/-- The upper elementary unipotent in `SL₂(𝔽)`. -/
def upperUnipotent (r : 𝔽) : LogicalBlock 𝔽 :=
  !![1, r; 0, 1]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Every lower elementary unipotent has determinant one. -/
theorem lowerUnipotent_isSpecialLinear (r : 𝔽) :
    IsSpecialLinearBlock (lowerUnipotent r) := by
  simp [IsSpecialLinearBlock, lowerUnipotent, Matrix.det_fin_two]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Every upper elementary unipotent has determinant one. -/
theorem upperUnipotent_isSpecialLinear (r : 𝔽) :
    IsSpecialLinearBlock (upperUnipotent r) := by
  simp [IsSpecialLinearBlock, upperUnipotent, Matrix.det_fin_two]

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- At any chosen input leg, the lower dual-multiplier family realizes every
lower elementary unipotent coefficient. -/
theorem exists_lowerDuality_parameter
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (duality : GenericDiagonalDuality C)
    (input : GenericParty m) (r : 𝔽) :
    ∃ a : 𝔽, a * (duality.multiplier input : 𝔽) = r := by
  refine
    ⟨r * (↑((duality.multiplier input)⁻¹) : 𝔽), ?_⟩
  rw [mul_assoc]
  simp

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- At any chosen input leg, the upper inverse-dual-multiplier family realizes
every upper elementary unipotent coefficient. -/
theorem exists_upperDuality_parameter
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    (duality : GenericDiagonalDuality C)
    (input : GenericParty m) (r : 𝔽) :
    ∃ μ : 𝔽, μ * ((duality.multiplier input)⁻¹ : 𝔽ˣ) = r := by
  refine ⟨r * (↑(duality.multiplier input) : 𝔽), ?_⟩
  rw [mul_assoc]
  simp

/-- A projective one-qudit affine action on Pauli labels.  Its translation
records the logical Weyl operator and its linear block records conjugation on
the two-dimensional label plane. -/
structure ProjectiveLogicalAction (𝔽 : Type*) [Field 𝔽] where
  /-- Logical Weyl translation. -/
  translation : 𝔽 × 𝔽
  /-- Linear action on Pauli labels. -/
  linear : LogicalBlock 𝔽

/-- The affine special-linear subset `𝔽² ⋊ SL₂(𝔽)` of projective affine
logical actions. -/
def affineSpecialLinearSet :
    Set (ProjectiveLogicalAction 𝔽) :=
  {g | IsSpecialLinearBlock g.linear}

/-- The affine split-torus subset `𝔽² ⋊ T` of projective logical actions. -/
def affineSplitTorusSet :
    Set (ProjectiveLogicalAction 𝔽) :=
  {g | IsSplitTorusBlock g.linear}

/-- Data identifying a fixed-party projective logical carrier from its linear
kernel.  Membership depends exactly on the linear block, so every logical Weyl
translation occurs over every realized linear block. -/
structure FixedPartyProjectiveTransversalInputs
    (transversal : Set (ProjectiveLogicalAction 𝔽))
    (isConic : Prop) where
  /-- The realized linear fixed-party kernel. -/
  kernel : Set (LogicalBlock 𝔽)
  /-- The geometric full-special-linear versus split-torus dichotomy. -/
  logicalPhase : LogicalPhaseInputs 𝔽 kernel isConic
  /-- The projective carrier is the complete affine fiber over the linear
  kernel. -/
  transversal_iff_linear_mem :
    ∀ g, g ∈ transversal ↔ g.linear ∈ kernel

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- The exact fixed-party projective logical carrier is `𝔽² ⋊ SL₂(𝔽)` on
the conic locus and `𝔽² ⋊ T` off it. -/
theorem fixedPartyProjectiveTransversal_eq_affineSpecialLinear_or_splitTorus
    {transversal : Set (ProjectiveLogicalAction 𝔽)}
    {isConic : Prop}
    (inputs : FixedPartyProjectiveTransversalInputs transversal isConic) :
    (isConic → transversal = affineSpecialLinearSet) ∧
    (¬ isConic → transversal = affineSplitTorusSet) := by
  obtain ⟨hconic, hnonconic⟩ :=
    fixedPartyKernel_eq_specialLinear_or_splitTorus inputs.logicalPhase
  constructor
  · intro hc
    have hk := hconic hc
    ext g
    rw [inputs.transversal_iff_linear_mem, hk]
    rfl
  · intro hnc
    have hk := hnonconic hnc
    ext g
    rw [inputs.transversal_iff_linear_mem, hk]
    rfl

/-- A pure logical Weyl translation. -/
def projectiveLogicalTranslation (v : 𝔽 × 𝔽) :
    ProjectiveLogicalAction 𝔽 where
  translation := v
  linear := 1

/-- A projective logical action with zero translation and prescribed linear
block. -/
def projectiveLogicalLinearAction (A : LogicalBlock 𝔽) :
    ProjectiveLogicalAction 𝔽 where
  translation := 0
  linear := A

/-- The two containments required to identify the projective transversal
logical group of a half-dimensional generalized Reed--Solomon encoder.
The forward field is the dual-multiplier/unipotent construction; the reverse
field is the factorwise transversal Clifford no-go. -/
structure GRSTransversalInputs
    (C : Submodule 𝔽 (GenericBasisLabel m 𝔽))
    (transversal : Set (ProjectiveLogicalAction 𝔽)) where
  /-- The GRS dual-multiplier identity `S C = Cᗮ`. -/
  diagonalDuality : GenericDiagonalDuality C
  /-- Every logical Weyl translation has a product-Pauli representative. -/
  logicalTranslations_transversal :
    ∀ v, projectiveLogicalTranslation v ∈ transversal
  /-- The lower dual-multiplier shear, with its stabilizer phase corrected,
  realizes every lower elementary unipotent. -/
  lowerUnipotents_transversal :
    ∀ r, projectiveLogicalLinearAction (lowerUnipotent r) ∈ transversal
  /-- The upper inverse-dual-multiplier shear, with its stabilizer phase
  corrected, realizes every upper elementary unipotent. -/
  upperUnipotents_transversal :
    ∀ r, projectiveLogicalLinearAction (upperUnipotent r) ∈ transversal
  /-- Weyl translations and the two elementary unipotent families generate
  the complete affine special-linear carrier. -/
  affineSpecialLinear_generated :
    (∀ v, projectiveLogicalTranslation v ∈ transversal) →
    (∀ r, projectiveLogicalLinearAction (lowerUnipotent r) ∈ transversal) →
    (∀ r, projectiveLogicalLinearAction (upperUnipotent r) ∈ transversal) →
      affineSpecialLinearSet ⊆ transversal
  /-- Every projective transversal logical action is affine special linear. -/
  transversal_subset_affineSpecialLinear :
    transversal ⊆ affineSpecialLinearSet

omit [Fintype 𝔽] [DecidableEq 𝔽] in
/-- Under the explicit GRS construction and encoder-rigidity containments,
the projective transversal logical group is exactly `𝔽² ⋊ SL₂(𝔽)` as a
carrier. -/
theorem grs_projectiveTransversal_eq_affineSpecialLinear
    {C : Submodule 𝔽 (GenericBasisLabel m 𝔽)}
    {transversal : Set (ProjectiveLogicalAction 𝔽)}
    (inputs : GRSTransversalInputs C transversal) :
    transversal = affineSpecialLinearSet := by
  exact Set.Subset.antisymm
    inputs.transversal_subset_affineSpecialLinear
    (inputs.affineSpecialLinear_generated
      inputs.logicalTranslations_transversal
      inputs.lowerUnipotents_transversal
      inputs.upperUnipotents_transversal)

/-- The order formula for the affine special-linear projective Clifford group
over a prime field of cardinality `q`. -/
def affineSpecialLinearOrder (q : ℕ) : ℕ :=
  q ^ 2 * (q * (q ^ 2 - 1))

/-- The `AME(8,7)` / `[[7,1,4]]₇` specialization has projective transversal
logical group order `16464`. -/
theorem affineSpecialLinearOrder_seven :
    affineSpecialLinearOrder 7 = 16464 := by
  norm_num [affineSpecialLinearOrder]

end

end RelativeConicArcs.AMELU
