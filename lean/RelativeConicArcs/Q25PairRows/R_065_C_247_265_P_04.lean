import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_65_247 : RowResult ⟨65, by decide⟩ ⟨247, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_65_248 : RowResult ⟨65, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_65_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_65_249 : RowResult ⟨65, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_65_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 2 4 6)

theorem row_65_250 : RowResult ⟨65, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_65_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_65_251 : RowResult ⟨65, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_65_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_65_252 : RowResult ⟨65, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_65_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_65_253 : RowResult ⟨65, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_65_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_65_254 : RowResult ⟨65, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_65_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_65_255 : RowResult ⟨65, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_65_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_65_256 : RowResult ⟨65, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_65_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_65_257 : RowResult ⟨65, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_65_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_65_258 : RowResult ⟨65, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_65_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_65_259 : RowResult ⟨65, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_65_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_65_260 : RowResult ⟨65, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_65_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_65_261 : RowResult ⟨65, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_65_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_65_262 : RowResult ⟨65, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_65_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_65_263 : RowResult ⟨65, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_65_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_65_264 : RowResult ⟨65, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_65_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_65_265 : RowResult ⟨65, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_65_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
