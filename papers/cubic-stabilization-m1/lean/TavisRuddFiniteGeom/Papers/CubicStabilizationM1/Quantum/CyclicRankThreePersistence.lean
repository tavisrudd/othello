import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.CyclicRankThreeCentralizer
import TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum.FormalDifferentialSystemVanishing

/-!
# Persistence of a cyclic nilpotent rank-three block

For the centered companion matrix `E` of `T³-bT-c`, the compressed flatness
identity `∂E = -C + [C,A] + [B,E]` and commutation of `C` with `E` make the
ideal `(b,c)` stable under every formal coordinate derivative. Over a
characteristic-zero domain, zero initial coefficients therefore imply `E³=0`
throughout the formal germ, while `E²` remains nonzero. Matrices of a flat
connection and its cyclic frame are hypotheses; no geometric connection or
change to a cyclic frame is constructed here.
-/

namespace TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum

private theorem trace_mul_commutator_eq_zero {R n : Type*} [CommRing R]
    [Fintype n] [DecidableEq n] (e c a : Matrix n n R) (h : e*c = c*e) :
    Matrix.trace (e * (c*a-a*c)) = 0 := by
  rw [mul_sub, Matrix.trace_sub, ← Matrix.mul_assoc, h,
    Matrix.trace_mul_cycle, Matrix.mul_assoc]
  rw [Matrix.trace_mul_cycle' a c e, sub_self]

/-- Multiplying a compressed flatness identity by the cyclic Euler matrix and
its square gives differential equations with coefficients in the ideal `(b,c)`.
The derivative matrix records arbitrary tangent values `db,dc`. -/
theorem centeredCyclicRankThree_flatness_coefficients {R : Type*} [CommRing R]
    (b c db dc : R) (comparison a connection : Matrix (Fin 3) (Fin 3) R)
    (commutes : comparison * centeredCyclicRankThree b c =
      centeredCyclicRankThree b c * comparison)
    (flat : !![0,0,dc; 0,0,db; 0,0,0] = -comparison +
      (comparison*a-a*comparison) +
      (connection*centeredCyclicRankThree b c-centeredCyclicRankThree b c*connection)) :
    db = b*(-2*comparison 1 0) + c*(-3*comparison 2 0) ∧
    dc = b*(-2*comparison 0 0-2*b*comparison 2 0) + c*(-3*comparison 1 0) := by
  let e := centeredCyclicRankThree b c
  have hc : e*comparison = comparison*e := commutes.symm
  have hc2 : e^2*comparison = comparison*e^2 := by
    calc
      e^2*comparison = e*(e*comparison) := by rw [pow_two, Matrix.mul_assoc]
      _ = comparison*e^2 := by rw [hc, ← Matrix.mul_assoc, hc, Matrix.mul_assoc, ← pow_two]
  have he : e*e = e*e := rfl
  have he2 : e^2*e = e*e^2 := by noncomm_ring
  have h1 := congrArg (fun m => Matrix.trace (e*m)) flat
  have h2 := congrArg (fun m => Matrix.trace (e^2*m)) flat
  have t1 := trace_mul_commutator_eq_zero e comparison a hc
  have t2 := trace_mul_commutator_eq_zero (e^2) comparison a hc2
  have s1 := trace_mul_commutator_eq_zero e e connection he
  have s2 := trace_mul_commutator_eq_zero (e^2) e connection he2
  have swap : connection*e-e*connection = -(e*connection-connection*e) := by abel
  simp only [mul_add, mul_neg, Matrix.trace_add, Matrix.trace_neg] at h1 h2
  change _ = _ + _ + Matrix.trace (e*(connection*e-e*connection)) at h1
  change _ = _ + _ + Matrix.trace (e^2*(connection*e-e*connection)) at h2
  rw [t1, swap, mul_neg, Matrix.trace_neg, s1] at h1
  rw [t2, swap, mul_neg, Matrix.trace_neg, s2] at h2
  have traces := centeredCyclicRankThree_commuting_traces comparison commutes
  have d1 : Matrix.trace (e * !![0,0,dc; 0,0,db; 0,0,0]) = db := by
    simp [e, centeredCyclicRankThree, Matrix.trace, Matrix.diag, Matrix.mul_apply,
      Fin.sum_univ_succ]
  have d2 : Matrix.trace (e^2 * !![0,0,dc; 0,0,db; 0,0,0]) = dc := by
    simp [e, centeredCyclicRankThree, pow_two, Matrix.trace, Matrix.diag,
      Matrix.mul_apply, Fin.sum_univ_succ]
  rw [d1, traces.2.1] at h1
  rw [d2, traces.2.2] at h2
  constructor
  · linear_combination h1
  · linear_combination h2


/-- A centered cyclic rank-three block satisfying compressed flatness and
commutation in every coordinate direction remains a single nilpotent block
on a formal germ if its characteristic coefficients vanish at the origin.
The connection matrices and their identities are explicit hypotheses. -/
theorem centeredCyclicRankThree_nilpotent_persists
    {σ K : Type*} [CommRing K] [NoZeroDivisors K] [CharZero K]
    (b c : MvPowerSeries σ K)
    (comparison a connection : σ → Matrix (Fin 3) (Fin 3) (MvPowerSeries σ K))
    (initialB : MvPowerSeries.coeff 0 b = 0)
    (initialC : MvPowerSeries.coeff 0 c = 0)
    (commutes : ∀ i, comparison i * centeredCyclicRankThree b c =
      centeredCyclicRankThree b c * comparison i)
    (flat : ∀ i,
      !![0,0,formalPartialDerivative i c; 0,0,formalPartialDerivative i b; 0,0,0] =
      -comparison i + (comparison i*a i-a i*comparison i) +
      (connection i*centeredCyclicRankThree b c-centeredCyclicRankThree b c*connection i)) :
    b = 0 ∧ c = 0 ∧ (centeredCyclicRankThree b c)^3 = 0 ∧
      (centeredCyclicRankThree b c)^2 ≠ 0 := by
  classical
  let f : Fin 2 → MvPowerSeries σ K := ![b,c]
  let ω : σ → Fin 2 → Fin 2 → MvPowerSeries σ K := fun i =>
    !![-2*comparison i 1 0, -3*comparison i 2 0;
       -2*comparison i 0 0-2*b*comparison i 2 0, -3*comparison i 1 0]
  have vanish := family_eq_zero_of_constantCoeff_eq_zero_of_differential_system f ω
    (by intro j; fin_cases j <;> simp [f, initialB, initialC])
    (by
      intro i j
      have equations := centeredCyclicRankThree_flatness_coefficients b c
        (formalPartialDerivative i b) (formalPartialDerivative i c)
        (comparison i) (a i) (connection i) (commutes i) (flat i)
      fin_cases j
      · simpa [f, ω, Fin.sum_univ_succ] using equations.1
      · simpa [f, ω, Fin.sum_univ_succ] using equations.2)
  have hb : b = 0 := vanish 0
  have hc : c = 0 := vanish 1
  refine ⟨hb, hc, ?_, ?_⟩
  · rw [hb, hc]
    ext row column
    fin_cases row <;> fin_cases column <;>
      simp [centeredCyclicRankThree, pow_succ, Matrix.mul_apply, Fin.sum_univ_succ]
  · intro h
    have entry := congrArg (fun m : Matrix (Fin 3) (Fin 3) (MvPowerSeries σ K) => m 2 0) h
    simp [centeredCyclicRankThree, pow_two, Matrix.mul_apply, Fin.sum_univ_succ] at entry

end TavisRuddFiniteGeom.Papers.CubicStabilizationM1.Quantum
