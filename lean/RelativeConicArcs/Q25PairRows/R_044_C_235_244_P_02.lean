import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_44_235 : RowResult ⟨44, by decide⟩ ⟨235, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_44_236 : RowResult ⟨44, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_44_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 2 4 7)

theorem row_44_237 : RowResult ⟨44, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_44_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_238 : RowResult ⟨44, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_44_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_44_239 : RowResult ⟨44, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_44_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 4 7)

theorem row_44_240 : RowResult ⟨44, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_44_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 4 5 6)

theorem row_44_241 : RowResult ⟨44, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_44_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_242 : RowResult ⟨44, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_44_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_243 : RowResult ⟨44, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_44_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_44_244 : RowResult ⟨44, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_44_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
