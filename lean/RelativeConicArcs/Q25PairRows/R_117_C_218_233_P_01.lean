import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_117_218 : RowResult ⟨117, by decide⟩ ⟨218, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 4 5 6)

theorem row_117_219 : RowResult ⟨117, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_117_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_117_220 : RowResult ⟨117, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_117_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_117_221 : RowResult ⟨117, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_117_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_117_222 : RowResult ⟨117, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_117_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_117_223 : RowResult ⟨117, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_117_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_117_224 : RowResult ⟨117, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_117_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_117_225 : RowResult ⟨117, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_117_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_117_226 : RowResult ⟨117, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_117_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_117_227 : RowResult ⟨117, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_117_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_117_228 : RowResult ⟨117, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_117_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_117_229 : RowResult ⟨117, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_117_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_117_230 : RowResult ⟨117, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_117_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_117_231 : RowResult ⟨117, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_117_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 2 4 6)

theorem row_117_232 : RowResult ⟨117, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_117_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_117_233 : RowResult ⟨117, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_117_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
