import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false
set_option linter.unusedVariables false

theorem row_73_243 : RowResult ⟨73, by decide⟩ ⟨243, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_73_244 : RowResult ⟨73, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_73_243
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_73_245 : RowResult ⟨73, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_73_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_73_246 : RowResult ⟨73, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_73_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_73_247 : RowResult ⟨73, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_73_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 2 5 7)

theorem row_73_248 : RowResult ⟨73, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_73_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 1 4 6)

theorem row_73_249 : RowResult ⟨73, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_73_248
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_73_250 : RowResult ⟨73, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_73_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_73_251 : RowResult ⟨73, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_73_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_73_252 : RowResult ⟨73, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_73_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_73_253 : RowResult ⟨73, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_73_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_73_254 : RowResult ⟨73, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_73_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_73_255 : RowResult ⟨73, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_73_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_73_256 : RowResult ⟨73, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_73_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_73_257 : RowResult ⟨73, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_73_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_73_258 : RowResult ⟨73, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_73_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_73_259 : RowResult ⟨73, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_73_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_73_260 : RowResult ⟨73, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_73_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_73_261 : RowResult ⟨73, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_73_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_73_262 : RowResult ⟨73, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_73_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_73_263 : RowResult ⟨73, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_73_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_73_264 : RowResult ⟨73, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_73_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_73_265 : RowResult ⟨73, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_73_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

theorem row_73_266 : RowResult ⟨73, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_73_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 6 7)

theorem row_73_267 : RowResult ⟨73, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_73_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 6 7)

theorem row_73_268 : RowResult ⟨73, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_73_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 6 7)

theorem row_73_269 : RowResult ⟨73, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_73_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 6 7)

theorem row_73_270 : RowResult ⟨73, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_73_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 6 7)

theorem row_73_271 : RowResult ⟨73, by decide⟩ ⟨271, by decide⟩ := by
  have _previous := row_73_270
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨271, by decide⟩) 0 6 7)

theorem row_73_272 : RowResult ⟨73, by decide⟩ ⟨272, by decide⟩ := by
  have _previous := row_73_271
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨272, by decide⟩) 0 6 7)

theorem row_73_273 : RowResult ⟨73, by decide⟩ ⟨273, by decide⟩ := by
  have _previous := row_73_272
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨273, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
