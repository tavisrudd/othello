import RelativeConicArcs.Q16Reduction
import RelativeConicArcs.Q16CertificateData
import RelativeConicArcs.Q16LeafData
import RelativeConicArcs.Q16QuadraticAvoidance
import RelativeConicArcs.ExampleChecks.Q16

/-!
# Exact relative conic-arc value over `GF(16)`

The generated projective classification excludes cardinality eight; the existing explicit
nine-point certificate supplies the matching upper bound.
-/

namespace RelativeConicArcs

open Conic Certificate FiniteFields
open Q16Classification Q16Classification.Q16CertificateData
open Examples

set_option maxHeartbeats 20000000
set_option maxRecDepth 100000

noncomputable local instance : Fintype (Conic.Point GF16) := Fintype.ofFinite _
noncomputable local instance : DecidableEq (Conic.Point GF16) := Classical.decEq _

theorem no_completeOutside_GF16_card_eight
    (C : NonsingularConic (K := GF16)) {A : Finset (Conic.Point GF16)}
    (hA : CompleteOutside (L := Conic.Point GF16) A C.points) (hcard : A.card = 8) : False :=
  no_completeOutside_card_eight books4_valid books5_valid books6_valid books7_valid
    rejectedLeaves_valid C hA hcard

/-- The formerly open alternative `rho_C(16) ∈ {8,9}` has the exact value nine. -/
theorem rhoC_GF16 : rhoC (K := GF16) = 9 := by
  have hL2 : L2 16 = 8 := by
    apply Nat.le_antisymm
    · apply Nat.sInf_le
      norm_num [L2Admissible, Nat.choose]
    · have hadm : L2Admissible 16 (L2 16) := by
        rw [L2]
        change sInf {k : ℕ | L2Admissible 16 k} ∈ {k : ℕ | L2Admissible 16 k}
        exact Nat.sInf_mem ⟨8, by norm_num [L2Admissible, Nat.choose]⟩
      by_contra h
      have hlt : L2 16 < 8 := by omega
      interval_cases hval : L2 16 <;>
        norm_num [L2Admissible, Nat.choose, hval] at hadm
  have hlower : 8 ≤ rhoC (K := GF16) := by
    rw [← hL2]
    simpa using (NonsingularConic.standard (K := GF16)).finite_lower_bound.2
  have hupper : rhoC (K := GF16) ≤ 9 := by
    simpa [q16Witness] using rhoC_le_length_of_check q16_check
  have hne : rhoC (K := GF16) ≠ 8 := by
    intro hrho
    let C := NonsingularConic.standard (K := GF16)
    obtain ⟨A, hA, hcard⟩ :=
      exists_completeOutside_card_eq_rho (L := Conic.Point GF16) C.points
    apply no_completeOutside_GF16_card_eight C hA
    rw [hcard, C.rho_points_eq_rhoC, hrho]
  omega

#print axioms no_completeOutside_GF16_card_eight
#print axioms rhoC_GF16

end RelativeConicArcs
