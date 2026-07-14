import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_25_226 : RowResult ⟨25, by decide⟩ ⟨226, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 4 5)

theorem row_25_227 : RowResult ⟨25, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_25_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 4 5)

theorem row_25_228 : RowResult ⟨25, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_25_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 4 5)

theorem row_25_229 : RowResult ⟨25, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_25_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 4 5)

theorem row_25_230 : RowResult ⟨25, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_25_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_25_231 : RowResult ⟨25, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_25_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 1 4 5)

theorem row_25_232 : RowResult ⟨25, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_25_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 4 5)

theorem row_25_233 : RowResult ⟨25, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_25_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 1 4 5)

theorem row_25_234 : RowResult ⟨25, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_25_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 1 4 5)

theorem row_25_235 : RowResult ⟨25, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_25_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 1 4 5)

theorem row_25_236 : RowResult ⟨25, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_25_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 4 5)

theorem row_25_237 : RowResult ⟨25, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_25_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 4 5)

theorem row_25_238 : RowResult ⟨25, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_25_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 1 4 5)

theorem row_25_239 : RowResult ⟨25, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_25_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 4 5)

theorem row_25_240 : RowResult ⟨25, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_25_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 1 4 5)

theorem row_25_241 : RowResult ⟨25, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_25_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 1 4 5)

theorem row_25_242 : RowResult ⟨25, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_25_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 1 4 5)

theorem row_25_243 : RowResult ⟨25, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_25_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 1 4 5)

theorem row_25_244 : RowResult ⟨25, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_25_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 1 4 5)

theorem row_25_245 : RowResult ⟨25, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_25_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_25_246 : RowResult ⟨25, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_25_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 1 4 5)

theorem row_25_247 : RowResult ⟨25, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_25_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 1 4 5)

theorem row_25_248 : RowResult ⟨25, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_25_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 1 4 5)

theorem row_25_249 : RowResult ⟨25, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_25_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 1 4 5)

theorem row_25_250 : RowResult ⟨25, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_25_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_25_251 : RowResult ⟨25, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_25_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_25_252 : RowResult ⟨25, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_25_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_25_253 : RowResult ⟨25, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_25_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_25_254 : RowResult ⟨25, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_25_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_25_255 : RowResult ⟨25, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_25_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_25_256 : RowResult ⟨25, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_25_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_25_257 : RowResult ⟨25, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_25_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_25_258 : RowResult ⟨25, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_25_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_25_259 : RowResult ⟨25, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_25_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_25_260 : RowResult ⟨25, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_25_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_25_261 : RowResult ⟨25, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_25_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_25_262 : RowResult ⟨25, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_25_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_25_263 : RowResult ⟨25, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_25_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_25_264 : RowResult ⟨25, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_25_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_25_265 : RowResult ⟨25, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_25_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

theorem row_25_266 : RowResult ⟨25, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_25_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 6 7)

theorem row_25_267 : RowResult ⟨25, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_25_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 6 7)

theorem row_25_268 : RowResult ⟨25, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_25_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 6 7)

theorem row_25_269 : RowResult ⟨25, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_25_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 6 7)

theorem row_25_270 : RowResult ⟨25, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_25_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 6 7)

theorem row_25_271 : RowResult ⟨25, by decide⟩ ⟨271, by decide⟩ := by
  have _previous := row_25_270
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨271, by decide⟩) 0 6 7)

theorem row_25_272 : RowResult ⟨25, by decide⟩ ⟨272, by decide⟩ := by
  have _previous := row_25_271
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨272, by decide⟩) 0 6 7)

theorem row_25_273 : RowResult ⟨25, by decide⟩ ⟨273, by decide⟩ := by
  have _previous := row_25_272
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨273, by decide⟩) 0 6 7)

theorem row_25_274 : RowResult ⟨25, by decide⟩ ⟨274, by decide⟩ := by
  have _previous := row_25_273
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨274, by decide⟩) 0 6 7)

theorem row_25_275 : RowResult ⟨25, by decide⟩ ⟨275, by decide⟩ := by
  have _previous := row_25_274
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨275, by decide⟩) 0 6 7)

theorem row_25_276 : RowResult ⟨25, by decide⟩ ⟨276, by decide⟩ := by
  have _previous := row_25_275
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨276, by decide⟩) 0 6 7)

theorem row_25_277 : RowResult ⟨25, by decide⟩ ⟨277, by decide⟩ := by
  have _previous := row_25_276
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨277, by decide⟩) 0 6 7)

theorem row_25_278 : RowResult ⟨25, by decide⟩ ⟨278, by decide⟩ := by
  have _previous := row_25_277
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨278, by decide⟩) 0 6 7)

theorem row_25_279 : RowResult ⟨25, by decide⟩ ⟨279, by decide⟩ := by
  have _previous := row_25_278
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨279, by decide⟩) 0 6 7)

theorem row_25_280 : RowResult ⟨25, by decide⟩ ⟨280, by decide⟩ := by
  have _previous := row_25_279
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨280, by decide⟩) 0 6 7)

theorem row_25_281 : RowResult ⟨25, by decide⟩ ⟨281, by decide⟩ := by
  have _previous := row_25_280
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨281, by decide⟩) 0 6 7)

theorem row_25_282 : RowResult ⟨25, by decide⟩ ⟨282, by decide⟩ := by
  have _previous := row_25_281
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨282, by decide⟩) 0 6 7)

theorem row_25_283 : RowResult ⟨25, by decide⟩ ⟨283, by decide⟩ := by
  have _previous := row_25_282
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨283, by decide⟩) 0 6 7)

theorem row_25_284 : RowResult ⟨25, by decide⟩ ⟨284, by decide⟩ := by
  have _previous := row_25_283
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨284, by decide⟩) 0 6 7)

theorem row_25_285 : RowResult ⟨25, by decide⟩ ⟨285, by decide⟩ := by
  have _previous := row_25_284
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨285, by decide⟩) 0 6 7)

theorem row_25_286 : RowResult ⟨25, by decide⟩ ⟨286, by decide⟩ := by
  have _previous := row_25_285
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨286, by decide⟩) 0 6 7)

theorem row_25_287 : RowResult ⟨25, by decide⟩ ⟨287, by decide⟩ := by
  have _previous := row_25_286
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨287, by decide⟩) 0 6 7)

theorem row_25_288 : RowResult ⟨25, by decide⟩ ⟨288, by decide⟩ := by
  have _previous := row_25_287
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨288, by decide⟩) 0 6 7)

theorem row_25_289 : RowResult ⟨25, by decide⟩ ⟨289, by decide⟩ := by
  have _previous := row_25_288
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) 0 6 7)

theorem row_25_290 : RowResult ⟨25, by decide⟩ ⟨290, by decide⟩ := by
  have _previous := row_25_289
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨290, by decide⟩) 0 6 7)

theorem row_25_291 : RowResult ⟨25, by decide⟩ ⟨291, by decide⟩ := by
  have _previous := row_25_290
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨291, by decide⟩) 0 6 7)

theorem row_25_292 : RowResult ⟨25, by decide⟩ ⟨292, by decide⟩ := by
  have _previous := row_25_291
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨292, by decide⟩) 0 6 7)

theorem row_25_293 : RowResult ⟨25, by decide⟩ ⟨293, by decide⟩ := by
  have _previous := row_25_292
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨293, by decide⟩) 0 6 7)

theorem row_25_294 : RowResult ⟨25, by decide⟩ ⟨294, by decide⟩ := by
  have _previous := row_25_293
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨294, by decide⟩) 0 6 7)

theorem row_25_295 : RowResult ⟨25, by decide⟩ ⟨295, by decide⟩ := by
  have _previous := row_25_294
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨295, by decide⟩) 0 6 7)

theorem row_25_296 : RowResult ⟨25, by decide⟩ ⟨296, by decide⟩ := by
  have _previous := row_25_295
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨296, by decide⟩) 0 6 7)

theorem row_25_297 : RowResult ⟨25, by decide⟩ ⟨297, by decide⟩ := by
  have _previous := row_25_296
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨297, by decide⟩) 0 6 7)

theorem row_25_298 : RowResult ⟨25, by decide⟩ ⟨298, by decide⟩ := by
  have _previous := row_25_297
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨298, by decide⟩) 0 6 7)

theorem row_25_299 : RowResult ⟨25, by decide⟩ ⟨299, by decide⟩ := by
  have _previous := row_25_298
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨299, by decide⟩) 0 6 7)

theorem row_25_300 : RowResult ⟨25, by decide⟩ ⟨300, by decide⟩ := by
  have _previous := row_25_299
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨300, by decide⟩) 0 1 6)

theorem row_25_301 : RowResult ⟨25, by decide⟩ ⟨301, by decide⟩ := by
  have _previous := row_25_300
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨301, by decide⟩) 0 1 6)

theorem row_25_302 : RowResult ⟨25, by decide⟩ ⟨302, by decide⟩ := by
  have _previous := row_25_301
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) 0 1 6)

theorem row_25_303 : RowResult ⟨25, by decide⟩ ⟨303, by decide⟩ := by
  have _previous := row_25_302
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨303, by decide⟩) 0 1 6)

theorem row_25_304 : RowResult ⟨25, by decide⟩ ⟨304, by decide⟩ := by
  have _previous := row_25_303
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨304, by decide⟩) 0 1 6)

theorem row_25_305 : RowResult ⟨25, by decide⟩ ⟨305, by decide⟩ := by
  have _previous := row_25_304
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨305, by decide⟩) 0 1 6)

theorem row_25_306 : RowResult ⟨25, by decide⟩ ⟨306, by decide⟩ := by
  have _previous := row_25_305
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨306, by decide⟩) 0 1 6)

theorem row_25_307 : RowResult ⟨25, by decide⟩ ⟨307, by decide⟩ := by
  have _previous := row_25_306
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨307, by decide⟩) 0 1 6)

theorem row_25_308 : RowResult ⟨25, by decide⟩ ⟨308, by decide⟩ := by
  have _previous := row_25_307
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨308, by decide⟩) 0 1 6)

theorem row_25_309 : RowResult ⟨25, by decide⟩ ⟨309, by decide⟩ := by
  have _previous := row_25_308
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) (orbitCodeOfNumber ⟨309, by decide⟩) 0 1 6)

end RelativeConicArcs.Q25PairCertificate
