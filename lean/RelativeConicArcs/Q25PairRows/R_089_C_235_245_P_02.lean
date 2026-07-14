import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_89_235 : RowResult ⟨89, by decide⟩ ⟨235, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_89_236 : RowResult ⟨89, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_89_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_89_237 : RowResult ⟨89, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_89_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 4 5 6)

theorem row_89_238 : RowResult ⟨89, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_89_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_89_239 : RowResult ⟨89, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_89_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 4 6)

theorem row_89_240 : RowResult ⟨89, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_89_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 2 5 7)

theorem row_89_241 : RowResult ⟨89, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_89_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_89_242 : RowResult ⟨89, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_89_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_89_243 : RowResult ⟨89, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_89_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_89_244 : RowResult ⟨89, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_89_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 1 4 7)

theorem row_89_245 : RowResult ⟨89, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_89_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
