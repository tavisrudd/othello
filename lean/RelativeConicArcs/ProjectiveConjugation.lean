import RelativeConicArcs.ProjectiveBridge
import FiniteGeom.BaerCompletion.BaerPlane

/-!
# Coordinatewise field conjugation on a projective plane

Every field automorphism acts semilinearly on homogeneous coordinates and preserves the standard
point-line orthogonality incidence.  An involutive automorphism therefore supplies the concrete
`InvolutiveIncidence` structure used by the Baer-completion proof spine.
-/

open scoped LinearAlgebra.Projectivization

namespace RelativeConicArcs
namespace ProjectiveConjugation

open FiniteGeom.BaerCompletion Matrix Projectivization

variable {K : Type*} [Field K]

abbrev Point (K : Type*) [Field K] := Projectivization K (Fin 3 → K)

/-- Apply a field automorphism coordinatewise, as a semilinear map. -/
def coordinatewise (σ : K ≃+* K) : (Fin 3 → K) →ₛₗ[σ.toRingHom] (Fin 3 → K) where
  toFun v i := σ (v i)
  map_add' v w := by ext i; simp
  map_smul' a v := by ext i; simp

theorem coordinatewise_injective (σ : K ≃+* K) : Function.Injective (coordinatewise σ) := by
  intro v w h
  ext i
  exact σ.injective (congrFun h i)

/-- The projective action induced by coordinatewise field conjugation. -/
def projectiveMap (σ : K ≃+* K) : Point K → Point K :=
  Projectivization.map (coordinatewise σ) (coordinatewise_injective σ)

/-- Coordinatewise conjugation is a permutation of projective points. -/
noncomputable def projectiveEquiv (σ : K ≃+* K) : Point K ≃ Point K where
  toFun := projectiveMap σ
  invFun := projectiveMap σ.symm
  left_inv p := by
    induction p using Projectivization.ind with
    | h v hv =>
      simp only [projectiveMap, Projectivization.map_mk]
      apply (Projectivization.mk_eq_mk_iff' K _ _ _ _).mpr
      exact ⟨1, by
        ext i
        simp only [Pi.smul_apply, one_smul]
        change v i = σ.symm (σ (v i))
        exact (σ.symm_apply_apply (v i)).symm⟩
  right_inv p := by
    induction p using Projectivization.ind with
    | h v hv =>
      simp only [projectiveMap, Projectivization.map_mk]
      apply (Projectivization.mk_eq_mk_iff' K _ _ _ _).mpr
      exact ⟨1, by
        ext i
        simp only [Pi.smul_apply, one_smul]
        change v i = σ (σ.symm (v i))
        exact (σ.apply_symm_apply (v i)).symm⟩

/-- A projective point represented by `v` is fixed exactly when coordinatewise conjugation sends
`v` to a scalar multiple of itself.  In particular, projective fixedness is weaker than the
chosen representative being coordinatewise fixed. -/
theorem projectiveEquiv_mk_eq_iff (σ : K ≃+* K) (v : Fin 3 → K) (hv : v ≠ 0) :
    projectiveEquiv σ (Projectivization.mk K v hv) = Projectivization.mk K v hv ↔
      ∃ a : K, a • v = coordinatewise σ v := by
  change projectiveMap σ (Projectivization.mk K v hv) = _ ↔ _
  rw [projectiveMap, Projectivization.map_mk,
    Projectivization.mk_eq_mk_iff' K]

/-- A field automorphism preserves projective point-line incidence when applied to both sides. -/
theorem orthogonal_projectiveEquiv_iff (σ : K ≃+* K) (p l : Point K) :
    (projectiveEquiv σ p).orthogonal (projectiveEquiv σ l) ↔ p.orthogonal l := by
  induction p using Projectivization.ind with
  | h v hv =>
    induction l using Projectivization.ind with
    | h w hw =>
      rw [show projectiveEquiv σ (Projectivization.mk K v hv) =
          Projectivization.map (coordinatewise σ) (coordinatewise_injective σ)
            (Projectivization.mk K v hv) from rfl,
        show projectiveEquiv σ (Projectivization.mk K w hw) =
          Projectivization.map (coordinatewise σ) (coordinatewise_injective σ)
            (Projectivization.mk K w hw) from rfl,
        Projectivization.map_mk, Projectivization.map_mk,
        Projectivization.orthogonal_mk, Projectivization.orthogonal_mk]
      change (σ.toRingHom ∘ v) ⬝ᵥ (σ.toRingHom ∘ w) = 0 ↔ v ⬝ᵥ w = 0
      rw [← σ.toRingHom.map_dotProduct]
      exact σ.map_eq_zero_iff

/-- An involutive field automorphism gives the coordinate incidence involution required by the
abstract Baer secant theorems. -/
noncomputable def involutiveIncidence (σ : K ≃+* K) (hinv : ∀ a, σ (σ a) = a) :
    InvolutiveIncidence (Point K) (Point K) where
  incident p l := p.orthogonal l
  pointConj := projectiveEquiv σ
  lineConj := projectiveEquiv σ
  point_involutive p := by
    induction p using Projectivization.ind with
    | h v hv =>
      change projectiveMap σ (projectiveMap σ (Projectivization.mk K v hv)) = _
      simp only [projectiveMap, Projectivization.map_mk]
      apply (Projectivization.mk_eq_mk_iff' K _ _ _ _).mpr
      exact ⟨1, by
        ext i
        simp only [Pi.smul_apply, one_smul]
        change v i = σ (σ (v i))
        exact (hinv (v i)).symm⟩
  line_involutive p := by
    induction p using Projectivization.ind with
    | h v hv =>
      change projectiveMap σ (projectiveMap σ (Projectivization.mk K v hv)) = _
      simp only [projectiveMap, Projectivization.map_mk]
      apply (Projectivization.mk_eq_mk_iff' K _ _ _ _).mpr
      exact ⟨1, by
        ext i
        simp only [Pi.smul_apply, one_smul]
        change v i = σ (σ (v i))
        exact (hinv (v i)).symm⟩
  incident_conj_iff := orthogonal_projectiveEquiv_iff σ

end ProjectiveConjugation
end RelativeConicArcs
