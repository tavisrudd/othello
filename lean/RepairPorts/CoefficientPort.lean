import FiniteGeom.Repair
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

end RepairPorts
