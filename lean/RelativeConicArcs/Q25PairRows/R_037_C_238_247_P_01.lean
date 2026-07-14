import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_37_238 : RowResult ⟨37, by decide⟩ ⟨238, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_37_239 : RowResult ⟨37, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_37_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_37_240 : RowResult ⟨37, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_37_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_37_241 : RowResult ⟨37, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_37_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_37_242 : RowResult ⟨37, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_37_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 1 4 7)

theorem row_37_243 : RowResult ⟨37, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_37_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 2 4 7)

theorem row_37_244 : RowResult ⟨37, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_37_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_37_245 : RowResult ⟨37, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_37_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_37_246 : RowResult ⟨37, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_37_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_37_247 : RowResult ⟨37, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_37_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
