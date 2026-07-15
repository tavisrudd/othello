import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_191_215 : RowResult ⟨191, by decide⟩ ⟨215, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_191_216 : RowResult ⟨191, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_191_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 1 4 6)

theorem row_191_217 : RowResult ⟨191, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_191_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 2 5 7)

theorem row_191_218 : RowResult ⟨191, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_191_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 2 4 7)

theorem row_191_219 : RowResult ⟨191, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_191_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_191_220 : RowResult ⟨191, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_191_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_191_221 : RowResult ⟨191, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_191_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_191_222 : RowResult ⟨191, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_191_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_191_223 : RowResult ⟨191, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_191_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_191_224 : RowResult ⟨191, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_191_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_191_225 : RowResult ⟨191, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_191_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_191_226 : RowResult ⟨191, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_191_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_191_227 : RowResult ⟨191, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_191_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_191_228 : RowResult ⟨191, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_191_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_191_229 : RowResult ⟨191, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_191_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_191_230 : RowResult ⟨191, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_191_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
