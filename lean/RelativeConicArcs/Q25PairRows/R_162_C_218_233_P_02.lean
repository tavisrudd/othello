import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_162_218 : RowResult ⟨162, by decide⟩ ⟨218, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_162_219 : RowResult ⟨162, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_162_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_162_220 : RowResult ⟨162, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_162_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_162_221 : RowResult ⟨162, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_162_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 2 4 6)

theorem row_162_222 : RowResult ⟨162, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_162_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_162_223 : RowResult ⟨162, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_162_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 2 4 7)

theorem row_162_224 : RowResult ⟨162, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_162_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_162_225 : RowResult ⟨162, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_162_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_162_226 : RowResult ⟨162, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_162_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_162_227 : RowResult ⟨162, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_162_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_162_228 : RowResult ⟨162, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_162_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_162_229 : RowResult ⟨162, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_162_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_162_230 : RowResult ⟨162, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_162_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_162_231 : RowResult ⟨162, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_162_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 2 5 7)

theorem row_162_232 : RowResult ⟨162, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_162_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_162_233 : RowResult ⟨162, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_162_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
