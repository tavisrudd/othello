import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_193_232 : RowResult ⟨193, by decide⟩ ⟨232, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_193_233 : RowResult ⟨193, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_193_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 2 5 7)

theorem row_193_234 : RowResult ⟨193, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_193_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_193_235 : RowResult ⟨193, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_193_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_193_236 : RowResult ⟨193, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_193_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_193_237 : RowResult ⟨193, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_193_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_193_238 : RowResult ⟨193, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_193_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 1 4 7)

theorem row_193_239 : RowResult ⟨193, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_193_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_193_240 : RowResult ⟨193, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_193_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_193_241 : RowResult ⟨193, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_193_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 2 4 7)

theorem row_193_242 : RowResult ⟨193, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_193_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 4 5 6)

theorem row_193_243 : RowResult ⟨193, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_193_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
