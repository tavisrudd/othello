import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_172_216 : RowResult ⟨172, by decide⟩ ⟨216, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_172_217 : RowResult ⟨172, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_172_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 2 4 7)

theorem row_172_218 : RowResult ⟨172, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_172_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_172_219 : RowResult ⟨172, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_172_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_172_220 : RowResult ⟨172, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_172_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_172_221 : RowResult ⟨172, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_172_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 4 5 6)

theorem row_172_222 : RowResult ⟨172, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_172_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 1 4 6)

theorem row_172_223 : RowResult ⟨172, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_172_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_172_224 : RowResult ⟨172, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_172_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_172_225 : RowResult ⟨172, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_172_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_172_226 : RowResult ⟨172, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_172_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_172_227 : RowResult ⟨172, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_172_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_172_228 : RowResult ⟨172, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_172_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_172_229 : RowResult ⟨172, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_172_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_172_230 : RowResult ⟨172, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_172_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_172_231 : RowResult ⟨172, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_172_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_172_232 : RowResult ⟨172, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_172_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
