import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_167_221 : RowResult ⟨167, by decide⟩ ⟨221, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_167_222 : RowResult ⟨167, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_167_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_167_223 : RowResult ⟨167, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_167_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_167_224 : RowResult ⟨167, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_167_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_167_225 : RowResult ⟨167, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_167_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_167_226 : RowResult ⟨167, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_167_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_167_227 : RowResult ⟨167, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_167_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_167_228 : RowResult ⟨167, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_167_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_167_229 : RowResult ⟨167, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_167_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_167_230 : RowResult ⟨167, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_167_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_167_231 : RowResult ⟨167, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_167_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_167_232 : RowResult ⟨167, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_167_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_167_233 : RowResult ⟨167, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_167_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 2 5 7)

theorem row_167_234 : RowResult ⟨167, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_167_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
