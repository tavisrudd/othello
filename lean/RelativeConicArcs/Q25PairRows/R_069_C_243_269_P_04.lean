import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_69_243 : RowResult ⟨69, by decide⟩ ⟨243, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_69_244 : RowResult ⟨69, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_69_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 1 4 6)

theorem row_69_245 : RowResult ⟨69, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_69_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_69_246 : RowResult ⟨69, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_69_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_69_247 : RowResult ⟨69, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_69_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨41, by decide⟩,
    orbitCodeOfNumber ⟨215, by decide⟩, by decide⟩

theorem row_69_248 : RowResult ⟨69, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_69_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨215, by decide⟩, by decide⟩

theorem row_69_249 : RowResult ⟨69, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_69_248
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨217, by decide⟩, by decide⟩

theorem row_69_250 : RowResult ⟨69, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_69_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_69_251 : RowResult ⟨69, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_69_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_69_252 : RowResult ⟨69, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_69_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_69_253 : RowResult ⟨69, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_69_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_69_254 : RowResult ⟨69, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_69_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_69_255 : RowResult ⟨69, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_69_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_69_256 : RowResult ⟨69, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_69_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_69_257 : RowResult ⟨69, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_69_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_69_258 : RowResult ⟨69, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_69_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_69_259 : RowResult ⟨69, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_69_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_69_260 : RowResult ⟨69, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_69_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_69_261 : RowResult ⟨69, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_69_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_69_262 : RowResult ⟨69, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_69_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_69_263 : RowResult ⟨69, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_69_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_69_264 : RowResult ⟨69, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_69_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_69_265 : RowResult ⟨69, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_69_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

theorem row_69_266 : RowResult ⟨69, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_69_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 6 7)

theorem row_69_267 : RowResult ⟨69, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_69_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 6 7)

theorem row_69_268 : RowResult ⟨69, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_69_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 6 7)

theorem row_69_269 : RowResult ⟨69, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_69_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
