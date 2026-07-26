import Mathlib.LinearAlgebra.FiniteDimensional.Lemmas

/-!
# Nonprincipal sheet summands and a one-dimensional trade kernel

Let a sheet vector space split as `P₀ × Q`, where `P₀` contains the
principal summand and `Q` is the sum of the nonprincipal summands.  Two
sheets then form

`(P₀ × Q) × (P₀ × Q)`.

If the kernel of a quadratic moment map is supported entirely in the two
`P₀` coordinates, its restriction to the two displayed copies of `Q` is
injective.  Thus both nonprincipal sheet copies embed in the quadratic
target.  In finite dimension this forces twice the dimension of `Q` to be
at most the dimension of that target.

The result is linear algebra.  Applications to permutation modules supply
the principal/nonprincipal decomposition and prove that the unique
full-support sheet-sign trade is supported in the principal coordinates.
-/

namespace RelativeConicArcs.QuadraticTradeProjectiveBridge

open Function LinearMap

noncomputable section

variable {k P₀ Q R : Type*} [Field k]
  [AddCommGroup P₀] [Module k P₀]
  [AddCommGroup Q] [Module k Q]
  [AddCommGroup R] [Module k R]

/-- Insert two nonprincipal sheet vectors into the two-sheet space. -/
def nonprincipalSheets :
    Q × Q →ₗ[k] (P₀ × Q) × (P₀ × Q) where
  toFun x := ((0, x.1), (0, x.2))
  map_add' x y := by
    ext <;> simp
  map_smul' c x := by
    ext <;> simp

/-- The insertion of the two nonprincipal sheet copies is injective. -/
theorem nonprincipalSheets_injective :
    Function.Injective (nonprincipalSheets (k := k) (P₀ := P₀) (Q := Q)) := by
  intro x y hxy
  apply Prod.ext
  · simpa [nonprincipalSheets] using congrArg (fun z => z.1.2) hxy
  · simpa [nonprincipalSheets] using congrArg (fun z => z.2.2) hxy

/-- A moment kernel is supported in the principal sheet coordinates when
every vector in it has zero nonprincipal coordinate on both sheets. -/
def KernelSupportedOnPrincipal
    (moments : (P₀ × Q) × (P₀ × Q) →ₗ[k] R) : Prop :=
  ∀ x, moments x = 0 → x.1.2 = 0 ∧ x.2.2 = 0

/-- The signed line through a chosen principal vector on the two sheets. -/
def principalTradeLine (principal : P₀) :
    k →ₗ[k] (P₀ × Q) × (P₀ × Q) where
  toFun a := ((a • principal, 0), (-a • principal, 0))
  map_add' a b := by
    ext <;> simp [add_smul, add_comm]
  map_smul' a b := by
    ext <;> simp [mul_smul]

/-- If every moment-kernel vector lies on the signed principal line, then
the kernel is supported in the principal coordinates. -/
theorem kernelSupportedOnPrincipal_of_ker_le_principalTradeLine
    (moments : (P₀ × Q) × (P₀ × Q) →ₗ[k] R)
    (principal : P₀)
    (hkernel :
      LinearMap.ker moments ≤
        LinearMap.range
          (principalTradeLine (k := k) (Q := Q) principal)) :
    KernelSupportedOnPrincipal moments := by
  intro x hx
  obtain ⟨a, ha⟩ := hkernel (LinearMap.mem_ker.mpr hx)
  constructor
  · simpa [principalTradeLine] using (congrArg (fun z => z.1.2) ha).symm
  · simpa [principalTradeLine] using (congrArg (fun z => z.2.2) ha).symm

/-- If every quadratic trade is supported in the principal coordinates,
the quadratic moment map is injective on the two nonprincipal sheet
copies. -/
theorem moments_comp_nonprincipalSheets_injective
    (moments : (P₀ × Q) × (P₀ × Q) →ₗ[k] R)
    (hkernel : KernelSupportedOnPrincipal moments) :
    Function.Injective
      (moments.comp
        (nonprincipalSheets (k := k) (P₀ := P₀) (Q := Q))) := by
  intro x y hxy
  have hzero :
      moments
          (nonprincipalSheets (k := k) (P₀ := P₀) (Q := Q) (x - y)) =
        0 := by
    simp only [map_sub]
    exact sub_eq_zero.mpr hxy
  have hcoordinates := hkernel _ hzero
  have hdifference : (x - y).1 = 0 ∧ (x - y).2 = 0 := by
    simpa [nonprincipalSheets] using hcoordinates
  apply sub_eq_zero.mp
  exact Prod.ext hdifference.1 hdifference.2

/-- In finite dimension, a principal-supported trade kernel forces the
quadratic target to have room for both nonprincipal sheet copies. -/
theorem two_mul_finrank_nonprincipal_le_target
    [Module.Finite k Q] [Module.Finite k R]
    (moments : (P₀ × Q) × (P₀ × Q) →ₗ[k] R)
    (hkernel : KernelSupportedOnPrincipal moments) :
    2 * Module.finrank k Q ≤ Module.finrank k R := by
  have hinjective :=
    moments_comp_nonprincipalSheets_injective moments hkernel
  have hle :
      Module.finrank k (Q × Q) ≤ Module.finrank k R :=
    (moments.comp
      (nonprincipalSheets (k := k) (P₀ := P₀) (Q := Q))).finrank_le_finrank_of_injective
      hinjective
  simpa [Module.finrank_prod, two_mul] using hle

end

end RelativeConicArcs.QuadraticTradeProjectiveBridge
