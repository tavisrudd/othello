import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_138_214 : RowResult ⟨138, by decide⟩ ⟨214, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_138_215 : RowResult ⟨138, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_138_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 2 5 7)

theorem row_138_216 : RowResult ⟨138, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_138_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_138_217 : RowResult ⟨138, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_138_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 2 5 6)

theorem row_138_218 : RowResult ⟨138, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_138_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 1 4 7)

theorem row_138_219 : RowResult ⟨138, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_138_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_138_220 : RowResult ⟨138, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_138_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_138_221 : RowResult ⟨138, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_138_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_138_222 : RowResult ⟨138, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_138_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_138_223 : RowResult ⟨138, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_138_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 2 4 6)

theorem row_138_224 : RowResult ⟨138, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_138_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_138_225 : RowResult ⟨138, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_138_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_138_226 : RowResult ⟨138, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_138_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_138_227 : RowResult ⟨138, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_138_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_138_228 : RowResult ⟨138, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_138_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_138_229 : RowResult ⟨138, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_138_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_138_230 : RowResult ⟨138, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_138_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
