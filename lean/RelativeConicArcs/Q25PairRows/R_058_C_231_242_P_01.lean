import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_58_231 : RowResult ⟨58, by decide⟩ ⟨231, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_58_232 : RowResult ⟨58, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_58_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_58_233 : RowResult ⟨58, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_58_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 1 4 6)

theorem row_58_234 : RowResult ⟨58, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_58_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_58_235 : RowResult ⟨58, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_58_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_58_236 : RowResult ⟨58, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_58_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 4 5 6)

theorem row_58_237 : RowResult ⟨58, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_58_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 2 5 7)

theorem row_58_238 : RowResult ⟨58, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_58_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨196, by decide⟩, by decide⟩

theorem row_58_239 : RowResult ⟨58, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_58_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_58_240 : RowResult ⟨58, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_58_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_58_241 : RowResult ⟨58, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_58_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 2 5 6)

theorem row_58_242 : RowResult ⟨58, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_58_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
