import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_108_218 : RowResult ⟨108, by decide⟩ ⟨218, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_108_219 : RowResult ⟨108, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_108_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_108_220 : RowResult ⟨108, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_108_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_108_221 : RowResult ⟨108, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_108_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_108_222 : RowResult ⟨108, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_108_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 2 5 6)

theorem row_108_223 : RowResult ⟨108, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_108_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 1 4 7)

theorem row_108_224 : RowResult ⟨108, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_108_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_108_225 : RowResult ⟨108, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_108_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_108_226 : RowResult ⟨108, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_108_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_108_227 : RowResult ⟨108, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_108_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_108_228 : RowResult ⟨108, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_108_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_108_229 : RowResult ⟨108, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_108_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_108_230 : RowResult ⟨108, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_108_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_108_231 : RowResult ⟨108, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_108_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 2 4 7)

theorem row_108_232 : RowResult ⟨108, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_108_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_108_233 : RowResult ⟨108, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_108_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 1 4 6)

theorem row_108_234 : RowResult ⟨108, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_108_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_108_235 : RowResult ⟨108, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_108_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 4 5 6)

theorem row_108_236 : RowResult ⟨108, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_108_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
