import RelativeConicArcs.ClebschWittHadamard

/-!
# Quadratic-residue incidence and Barker correlation checks

This leaf checks the cyclic `2-(11,5,2)` incidence design and the exact periodic and aperiodic
correlations in one native-evaluation pass.  Its terminals depend on `Lean.ofReduceBool`.
-/

namespace RelativeConicArcs
namespace ClebschWittHadamard

private theorem checkedSequences :
    (residueBlocks.card = 11 ∧
      (∀ b ∈ residueBlocks, b.card = 5) ∧
      ∀ x y : Fin 11, x ≠ y →
        (residueBlocks.filter fun b => x ∈ b ∧ y ∈ b).card = 2) ∧
    (periodicCorrelation residueSign 0 = 11 ∧
      ∀ d : Fin 11, d ≠ 0 → periodicCorrelation residueSign d = -1) ∧
    ∀ d : Fin 11,
      barkerAperiodicCorrelation d = ![11, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1] d := by
  native_decide

/-- The QR incidence rows form a `2-(11,5,2)` design. -/
theorem residueBlocks_two_design :
    residueBlocks.card = 11 ∧
    (∀ b ∈ residueBlocks, b.card = 5) ∧
    ∀ x y : Fin 11, x ≠ y →
      (residueBlocks.filter fun b => x ∈ b ∧ y ∈ b).card = 2 :=
  checkedSequences.1

/-- The associated Legendre sign word has periodic autocorrelation `-1` off zero. -/
theorem residueSign_periodic_correlation :
    periodicCorrelation residueSign 0 = 11 ∧
    ∀ d : Fin 11, d ≠ 0 → periodicCorrelation residueSign d = -1 :=
  checkedSequences.2.1

/-- Exact aperiodic autocorrelations of the normalized length-eleven Barker word. -/
theorem barker_aperiodic_correlations :
    ∀ d : Fin 11,
      barkerAperiodicCorrelation d = ![11, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1] d :=
  checkedSequences.2.2

end ClebschWittHadamard
end RelativeConicArcs
