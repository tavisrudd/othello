import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_256_257 : RowResult ⟨256, by decide⟩ ⟨257, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 4 5)

theorem row_256_258 : RowResult ⟨256, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_256_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 4 5)

theorem row_256_259 : RowResult ⟨256, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_256_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 4 5)

theorem row_256_260 : RowResult ⟨256, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_256_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 4 5)

theorem row_256_261 : RowResult ⟨256, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_256_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 4 5)

theorem row_256_262 : RowResult ⟨256, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_256_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 4 5)

theorem row_256_263 : RowResult ⟨256, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_256_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 4 5)

theorem row_256_264 : RowResult ⟨256, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_256_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 4 5)

theorem row_256_265 : RowResult ⟨256, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_256_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 4 5)

theorem row_256_266 : RowResult ⟨256, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_256_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 4 5)

theorem row_256_267 : RowResult ⟨256, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_256_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 4 5)

theorem row_256_268 : RowResult ⟨256, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_256_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 4 5)

theorem row_256_269 : RowResult ⟨256, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_256_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 4 5)

theorem row_256_270 : RowResult ⟨256, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_256_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 4 5)

theorem row_256_271 : RowResult ⟨256, by decide⟩ ⟨271, by decide⟩ := by
  have _previous := row_256_270
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨271, by decide⟩) 0 4 5)

theorem row_256_272 : RowResult ⟨256, by decide⟩ ⟨272, by decide⟩ := by
  have _previous := row_256_271
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨272, by decide⟩) 0 4 5)

theorem row_256_273 : RowResult ⟨256, by decide⟩ ⟨273, by decide⟩ := by
  have _previous := row_256_272
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨273, by decide⟩) 0 4 5)

theorem row_256_274 : RowResult ⟨256, by decide⟩ ⟨274, by decide⟩ := by
  have _previous := row_256_273
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨274, by decide⟩) 0 4 5)

theorem row_256_275 : RowResult ⟨256, by decide⟩ ⟨275, by decide⟩ := by
  have _previous := row_256_274
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨275, by decide⟩) 0 4 5)

theorem row_256_276 : RowResult ⟨256, by decide⟩ ⟨276, by decide⟩ := by
  have _previous := row_256_275
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨276, by decide⟩) 0 4 5)

theorem row_256_277 : RowResult ⟨256, by decide⟩ ⟨277, by decide⟩ := by
  have _previous := row_256_276
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨277, by decide⟩) 0 4 5)

theorem row_256_278 : RowResult ⟨256, by decide⟩ ⟨278, by decide⟩ := by
  have _previous := row_256_277
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨278, by decide⟩) 0 4 5)

theorem row_256_279 : RowResult ⟨256, by decide⟩ ⟨279, by decide⟩ := by
  have _previous := row_256_278
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨279, by decide⟩) 0 4 5)

theorem row_256_280 : RowResult ⟨256, by decide⟩ ⟨280, by decide⟩ := by
  have _previous := row_256_279
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨280, by decide⟩) 0 4 5)

theorem row_256_281 : RowResult ⟨256, by decide⟩ ⟨281, by decide⟩ := by
  have _previous := row_256_280
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨281, by decide⟩) 0 4 5)

theorem row_256_282 : RowResult ⟨256, by decide⟩ ⟨282, by decide⟩ := by
  have _previous := row_256_281
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨282, by decide⟩) 0 4 5)

theorem row_256_283 : RowResult ⟨256, by decide⟩ ⟨283, by decide⟩ := by
  have _previous := row_256_282
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨283, by decide⟩) 0 4 5)

theorem row_256_284 : RowResult ⟨256, by decide⟩ ⟨284, by decide⟩ := by
  have _previous := row_256_283
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨284, by decide⟩) 0 4 5)

theorem row_256_285 : RowResult ⟨256, by decide⟩ ⟨285, by decide⟩ := by
  have _previous := row_256_284
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨285, by decide⟩) 0 4 5)

theorem row_256_286 : RowResult ⟨256, by decide⟩ ⟨286, by decide⟩ := by
  have _previous := row_256_285
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨286, by decide⟩) 0 4 5)

theorem row_256_287 : RowResult ⟨256, by decide⟩ ⟨287, by decide⟩ := by
  have _previous := row_256_286
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨287, by decide⟩) 0 4 5)

theorem row_256_288 : RowResult ⟨256, by decide⟩ ⟨288, by decide⟩ := by
  have _previous := row_256_287
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨288, by decide⟩) 0 4 5)

theorem row_256_289 : RowResult ⟨256, by decide⟩ ⟨289, by decide⟩ := by
  have _previous := row_256_288
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) 0 4 5)

theorem row_256_290 : RowResult ⟨256, by decide⟩ ⟨290, by decide⟩ := by
  have _previous := row_256_289
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨290, by decide⟩) 0 4 5)

theorem row_256_291 : RowResult ⟨256, by decide⟩ ⟨291, by decide⟩ := by
  have _previous := row_256_290
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨291, by decide⟩) 0 4 5)

theorem row_256_292 : RowResult ⟨256, by decide⟩ ⟨292, by decide⟩ := by
  have _previous := row_256_291
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨292, by decide⟩) 0 4 5)

theorem row_256_293 : RowResult ⟨256, by decide⟩ ⟨293, by decide⟩ := by
  have _previous := row_256_292
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨293, by decide⟩) 0 4 5)

theorem row_256_294 : RowResult ⟨256, by decide⟩ ⟨294, by decide⟩ := by
  have _previous := row_256_293
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨294, by decide⟩) 0 4 5)

theorem row_256_295 : RowResult ⟨256, by decide⟩ ⟨295, by decide⟩ := by
  have _previous := row_256_294
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨295, by decide⟩) 0 4 5)

theorem row_256_296 : RowResult ⟨256, by decide⟩ ⟨296, by decide⟩ := by
  have _previous := row_256_295
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨296, by decide⟩) 0 4 5)

theorem row_256_297 : RowResult ⟨256, by decide⟩ ⟨297, by decide⟩ := by
  have _previous := row_256_296
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨297, by decide⟩) 0 4 5)

theorem row_256_298 : RowResult ⟨256, by decide⟩ ⟨298, by decide⟩ := by
  have _previous := row_256_297
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨298, by decide⟩) 0 4 5)

theorem row_256_299 : RowResult ⟨256, by decide⟩ ⟨299, by decide⟩ := by
  have _previous := row_256_298
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨299, by decide⟩) 0 4 5)

theorem row_256_300 : RowResult ⟨256, by decide⟩ ⟨300, by decide⟩ := by
  have _previous := row_256_299
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨300, by decide⟩) 0 1 6)

theorem row_256_301 : RowResult ⟨256, by decide⟩ ⟨301, by decide⟩ := by
  have _previous := row_256_300
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨301, by decide⟩) 0 1 6)

theorem row_256_302 : RowResult ⟨256, by decide⟩ ⟨302, by decide⟩ := by
  have _previous := row_256_301
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) 0 1 6)

theorem row_256_303 : RowResult ⟨256, by decide⟩ ⟨303, by decide⟩ := by
  have _previous := row_256_302
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨303, by decide⟩) 0 1 6)

theorem row_256_304 : RowResult ⟨256, by decide⟩ ⟨304, by decide⟩ := by
  have _previous := row_256_303
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨304, by decide⟩) 0 1 6)

theorem row_256_305 : RowResult ⟨256, by decide⟩ ⟨305, by decide⟩ := by
  have _previous := row_256_304
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨305, by decide⟩) 0 1 6)

theorem row_256_306 : RowResult ⟨256, by decide⟩ ⟨306, by decide⟩ := by
  have _previous := row_256_305
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨306, by decide⟩) 0 1 6)

theorem row_256_307 : RowResult ⟨256, by decide⟩ ⟨307, by decide⟩ := by
  have _previous := row_256_306
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨307, by decide⟩) 0 1 6)

theorem row_256_308 : RowResult ⟨256, by decide⟩ ⟨308, by decide⟩ := by
  have _previous := row_256_307
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨308, by decide⟩) 0 1 6)

theorem row_256_309 : RowResult ⟨256, by decide⟩ ⟨309, by decide⟩ := by
  have _previous := row_256_308
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) (orbitCodeOfNumber ⟨309, by decide⟩) 0 1 6)

end RelativeConicArcs.Q25PairCertificate
