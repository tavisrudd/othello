import RelativeConicArcs.EvaluationDichotomy

/-!
# Avoiding linear conditions and a cubic-size exceptional set

Let `W` be an `r`-dimensional vector space over a finite field with `q` elements.  A family of at
most `q - 3` proper linear hyperplanes leaves more than `3 q^(r-1)` vectors uncovered when
`q ≥ 5` and `r ≥ 2`.  Consequently, the uncovered vectors cannot all lie in an exceptional set of
that size.

For ternary quadratic forms, the singular forms are cut out by the cubic conic discriminant.
The results here isolate the finite linear-algebra and cardinal-arithmetic part of the argument.
They do not identify an abstract exceptional set with a discriminant zero locus.
-/

namespace RelativeConicArcs

section CubicExceptionalSet

variable {K W ι : Type*} [Field K] [Fintype K] [DecidableEq K]
  [AddCommGroup W] [Module K W] [Fintype W] [DecidableEq W]
  [FiniteDimensional K W]

private theorem cubic_bound_lt_hyperplane_complement {q m r : ℕ}
    (hq : 5 ≤ q) (hm : m ≤ q - 3) (hr : 2 ≤ r) :
    3 * q ^ (r - 1) < (q - 1) * q ^ (r - 2) * (q + 1 - m) := by
  let p := q ^ (r - 2)
  have hp : 0 < p := pow_pos (by omega : 0 < q) _
  have hpow : q ^ (r - 1) = q * p := by
    rw [show r - 1 = (r - 2) + 1 by omega, pow_succ, Nat.mul_comm]
  have hbase : 3 * q < 4 * (q - 1) := by omega
  have hfactor : 4 ≤ q + 1 - m := by omega
  calc
    3 * q ^ (r - 1) = (3 * q) * p := by rw [hpow]; ring
    _ < (4 * (q - 1)) * p := Nat.mul_lt_mul_of_pos_right hbase hp
    _ = (q - 1) * p * 4 := by ring
    _ ≤ (q - 1) * p * (q + 1 - m) :=
      Nat.mul_le_mul_left ((q - 1) * p) hfactor

omit [DecidableEq K] in
/-- A cubic-size exceptional set cannot contain every vector outside at most `q - 3`
hyperplanes. -/
theorem exists_outside_hyperplanes_not_mem_of_cubic_bound
    (s : Finset (Submodule K W)) (bad : Finset W)
    (hs : s.Nonempty) (hdim : 2 ≤ Module.finrank K W)
    (hq : 5 ≤ Fintype.card K) (hcard : s.card ≤ Fintype.card K - 3)
    (hhyper : ∀ H ∈ s, Module.finrank K H + 1 = Module.finrank K W)
    (hbad : bad.card ≤ 3 * Fintype.card K ^ (Module.finrank K W - 1)) :
    ∃ x, x ∈ outsideSubmodules s ∧ x ∉ bad := by
  have hcardq : s.card ≤ Fintype.card K := by omega
  have houtside := card_outside_hyperplanes_factored_lower_bound
    s hs hdim hcardq hhyper
  have hthreshold :
      3 * Fintype.card K ^ (Module.finrank K W - 1) <
        (Fintype.card K - 1) *
          Fintype.card K ^ (Module.finrank K W - 2) *
            (Fintype.card K + 1 - s.card) :=
    cubic_bound_lt_hyperplane_complement hq hcard hdim
  have hlt : bad.card < (outsideSubmodules s).card :=
    lt_of_le_of_lt hbad (lt_of_lt_of_le hthreshold houtside)
  exact Finset.exists_mem_notMem_of_card_lt_card hlt

/-- Functional form of cubic-exceptional-set avoidance.  The returned vector is nonzero, avoids
the exceptional set, and is nonzero under every selected functional. -/
theorem exists_ne_zero_apply_ne_zero_not_mem_of_cubic_bound
    (s : Finset ι) (L : ι → W →ₗ[K] K) (bad : Finset W)
    (hs : s.Nonempty) (hdim : 2 ≤ Module.finrank K W)
    (hq : 5 ≤ Fintype.card K) (hcard : s.card ≤ Fintype.card K - 3)
    (hne : ∀ i ∈ s, L i ≠ 0)
    (hbad : bad.card ≤ 3 * Fintype.card K ^ (Module.finrank K W - 1)) :
    ∃ x, x ≠ 0 ∧ x ∉ bad ∧ ∀ i ∈ s, L i x ≠ 0 := by
  classical
  let H : Finset (Submodule K W) := s.image fun i => LinearMap.ker (L i)
  have hHnonempty : H.Nonempty := hs.image _
  have hHcard : H.card ≤ Fintype.card K - 3 :=
    (Finset.card_image_le.trans hcard)
  have hHhyper : ∀ G ∈ H, Module.finrank K G + 1 = Module.finrank K W := by
    intro G hG
    obtain ⟨i, hi, rfl⟩ := Finset.mem_image.mp hG
    exact Module.Dual.finrank_ker_add_one_of_ne_zero (hne i hi)
  obtain ⟨x, hxoutside, hxbad⟩ :=
    exists_outside_hyperplanes_not_mem_of_cubic_bound
      H bad hHnonempty hdim hq hHcard hHhyper hbad
  have havoid : ∀ i ∈ s, L i x ≠ 0 := by
    intro i hi hzero
    have hxker : x ∈ LinearMap.ker (L i) := LinearMap.mem_ker.mpr hzero
    have hxunion : x ∈ H.biUnion submoduleFinset := by
      apply Finset.mem_biUnion.mpr
      exact ⟨LinearMap.ker (L i), Finset.mem_image.mpr ⟨i, hi, rfl⟩, by
        simpa [submoduleFinset] using hxker⟩
    exact (Finset.mem_sdiff.mp hxoutside).2 hxunion
  obtain ⟨i, hi⟩ := hs
  refine ⟨x, ?_, hxbad, havoid⟩
  intro hxzero
  exact havoid i hi (by simp [hxzero])

end CubicExceptionalSet

end RelativeConicArcs
