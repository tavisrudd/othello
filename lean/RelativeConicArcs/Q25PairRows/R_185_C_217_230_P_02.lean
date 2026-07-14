import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_185_217 : RowResult ⟨185, by decide⟩ ⟨217, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_185_218 : RowResult ⟨185, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_185_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_185_219 : RowResult ⟨185, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_185_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_185_220 : RowResult ⟨185, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_185_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_185_221 : RowResult ⟨185, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_185_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_185_222 : RowResult ⟨185, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_185_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_185_223 : RowResult ⟨185, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_185_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_185_224 : RowResult ⟨185, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_185_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 2 5 7)

theorem row_185_225 : RowResult ⟨185, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_185_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_185_226 : RowResult ⟨185, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_185_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_185_227 : RowResult ⟨185, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_185_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_185_228 : RowResult ⟨185, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_185_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_185_229 : RowResult ⟨185, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_185_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_185_230 : RowResult ⟨185, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_185_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
