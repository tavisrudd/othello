import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_251_252 : RowResult ⟨251, by decide⟩ ⟨252, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 4 5)

theorem row_251_253 : RowResult ⟨251, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_251_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 4 5)

theorem row_251_254 : RowResult ⟨251, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_251_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 4 5)

theorem row_251_255 : RowResult ⟨251, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_251_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 4 5)

theorem row_251_256 : RowResult ⟨251, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_251_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 4 5)

theorem row_251_257 : RowResult ⟨251, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_251_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 4 5)

theorem row_251_258 : RowResult ⟨251, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_251_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 4 5)

theorem row_251_259 : RowResult ⟨251, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_251_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 4 5)

theorem row_251_260 : RowResult ⟨251, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_251_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 4 5)

theorem row_251_261 : RowResult ⟨251, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_251_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 4 5)

theorem row_251_262 : RowResult ⟨251, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_251_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 4 5)

theorem row_251_263 : RowResult ⟨251, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_251_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 4 5)

theorem row_251_264 : RowResult ⟨251, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_251_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 4 5)

theorem row_251_265 : RowResult ⟨251, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_251_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 4 5)

theorem row_251_266 : RowResult ⟨251, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_251_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 4 5)

theorem row_251_267 : RowResult ⟨251, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_251_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 4 5)

theorem row_251_268 : RowResult ⟨251, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_251_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 4 5)

theorem row_251_269 : RowResult ⟨251, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_251_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 4 5)

theorem row_251_270 : RowResult ⟨251, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_251_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 4 5)

theorem row_251_271 : RowResult ⟨251, by decide⟩ ⟨271, by decide⟩ := by
  have _previous := row_251_270
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨271, by decide⟩) 0 4 5)

theorem row_251_272 : RowResult ⟨251, by decide⟩ ⟨272, by decide⟩ := by
  have _previous := row_251_271
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨272, by decide⟩) 0 4 5)

theorem row_251_273 : RowResult ⟨251, by decide⟩ ⟨273, by decide⟩ := by
  have _previous := row_251_272
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨273, by decide⟩) 0 4 5)

theorem row_251_274 : RowResult ⟨251, by decide⟩ ⟨274, by decide⟩ := by
  have _previous := row_251_273
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨274, by decide⟩) 0 4 5)

theorem row_251_275 : RowResult ⟨251, by decide⟩ ⟨275, by decide⟩ := by
  have _previous := row_251_274
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨275, by decide⟩) 0 4 5)

theorem row_251_276 : RowResult ⟨251, by decide⟩ ⟨276, by decide⟩ := by
  have _previous := row_251_275
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨276, by decide⟩) 0 4 5)

theorem row_251_277 : RowResult ⟨251, by decide⟩ ⟨277, by decide⟩ := by
  have _previous := row_251_276
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨277, by decide⟩) 0 4 5)

theorem row_251_278 : RowResult ⟨251, by decide⟩ ⟨278, by decide⟩ := by
  have _previous := row_251_277
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨278, by decide⟩) 0 4 5)

theorem row_251_279 : RowResult ⟨251, by decide⟩ ⟨279, by decide⟩ := by
  have _previous := row_251_278
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨279, by decide⟩) 0 4 5)

theorem row_251_280 : RowResult ⟨251, by decide⟩ ⟨280, by decide⟩ := by
  have _previous := row_251_279
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨280, by decide⟩) 0 4 5)

theorem row_251_281 : RowResult ⟨251, by decide⟩ ⟨281, by decide⟩ := by
  have _previous := row_251_280
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨281, by decide⟩) 0 4 5)

theorem row_251_282 : RowResult ⟨251, by decide⟩ ⟨282, by decide⟩ := by
  have _previous := row_251_281
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨282, by decide⟩) 0 4 5)

theorem row_251_283 : RowResult ⟨251, by decide⟩ ⟨283, by decide⟩ := by
  have _previous := row_251_282
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨283, by decide⟩) 0 4 5)

theorem row_251_284 : RowResult ⟨251, by decide⟩ ⟨284, by decide⟩ := by
  have _previous := row_251_283
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨284, by decide⟩) 0 4 5)

theorem row_251_285 : RowResult ⟨251, by decide⟩ ⟨285, by decide⟩ := by
  have _previous := row_251_284
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨285, by decide⟩) 0 4 5)

theorem row_251_286 : RowResult ⟨251, by decide⟩ ⟨286, by decide⟩ := by
  have _previous := row_251_285
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨286, by decide⟩) 0 4 5)

theorem row_251_287 : RowResult ⟨251, by decide⟩ ⟨287, by decide⟩ := by
  have _previous := row_251_286
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨287, by decide⟩) 0 4 5)

theorem row_251_288 : RowResult ⟨251, by decide⟩ ⟨288, by decide⟩ := by
  have _previous := row_251_287
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨288, by decide⟩) 0 4 5)

theorem row_251_289 : RowResult ⟨251, by decide⟩ ⟨289, by decide⟩ := by
  have _previous := row_251_288
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) 0 4 5)

theorem row_251_290 : RowResult ⟨251, by decide⟩ ⟨290, by decide⟩ := by
  have _previous := row_251_289
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨290, by decide⟩) 0 4 5)

theorem row_251_291 : RowResult ⟨251, by decide⟩ ⟨291, by decide⟩ := by
  have _previous := row_251_290
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨291, by decide⟩) 0 4 5)

theorem row_251_292 : RowResult ⟨251, by decide⟩ ⟨292, by decide⟩ := by
  have _previous := row_251_291
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨292, by decide⟩) 0 4 5)

theorem row_251_293 : RowResult ⟨251, by decide⟩ ⟨293, by decide⟩ := by
  have _previous := row_251_292
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨293, by decide⟩) 0 4 5)

theorem row_251_294 : RowResult ⟨251, by decide⟩ ⟨294, by decide⟩ := by
  have _previous := row_251_293
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨294, by decide⟩) 0 4 5)

theorem row_251_295 : RowResult ⟨251, by decide⟩ ⟨295, by decide⟩ := by
  have _previous := row_251_294
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨295, by decide⟩) 0 4 5)

theorem row_251_296 : RowResult ⟨251, by decide⟩ ⟨296, by decide⟩ := by
  have _previous := row_251_295
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨296, by decide⟩) 0 4 5)

theorem row_251_297 : RowResult ⟨251, by decide⟩ ⟨297, by decide⟩ := by
  have _previous := row_251_296
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨297, by decide⟩) 0 4 5)

theorem row_251_298 : RowResult ⟨251, by decide⟩ ⟨298, by decide⟩ := by
  have _previous := row_251_297
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨298, by decide⟩) 0 4 5)

theorem row_251_299 : RowResult ⟨251, by decide⟩ ⟨299, by decide⟩ := by
  have _previous := row_251_298
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨299, by decide⟩) 0 4 5)

theorem row_251_300 : RowResult ⟨251, by decide⟩ ⟨300, by decide⟩ := by
  have _previous := row_251_299
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨300, by decide⟩) 0 1 6)

theorem row_251_301 : RowResult ⟨251, by decide⟩ ⟨301, by decide⟩ := by
  have _previous := row_251_300
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨301, by decide⟩) 0 1 6)

theorem row_251_302 : RowResult ⟨251, by decide⟩ ⟨302, by decide⟩ := by
  have _previous := row_251_301
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) 0 1 6)

theorem row_251_303 : RowResult ⟨251, by decide⟩ ⟨303, by decide⟩ := by
  have _previous := row_251_302
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨303, by decide⟩) 0 1 6)

theorem row_251_304 : RowResult ⟨251, by decide⟩ ⟨304, by decide⟩ := by
  have _previous := row_251_303
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨304, by decide⟩) 0 1 6)

theorem row_251_305 : RowResult ⟨251, by decide⟩ ⟨305, by decide⟩ := by
  have _previous := row_251_304
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨305, by decide⟩) 0 1 6)

theorem row_251_306 : RowResult ⟨251, by decide⟩ ⟨306, by decide⟩ := by
  have _previous := row_251_305
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨306, by decide⟩) 0 1 6)

theorem row_251_307 : RowResult ⟨251, by decide⟩ ⟨307, by decide⟩ := by
  have _previous := row_251_306
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨307, by decide⟩) 0 1 6)

theorem row_251_308 : RowResult ⟨251, by decide⟩ ⟨308, by decide⟩ := by
  have _previous := row_251_307
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨308, by decide⟩) 0 1 6)

theorem row_251_309 : RowResult ⟨251, by decide⟩ ⟨309, by decide⟩ := by
  have _previous := row_251_308
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) (orbitCodeOfNumber ⟨309, by decide⟩) 0 1 6)

end RelativeConicArcs.Q25PairCertificate
