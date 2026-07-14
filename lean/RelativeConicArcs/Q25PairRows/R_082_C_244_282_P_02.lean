import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_82_244 : RowResult ⟨82, by decide⟩ ⟨244, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_82_245 : RowResult ⟨82, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_82_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_82_246 : RowResult ⟨82, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_82_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_82_247 : RowResult ⟨82, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_82_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 1 4 7)

theorem row_82_248 : RowResult ⟨82, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_82_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_82_249 : RowResult ⟨82, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_82_248
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_82_250 : RowResult ⟨82, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_82_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_82_251 : RowResult ⟨82, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_82_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_82_252 : RowResult ⟨82, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_82_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_82_253 : RowResult ⟨82, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_82_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_82_254 : RowResult ⟨82, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_82_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_82_255 : RowResult ⟨82, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_82_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_82_256 : RowResult ⟨82, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_82_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_82_257 : RowResult ⟨82, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_82_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_82_258 : RowResult ⟨82, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_82_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_82_259 : RowResult ⟨82, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_82_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_82_260 : RowResult ⟨82, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_82_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_82_261 : RowResult ⟨82, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_82_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_82_262 : RowResult ⟨82, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_82_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_82_263 : RowResult ⟨82, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_82_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_82_264 : RowResult ⟨82, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_82_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_82_265 : RowResult ⟨82, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_82_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

theorem row_82_266 : RowResult ⟨82, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_82_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 6 7)

theorem row_82_267 : RowResult ⟨82, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_82_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 6 7)

theorem row_82_268 : RowResult ⟨82, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_82_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 6 7)

theorem row_82_269 : RowResult ⟨82, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_82_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 6 7)

theorem row_82_270 : RowResult ⟨82, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_82_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 6 7)

theorem row_82_271 : RowResult ⟨82, by decide⟩ ⟨271, by decide⟩ := by
  have _previous := row_82_270
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨271, by decide⟩) 0 6 7)

theorem row_82_272 : RowResult ⟨82, by decide⟩ ⟨272, by decide⟩ := by
  have _previous := row_82_271
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨272, by decide⟩) 0 6 7)

theorem row_82_273 : RowResult ⟨82, by decide⟩ ⟨273, by decide⟩ := by
  have _previous := row_82_272
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨273, by decide⟩) 0 6 7)

theorem row_82_274 : RowResult ⟨82, by decide⟩ ⟨274, by decide⟩ := by
  have _previous := row_82_273
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨274, by decide⟩) 0 6 7)

theorem row_82_275 : RowResult ⟨82, by decide⟩ ⟨275, by decide⟩ := by
  have _previous := row_82_274
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨275, by decide⟩) 0 6 7)

theorem row_82_276 : RowResult ⟨82, by decide⟩ ⟨276, by decide⟩ := by
  have _previous := row_82_275
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨276, by decide⟩) 0 6 7)

theorem row_82_277 : RowResult ⟨82, by decide⟩ ⟨277, by decide⟩ := by
  have _previous := row_82_276
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨277, by decide⟩) 0 6 7)

theorem row_82_278 : RowResult ⟨82, by decide⟩ ⟨278, by decide⟩ := by
  have _previous := row_82_277
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨278, by decide⟩) 0 6 7)

theorem row_82_279 : RowResult ⟨82, by decide⟩ ⟨279, by decide⟩ := by
  have _previous := row_82_278
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨279, by decide⟩) 0 6 7)

theorem row_82_280 : RowResult ⟨82, by decide⟩ ⟨280, by decide⟩ := by
  have _previous := row_82_279
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨280, by decide⟩) 0 6 7)

theorem row_82_281 : RowResult ⟨82, by decide⟩ ⟨281, by decide⟩ := by
  have _previous := row_82_280
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨281, by decide⟩) 0 6 7)

theorem row_82_282 : RowResult ⟨82, by decide⟩ ⟨282, by decide⟩ := by
  have _previous := row_82_281
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) (orbitCodeOfNumber ⟨282, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
