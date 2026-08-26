import RelativeConicArcs.ClebschSteinChart
import RelativeConicArcs.GoldenResidueAlgebra

/-!
# The canonical golden Stein chart

The rational golden residue field carries a distinguished square root of five,
so the scalar-normalized Stein chart has a choice-free specialization there.
This module records that specialization and identifies its branch root with the
canonical golden root times the normalized cubic coordinate.

The geometric comparison between this chart and the normalized incidence
fibre remains a separate statement.
-/

namespace RelativeConicArcs.ClebschGoldenSteinChart

open ClebschSteinChart
open GoldenResidueAlgebra

/-- The choice-free Stein chart over the rational golden residue field. -/
noncomputable def canonicalData (σ₃ : GoldenAlgebra) :
    ClebschSteinChart.Data GoldenAlgebra where
  J₀ := 16 * σ₃ ^ 2
  σ₃ := σ₃
  sqrtFive := GoldenResidueAlgebra.sqrtFive
  sextic_pullback := rfl
  sqrtFive_sq := GoldenResidueAlgebra.sqrtFive_sq

/-- Its split branch root is the canonical `4 sqrtFive σ₃`. -/
theorem canonicalData_root (σ₃ : GoldenAlgebra) :
    (canonicalData σ₃).root = 4 * GoldenResidueAlgebra.sqrtFive * σ₃ := rfl

/-- Deck exchange negates the canonical branch root. -/
theorem deck_canonicalData_root (σ₃ : GoldenAlgebra) :
    GoldenResidueAlgebra.deck ((canonicalData σ₃).root) =
      -(canonicalData (GoldenResidueAlgebra.deck σ₃)).root := by
  rw [canonicalData_root, map_mul, map_mul, map_ofNat,
    GoldenResidueAlgebra.deck_sqrtFive, canonicalData_root]
  ring

end RelativeConicArcs.ClebschGoldenSteinChart
