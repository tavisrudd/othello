import RelativeConicArcs.Q25PairRows

/-! Kernel-checked composition of the normalized exceptional-profile row certificates. -/

namespace RelativeConicArcs.Q25PairCertificate

open Q25Coordinates FiniteFields

/-- Every normalized arc containing `[1:ω:ω], [1:-ω:-ω]` has two distinct legal conjugate-pair
extensions.  External computation proposes two small certificates per valid row; every obstruction,
legal extension, and witness inequality used here is independently checked by Lean. -/
theorem first_slice_two_005 :
    FirstSliceTwo (.affineY 0 0 (FiniteFields.GF25.ofNat 5)) := by
  intro b c hab hbc hcap
  let bn : Fin 310 := ⟨orbitNumber b, orbitNumber_lt b⟩
  let cn : Fin 310 := ⟨orbitNumber c, orbitNumber_lt c⟩
  have h5 : 5 < bn.val := by
    simpa [bn, orbitNumber, FiniteFields.GF25.ofNat] using hab
  have hbnc : bn.val < cn.val := by simpa [bn, cn] using hbc
  have hr := allRows bn cn h5 hbnc
  have hr' :
      ¬ RawCap (normalizedConfig (.affineY 0 0 (FiniteFields.GF25.ofNat 5)) b c) ∨
        ∃ q r : OrbitCode,
          TwoLegalPairs
            (normalizedConfig (.affineY 0 0 (FiniteFields.GF25.ofNat 5)) b c) q r := by
    have hfive : orbitCodeOfNumber (5 : Fin 310) =
        .affineY 0 0 (FiniteFields.GF25.ofNat 5) := by decide
    simpa [RowResult, bn, cn, hfive] using hr
  rcases hr' with hnot | hlegal
  · exact False.elim (hnot hcap)
  · exact hlegal

/-- The original one-witness slice remains available as a projection of the stronger certificate. -/
theorem first_slice_005 :
    FirstSlice (.affineY 0 0 (FiniteFields.GF25.ofNat 5)) := by
  intro b c hab hbc hcap
  obtain ⟨q, r, _hqr, hq, _hr⟩ := first_slice_two_005 b c hab hbc hcap
  exact ⟨q, hq⟩

end RelativeConicArcs.Q25PairCertificate
