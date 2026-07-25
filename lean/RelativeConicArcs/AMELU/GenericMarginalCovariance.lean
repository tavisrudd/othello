import RelativeConicArcs.AMELU.GenericSubsystemWeyl
import RelativeConicArcs.AMELU.StateMarginalCovariance

/-!
# Covariance of length-generic reduced matrices

Splitting a length-`2m` label into retained and discarded coordinates turns a
product local action into a Kronecker product.  Partial-trace covariance then
shows that every retained reduced matrix is conjugated by the tensor product
of its retained local factors.  In product-Weyl coordinates this is precisely
the independent product of the local Weyl-coordinate conjugation maps.

All arguments are symbolic and kernel checked.  The module contains no
generated data, native evaluation, axioms, or admitted declarations.
-/

namespace RelativeConicArcs.AMELU

open scoped Kronecker ComplexConjugate
open Finset Matrix

variable {m : ℕ} {𝔽 : Type*}
  [Field 𝔽] [Fintype 𝔽] [DecidableEq 𝔽]

/-- A generic state in retained/discarded product coordinates. -/
def genericAssembledState
    (ψ : GenericState m 𝔽) (S : Finset (GenericParty m)) :
    ((S → 𝔽) ×
      ((i : {i : GenericParty m // i ∉ S}) → 𝔽)) → ℂ :=
  fun p => ψ (genericAssembleLabel S p.1 p.2)

/-- Tensor product of the matrices on the discarded coordinates. -/
def genericEnvironmentTensorMatrix
    (S : Finset (GenericParty m))
    (U : GenericParty m → LocalMatrix 𝔽) :
    Matrix (((i : {i : GenericParty m // i ∉ S}) → 𝔽))
      (((i : {i : GenericParty m // i ∉ S}) → 𝔽)) ℂ :=
  fun y x =>
    ∏ i : {i : GenericParty m // i ∉ S},
      U i.1 (y i) (x i)

omit [Field 𝔽] in
/-- The discarded-coordinate tensor matrix is unitary when every local
factor is unitary. -/
theorem genericEnvironmentTensorMatrix_isUnitary
    (S : Finset (GenericParty m))
    (U : GenericParty m → LocalMatrix 𝔽)
    (hU : ∀ i, IsUnitaryMatrix (U i)) :
    IsUnitaryMatrix (genericEnvironmentTensorMatrix S U) := by
  exact finiteProductTensorMatrix_isUnitary
    (fun i : {i : GenericParty m // i ∉ S} => U i.1)
    (fun i => hU i.1)

omit [Field 𝔽] [DecidableEq 𝔽] in
/-- In product coordinates, the generic local action is the Kronecker
product of the retained and discarded tensor matrices. -/
theorem genericAssembledState_localAction
    (U : GenericParty m → LocalMatrix 𝔽)
    (ψ : GenericState m 𝔽) (S : Finset (GenericParty m)) :
    genericAssembledState (genericLocalAction U ψ) S =
      ((finiteProductTensorMatrix (fun i : S => U i.1)) ⊗ₖ
        genericEnvironmentTensorMatrix S U) *ᵥ
          genericAssembledState ψ S := by
  classical
  funext p
  rcases p with ⟨x, e⟩
  unfold genericAssembledState genericLocalAction
  rw [← generic_sum_assembleLabel S]
  simp only [Matrix.mulVec, dotProduct]
  rw [Fintype.sum_prod_type]
  simp only [Matrix.kronecker_apply, finiteProductTensorMatrix,
    genericEnvironmentTensorMatrix]
  apply Finset.sum_congr rfl
  intro a _
  apply Finset.sum_congr rfl
  intro d _
  let g : GenericParty m → ℂ :=
    fun i => U i (genericAssembleLabel S x e i)
      (genericAssembleLabel S a d i)
  rw [← Finset.prod_mul_prod_compl S g]
  rw [Finset.prod_subtype (p := fun i : GenericParty m => i ∈ S)
    S (fun _ => Iff.rfl) g]
  rw [Finset.prod_subtype
    (p := fun i : GenericParty m => i ∉ S) Sᶜ (by
      intro i
      simp) g]
  have hSprod :
      (∏ i : S,
        U i.1 (genericAssembleLabel S x e i.1)
          (genericAssembleLabel S a d i.1)) =
        ∏ i : S, U i.1 (x i) (a i) := by
    apply Finset.prod_congr rfl
    intro i _
    simp [genericAssembleLabel, i.2]
  have hEprod :
      (∏ i : {i : GenericParty m // i ∉ S},
        U i.1 (genericAssembleLabel S x e i.1)
          (genericAssembleLabel S a d i.1)) =
        ∏ i : {i : GenericParty m // i ∉ S},
          U i.1 (e i) (d i) := by
    apply Finset.prod_congr rfl
    intro i _
    simp [genericAssembleLabel, i.2]
  apply congrArg
    (fun z : ℂ => z * ψ (genericAssembleLabel S a d))
  exact congrArg₂ (· * ·) hSprod hEprod

omit [Field 𝔽] [DecidableEq 𝔽] in
/-- The generic reduced matrix is the partial trace of the assembled
rank-one density matrix. -/
theorem partialTraceSecond_vectorDensity_genericAssembledState
    (ψ : GenericState m 𝔽) (S : Finset (GenericParty m)) :
    partialTraceSecond (vectorDensity (genericAssembledState ψ S)) =
      fun x y => genericMarginalEntry ψ S x y := by
  rfl

omit [Field 𝔽] in
/-- A generic reduced matrix transforms by retained product conjugation. -/
theorem genericMarginalEntry_localAction
    (U : GenericParty m → LocalMatrix 𝔽)
    (hU : ∀ i, IsUnitaryMatrix (U i))
    (ψ : GenericState m 𝔽) (S : Finset (GenericParty m)) :
    (fun x y => genericMarginalEntry (genericLocalAction U ψ) S x y) =
      finiteProductUnitaryConjugationEquiv
        (fun i : S => U i.1) (fun i => hU i.1)
        (fun x y => genericMarginalEntry ψ S x y) := by
  classical
  let A := finiteProductTensorMatrix (fun i : S => U i.1)
  let B := genericEnvironmentTensorMatrix S U
  have hBunitary : IsUnitaryMatrix B :=
    genericEnvironmentTensorMatrix_isUnitary S U hU
  calc
    _ = partialTraceSecond
        (vectorDensity (genericAssembledState
          (genericLocalAction U ψ) S)) :=
      (partialTraceSecond_vectorDensity_genericAssembledState
        (genericLocalAction U ψ) S).symm
    _ = partialTraceSecond
        (vectorDensity (((A ⊗ₖ B) *ᵥ
          genericAssembledState ψ S))) := by
      rw [← genericAssembledState_localAction U ψ S]
    _ = partialTraceSecond
        ((A ⊗ₖ B) * vectorDensity (genericAssembledState ψ S) *
          (A ⊗ₖ B)ᴴ) := by
      rw [vectorDensity_mulVec]
    _ = A * partialTraceSecond
        (vectorDensity (genericAssembledState ψ S)) * Aᴴ :=
      partialTraceSecond_product_conjugation A B
        (vectorDensity (genericAssembledState ψ S))
        (conjTranspose_mul_self_eq_one_of_isUnitaryMatrix hBunitary)
    _ = finiteProductUnitaryConjugationEquiv
        (fun i : S => U i.1) (fun i => hU i.1)
        (fun x y => genericMarginalEntry ψ S x y) := by
      rw [partialTraceSecond_vectorDensity_genericAssembledState]
      rfl

omit [Field 𝔽] [DecidableEq 𝔽] in
/-- A norm-one global phase does not change a generic reduced matrix. -/
theorem genericMarginalEntry_smul_of_normSq_eq_one
    (phase : ℂ) (hphase : Complex.normSq phase = 1)
    (ψ : GenericState m 𝔽) (S : Finset (GenericParty m)) :
    (fun x y => genericMarginalEntry (phase • ψ) S x y) =
      fun x y => genericMarginalEntry ψ S x y := by
  funext x y
  unfold genericMarginalEntry
  apply Finset.sum_congr rfl
  intro e _
  change
    (phase * ψ (genericAssembleLabel S x e)) *
        conj (phase * ψ (genericAssembleLabel S y e)) =
      ψ (genericAssembleLabel S x e) *
        conj (ψ (genericAssembleLabel S y e))
  rw [map_mul]
  have hphase' : phase * conj phase = 1 := by
    rw [Complex.mul_conj, hphase]
    norm_num
  rw [show
    (phase * ψ (genericAssembleLabel S x e)) *
        (conj phase * conj (ψ (genericAssembleLabel S y e))) =
      (phase * conj phase) *
        (ψ (genericAssembleLabel S x e) *
          conj (ψ (genericAssembleLabel S y e))) by ring,
    hphase', one_mul]

omit [Field 𝔽] in
/-- A generic local-unitary state equality yields product conjugation of
every retained reduced matrix. -/
theorem genericMarginalEntry_eq_productConjugation_of_localAction_eq
    (U : GenericParty m → LocalMatrix 𝔽)
    (hU : ∀ i, IsUnitaryMatrix (U i))
    (phase : ℂ) (hphase : Complex.normSq phase = 1)
    (ψ φ : GenericState m 𝔽)
    (hstate : genericLocalAction U ψ = phase • φ)
    (S : Finset (GenericParty m)) :
    finiteProductUnitaryConjugationEquiv
        (fun i : S => U i.1) (fun i => hU i.1)
        (fun x y => genericMarginalEntry ψ S x y) =
      fun x y => genericMarginalEntry φ S x y := by
  rw [← genericMarginalEntry_localAction U hU ψ S, hstate,
    genericMarginalEntry_smul_of_normSq_eq_one phase hphase φ S]

/-- The amplitude-defined marginal coefficient is its product-Weyl basis
coordinate. -/
theorem genericMarginalWeylCoefficient_eq_finiteProductCoordinate
    (w : WeylConvention 𝔽) (ψ : GenericState m 𝔽)
    (S : Finset (GenericParty m)) (v : S → 𝔽 × 𝔽) :
    genericMarginalWeylCoefficient w ψ S v =
      finiteProductWeylCoordinateEquiv w
        (fun x y => genericMarginalEntry ψ S x y) v := by
  rw [finiteProductWeylCoordinateEquiv_apply]
  simp [finiteProductWeylFunctional,
    genericMarginalWeylCoefficient, Fintype.card_coe]

/-- In product-Weyl coordinates, a generic local-unitary equality is the
independent product of the retained one-qudit conjugation maps. -/
theorem genericMarginalWeylCoordinates_eq_of_localAction_eq
    (w : WeylConvention 𝔽)
    (U : GenericParty m → LocalMatrix 𝔽)
    (hU : ∀ i, IsUnitaryMatrix (U i))
    (phase : ℂ) (hphase : Complex.normSq phase = 1)
    (ψ φ : GenericState m 𝔽)
    (hstate : genericLocalAction U ψ = phase • φ)
    (S : Finset (GenericParty m)) :
    finiteProductUnitaryConjugationWeylEquiv w
        (fun i : S => U i.1) (fun i => hU i.1)
        (fun v => genericMarginalWeylCoefficient w ψ S v) =
      fun v => genericMarginalWeylCoefficient w φ S v := by
  have hmarginal :=
    genericMarginalEntry_eq_productConjugation_of_localAction_eq
      U hU phase hphase ψ φ hstate S
  have hcoordinate :=
    congrArg (finiteProductWeylCoordinateEquiv w) hmarginal
  simpa [finiteProductUnitaryConjugationWeylEquiv,
    genericMarginalWeylCoefficient_eq_finiteProductCoordinate] using
      hcoordinate

end RelativeConicArcs.AMELU
