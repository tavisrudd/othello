import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_190_214 : RowResult ⟨190, by decide⟩ ⟨214, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_190_215 : RowResult ⟨190, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_190_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 1 4 6)

theorem row_190_216 : RowResult ⟨190, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_190_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_190_217 : RowResult ⟨190, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_190_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 2 4 6)

theorem row_190_218 : RowResult ⟨190, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_190_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_190_219 : RowResult ⟨190, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_190_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 2 5 6)

theorem row_190_220 : RowResult ⟨190, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_190_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_190_221 : RowResult ⟨190, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_190_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_190_222 : RowResult ⟨190, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_190_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 2 5 7)

theorem row_190_223 : RowResult ⟨190, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_190_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_190_224 : RowResult ⟨190, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_190_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 4 5 6)

theorem row_190_225 : RowResult ⟨190, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_190_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_190_226 : RowResult ⟨190, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_190_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_190_227 : RowResult ⟨190, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_190_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_190_228 : RowResult ⟨190, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_190_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_190_229 : RowResult ⟨190, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_190_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_190_230 : RowResult ⟨190, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_190_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_190_231 : RowResult ⟨190, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_190_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
