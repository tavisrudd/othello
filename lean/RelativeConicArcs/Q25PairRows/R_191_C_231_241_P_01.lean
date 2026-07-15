import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_191_231 : RowResult ⟨191, by decide⟩ ⟨231, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_191_232 : RowResult ⟨191, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_191_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_191_233 : RowResult ⟨191, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_191_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_191_234 : RowResult ⟨191, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_191_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_191_235 : RowResult ⟨191, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_191_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 5 7)

theorem row_191_236 : RowResult ⟨191, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_191_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 4 7)

theorem row_191_237 : RowResult ⟨191, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_191_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_191_238 : RowResult ⟨191, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_191_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_191_239 : RowResult ⟨191, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_191_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_191_240 : RowResult ⟨191, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_191_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 4 5 6)

theorem row_191_241 : RowResult ⟨191, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_191_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
