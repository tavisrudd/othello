import Mathlib.Tactic
import Mathlib.LinearAlgebra.Dimension.Finrank

/-!
# Strict degree increase and nilpotence

A linear operator that raises a finite decreasing filtration annihilates the
whole vector space after the filtration length. The coefficient-degree
inequality for an Euler insertion on a nef-canonical surface is proved as an
integer inequality; the virtual-dimension formula and its realization by the
operator remain geometric inputs.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

/-- Iteration of a strictly filtration-raising endomorphism lands in the
corresponding filtration step, starting from a full degree-zero filtration. -/
theorem strictlyRaising_pow_mem
    {K V : Type*} [Field K] [AddCommGroup V] [Module K V]
    (filtration : ℕ → Submodule K V) (full : filtration 0=⊤)
    (operator : V →ₗ[K] V)
    (raises : ∀ n x, x ∈ filtration n → operator x ∈ filtration (n+1)) :
    ∀ n x, (operator^n) x ∈ filtration n := by
  intro n
  induction n with
  | zero => intro x; simp [full]
  | succ n ih =>
    intro x
    rw [pow_succ']
    exact raises n ((operator^n) x) (ih x)

/-- A strictly raising endomorphism of a finite filtration is nilpotent;
the nilpotence exponent is the first specified zero filtration step. -/
theorem strictlyRaising_nilpotent
    {K V : Type*} [Field K] [AddCommGroup V] [Module K V]
    (filtration : ℕ → Submodule K V) (full : filtration 0=⊤)
    (operator : V →ₗ[K] V)
    (raises : ∀ n x, x ∈ filtration n → operator x ∈ filtration (n+1))
    (bound : ℕ) (zero : filtration bound=⊥) :
    operator^bound=0 := by
  ext x
  have h := strictlyRaising_pow_mem filtration full operator raises bound x
  simpa [zero] using h

/-- The virtual-dimension expression strictly raises degree when the Euler
insertion has positive degree, every nonunit bulk insertion has degree at
least one, and the curve has nonpositive first-Chern pairing. -/
theorem nefSurface_virtualDegree_strictly_increases
    {ι : Type*} (insertions : Finset ι) (degree : ι → ℤ)
    (positiveBulk : ∀ i ∈ insertions, 1 ≤ degree i)
    (input euler chern : ℤ) (positiveEuler : 1 ≤ euler) (nef : chern ≤ 0) :
    input < input + euler + (∑ i ∈ insertions, (degree i-1)) - chern := by
  have nonnegative : 0 ≤ ∑ i ∈ insertions, (degree i-1) :=
    Finset.sum_nonneg (fun i hi => sub_nonneg.mpr (positiveBulk i hi))
  omega

/-- A projective surface with positive second Betti number has full even
rank at least three; equality forces the second Betti number to be one. -/
theorem surfaceEvenRank_bounds (secondBetti : ℕ) (positive : 1 ≤ secondBetti) :
    3 ≤ secondBetti+2 ∧ (secondBetti+2=3 ↔ secondBetti=1) := by omega

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
