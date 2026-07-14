import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_140_219 : RowResult ⟨140, by decide⟩ ⟨219, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_140_220 : RowResult ⟨140, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_140_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_140_221 : RowResult ⟨140, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_140_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_140_222 : RowResult ⟨140, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_140_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 2 4 6)

theorem row_140_223 : RowResult ⟨140, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_140_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 4 5 6)

theorem row_140_224 : RowResult ⟨140, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_140_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 2 5 6)

theorem row_140_225 : RowResult ⟨140, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_140_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_140_226 : RowResult ⟨140, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_140_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_140_227 : RowResult ⟨140, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_140_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_140_228 : RowResult ⟨140, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_140_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_140_229 : RowResult ⟨140, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_140_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_140_230 : RowResult ⟨140, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_140_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_140_231 : RowResult ⟨140, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_140_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_140_232 : RowResult ⟨140, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_140_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_140_233 : RowResult ⟨140, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_140_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_140_234 : RowResult ⟨140, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_140_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_140_235 : RowResult ⟨140, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_140_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 1 4 7)

theorem row_140_236 : RowResult ⟨140, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_140_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
