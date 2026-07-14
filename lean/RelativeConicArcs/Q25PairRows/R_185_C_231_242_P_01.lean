import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_185_231 : RowResult ⟨185, by decide⟩ ⟨231, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_185_232 : RowResult ⟨185, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_185_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 2 5 7)

theorem row_185_233 : RowResult ⟨185, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_185_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_185_234 : RowResult ⟨185, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_185_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 4 6)

theorem row_185_235 : RowResult ⟨185, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_185_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 1 4 6)

theorem row_185_236 : RowResult ⟨185, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_185_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 4 5 6)

theorem row_185_237 : RowResult ⟨185, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_185_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_185_238 : RowResult ⟨185, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_185_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_185_239 : RowResult ⟨185, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_185_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_185_240 : RowResult ⟨185, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_185_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 1 4 7)

theorem row_185_241 : RowResult ⟨185, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_185_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_185_242 : RowResult ⟨185, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_185_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
