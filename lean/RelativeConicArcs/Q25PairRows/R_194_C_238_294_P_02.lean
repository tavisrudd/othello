import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_194_238 : RowResult ⟨194, by decide⟩ ⟨238, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_194_239 : RowResult ⟨194, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_194_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 4 7)

theorem row_194_240 : RowResult ⟨194, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_194_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_194_241 : RowResult ⟨194, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_194_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_194_242 : RowResult ⟨194, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_194_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 2 5 7)

theorem row_194_243 : RowResult ⟨194, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_194_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 4 5 6)

theorem row_194_244 : RowResult ⟨194, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_194_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 1 4 6)

theorem row_194_245 : RowResult ⟨194, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_194_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_194_246 : RowResult ⟨194, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_194_245
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_194_247 : RowResult ⟨194, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_194_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 2 5 6)

theorem row_194_248 : RowResult ⟨194, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_194_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 2 4 6)

theorem row_194_249 : RowResult ⟨194, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_194_248
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨216, by decide⟩, by decide⟩

theorem row_194_250 : RowResult ⟨194, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_194_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_194_251 : RowResult ⟨194, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_194_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_194_252 : RowResult ⟨194, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_194_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_194_253 : RowResult ⟨194, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_194_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_194_254 : RowResult ⟨194, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_194_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_194_255 : RowResult ⟨194, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_194_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_194_256 : RowResult ⟨194, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_194_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_194_257 : RowResult ⟨194, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_194_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_194_258 : RowResult ⟨194, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_194_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_194_259 : RowResult ⟨194, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_194_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_194_260 : RowResult ⟨194, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_194_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_194_261 : RowResult ⟨194, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_194_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_194_262 : RowResult ⟨194, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_194_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_194_263 : RowResult ⟨194, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_194_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_194_264 : RowResult ⟨194, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_194_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_194_265 : RowResult ⟨194, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_194_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

theorem row_194_266 : RowResult ⟨194, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_194_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 6 7)

theorem row_194_267 : RowResult ⟨194, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_194_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 6 7)

theorem row_194_268 : RowResult ⟨194, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_194_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 6 7)

theorem row_194_269 : RowResult ⟨194, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_194_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 6 7)

theorem row_194_270 : RowResult ⟨194, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_194_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 6 7)

theorem row_194_271 : RowResult ⟨194, by decide⟩ ⟨271, by decide⟩ := by
  have _previous := row_194_270
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨271, by decide⟩) 0 6 7)

theorem row_194_272 : RowResult ⟨194, by decide⟩ ⟨272, by decide⟩ := by
  have _previous := row_194_271
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨272, by decide⟩) 0 6 7)

theorem row_194_273 : RowResult ⟨194, by decide⟩ ⟨273, by decide⟩ := by
  have _previous := row_194_272
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨273, by decide⟩) 0 6 7)

theorem row_194_274 : RowResult ⟨194, by decide⟩ ⟨274, by decide⟩ := by
  have _previous := row_194_273
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨274, by decide⟩) 0 6 7)

theorem row_194_275 : RowResult ⟨194, by decide⟩ ⟨275, by decide⟩ := by
  have _previous := row_194_274
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨275, by decide⟩) 0 6 7)

theorem row_194_276 : RowResult ⟨194, by decide⟩ ⟨276, by decide⟩ := by
  have _previous := row_194_275
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨276, by decide⟩) 0 6 7)

theorem row_194_277 : RowResult ⟨194, by decide⟩ ⟨277, by decide⟩ := by
  have _previous := row_194_276
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨277, by decide⟩) 0 6 7)

theorem row_194_278 : RowResult ⟨194, by decide⟩ ⟨278, by decide⟩ := by
  have _previous := row_194_277
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨278, by decide⟩) 0 6 7)

theorem row_194_279 : RowResult ⟨194, by decide⟩ ⟨279, by decide⟩ := by
  have _previous := row_194_278
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨279, by decide⟩) 0 6 7)

theorem row_194_280 : RowResult ⟨194, by decide⟩ ⟨280, by decide⟩ := by
  have _previous := row_194_279
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨280, by decide⟩) 0 6 7)

theorem row_194_281 : RowResult ⟨194, by decide⟩ ⟨281, by decide⟩ := by
  have _previous := row_194_280
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨281, by decide⟩) 0 6 7)

theorem row_194_282 : RowResult ⟨194, by decide⟩ ⟨282, by decide⟩ := by
  have _previous := row_194_281
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨282, by decide⟩) 0 6 7)

theorem row_194_283 : RowResult ⟨194, by decide⟩ ⟨283, by decide⟩ := by
  have _previous := row_194_282
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨283, by decide⟩) 0 6 7)

theorem row_194_284 : RowResult ⟨194, by decide⟩ ⟨284, by decide⟩ := by
  have _previous := row_194_283
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨284, by decide⟩) 0 6 7)

theorem row_194_285 : RowResult ⟨194, by decide⟩ ⟨285, by decide⟩ := by
  have _previous := row_194_284
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨285, by decide⟩) 0 6 7)

theorem row_194_286 : RowResult ⟨194, by decide⟩ ⟨286, by decide⟩ := by
  have _previous := row_194_285
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨286, by decide⟩) 0 6 7)

theorem row_194_287 : RowResult ⟨194, by decide⟩ ⟨287, by decide⟩ := by
  have _previous := row_194_286
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨287, by decide⟩) 0 6 7)

theorem row_194_288 : RowResult ⟨194, by decide⟩ ⟨288, by decide⟩ := by
  have _previous := row_194_287
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨288, by decide⟩) 0 6 7)

theorem row_194_289 : RowResult ⟨194, by decide⟩ ⟨289, by decide⟩ := by
  have _previous := row_194_288
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) 0 6 7)

theorem row_194_290 : RowResult ⟨194, by decide⟩ ⟨290, by decide⟩ := by
  have _previous := row_194_289
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨290, by decide⟩) 0 6 7)

theorem row_194_291 : RowResult ⟨194, by decide⟩ ⟨291, by decide⟩ := by
  have _previous := row_194_290
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨291, by decide⟩) 0 6 7)

theorem row_194_292 : RowResult ⟨194, by decide⟩ ⟨292, by decide⟩ := by
  have _previous := row_194_291
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨292, by decide⟩) 0 6 7)

theorem row_194_293 : RowResult ⟨194, by decide⟩ ⟨293, by decide⟩ := by
  have _previous := row_194_292
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨293, by decide⟩) 0 6 7)

theorem row_194_294 : RowResult ⟨194, by decide⟩ ⟨294, by decide⟩ := by
  have _previous := row_194_293
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) (orbitCodeOfNumber ⟨294, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
