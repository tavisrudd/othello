import ProjectiveCap.GridCounting
import ProjectiveCap.GridGame
import ProjectiveCap.Almost.OddEscape
import Mathlib.Tactic

/-!
# Conic localization scaffold

This file gives Lean names to the conic-localization layer for size-three
residual-grid positions.  The main geometric facts are stated as `Prop`
targets, following the style of `ProjectiveCap.StableFacts`: the projective
conic vocabulary itself is still intentionally lightweight.

The coordinate substrate for the hyperbola normal form and the `psi_u`
involutions is concrete, so later proofs can build directly on these names.
-/

namespace ProjectiveCap
namespace ConicLocalization

variable {K : Type*} [Field K] [Fintype K] [DecidableEq K]

/-! ## Hyperbola normal form -/

/-- The affine hyperbola `(r - rho) * (c - A) = B`. -/
def OnHyperbola (rho A B : K) (p : GridPoint K) : Prop :=
  (p.1 - rho) * (p.2 - A) = B

/-- The finite set of grid cells on `(r - rho) * (c - A) = B`. -/
noncomputable def HyperbolaCells (rho A B : K) : Finset (GridPoint K) := by
  classical
  exact Finset.univ.filter fun p => OnHyperbola (K := K) rho A B p

omit [DecidableEq K] in
theorem mem_hyperbolaCells {rho A B : K} {p : GridPoint K} :
    p ∈ HyperbolaCells (K := K) rho A B ↔ OnHyperbola (K := K) rho A B p := by
  classical
  simp [HyperbolaCells]

/-- A residual-grid seed lies on a hyperbola normal form. -/
def HyperbolaFits (S : Finset (GridPoint K)) (rho A B : K) : Prop :=
  ∀ p : GridPoint K, p ∈ S -> OnHyperbola (K := K) rho A B p

/--
Conics through the two burned directions, normalized so the `r*c`
coefficient is `1`.  The affine equation is
`r*c + eps*r + zeta*c + gamma = 0`.
-/
structure BurnedDirectionConic (K : Type*) where
  eps : K
  zeta : K
  gamma : K

namespace BurnedDirectionConic

variable (C : BurnedDirectionConic K)

/-- Affine cells on the normalized conic. -/
def OnAffine (p : GridPoint K) : Prop :=
  p.1 * p.2 + C.eps * p.1 + C.zeta * p.2 + C.gamma = 0

/-- Hyperbola row-center parameter for the normalized conic. -/
def rho : K := -C.zeta

/-- Hyperbola column-center parameter for the normalized conic. -/
def A : K := -C.eps

/-- Hyperbola product parameter for the normalized conic. -/
def B : K := C.zeta * C.eps - C.gamma

/-- Nondegeneracy in this normalized burned-direction chart. -/
def Nondegenerate : Prop := C.B ≠ 0

omit [Fintype K] [DecidableEq K] in
theorem onAffine_iff_onHyperbola (p : GridPoint K) :
    C.OnAffine p ↔ OnHyperbola (K := K) C.rho C.A C.B p := by
  unfold OnAffine OnHyperbola rho A B
  constructor <;> intro h <;> linear_combination h

end BurnedDirectionConic

/-- The normalized conic associated to `(r - rho) * (c - A) = B`. -/
def hyperbolaConic (rho A B : K) : BurnedDirectionConic K where
  eps := -A
  zeta := -rho
  gamma := rho * A - B

/--
Target: the five-arc consisting of a size-three grid seed plus the two burned
directions determines a unique nondegenerate conic.  The burned directions are
encoded by the normalized `BurnedDirectionConic` chart.
-/
def UniqueConicThroughFiveArcStatement : Prop :=
  ∀ S : Finset (GridPoint K),
    S.card = 3 ->
    GridCap (K := K) S ->
      ∃ C : BurnedDirectionConic K,
        C.Nondegenerate ∧
          (∀ p : GridPoint K, p ∈ S -> C.OnAffine p) ∧
          ∀ D : BurnedDirectionConic K,
            D.Nondegenerate ->
            (∀ p : GridPoint K, p ∈ S -> D.OnAffine p) ->
              D = C

/--
Target: the same unique conic, expressed in the hyperbola/Mobius normal form
`(r - rho) * (c - A) = B`, with `B != 0`.
-/
def HyperbolaNormalFormStatement : Prop :=
  ∀ S : Finset (GridPoint K),
    S.card = 3 ->
    GridCap (K := K) S ->
      ∃ rho A B : K,
        B ≠ 0 ∧
          HyperbolaFits (K := K) S rho A B ∧
          ∀ rho' A' B' : K,
            B' ≠ 0 ->
            HyperbolaFits (K := K) S rho' A' B' ->
              rho' = rho ∧ A' = A ∧ B' = B

/-- Legal on-conic extensions of `S`, relative to a chosen hyperbola model. -/
noncomputable def OnConicLegalExtensions
    (S : Finset (GridPoint K)) (rho A B : K) : Finset (GridPoint K) := by
  classical
  exact (HyperbolaCells (K := K) rho A B).filter fun p =>
    p ∈ GridGame.LegalExtensions (K := K) S

theorem mem_onConicLegalExtensions
    {S : Finset (GridPoint K)} {rho A B : K} {p : GridPoint K} :
    p ∈ OnConicLegalExtensions (K := K) S rho A B ↔
      OnHyperbola (K := K) rho A B p ∧
        p ∈ GridGame.LegalExtensions (K := K) S := by
  classical
  simp [OnConicLegalExtensions, mem_hyperbolaCells]

/--
Target: every non-seed cell on the size-three seed's conic is legal, and there
are exactly `q - 4` such legal on-conic extensions.
-/
def OnConicLegalExtensionCountStatement : Prop :=
  ∀ S : Finset (GridPoint K), ∀ rho A B : K,
    S.card = 3 ->
    GridCap (K := K) S ->
    B ≠ 0 ->
    HyperbolaFits (K := K) S rho A B ->
      (∀ p : GridPoint K,
        p ∈ HyperbolaCells (K := K) rho A B ->
        p ∉ S ->
          p ∈ GridGame.LegalExtensions (K := K) S) ∧
      (((HyperbolaCells (K := K) rho A B).filter fun p => p ∉ S).card : Int) =
        (Fintype.card K : Int) - 4

/-- A grid cap is inclusion-maximal among residual-grid positions. -/
def MaximalGridCap (S : Finset (GridPoint K)) : Prop :=
  GridCap (K := K) S ∧
    ∀ p : GridPoint K, p ∉ S -> ¬ GridCap (K := K) (insert p S)

/--
Target: for odd characteristic, the affine hyperbola cell set is a maximal
grid cap of size `q - 1`.
-/
def OddHyperbolaMaximalStatement : Prop :=
  ∀ rho A B : K,
    (2 : K) ≠ 0 ->
    B ≠ 0 ->
      MaximalGridCap (K := K) (HyperbolaCells (K := K) rho A B) ∧
        ((HyperbolaCells (K := K) rho A B).card : Int) =
          (Fintype.card K : Int) - 1

/-! ## The `psi_u` involutions -/

/-- The hyperbola parametrization `t |-> (rho + t, A + B / t)`. -/
def hyperbolaParamPoint (rho A B t : K) : GridPoint K :=
  (rho + t, A + B / t)

/--
The translated-coordinate map
`(t, s) |-> ((u / B) * s, (B / u) * t)`, transported back to grid
coordinates.
-/
def psi (rho A B u : K) (p : GridPoint K) : GridPoint K :=
  (rho + (u / B) * (p.2 - A), A + (B / u) * (p.1 - rho))

omit [Fintype K] [DecidableEq K] in
theorem psi_involutive {rho A B u : K} (hB : B ≠ 0) (hu : u ≠ 0) :
    Function.Involutive (psi (K := K) rho A B u) := by
  intro p
  ext <;> simp [psi]
  · field_simp [hB, hu]
    ring
  · field_simp [hB, hu]
    ring

omit [Fintype K] [DecidableEq K] in
theorem psi_onHyperbola_iff {rho A B u : K} (hB : B ≠ 0) (hu : u ≠ 0)
    (p : GridPoint K) :
    OnHyperbola (K := K) rho A B (psi (K := K) rho A B u p) ↔
      OnHyperbola (K := K) rho A B p := by
  have hprod :
      ((psi (K := K) rho A B u p).1 - rho) *
          ((psi (K := K) rho A B u p).2 - A) =
        (p.1 - rho) * (p.2 - A) := by
    simp [psi]
    field_simp [hB, hu]
  change
    ((psi (K := K) rho A B u p).1 - rho) *
        ((psi (K := K) rho A B u p).2 - A) = B ↔
      (p.1 - rho) * (p.2 - A) = B
  rw [hprod]

omit [Fintype K] [DecidableEq K] in
theorem psi_hyperbolaParamPoint {rho A B u t : K}
    (hB : B ≠ 0) (hu : u ≠ 0) (ht : t ≠ 0) :
    psi (K := K) rho A B u (hyperbolaParamPoint rho A B t) =
      hyperbolaParamPoint rho A B (u / t) := by
  ext <;> simp [psi, hyperbolaParamPoint]
  · field_simp [hB, hu, ht]
  · field_simp [hB, hu, ht]

omit [Fintype K] [DecidableEq K] in
theorem psi_bijective {rho A B u : K} (hB : B ≠ 0) (hu : u ≠ 0) :
    Function.Bijective (psi (K := K) rho A B u) :=
  (psi_involutive (K := K) hB hu).bijective

omit [Fintype K] [DecidableEq K] in
theorem psi_first_eq_iff {rho A B u : K} (hB : B ≠ 0) (hu : u ≠ 0)
    {p q : GridPoint K} :
    (psi (K := K) rho A B u p).1 = (psi (K := K) rho A B u q).1 ↔
      p.2 = q.2 := by
  constructor
  · intro h
    have hsub := congrArg (fun z : K => z - rho) h
    simp [psi] at hsub
    rcases hsub with hpq | huzero | hBzero
    · exact hpq
    · exact (hu huzero).elim
    · exact (hB hBzero).elim
  · intro h
    simp [psi, h]

omit [Fintype K] [DecidableEq K] in
theorem psi_second_eq_iff {rho A B u : K} (hB : B ≠ 0) (hu : u ≠ 0)
    {p q : GridPoint K} :
    (psi (K := K) rho A B u p).2 = (psi (K := K) rho A B u q).2 ↔
      p.1 = q.1 := by
  constructor
  · intro h
    have hsub := congrArg (fun z : K => z - A) h
    simp [psi] at hsub
    rcases hsub with hpq | hBzero | huzero
    · exact hpq
    · exact (hB hBzero).elim
    · exact (hu huzero).elim
  · intro h
    simp [psi, h]

omit [Fintype K] [DecidableEq K] in
theorem collinear_psi_iff {rho A B u : K} (hB : B ≠ 0) (hu : u ≠ 0)
    (p q r : GridPoint K) :
    Collinear (K := K) (psi (K := K) rho A B u p)
      (psi (K := K) rho A B u q) (psi (K := K) rho A B u r) ↔
      Collinear (K := K) p q r := by
  constructor
  · intro h
    have hcancel :
        (B * u) * ((q.2 - p.2) * (r.1 - p.1)) =
          (B * u) * ((q.1 - p.1) * (r.2 - p.2)) := by
      unfold Collinear psi at h
      field_simp [hB, hu] at h
      ring_nf at h ⊢
      exact h
    unfold Collinear
    exact (mul_left_cancel₀ (mul_ne_zero hB hu) hcancel).symm
  · intro h
    have hmul :
        (B * u) * ((q.2 - p.2) * (r.1 - p.1)) =
          (B * u) * ((q.1 - p.1) * (r.2 - p.2)) := by
      unfold Collinear at h
      rw [h.symm]
    unfold Collinear psi
    field_simp [hB, hu]
    ring_nf at hmul ⊢
    exact hmul

/-- A map that acts as a symmetry of residual-grid positions. -/
def GridSymmetry (f : GridPoint K -> GridPoint K) : Prop :=
  Function.Bijective f ∧
    ∀ S : Finset (GridPoint K),
      GridCap (K := K) (S.image f) ↔ GridCap (K := K) S

omit [Fintype K] in
theorem rowSparse_image_psi {rho A B u : K} (hB : B ≠ 0) (hu : u ≠ 0)
    {S : Finset (GridPoint K)} (hS : GridCap (K := K) S) :
    RowSparse (K := K) (S.image (psi (K := K) rho A B u)) := by
  intro p q hp hq hrow
  rcases Finset.mem_image.mp hp with ⟨p0, hp0, rfl⟩
  rcases Finset.mem_image.mp hq with ⟨q0, hq0, rfl⟩
  have hcol : p0.2 = q0.2 := (psi_first_eq_iff (K := K) hB hu).mp hrow
  have hpq : p0 = q0 := hS.1.2 hp0 hq0 hcol
  rw [hpq]

omit [Fintype K] in
theorem colSparse_image_psi {rho A B u : K} (hB : B ≠ 0) (hu : u ≠ 0)
    {S : Finset (GridPoint K)} (hS : GridCap (K := K) S) :
    ColSparse (K := K) (S.image (psi (K := K) rho A B u)) := by
  intro p q hp hq hcol
  rcases Finset.mem_image.mp hp with ⟨p0, hp0, rfl⟩
  rcases Finset.mem_image.mp hq with ⟨q0, hq0, rfl⟩
  have hrow : p0.1 = q0.1 := (psi_second_eq_iff (K := K) hB hu).mp hcol
  have hpq : p0 = q0 := hS.1.1 hp0 hq0 hrow
  rw [hpq]

omit [Fintype K] in
theorem affineCap_image_psi {rho A B u : K} (hB : B ≠ 0) (hu : u ≠ 0)
    {S : Finset (GridPoint K)} (hS : GridCap (K := K) S) :
    AffineCap (K := K) (S.image (psi (K := K) rho A B u)) := by
  intro a b c ha hb hc hab hac hbc hcol
  rcases Finset.mem_image.mp ha with ⟨a0, ha0, rfl⟩
  rcases Finset.mem_image.mp hb with ⟨b0, hb0, rfl⟩
  rcases Finset.mem_image.mp hc with ⟨c0, hc0, rfl⟩
  have hab0 : a0 ≠ b0 := fun h => hab (by rw [h])
  have hac0 : a0 ≠ c0 := fun h => hac (by rw [h])
  have hbc0 : b0 ≠ c0 := fun h => hbc (by rw [h])
  exact hS.2 ha0 hb0 hc0 hab0 hac0 hbc0
    ((collinear_psi_iff (K := K) hB hu a0 b0 c0).mp hcol)

omit [Fintype K] in
theorem gridCap_image_psi {rho A B u : K} (hB : B ≠ 0) (hu : u ≠ 0)
    {S : Finset (GridPoint K)} (hS : GridCap (K := K) S) :
    GridCap (K := K) (S.image (psi (K := K) rho A B u)) :=
  ⟨⟨rowSparse_image_psi (K := K) hB hu hS,
    colSparse_image_psi (K := K) hB hu hS⟩,
    affineCap_image_psi (K := K) hB hu hS⟩

omit [Fintype K] in
theorem gridCap_image_psi_iff {rho A B u : K} (hB : B ≠ 0) (hu : u ≠ 0)
    (S : Finset (GridPoint K)) :
    GridCap (K := K) (S.image (psi (K := K) rho A B u)) ↔
      GridCap (K := K) S := by
  constructor
  · intro hS
    have htwice :
        (S.image (psi (K := K) rho A B u)).image (psi (K := K) rho A B u) = S := by
      rw [Finset.image_image]
      have hcomp : (psi (K := K) rho A B u) ∘
          (psi (K := K) rho A B u) = id :=
        funext (psi_involutive (K := K) hB hu)
      rw [hcomp]
      simp
    have htwiceCap :
        GridCap (K := K)
          ((S.image (psi (K := K) rho A B u)).image (psi (K := K) rho A B u)) :=
      gridCap_image_psi (K := K) (rho := rho) (A := A) hB hu hS
    simpa [htwice] using htwiceCap
  · exact gridCap_image_psi (K := K) (rho := rho) (A := A) hB hu

omit [Fintype K] in
theorem psi_gridSymmetry {rho A B u : K} (hB : B ≠ 0) (hu : u ≠ 0) :
    GridSymmetry (K := K) (psi (K := K) rho A B u) :=
  ⟨psi_bijective (K := K) hB hu, gridCap_image_psi_iff (K := K) hB hu⟩

/--
Packaged statement: each `psi_u` is a grid-symmetry involution preserving the
hyperbola and acting on the conic parameter by `t |-> u / t`.
-/
def PsiInvolutionStatement : Prop :=
  ∀ rho A B u : K,
    B ≠ 0 ->
    u ≠ 0 ->
      Function.Involutive (psi (K := K) rho A B u) ∧
        GridSymmetry (K := K) (psi (K := K) rho A B u) ∧
        (∀ p : GridPoint K,
          OnHyperbola (K := K) rho A B (psi (K := K) rho A B u p) ↔
            OnHyperbola (K := K) rho A B p) ∧
        ∀ t : K,
          t ≠ 0 ->
            psi (K := K) rho A B u (hyperbolaParamPoint rho A B t) =
              hyperbolaParamPoint rho A B (u / t)

omit [Fintype K] in
theorem psiInvolutionStatement : PsiInvolutionStatement (K := K) := by
  intro rho A B u hB hu
  exact ⟨psi_involutive (K := K) hB hu,
    psi_gridSymmetry (K := K) hB hu,
    psi_onHyperbola_iff (K := K) hB hu,
    fun t ht => psi_hyperbolaParamPoint (K := K) hB hu ht⟩

/--
The on-conic escape refinement: the future odd-plane kernel should find a
game-valued P child among the on-conic legal extensions.
-/
def OnConicEscapeStatement : Prop :=
  ∀ S : Finset (GridPoint K),
    S.card = 3 ->
    GridCap (K := K) S ->
      ∃ rho A B : K, ∃ p : GridPoint K,
        B ≠ 0 ∧
          HyperbolaFits (K := K) S rho A B ∧
          p ∈ OnConicLegalExtensions (K := K) S rho A B ∧
          GridGame.IsP (K := K) (insert p S)

/-- The on-conic refinement immediately implies the ordinary odd escape target. -/
theorem oddEscapeStatement_of_onConicEscapeStatement
    (hON : OnConicEscapeStatement (K := K)) :
    GridGame.OddEscapeStatement (K := K) := by
  rw [GridGame.oddEscapeStatement_iff_escapeExtensions_nonempty]
  intro S hcard hcap
  rcases hON S hcard hcap with ⟨rho, A, B, p, _hB, _hfit, hpOn, hpP⟩
  refine ⟨p, ?_⟩
  exact GridGame.mem_escapeExtensions.mpr
    ⟨(mem_onConicLegalExtensions (K := K)).mp hpOn |>.2, hpP⟩

/-- The same implication in the `Almost` namespace's target spelling. -/
theorem almostOddEscapeGameStatement_of_onConicEscapeStatement
    (hON : OnConicEscapeStatement (K := K)) :
    Almost.OddEscapeGameStatement (K := K) :=
  oddEscapeStatement_of_onConicEscapeStatement (K := K) hON

end ConicLocalization
end ProjectiveCap
