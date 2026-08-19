import Mathlib.LinearAlgebra.Determinant
import Mathlib.LinearAlgebra.FreeModule.Finite.CardQuotient
import Mathlib.LinearAlgebra.Matrix.Adjugate
import Mathlib.LinearAlgebra.Matrix.ToLin

/-!
# Discriminant groups of integral alternating lattices

Let `Λ = ℤ^ι` carry the pairing `E(x,y) = xᵀ F y` of an integral square matrix
`F` with nonzero determinant, and let
`Λ^# = {v ∈ ℚ^ι : E(x,v) ∈ ℤ for every x ∈ Λ}` be the dual lattice.  Sending a
rational vector `v` to the integral vector `F v` is an isomorphism from `Λ^#`
onto `ℤ^ι` carrying `Λ` onto the image lattice `F ℤ^ι`, so the discriminant
group `Λ^#/Λ` is the cokernel of `F` on the standard lattice.  That cokernel is
the model used here, and `discriminantGroup` names it.

Under the same identification the discriminant pairing
`Λ^#/Λ × Λ^#/Λ → ℚ/ℤ`, `(v,w) ↦ E(v,w) mod ℤ`, is
`(x,y) ↦ (1/det F)·xᵀ adj(F) y mod ℤ` on representatives, because
`F adj(F) = adj(F) F = det F`.  That expression is `discriminantValue`, and
`discriminantPairing` is the bilinear map it induces on the cokernel.  It
descends in the second variable for every `F`, and in the first variable when
`F` is alternating, meaning `Fᵀ = -F`, since then `Fᵀ adj(F)` is again `det F`
times the identity up to sign.

Results.  The discriminant pairing is well defined and nondegenerate, and the
discriminant group is finite of order `|det F|`.  If an integral matrix `C`
pulls a unimodular form `T` back to `F`, meaning `Cᵀ T C = F`, then `C` is
injective on the standard lattice, its cokernel embeds in the discriminant
group of `F` through the matrix `Cᵀ T`, and the resulting subgroup is
isotropic, equal to its own orthogonal complement, and therefore maximal among
isotropic subgroups.  It has order `|det C|`, whose square is `|det F|`.

Trust boundary.  For an isogeny of polarized abelian varieties inducing `C` on
integral first homology, these statements are the order of the kernel of the
source polarization, the degree of the isogeny, and maximal isotropy of its
kernel inside that group.  No abelian variety, isogeny, polarization, or
commutator pairing is constructed here: every definition and theorem below is
about integral matrices and finitely generated abelian groups.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue

namespace GraphLattices

open scoped Matrix

/-- The integers inside the rationals, as a subgroup. -/
def integerLine : Submodule ℤ ℚ := Submodule.span ℤ {(1 : ℚ)}

/-- A rational number lies in the integer subgroup exactly when it is the image
of an integer. -/
theorem mem_integerLine_iff {value : ℚ} :
    value ∈ integerLine ↔ ∃ integer : ℤ, (integer : ℚ) = value := by
  rw [integerLine, Submodule.mem_span_singleton]
  constructor
  · rintro ⟨coefficient, rfl⟩
    exact ⟨coefficient, by simp⟩
  · rintro ⟨integer, rfl⟩
    exact ⟨integer, by simp⟩

/-- The rationals modulo the integers, the value group of a discriminant
pairing. -/
abbrev RationalsModOne : Type := ℚ ⧸ integerLine

/-- A rational number vanishes modulo the integers exactly when it is an
integer. -/
theorem rationalsModOne_eq_zero_iff {value : ℚ} :
    (Submodule.Quotient.mk value : RationalsModOne) = 0 ↔
      ∃ integer : ℤ, (integer : ℚ) = value := by
  rw [Submodule.Quotient.mk_eq_zero, mem_integerLine_iff]

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- The image of the standard integral lattice under an integral square
matrix. -/
def latticeImage (matrix : Matrix ι ι ℤ) : Submodule ℤ (ι → ℤ) :=
  LinearMap.range matrix.mulVecLin

omit [DecidableEq ι] in
/-- Membership in the image lattice is the existence of an integral
preimage. -/
theorem mem_latticeImage_iff {matrix : Matrix ι ι ℤ} {vector : ι → ℤ} :
    vector ∈ latticeImage matrix ↔ ∃ source : ι → ℤ, matrix *ᵥ source = vector := by
  simp [latticeImage, LinearMap.mem_range]

/-- The cokernel of an integral square matrix on the standard lattice. -/
abbrev integralCokernel (matrix : Matrix ι ι ℤ) : Type _ :=
  (ι → ℤ) ⧸ latticeImage matrix

/-- The discriminant group of an integral lattice pairing: the dual quotient
`Λ^#/Λ`, presented as the cokernel of the pairing matrix through the
isomorphism `v ↦ F v` from the dual lattice onto the standard lattice. -/
abbrev discriminantGroup (form : Matrix ι ι ℤ) : Type _ := integralCokernel form

omit [DecidableEq ι] in
/-- Moving a matrix across a dot product transposes it. -/
theorem mulVec_dotProduct_eq_dotProduct_transpose
    (matrix : Matrix ι ι ℤ) (left right : ι → ℤ) :
    (matrix *ᵥ left) ⬝ᵥ right = left ⬝ᵥ (matrixᵀ *ᵥ right) := by
  rw [dotProduct_comm (matrix *ᵥ left) right]
  exact (Matrix.dotProduct_transpose_mulVec matrix left right).symm

/-- Pairing against a standard basis vector reads off one coordinate of the
transposed matrix applied to the other argument. -/
theorem dotProduct_mulVec_single (matrix : Matrix ι ι ℤ) (vector : ι → ℤ) (index : ι) :
    vector ⬝ᵥ (matrix *ᵥ Pi.single index (1 : ℤ)) = (matrixᵀ *ᵥ vector) index := by
  rw [Matrix.mulVec_single_one]
  simp [dotProduct, Matrix.mulVec, Matrix.transpose_apply, mul_comm]

omit [Fintype ι] [DecidableEq ι] in
/-- A vector all of whose coordinates are divisible by a fixed integer is that
integer times an integral vector. -/
theorem exists_smul_of_forall_dvd {value : ℤ} {vector : ι → ℤ}
    (divisibility : ∀ index, value ∣ vector index) :
    ∃ quotient : ι → ℤ, vector = value • quotient := by
  refine ⟨fun index ↦ (divisibility index).choose, ?_⟩
  funext index
  simpa using (divisibility index).choose_spec

/-- A matrix with nonzero determinant is injective on the standard integral
lattice. -/
theorem mulVecLin_injective_of_det_ne_zero {matrix : Matrix ι ι ℤ}
    (nondegenerate : matrix.det ≠ 0) :
    Function.Injective matrix.mulVecLin := by
  intro left right equalImages
  have difference : matrix *ᵥ (left - right) = 0 := by
    rw [Matrix.mulVec_sub]
    simpa [Matrix.mulVecLin_apply] using sub_eq_zero.mpr equalImages
  have scaled : matrix.det • (left - right) = 0 := by
    have applied := congrArg (fun vector ↦ matrix.adjugate *ᵥ vector) difference
    simpa [Matrix.mulVec_mulVec, Matrix.adjugate_mul, Matrix.smul_mulVec,
      Matrix.one_mulVec] using applied
  rcases smul_eq_zero.mp scaled with determinantZero | differenceZero
  · exact absurd determinantZero nondegenerate
  · exact sub_eq_zero.mp differenceZero

/-- The cokernel of an integral matrix with nonzero determinant is finite of
order the absolute value of its determinant. -/
theorem natCard_integralCokernel {matrix : Matrix ι ι ℤ}
    (nondegenerate : matrix.det ≠ 0) :
    Nat.card (integralCokernel matrix) = matrix.det.natAbs := by
  have injective := mulVecLin_injective_of_det_ne_zero nondegenerate
  let corestriction : (ι → ℤ) ≃ₗ[ℤ] latticeImage matrix :=
    LinearEquiv.ofInjective matrix.mulVecLin injective
  have factored :
      (latticeImage matrix).subtype ∘ₗ
          AddMonoidHom.toIntLinearMap
            (corestriction.toAddEquiv : (ι → ℤ) →+ latticeImage matrix) =
        matrix.mulVecLin := by
    ext vector index
    rfl
  have counted := Submodule.natAbs_det_equiv (latticeImage matrix) corestriction.toAddEquiv
  rw [factored] at counted
  rw [← counted, ← Matrix.toLin'_apply', LinearMap.det_toLin']

/-- The transposed adjugate of an alternating matrix inverts it up to sign:
`F adj(F)ᵀ = -(det F)`. -/
theorem mul_adjugate_transpose_of_alternating {form : Matrix ι ι ℤ}
    (alternating : formᵀ = -form) :
    form * (form.adjugate)ᵀ = -(form.det • (1 : Matrix ι ι ℤ)) := by
  have base : (form.adjugate * form)ᵀ = (form.det • (1 : Matrix ι ι ℤ))ᵀ := by
    rw [Matrix.adjugate_mul]
  rw [Matrix.transpose_mul, alternating, Matrix.neg_mul, Matrix.transpose_smul,
    Matrix.transpose_one] at base
  exact neg_eq_iff_eq_neg.mp base

/-- The rational value of the discriminant pairing on integral representatives:
`(1/det F)·xᵀ adj(F) y`, which is `E(v,w)` for the dual vectors `v` and `w`
with `F v = x` and `F w = y`. -/
def discriminantValue (form : Matrix ι ι ℤ) (left right : ι → ℤ) : ℚ :=
  ((left ⬝ᵥ form.adjugate *ᵥ right : ℤ) : ℚ) / (form.det : ℚ)

/-- The discriminant value is additive in its first variable. -/
theorem discriminantValue_add_left (form : Matrix ι ι ℤ) (first second right : ι → ℤ) :
    discriminantValue form (first + second) right =
      discriminantValue form first right + discriminantValue form second right := by
  simp [discriminantValue, add_dotProduct, add_div]

/-- The discriminant value is homogeneous in its first variable. -/
theorem discriminantValue_smul_left (form : Matrix ι ι ℤ) (scalar : ℤ) (left right : ι → ℤ) :
    discriminantValue form (scalar • left) right =
      scalar • discriminantValue form left right := by
  rw [discriminantValue, discriminantValue, smul_dotProduct, smul_eq_mul, zsmul_eq_mul]
  push_cast
  ring

/-- The discriminant value is additive in its second variable. -/
theorem discriminantValue_add_right (form : Matrix ι ι ℤ) (left first second : ι → ℤ) :
    discriminantValue form left (first + second) =
      discriminantValue form left first + discriminantValue form left second := by
  simp [discriminantValue, Matrix.mulVec_add, dotProduct_add, add_div]

/-- The discriminant value is homogeneous in its second variable. -/
theorem discriminantValue_smul_right (form : Matrix ι ι ℤ) (scalar : ℤ) (left right : ι → ℤ) :
    discriminantValue form left (scalar • right) =
      scalar • discriminantValue form left right := by
  rw [discriminantValue, discriminantValue, Matrix.mulVec_smul, dotProduct_smul, smul_eq_mul,
    zsmul_eq_mul]
  push_cast
  ring

/-- A representative from the lattice itself pairs integrally in the second
variable. -/
theorem discriminantValue_right_latticeImage {form : Matrix ι ι ℤ}
    (nondegenerate : form.det ≠ 0) (left source : ι → ℤ) :
    discriminantValue form left (form *ᵥ source) = ((left ⬝ᵥ source : ℤ) : ℚ) := by
  have castNonzero : (form.det : ℚ) ≠ 0 := Int.cast_ne_zero.mpr nondegenerate
  rw [discriminantValue, Matrix.mulVec_mulVec, Matrix.adjugate_mul, Matrix.smul_mulVec,
    Matrix.one_mulVec, dotProduct_smul, smul_eq_mul, Int.cast_mul, mul_comm,
    mul_div_cancel_right₀ _ castNonzero]

/-- For an alternating form a representative from the lattice itself pairs
integrally in the first variable as well. -/
theorem discriminantValue_left_latticeImage {form : Matrix ι ι ℤ}
    (alternating : formᵀ = -form) (nondegenerate : form.det ≠ 0) (source right : ι → ℤ) :
    discriminantValue form (form *ᵥ source) right = -((source ⬝ᵥ right : ℤ) : ℚ) := by
  have castNonzero : (form.det : ℚ) ≠ 0 := Int.cast_ne_zero.mpr nondegenerate
  have numerator :
      (form *ᵥ source) ⬝ᵥ form.adjugate *ᵥ right = -(form.det * (source ⬝ᵥ right)) := by
    rw [mulVec_dotProduct_eq_dotProduct_transpose, Matrix.mulVec_mulVec, alternating,
      Matrix.neg_mul, Matrix.mul_adjugate, Matrix.neg_mulVec, Matrix.smul_mulVec,
      Matrix.one_mulVec, dotProduct_neg, dotProduct_smul, smul_eq_mul]
  rw [discriminantValue, numerator, Int.cast_neg, Int.cast_mul, neg_div, mul_comm,
    mul_div_cancel_right₀ _ castNonzero]

/-- The discriminant value as a bilinear rational-valued pairing on integral
representatives. -/
def discriminantRationalPairing (form : Matrix ι ι ℤ) :
    (ι → ℤ) →ₗ[ℤ] (ι → ℤ) →ₗ[ℤ] ℚ where
  toFun left :=
    { toFun := fun right ↦ discriminantValue form left right
      map_add' := discriminantValue_add_right form left
      map_smul' := fun scalar right ↦ discriminantValue_smul_right form scalar left right }
  map_add' first second := by
    refine LinearMap.ext fun right ↦ ?_
    exact discriminantValue_add_left form first second right
  map_smul' scalar left := by
    refine LinearMap.ext fun right ↦ ?_
    exact discriminantValue_smul_left form scalar left right

/-- The discriminant pairing on integral representatives, valued in `ℚ/ℤ`. -/
def discriminantRepresentativePairing (form : Matrix ι ι ℤ) :
    (ι → ℤ) →ₗ[ℤ] (ι → ℤ) →ₗ[ℤ] RationalsModOne :=
  (discriminantRationalPairing form).compr₂ integerLine.mkQ

/-- The representative pairing is the class of the discriminant value. -/
theorem discriminantRepresentativePairing_apply (form : Matrix ι ι ℤ) (left right : ι → ℤ) :
    discriminantRepresentativePairing form left right =
      Submodule.Quotient.mk (discriminantValue form left right) :=
  rfl

/-- The discriminant pairing with its second variable descended to the
discriminant group. -/
def discriminantPairingRight {form : Matrix ι ι ℤ} (nondegenerate : form.det ≠ 0)
    (left : ι → ℤ) : discriminantGroup form →ₗ[ℤ] RationalsModOne :=
  Submodule.liftQ _ (discriminantRepresentativePairing form left) (by
    intro vector membership
    obtain ⟨source, rfl⟩ := mem_latticeImage_iff.mp membership
    rw [LinearMap.mem_ker, discriminantRepresentativePairing_apply,
      discriminantValue_right_latticeImage nondegenerate]
    exact rationalsModOne_eq_zero_iff.mpr ⟨left ⬝ᵥ source, rfl⟩)

/-- The descended pairing computes on the class of a representative. -/
theorem discriminantPairingRight_mk {form : Matrix ι ι ℤ} (nondegenerate : form.det ≠ 0)
    (left right : ι → ℤ) :
    discriminantPairingRight nondegenerate left (Submodule.Quotient.mk right) =
      Submodule.Quotient.mk (discriminantValue form left right) :=
  rfl

/-- The discriminant pairing with its second variable descended, as a linear
map in the first variable. -/
def discriminantPairingAux {form : Matrix ι ι ℤ} (nondegenerate : form.det ≠ 0) :
    (ι → ℤ) →ₗ[ℤ] discriminantGroup form →ₗ[ℤ] RationalsModOne where
  toFun left := discriminantPairingRight nondegenerate left
  map_add' first second := by
    refine LinearMap.ext fun element ↦ ?_
    obtain ⟨right, rfl⟩ := Submodule.Quotient.mk_surjective _ element
    simp only [LinearMap.add_apply, discriminantPairingRight_mk, discriminantValue_add_left]
    exact Submodule.Quotient.mk_add _
  map_smul' scalar left := by
    refine LinearMap.ext fun element ↦ ?_
    obtain ⟨right, rfl⟩ := Submodule.Quotient.mk_surjective _ element
    have scaled :
        ((RingHom.id ℤ) scalar • discriminantPairingRight nondegenerate left)
            (Submodule.Quotient.mk right) =
          scalar • discriminantPairingRight nondegenerate left (Submodule.Quotient.mk right) :=
      rfl
    rw [scaled, discriminantPairingRight_mk, discriminantPairingRight_mk,
      discriminantValue_smul_left]
    exact Submodule.Quotient.mk_smul _ _ _

/-- The discriminant pairing of an integral alternating form with nonzero
determinant: the `ℚ/ℤ`-valued pairing `(v,w) ↦ E(v,w) mod ℤ` of the dual
lattice, read on the discriminant group through the identification
`v ↦ F v`. -/
def discriminantPairing {form : Matrix ι ι ℤ} (alternating : formᵀ = -form)
    (nondegenerate : form.det ≠ 0) :
    discriminantGroup form →ₗ[ℤ] discriminantGroup form →ₗ[ℤ] RationalsModOne :=
  Submodule.liftQ _ (discriminantPairingAux nondegenerate) (by
    intro vector membership
    obtain ⟨source, rfl⟩ := mem_latticeImage_iff.mp membership
    refine LinearMap.mem_ker.mpr (LinearMap.ext fun element ↦ ?_)
    obtain ⟨right, rfl⟩ := Submodule.Quotient.mk_surjective _ element
    show discriminantPairingRight nondegenerate _ _ = 0
    rw [discriminantPairingRight_mk,
      discriminantValue_left_latticeImage alternating nondegenerate]
    exact rationalsModOne_eq_zero_iff.mpr ⟨-(source ⬝ᵥ right), by push_cast; ring⟩)

/-- The discriminant pairing of two classes is the class modulo one of the
discriminant value of any two representatives. -/
theorem discriminantPairing_mk {form : Matrix ι ι ℤ} (alternating : formᵀ = -form)
    (nondegenerate : form.det ≠ 0) (left right : ι → ℤ) :
    discriminantPairing alternating nondegenerate (Submodule.Quotient.mk left)
        (Submodule.Quotient.mk right) =
      Submodule.Quotient.mk (discriminantValue form left right) :=
  rfl

/-- The discriminant pairing of two representatives vanishes exactly when the
determinant divides the integral numerator. -/
theorem discriminantPairing_mk_eq_zero_iff {form : Matrix ι ι ℤ}
    (alternating : formᵀ = -form) (nondegenerate : form.det ≠ 0) (left right : ι → ℤ) :
    discriminantPairing alternating nondegenerate (Submodule.Quotient.mk left)
        (Submodule.Quotient.mk right) = 0 ↔
      form.det ∣ left ⬝ᵥ form.adjugate *ᵥ right := by
  have castNonzero : (form.det : ℚ) ≠ 0 := Int.cast_ne_zero.mpr nondegenerate
  rw [discriminantPairing_mk, rationalsModOne_eq_zero_iff]
  constructor
  · rintro ⟨integer, equation⟩
    rw [discriminantValue, eq_div_iff castNonzero] at equation
    have integral : (integer * form.det : ℤ) = left ⬝ᵥ form.adjugate *ᵥ right := by
      exact_mod_cast equation
    exact ⟨integer, by rw [← integral]; ring⟩
  · rintro ⟨cofactor, equation⟩
    refine ⟨cofactor, ?_⟩
    rw [discriminantValue, equation, Int.cast_mul, mul_comm,
      mul_div_cancel_right₀ _ castNonzero]

/-- The discriminant pairing is nondegenerate. -/
theorem discriminantPairing_eq_zero_of_forall {form : Matrix ι ι ℤ}
    (alternating : formᵀ = -form) (nondegenerate : form.det ≠ 0)
    {element : discriminantGroup form}
    (orthogonal : ∀ other : discriminantGroup form,
      discriminantPairing alternating nondegenerate element other = 0) :
    element = 0 := by
  obtain ⟨representative, rfl⟩ := Submodule.Quotient.mk_surjective _ element
  have divisibility : ∀ index : ι,
      form.det ∣ ((form.adjugate)ᵀ *ᵥ representative) index := by
    intro index
    have vanishing := orthogonal (Submodule.Quotient.mk (Pi.single index 1))
    rw [discriminantPairing_mk_eq_zero_iff alternating nondegenerate] at vanishing
    rwa [dotProduct_mulVec_single] at vanishing
  obtain ⟨cofactor, equation⟩ := exists_smul_of_forall_dvd divisibility
  have applied :
      form *ᵥ ((form.adjugate)ᵀ *ᵥ representative) = form *ᵥ (form.det • cofactor) := by
    rw [equation]
  rw [Matrix.mulVec_mulVec, mul_adjugate_transpose_of_alternating alternating,
    Matrix.mulVec_smul] at applied
  have cancelled : form.det • representative = form.det • (-(form *ᵥ cofactor)) := by
    have expanded : (-(form.det • (1 : Matrix ι ι ℤ))) *ᵥ representative =
        -(form.det • representative) := by
      rw [Matrix.neg_mulVec, Matrix.smul_mulVec, Matrix.one_mulVec]
    rw [expanded] at applied
    rw [smul_neg]
    exact neg_eq_iff_eq_neg.mp applied
  have representativeValue : representative = -(form *ᵥ cofactor) :=
    smul_right_injective (ι → ℤ) nondegenerate cancelled
  refine (Submodule.Quotient.mk_eq_zero _).mpr (mem_latticeImage_iff.mpr ⟨-cofactor, ?_⟩)
  rw [Matrix.mulVec_neg, representativeValue]

/-- The orthogonal complement of a subgroup of the discriminant group. -/
def discriminantPerp {form : Matrix ι ι ℤ} (alternating : formᵀ = -form)
    (nondegenerate : form.det ≠ 0) (subgroup : Submodule ℤ (discriminantGroup form)) :
    Submodule ℤ (discriminantGroup form) where
  carrier := {element | ∀ other ∈ subgroup,
    discriminantPairing alternating nondegenerate element other = 0}
  zero_mem' := by
    intro other _
    rw [map_zero, LinearMap.zero_apply]
  add_mem' := by
    intro first second memberFirst memberSecond other membership
    rw [map_add, LinearMap.add_apply, memberFirst other membership,
      memberSecond other membership, add_zero]
  smul_mem' := by
    intro scalar element member other membership
    have scaled :
        (discriminantPairing alternating nondegenerate (scalar • element)) other =
          scalar • (discriminantPairing alternating nondegenerate element) other := by
      rw [map_smul]
      rfl
    rw [scaled, member other membership]
    exact smul_zero scalar

/-- Membership in the orthogonal complement is vanishing against every element
of the subgroup. -/
theorem mem_discriminantPerp_iff {form : Matrix ι ι ℤ} {alternating : formᵀ = -form}
    {nondegenerate : form.det ≠ 0} {subgroup : Submodule ℤ (discriminantGroup form)}
    {element : discriminantGroup form} :
    element ∈ discriminantPerp alternating nondegenerate subgroup ↔
      ∀ other ∈ subgroup, discriminantPairing alternating nondegenerate element other = 0 :=
  Iff.rfl

/-- Orthogonal complements reverse inclusions. -/
theorem discriminantPerp_antitone {form : Matrix ι ι ℤ} (alternating : formᵀ = -form)
    (nondegenerate : form.det ≠ 0) {smaller larger : Submodule ℤ (discriminantGroup form)}
    (inclusion : smaller ≤ larger) :
    discriminantPerp alternating nondegenerate larger ≤
      discriminantPerp alternating nondegenerate smaller :=
  fun _ member other membership ↦ member other (inclusion membership)

/-- A subgroup of a discriminant group is maximal isotropic when it pairs
trivially with itself and no larger subgroup does. -/
def IsMaximalIsotropicSubgroup {form : Matrix ι ι ℤ} (alternating : formᵀ = -form)
    (nondegenerate : form.det ≠ 0) (subgroup : Submodule ℤ (discriminantGroup form)) : Prop :=
  subgroup ≤ discriminantPerp alternating nondegenerate subgroup ∧
    ∀ larger : Submodule ℤ (discriminantGroup form),
      subgroup ≤ larger →
      larger ≤ discriminantPerp alternating nondegenerate larger →
      larger = subgroup

/-- A subgroup equal to its own orthogonal complement is maximal isotropic. -/
theorem isMaximalIsotropicSubgroup_of_eq_perp {form : Matrix ι ι ℤ}
    {alternating : formᵀ = -form} {nondegenerate : form.det ≠ 0}
    {subgroup : Submodule ℤ (discriminantGroup form)}
    (selfOrthogonal : subgroup = discriminantPerp alternating nondegenerate subgroup) :
    IsMaximalIsotropicSubgroup alternating nondegenerate subgroup := by
  refine ⟨selfOrthogonal.le, fun larger contains isotropic ↦ le_antisymm ?_ contains⟩
  calc larger ≤ discriminantPerp alternating nondegenerate larger := isotropic
    _ ≤ discriminantPerp alternating nondegenerate subgroup :=
      discriminantPerp_antitone alternating nondegenerate contains
    _ = subgroup := selfOrthogonal.symm

section Comparison

variable {form comparison target : Matrix ι ι ℤ}

/-- Pulling a form back along a comparison matrix multiplies determinants. -/
theorem det_of_polarizationPullback (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = form) :
    form.det = comparison.det * comparison.det := by
  rw [← pullback, Matrix.det_mul, Matrix.det_mul, Matrix.det_transpose, principal]
  ring

/-- Conjugating the adjugate of a pulled-back form by the comparison matrix
returns the square of its determinant times the adjugate of the target
form. -/
theorem comparison_adjugate_sandwich
    (pullback : comparisonᵀ * target * comparison = form) :
    comparison * form.adjugate * comparisonᵀ =
      (comparison.det * comparison.det) • target.adjugate := by
  have expanded : form.adjugate =
      comparison.adjugate * (target.adjugate * (comparison.adjugate)ᵀ) := by
    rw [← pullback, Matrix.adjugate_mul_distrib, Matrix.adjugate_mul_distrib,
      Matrix.adjugate_transpose]
  have transposed : (comparison.adjugate)ᵀ * comparisonᵀ =
      comparison.det • (1 : Matrix ι ι ℤ) := by
    rw [← Matrix.transpose_mul, Matrix.mul_adjugate, Matrix.transpose_smul,
      Matrix.transpose_one]
  calc comparison * form.adjugate * comparisonᵀ
      = (comparison * comparison.adjugate) * target.adjugate *
          ((comparison.adjugate)ᵀ * comparisonᵀ) := by
        rw [expanded]
        simp only [Matrix.mul_assoc]
    _ = (comparison.det * comparison.det) • target.adjugate := by
        rw [Matrix.mul_adjugate, transposed]
        simp only [Matrix.smul_mul, Matrix.mul_smul, Matrix.one_mul, Matrix.mul_one, smul_smul]

/-- The cokernel of the comparison matrix, the lattice model of the kernel of
an isogeny inducing it on integral first homology. -/
abbrev comparisonCokernel (comparison : Matrix ι ι ℤ) : Type _ := integralCokernel comparison

/-- The comparison cokernel maps to the discriminant group of the pulled-back
form through the matrix `Cᵀ T`.  This is the lattice model of the inclusion of
the kernel of an isogeny in the kernel of the source polarization. -/
def comparisonToDiscriminant (pullback : comparisonᵀ * target * comparison = form) :
    comparisonCokernel comparison →ₗ[ℤ] discriminantGroup form :=
  Submodule.liftQ _ ((latticeImage form).mkQ.comp (comparisonᵀ * target).mulVecLin) (by
    intro vector membership
    obtain ⟨source, rfl⟩ := mem_latticeImage_iff.mp membership
    refine LinearMap.mem_ker.mpr ?_
    show Submodule.Quotient.mk ((comparisonᵀ * target) *ᵥ (comparison *ᵥ source)) = 0
    rw [Matrix.mulVec_mulVec, pullback]
    exact (Submodule.Quotient.mk_eq_zero _).mpr (mem_latticeImage_iff.mpr ⟨source, rfl⟩))

omit [DecidableEq ι] in
/-- The embedding computes on the class of a representative. -/
theorem comparisonToDiscriminant_mk (pullback : comparisonᵀ * target * comparison = form)
    (source : ι → ℤ) :
    comparisonToDiscriminant pullback (Submodule.Quotient.mk source) =
      Submodule.Quotient.mk ((comparisonᵀ * target) *ᵥ source) :=
  rfl

/-- The comparison matrix composed with a unimodular target form is again
nondegenerate. -/
theorem det_comparison_transpose_mul_target (principal : target.det = 1)
    (nondegenerate : comparison.det ≠ 0) : (comparisonᵀ * target).det ≠ 0 := by
  rw [Matrix.det_mul, Matrix.det_transpose, principal, mul_one]
  exact nondegenerate

/-- The comparison cokernel embeds in the discriminant group. -/
theorem comparisonToDiscriminant_injective (principal : target.det = 1)
    (nondegenerate : comparison.det ≠ 0)
    (pullback : comparisonᵀ * target * comparison = form) :
    Function.Injective (comparisonToDiscriminant pullback) := by
  refine LinearMap.ker_eq_bot.mp (Submodule.eq_bot_iff _ |>.mpr ?_)
  intro element membership
  obtain ⟨source, rfl⟩ := Submodule.Quotient.mk_surjective _ element
  rw [LinearMap.mem_ker, comparisonToDiscriminant_mk] at membership
  obtain ⟨witness, equation⟩ :=
    mem_latticeImage_iff.mp ((Submodule.Quotient.mk_eq_zero _).mp membership)
  have rewritten : (comparisonᵀ * target) *ᵥ source =
      (comparisonᵀ * target) *ᵥ (comparison *ᵥ witness) := by
    rw [Matrix.mulVec_mulVec, pullback, equation]
  have injective :=
    mulVecLin_injective_of_det_ne_zero (det_comparison_transpose_mul_target principal nondegenerate)
  have equalSources : source = comparison *ᵥ witness := injective rewritten
  exact (Submodule.Quotient.mk_eq_zero _).mpr (mem_latticeImage_iff.mpr ⟨witness, equalSources.symm⟩)

/-- The image of the comparison cokernel in the discriminant group: the
lattice model of the kernel of an isogeny, seen inside the kernel of the source
polarization. -/
def comparisonKernelSubgroup (pullback : comparisonᵀ * target * comparison = form) :
    Submodule ℤ (discriminantGroup form) :=
  LinearMap.range (comparisonToDiscriminant pullback)

omit [DecidableEq ι] in
/-- The kernel subgroup consists of the classes of the vectors in the image of
the matrix `Cᵀ T`. -/
theorem mem_comparisonKernelSubgroup_iff
    {pullback : comparisonᵀ * target * comparison = form}
    {element : discriminantGroup form} :
    element ∈ comparisonKernelSubgroup pullback ↔
      ∃ source : ι → ℤ,
        (Submodule.Quotient.mk ((comparisonᵀ * target) *ᵥ source) :
          discriminantGroup form) = element := by
  constructor
  · rintro ⟨preimage, rfl⟩
    obtain ⟨source, rfl⟩ := Submodule.Quotient.mk_surjective _ preimage
    exact ⟨source, (comparisonToDiscriminant_mk pullback source)⟩
  · rintro ⟨source, rfl⟩
    exact ⟨Submodule.Quotient.mk source, comparisonToDiscriminant_mk pullback source⟩

/-- The kernel subgroup pairs trivially with itself: on the lattice level, the
polarization pullback identity makes the discriminant pairing of two kernel
classes an integer. -/
theorem comparisonKernelSubgroup_isotropic (alternating : formᵀ = -form)
    (nondegenerate : form.det ≠ 0) (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = form) :
    comparisonKernelSubgroup pullback ≤
      discriminantPerp alternating nondegenerate (comparisonKernelSubgroup pullback) := by
  intro element membership other otherMembership
  obtain ⟨left, rfl⟩ := mem_comparisonKernelSubgroup_iff.mp membership
  obtain ⟨right, rfl⟩ := mem_comparisonKernelSubgroup_iff.mp otherMembership
  rw [discriminantPairing_mk_eq_zero_iff alternating nondegenerate]
  refine ⟨left ⬝ᵥ (targetᵀ *ᵥ right), ?_⟩
  have matrixIdentity :
      (comparisonᵀ * target)ᵀ * form.adjugate * (comparisonᵀ * target) = form.det • targetᵀ := by
    rw [Matrix.transpose_mul, Matrix.transpose_transpose,
      det_of_polarizationPullback principal pullback]
    calc targetᵀ * comparison * form.adjugate * (comparisonᵀ * target)
        = targetᵀ * (comparison * form.adjugate * comparisonᵀ) * target := by
          simp only [Matrix.mul_assoc]
      _ = (comparison.det * comparison.det) • (targetᵀ * (target.adjugate * target)) := by
          rw [comparison_adjugate_sandwich pullback]
          simp only [Matrix.mul_smul, Matrix.smul_mul, Matrix.mul_assoc]
      _ = (comparison.det * comparison.det) • targetᵀ := by
          rw [Matrix.adjugate_mul, principal, one_smul, Matrix.mul_one]
  calc ((comparisonᵀ * target) *ᵥ left) ⬝ᵥ form.adjugate *ᵥ ((comparisonᵀ * target) *ᵥ right)
      = left ⬝ᵥ (((comparisonᵀ * target)ᵀ * form.adjugate * (comparisonᵀ * target)) *ᵥ right) := by
        rw [mulVec_dotProduct_eq_dotProduct_transpose, Matrix.mulVec_mulVec, Matrix.mulVec_mulVec]
    _ = form.det * (left ⬝ᵥ (targetᵀ *ᵥ right)) := by
        rw [matrixIdentity, Matrix.smul_mulVec, dotProduct_smul, smul_eq_mul]

/-- Every class orthogonal to the kernel subgroup lies in it. -/
theorem comparisonKernelSubgroup_perp_le (alternating : formᵀ = -form)
    (nondegenerate : form.det ≠ 0) (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = form) :
    discriminantPerp alternating nondegenerate (comparisonKernelSubgroup pullback) ≤
      comparisonKernelSubgroup pullback := by
  intro element membership
  obtain ⟨representative, rfl⟩ := Submodule.Quotient.mk_surjective _ element
  have divisibility : ∀ index : ι,
      form.det ∣ (((comparisonᵀ * target)ᵀ * (form.adjugate)ᵀ) *ᵥ representative) index := by
    intro index
    have vanishing := membership
      (Submodule.Quotient.mk ((comparisonᵀ * target) *ᵥ Pi.single index 1))
      (mem_comparisonKernelSubgroup_iff.mpr ⟨Pi.single index 1, rfl⟩)
    rw [discriminantPairing_mk_eq_zero_iff alternating nondegenerate] at vanishing
    have rewritten :
        representative ⬝ᵥ form.adjugate *ᵥ ((comparisonᵀ * target) *ᵥ Pi.single index 1) =
          (((comparisonᵀ * target)ᵀ * (form.adjugate)ᵀ) *ᵥ representative) index := by
      rw [Matrix.mulVec_mulVec, dotProduct_mulVec_single, Matrix.transpose_mul]
    rwa [rewritten] at vanishing
  obtain ⟨cofactor, equation⟩ := exists_smul_of_forall_dvd divisibility
  set bridge : Matrix ι ι ℤ := (comparisonᵀ * target) * (targetᵀ).adjugate with bridgeDefinition
  have collapse : bridge * ((comparisonᵀ * target)ᵀ * (form.adjugate)ᵀ) =
      -(form.det • (1 : Matrix ι ι ℤ)) := by
    have targetTransposeUnimodular : (targetᵀ).adjugate * targetᵀ =
        (1 : Matrix ι ι ℤ) := by
      rw [Matrix.adjugate_mul, Matrix.det_transpose, principal, one_smul]
    calc bridge * ((comparisonᵀ * target)ᵀ * (form.adjugate)ᵀ)
        = (comparisonᵀ * target) * ((targetᵀ).adjugate * targetᵀ) * comparison *
            (form.adjugate)ᵀ := by
          rw [bridgeDefinition, Matrix.transpose_mul, Matrix.transpose_transpose]
          simp only [Matrix.mul_assoc]
      _ = form * (form.adjugate)ᵀ := by
          rw [targetTransposeUnimodular, Matrix.mul_one, pullback]
      _ = -(form.det • (1 : Matrix ι ι ℤ)) := mul_adjugate_transpose_of_alternating alternating
  have applied :
      bridge *ᵥ (((comparisonᵀ * target)ᵀ * (form.adjugate)ᵀ) *ᵥ representative) =
        bridge *ᵥ (form.det • cofactor) := by
    rw [equation]
  rw [Matrix.mulVec_mulVec, collapse, Matrix.mulVec_smul] at applied
  have cancelled : form.det • representative =
      form.det • (-(bridge *ᵥ cofactor)) := by
    have expanded : (-(form.det • (1 : Matrix ι ι ℤ))) *ᵥ representative =
        -(form.det • representative) := by
      rw [Matrix.neg_mulVec, Matrix.smul_mulVec, Matrix.one_mulVec]
    rw [expanded] at applied
    rw [smul_neg]
    exact neg_eq_iff_eq_neg.mp applied
  have representativeValue : representative = -(bridge *ᵥ cofactor) :=
    smul_right_injective (ι → ℤ) nondegenerate cancelled
  refine mem_comparisonKernelSubgroup_iff.mpr ⟨-((targetᵀ).adjugate *ᵥ cofactor), ?_⟩
  rw [Matrix.mulVec_neg, Matrix.mulVec_mulVec, ← bridgeDefinition, ← representativeValue]

/-- The kernel subgroup is exactly its own orthogonal complement. -/
theorem comparisonKernelSubgroup_eq_perp (alternating : formᵀ = -form)
    (nondegenerate : form.det ≠ 0) (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = form) :
    comparisonKernelSubgroup pullback =
      discriminantPerp alternating nondegenerate (comparisonKernelSubgroup pullback) :=
  le_antisymm
    (comparisonKernelSubgroup_isotropic alternating nondegenerate principal pullback)
    (comparisonKernelSubgroup_perp_le alternating nondegenerate principal pullback)

/-- The lattice model of the isogeny kernel is a maximal isotropic subgroup of
the discriminant group of the pulled-back form. -/
theorem comparisonKernelSubgroup_isMaximalIsotropic (alternating : formᵀ = -form)
    (nondegenerate : form.det ≠ 0) (principal : target.det = 1)
    (pullback : comparisonᵀ * target * comparison = form) :
    IsMaximalIsotropicSubgroup alternating nondegenerate (comparisonKernelSubgroup pullback) :=
  isMaximalIsotropicSubgroup_of_eq_perp
    (comparisonKernelSubgroup_eq_perp alternating nondegenerate principal pullback)

/-- The kernel subgroup has order the absolute value of the comparison
determinant. -/
theorem natCard_comparisonKernelSubgroup (principal : target.det = 1)
    (comparisonNondegenerate : comparison.det ≠ 0)
    (pullback : comparisonᵀ * target * comparison = form) :
    Nat.card (comparisonKernelSubgroup pullback) = comparison.det.natAbs := by
  have injective :=
    comparisonToDiscriminant_injective principal comparisonNondegenerate pullback
  have equivalence :
      comparisonCokernel comparison ≃ₗ[ℤ] LinearMap.range (comparisonToDiscriminant pullback) :=
    LinearEquiv.ofInjective _ injective
  rw [comparisonKernelSubgroup, ← Nat.card_congr equivalence.toEquiv,
    natCard_integralCokernel comparisonNondegenerate]

/-- The kernel subgroup has square-root order in the discriminant group. -/
theorem natCard_discriminantGroup_eq_sq (principal : target.det = 1)
    (comparisonNondegenerate : comparison.det ≠ 0)
    (pullback : comparisonᵀ * target * comparison = form) :
    Nat.card (discriminantGroup form) =
      Nat.card (comparisonKernelSubgroup pullback) ^ 2 := by
  have formNondegenerate : form.det ≠ 0 := by
    rw [det_of_polarizationPullback principal pullback]
    exact mul_ne_zero comparisonNondegenerate comparisonNondegenerate
  rw [natCard_integralCokernel formNondegenerate,
    natCard_comparisonKernelSubgroup principal comparisonNondegenerate pullback,
    det_of_polarizationPullback principal pullback, Int.natAbs_mul, sq]

end Comparison

end GraphLattices

end TavisRuddFiniteGeom.Papers.CubicStabilizationEpilogue
