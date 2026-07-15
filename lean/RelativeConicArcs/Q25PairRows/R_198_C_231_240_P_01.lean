import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_198_231 : RowResult ⟨198, by decide⟩ ⟨231, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_198_232 : RowResult ⟨198, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_198_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_198_233 : RowResult ⟨198, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_198_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 1 4 7)

theorem row_198_234 : RowResult ⟨198, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_198_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 5 6)

theorem row_198_235 : RowResult ⟨198, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_198_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_198_236 : RowResult ⟨198, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_198_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_198_237 : RowResult ⟨198, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_198_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 2 4 6)

theorem row_198_238 : RowResult ⟨198, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_198_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_198_239 : RowResult ⟨198, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_198_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_198_240 : RowResult ⟨198, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_198_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
