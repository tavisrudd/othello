import FiniteGeom.Repair
import FiniteGeom.CodeDuality
import Mathlib.Data.ENat.Lattice

/-!
# Coefficient-valued bounded repair ports

For a linear code `C`, a target coordinate `x`, and a helper radius `r`, the coefficient port
consists of the dual words whose target coefficient is normalized to one and whose support away
from `x` has size at most `r`.  Its linear span is the portion of the parity-check space remembered
by radius-`r` local repair equations.

The reconstruction radius is the least bounded radius whose normalized repair words span the
entire dual code, with value `⊤` when no such radius exists.  Thus reconstruction is a statement
about scalar relations, not merely about their supports.
-/

namespace RepairPorts

open Finset
open scoped ENat

variable {ι : Type*} [Fintype ι] [DecidableEq ι]
  {𝔽 : Type*} [Field 𝔽] [DecidableEq 𝔽]

/-- Target-normalized dual words using at most `r` helpers. -/
def coefficientPort (C : Submodule 𝔽 (ι → 𝔽)) (x : ι) (r : ℕ) : Set (ι → 𝔽) :=
  {y | y ∈ FiniteGeom.dualCode C ∧ y x = 1 ∧
    ((FiniteGeom.wordSupport y).erase x).card ≤ r}

/-- The parity-check subspace remembered by the radius-`r` coefficient port. -/
def coefficientPortSpan (C : Submodule 𝔽 (ι → 𝔽)) (x : ι) (r : ℕ) :
    Submodule 𝔽 (ι → 𝔽) :=
  Submodule.span 𝔽 (coefficientPort C x r)

/-- The radius-`r` coefficient port reconstructs the code's entire parity-check space. -/
def ReconstructsAt (C : Submodule 𝔽 (ι → 𝔽)) (x : ι) (r : ℕ) : Prop :=
  coefficientPortSpan C x r = FiniteGeom.dualCode C

/-- When a coefficient port spans the parity-check space, taking its orthogonal code recovers the
original linear code. -/
theorem reconstructedCode_eq {C : Submodule 𝔽 (ι → 𝔽)} {x : ι} {r : ℕ}
    (h : ReconstructsAt C x r) :
    FiniteGeom.dualCode (coefficientPortSpan C x r) = C := by
  rw [h, FiniteGeom.dualCode_dualCode]

/-- The least radius reconstructing the parity-check space, or `⊤` if none does. -/
noncomputable def reconstructionRadius (C : Submodule 𝔽 (ι → 𝔽)) (x : ι) : ℕ∞ :=
  sInf ((fun r : ℕ => (r : ℕ∞)) '' {r | ReconstructsAt C x r})

theorem coefficientPort_mono {C : Submodule 𝔽 (ι → 𝔽)} {x : ι} {r s : ℕ}
    (hrs : r ≤ s) : coefficientPort C x r ⊆ coefficientPort C x s := by
  rintro y ⟨hy, hyx, hcard⟩
  exact ⟨hy, hyx, hcard.trans hrs⟩

theorem coefficientPortSpan_mono {C : Submodule 𝔽 (ι → 𝔽)} {x : ι} {r s : ℕ}
    (hrs : r ≤ s) : coefficientPortSpan C x r ≤ coefficientPortSpan C x s :=
  Submodule.span_mono (coefficientPort_mono hrs)

theorem coefficientPortSpan_le_dualCode
    (C : Submodule 𝔽 (ι → 𝔽)) (x : ι) (r : ℕ) :
    coefficientPortSpan C x r ≤ FiniteGeom.dualCode C := by
  apply Submodule.span_le.mpr
  intro y hy
  exact hy.1

theorem reconstructsAt_mono {C : Submodule 𝔽 (ι → 𝔽)} {x : ι} {r s : ℕ}
    (hrs : r ≤ s) (hr : ReconstructsAt C x r) : ReconstructsAt C x s := by
  apply le_antisymm (coefficientPortSpan_le_dualCode C x s)
  rw [← hr]
  exact coefficientPortSpan_mono hrs

/-- An intrinsic isomorphism of pointed coefficient ports.  The ambient linear equivalence must
carry the full parity-check space and every bounded normalized coefficient fiber exactly. -/
structure PointedCoefficientPortIso
    {κ : Type*} [Fintype κ] [DecidableEq κ]
    (C : Submodule 𝔽 (ι → 𝔽)) (x : ι)
    (C' : Submodule 𝔽 (κ → 𝔽)) (x' : κ) where
  ambientEquiv : (ι → 𝔽) ≃ₗ[𝔽] (κ → 𝔽)
  map_dualCode :
    (FiniteGeom.dualCode C).map ambientEquiv.toLinearMap = FiniteGeom.dualCode C'
  map_coefficientPort :
    ∀ r, ambientEquiv '' coefficientPort C x r = coefficientPort C' x' r

theorem PointedCoefficientPortIso.map_coefficientPortSpan
    {κ : Type*} [Fintype κ] [DecidableEq κ]
    {C : Submodule 𝔽 (ι → 𝔽)} {x : ι}
    {C' : Submodule 𝔽 (κ → 𝔽)} {x' : κ}
    (e : PointedCoefficientPortIso C x C' x') (r : ℕ) :
    (coefficientPortSpan C x r).map e.ambientEquiv.toLinearMap =
      coefficientPortSpan C' x' r := by
  rw [coefficientPortSpan, coefficientPortSpan, LinearMap.map_span]
  change Submodule.span 𝔽 (e.ambientEquiv '' coefficientPort C x r) =
    Submodule.span 𝔽 (coefficientPort C' x' r)
  rw [e.map_coefficientPort]

theorem PointedCoefficientPortIso.reconstructsAt_iff
    {κ : Type*} [Fintype κ] [DecidableEq κ]
    {C : Submodule 𝔽 (ι → 𝔽)} {x : ι}
    {C' : Submodule 𝔽 (κ → 𝔽)} {x' : κ}
    (e : PointedCoefficientPortIso C x C' x') (r : ℕ) :
    ReconstructsAt C x r ↔ ReconstructsAt C' x' r := by
  constructor <;> intro h
  · rw [ReconstructsAt, ← e.map_coefficientPortSpan r, h, e.map_dualCode]
  · have hmap :
        (coefficientPortSpan C x r).map e.ambientEquiv.toLinearMap =
          (FiniteGeom.dualCode C).map e.ambientEquiv.toLinearMap := by
      rw [e.map_coefficientPortSpan r, e.map_dualCode, h]
    exact (Submodule.map_injective_of_injective e.ambientEquiv.injective) hmap

/-- Pointed coefficient-port isomorphisms preserve reconstruction radius. -/
theorem PointedCoefficientPortIso.reconstructionRadius_eq
    {κ : Type*} [Fintype κ] [DecidableEq κ]
    {C : Submodule 𝔽 (ι → 𝔽)} {x : ι}
    {C' : Submodule 𝔽 (κ → 𝔽)} {x' : κ}
    (e : PointedCoefficientPortIso C x C' x') :
    reconstructionRadius C x = reconstructionRadius C' x' := by
  unfold reconstructionRadius
  congr 1
  ext z
  constructor
  · rintro ⟨r, hr, rfl⟩
    exact ⟨r, (e.reconstructsAt_iff r).mp hr, rfl⟩
  · rintro ⟨r, hr, rfl⟩
    exact ⟨r, (e.reconstructsAt_iff r).mpr hr, rfl⟩

private theorem erased_wordSupport_card_le_univ (y : ι → 𝔽) (x : ι) :
    ((FiniteGeom.wordSupport y).erase x).card ≤ Fintype.card ι := by
  calc
    ((FiniteGeom.wordSupport y).erase x).card ≤ (Finset.univ : Finset ι).card :=
      Finset.card_le_card (Finset.subset_univ _)
    _ = Fintype.card ι := Finset.card_univ

/-- If some parity check uses the target coordinate, then the coefficient port at the trivial
full-coordinate radius spans the entire dual code.  Hence the reconstruction radius is finite at
every genuinely repairable coordinate. -/
theorem reconstructsAt_card_of_exists_dual_not_zero
    {C : Submodule 𝔽 (ι → 𝔽)} {x : ι}
    (hx : ∃ y ∈ FiniteGeom.dualCode C, y x ≠ 0) :
    ReconstructsAt C x (Fintype.card ι) := by
  apply le_antisymm (coefficientPortSpan_le_dualCode C x _)
  rintro y hy
  obtain ⟨y₀, hy₀, hy₀x⟩ := hx
  let w : ι → 𝔽 := (y₀ x)⁻¹ • y₀
  have hwdual : w ∈ FiniteGeom.dualCode C :=
    (FiniteGeom.dualCode C).smul_mem _ hy₀
  have hwx : w x = 1 := by
    simp [w, hy₀x]
  have hwport : w ∈ coefficientPort C x (Fintype.card ι) :=
    ⟨hwdual, hwx, erased_wordSupport_card_le_univ w x⟩
  have hwspan : w ∈ coefficientPortSpan C x (Fintype.card ι) :=
    Submodule.subset_span hwport
  let z : ι → 𝔽 := y - y x • w
  have hzdual : z ∈ FiniteGeom.dualCode C :=
    (FiniteGeom.dualCode C).sub_mem hy ((FiniteGeom.dualCode C).smul_mem _ hwdual)
  have hzx : z x = 0 := by
    simp [z, hwx]
  let u : ι → 𝔽 := w + z
  have hudual : u ∈ FiniteGeom.dualCode C :=
    (FiniteGeom.dualCode C).add_mem hwdual hzdual
  have hux : u x = 1 := by
    simp [u, hwx, hzx]
  have huport : u ∈ coefficientPort C x (Fintype.card ι) :=
    ⟨hudual, hux, erased_wordSupport_card_le_univ u x⟩
  have huspan : u ∈ coefficientPortSpan C x (Fintype.card ι) :=
    Submodule.subset_span huport
  have hzspan : z ∈ coefficientPortSpan C x (Fintype.card ι) := by
    convert (coefficientPortSpan C x (Fintype.card ι)).sub_mem huspan hwspan using 1
    simp [u]
  have hydecomp : y = z + y x • w := by
    simp [z]
  rw [hydecomp]
  exact (coefficientPortSpan C x (Fintype.card ι)).add_mem hzspan
    ((coefficientPortSpan C x (Fintype.card ι)).smul_mem _ hwspan)

/-- A support belongs to the complete support port exactly when it is the support of a normalized
coefficient-port word.  Normalization changes coefficients but not support. -/
theorem mem_repairHypergraph_iff_exists_mem_coefficientPort
    {C : Submodule 𝔽 (ι → 𝔽)} {x : ι} {r : ℕ} {R : Finset ι} :
    R ∈ FiniteGeom.repairHypergraph C x r ↔
      ∃ y ∈ coefficientPort C x r,
        FiniteGeom.wordSupport y = insert x R ∧ x ∉ R := by
  constructor
  · intro hR
    obtain ⟨hsub, hcard, y, hy, hyx, hsupp⟩ := FiniteGeom.mem_repairHypergraph.mp hR
    let z := (y x)⁻¹ • y
    have hzx : z x = 1 := by
      simp [z, hyx]
    have hzdual : z ∈ FiniteGeom.dualCode C :=
      (FiniteGeom.dualCode C).smul_mem _ hy
    have hsuppz : FiniteGeom.wordSupport z = FiniteGeom.wordSupport y := by
      ext j
      simp only [FiniteGeom.mem_wordSupport, z, Pi.smul_apply, smul_eq_mul]
      exact mul_ne_zero_iff.trans <| and_iff_right (inv_ne_zero hyx)
    have hxR : x ∉ R := by
      intro hx
      exact (Finset.mem_erase.mp (hsub hx)).1 rfl
    refine ⟨z, ⟨hzdual, hzx, ?_⟩, ?_, hxR⟩
    · rw [hsuppz, hsupp, Finset.erase_insert hxR]
      exact hcard
    · rw [hsuppz, hsupp]
  · rintro ⟨y, ⟨hy, hyx, hcard⟩, hsupp, hxR⟩
    rw [hsupp, Finset.erase_insert hxR] at hcard
    apply FiniteGeom.mem_repairHypergraph.mpr
    refine ⟨?_, hcard, y, hy, by simp [hyx], hsupp⟩
    intro j hj
    exact Finset.mem_erase.mpr ⟨fun hjx => hxR (hjx ▸ hj), Finset.mem_univ j⟩

#print axioms reconstructedCode_eq
#print axioms PointedCoefficientPortIso.reconstructsAt_iff
#print axioms PointedCoefficientPortIso.reconstructionRadius_eq
#print axioms reconstructsAt_card_of_exists_dual_not_zero
#print axioms mem_repairHypergraph_iff_exists_mem_coefficientPort

end RepairPorts
