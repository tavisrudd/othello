import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_137_238 : RowResult ⟨137, by decide⟩ ⟨238, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 2 3 4)

theorem row_137_239 : RowResult ⟨137, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_137_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 4)

theorem row_137_240 : RowResult ⟨137, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_137_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 2 3 4)

theorem row_137_241 : RowResult ⟨137, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_137_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 2 3 4)

theorem row_137_242 : RowResult ⟨137, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_137_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 1 4 7)

theorem row_137_243 : RowResult ⟨137, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_137_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 2 3 4)

theorem row_137_244 : RowResult ⟨137, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_137_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 2 3 4)

theorem row_137_245 : RowResult ⟨137, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_137_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_137_246 : RowResult ⟨137, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_137_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 2 3 4)

theorem row_137_247 : RowResult ⟨137, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_137_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 2 3 4)

theorem row_137_248 : RowResult ⟨137, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_137_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 2 3 4)

theorem row_137_249 : RowResult ⟨137, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_137_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 2 3 4)

theorem row_137_250 : RowResult ⟨137, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_137_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_137_251 : RowResult ⟨137, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_137_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_137_252 : RowResult ⟨137, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_137_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_137_253 : RowResult ⟨137, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_137_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_137_254 : RowResult ⟨137, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_137_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_137_255 : RowResult ⟨137, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_137_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_137_256 : RowResult ⟨137, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_137_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_137_257 : RowResult ⟨137, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_137_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_137_258 : RowResult ⟨137, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_137_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_137_259 : RowResult ⟨137, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_137_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_137_260 : RowResult ⟨137, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_137_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_137_261 : RowResult ⟨137, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_137_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_137_262 : RowResult ⟨137, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_137_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_137_263 : RowResult ⟨137, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_137_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_137_264 : RowResult ⟨137, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_137_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_137_265 : RowResult ⟨137, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_137_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

theorem row_137_266 : RowResult ⟨137, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_137_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 6 7)

theorem row_137_267 : RowResult ⟨137, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_137_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 6 7)

theorem row_137_268 : RowResult ⟨137, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_137_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 6 7)

theorem row_137_269 : RowResult ⟨137, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_137_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 6 7)

theorem row_137_270 : RowResult ⟨137, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_137_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 6 7)

theorem row_137_271 : RowResult ⟨137, by decide⟩ ⟨271, by decide⟩ := by
  have _previous := row_137_270
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨271, by decide⟩) 0 6 7)

theorem row_137_272 : RowResult ⟨137, by decide⟩ ⟨272, by decide⟩ := by
  have _previous := row_137_271
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨272, by decide⟩) 0 6 7)

theorem row_137_273 : RowResult ⟨137, by decide⟩ ⟨273, by decide⟩ := by
  have _previous := row_137_272
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨273, by decide⟩) 0 6 7)

theorem row_137_274 : RowResult ⟨137, by decide⟩ ⟨274, by decide⟩ := by
  have _previous := row_137_273
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨274, by decide⟩) 0 6 7)

theorem row_137_275 : RowResult ⟨137, by decide⟩ ⟨275, by decide⟩ := by
  have _previous := row_137_274
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨275, by decide⟩) 0 6 7)

theorem row_137_276 : RowResult ⟨137, by decide⟩ ⟨276, by decide⟩ := by
  have _previous := row_137_275
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨276, by decide⟩) 0 6 7)

theorem row_137_277 : RowResult ⟨137, by decide⟩ ⟨277, by decide⟩ := by
  have _previous := row_137_276
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨277, by decide⟩) 0 6 7)

theorem row_137_278 : RowResult ⟨137, by decide⟩ ⟨278, by decide⟩ := by
  have _previous := row_137_277
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨278, by decide⟩) 0 6 7)

theorem row_137_279 : RowResult ⟨137, by decide⟩ ⟨279, by decide⟩ := by
  have _previous := row_137_278
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨279, by decide⟩) 0 6 7)

theorem row_137_280 : RowResult ⟨137, by decide⟩ ⟨280, by decide⟩ := by
  have _previous := row_137_279
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨280, by decide⟩) 0 6 7)

theorem row_137_281 : RowResult ⟨137, by decide⟩ ⟨281, by decide⟩ := by
  have _previous := row_137_280
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨281, by decide⟩) 0 6 7)

theorem row_137_282 : RowResult ⟨137, by decide⟩ ⟨282, by decide⟩ := by
  have _previous := row_137_281
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨282, by decide⟩) 0 6 7)

theorem row_137_283 : RowResult ⟨137, by decide⟩ ⟨283, by decide⟩ := by
  have _previous := row_137_282
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨283, by decide⟩) 0 6 7)

theorem row_137_284 : RowResult ⟨137, by decide⟩ ⟨284, by decide⟩ := by
  have _previous := row_137_283
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨284, by decide⟩) 0 6 7)

theorem row_137_285 : RowResult ⟨137, by decide⟩ ⟨285, by decide⟩ := by
  have _previous := row_137_284
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨285, by decide⟩) 0 6 7)

theorem row_137_286 : RowResult ⟨137, by decide⟩ ⟨286, by decide⟩ := by
  have _previous := row_137_285
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨286, by decide⟩) 0 6 7)

theorem row_137_287 : RowResult ⟨137, by decide⟩ ⟨287, by decide⟩ := by
  have _previous := row_137_286
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨287, by decide⟩) 0 6 7)

theorem row_137_288 : RowResult ⟨137, by decide⟩ ⟨288, by decide⟩ := by
  have _previous := row_137_287
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨288, by decide⟩) 0 6 7)

theorem row_137_289 : RowResult ⟨137, by decide⟩ ⟨289, by decide⟩ := by
  have _previous := row_137_288
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) 0 6 7)

theorem row_137_290 : RowResult ⟨137, by decide⟩ ⟨290, by decide⟩ := by
  have _previous := row_137_289
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨290, by decide⟩) 0 6 7)

theorem row_137_291 : RowResult ⟨137, by decide⟩ ⟨291, by decide⟩ := by
  have _previous := row_137_290
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨291, by decide⟩) 0 6 7)

theorem row_137_292 : RowResult ⟨137, by decide⟩ ⟨292, by decide⟩ := by
  have _previous := row_137_291
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨292, by decide⟩) 0 6 7)

theorem row_137_293 : RowResult ⟨137, by decide⟩ ⟨293, by decide⟩ := by
  have _previous := row_137_292
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨293, by decide⟩) 0 6 7)

theorem row_137_294 : RowResult ⟨137, by decide⟩ ⟨294, by decide⟩ := by
  have _previous := row_137_293
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨294, by decide⟩) 0 6 7)

theorem row_137_295 : RowResult ⟨137, by decide⟩ ⟨295, by decide⟩ := by
  have _previous := row_137_294
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨295, by decide⟩) 0 6 7)

theorem row_137_296 : RowResult ⟨137, by decide⟩ ⟨296, by decide⟩ := by
  have _previous := row_137_295
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨296, by decide⟩) 0 6 7)

theorem row_137_297 : RowResult ⟨137, by decide⟩ ⟨297, by decide⟩ := by
  have _previous := row_137_296
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨297, by decide⟩) 0 6 7)

theorem row_137_298 : RowResult ⟨137, by decide⟩ ⟨298, by decide⟩ := by
  have _previous := row_137_297
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨298, by decide⟩) 0 6 7)

theorem row_137_299 : RowResult ⟨137, by decide⟩ ⟨299, by decide⟩ := by
  have _previous := row_137_298
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨299, by decide⟩) 0 6 7)

theorem row_137_300 : RowResult ⟨137, by decide⟩ ⟨300, by decide⟩ := by
  have _previous := row_137_299
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨300, by decide⟩) 0 1 6)

theorem row_137_301 : RowResult ⟨137, by decide⟩ ⟨301, by decide⟩ := by
  have _previous := row_137_300
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨301, by decide⟩) 0 1 6)

theorem row_137_302 : RowResult ⟨137, by decide⟩ ⟨302, by decide⟩ := by
  have _previous := row_137_301
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) 0 1 6)

theorem row_137_303 : RowResult ⟨137, by decide⟩ ⟨303, by decide⟩ := by
  have _previous := row_137_302
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨303, by decide⟩) 0 1 6)

theorem row_137_304 : RowResult ⟨137, by decide⟩ ⟨304, by decide⟩ := by
  have _previous := row_137_303
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨304, by decide⟩) 0 1 6)

theorem row_137_305 : RowResult ⟨137, by decide⟩ ⟨305, by decide⟩ := by
  have _previous := row_137_304
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨305, by decide⟩) 0 1 6)

theorem row_137_306 : RowResult ⟨137, by decide⟩ ⟨306, by decide⟩ := by
  have _previous := row_137_305
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨306, by decide⟩) 0 1 6)

theorem row_137_307 : RowResult ⟨137, by decide⟩ ⟨307, by decide⟩ := by
  have _previous := row_137_306
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨307, by decide⟩) 0 1 6)

theorem row_137_308 : RowResult ⟨137, by decide⟩ ⟨308, by decide⟩ := by
  have _previous := row_137_307
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨308, by decide⟩) 0 1 6)

theorem row_137_309 : RowResult ⟨137, by decide⟩ ⟨309, by decide⟩ := by
  have _previous := row_137_308
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨309, by decide⟩) 0 1 6)

end RelativeConicArcs.Q25PairCertificate
