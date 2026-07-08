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

/-- Nonzero field parameters for the hyperbola parametrization. -/
noncomputable def NonzeroParams : Finset K :=
  Finset.univ.erase 0

omit [DecidableEq K] in
theorem mem_hyperbolaCells {rho A B : K} {p : GridPoint K} :
    p ∈ HyperbolaCells (K := K) rho A B ↔ OnHyperbola (K := K) rho A B p := by
  classical
  simp [HyperbolaCells]

theorem mem_nonzeroParams {t : K} :
    t ∈ NonzeroParams (K := K) ↔ t ≠ 0 := by
  simp [NonzeroParams]

theorem card_nonzeroParams :
    (NonzeroParams (K := K)).card = Fintype.card K - 1 := by
  simp [NonzeroParams]

/-- A residual-grid seed lies on a hyperbola normal form. -/
def HyperbolaFits (S : Finset (GridPoint K)) (rho A B : K) : Prop :=
  ∀ p : GridPoint K, p ∈ S -> OnHyperbola (K := K) rho A B p

/-- The determinant of the two-by-two linear system for the hyperbola center. -/
def hyperbolaDenom (a b c : GridPoint K) : K :=
  (b.2 - a.2) * (c.1 - a.1) - (c.2 - a.2) * (b.1 - a.1)

/-- Cramer-rule row-center parameter for the hyperbola through an ordered triple. -/
def hyperbolaRhoOfTriple (a b c : GridPoint K) : K :=
  ((b.1 * b.2 - a.1 * a.2) * (c.1 - a.1) -
      (c.1 * c.2 - a.1 * a.2) * (b.1 - a.1)) /
    hyperbolaDenom (K := K) a b c

/-- Cramer-rule column-center parameter for the hyperbola through an ordered triple. -/
def hyperbolaAOfTriple (a b c : GridPoint K) : K :=
  ((b.2 - a.2) * (c.1 * c.2 - a.1 * a.2) -
      (c.2 - a.2) * (b.1 * b.2 - a.1 * a.2)) /
    hyperbolaDenom (K := K) a b c

/-- Product parameter for the hyperbola through an ordered triple. -/
def hyperbolaBOfTriple (a b c : GridPoint K) : K :=
  (a.1 - hyperbolaRhoOfTriple (K := K) a b c) *
    (a.2 - hyperbolaAOfTriple (K := K) a b c)

omit [Fintype K] [DecidableEq K] in
theorem hyperbolaDenom_ne_zero_of_not_collinear {a b c : GridPoint K}
    (hnot : ¬ Collinear (K := K) a b c) :
    hyperbolaDenom (K := K) a b c ≠ 0 := by
  intro hden
  apply hnot
  have heq :
      (b.2 - a.2) * (c.1 - a.1) =
        (c.2 - a.2) * (b.1 - a.1) := sub_eq_zero.mp hden
  unfold Collinear
  calc
    (b.1 - a.1) * (c.2 - a.2) =
        (c.2 - a.2) * (b.1 - a.1) := by ring
    _ = (b.2 - a.2) * (c.1 - a.1) := heq.symm

omit [Fintype K] in
theorem hyperbolaDenom_ne_zero_of_gridCap_triple {a b c : GridPoint K}
    (hS : GridCap (K := K) ({a, b, c} : Finset (GridPoint K)))
    (hab : a ≠ b) (hac : a ≠ c) (hbc : b ≠ c) :
    hyperbolaDenom (K := K) a b c ≠ 0 :=
  hyperbolaDenom_ne_zero_of_not_collinear (K := K)
    (hS.2 (by simp) (by simp) (by simp) hab hac hbc)

omit [Fintype K] [DecidableEq K] in
theorem hyperbolaTriple_linear_b {a b c : GridPoint K}
    (hden : hyperbolaDenom (K := K) a b c ≠ 0) :
    hyperbolaRhoOfTriple (K := K) a b c * (b.2 - a.2) +
        hyperbolaAOfTriple (K := K) a b c * (b.1 - a.1) =
      b.1 * b.2 - a.1 * a.2 := by
  unfold hyperbolaRhoOfTriple hyperbolaAOfTriple
  field_simp [hden]
  unfold hyperbolaDenom
  ring

omit [Fintype K] [DecidableEq K] in
theorem hyperbolaTriple_linear_c {a b c : GridPoint K}
    (hden : hyperbolaDenom (K := K) a b c ≠ 0) :
    hyperbolaRhoOfTriple (K := K) a b c * (c.2 - a.2) +
        hyperbolaAOfTriple (K := K) a b c * (c.1 - a.1) =
      c.1 * c.2 - a.1 * a.2 := by
  unfold hyperbolaRhoOfTriple hyperbolaAOfTriple
  field_simp [hden]
  unfold hyperbolaDenom
  ring

omit [Fintype K] [DecidableEq K] in
theorem onHyperbola_pair_linear {rho A B : K} {p q : GridPoint K}
    (hp : OnHyperbola (K := K) rho A B p)
    (hq : OnHyperbola (K := K) rho A B q) :
    rho * (q.2 - p.2) + A * (q.1 - p.1) =
      q.1 * q.2 - p.1 * p.2 := by
  unfold OnHyperbola at hp hq
  linear_combination hp - hq

omit [Fintype K] [DecidableEq K] in
theorem onHyperbola_hyperbolaOfTriple_a (a b c : GridPoint K) :
    OnHyperbola (K := K)
      (hyperbolaRhoOfTriple (K := K) a b c)
      (hyperbolaAOfTriple (K := K) a b c)
      (hyperbolaBOfTriple (K := K) a b c) a := by
  simp [OnHyperbola, hyperbolaBOfTriple]

omit [Fintype K] [DecidableEq K] in
theorem onHyperbola_hyperbolaOfTriple_b {a b c : GridPoint K}
    (hden : hyperbolaDenom (K := K) a b c ≠ 0) :
    OnHyperbola (K := K)
      (hyperbolaRhoOfTriple (K := K) a b c)
      (hyperbolaAOfTriple (K := K) a b c)
      (hyperbolaBOfTriple (K := K) a b c) b := by
  unfold OnHyperbola hyperbolaBOfTriple
  have hlin := hyperbolaTriple_linear_b (K := K) hden
  linear_combination -hlin

omit [Fintype K] [DecidableEq K] in
theorem onHyperbola_hyperbolaOfTriple_c {a b c : GridPoint K}
    (hden : hyperbolaDenom (K := K) a b c ≠ 0) :
    OnHyperbola (K := K)
      (hyperbolaRhoOfTriple (K := K) a b c)
      (hyperbolaAOfTriple (K := K) a b c)
      (hyperbolaBOfTriple (K := K) a b c) c := by
  unfold OnHyperbola hyperbolaBOfTriple
  have hlin := hyperbolaTriple_linear_c (K := K) hden
  linear_combination -hlin

omit [Fintype K] in
theorem hyperbolaFits_triple {a b c : GridPoint K}
    (hden : hyperbolaDenom (K := K) a b c ≠ 0) :
    HyperbolaFits (K := K) ({a, b, c} : Finset (GridPoint K))
      (hyperbolaRhoOfTriple (K := K) a b c)
      (hyperbolaAOfTriple (K := K) a b c)
      (hyperbolaBOfTriple (K := K) a b c) := by
  intro p hp
  simp only [Finset.mem_insert, Finset.mem_singleton] at hp
  rcases hp with rfl | rfl | rfl
  · exact onHyperbola_hyperbolaOfTriple_a (K := K) _ _ _
  · exact onHyperbola_hyperbolaOfTriple_b (K := K) hden
  · exact onHyperbola_hyperbolaOfTriple_c (K := K) hden

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

omit [Fintype K] in
theorem hyperbolaFits_card_three_B_ne_zero {S : Finset (GridPoint K)} {rho A B : K}
    (hcard : S.card = 3) (hS : GridCap (K := K) S)
    (hfit : HyperbolaFits (K := K) S rho A B) :
    B ≠ 0 := by
  intro hB0
  obtain ⟨a, b, c, hab, hac, hbc, rfl⟩ := Finset.card_eq_three.mp hcard
  have haOn : OnHyperbola (K := K) rho A B a := hfit a (by simp)
  have hbOn : OnHyperbola (K := K) rho A B b := hfit b (by simp)
  have hcOn : OnHyperbola (K := K) rho A B c := hfit c (by simp)
  have ha : a.1 = rho ∨ a.2 = A := by
    unfold OnHyperbola at haOn
    rw [hB0] at haOn
    rcases mul_eq_zero.mp haOn with hrow | hcol
    · exact Or.inl (sub_eq_zero.mp hrow)
    · exact Or.inr (sub_eq_zero.mp hcol)
  have hb : b.1 = rho ∨ b.2 = A := by
    unfold OnHyperbola at hbOn
    rw [hB0] at hbOn
    rcases mul_eq_zero.mp hbOn with hrow | hcol
    · exact Or.inl (sub_eq_zero.mp hrow)
    · exact Or.inr (sub_eq_zero.mp hcol)
  have hc : c.1 = rho ∨ c.2 = A := by
    unfold OnHyperbola at hcOn
    rw [hB0] at hcOn
    rcases mul_eq_zero.mp hcOn with hrow | hcol
    · exact Or.inl (sub_eq_zero.mp hrow)
    · exact Or.inr (sub_eq_zero.mp hcol)
  rcases ha with haRow | haCol
  · rcases hb with hbRow | hbCol
    · have hrow : a.1 = b.1 := by rw [haRow, hbRow]
      exact hab (hS.1.1 (by simp) (by simp) hrow)
    · rcases hc with hcRow | hcCol
      · have hrow : a.1 = c.1 := by rw [haRow, hcRow]
        exact hac (hS.1.1 (by simp) (by simp) hrow)
      · have hcol : b.2 = c.2 := by rw [hbCol, hcCol]
        exact hbc (hS.1.2 (by simp) (by simp) hcol)
  · rcases hb with hbRow | hbCol
    · rcases hc with hcRow | hcCol
      · have hrow : b.1 = c.1 := by rw [hbRow, hcRow]
        exact hbc (hS.1.1 (by simp) (by simp) hrow)
      · have hcol : a.2 = c.2 := by rw [haCol, hcCol]
        exact hac (hS.1.2 (by simp) (by simp) hcol)
    · have hcol : a.2 = b.2 := by rw [haCol, hbCol]
      exact hab (hS.1.2 (by simp) (by simp) hcol)

omit [Fintype K] in
theorem exists_hyperbolaNormalForm {S : Finset (GridPoint K)}
    (hcard : S.card = 3) (hS : GridCap (K := K) S) :
    ∃ rho A B : K,
      B ≠ 0 ∧ HyperbolaFits (K := K) S rho A B := by
  obtain ⟨a, b, c, hab, hac, hbc, rfl⟩ := Finset.card_eq_three.mp hcard
  let rho := hyperbolaRhoOfTriple (K := K) a b c
  let A := hyperbolaAOfTriple (K := K) a b c
  let B := hyperbolaBOfTriple (K := K) a b c
  have hden : hyperbolaDenom (K := K) a b c ≠ 0 :=
    hyperbolaDenom_ne_zero_of_gridCap_triple (K := K) hS hab hac hbc
  have hfit :
      HyperbolaFits (K := K) ({a, b, c} : Finset (GridPoint K)) rho A B := by
    simpa [rho, A, B] using hyperbolaFits_triple (K := K) hden
  have hcardTriple : ({a, b, c} : Finset (GridPoint K)).card = 3 := by
    simp [hab, hac, hbc]
  have hB : B ≠ 0 :=
    hyperbolaFits_card_three_B_ne_zero (K := K) hcardTriple hS hfit
  exact ⟨rho, A, B, hB, hfit⟩

omit [Fintype K] [DecidableEq K] in
theorem hyperbolaConic_nondegenerate {rho A B : K} (hB : B ≠ 0) :
    (hyperbolaConic (K := K) rho A B).Nondegenerate := by
  simpa [BurnedDirectionConic.Nondegenerate, BurnedDirectionConic.B, hyperbolaConic] using hB

omit [Fintype K] [DecidableEq K] in
theorem burnedDirectionConic_eq_hyperbolaConic_of_params
    (C : BurnedDirectionConic K) {rho A B : K}
    (hrho : C.rho = rho) (hA : C.A = A) (hB : C.B = B) :
    C = hyperbolaConic (K := K) rho A B := by
  cases C with
  | mk eps zeta gamma =>
      simp [BurnedDirectionConic.rho, BurnedDirectionConic.A,
        BurnedDirectionConic.B, hyperbolaConic] at hrho hA hB ⊢
      constructor
      · linear_combination -hA
      · constructor
        · linear_combination -hrho
        · linear_combination -hB + (-zeta) * hA + A * hrho

omit [Fintype K] [DecidableEq K] in
theorem uniqueConicThroughFiveArcStatement_of_hyperbolaNormalFormStatement
    (hNF : HyperbolaNormalFormStatement (K := K)) :
    UniqueConicThroughFiveArcStatement (K := K) := by
  intro S hcard hS
  rcases hNF S hcard hS with ⟨rho, A, B, hB, hfit, huniq⟩
  refine ⟨hyperbolaConic (K := K) rho A B,
    hyperbolaConic_nondegenerate (K := K) hB, ?_, ?_⟩
  · intro p hp
    exact (BurnedDirectionConic.onAffine_iff_onHyperbola
      (K := K) (C := hyperbolaConic (K := K) rho A B) p).mpr
        (by simpa [BurnedDirectionConic.rho, BurnedDirectionConic.A,
          BurnedDirectionConic.B, hyperbolaConic] using hfit p hp)
  · intro D hDnondeg hDfit
    have hDfitHyper : HyperbolaFits (K := K) S D.rho D.A D.B := by
      intro p hp
      exact (BurnedDirectionConic.onAffine_iff_onHyperbola (K := K) (C := D) p).mp
        (hDfit p hp)
    rcases huniq D.rho D.A D.B hDnondeg hDfitHyper with ⟨hrho, hA, hB'⟩
    exact burnedDirectionConic_eq_hyperbolaConic_of_params (K := K) D hrho hA hB'

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
Packaged statement: every non-seed cell on the size-three seed's conic is legal,
and there are exactly `q - 4` such legal on-conic extensions.
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
Packaged statement: for odd characteristic, the affine hyperbola cell set is a
maximal grid cap of size `q - 1`.
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

omit [Fintype K] [DecidableEq K] in
theorem hyperbolaParamPoint_injective (rho A B : K) :
    Function.Injective (hyperbolaParamPoint (K := K) rho A B) := by
  intro t s h
  have hfirst := congrArg Prod.fst h
  simp [hyperbolaParamPoint] at hfirst
  linear_combination hfirst

omit [Fintype K] [DecidableEq K] in
theorem hyperbolaParamPoint_onHyperbola {rho A B t : K} (ht : t ≠ 0) :
    OnHyperbola (K := K) rho A B (hyperbolaParamPoint rho A B t) := by
  unfold OnHyperbola hyperbolaParamPoint
  field_simp [ht]
  ring

omit [Fintype K] [DecidableEq K] in
theorem onHyperbola_first_ne_rho {rho A B : K} (hB : B ≠ 0)
    {p : GridPoint K} (hp : OnHyperbola (K := K) rho A B p) :
    p.1 ≠ rho := by
  intro h
  unfold OnHyperbola at hp
  rw [h, sub_self, zero_mul] at hp
  exact hB hp.symm

omit [Fintype K] [DecidableEq K] in
theorem onHyperbola_second_ne_A {rho A B : K} (hB : B ≠ 0)
    {p : GridPoint K} (hp : OnHyperbola (K := K) rho A B p) :
    p.2 ≠ A := by
  intro h
  unfold OnHyperbola at hp
  rw [h, sub_self, mul_zero] at hp
  exact hB hp.symm

omit [Fintype K] [DecidableEq K] in
theorem onHyperbola_eq_hyperbolaParamPoint {rho A B : K} (hB : B ≠ 0)
    {p : GridPoint K} (hp : OnHyperbola (K := K) rho A B p) :
    p = hyperbolaParamPoint rho A B (p.1 - rho) := by
  ext
  · simp [hyperbolaParamPoint]
  · have ht : p.1 - rho ≠ 0 := by
      intro hz
      exact onHyperbola_first_ne_rho (K := K) hB hp (sub_eq_zero.mp hz)
    have hdiv : B / (p.1 - rho) = p.2 - A := by
      unfold OnHyperbola at hp
      rw [← hp]
      field_simp [ht]
    calc
      p.2 = A + (p.2 - A) := by ring
      _ = A + B / (p.1 - rho) := by rw [← hdiv]

omit [Fintype K] [DecidableEq K] in
theorem onHyperbola_iff_exists_param {rho A B : K} (hB : B ≠ 0)
    {p : GridPoint K} :
    OnHyperbola (K := K) rho A B p ↔
      ∃ t : K, t ≠ 0 ∧ p = hyperbolaParamPoint rho A B t := by
  constructor
  · intro hp
    refine ⟨p.1 - rho, ?_, onHyperbola_eq_hyperbolaParamPoint (K := K) hB hp⟩
    intro hz
    exact onHyperbola_first_ne_rho (K := K) hB hp (sub_eq_zero.mp hz)
  · rintro ⟨t, ht, rfl⟩
    exact hyperbolaParamPoint_onHyperbola (K := K) ht

theorem hyperbolaCells_eq_image_nonzeroParams {rho A B : K} (hB : B ≠ 0) :
    HyperbolaCells (K := K) rho A B =
      (NonzeroParams (K := K)).image (hyperbolaParamPoint rho A B) := by
  ext p
  rw [mem_hyperbolaCells, onHyperbola_iff_exists_param (K := K) hB]
  simp [mem_nonzeroParams, eq_comm]

theorem card_hyperbolaCells {rho A B : K} (hB : B ≠ 0) :
    (HyperbolaCells (K := K) rho A B).card = Fintype.card K - 1 := by
  rw [hyperbolaCells_eq_image_nonzeroParams (K := K) hB]
  rw [Finset.card_image_of_injective _ (hyperbolaParamPoint_injective (K := K) rho A B)]
  exact card_nonzeroParams (K := K)

omit [DecidableEq K] in
theorem rowSparse_hyperbolaCells {rho A B : K} (hB : B ≠ 0) :
    RowSparse (K := K) (HyperbolaCells (K := K) rho A B) := by
  intro p q hp hq hrow
  have hpOn : OnHyperbola (K := K) rho A B p := mem_hyperbolaCells.mp hp
  have hqOn : OnHyperbola (K := K) rho A B q := mem_hyperbolaCells.mp hq
  have hprow := onHyperbola_eq_hyperbolaParamPoint (K := K) hB hpOn
  have hqrow := onHyperbola_eq_hyperbolaParamPoint (K := K) hB hqOn
  have hparam : p.1 - rho = q.1 - rho := by rw [hrow]
  rw [hprow, hqrow, hparam]

omit [DecidableEq K] in
theorem colSparse_hyperbolaCells {rho A B : K} (hB : B ≠ 0) :
    ColSparse (K := K) (HyperbolaCells (K := K) rho A B) := by
  intro p q hp hq hcol
  have hpOn : OnHyperbola (K := K) rho A B p := mem_hyperbolaCells.mp hp
  have hqOn : OnHyperbola (K := K) rho A B q := mem_hyperbolaCells.mp hq
  have hpne : p.1 - rho ≠ 0 := by
    intro hz
    exact onHyperbola_first_ne_rho (K := K) hB hpOn (sub_eq_zero.mp hz)
  have hqne : q.1 - rho ≠ 0 := by
    intro hz
    exact onHyperbola_first_ne_rho (K := K) hB hqOn (sub_eq_zero.mp hz)
  have hpParam := onHyperbola_eq_hyperbolaParamPoint (K := K) hB hpOn
  have hqParam := onHyperbola_eq_hyperbolaParamPoint (K := K) hB hqOn
  have hdiv : B / (p.1 - rho) = B / (q.1 - rho) := by
    have hcol' := hcol
    rw [hpParam, hqParam] at hcol'
    simpa [hyperbolaParamPoint] using hcol'
  have hparam : p.1 - rho = q.1 - rho := by
    have hmul : B * (p.1 - rho)⁻¹ = B * (q.1 - rho)⁻¹ := by
      simpa [div_eq_mul_inv] using hdiv
    have hinv : (p.1 - rho)⁻¹ = (q.1 - rho)⁻¹ :=
      mul_left_cancel₀ hB hmul
    exact inv_injective hinv
  rw [hpParam, hqParam, hparam]

omit [DecidableEq K] in
theorem partialPermutation_hyperbolaCells {rho A B : K} (hB : B ≠ 0) :
    PartialPermutation (K := K) (HyperbolaCells (K := K) rho A B) :=
  ⟨rowSparse_hyperbolaCells (K := K) hB, colSparse_hyperbolaCells (K := K) hB⟩

omit [Fintype K] [DecidableEq K] in
theorem not_collinear_hyperbolaParamPoint {rho A B t s v : K}
    (hB : B ≠ 0) (ht : t ≠ 0) (hs : s ≠ 0) (hv : v ≠ 0)
    (hts : t ≠ s) (htv : t ≠ v) (hsv : s ≠ v) :
    ¬ Collinear (K := K)
      (hyperbolaParamPoint rho A B t)
      (hyperbolaParamPoint rho A B s)
      (hyperbolaParamPoint rho A B v) := by
  intro hcol
  have hcancel :
      (B * (s - t) * (v - t)) * (v - s) = 0 := by
    unfold Collinear hyperbolaParamPoint at hcol
    field_simp [hB, ht, hs, hv] at hcol
    ring_nf at hcol ⊢
    linear_combination hcol
  have hleft : B * (s - t) * (v - t) ≠ 0 := by
    refine mul_ne_zero (mul_ne_zero hB ?_) ?_
    · exact sub_ne_zero.mpr hts.symm
    · exact sub_ne_zero.mpr htv.symm
  have hvsub : v - s = 0 := by
    have hcancel' : (B * (s - t) * (v - t)) * (v - s) =
        (B * (s - t) * (v - t)) * 0 := by
      simpa using hcancel
    exact mul_left_cancel₀ hleft hcancel'
  exact hsv (sub_eq_zero.mp hvsub).symm

omit [DecidableEq K] in
theorem affineCap_hyperbolaCells {rho A B : K} (hB : B ≠ 0) :
    AffineCap (K := K) (HyperbolaCells (K := K) rho A B) := by
  intro a b c ha hb hc hab hac hbc hcol
  have haOn : OnHyperbola (K := K) rho A B a := mem_hyperbolaCells.mp ha
  have hbOn : OnHyperbola (K := K) rho A B b := mem_hyperbolaCells.mp hb
  have hcOn : OnHyperbola (K := K) rho A B c := mem_hyperbolaCells.mp hc
  rcases (onHyperbola_iff_exists_param (K := K) hB).mp haOn with ⟨t, ht, rfl⟩
  rcases (onHyperbola_iff_exists_param (K := K) hB).mp hbOn with ⟨s, hs, rfl⟩
  rcases (onHyperbola_iff_exists_param (K := K) hB).mp hcOn with ⟨v, hv, rfl⟩
  have hts : t ≠ s := fun h => hab (by rw [h])
  have htv : t ≠ v := fun h => hac (by rw [h])
  have hsv : s ≠ v := fun h => hbc (by rw [h])
  exact not_collinear_hyperbolaParamPoint (K := K) hB ht hs hv hts htv hsv hcol

omit [DecidableEq K] in
theorem gridCap_hyperbolaCells {rho A B : K} (hB : B ≠ 0) :
    GridCap (K := K) (HyperbolaCells (K := K) rho A B) :=
  ⟨partialPermutation_hyperbolaCells (K := K) hB,
    affineCap_hyperbolaCells (K := K) hB⟩

theorem gridCap_hyperbolaCells_and_card {rho A B : K} (hB : B ≠ 0) :
    GridCap (K := K) (HyperbolaCells (K := K) rho A B) ∧
      ((HyperbolaCells (K := K) rho A B).card : Int) =
        (Fintype.card K : Int) - 1 := by
  exact ⟨gridCap_hyperbolaCells (K := K) hB, by
    rw [card_hyperbolaCells (K := K) hB]
    have hcard_pos : 0 < Fintype.card K := Fintype.card_pos_iff.mpr ⟨(0 : K)⟩
    have hle : 1 ≤ Fintype.card K := Nat.succ_le_of_lt hcard_pos
    norm_num [Nat.cast_sub hle]⟩

theorem onConicLegalExtensionCountStatement :
    OnConicLegalExtensionCountStatement (K := K) := by
  intro S rho A B hcard hS hB hfit
  constructor
  · intro p hpCell hpnot
    rw [GridGame.mem_legalExtensions]
    refine ⟨hpnot, ?_⟩
    exact gridCap_mono (K := K) (T := HyperbolaCells (K := K) rho A B) (by
      intro x hx
      rcases Finset.mem_insert.mp hx with rfl | hxS
      · exact hpCell
      · exact mem_hyperbolaCells.mpr (hfit x hxS)) (gridCap_hyperbolaCells (K := K) hB)
  · let H := HyperbolaCells (K := K) rho A B
    have hsubset : S ⊆ H := by
      intro p hp
      exact mem_hyperbolaCells.mpr (hfit p hp)
    have hfilter :
        (H.filter fun p => p ∉ S) = H \ S := by
      ext p
      simp
    have hcardNat : (H \ S).card = (Fintype.card K - 1) - 3 := by
      rw [Finset.card_sdiff_of_subset hsubset, card_hyperbolaCells (K := K) hB, hcard]
    have hSle : S.card ≤ H.card := Finset.card_le_card hsubset
    have hqge4 : 4 ≤ Fintype.card K := by
      rw [card_hyperbolaCells (K := K) hB, hcard] at hSle
      omega
    rw [hfilter, hcardNat]
    have hle1 : 1 ≤ Fintype.card K := by omega
    have hle3 : 3 ≤ Fintype.card K - 1 := by omega
    norm_num [Nat.cast_sub hle1, Nat.cast_sub hle3]
    ring

omit [Fintype K] [DecidableEq K] in
theorem hyperbola_center_secant_collinear {rho A B t : K} (ht : t ≠ 0) :
    Collinear (K := K) (rho, A)
      (hyperbolaParamPoint rho A B t)
      (hyperbolaParamPoint rho A B (-t)) := by
  unfold Collinear hyperbolaParamPoint
  field_simp [ht]
  ring

theorem maximalGridCap_hyperbolaCells_of_two_ne_zero {rho A B : K}
    (h2 : (2 : K) ≠ 0) (hB : B ≠ 0) :
    MaximalGridCap (K := K) (HyperbolaCells (K := K) rho A B) := by
  let H := HyperbolaCells (K := K) rho A B
  refine ⟨gridCap_hyperbolaCells (K := K) hB, ?_⟩
  intro p hpnot hcapInsert
  by_cases hrow : p.1 = rho
  · by_cases hcol : p.2 = A
    · have hpcenter : p = (rho, A) := Prod.ext hrow hcol
      subst p
      let q := hyperbolaParamPoint rho A B 1
      let r := hyperbolaParamPoint rho A B (-1)
      have hqH : q ∈ H :=
        mem_hyperbolaCells.mpr (hyperbolaParamPoint_onHyperbola (K := K) one_ne_zero)
      have hrH : r ∈ H := by
        have hneg : (-1 : K) ≠ 0 := neg_ne_zero.mpr one_ne_zero
        exact mem_hyperbolaCells.mpr (hyperbolaParamPoint_onHyperbola (K := K) hneg)
      have hpMem : (rho, A) ∈ insert (rho, A) H := by simp
      have hqMem : q ∈ insert (rho, A) H := Finset.mem_insert.mpr (Or.inr hqH)
      have hrMem : r ∈ insert (rho, A) H := Finset.mem_insert.mpr (Or.inr hrH)
      have hpq : (rho, A) ≠ q := by
        intro h
        have hf := congrArg Prod.fst h
        simp [q, hyperbolaParamPoint] at hf
      have hpr : (rho, A) ≠ r := by
        intro h
        have hf := congrArg Prod.fst h
        simp [r, hyperbolaParamPoint] at hf
      have hqr : q ≠ r := by
        intro h
        have hf := congrArg Prod.fst h
        simp [q, r, hyperbolaParamPoint] at hf
        have htwo : (2 : K) = 0 := by linear_combination hf
        exact h2 htwo
      exact hcapInsert.2 hpMem hqMem hrMem hpq hpr hqr
        (hyperbola_center_secant_collinear (K := K) (rho := rho) (A := A) (B := B)
          (t := 1) one_ne_zero)
    · let t := B / (p.2 - A)
      let q := hyperbolaParamPoint rho A B t
      have ht : t ≠ 0 := div_ne_zero hB (sub_ne_zero.mpr hcol)
      have hqH : q ∈ H :=
        mem_hyperbolaCells.mpr (hyperbolaParamPoint_onHyperbola (K := K) ht)
      have hpMem : p ∈ insert p H := by simp
      have hqMem : q ∈ insert p H := Finset.mem_insert.mpr (Or.inr hqH)
      have hqcol : p.2 = q.2 := by
        have hq2 : q.2 = A + (p.2 - A) := by
          simp [q, t, hyperbolaParamPoint]
          field_simp [hB, sub_ne_zero.mpr hcol]
          ring
        calc
          p.2 = A + (p.2 - A) := by ring
          _ = q.2 := hq2.symm
      have hpq : p ≠ q := by
        intro hpq
        exact hpnot (hpq ▸ hqH)
      exact hpq (hcapInsert.1.2 hpMem hqMem hqcol)
  · let t := p.1 - rho
    let q := hyperbolaParamPoint rho A B t
    have ht : t ≠ 0 := sub_ne_zero.mpr hrow
    have hqH : q ∈ H :=
      mem_hyperbolaCells.mpr (hyperbolaParamPoint_onHyperbola (K := K) ht)
    have hpMem : p ∈ insert p H := by simp
    have hqMem : q ∈ insert p H := Finset.mem_insert.mpr (Or.inr hqH)
    have hqrow : p.1 = q.1 := by simp [q, t, hyperbolaParamPoint]
    have hpq : p ≠ q := by
      intro hpq
      exact hpnot (hpq ▸ hqH)
    exact hpq (hcapInsert.1.1 hpMem hqMem hqrow)

theorem oddHyperbolaMaximalStatement :
    OddHyperbolaMaximalStatement (K := K) := by
  intro rho A B h2 hB
  exact ⟨maximalGridCap_hyperbolaCells_of_two_ne_zero (K := K) h2 hB,
    (gridCap_hyperbolaCells_and_card (K := K) hB).2⟩

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
