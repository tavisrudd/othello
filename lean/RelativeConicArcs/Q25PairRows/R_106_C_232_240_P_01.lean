import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_106_232 : RowResult ⟨106, by decide⟩ ⟨232, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_106_233 : RowResult ⟨106, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_106_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_106_234 : RowResult ⟨106, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_106_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_106_235 : RowResult ⟨106, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_106_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_106_236 : RowResult ⟨106, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_106_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_106_237 : RowResult ⟨106, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_106_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 2 5 6)

theorem row_106_238 : RowResult ⟨106, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_106_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 4 5 6)

theorem row_106_239 : RowResult ⟨106, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_106_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_106_240 : RowResult ⟨106, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_106_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
