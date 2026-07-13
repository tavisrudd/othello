import RepairCodes.Q9ExtensionLift
import Mathlib.Topology.Algebra.Order.Field

/-!
# Quarantined deep input for the asymptotic RepairCodes theorem

This file contains exactly one imported mathematical assertion.
-/

namespace RepairCodes.Imported

open Filter FiniteGeom

noncomputable section

/-- **Imported: Stichtenoth, Theorem 1.6(ii), specialized to `q = 6561 = 81^2`.**

Henning Stichtenoth, *Transitive and Self-dual Codes Attaining the
Tsfasman–Vladut–Zink Bound*, arXiv:math/0506264, Theorem 1.6(ii): for every square
`q = ell^2` there is a sequence of self-dual `[n_j,n_j/2,d_j]` codes over `F_q`,
with `n_j → ∞` and

`lim d_j/n_j ≥ 1/2 - 1/(ell-1)`.

Here `ell = 81`, so the displayed lower bound is `39/80`.  The statement below is
the theorem's parameter statement expressed with this repository's definitions of
linear code, ordinary dual, dimension, and minimum distance.  The cardinality
hypothesis identifies the coefficient field with `F_6561` up to the unique finite-field
isomorphism.

Primary source: https://arxiv.org/abs/math/0506264 (Theorem 1.6(ii), pp. 3–4;
proof via Corollary 4.9 and Remark 4.6(ii)).
-/
axiom stichtenoth_selfDual_TVZ_6561
    (L : Type*) [Field L] [Fintype L] [DecidableEq L]
    (hcard : Fintype.card L = 6561) :
    ∃ (n : ℕ → ℕ)
      (C : (j : ℕ) → Submodule L (Fin (n j) → L)) (δ : ℝ),
      (∀ j, C j = dualCode (C j)) ∧
      (∀ j, 2 * Module.finrank L (C j) = n j) ∧
      Tendsto n atTop atTop ∧
      Tendsto (fun j ↦ (minDist (C j) : ℝ) / (n j : ℝ)) atTop (nhds δ) ∧
      (39 : ℝ) / 80 ≤ δ

end
end RepairCodes.Imported
