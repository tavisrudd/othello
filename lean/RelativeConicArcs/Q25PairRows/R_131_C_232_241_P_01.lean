import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_131_232 : RowResult ⟨131, by decide⟩ ⟨232, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 4 5 6)

theorem row_131_233 : RowResult ⟨131, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_131_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_131_234 : RowResult ⟨131, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_131_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_131_235 : RowResult ⟨131, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_131_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨41, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_131_236 : RowResult ⟨131, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_131_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨215, by decide⟩, by decide⟩

theorem row_131_237 : RowResult ⟨131, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_131_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_131_238 : RowResult ⟨131, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_131_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 2 5 6)

theorem row_131_239 : RowResult ⟨131, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_131_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_131_240 : RowResult ⟨131, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_131_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_131_241 : RowResult ⟨131, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_131_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
