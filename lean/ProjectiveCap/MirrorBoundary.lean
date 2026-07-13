import ProjectiveCap.HyperbolicQuadricMirror
import ProjectiveCap.FiniteQuadraticIsotropy
import ProjectiveCap.FiniteHermitian
import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv
import Mathlib.LinearAlgebra.Eigenspace.Basic

/-!
# Formal boundary reductions for projective mirror arguments

This file proves the linear-algebra reductions and the finite quadratic and Hermitian inputs needed
for the linear parabolic and Hermitian boundaries. It deliberately does **not** assert the full
paper-only classifications: the Baer-semilinear branches and the elliptic nonsplit classification
remain explicit obligations in the accompanying trust note.
-/

open scoped LinearAlgebra.Projectivization

namespace ProjectiveCap
namespace Projective

open FiniteQuadraticIsotropy

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]

/-- A sub-board contains a fixed point of a projective symmetry. -/
def HasFixedPointOn (Q : Point K V → Prop) (σ : Point K V ≃ Point K V) : Prop :=
  ∃ x, Q x ∧ σ x = x

/-- A projective symmetry is fixed-point-free on a sub-board. -/
def FixedPointFreeOn (Q : Point K V → Prop) (σ : Point K V ≃ Point K V) : Prop :=
  ∀ x, Q x → σ x ≠ x

theorem not_fixedPointFreeOn_of_hasFixedPointOn {Q : Point K V → Prop}
    {σ : Point K V ≃ Point K V} (h : HasFixedPointOn Q σ) : ¬ FixedPointFreeOn Q σ := by
  rintro hfpf
  obtain ⟨x, hxQ, hx⟩ := h
  exact hfpf x hxQ hx

/-- An isotropic eigenvector is exactly the local obstruction needed to refute a mirror on a
quadric/Hermitian sub-board. The hard family-specific task is to produce such an eigenvector. -/
theorem hasFixedPointOn_of_eigenvector (g : V ≃ₗ[K] V) (Q : Point K V → Prop)
    {v : V} (hv : v ≠ 0) {a : K} (hgv : g v = a • v)
    (hQ : Q (Projectivization.mk K v hv)) :
    HasFixedPointOn Q (mapEquiv g) := by
  exact ⟨Projectivization.mk K v hv, hQ, mapEquiv_fixed_of_eq_smul g hv hgv⟩

/-- A mirror that is fixed-point-free on a quadratic/Hermitian board has no eigenline on that
board. Equivalently, each eigenspace is anisotropic for the board predicate. -/
theorem no_board_eigenvector_of_fixedPointFreeOn (g : V ≃ₗ[K] V)
    (Q : Point K V → Prop) (hfpf : FixedPointFreeOn Q (mapEquiv g))
    {v : V} (hv : v ≠ 0) {a : K} (hgv : g v = a • v) :
    ¬ Q (Projectivization.mk K v hv) := by
  intro hQ
  exact hfpf _ hQ (mapEquiv_fixed_of_eq_smul g hv hgv)

/-!
## Quadratic boards and the split linear obstruction
-/

/-- The projective quadric cut out by a quadratic form. Using the canonical representative makes
this definition directly compatible with the existing projective-board API. -/
def OnQuadraticForm (Q : QuadraticForm K V) (p : Point K V) : Prop :=
  Q p.rep = 0

/-- A nonzero isotropic vector determines a point of its projective quadric. -/
theorem onQuadraticForm_mk (Q : QuadraticForm K V) {v : V} (hv : v ≠ 0) (hQ : Q v = 0) :
    OnQuadraticForm Q (Projectivization.mk K v hv) := by
  have hrep_eq :
      Projectivization.mk K (Projectivization.mk K v hv).rep
          (Projectivization.mk K v hv).rep_nonzero =
        Projectivization.mk K v hv := Projectivization.mk_rep _
  obtain ⟨c, hc⟩ :=
    (Projectivization.mk_eq_mk_iff' K (Projectivization.mk K v hv).rep v
      (Projectivization.mk K v hv).rep_nonzero hv).mp hrep_eq
  unfold OnQuadraticForm
  rw [← hc, QuadraticMap.map_smul, hQ, smul_zero]

section Split

variable [Fintype K] [FiniteDimensional K V]

omit [Fintype K] [FiniteDimensional K V] in
/-- In odd characteristic an involution splits the vector space into its `+1` and `-1`
eigenspaces. -/
theorem isCompl_eigenspaces_one_neg_one (hchar : ringChar K ≠ 2)
    (g : V ≃ₗ[K] V) (hg : ∀ v, g (g v) = v) :
    IsCompl (Module.End.eigenspace g.toLinearMap 1)
      (Module.End.eigenspace g.toLinearMap (-1)) := by
  have hone : (1 : K) ≠ -1 := (Ring.neg_one_ne_one_of_char_ne_two hchar).symm
  have hdisjoint :
      Disjoint (Module.End.eigenspace g.toLinearMap 1)
        (Module.End.eigenspace g.toLinearMap (-1)) :=
    (Module.End.eigenspaces_iSupIndep g.toLinearMap).pairwiseDisjoint hone
  refine ⟨hdisjoint, codisjoint_iff.mpr (eq_top_iff.mpr fun v _ => ?_)⟩
  let vp : V := (2 : K)⁻¹ • (v + g v)
  let vm : V := (2 : K)⁻¹ • (v - g v)
  have hvp : vp ∈ Module.End.eigenspace g.toLinearMap 1 := by
    rw [Module.End.mem_eigenspace_iff]
    simp only [LinearEquiv.coe_coe, one_smul, vp, map_smul, map_add, hg]
    rw [add_comm]
  have hvm : vm ∈ Module.End.eigenspace g.toLinearMap (-1) := by
    rw [Module.End.mem_eigenspace_iff]
    simp only [LinearEquiv.coe_coe, vm, map_smul, map_sub, hg, neg_smul]
    module
  have hsum : vp + vm = v := by
    calc
      vp + vm = (2 : K)⁻¹ • ((v + g v) + (v - g v)) := by
        simp only [vp, vm, smul_add]
      _ = (2 : K)⁻¹ • ((2 : K) • v) := by
        congr 1
        module
      _ = ((2 : K)⁻¹ * 2) • v := by rw [smul_smul]
      _ = v := by rw [inv_mul_cancel₀ (Ring.two_ne_zero hchar), one_smul]
  rw [← hsum]
  exact Submodule.add_mem_sup hvp hvm

omit [Fintype K] in
/-- If an odd-characteristic involution acts on a space of dimension at least five, one of its two
eigenspaces has dimension at least three. -/
theorem three_le_finrank_eigenspace_one_or_neg_one (hchar : ringChar K ≠ 2)
    (g : V ≃ₗ[K] V) (hg : ∀ v, g (g v) = v)
    (hdim : 5 ≤ Module.finrank K V) :
    3 ≤ Module.finrank K (Module.End.eigenspace g.toLinearMap 1) ∨
      3 ≤ Module.finrank K (Module.End.eigenspace g.toLinearMap (-1)) := by
  have hsum := Submodule.finrank_add_eq_of_isCompl (isCompl_eigenspaces_one_neg_one hchar g hg)
  omega

/-- Every split projective involution in dimension at least five fixes a point on every projective
quadric. The fixed point comes from a nonzero isotropic vector in a large eigenspace. -/
theorem hasFixedPointOn_quadric_of_involution_finrank_five
    (hchar : ringChar K ≠ 2) (Q : QuadraticForm K V)
    (g : V ≃ₗ[K] V) (hg : ∀ v, g (g v) = v)
    (hdim : 5 ≤ Module.finrank K V) :
    HasFixedPointOn (OnQuadraticForm Q) (mapEquiv g) := by
  rcases three_le_finrank_eigenspace_one_or_neg_one hchar g hg hdim with hp | hm
  · obtain ⟨v, hv, hQv⟩ :=
      exists_ne_zero_quadraticForm_eq_zero hchar
        (Q.restrict (Module.End.eigenspace g.toLinearMap 1)) hp
    exact hasFixedPointOn_of_eigenvector g (OnQuadraticForm Q) (Subtype.coe_ne_coe.mpr hv)
      (Module.End.mem_eigenspace_iff.mp v.property) (onQuadraticForm_mk Q
        (Subtype.coe_ne_coe.mpr hv) hQv)
  · obtain ⟨v, hv, hQv⟩ :=
      exists_ne_zero_quadraticForm_eq_zero hchar
        (Q.restrict (Module.End.eigenspace g.toLinearMap (-1))) hm
    exact hasFixedPointOn_of_eigenvector g (OnQuadraticForm Q) (Subtype.coe_ne_coe.mpr hv)
      (Module.End.mem_eigenspace_iff.mp v.property) (onQuadraticForm_mk Q
        (Subtype.coe_ne_coe.mpr hv) hQv)

/-- Unnormalized split-scalar form of the preceding theorem. If `g² = r² I` with `r ≠ 0`, scale
`g` by `r⁻¹` to obtain an involution. Scalar rescaling does not change the induced projective map,
so the isotropic fixed point is a fixed point of the original representative. -/
theorem hasFixedPointOn_quadric_of_sq_square_finrank_five
    (hchar : ringChar K ≠ 2) (Q : QuadraticForm K V)
    (g : V ≃ₗ[K] V) (r : K) (hr : r ≠ 0)
    (hg : ∀ v, g (g v) = (r * r) • v)
    (hdim : 5 ≤ Module.finrank K V) :
    HasFixedPointOn (OnQuadraticForm Q) (mapEquiv g) := by
  let scaleInv : V ≃ₗ[K] V :=
    DistribMulAction.toLinearEquiv K V (Units.mk0 r⁻¹ (inv_ne_zero hr))
  let gn : V ≃ₗ[K] V := g.trans scaleInv
  have hgn_apply (v : V) : gn v = r⁻¹ • g v := by
    simp [gn, scaleInv]
  have hgn_sq (v : V) : gn (gn v) = v := by
    rw [hgn_apply, hgn_apply, map_smul, hg, smul_smul, smul_smul]
    have hscalar : r⁻¹ * r⁻¹ * (r * r) = 1 := by field_simp
    rw [hscalar, one_smul]
  have hmap (x : Point K V) : mapEquiv gn x = mapEquiv g x := by
    induction x using Projectivization.ind with | h v hv =>
      rw [mapEquiv_mk, mapEquiv_mk]
      apply (Projectivization.mk_eq_mk_iff' K (gn v) (g v) (by simp [hv]) (by simp [hv])).mpr
      exact ⟨r⁻¹, (hgn_apply v).symm⟩
  obtain ⟨x, hxQ, hxfix⟩ :=
    hasFixedPointOn_quadric_of_involution_finrank_five hchar Q gn hgn_sq hdim
  exact ⟨x, hxQ, by rw [← hmap x]; exact hxfix⟩

/-- Formalized split half of the parabolic obstruction. The vector space underlying
`Q(2m,q)` has dimension `2m+1 ≥ 5` for `m ≥ 2`, so a linear involution always fixes an isotropic
projective point and cannot be fixed-point-free on the parabolic quadric. -/
theorem parabolic_split_linear_route_not_fixedPointFree {m : ℕ} (hm : 2 ≤ m)
    (hchar : ringChar K ≠ 2) (Q : QuadraticForm K (Fin (2 * m + 1) → K))
    (g : (Fin (2 * m + 1) → K) ≃ₗ[K] (Fin (2 * m + 1) → K))
    (hg : ∀ v, g (g v) = v) :
    ¬ FixedPointFreeOn (OnQuadraticForm Q) (mapEquiv g) := by
  apply not_fixedPointFreeOn_of_hasFixedPointOn
  apply hasFixedPointOn_quadric_of_involution_finrank_five hchar Q g hg
  simp only [Module.finrank_fin_fun]
  omega

/-- Strict split-route statement in the scalar-square normal form supplied by a projective
involution: `g² = r² I`. -/
theorem parabolic_split_scalar_square_route_not_fixedPointFree {m : ℕ} (hm : 2 ≤ m)
    (hchar : ringChar K ≠ 2) (Q : QuadraticForm K (Fin (2 * m + 1) → K))
    (g : (Fin (2 * m + 1) → K) ≃ₗ[K] (Fin (2 * m + 1) → K))
    (r : K) (hr : r ≠ 0) (hg : ∀ v, g (g v) = (r * r) • v) :
    ¬ FixedPointFreeOn (OnQuadraticForm Q) (mapEquiv g) := by
  apply not_fixedPointFreeOn_of_hasFixedPointOn
  apply hasFixedPointOn_quadric_of_sq_square_finrank_five hchar Q g r hr hg
  simp only [Module.finrank_fin_fun]
  omega

end Split

/-!
## Hermitian boards and the linear obstruction
-/

section Hermitian

variable {F : Type*} [Field F] [Fintype F]
variable [Fintype K] [Algebra F K] [FiniteDimensional K V]

/-- The projective Hermitian variety cut out by a finite-field Hermitian form. -/
def OnHermitianForm (B : FiniteHermitian.Form (F := F) (K := K) (V := V))
    (p : Point K V) : Prop :=
  B p.rep p.rep = 0

omit [FiniteDimensional K V] in
/-- A nonzero isotropic vector determines a point of its projective Hermitian variety. -/
theorem onHermitianForm_mk (B : FiniteHermitian.Form (F := F) (K := K) (V := V))
    {v : V} (hv : v ≠ 0) (hBv : B v v = 0) :
    OnHermitianForm B (Projectivization.mk K v hv) := by
  have hrep_eq :
      Projectivization.mk K (Projectivization.mk K v hv).rep
          (Projectivization.mk K v hv).rep_nonzero =
        Projectivization.mk K v hv := Projectivization.mk_rep _
  obtain ⟨c, hc⟩ :=
    (Projectivization.mk_eq_mk_iff' K (Projectivization.mk K v hv).rep v
      (Projectivization.mk K v hv).rep_nonzero hv).mp hrep_eq
  unfold OnHermitianForm
  rw [← hc]
  simp [LinearMap.map_smulₛₗ, FiniteHermitian.conjRingHom_apply, LinearMap.smul_apply,
    hBv]

omit [Fintype F] [Fintype K] [Algebra F K] in
/-- In dimension at least three, one eigenspace of an odd-characteristic involution has dimension
at least two. -/
theorem two_le_finrank_eigenspace_one_or_neg_one (hchar : ringChar K ≠ 2)
    (g : V ≃ₗ[K] V) (hg : ∀ v, g (g v) = v)
    (hdim : 3 ≤ Module.finrank K V) :
    2 ≤ Module.finrank K (Module.End.eigenspace g.toLinearMap 1) ∨
      2 ≤ Module.finrank K (Module.End.eigenspace g.toLinearMap (-1)) := by
  have hsum := Submodule.finrank_add_eq_of_isCompl (isCompl_eigenspaces_one_neg_one hchar g hg)
  omega

/-- Every split projective involution in Hermitian dimension at least three fixes a Hermitian
point. -/
theorem hasFixedPointOn_hermitian_of_involution_finrank_three
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2)
    (B : FiniteHermitian.Form (F := F) (K := K) (V := V))
    (hB : FiniteHermitian.IsHermitian B)
    (g : V ≃ₗ[K] V) (hg : ∀ v, g (g v) = v)
    (hdim : 3 ≤ Module.finrank K V) :
    HasFixedPointOn (OnHermitianForm B) (mapEquiv g) := by
  have hcharK : ringChar K ≠ 2 := by
    rwa [← Algebra.ringChar_eq F K]
  rcases two_le_finrank_eigenspace_one_or_neg_one hcharK g hg hdim with hp | hm
  · obtain ⟨v, hv, hBv⟩ := FiniteHermitian.exists_ne_zero_self_eq_zero hfinrank
      (B.domRestrict₁₂ (Module.End.eigenspace g.toLinearMap 1)
        (Module.End.eigenspace g.toLinearMap 1))
      (hB.restrict (Module.End.eigenspace g.toLinearMap 1)) hp
    exact hasFixedPointOn_of_eigenvector g (OnHermitianForm B) (Subtype.coe_ne_coe.mpr hv)
      (Module.End.mem_eigenspace_iff.mp v.property)
      (onHermitianForm_mk B (Subtype.coe_ne_coe.mpr hv) hBv)
  · obtain ⟨v, hv, hBv⟩ := FiniteHermitian.exists_ne_zero_self_eq_zero hfinrank
      (B.domRestrict₁₂ (Module.End.eigenspace g.toLinearMap (-1))
        (Module.End.eigenspace g.toLinearMap (-1)))
      (hB.restrict (Module.End.eigenspace g.toLinearMap (-1))) hm
    exact hasFixedPointOn_of_eigenvector g (OnHermitianForm B) (Subtype.coe_ne_coe.mpr hv)
      (Module.End.mem_eigenspace_iff.mp v.property)
      (onHermitianForm_mk B (Subtype.coe_ne_coe.mpr hv) hBv)

/-- Scalar-square version of the Hermitian split obstruction. -/
theorem hasFixedPointOn_hermitian_of_sq_square_finrank_three
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2)
    (B : FiniteHermitian.Form (F := F) (K := K) (V := V))
    (hB : FiniteHermitian.IsHermitian B)
    (g : V ≃ₗ[K] V) (r : K) (hr : r ≠ 0)
    (hg : ∀ v, g (g v) = (r * r) • v)
    (hdim : 3 ≤ Module.finrank K V) :
    HasFixedPointOn (OnHermitianForm B) (mapEquiv g) := by
  let scaleInv : V ≃ₗ[K] V :=
    DistribMulAction.toLinearEquiv K V (Units.mk0 r⁻¹ (inv_ne_zero hr))
  let gn : V ≃ₗ[K] V := g.trans scaleInv
  have hgn_apply (v : V) : gn v = r⁻¹ • g v := by simp [gn, scaleInv]
  have hgn_sq (v : V) : gn (gn v) = v := by
    rw [hgn_apply, hgn_apply, map_smul, hg, smul_smul, smul_smul]
    have hscalar : r⁻¹ * r⁻¹ * (r * r) = 1 := by field_simp
    rw [hscalar, one_smul]
  have hmap (x : Point K V) : mapEquiv gn x = mapEquiv g x := by
    induction x using Projectivization.ind with | h v hv =>
      rw [mapEquiv_mk, mapEquiv_mk]
      apply (Projectivization.mk_eq_mk_iff' K (gn v) (g v) (by simp [hv]) (by simp [hv])).mpr
      exact ⟨r⁻¹, (hgn_apply v).symm⟩
  obtain ⟨x, hxB, hxfix⟩ :=
    hasFixedPointOn_hermitian_of_involution_finrank_three hfinrank hchar B hB gn hgn_sq hdim
  exact ⟨x, hxB, by rw [← hmap x]; exact hxfix⟩

/-- Formalized split linear route for every nontrivial Hermitian variety `H(k,q²)`, `k ≥ 2`. -/
theorem hermitian_split_scalar_square_route_not_fixedPointFree {k : ℕ} (hk : 2 ≤ k)
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2)
    (B : FiniteHermitian.Form (F := F) (K := K) (V := Fin (k + 1) → K))
    (hB : FiniteHermitian.IsHermitian B)
    (g : (Fin (k + 1) → K) ≃ₗ[K] (Fin (k + 1) → K))
    (r : K) (hr : r ≠ 0) (hg : ∀ v, g (g v) = (r * r) • v) :
    ¬ FixedPointFreeOn (OnHermitianForm B) (mapEquiv g) := by
  apply not_fixedPointFreeOn_of_hasFixedPointOn
  apply hasFixedPointOn_hermitian_of_sq_square_finrank_three hfinrank hchar B hB g r hr hg
  simp only [Module.finrank_fin_fun]
  omega

omit [FiniteDimensional K V] in
/-- Formalized nonsplit linear route: a nondegenerate Hermitian similitude with base-field
multiplier cannot square to a nonsquare scalar. -/
theorem hermitian_nonsplit_linear_route_impossible [Nontrivial V]
    (hfinrank : Module.finrank F K = 2) (hchar : ringChar F ≠ 2)
    (B : FiniteHermitian.Form (F := F) (K := K) (V := V)) (hB : B.Nondegenerate)
    (g : V ≃ₗ[K] V) (c : K) (μ : F)
    (hg : ∀ v, g (g v) = c • v)
    (hsim : ∀ x y, B (g x) (g y) = algebraMap F K μ * B x y)
    (hnonsquare : ¬ IsSquare c) : False :=
  FiniteHermitian.no_similitude_sq_nonsquare hfinrank hchar B hB g c μ hg hsim hnonsquare

end Hermitian

/-- Determinant parity obstruction. If an invertible `(2m+1)×(2m+1)` matrix squares to
`δ I`, then `δ` is a square. Thus a nonsplit square-scalar projective involution cannot act on an
odd-dimensional vector space. -/
theorem isSquare_scalar_of_matrix_sq_odd {m : ℕ}
    (A : Matrix (Fin (2 * m + 1)) (Fin (2 * m + 1)) K) (δ : K)
    (hδ : δ ≠ 0) (hA : A * A = δ • (1 : Matrix (Fin (2 * m + 1)) (Fin (2 * m + 1)) K)) :
    IsSquare δ := by
  have hdet : A.det * A.det = δ ^ (2 * m + 1) := by
    calc
      A.det * A.det = (A * A).det := (Matrix.det_mul A A).symm
      _ = (δ • (1 : Matrix (Fin (2 * m + 1)) (Fin (2 * m + 1)) K)).det := by rw [hA]
      _ = δ ^ (2 * m + 1) := by simp
  have hpow : δ ^ (2 * m + 1) = δ * (δ ^ m) ^ 2 := by ring
  refine ⟨A.det / δ ^ m, ?_⟩
  field_simp
  rw [hpow] at hdet
  simpa [pow_two] using hdet.symm

theorem no_matrix_sq_nonsquare_in_odd_dimension {m : ℕ}
    (A : Matrix (Fin (2 * m + 1)) (Fin (2 * m + 1)) K) (δ : K)
    (hδ : δ ≠ 0) (hnonsquare : ¬ IsSquare δ) :
    A * A ≠ δ • (1 : Matrix (Fin (2 * m + 1)) (Fin (2 * m + 1)) K) := by
  intro hA
  exact hnonsquare (isSquare_scalar_of_matrix_sq_odd A δ hδ hA)

/-- Formalized nonsplit half of the parabolic obstruction: the vector space underlying
`Q(2m,q)` has odd dimension `2m+1`, so it cannot carry a linear projective involution represented
by `A² = δ I` with `δ` nonsquare. Together with
`parabolic_split_scalar_square_route_not_fixedPointFree`, this completes the linear branches; the
Baer-semilinear branch remains C87. -/
theorem parabolic_nonsplit_linear_route_impossible {m : ℕ}
    (A : Matrix (Fin (2 * m + 1)) (Fin (2 * m + 1)) K) (δ : K)
    (hδ : δ ≠ 0) (hnonsquare : ¬ IsSquare δ) :
    A * A ≠ δ • (1 : Matrix (Fin (2 * m + 1)) (Fin (2 * m + 1)) K) :=
  no_matrix_sq_nonsquare_in_odd_dimension A δ hδ hnonsquare

end Projective
end ProjectiveCap
