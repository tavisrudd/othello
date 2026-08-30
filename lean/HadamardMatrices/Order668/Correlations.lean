/-
# The autocorrelation identity for the four sequences of length 166

The four sequences `A`, `B`, `C`, `D` of `HadamardMatrices.Order668.Sequences`
satisfy

```
  PAF_A s + PAF_B s + PAF_C s + PAF_D s = -4   for every s ≠ 0 in ZMod 166,
```

where `PAF_X s = ∑ t, X t * X (t + s)` is the periodic autocorrelation.  This is
the hypothesis that makes the bordered Goethals–Seidel array of order 668
orthogonal; equivalently, the supports of the four sequences form four
supplementary difference sets on `ZMod 166` with the parameters forced by that
border.

The identity is an exhaustive check over the 165 nonzero shifts, each a sum of
664 products, discharged by kernel reduction.  Nothing beyond the Lean kernel is
trusted.
-/
import HadamardMatrices.Order668.Sequences

namespace HadamardMatrices
namespace Order668

set_option maxRecDepth 8000
set_option maxHeartbeats 4000000

/-- The four periodic autocorrelations sum to `-4` at every nonzero shift. -/
theorem pafSum_eq_neg_four :
    ∀ s : ZMod 166, s ≠ 0 → pafSum sequenceA sequenceB sequenceC sequenceD s = -4 := by
  rw [sequenceA_eq_packed, sequenceB_eq_packed, sequenceC_eq_packed, sequenceD_eq_packed]
  decide

end Order668
end HadamardMatrices
