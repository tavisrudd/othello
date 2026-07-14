import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_233_234 : RowResult ⟨233, by decide⟩ ⟨234, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 0 4 6)

theorem row_233_235 : RowResult ⟨233, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_233_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 0 4 6)

theorem row_233_236 : RowResult ⟨233, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_233_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 0 4 6)

theorem row_233_237 : RowResult ⟨233, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_233_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 0 4 6)

theorem row_233_238 : RowResult ⟨233, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_233_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 0 4 6)

theorem row_233_239 : RowResult ⟨233, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_233_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 0 4 6)

theorem row_233_240 : RowResult ⟨233, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_233_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 0 4 6)

theorem row_233_241 : RowResult ⟨233, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_233_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 0 4 6)

theorem row_233_242 : RowResult ⟨233, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_233_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 0 4 6)

theorem row_233_243 : RowResult ⟨233, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_233_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 0 4 6)

theorem row_233_244 : RowResult ⟨233, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_233_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 0 4 6)

theorem row_233_245 : RowResult ⟨233, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_233_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 0 4 6)

theorem row_233_246 : RowResult ⟨233, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_233_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 0 4 6)

theorem row_233_247 : RowResult ⟨233, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_233_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 0 4 6)

theorem row_233_248 : RowResult ⟨233, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_233_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 0 4 6)

theorem row_233_249 : RowResult ⟨233, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_233_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 0 4 6)

theorem row_233_250 : RowResult ⟨233, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_233_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_233_251 : RowResult ⟨233, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_233_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_233_252 : RowResult ⟨233, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_233_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_233_253 : RowResult ⟨233, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_233_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_233_254 : RowResult ⟨233, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_233_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_233_255 : RowResult ⟨233, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_233_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_233_256 : RowResult ⟨233, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_233_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_233_257 : RowResult ⟨233, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_233_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_233_258 : RowResult ⟨233, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_233_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_233_259 : RowResult ⟨233, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_233_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_233_260 : RowResult ⟨233, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_233_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_233_261 : RowResult ⟨233, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_233_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_233_262 : RowResult ⟨233, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_233_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_233_263 : RowResult ⟨233, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_233_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_233_264 : RowResult ⟨233, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_233_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_233_265 : RowResult ⟨233, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_233_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

theorem row_233_266 : RowResult ⟨233, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_233_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 6 7)

theorem row_233_267 : RowResult ⟨233, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_233_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 6 7)

theorem row_233_268 : RowResult ⟨233, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_233_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 6 7)

theorem row_233_269 : RowResult ⟨233, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_233_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 6 7)

theorem row_233_270 : RowResult ⟨233, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_233_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 6 7)

theorem row_233_271 : RowResult ⟨233, by decide⟩ ⟨271, by decide⟩ := by
  have _previous := row_233_270
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨271, by decide⟩) 0 6 7)

theorem row_233_272 : RowResult ⟨233, by decide⟩ ⟨272, by decide⟩ := by
  have _previous := row_233_271
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨272, by decide⟩) 0 6 7)

theorem row_233_273 : RowResult ⟨233, by decide⟩ ⟨273, by decide⟩ := by
  have _previous := row_233_272
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨273, by decide⟩) 0 6 7)

theorem row_233_274 : RowResult ⟨233, by decide⟩ ⟨274, by decide⟩ := by
  have _previous := row_233_273
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨274, by decide⟩) 0 6 7)

theorem row_233_275 : RowResult ⟨233, by decide⟩ ⟨275, by decide⟩ := by
  have _previous := row_233_274
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨275, by decide⟩) 0 6 7)

theorem row_233_276 : RowResult ⟨233, by decide⟩ ⟨276, by decide⟩ := by
  have _previous := row_233_275
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨276, by decide⟩) 0 6 7)

theorem row_233_277 : RowResult ⟨233, by decide⟩ ⟨277, by decide⟩ := by
  have _previous := row_233_276
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨277, by decide⟩) 0 6 7)

theorem row_233_278 : RowResult ⟨233, by decide⟩ ⟨278, by decide⟩ := by
  have _previous := row_233_277
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨278, by decide⟩) 0 6 7)

theorem row_233_279 : RowResult ⟨233, by decide⟩ ⟨279, by decide⟩ := by
  have _previous := row_233_278
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨279, by decide⟩) 0 6 7)

theorem row_233_280 : RowResult ⟨233, by decide⟩ ⟨280, by decide⟩ := by
  have _previous := row_233_279
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨280, by decide⟩) 0 6 7)

theorem row_233_281 : RowResult ⟨233, by decide⟩ ⟨281, by decide⟩ := by
  have _previous := row_233_280
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨281, by decide⟩) 0 6 7)

theorem row_233_282 : RowResult ⟨233, by decide⟩ ⟨282, by decide⟩ := by
  have _previous := row_233_281
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨282, by decide⟩) 0 6 7)

theorem row_233_283 : RowResult ⟨233, by decide⟩ ⟨283, by decide⟩ := by
  have _previous := row_233_282
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨283, by decide⟩) 0 6 7)

theorem row_233_284 : RowResult ⟨233, by decide⟩ ⟨284, by decide⟩ := by
  have _previous := row_233_283
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨284, by decide⟩) 0 6 7)

theorem row_233_285 : RowResult ⟨233, by decide⟩ ⟨285, by decide⟩ := by
  have _previous := row_233_284
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨285, by decide⟩) 0 6 7)

theorem row_233_286 : RowResult ⟨233, by decide⟩ ⟨286, by decide⟩ := by
  have _previous := row_233_285
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨286, by decide⟩) 0 6 7)

theorem row_233_287 : RowResult ⟨233, by decide⟩ ⟨287, by decide⟩ := by
  have _previous := row_233_286
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨287, by decide⟩) 0 6 7)

theorem row_233_288 : RowResult ⟨233, by decide⟩ ⟨288, by decide⟩ := by
  have _previous := row_233_287
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨288, by decide⟩) 0 6 7)

theorem row_233_289 : RowResult ⟨233, by decide⟩ ⟨289, by decide⟩ := by
  have _previous := row_233_288
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) 0 6 7)

theorem row_233_290 : RowResult ⟨233, by decide⟩ ⟨290, by decide⟩ := by
  have _previous := row_233_289
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨290, by decide⟩) 0 6 7)

theorem row_233_291 : RowResult ⟨233, by decide⟩ ⟨291, by decide⟩ := by
  have _previous := row_233_290
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨291, by decide⟩) 0 6 7)

theorem row_233_292 : RowResult ⟨233, by decide⟩ ⟨292, by decide⟩ := by
  have _previous := row_233_291
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨292, by decide⟩) 0 6 7)

theorem row_233_293 : RowResult ⟨233, by decide⟩ ⟨293, by decide⟩ := by
  have _previous := row_233_292
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨293, by decide⟩) 0 6 7)

theorem row_233_294 : RowResult ⟨233, by decide⟩ ⟨294, by decide⟩ := by
  have _previous := row_233_293
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨294, by decide⟩) 0 6 7)

theorem row_233_295 : RowResult ⟨233, by decide⟩ ⟨295, by decide⟩ := by
  have _previous := row_233_294
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨295, by decide⟩) 0 6 7)

theorem row_233_296 : RowResult ⟨233, by decide⟩ ⟨296, by decide⟩ := by
  have _previous := row_233_295
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨296, by decide⟩) 0 6 7)

theorem row_233_297 : RowResult ⟨233, by decide⟩ ⟨297, by decide⟩ := by
  have _previous := row_233_296
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨297, by decide⟩) 0 6 7)

theorem row_233_298 : RowResult ⟨233, by decide⟩ ⟨298, by decide⟩ := by
  have _previous := row_233_297
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨298, by decide⟩) 0 6 7)

theorem row_233_299 : RowResult ⟨233, by decide⟩ ⟨299, by decide⟩ := by
  have _previous := row_233_298
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨299, by decide⟩) 0 6 7)

theorem row_233_300 : RowResult ⟨233, by decide⟩ ⟨300, by decide⟩ := by
  have _previous := row_233_299
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨300, by decide⟩) 0 1 6)

theorem row_233_301 : RowResult ⟨233, by decide⟩ ⟨301, by decide⟩ := by
  have _previous := row_233_300
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨301, by decide⟩) 0 1 6)

theorem row_233_302 : RowResult ⟨233, by decide⟩ ⟨302, by decide⟩ := by
  have _previous := row_233_301
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) 0 1 6)

theorem row_233_303 : RowResult ⟨233, by decide⟩ ⟨303, by decide⟩ := by
  have _previous := row_233_302
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨303, by decide⟩) 0 1 6)

theorem row_233_304 : RowResult ⟨233, by decide⟩ ⟨304, by decide⟩ := by
  have _previous := row_233_303
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨304, by decide⟩) 0 1 6)

theorem row_233_305 : RowResult ⟨233, by decide⟩ ⟨305, by decide⟩ := by
  have _previous := row_233_304
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨305, by decide⟩) 0 1 6)

theorem row_233_306 : RowResult ⟨233, by decide⟩ ⟨306, by decide⟩ := by
  have _previous := row_233_305
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨306, by decide⟩) 0 1 6)

theorem row_233_307 : RowResult ⟨233, by decide⟩ ⟨307, by decide⟩ := by
  have _previous := row_233_306
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨307, by decide⟩) 0 1 6)

theorem row_233_308 : RowResult ⟨233, by decide⟩ ⟨308, by decide⟩ := by
  have _previous := row_233_307
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨308, by decide⟩) 0 1 6)

theorem row_233_309 : RowResult ⟨233, by decide⟩ ⟨309, by decide⟩ := by
  have _previous := row_233_308
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) (orbitCodeOfNumber ⟨309, by decide⟩) 0 1 6)

end RelativeConicArcs.Q25PairCertificate
