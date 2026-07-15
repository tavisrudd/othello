import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_31_217 : RowResult ⟨31, by decide⟩ ⟨217, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_31_218 : RowResult ⟨31, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_31_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 4 5 6)

theorem row_31_219 : RowResult ⟨31, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_31_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_31_220 : RowResult ⟨31, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_31_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_31_221 : RowResult ⟨31, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_31_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 1 4 7)

theorem row_31_222 : RowResult ⟨31, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_31_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_31_223 : RowResult ⟨31, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_31_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_31_224 : RowResult ⟨31, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_31_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_31_225 : RowResult ⟨31, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_31_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_31_226 : RowResult ⟨31, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_31_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_31_227 : RowResult ⟨31, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_31_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_31_228 : RowResult ⟨31, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_31_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_31_229 : RowResult ⟨31, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_31_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_31_230 : RowResult ⟨31, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_31_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_31_231 : RowResult ⟨31, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_31_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
