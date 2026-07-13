import RelativeConicArcs.Q11SemanticBase

namespace RelativeConicArcs.Examples.Q11Coding

open Certificate

set_option maxRecDepth 100000

private instance : Fact (Nat.Prime 11) := ⟨by decide⟩

theorem affineRayOfVec_rightInverse : Function.RightInverse affineRayOfVec
    (fun p : AffineRay => (⟨affineRayVec p, affineRayVec_ne_zero p⟩ :
      {s : Vec (ZMod 11) // s ≠ 0})) := by
  intro s
  apply Subtype.ext
  funext k
  unfold affineRayOfVec
  split_ifs with h₀ h₁
  · have hval₁ := (s.1 1 / s.1 0).val_lt
    have hval₂ := (s.1 2 / s.1 0).val_lt
    have hlt : (s.1 1 / s.1 0).val * 11 + (s.1 2 / s.1 0).val < 121 := by omega
    have hdiv : ((s.1 1 / s.1 0).val * 11 + (s.1 2 / s.1 0).val) / 11 =
        (s.1 1 / s.1 0).val := by omega
    have hp : projectiveVec
        ⟨(s.1 1 / s.1 0).val * 11 + (s.1 2 / s.1 0).val, by omega⟩ =
          ![1, s.1 1 / s.1 0, s.1 2 / s.1 0] := by
      simp [projectiveVec, hlt, hdiv]
    change (s.1 0 • projectiveVec
      ⟨(s.1 1 / s.1 0).val * 11 + (s.1 2 / s.1 0).val, _⟩) k = s.1 k
    rw [hp]
    fin_cases k <;> simp [div_eq_mul_inv, h₀, mul_comm]
  · have hs₀ : s.1 0 = 0 := not_ne_iff.mp h₀
    have hval₂ := (s.1 2 / s.1 1).val_lt
    have hlt : 121 + (s.1 2 / s.1 1).val < 132 := by omega
    have hp : projectiveVec ⟨121 + (s.1 2 / s.1 1).val, by omega⟩ =
        ![0, 1, s.1 2 / s.1 1] := by
      simp [projectiveVec, hlt]
    change (s.1 1 • projectiveVec ⟨121 + (s.1 2 / s.1 1).val, _⟩) k = s.1 k
    rw [hp]
    fin_cases k <;> simp [hs₀, div_eq_mul_inv, h₁, mul_comm]
  · have hs₀ : s.1 0 = 0 := not_ne_iff.mp h₀
    have hs₁ : s.1 1 = 0 := not_ne_iff.mp h₁
    fin_cases k <;> simp [affineRayVec, projectiveVec, hs₀, hs₁]

theorem affineRayVec_bijective : Function.Bijective
    (fun p : AffineRay => (⟨affineRayVec p, affineRayVec_ne_zero p⟩ :
      {s : Vec (ZMod 11) // s ≠ 0})) :=
  (Fintype.bijective_iff_surjective_and_card _).mpr
    ⟨affineRayOfVec_rightInverse.surjective, by decide⟩

noncomputable def affineRayEquiv : AffineRay ≃ {s : Vec (ZMod 11) // s ≠ 0} :=
  Equiv.ofBijective _ affineRayVec_bijective

end RelativeConicArcs.Examples.Q11Coding
