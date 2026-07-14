import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_31_232 : RowResult ⟨31, by decide⟩ ⟨232, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_31_233 : RowResult ⟨31, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_31_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 4 5 6)

theorem row_31_234 : RowResult ⟨31, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_31_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 5 6)

theorem row_31_235 : RowResult ⟨31, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_31_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_31_236 : RowResult ⟨31, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_31_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_31_237 : RowResult ⟨31, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_31_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 2 4 7)

theorem row_31_238 : RowResult ⟨31, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_31_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_31_239 : RowResult ⟨31, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_31_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_31_240 : RowResult ⟨31, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_31_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_31_241 : RowResult ⟨31, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_31_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 2 4 6)

theorem row_31_242 : RowResult ⟨31, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_31_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
