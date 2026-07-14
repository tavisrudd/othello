import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_132_216 : RowResult ⟨132, by decide⟩ ⟨216, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨167, by decide⟩, by decide⟩

theorem row_132_217 : RowResult ⟨132, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_132_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_132_218 : RowResult ⟨132, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_132_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 4 5 6)

theorem row_132_219 : RowResult ⟨132, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_132_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_132_220 : RowResult ⟨132, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_132_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_132_221 : RowResult ⟨132, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_132_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_132_222 : RowResult ⟨132, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_132_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 1 4 7)

theorem row_132_223 : RowResult ⟨132, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_132_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 2 5 6)

theorem row_132_224 : RowResult ⟨132, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_132_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_132_225 : RowResult ⟨132, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_132_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_132_226 : RowResult ⟨132, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_132_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_132_227 : RowResult ⟨132, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_132_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_132_228 : RowResult ⟨132, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_132_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_132_229 : RowResult ⟨132, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_132_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_132_230 : RowResult ⟨132, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_132_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_132_231 : RowResult ⟨132, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_132_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_132_232 : RowResult ⟨132, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_132_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
