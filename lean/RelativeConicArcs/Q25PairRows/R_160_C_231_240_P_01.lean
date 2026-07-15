import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_160_231 : RowResult ⟨160, by decide⟩ ⟨231, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_160_232 : RowResult ⟨160, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_160_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_160_233 : RowResult ⟨160, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_160_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 2 4 7)

theorem row_160_234 : RowResult ⟨160, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_160_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_160_235 : RowResult ⟨160, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_160_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 1 4 6)

theorem row_160_236 : RowResult ⟨160, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_160_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_160_237 : RowResult ⟨160, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_160_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_160_238 : RowResult ⟨160, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_160_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_160_239 : RowResult ⟨160, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_160_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_160_240 : RowResult ⟨160, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_160_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
