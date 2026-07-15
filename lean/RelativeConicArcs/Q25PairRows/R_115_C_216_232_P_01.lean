import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_115_216 : RowResult ⟨115, by decide⟩ ⟨216, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 4 5 6)

theorem row_115_217 : RowResult ⟨115, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_115_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_115_218 : RowResult ⟨115, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_115_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_115_219 : RowResult ⟨115, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_115_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_115_220 : RowResult ⟨115, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_115_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_115_221 : RowResult ⟨115, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_115_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 2 5 6)

theorem row_115_222 : RowResult ⟨115, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_115_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_115_223 : RowResult ⟨115, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_115_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 2 5 7)

theorem row_115_224 : RowResult ⟨115, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_115_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_115_225 : RowResult ⟨115, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_115_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_115_226 : RowResult ⟨115, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_115_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_115_227 : RowResult ⟨115, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_115_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_115_228 : RowResult ⟨115, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_115_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_115_229 : RowResult ⟨115, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_115_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_115_230 : RowResult ⟨115, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_115_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_115_231 : RowResult ⟨115, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_115_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 4 5 6)

theorem row_115_232 : RowResult ⟨115, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_115_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
