import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_139_240 : RowResult ⟨139, by decide⟩ ⟨240, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_139_241 : RowResult ⟨139, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_139_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_139_242 : RowResult ⟨139, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_139_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_139_243 : RowResult ⟨139, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_139_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_139_244 : RowResult ⟨139, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_139_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 1 4 7)

theorem row_139_245 : RowResult ⟨139, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_139_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_139_246 : RowResult ⟨139, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_139_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_139_247 : RowResult ⟨139, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_139_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
