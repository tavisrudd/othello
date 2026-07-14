import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_225_226 : RowResult ⟨225, by decide⟩ ⟨226, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 0 4 6)

theorem row_225_227 : RowResult ⟨225, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_225_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 0 4 6)

theorem row_225_228 : RowResult ⟨225, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_225_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 0 4 6)

theorem row_225_229 : RowResult ⟨225, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_225_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 0 4 6)

theorem row_225_230 : RowResult ⟨225, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_225_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 0 4 6)

theorem row_225_231 : RowResult ⟨225, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_225_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 0 4 6)

theorem row_225_232 : RowResult ⟨225, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_225_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 0 4 6)

theorem row_225_233 : RowResult ⟨225, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_225_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 0 4 6)

theorem row_225_234 : RowResult ⟨225, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_225_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 0 4 6)

theorem row_225_235 : RowResult ⟨225, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_225_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 0 4 6)

theorem row_225_236 : RowResult ⟨225, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_225_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 0 4 6)

theorem row_225_237 : RowResult ⟨225, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_225_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 0 4 6)

theorem row_225_238 : RowResult ⟨225, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_225_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 0 4 6)

theorem row_225_239 : RowResult ⟨225, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_225_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 0 4 6)

theorem row_225_240 : RowResult ⟨225, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_225_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 0 4 6)

theorem row_225_241 : RowResult ⟨225, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_225_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 0 4 6)

theorem row_225_242 : RowResult ⟨225, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_225_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 0 4 6)

theorem row_225_243 : RowResult ⟨225, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_225_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 0 4 6)

theorem row_225_244 : RowResult ⟨225, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_225_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 0 4 6)

theorem row_225_245 : RowResult ⟨225, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_225_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 0 4 6)

theorem row_225_246 : RowResult ⟨225, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_225_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 0 4 6)

theorem row_225_247 : RowResult ⟨225, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_225_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 0 4 6)

theorem row_225_248 : RowResult ⟨225, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_225_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 0 4 6)

theorem row_225_249 : RowResult ⟨225, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_225_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 0 4 6)

theorem row_225_250 : RowResult ⟨225, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_225_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_225_251 : RowResult ⟨225, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_225_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_225_252 : RowResult ⟨225, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_225_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_225_253 : RowResult ⟨225, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_225_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_225_254 : RowResult ⟨225, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_225_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_225_255 : RowResult ⟨225, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_225_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_225_256 : RowResult ⟨225, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_225_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_225_257 : RowResult ⟨225, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_225_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_225_258 : RowResult ⟨225, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_225_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_225_259 : RowResult ⟨225, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_225_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_225_260 : RowResult ⟨225, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_225_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_225_261 : RowResult ⟨225, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_225_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_225_262 : RowResult ⟨225, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_225_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_225_263 : RowResult ⟨225, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_225_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_225_264 : RowResult ⟨225, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_225_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_225_265 : RowResult ⟨225, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_225_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

theorem row_225_266 : RowResult ⟨225, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_225_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 6 7)

theorem row_225_267 : RowResult ⟨225, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_225_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 6 7)

theorem row_225_268 : RowResult ⟨225, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_225_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 6 7)

theorem row_225_269 : RowResult ⟨225, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_225_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 6 7)

theorem row_225_270 : RowResult ⟨225, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_225_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 6 7)

theorem row_225_271 : RowResult ⟨225, by decide⟩ ⟨271, by decide⟩ := by
  have _previous := row_225_270
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨271, by decide⟩) 0 6 7)

theorem row_225_272 : RowResult ⟨225, by decide⟩ ⟨272, by decide⟩ := by
  have _previous := row_225_271
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨272, by decide⟩) 0 6 7)

theorem row_225_273 : RowResult ⟨225, by decide⟩ ⟨273, by decide⟩ := by
  have _previous := row_225_272
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨273, by decide⟩) 0 6 7)

theorem row_225_274 : RowResult ⟨225, by decide⟩ ⟨274, by decide⟩ := by
  have _previous := row_225_273
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨274, by decide⟩) 0 6 7)

theorem row_225_275 : RowResult ⟨225, by decide⟩ ⟨275, by decide⟩ := by
  have _previous := row_225_274
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨275, by decide⟩) 0 6 7)

theorem row_225_276 : RowResult ⟨225, by decide⟩ ⟨276, by decide⟩ := by
  have _previous := row_225_275
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨276, by decide⟩) 0 6 7)

theorem row_225_277 : RowResult ⟨225, by decide⟩ ⟨277, by decide⟩ := by
  have _previous := row_225_276
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨277, by decide⟩) 0 6 7)

theorem row_225_278 : RowResult ⟨225, by decide⟩ ⟨278, by decide⟩ := by
  have _previous := row_225_277
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨278, by decide⟩) 0 6 7)

theorem row_225_279 : RowResult ⟨225, by decide⟩ ⟨279, by decide⟩ := by
  have _previous := row_225_278
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨279, by decide⟩) 0 6 7)

theorem row_225_280 : RowResult ⟨225, by decide⟩ ⟨280, by decide⟩ := by
  have _previous := row_225_279
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨280, by decide⟩) 0 6 7)

theorem row_225_281 : RowResult ⟨225, by decide⟩ ⟨281, by decide⟩ := by
  have _previous := row_225_280
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨281, by decide⟩) 0 6 7)

theorem row_225_282 : RowResult ⟨225, by decide⟩ ⟨282, by decide⟩ := by
  have _previous := row_225_281
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨282, by decide⟩) 0 6 7)

theorem row_225_283 : RowResult ⟨225, by decide⟩ ⟨283, by decide⟩ := by
  have _previous := row_225_282
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨283, by decide⟩) 0 6 7)

theorem row_225_284 : RowResult ⟨225, by decide⟩ ⟨284, by decide⟩ := by
  have _previous := row_225_283
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨284, by decide⟩) 0 6 7)

theorem row_225_285 : RowResult ⟨225, by decide⟩ ⟨285, by decide⟩ := by
  have _previous := row_225_284
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨285, by decide⟩) 0 6 7)

theorem row_225_286 : RowResult ⟨225, by decide⟩ ⟨286, by decide⟩ := by
  have _previous := row_225_285
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨286, by decide⟩) 0 6 7)

theorem row_225_287 : RowResult ⟨225, by decide⟩ ⟨287, by decide⟩ := by
  have _previous := row_225_286
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨287, by decide⟩) 0 6 7)

theorem row_225_288 : RowResult ⟨225, by decide⟩ ⟨288, by decide⟩ := by
  have _previous := row_225_287
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨288, by decide⟩) 0 6 7)

theorem row_225_289 : RowResult ⟨225, by decide⟩ ⟨289, by decide⟩ := by
  have _previous := row_225_288
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) 0 6 7)

theorem row_225_290 : RowResult ⟨225, by decide⟩ ⟨290, by decide⟩ := by
  have _previous := row_225_289
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨290, by decide⟩) 0 6 7)

theorem row_225_291 : RowResult ⟨225, by decide⟩ ⟨291, by decide⟩ := by
  have _previous := row_225_290
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨291, by decide⟩) 0 6 7)

theorem row_225_292 : RowResult ⟨225, by decide⟩ ⟨292, by decide⟩ := by
  have _previous := row_225_291
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨292, by decide⟩) 0 6 7)

theorem row_225_293 : RowResult ⟨225, by decide⟩ ⟨293, by decide⟩ := by
  have _previous := row_225_292
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨293, by decide⟩) 0 6 7)

theorem row_225_294 : RowResult ⟨225, by decide⟩ ⟨294, by decide⟩ := by
  have _previous := row_225_293
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨294, by decide⟩) 0 6 7)

theorem row_225_295 : RowResult ⟨225, by decide⟩ ⟨295, by decide⟩ := by
  have _previous := row_225_294
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨295, by decide⟩) 0 6 7)

theorem row_225_296 : RowResult ⟨225, by decide⟩ ⟨296, by decide⟩ := by
  have _previous := row_225_295
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨296, by decide⟩) 0 6 7)

theorem row_225_297 : RowResult ⟨225, by decide⟩ ⟨297, by decide⟩ := by
  have _previous := row_225_296
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨297, by decide⟩) 0 6 7)

theorem row_225_298 : RowResult ⟨225, by decide⟩ ⟨298, by decide⟩ := by
  have _previous := row_225_297
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨298, by decide⟩) 0 6 7)

theorem row_225_299 : RowResult ⟨225, by decide⟩ ⟨299, by decide⟩ := by
  have _previous := row_225_298
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨299, by decide⟩) 0 6 7)

theorem row_225_300 : RowResult ⟨225, by decide⟩ ⟨300, by decide⟩ := by
  have _previous := row_225_299
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨300, by decide⟩) 0 1 6)

theorem row_225_301 : RowResult ⟨225, by decide⟩ ⟨301, by decide⟩ := by
  have _previous := row_225_300
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨301, by decide⟩) 0 1 6)

theorem row_225_302 : RowResult ⟨225, by decide⟩ ⟨302, by decide⟩ := by
  have _previous := row_225_301
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) 0 1 6)

theorem row_225_303 : RowResult ⟨225, by decide⟩ ⟨303, by decide⟩ := by
  have _previous := row_225_302
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨303, by decide⟩) 0 1 6)

theorem row_225_304 : RowResult ⟨225, by decide⟩ ⟨304, by decide⟩ := by
  have _previous := row_225_303
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨304, by decide⟩) 0 1 6)

theorem row_225_305 : RowResult ⟨225, by decide⟩ ⟨305, by decide⟩ := by
  have _previous := row_225_304
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨305, by decide⟩) 0 1 6)

theorem row_225_306 : RowResult ⟨225, by decide⟩ ⟨306, by decide⟩ := by
  have _previous := row_225_305
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨306, by decide⟩) 0 1 6)

theorem row_225_307 : RowResult ⟨225, by decide⟩ ⟨307, by decide⟩ := by
  have _previous := row_225_306
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨307, by decide⟩) 0 1 6)

theorem row_225_308 : RowResult ⟨225, by decide⟩ ⟨308, by decide⟩ := by
  have _previous := row_225_307
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨308, by decide⟩) 0 1 6)

theorem row_225_309 : RowResult ⟨225, by decide⟩ ⟨309, by decide⟩ := by
  have _previous := row_225_308
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) (orbitCodeOfNumber ⟨309, by decide⟩) 0 1 6)

end RelativeConicArcs.Q25PairCertificate
