import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_165_246 : RowResult ⟨165, by decide⟩ ⟨246, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_165_247 : RowResult ⟨165, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_165_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_165_248 : RowResult ⟨165, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_165_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 2 5 7)

theorem row_165_249 : RowResult ⟨165, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_165_248
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨223, by decide⟩, by decide⟩

theorem row_165_250 : RowResult ⟨165, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_165_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_165_251 : RowResult ⟨165, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_165_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_165_252 : RowResult ⟨165, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_165_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_165_253 : RowResult ⟨165, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_165_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_165_254 : RowResult ⟨165, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_165_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_165_255 : RowResult ⟨165, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_165_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_165_256 : RowResult ⟨165, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_165_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_165_257 : RowResult ⟨165, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_165_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_165_258 : RowResult ⟨165, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_165_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_165_259 : RowResult ⟨165, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_165_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_165_260 : RowResult ⟨165, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_165_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_165_261 : RowResult ⟨165, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_165_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_165_262 : RowResult ⟨165, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_165_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_165_263 : RowResult ⟨165, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_165_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_165_264 : RowResult ⟨165, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_165_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_165_265 : RowResult ⟨165, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_165_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
