import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_20_221 : RowResult ⟨20, by decide⟩ ⟨221, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 0 2 4)

theorem row_20_222 : RowResult ⟨20, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_20_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 0 2 4)

theorem row_20_223 : RowResult ⟨20, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_20_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 0 2 4)

theorem row_20_224 : RowResult ⟨20, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_20_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 0 2 4)

theorem row_20_225 : RowResult ⟨20, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_20_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 0 2 4)

theorem row_20_226 : RowResult ⟨20, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_20_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 0 2 4)

theorem row_20_227 : RowResult ⟨20, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_20_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 0 2 4)

theorem row_20_228 : RowResult ⟨20, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_20_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 0 2 4)

theorem row_20_229 : RowResult ⟨20, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_20_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 0 2 4)

theorem row_20_230 : RowResult ⟨20, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_20_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 0 2 4)

theorem row_20_231 : RowResult ⟨20, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_20_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 0 2 4)

theorem row_20_232 : RowResult ⟨20, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_20_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 0 2 4)

theorem row_20_233 : RowResult ⟨20, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_20_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 0 2 4)

theorem row_20_234 : RowResult ⟨20, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_20_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 0 2 4)

theorem row_20_235 : RowResult ⟨20, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_20_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 0 2 4)

theorem row_20_236 : RowResult ⟨20, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_20_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 0 2 4)

theorem row_20_237 : RowResult ⟨20, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_20_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 0 2 4)

theorem row_20_238 : RowResult ⟨20, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_20_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 0 2 4)

theorem row_20_239 : RowResult ⟨20, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_20_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 0 2 4)

theorem row_20_240 : RowResult ⟨20, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_20_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 0 2 4)

theorem row_20_241 : RowResult ⟨20, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_20_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 0 2 4)

theorem row_20_242 : RowResult ⟨20, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_20_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 0 2 4)

theorem row_20_243 : RowResult ⟨20, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_20_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 0 2 4)

theorem row_20_244 : RowResult ⟨20, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_20_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 0 2 4)

theorem row_20_245 : RowResult ⟨20, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_20_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 0 2 4)

theorem row_20_246 : RowResult ⟨20, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_20_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 0 2 4)

theorem row_20_247 : RowResult ⟨20, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_20_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 0 2 4)

theorem row_20_248 : RowResult ⟨20, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_20_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 0 2 4)

theorem row_20_249 : RowResult ⟨20, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_20_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 0 2 4)

theorem row_20_250 : RowResult ⟨20, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_20_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 2 4)

theorem row_20_251 : RowResult ⟨20, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_20_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 2 4)

theorem row_20_252 : RowResult ⟨20, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_20_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 2 4)

theorem row_20_253 : RowResult ⟨20, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_20_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 2 4)

theorem row_20_254 : RowResult ⟨20, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_20_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 2 4)

theorem row_20_255 : RowResult ⟨20, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_20_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 2 4)

theorem row_20_256 : RowResult ⟨20, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_20_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 2 4)

theorem row_20_257 : RowResult ⟨20, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_20_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 2 4)

theorem row_20_258 : RowResult ⟨20, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_20_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 2 4)

theorem row_20_259 : RowResult ⟨20, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_20_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 2 4)

theorem row_20_260 : RowResult ⟨20, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_20_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 2 4)

theorem row_20_261 : RowResult ⟨20, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_20_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 2 4)

theorem row_20_262 : RowResult ⟨20, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_20_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 2 4)

theorem row_20_263 : RowResult ⟨20, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_20_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 2 4)

theorem row_20_264 : RowResult ⟨20, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_20_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 2 4)

theorem row_20_265 : RowResult ⟨20, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_20_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 2 4)

theorem row_20_266 : RowResult ⟨20, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_20_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 2 4)

theorem row_20_267 : RowResult ⟨20, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_20_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 2 4)

theorem row_20_268 : RowResult ⟨20, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_20_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 2 4)

theorem row_20_269 : RowResult ⟨20, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_20_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 2 4)

theorem row_20_270 : RowResult ⟨20, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_20_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 2 4)

theorem row_20_271 : RowResult ⟨20, by decide⟩ ⟨271, by decide⟩ := by
  have _previous := row_20_270
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨271, by decide⟩) 0 2 4)

theorem row_20_272 : RowResult ⟨20, by decide⟩ ⟨272, by decide⟩ := by
  have _previous := row_20_271
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨272, by decide⟩) 0 2 4)

theorem row_20_273 : RowResult ⟨20, by decide⟩ ⟨273, by decide⟩ := by
  have _previous := row_20_272
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨273, by decide⟩) 0 2 4)

theorem row_20_274 : RowResult ⟨20, by decide⟩ ⟨274, by decide⟩ := by
  have _previous := row_20_273
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨274, by decide⟩) 0 2 4)

theorem row_20_275 : RowResult ⟨20, by decide⟩ ⟨275, by decide⟩ := by
  have _previous := row_20_274
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨275, by decide⟩) 0 2 4)

theorem row_20_276 : RowResult ⟨20, by decide⟩ ⟨276, by decide⟩ := by
  have _previous := row_20_275
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨276, by decide⟩) 0 2 4)

theorem row_20_277 : RowResult ⟨20, by decide⟩ ⟨277, by decide⟩ := by
  have _previous := row_20_276
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨277, by decide⟩) 0 2 4)

theorem row_20_278 : RowResult ⟨20, by decide⟩ ⟨278, by decide⟩ := by
  have _previous := row_20_277
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨278, by decide⟩) 0 2 4)

theorem row_20_279 : RowResult ⟨20, by decide⟩ ⟨279, by decide⟩ := by
  have _previous := row_20_278
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨279, by decide⟩) 0 2 4)

theorem row_20_280 : RowResult ⟨20, by decide⟩ ⟨280, by decide⟩ := by
  have _previous := row_20_279
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨280, by decide⟩) 0 2 4)

theorem row_20_281 : RowResult ⟨20, by decide⟩ ⟨281, by decide⟩ := by
  have _previous := row_20_280
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨281, by decide⟩) 0 2 4)

theorem row_20_282 : RowResult ⟨20, by decide⟩ ⟨282, by decide⟩ := by
  have _previous := row_20_281
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨282, by decide⟩) 0 2 4)

theorem row_20_283 : RowResult ⟨20, by decide⟩ ⟨283, by decide⟩ := by
  have _previous := row_20_282
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨283, by decide⟩) 0 2 4)

theorem row_20_284 : RowResult ⟨20, by decide⟩ ⟨284, by decide⟩ := by
  have _previous := row_20_283
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨284, by decide⟩) 0 2 4)

theorem row_20_285 : RowResult ⟨20, by decide⟩ ⟨285, by decide⟩ := by
  have _previous := row_20_284
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨285, by decide⟩) 0 2 4)

theorem row_20_286 : RowResult ⟨20, by decide⟩ ⟨286, by decide⟩ := by
  have _previous := row_20_285
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨286, by decide⟩) 0 2 4)

theorem row_20_287 : RowResult ⟨20, by decide⟩ ⟨287, by decide⟩ := by
  have _previous := row_20_286
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨287, by decide⟩) 0 2 4)

theorem row_20_288 : RowResult ⟨20, by decide⟩ ⟨288, by decide⟩ := by
  have _previous := row_20_287
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨288, by decide⟩) 0 2 4)

theorem row_20_289 : RowResult ⟨20, by decide⟩ ⟨289, by decide⟩ := by
  have _previous := row_20_288
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) 0 2 4)

theorem row_20_290 : RowResult ⟨20, by decide⟩ ⟨290, by decide⟩ := by
  have _previous := row_20_289
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨290, by decide⟩) 0 2 4)

theorem row_20_291 : RowResult ⟨20, by decide⟩ ⟨291, by decide⟩ := by
  have _previous := row_20_290
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨291, by decide⟩) 0 2 4)

theorem row_20_292 : RowResult ⟨20, by decide⟩ ⟨292, by decide⟩ := by
  have _previous := row_20_291
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨292, by decide⟩) 0 2 4)

theorem row_20_293 : RowResult ⟨20, by decide⟩ ⟨293, by decide⟩ := by
  have _previous := row_20_292
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨293, by decide⟩) 0 2 4)

theorem row_20_294 : RowResult ⟨20, by decide⟩ ⟨294, by decide⟩ := by
  have _previous := row_20_293
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨294, by decide⟩) 0 2 4)

theorem row_20_295 : RowResult ⟨20, by decide⟩ ⟨295, by decide⟩ := by
  have _previous := row_20_294
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨295, by decide⟩) 0 2 4)

theorem row_20_296 : RowResult ⟨20, by decide⟩ ⟨296, by decide⟩ := by
  have _previous := row_20_295
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨296, by decide⟩) 0 2 4)

theorem row_20_297 : RowResult ⟨20, by decide⟩ ⟨297, by decide⟩ := by
  have _previous := row_20_296
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨297, by decide⟩) 0 2 4)

theorem row_20_298 : RowResult ⟨20, by decide⟩ ⟨298, by decide⟩ := by
  have _previous := row_20_297
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨298, by decide⟩) 0 2 4)

theorem row_20_299 : RowResult ⟨20, by decide⟩ ⟨299, by decide⟩ := by
  have _previous := row_20_298
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨299, by decide⟩) 0 2 4)

theorem row_20_300 : RowResult ⟨20, by decide⟩ ⟨300, by decide⟩ := by
  have _previous := row_20_299
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨300, by decide⟩) 0 1 6)

theorem row_20_301 : RowResult ⟨20, by decide⟩ ⟨301, by decide⟩ := by
  have _previous := row_20_300
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨301, by decide⟩) 0 1 6)

theorem row_20_302 : RowResult ⟨20, by decide⟩ ⟨302, by decide⟩ := by
  have _previous := row_20_301
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) 0 1 6)

theorem row_20_303 : RowResult ⟨20, by decide⟩ ⟨303, by decide⟩ := by
  have _previous := row_20_302
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨303, by decide⟩) 0 1 6)

theorem row_20_304 : RowResult ⟨20, by decide⟩ ⟨304, by decide⟩ := by
  have _previous := row_20_303
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨304, by decide⟩) 0 1 6)

theorem row_20_305 : RowResult ⟨20, by decide⟩ ⟨305, by decide⟩ := by
  have _previous := row_20_304
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨305, by decide⟩) 0 1 6)

theorem row_20_306 : RowResult ⟨20, by decide⟩ ⟨306, by decide⟩ := by
  have _previous := row_20_305
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨306, by decide⟩) 0 1 6)

theorem row_20_307 : RowResult ⟨20, by decide⟩ ⟨307, by decide⟩ := by
  have _previous := row_20_306
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨307, by decide⟩) 0 1 6)

theorem row_20_308 : RowResult ⟨20, by decide⟩ ⟨308, by decide⟩ := by
  have _previous := row_20_307
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨308, by decide⟩) 0 1 6)

theorem row_20_309 : RowResult ⟨20, by decide⟩ ⟨309, by decide⟩ := by
  have _previous := row_20_308
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨309, by decide⟩) 0 1 6)

end RelativeConicArcs.Q25PairCertificate
