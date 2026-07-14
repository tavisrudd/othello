import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_49_238 : RowResult ⟨49, by decide⟩ ⟨238, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_49_239 : RowResult ⟨49, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_49_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_49_240 : RowResult ⟨49, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_49_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_49_241 : RowResult ⟨49, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_49_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_49_242 : RowResult ⟨49, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_49_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_49_243 : RowResult ⟨49, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_49_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_49_244 : RowResult ⟨49, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_49_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨167, by decide⟩, by decide⟩

theorem row_49_245 : RowResult ⟨49, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_49_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
