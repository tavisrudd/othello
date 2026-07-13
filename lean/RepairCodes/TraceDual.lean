import RepairCodes.OuterDual
import Mathlib.RingTheory.Trace.Basic
import Mathlib.LinearAlgebra.BilinearForm.Properties

/-!
# Restriction of scalars preserves the outer dual-distance gate

Let `L/K` be a finite separable field extension and let `O ≤ L^ι` be an `L`-linear
code.  After restriction of scalars, the coordinate-free outer dual used by the repair
transfer theorem consists of tuples of `K`-linear functionals `L → K`.

The trace pairing identifies every such functional uniquely with

`x ↦ Tr[L/K](a * x)`.

If a tuple of functionals annihilates the restricted code, applying it to every scalar
multiple `c • u` of an outer word shows, by nondegeneracy of the trace pairing, that the
coefficient tuple `a` lies in the ordinary `L`-linear dual code.  The trace identification
is injective in every coordinate, so the two tuples have exactly the same Hamming support.

This is finite linear algebra.  It uses no imported coding-theory or asymptotic theorem.
-/

namespace RepairCodes

open Finset FiniteGeom
open scoped BigOperators

noncomputable section

variable {K L ι : Type*}
variable [Field K] [Field L] [Algebra K L]
variable [FiniteDimensional K L] [Algebra.IsSeparable K L]
variable [Fintype ι] [DecidableEq L]

/-- The coefficient representing a base-field functional under the trace pairing. -/
noncomputable def traceCoefficient (f : Module.Dual K L) : L :=
  ((Algebra.traceForm K L).toDual (traceForm_nondegenerate K L)).symm f

omit [DecidableEq L] in
@[simp]
theorem trace_traceCoefficient_mul (f : Module.Dual K L) (x : L) :
    Algebra.trace K L (traceCoefficient f * x) = f x := by
  simpa only [traceCoefficient, Algebra.traceForm_apply] using
    (LinearMap.BilinForm.apply_toDual_symm_apply
      (B := Algebra.traceForm K L) (hB := traceForm_nondegenerate K L) f x)

omit [DecidableEq L] in
@[simp]
theorem traceCoefficient_eq_zero_iff (f : Module.Dual K L) :
    traceCoefficient f = 0 ↔ f = 0 := by
  let e := (Algebra.traceForm K L).toDual (traceForm_nondegenerate K L)
  change e.symm f = 0 ↔ f = 0
  exact e.symm.map_eq_zero_iff

omit [DecidableEq L] in
/-- A functional-dual word of the restricted code is represented by an ordinary
extension-field dual word. -/
theorem traceCoefficient_mem_dualCode
    (O : Submodule L (ι → L)) (beta : ι → Module.Dual K L)
    (hbeta : beta ∈ functionalDual (O.restrictScalars K)) :
    (fun j ↦ traceCoefficient (beta j)) ∈ dualCode O := by
  rw [mem_dualCode]
  intro u hu
  let a : ι → L := fun j ↦ traceCoefficient (beta j)
  let e := (Algebra.traceForm K L).toDual (traceForm_nondegenerate K L)
  have htrace (c : L) : Algebra.trace K L ((u ⬝ᵥ a) * c) = 0 := by
    have h := hbeta (c • u) (O.smul_mem c hu)
    rw [show (u ⬝ᵥ a) * c = ∑ j, a j * (c * u j) by
      simp only [dotProduct, Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro j _
      dsimp only [a]
      ring]
    rw [map_sum]
    calc
      ∑ j, Algebra.trace K L (a j * (c * u j)) =
          ∑ j, beta j (c * u j) := by
        apply Finset.sum_congr rfl
        intro j _
        exact trace_traceCoefficient_mul (beta j) (c * u j)
      _ = 0 := by simpa only [Pi.smul_apply, smul_eq_mul] using h
  apply e.injective
  apply LinearMap.ext
  intro c
  change Algebra.trace K L ((u ⬝ᵥ a) * c) = Algebra.trace K L (0 * c)
  simpa using htrace c

/-- The trace representation preserves the support, hence the Hamming weight, exactly. -/
theorem functionalWeight_traceCoefficient (beta : ι → Module.Dual K L) :
    functionalWeight beta = hammingNorm (fun j ↦ traceCoefficient (beta j)) := by
  classical
  unfold functionalWeight hammingNorm
  congr 1
  ext j
  simp only [Finset.mem_filter, Finset.mem_univ, true_and]
  exact not_congr (traceCoefficient_eq_zero_iff (beta j)).symm

/-- **Trace-duality bridge.** Ordinary extension-field dual distance at least `d`
implies the coordinate-free functional-dual distance gate at least `d` after restriction
of scalars to the base field. -/
theorem hasFunctionalDualDistanceAtLeast_restrictScalars
    (O : Submodule L (ι → L)) (d : ℕ) (hd : d ≤ dualDist O) :
    HasFunctionalDualDistanceAtLeast (O.restrictScalars K) d := by
  intro beta hbeta hbeta0
  let a : ι → L := fun j ↦ traceCoefficient (beta j)
  have ha : a ∈ dualCode O := traceCoefficient_mem_dualCode O beta hbeta
  have ha0 : a ≠ 0 := by
    intro ha0
    apply hbeta0
    funext j
    have haj : a j = 0 := congrFun ha0 j
    exact (traceCoefficient_eq_zero_iff (beta j)).mp haj
  calc
    d ≤ dualDist O := hd
    _ ≤ hammingNorm a := dualDist_le_hammingNorm ha ha0
    _ = functionalWeight beta := (functionalWeight_traceCoefficient beta).symm

#print axioms hasFunctionalDualDistanceAtLeast_restrictScalars

end
end RepairCodes
