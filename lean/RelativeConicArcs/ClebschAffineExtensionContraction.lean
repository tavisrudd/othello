import Mathlib.LinearAlgebra.FiniteDimensional.Basic
import Mathlib.Tactic

/-!
# Evaluation--coevaluation contraction for an affine extension

Let `S = ι → k` and `F = κ → k` be finite coordinate spaces.  Suppose `i : S → F`
has a retraction `ρ : F → S`.  Differentiating the symmetric rank-one expression
`i(t)c` gives

`t ↦ t ⊗ c + ρ(c) ⊗ i(t)`.

Categorical trace over `S` contracts this expression to

`(#ι) c + i(ρ(c))`.

The theorem below proves this formula coordinatewise.  Applying it pointwise proves the same
identity for cochains.  No group action or cohomology quotient is introduced here; passage from
the cochain identity to a cohomology class requires the equivariance of `i` and `ρ`.
-/

namespace RelativeConicArcs.ClebschAffineExtensionContraction

variable {k ι κ G : Type*} [Field k]
  [Fintype ι] [DecidableEq ι]

/-- The standard coordinate vector supported at `j`. -/
def coordinateVector (j : ι) : ι → k := fun r ↦ if r = j then 1 else 0

/-- Every finite coordinate vector is the sum of its coordinates times the standard vectors. -/
theorem sum_smul_coordinateVector (x : ι → k) :
    ∑ j, x j • coordinateVector j = x := by
  funext r
  simp [coordinateVector]

/-- Coordinate form of the categorical trace after differentiating the symmetric rank-one map
`t ↦ i(t)c`.  The first summand traces the identity on the selected copy of `S`; the second
summand closes the rank-one operator determined by `ρ(c)`. -/
def contractedRankOne
    (i : (ι → k) →ₗ[k] (κ → k)) (ρ : (κ → k) →ₗ[k] (ι → k))
    (c : κ → k) : κ → k :=
  ∑ j, ((ρ (i (coordinateVector j)) j) • c + (ρ c j) • i (coordinateVector j))

/-- Evaluation--coevaluation gives `dim(S)` copies of the affine cocycle plus the projection of
that cocycle through the selected retract. -/
theorem contractedRankOne_eq
    (i : (ι → k) →ₗ[k] (κ → k)) (ρ : (κ → k) →ₗ[k] (ι → k))
    (hretract : ∀ x, ρ (i x) = x) (c : κ → k) :
    contractedRankOne i ρ c = (Fintype.card ι : k) • c + i (ρ c) := by
  rw [contractedRankOne, Finset.sum_add_distrib]
  congr 1
  · have hj : ∀ j : ι, ρ (i (coordinateVector j)) j = 1 := by
      intro j
      have h := congrFun (hretract (coordinateVector j)) j
      simpa [coordinateVector] using h
    simp_rw [hj]
    ext x
    simp
  · have h := congrArg (fun x : ι → k ↦ i x) (sum_smul_coordinateVector (ρ c))
    simpa using h

/-- Pointwise form of the contraction identity for an arbitrary cochain `c : G → F`. -/
theorem contractedCochain_eq
    (i : (ι → k) →ₗ[k] (κ → k)) (ρ : (κ → k) →ₗ[k] (ι → k))
    (hretract : ∀ x, ρ (i x) = x) (c : G → κ → k) :
    (fun g ↦ contractedRankOne i ρ (c g)) =
      fun g ↦ (Fintype.card ι : k) • c g + i (ρ (c g)) := by
  funext g
  exact contractedRankOne_eq i ρ hretract (c g)

end RelativeConicArcs.ClebschAffineExtensionContraction
