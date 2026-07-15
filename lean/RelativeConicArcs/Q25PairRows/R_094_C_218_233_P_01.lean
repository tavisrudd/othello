import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_94_218 : RowResult ⟨94, by decide⟩ ⟨218, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_94_219 : RowResult ⟨94, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_94_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 1 4 6)

theorem row_94_220 : RowResult ⟨94, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_94_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_94_221 : RowResult ⟨94, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_94_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 4 5 6)

theorem row_94_222 : RowResult ⟨94, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_94_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_94_223 : RowResult ⟨94, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_94_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_94_224 : RowResult ⟨94, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_94_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_94_225 : RowResult ⟨94, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_94_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_94_226 : RowResult ⟨94, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_94_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_94_227 : RowResult ⟨94, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_94_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_94_228 : RowResult ⟨94, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_94_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_94_229 : RowResult ⟨94, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_94_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_94_230 : RowResult ⟨94, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_94_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_94_231 : RowResult ⟨94, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_94_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_94_232 : RowResult ⟨94, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_94_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨218, by decide⟩, by decide⟩

theorem row_94_233 : RowResult ⟨94, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_94_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
