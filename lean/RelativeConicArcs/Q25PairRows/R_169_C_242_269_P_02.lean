import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_169_242 : RowResult ⟨169, by decide⟩ ⟨242, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_169_243 : RowResult ⟨169, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_169_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 2 5 7)

theorem row_169_244 : RowResult ⟨169, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_169_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 1 4 6)

theorem row_169_245 : RowResult ⟨169, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_169_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_169_246 : RowResult ⟨169, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_169_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_169_247 : RowResult ⟨169, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_169_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_169_248 : RowResult ⟨169, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_169_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_169_249 : RowResult ⟨169, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_169_248
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_169_250 : RowResult ⟨169, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_169_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_169_251 : RowResult ⟨169, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_169_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_169_252 : RowResult ⟨169, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_169_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_169_253 : RowResult ⟨169, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_169_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_169_254 : RowResult ⟨169, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_169_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_169_255 : RowResult ⟨169, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_169_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_169_256 : RowResult ⟨169, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_169_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_169_257 : RowResult ⟨169, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_169_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_169_258 : RowResult ⟨169, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_169_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_169_259 : RowResult ⟨169, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_169_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_169_260 : RowResult ⟨169, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_169_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_169_261 : RowResult ⟨169, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_169_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_169_262 : RowResult ⟨169, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_169_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_169_263 : RowResult ⟨169, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_169_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_169_264 : RowResult ⟨169, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_169_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_169_265 : RowResult ⟨169, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_169_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

theorem row_169_266 : RowResult ⟨169, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_169_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 6 7)

theorem row_169_267 : RowResult ⟨169, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_169_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 6 7)

theorem row_169_268 : RowResult ⟨169, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_169_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 6 7)

theorem row_169_269 : RowResult ⟨169, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_169_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
