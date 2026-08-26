import Mathlib.Tactic.NormNum
import RelativeConicArcs.TraceSplitQuadraticAlgebra

/-!
# The scalar-normalized Clebsch Stein chart

The reusable trace-split algebra works with an arbitrary branch coefficient.
This module supplies the exact paper-specific chart datum: the pulled-back
sextic is `16 σ₃²`, a chosen square root of five squares to `5`, and hence the
Stein coefficient `5 J₀` is the square `(4 √5 σ₃)²`.  The identity relates
the scalar-normalized and split-root presentations, and the latter carries the
already-formalized comparison to the split pinching algebra.

The geometric assertion producing this datum from the incidence normalization
remains a separate input.
-/

namespace RelativeConicArcs.ClebschSteinChart

open TraceSplitQuadraticAlgebra

variable {S : Type*} [CommRing S]

/-- Exact scalar-normalized data on a Clebsch chart. -/
structure Data (S : Type*) [CommRing S] where
  J₀ : S
  σ₃ : S
  sqrtFive : S
  sextic_pullback : J₀ = 16 * σ₃ ^ 2
  sqrtFive_sq : sqrtFive ^ 2 = 5

/-- The two roots of the pulled-back Stein relation. -/
def Data.root (c : Data S) : S := 4 * c.sqrtFive * c.σ₃

/-- The paper's exact chart coefficient identity
`5 J₀ = (4 √5 σ₃)²`. -/
theorem Data.branchCoefficient_eq_root_sq (c : Data S) :
    5 * c.J₀ = c.root ^ 2 := by
  rw [c.sextic_pullback, ← c.sqrtFive_sq]
  simp only [Data.root]
  rw [show (16 : S) = 4 * 4 by norm_num]
  simp only [pow_two]
  ac_rfl

/-- The scalar-normalized trace-split Stein algebra on the chart. -/
abbrev Data.steinAlgebra (c : Data S) :=
  TraceSplitQuadraticAlgebra.Algebra (5 * c.J₀)

/-- The same chart algebra written in its split-root presentation.  The theorem
`branchCoefficient_eq_root_sq` identifies its defining coefficient with that
of `steinAlgebra`. -/
abbrev Data.splitChartAlgebra (c : Data S) :=
  TraceSplitQuadraticAlgebra.Algebra (c.root ^ 2)

/-- Evaluation at the two roots gives the exact comparison from the split-root
presentation to the pinching algebra. -/
noncomputable def Data.splitComparison (c : Data S) :
    c.splitChartAlgebra →+* SplitQuadraticPinching.splitPinching c.root :=
  TraceSplitQuadraticAlgebra.splitComparison c.root

end RelativeConicArcs.ClebschSteinChart
