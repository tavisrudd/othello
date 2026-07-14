import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_187_246 : RowResult ⟨187, by decide⟩ ⟨246, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_187_247 : RowResult ⟨187, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_187_246
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_187_248 : RowResult ⟨187, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_187_247
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_187_249 : RowResult ⟨187, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_187_248
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_187_250 : RowResult ⟨187, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_187_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_187_251 : RowResult ⟨187, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_187_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_187_252 : RowResult ⟨187, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_187_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_187_253 : RowResult ⟨187, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_187_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_187_254 : RowResult ⟨187, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_187_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_187_255 : RowResult ⟨187, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_187_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_187_256 : RowResult ⟨187, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_187_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_187_257 : RowResult ⟨187, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_187_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_187_258 : RowResult ⟨187, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_187_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_187_259 : RowResult ⟨187, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_187_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_187_260 : RowResult ⟨187, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_187_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_187_261 : RowResult ⟨187, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_187_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_187_262 : RowResult ⟨187, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_187_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_187_263 : RowResult ⟨187, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_187_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_187_264 : RowResult ⟨187, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_187_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_187_265 : RowResult ⟨187, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_187_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

theorem row_187_266 : RowResult ⟨187, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_187_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 6 7)

theorem row_187_267 : RowResult ⟨187, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_187_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 6 7)

theorem row_187_268 : RowResult ⟨187, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_187_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 6 7)

theorem row_187_269 : RowResult ⟨187, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_187_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 6 7)

theorem row_187_270 : RowResult ⟨187, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_187_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 6 7)

theorem row_187_271 : RowResult ⟨187, by decide⟩ ⟨271, by decide⟩ := by
  have _previous := row_187_270
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨271, by decide⟩) 0 6 7)

theorem row_187_272 : RowResult ⟨187, by decide⟩ ⟨272, by decide⟩ := by
  have _previous := row_187_271
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨272, by decide⟩) 0 6 7)

theorem row_187_273 : RowResult ⟨187, by decide⟩ ⟨273, by decide⟩ := by
  have _previous := row_187_272
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨273, by decide⟩) 0 6 7)

theorem row_187_274 : RowResult ⟨187, by decide⟩ ⟨274, by decide⟩ := by
  have _previous := row_187_273
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨274, by decide⟩) 0 6 7)

theorem row_187_275 : RowResult ⟨187, by decide⟩ ⟨275, by decide⟩ := by
  have _previous := row_187_274
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨275, by decide⟩) 0 6 7)

theorem row_187_276 : RowResult ⟨187, by decide⟩ ⟨276, by decide⟩ := by
  have _previous := row_187_275
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨276, by decide⟩) 0 6 7)

theorem row_187_277 : RowResult ⟨187, by decide⟩ ⟨277, by decide⟩ := by
  have _previous := row_187_276
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨277, by decide⟩) 0 6 7)

theorem row_187_278 : RowResult ⟨187, by decide⟩ ⟨278, by decide⟩ := by
  have _previous := row_187_277
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨278, by decide⟩) 0 6 7)

theorem row_187_279 : RowResult ⟨187, by decide⟩ ⟨279, by decide⟩ := by
  have _previous := row_187_278
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨279, by decide⟩) 0 6 7)

theorem row_187_280 : RowResult ⟨187, by decide⟩ ⟨280, by decide⟩ := by
  have _previous := row_187_279
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨280, by decide⟩) 0 6 7)

theorem row_187_281 : RowResult ⟨187, by decide⟩ ⟨281, by decide⟩ := by
  have _previous := row_187_280
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨281, by decide⟩) 0 6 7)

theorem row_187_282 : RowResult ⟨187, by decide⟩ ⟨282, by decide⟩ := by
  have _previous := row_187_281
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨282, by decide⟩) 0 6 7)

theorem row_187_283 : RowResult ⟨187, by decide⟩ ⟨283, by decide⟩ := by
  have _previous := row_187_282
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨283, by decide⟩) 0 6 7)

theorem row_187_284 : RowResult ⟨187, by decide⟩ ⟨284, by decide⟩ := by
  have _previous := row_187_283
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨284, by decide⟩) 0 6 7)

theorem row_187_285 : RowResult ⟨187, by decide⟩ ⟨285, by decide⟩ := by
  have _previous := row_187_284
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨285, by decide⟩) 0 6 7)

theorem row_187_286 : RowResult ⟨187, by decide⟩ ⟨286, by decide⟩ := by
  have _previous := row_187_285
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨286, by decide⟩) 0 6 7)

theorem row_187_287 : RowResult ⟨187, by decide⟩ ⟨287, by decide⟩ := by
  have _previous := row_187_286
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) (orbitCodeOfNumber ⟨287, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
