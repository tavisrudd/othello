import CapGame.Mirror
import ProjectiveCap.Projective
import ProjectiveCap.PlaneTransitivity

/-!
# Mirror wrappers for the projective cap game

The theorems here specialize the generic finite-building-game mirror lemmas to
`Projective.Cap`.  Geometry-specific files can use these once they prove that a
chosen projective symmetry supplies legal mirror replies and preserves the
closed class of positions.
-/

open scoped LinearAlgebra.Projectivization

namespace ProjectiveCap
namespace Projective

variable {K V : Type*} [Field K] [AddCommGroup V] [Module K V]
variable [DecidableEq (Point K V)]

omit [DecidableEq (Point K V)] in
theorem collinear_swap_left {a b c : Point K V} :
    Collinear K V a b c ↔ Collinear K V b a c := by
  rw [Collinear, Collinear, Set.insert_comm a b {c}]

omit [DecidableEq (Point K V)] in
theorem collinear_rotate_right {a b c : Point K V} :
    Collinear K V a b c ↔ Collinear K V c a b := by
  rw [Collinear, Collinear]
  have h : ({a, b, c} : Set (Point K V)) = ({c, a, b} : Set (Point K V)) := by
    ext z
    simp [or_comm, or_left_comm]
  rw [h]

omit [DecidableEq (Point K V)] in
theorem collinear_swap_right {a b c : Point K V} :
    Collinear K V a b c ↔ Collinear K V a c b := by
  rw [Collinear, Collinear]
  have h : ({a, b, c} : Set (Point K V)) = ({a, c, b} : Set (Point K V)) := by
    ext z
    simp [or_comm]
  rw [h]

theorem cap_insert_of_cap {S : Finset (Point K V)} {y : Point K V}
    (hS : Cap K V S) (hnew : y ∉ S)
    (hline : ∀ ⦃p q : Point K V⦄, p ∈ S -> q ∈ S ->
      y ≠ p -> y ≠ q -> p ≠ q -> ¬ Collinear K V y p q) :
    Cap K V (insert y S) := by
  intro a b c ha hb hc hab hac hbc hcol
  by_cases hay : a = y
  · subst hay
    have hbS : b ∈ S := by simpa [Finset.mem_insert, hab.symm] using hb
    have hcS : c ∈ S := by simpa [Finset.mem_insert, hac.symm] using hc
    exact hline hbS hcS hab hac hbc hcol
  by_cases hby : b = y
  · subst hby
    have haS : a ∈ S := by simpa [Finset.mem_insert, hab] using ha
    have hcS : c ∈ S := by simpa [Finset.mem_insert, hbc.symm] using hc
    exact hline haS hcS (Ne.symm hab) hbc hac
      ((collinear_swap_left (K := K) (V := V)).mp hcol)
  by_cases hcy : c = y
  · subst hcy
    have haS : a ∈ S := by simpa [Finset.mem_insert, hac] using ha
    have hbS : b ∈ S := by simpa [Finset.mem_insert, hbc] using hb
    exact hline haS hbS (Ne.symm hac) (Ne.symm hbc) hab
      ((collinear_rotate_right (K := K) (V := V)).mp hcol)
  exact hS (by simpa [hay] using ha) (by simpa [hby] using hb)
    (by simpa [hcy] using hc) hab hac hbc hcol

/--
Projective local mirror-step criterion with the genuine mirror-chord
obstruction made explicit.

The first part of the proof handles old-old obstructions using collinearity
preservation. The `hchord` hypothesis handles exactly the missing case where
the mirror chord through `x` and `σ x` hits an already selected point.
-/
theorem mirrorStepGood_of_collinearity_preserving_no_chord
    (σ : Point K V ≃ Point K V)
    (hσ : ∀ x : Point K V, σ (σ x) = x)
    (hfixed : ∀ x : Point K V, σ x ≠ x)
    (hcol : ∀ {a b c : Point K V},
      Collinear K V (σ a) (σ b) (σ c) ↔ Collinear K V a b c)
    {S : Finset (Point K V)}
    (hInv : FiniteBuildGame.MirrorInvariant σ S)
    (hchord : ∀ {x z : Point K V}, FiniteBuildGame.Move (Cap K V) S x ->
      z ∈ S -> ¬ Collinear K V (σ x) x z) :
    FiniteBuildGame.MirrorStepGood (Cap K V) σ S := by
  intro x hxmove
  have hsigNotS : σ x ∉ S := by
    intro hxS
    exact hxmove.1
      (FiniteBuildGame.mem_of_apply_mem_mirrorInvariant hσ hInv hxS)
  have hsigNot : σ x ∉ insert x S := by
    intro hxIns
    rcases Finset.mem_insert.mp hxIns with hxEq | hxS
    · exact hfixed x hxEq
    · exact hsigNotS hxS
  refine ⟨hsigNot, ?_⟩
  refine cap_insert_of_cap (K := K) (V := V) hxmove.2 hsigNot ?_
  intro p q hp hq hyp hyq hpq hpqcol
  rcases Finset.mem_insert.mp hp with rfl | hpS
  · have hqS : q ∈ S := by
      rcases Finset.mem_insert.mp hq with hqx | hqS
      · exact (hpq hqx.symm).elim
      · exact hqS
    exact hchord hxmove hqS hpqcol
  rcases Finset.mem_insert.mp hq with rfl | hqS
  · exact hchord hxmove hpS
      ((collinear_swap_right (K := K) (V := V)).mp hpqcol)
  · have hσpS : σ p ∈ S :=
      FiniteBuildGame.apply_mem_of_mirrorInvariant hInv hpS
    have hσqS : σ q ∈ S :=
      FiniteBuildGame.apply_mem_of_mirrorInvariant hInv hqS
    have hx_ne_σp : x ≠ σ p := by
      intro hxp
      apply hsigNotS
      have hp_eq : σ x = p := by
        rw [hxp, hσ p]
      simpa [hp_eq] using hpS
    have hx_ne_σq : x ≠ σ q := by
      intro hxq
      apply hsigNotS
      have hq_eq : σ x = q := by
        rw [hxq, hσ q]
      simpa [hq_eq] using hqS
    have hσp_ne_σq : σ p ≠ σ q := fun h => hpq (σ.injective h)
    have hcol' : Collinear K V x (σ p) (σ q) := by
      have hcol2 :
          Collinear K V (σ (σ x)) (σ p) (σ q) :=
        (hcol (a := σ x) (b := p) (c := q)).mpr hpqcol
      simpa [hσ x] using hcol2
    exact hxmove.2 (by simp) (by simp [hσpS]) (by simp [hσqS])
      hx_ne_σp hx_ne_σq hσp_ne_σq hcol'

/--
Projective local mirror-step criterion for a fixed-point-free collinearity
preserving involution.

The old-old obstruction is reflected by the collinearity-preservation
hypothesis.  The mirror-chord obstruction is ruled out because if an old point
`z` lies on the line through `x` and `σ x`, then its mirror `σ z` lies on the
same line too; the old pair `z, σ z` would have already blocked `x`.
-/
theorem mirrorStepGood_of_collinearity_preserving
    (σ : Point K V ≃ Point K V)
    (hσ : ∀ x : Point K V, σ (σ x) = x)
    (hfixed : ∀ x : Point K V, σ x ≠ x)
    (hcol : ∀ {a b c : Point K V},
      Collinear K V (σ a) (σ b) (σ c) ↔ Collinear K V a b c)
    {S : Finset (Point K V)}
    (hInv : FiniteBuildGame.MirrorInvariant σ S) :
    FiniteBuildGame.MirrorStepGood (Cap K V) σ S := by
  refine mirrorStepGood_of_collinearity_preserving_no_chord
    (K := K) (V := V) σ hσ hfixed hcol hInv ?_
  intro x z hxmove hzS hchord
  have hσzS : σ z ∈ S :=
    FiniteBuildGame.apply_mem_of_mirrorInvariant hInv hzS
  have hx_σx : x ≠ σ x := (hfixed x).symm
  have hline_z : Collinear K V x (σ x) z :=
    (collinear_swap_left (K := K) (V := V)).mp hchord
  have hline_σz : Collinear K V x (σ x) (σ z) := by
    have hline :
        Collinear K V (σ (σ x)) (σ x) (σ z) :=
      (hcol (a := σ x) (b := x) (c := z)).mpr hchord
    simpa [hσ x] using hline
  have hblocked : Collinear K V x z (σ z) :=
    collinear_of_collinear_pair (K := K) (V := V) hx_σx hline_z hline_σz
  have hxz : x ≠ z := by
    intro hxz
    exact hxmove.1 (by simpa [hxz] using hzS)
  have hxσz : x ≠ σ z := by
    intro hxσz
    exact hxmove.1 (by simpa [hxσz] using hσzS)
  have hzσz : z ≠ σ z := by
    intro hzσz
    exact hfixed z hzσz.symm
  exact hxmove.2 (by simp) (by simp [hzS]) (by simp [hσzS])
    hxz hxσz hzσz hblocked

variable [Fintype (Point K V)]

/--
Projective cap-game wrapper for a closed mirror strategy.

`Good` is the closed class of projective positions on which the mirror strategy
continues.  The hypothesis says that every legal move from a `Good` position is
answered by `σ`, and the two-move follower is again `Good`.
-/
theorem initialPStatement_of_closedMirror
    (σ : Point K V ≃ Point K V) {Good : Finset (Point K V) -> Prop}
    (hempty : Good ∅)
    (hstep : ∀ {S : Finset (Point K V)}, Good S -> ∀ x : Point K V,
      FiniteBuildGame.Move (Cap K V) S x ->
        FiniteBuildGame.Move (Cap K V) (insert x S) (σ x) ∧
          Good (insert (σ x) (insert x S))) :
    InitialPStatement (K := K) (V := V) := by
  simpa [InitialPStatement] using
    FiniteBuildGame.isP_of_closedMirror
      (Valid := Cap K V) (Good := Good) σ hstep
      (∅ : Finset (Point K V)) hempty

/--
Projective cap-game wrapper split into a one-step mirror condition and a
closure condition.
-/
theorem initialPStatement_of_mirrorStep_closed
    (σ : Point K V ≃ Point K V) {Good : Finset (Point K V) -> Prop}
    (hempty : Good ∅)
    (hstepGood : ∀ {S : Finset (Point K V)}, Good S ->
      FiniteBuildGame.MirrorStepGood (Cap K V) σ S)
    (hclosed : ∀ {S : Finset (Point K V)}, Good S -> ∀ x : Point K V,
      FiniteBuildGame.Move (Cap K V) S x ->
        Good (insert (σ x) (insert x S))) :
    InitialPStatement (K := K) (V := V) := by
  simpa [InitialPStatement] using
    FiniteBuildGame.isP_of_mirrorStep_closed
      (Valid := Cap K V) (Good := Good) σ hstepGood hclosed
      (∅ : Finset (Point K V)) hempty

/--
Projective cap-game wrapper for the common case where the closed class is all
valid positions invariant under an involutive board equivalence.
-/
theorem initialPStatement_of_invariant_mirror
    (σ : Point K V ≃ Point K V)
    (hσ : ∀ x : Point K V, σ (σ x) = x)
    (hstepGood : ∀ {S : Finset (Point K V)}, Cap K V S ->
      FiniteBuildGame.MirrorInvariant σ S ->
        FiniteBuildGame.MirrorStepGood (Cap K V) σ S) :
    InitialPStatement (K := K) (V := V) := by
  have hemptyInv :
      FiniteBuildGame.MirrorInvariant σ (∅ : Finset (Point K V)) := by
    simp [FiniteBuildGame.MirrorInvariant]
  simpa [InitialPStatement] using
    FiniteBuildGame.isP_of_invariant_mirror
      (Valid := Cap K V) σ hσ hstepGood
      (S := (∅ : Finset (Point K V))) (cap_empty (K := K) (V := V)) hemptyInv

/--
Whole-board projective mirror theorem: a fixed-point-free collinearity-preserving
projective involution gives a second-player win from the empty cap-game
position.
-/
theorem initialPStatement_of_fixedPointFree_collinearity_preserving_involution
    (σ : Point K V ≃ Point K V)
    (hσ : ∀ x : Point K V, σ (σ x) = x)
    (hfixed : ∀ x : Point K V, σ x ≠ x)
    (hcol : ∀ {a b c : Point K V},
      Collinear K V (σ a) (σ b) (σ c) ↔ Collinear K V a b c) :
    InitialPStatement (K := K) (V := V) := by
  exact initialPStatement_of_invariant_mirror (K := K) (V := V) σ hσ
    (fun {_S} _hcap hInv =>
      mirrorStepGood_of_collinearity_preserving
        (K := K) (V := V) σ hσ hfixed hcol hInv)

/--
Linear-algebra bridge for elliptic projective mirrors.

If a linear automorphism squares to multiplication by a nonsquare scalar, then
the induced projective collineation is an involutive fixed-point-free mirror,
so the projective cap game is P from the empty position.
-/
theorem initialPStatement_of_linearEquiv_sq_scalar_nonsquare
    (g : V ≃ₗ[K] V) (δ : K)
    (hg : ∀ v : V, g (g v) = δ • v)
    (hnonsquare : ¬ IsSquare δ) :
    InitialPStatement (K := K) (V := V) := by
  let σ : Point K V ≃ Point K V := mapEquiv g
  have hδ : δ ≠ 0 := by
    intro hδ0
    exact hnonsquare (by simp [hδ0])
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
          dsimp [σ]
          rw [mapEquiv_mk, mapEquiv_mk]
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
    intro a b c
    exact collinear_mapEquiv (K := K) (V := V) g
  exact initialPStatement_of_fixedPointFree_collinearity_preserving_involution
    (K := K) (V := V) σ hσ hfixed hcol

end Projective
end ProjectiveCap
