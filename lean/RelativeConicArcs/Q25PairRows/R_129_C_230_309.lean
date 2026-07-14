import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_129_230 : RowResult ⟨129, by decide⟩ ⟨230, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_129_231 : RowResult ⟨129, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_129_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 1 4 5)

theorem row_129_232 : RowResult ⟨129, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_129_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 4 5)

theorem row_129_233 : RowResult ⟨129, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_129_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 1 4 5)

theorem row_129_234 : RowResult ⟨129, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_129_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 1 4 5)

theorem row_129_235 : RowResult ⟨129, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_129_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 1 4 5)

theorem row_129_236 : RowResult ⟨129, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_129_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 4 5)

theorem row_129_237 : RowResult ⟨129, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_129_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 4 5)

theorem row_129_238 : RowResult ⟨129, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_129_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 1 4 5)

theorem row_129_239 : RowResult ⟨129, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_129_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 4 5)

theorem row_129_240 : RowResult ⟨129, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_129_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 1 4 5)

theorem row_129_241 : RowResult ⟨129, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_129_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 1 4 5)

theorem row_129_242 : RowResult ⟨129, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_129_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 1 4 5)

theorem row_129_243 : RowResult ⟨129, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_129_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 1 4 5)

theorem row_129_244 : RowResult ⟨129, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_129_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 1 4 5)

theorem row_129_245 : RowResult ⟨129, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_129_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_129_246 : RowResult ⟨129, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_129_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 1 4 5)

theorem row_129_247 : RowResult ⟨129, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_129_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 1 4 5)

theorem row_129_248 : RowResult ⟨129, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_129_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 1 4 5)

theorem row_129_249 : RowResult ⟨129, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_129_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 1 4 5)

theorem row_129_250 : RowResult ⟨129, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_129_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_129_251 : RowResult ⟨129, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_129_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_129_252 : RowResult ⟨129, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_129_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_129_253 : RowResult ⟨129, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_129_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_129_254 : RowResult ⟨129, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_129_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_129_255 : RowResult ⟨129, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_129_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_129_256 : RowResult ⟨129, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_129_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_129_257 : RowResult ⟨129, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_129_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_129_258 : RowResult ⟨129, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_129_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_129_259 : RowResult ⟨129, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_129_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_129_260 : RowResult ⟨129, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_129_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_129_261 : RowResult ⟨129, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_129_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_129_262 : RowResult ⟨129, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_129_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_129_263 : RowResult ⟨129, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_129_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_129_264 : RowResult ⟨129, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_129_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_129_265 : RowResult ⟨129, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_129_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

theorem row_129_266 : RowResult ⟨129, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_129_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 6 7)

theorem row_129_267 : RowResult ⟨129, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_129_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 6 7)

theorem row_129_268 : RowResult ⟨129, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_129_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 6 7)

theorem row_129_269 : RowResult ⟨129, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_129_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 6 7)

theorem row_129_270 : RowResult ⟨129, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_129_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 6 7)

theorem row_129_271 : RowResult ⟨129, by decide⟩ ⟨271, by decide⟩ := by
  have _previous := row_129_270
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨271, by decide⟩) 0 6 7)

theorem row_129_272 : RowResult ⟨129, by decide⟩ ⟨272, by decide⟩ := by
  have _previous := row_129_271
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨272, by decide⟩) 0 6 7)

theorem row_129_273 : RowResult ⟨129, by decide⟩ ⟨273, by decide⟩ := by
  have _previous := row_129_272
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨273, by decide⟩) 0 6 7)

theorem row_129_274 : RowResult ⟨129, by decide⟩ ⟨274, by decide⟩ := by
  have _previous := row_129_273
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨274, by decide⟩) 0 6 7)

theorem row_129_275 : RowResult ⟨129, by decide⟩ ⟨275, by decide⟩ := by
  have _previous := row_129_274
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨275, by decide⟩) 0 6 7)

theorem row_129_276 : RowResult ⟨129, by decide⟩ ⟨276, by decide⟩ := by
  have _previous := row_129_275
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨276, by decide⟩) 0 6 7)

theorem row_129_277 : RowResult ⟨129, by decide⟩ ⟨277, by decide⟩ := by
  have _previous := row_129_276
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨277, by decide⟩) 0 6 7)

theorem row_129_278 : RowResult ⟨129, by decide⟩ ⟨278, by decide⟩ := by
  have _previous := row_129_277
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨278, by decide⟩) 0 6 7)

theorem row_129_279 : RowResult ⟨129, by decide⟩ ⟨279, by decide⟩ := by
  have _previous := row_129_278
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨279, by decide⟩) 0 6 7)

theorem row_129_280 : RowResult ⟨129, by decide⟩ ⟨280, by decide⟩ := by
  have _previous := row_129_279
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨280, by decide⟩) 0 6 7)

theorem row_129_281 : RowResult ⟨129, by decide⟩ ⟨281, by decide⟩ := by
  have _previous := row_129_280
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨281, by decide⟩) 0 6 7)

theorem row_129_282 : RowResult ⟨129, by decide⟩ ⟨282, by decide⟩ := by
  have _previous := row_129_281
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨282, by decide⟩) 0 6 7)

theorem row_129_283 : RowResult ⟨129, by decide⟩ ⟨283, by decide⟩ := by
  have _previous := row_129_282
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨283, by decide⟩) 0 6 7)

theorem row_129_284 : RowResult ⟨129, by decide⟩ ⟨284, by decide⟩ := by
  have _previous := row_129_283
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨284, by decide⟩) 0 6 7)

theorem row_129_285 : RowResult ⟨129, by decide⟩ ⟨285, by decide⟩ := by
  have _previous := row_129_284
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨285, by decide⟩) 0 6 7)

theorem row_129_286 : RowResult ⟨129, by decide⟩ ⟨286, by decide⟩ := by
  have _previous := row_129_285
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨286, by decide⟩) 0 6 7)

theorem row_129_287 : RowResult ⟨129, by decide⟩ ⟨287, by decide⟩ := by
  have _previous := row_129_286
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨287, by decide⟩) 0 6 7)

theorem row_129_288 : RowResult ⟨129, by decide⟩ ⟨288, by decide⟩ := by
  have _previous := row_129_287
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨288, by decide⟩) 0 6 7)

theorem row_129_289 : RowResult ⟨129, by decide⟩ ⟨289, by decide⟩ := by
  have _previous := row_129_288
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) 0 6 7)

theorem row_129_290 : RowResult ⟨129, by decide⟩ ⟨290, by decide⟩ := by
  have _previous := row_129_289
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨290, by decide⟩) 0 6 7)

theorem row_129_291 : RowResult ⟨129, by decide⟩ ⟨291, by decide⟩ := by
  have _previous := row_129_290
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨291, by decide⟩) 0 6 7)

theorem row_129_292 : RowResult ⟨129, by decide⟩ ⟨292, by decide⟩ := by
  have _previous := row_129_291
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨292, by decide⟩) 0 6 7)

theorem row_129_293 : RowResult ⟨129, by decide⟩ ⟨293, by decide⟩ := by
  have _previous := row_129_292
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨293, by decide⟩) 0 6 7)

theorem row_129_294 : RowResult ⟨129, by decide⟩ ⟨294, by decide⟩ := by
  have _previous := row_129_293
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨294, by decide⟩) 0 6 7)

theorem row_129_295 : RowResult ⟨129, by decide⟩ ⟨295, by decide⟩ := by
  have _previous := row_129_294
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨295, by decide⟩) 0 6 7)

theorem row_129_296 : RowResult ⟨129, by decide⟩ ⟨296, by decide⟩ := by
  have _previous := row_129_295
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨296, by decide⟩) 0 6 7)

theorem row_129_297 : RowResult ⟨129, by decide⟩ ⟨297, by decide⟩ := by
  have _previous := row_129_296
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨297, by decide⟩) 0 6 7)

theorem row_129_298 : RowResult ⟨129, by decide⟩ ⟨298, by decide⟩ := by
  have _previous := row_129_297
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨298, by decide⟩) 0 6 7)

theorem row_129_299 : RowResult ⟨129, by decide⟩ ⟨299, by decide⟩ := by
  have _previous := row_129_298
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨299, by decide⟩) 0 6 7)

theorem row_129_300 : RowResult ⟨129, by decide⟩ ⟨300, by decide⟩ := by
  have _previous := row_129_299
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨300, by decide⟩) 0 1 6)

theorem row_129_301 : RowResult ⟨129, by decide⟩ ⟨301, by decide⟩ := by
  have _previous := row_129_300
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨301, by decide⟩) 0 1 6)

theorem row_129_302 : RowResult ⟨129, by decide⟩ ⟨302, by decide⟩ := by
  have _previous := row_129_301
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) 0 1 6)

theorem row_129_303 : RowResult ⟨129, by decide⟩ ⟨303, by decide⟩ := by
  have _previous := row_129_302
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨303, by decide⟩) 0 1 6)

theorem row_129_304 : RowResult ⟨129, by decide⟩ ⟨304, by decide⟩ := by
  have _previous := row_129_303
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨304, by decide⟩) 0 1 6)

theorem row_129_305 : RowResult ⟨129, by decide⟩ ⟨305, by decide⟩ := by
  have _previous := row_129_304
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨305, by decide⟩) 0 1 6)

theorem row_129_306 : RowResult ⟨129, by decide⟩ ⟨306, by decide⟩ := by
  have _previous := row_129_305
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨306, by decide⟩) 0 1 6)

theorem row_129_307 : RowResult ⟨129, by decide⟩ ⟨307, by decide⟩ := by
  have _previous := row_129_306
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨307, by decide⟩) 0 1 6)

theorem row_129_308 : RowResult ⟨129, by decide⟩ ⟨308, by decide⟩ := by
  have _previous := row_129_307
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨308, by decide⟩) 0 1 6)

theorem row_129_309 : RowResult ⟨129, by decide⟩ ⟨309, by decide⟩ := by
  have _previous := row_129_308
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) (orbitCodeOfNumber ⟨309, by decide⟩) 0 1 6)

end RelativeConicArcs.Q25PairCertificate
