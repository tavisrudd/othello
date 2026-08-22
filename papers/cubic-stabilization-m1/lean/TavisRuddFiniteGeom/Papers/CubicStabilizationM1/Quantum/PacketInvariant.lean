import Mathlib.Data.Nat.Basic

/-!
# Abstract packet multiplicities

The quantum comparison theorems used by the manuscript yield a nonnegative
integer multiplicity, projective-bundle formulas, and blow-up formulas.  This
module records only the elementary deductions from those formulas.  It does not
construct the quantum connection or prove the cited comparison theorems.

The projective-bundle premise is the numerical consequence used from Hiroshi
Iritani and Yuki Koto, *Quantum cohomology of projective bundles* (2026),
arXiv:2307.03696v4, Proposition 5.6 and Section 5.8.  No result from that source
is introduced as an axiom; it appears only through theorem hypotheses.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1

namespace Quantum

/-- Numerical data needed from a framed-monodromy packet invariant. -/
structure PacketData (Variety : Type*) where
  multiplicity : Variety → ℕ
  dimension : Variety → ℕ
  productProjective : Variety → ℕ → Variety
  projectiveBundle : Variety → ℕ → Variety

namespace PacketData

variable {Variety : Type*} (packet : PacketData Variety)

/-- The projective-bundle formula implies the corresponding formula for a
trivial projective bundle, expressed here as an explicit premise. -/
theorem product_multiplicity
    (formula : ∀ base rank,
      packet.multiplicity (packet.projectiveBundle base rank) =
        rank * packet.multiplicity base)
    (trivialization : ∀ base rank,
      packet.productProjective base rank = packet.projectiveBundle base rank) :
    ∀ base rank,
      packet.multiplicity (packet.productProjective base rank) =
        rank * packet.multiplicity base := by
  intro base rank
  rw [trivialization, formula]

/-- A nonzero packet survives multiplication by a positive projective factor. -/
theorem product_nonzero
    (formula : ∀ base rank,
      packet.multiplicity (packet.productProjective base rank) =
        rank * packet.multiplicity base)
    {base : Variety} (rank : ℕ) (rankPositive : 0 < rank)
    (baseNonzero : packet.multiplicity base ≠ 0) :
    packet.multiplicity (packet.productProjective base rank) ≠ 0 := by
  rw [formula]
  exact Nat.mul_ne_zero (Nat.ne_of_gt rankPositive) baseNonzero

end PacketData

end Quantum

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1
