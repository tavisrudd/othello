import RelativeConicArcs.Q25PairRows

/-! Kernel-checked composition of the normalized exceptional-profile row certificates. -/

namespace RelativeConicArcs.Q25PairCertificate

open Q25Coordinates FiniteFields

/-- Every normalized arc containing `[1:ω:ω], [1:-ω:-ω]` has a legal conjugate-pair
extension.  External computation proposes one small certificate per row; every obstruction or
legal extension used here is independently checked by Lean. -/
theorem first_slice_005 :
    FirstSlice (.affineY 0 0 (FiniteFields.GF25.ofNat 5)) := by
  intro b c hab hbc hcap
  let bn : Fin 310 := ⟨orbitNumber b, orbitNumber_lt b⟩
  let cn : Fin 310 := ⟨orbitNumber c, orbitNumber_lt c⟩
  have h5 : 5 < bn.val := by
    simpa [bn, orbitNumber, FiniteFields.GF25.ofNat] using hab
  have hbnc : bn.val < cn.val := by simpa [bn, cn] using hbc
  have hr := allRows bn cn h5 hbnc
  have hr' :
      ¬ RawCap (normalizedConfig (.affineY 0 0 (FiniteFields.GF25.ofNat 5)) b c) ∨
        ∃ q : OrbitCode,
          LegalPair (normalizedConfig (.affineY 0 0 (FiniteFields.GF25.ofNat 5)) b c) q := by
    have hfive : orbitCodeOfNumber (5 : Fin 310) =
        .affineY 0 0 (FiniteFields.GF25.ofNat 5) := by decide
    simpa [RowResult, bn, cn, hfive] using hr
  rcases hr' with hnot | hlegal
  · exact False.elim (hnot hcap)
  · exact hlegal

end RelativeConicArcs.Q25PairCertificate
