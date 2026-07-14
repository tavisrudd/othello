import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_84_217 : RowResult ⟨84, by decide⟩ ⟨217, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_84_218 : RowResult ⟨84, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_84_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 4 5 6)

theorem row_84_219 : RowResult ⟨84, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_84_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_84_220 : RowResult ⟨84, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_84_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_84_221 : RowResult ⟨84, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_84_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_84_222 : RowResult ⟨84, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_84_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_84_223 : RowResult ⟨84, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_84_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_84_224 : RowResult ⟨84, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_84_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 1 4 7)

theorem row_84_225 : RowResult ⟨84, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_84_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_84_226 : RowResult ⟨84, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_84_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_84_227 : RowResult ⟨84, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_84_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_84_228 : RowResult ⟨84, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_84_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_84_229 : RowResult ⟨84, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_84_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_84_230 : RowResult ⟨84, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_84_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_84_231 : RowResult ⟨84, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_84_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 2 5 7)

theorem row_84_232 : RowResult ⟨84, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_84_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_84_233 : RowResult ⟨84, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_84_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 4 5 6)

theorem row_84_234 : RowResult ⟨84, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_84_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
