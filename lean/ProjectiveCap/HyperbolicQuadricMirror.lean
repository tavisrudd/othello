import ProjectiveCap.Mirror
import ProjectiveCap.EllipticMirror

/-!
# Hyperbolic-quadric mirror (C48 harvest)

The generic fixed-point-free-involution mirror theorem
`Projective.initialPStatement_of_fixedPointFree_collinearity_preserving_involution`
is not tied to full projective space.  It applies to the cap/Nofil game on any
subvariety of `PG(V)` whose legality is *ambient* collinearity, because the
mirror-chord obstruction is killed by ambient collinearity + `σ`-invariance
alone (the proof of `mirrorStepGood_of_collinearity_preserving` is local).

This file records that reach:

* `SubCap Q` is the cap game on the sub-board `{p | Q p}` (a position is valid
  iff it is a cap and all its points satisfy `Q`).
* `initialSubCapP_of_fpf_collinearity_preserving` : an fpf collinearity-preserving
  involution `σ` with `Q`-preservation gives a P sub-board.  The **only** new
  obligation beyond C25 is `∀ x, Q x → Q (σ x)`; the cap part reuses
  `mirrorStepGood_of_collinearity_preserving` verbatim.
* Instantiation for the **hyperbolic quadric** `Q⁺(2m−1,q)`, `q` odd: the C25
  elliptic block map `(a,b) ↦ (δ b, a)` (`δ` nonsquare) is a factor-`δ`
  *similarity* of the split form `∑ aᵢ bᵢ`, so it preserves the quadric while
  staying fpf and collinearity-preserving.  Hence the cap game on
  `Q⁺(2m−1,q)` is P for every odd `q` and every `m ≥ 1` (`m ≥ 2` is the
  nontrivial geometric range).

See `notes/2026-07-09-codex-mirror-harvest.md` for the machine gates and the
boundary dichotomy (why elliptic/parabolic quadrics and Hermitian varieties are
*negatives* for this method).
-/

open scoped LinearAlgebra.Projectivization

namespace ProjectiveCap
namespace Projective

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]
variable [Fintype (Point K V)] [DecidableEq (Point K V)]

/-- The cap game restricted to the sub-board `{p | Q p}`: a position is valid
iff it is an ambient cap and every selected point satisfies `Q`. -/
def SubCap (Q : Point K V -> Prop) (S : Finset (Point K V)) : Prop :=
  Cap K V S ∧ ∀ p ∈ S, Q p

/--
Sub-board mirror harvest lemma.

For a fixed-point-free collinearity-preserving involution `σ` that preserves the
sub-board predicate `Q`, the empty position of the `SubCap Q` game is P.  The cap
part is exactly the projective mirror step; the sub-board part only needs that
the mirror reply stays on the board.
-/
theorem initialSubCapP_of_fpf_collinearity_preserving
    (σ : Point K V ≃ Point K V) (Q : Point K V -> Prop)
    (hσ : ∀ x : Point K V, σ (σ x) = x)
    (hfixed : ∀ x : Point K V, σ x ≠ x)
    (hcol : ∀ {a b c : Point K V},
      Collinear K V (σ a) (σ b) (σ c) ↔ Collinear K V a b c)
    (hQ : ∀ x : Point K V, Q x -> Q (σ x)) :
    FiniteBuildGame.IsP (SubCap Q) (∅ : Finset (Point K V)) := by
  have hstepGood : ∀ {S : Finset (Point K V)}, SubCap Q S ->
      FiniteBuildGame.MirrorInvariant σ S ->
        FiniteBuildGame.MirrorStepGood (SubCap Q) σ S := by
    intro S hSub hInv x hx
    have hxcap : FiniteBuildGame.Move (Cap K V) S x := ⟨hx.1, hx.2.1⟩
    have hstep :=
      mirrorStepGood_of_collinearity_preserving (K := K) (V := V)
        σ hσ hfixed hcol hInv x hxcap
    refine ⟨hstep.1, hstep.2, ?_⟩
    intro p hp
    rcases Finset.mem_insert.mp hp with rfl | hp2
    · exact hQ x (hx.2.2 x (Finset.mem_insert_self x S))
    · exact hx.2.2 p hp2
  have hempty : SubCap Q (∅ : Finset (Point K V)) :=
    ⟨cap_empty, by intro p hp; simp at hp⟩
  have hInvEmpty :
      FiniteBuildGame.MirrorInvariant σ (∅ : Finset (Point K V)) := by
    simp [FiniteBuildGame.MirrorInvariant]
  exact FiniteBuildGame.isP_of_invariant_mirror (Valid := SubCap Q) σ hσ
    hstepGood hempty hInvEmpty

/--
Linear-model form: a linear automorphism squaring to a nonsquare scalar induces
an fpf collinearity-preserving projective involution, so if it preserves the
sub-board predicate `Q` the `SubCap Q` game is P.
-/
theorem initialSubCapP_of_linearEquiv_sq_scalar_nonsquare
    (g : V ≃ₗ[K] V) (δ : K) (Q : Point K V -> Prop)
    (hg : ∀ v : V, g (g v) = δ • v) (hnonsquare : ¬ IsSquare δ)
    (hQ : ∀ x : Point K V, Q x -> Q (mapEquiv g x)) :
    FiniteBuildGame.IsP (SubCap Q) (∅ : Finset (Point K V)) := by
  let σ : Point K V ≃ Point K V := mapEquiv g
  have hδ : δ ≠ 0 := by
    intro hδ0; exact hnonsquare (by simp [hδ0])
  have hσ : ∀ x : Point K V, σ (σ x) = x := by
    intro x
    induction x using Projectivization.ind with | h v hv =>
      have hgg_ne : g (g v) ≠ 0 := by simp [hv]
      have hto_scalar :
          Projectivization.mk K (g (g v)) hgg_ne =
            Projectivization.mk K (δ • v) (smul_ne_zero hδ hv) :=
        (Projectivization.mk_eq_mk_iff' K (g (g v)) (δ • v)
          hgg_ne (smul_ne_zero hδ hv)).mpr ⟨1, by simp [hg v]⟩
      have hscalar_id :
          Projectivization.mk K (δ • v) (smul_ne_zero hδ hv) =
            Projectivization.mk K v hv :=
        (Projectivization.mk_eq_mk_iff' K (δ • v) v (smul_ne_zero hδ hv) hv).mpr
          ⟨δ, rfl⟩
      calc
        σ (σ (Projectivization.mk K v hv)) =
            Projectivization.mk K (g (g v)) hgg_ne := by
          dsimp [σ]; rw [mapEquiv_mk, mapEquiv_mk]
        _ = Projectivization.mk K (δ • v) (smul_ne_zero hδ hv) := hto_scalar
        _ = Projectivization.mk K v hv := hscalar_id
  have hfixed : ∀ x : Point K V, σ x ≠ x := by
    intro x hfix
    induction x using Projectivization.ind with | h v hv =>
      have hmap :
          Projectivization.mk K (g v) (by simp [hv]) =
            Projectivization.mk K v hv := by
        simpa [σ, mapEquiv_mk] using hfix
      obtain ⟨lam, hlam⟩ :=
        (Projectivization.mk_eq_mk_iff' K (g v) v (by simp [hv]) hv).mp hmap
      have hscalar : δ • v = (lam * lam) • v := by
        calc
          δ • v = g (g v) := (hg v).symm
          _ = g (lam • v) := by rw [hlam]
          _ = lam • g v := by simp
          _ = lam • (lam • v) := by rw [hlam]
          _ = (lam * lam) • v := by rw [mul_smul]
      have hδeq : δ = lam * lam := smul_left_injective K hv hscalar
      exact hnonsquare ⟨lam, hδeq⟩
  have hcol : ∀ {a b c : Point K V},
      Collinear K V (σ a) (σ b) (σ c) ↔ Collinear K V a b c := by
    intro a b c; exact collinear_mapEquiv (K := K) (V := V) g
  exact initialSubCapP_of_fpf_collinearity_preserving (K := K) (V := V)
    σ Q hσ hfixed hcol hQ

end Projective
end ProjectiveCap

/-!
## The hyperbolic quadric board
-/

namespace ProjectiveCap
namespace Projective

open scoped BigOperators

variable {K : Type*} [Field K]
variable {ι : Type*} [Fintype ι]

/-- Split (hyperbolic) quadratic form `∑ᵢ aᵢ bᵢ` on `ι`-many hyperbolic pairs. -/
def blockForm (v : ι -> K × K) : K := ∑ i, (v i).1 * (v i).2

theorem blockForm_smul (c : K) (v : ι -> K × K) :
    blockForm (c • v) = c ^ 2 * blockForm v := by
  simp only [blockForm, Pi.smul_apply, Prod.smul_fst, Prod.smul_snd, smul_eq_mul]
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl (fun i _ => ?_)
  ring

theorem blockForm_ellipticBlock (δ : K) (hδ : δ ≠ 0) (v : ι -> K × K) :
    blockForm (ellipticBlockLinearEquiv (K := K) (ι := ι) δ hδ v) =
      δ * blockForm v := by
  simp only [blockForm, ellipticBlockLinearEquiv, LinearEquiv.coe_mk, LinearMap.coe_mk,
    AddHom.coe_mk]
  rw [Finset.mul_sum]
  refine Finset.sum_congr rfl (fun i _ => ?_)
  ring

/-- Points of `PG(V)` on the hyperbolic quadric `{∑ aᵢ bᵢ = 0}`. -/
def OnBlockQuadric (p : Point K (ι -> K × K)) : Prop :=
  blockForm (p.rep) = 0

variable [Fintype (Point K (ι -> K × K))] [DecidableEq (Point K (ι -> K × K))]

-- The elliptic block map preserves the hyperbolic quadric (a factor-`δ` similarity of `blockForm`).
omit [Fintype (Point K (ι -> K × K))] [DecidableEq (Point K (ι -> K × K))] in
theorem onBlockQuadric_map (δ : K) (hδ : δ ≠ 0)
    {x : Point K (ι -> K × K)} (hx : OnBlockQuadric (ι := ι) x) :
    OnBlockQuadric (ι := ι)
      (mapEquiv (ellipticBlockLinearEquiv (K := K) (ι := ι) δ hδ) x) := by
  set g := ellipticBlockLinearEquiv (K := K) (ι := ι) δ hδ with hgdef
  have hrep_eq :
      Projectivization.mk K ((mapEquiv g x).rep) (mapEquiv g x).rep_nonzero =
        Projectivization.mk K (g x.rep) (by simp [x.rep_nonzero]) := by
    rw [Projectivization.mk_rep, ← mapEquiv_mk g x.rep_nonzero,
      Projectivization.mk_rep]
  obtain ⟨c, hc⟩ :=
    (Projectivization.mk_eq_mk_iff' K ((mapEquiv g x).rep) (g x.rep)
      (mapEquiv g x).rep_nonzero (by simp [x.rep_nonzero])).mp hrep_eq
  -- hc : c • g x.rep = (mapEquiv g x).rep
  unfold OnBlockQuadric at hx ⊢
  calc
    blockForm ((mapEquiv g x).rep) = blockForm (c • g x.rep) := by rw [hc]
    _ = c ^ 2 * blockForm (g x.rep) := blockForm_smul c (g x.rep)
    _ = c ^ 2 * (δ * blockForm x.rep) := by rw [blockForm_ellipticBlock δ hδ x.rep]
    _ = c ^ 2 * (δ * 0) := by rw [hx]
    _ = 0 := by ring

/--
Hyperbolic-quadric cap game is P: for a nonsquare `δ`, the elliptic block mirror
gives a second-player win on the sub-board `Q⁺(2m−1,q)` (`ι = Fin m`).
-/
theorem initialSubCapP_blockQuadric_of_nonsquare (δ : K) (hnonsquare : ¬ IsSquare δ) :
    FiniteBuildGame.IsP (SubCap (OnBlockQuadric (ι := ι)))
      (∅ : Finset (Point K (ι -> K × K))) := by
  have hδ : δ ≠ 0 := by intro hδ0; exact hnonsquare (by simp [hδ0])
  refine initialSubCapP_of_linearEquiv_sq_scalar_nonsquare
    (ellipticBlockLinearEquiv (K := K) (ι := ι) δ hδ) δ (OnBlockQuadric (ι := ι))
    (ellipticBlockLinearEquiv_sq (K := K) (ι := ι) δ hδ) hnonsquare ?_
  intro x hx
  exact onBlockQuadric_map δ hδ hx

/--
Odd-characteristic corollary: over a finite field of odd cardinality a nonsquare
exists, so the hyperbolic-quadric cap game `Q⁺(2m−1,q)` is P for odd `q`.
-/
theorem initialSubCapP_blockQuadric_of_odd_card [Fintype K] (hq : Odd (Fintype.card K)) :
    FiniteBuildGame.IsP (SubCap (OnBlockQuadric (ι := ι)))
      (∅ : Finset (Point K (ι -> K × K))) := by
  have hchar : ringChar K ≠ 2 := by
    intro hchar
    have hmod : Fintype.card K % 2 = 0 :=
      (FiniteField.even_card_iff_char_two (F := K)).mp hchar
    exact (Nat.not_odd_iff_even.mpr (by rw [Nat.even_iff]; exact hmod)) hq
  letI : Finite K := Fintype.finite (α := K) inferInstance
  rcases FiniteField.exists_nonsquare (F := K) hchar with ⟨δ, hδ⟩
  exact initialSubCapP_blockQuadric_of_nonsquare (ι := ι) δ hδ

end Projective
end ProjectiveCap
