import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_11_212 : RowResult ⟨11, by decide⟩ ⟨212, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 0 2 4)

theorem row_11_213 : RowResult ⟨11, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_11_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 0 2 4)

theorem row_11_214 : RowResult ⟨11, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_11_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 0 2 4)

theorem row_11_215 : RowResult ⟨11, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_11_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 0 2 4)

theorem row_11_216 : RowResult ⟨11, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_11_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 0 2 4)

theorem row_11_217 : RowResult ⟨11, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_11_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 0 2 4)

theorem row_11_218 : RowResult ⟨11, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_11_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 0 2 4)

theorem row_11_219 : RowResult ⟨11, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_11_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 0 2 4)

theorem row_11_220 : RowResult ⟨11, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_11_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 0 2 4)

theorem row_11_221 : RowResult ⟨11, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_11_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 0 2 4)

theorem row_11_222 : RowResult ⟨11, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_11_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 0 2 4)

theorem row_11_223 : RowResult ⟨11, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_11_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 0 2 4)

theorem row_11_224 : RowResult ⟨11, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_11_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 0 2 4)

theorem row_11_225 : RowResult ⟨11, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_11_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 0 2 4)

theorem row_11_226 : RowResult ⟨11, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_11_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 0 2 4)

theorem row_11_227 : RowResult ⟨11, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_11_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 0 2 4)

theorem row_11_228 : RowResult ⟨11, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_11_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 0 2 4)

theorem row_11_229 : RowResult ⟨11, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_11_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 0 2 4)

theorem row_11_230 : RowResult ⟨11, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_11_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 0 2 4)

theorem row_11_231 : RowResult ⟨11, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_11_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 0 2 4)

theorem row_11_232 : RowResult ⟨11, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_11_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 0 2 4)

theorem row_11_233 : RowResult ⟨11, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_11_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 0 2 4)

theorem row_11_234 : RowResult ⟨11, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_11_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 0 2 4)

theorem row_11_235 : RowResult ⟨11, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_11_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 0 2 4)

theorem row_11_236 : RowResult ⟨11, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_11_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 0 2 4)

theorem row_11_237 : RowResult ⟨11, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_11_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 0 2 4)

theorem row_11_238 : RowResult ⟨11, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_11_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 0 2 4)

theorem row_11_239 : RowResult ⟨11, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_11_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 0 2 4)

theorem row_11_240 : RowResult ⟨11, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_11_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 0 2 4)

theorem row_11_241 : RowResult ⟨11, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_11_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 0 2 4)

theorem row_11_242 : RowResult ⟨11, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_11_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 0 2 4)

theorem row_11_243 : RowResult ⟨11, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_11_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 0 2 4)

theorem row_11_244 : RowResult ⟨11, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_11_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 0 2 4)

theorem row_11_245 : RowResult ⟨11, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_11_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 0 2 4)

theorem row_11_246 : RowResult ⟨11, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_11_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 0 2 4)

theorem row_11_247 : RowResult ⟨11, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_11_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 0 2 4)

theorem row_11_248 : RowResult ⟨11, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_11_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 0 2 4)

theorem row_11_249 : RowResult ⟨11, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_11_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 0 2 4)

theorem row_11_250 : RowResult ⟨11, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_11_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 2 4)

theorem row_11_251 : RowResult ⟨11, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_11_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 2 4)

theorem row_11_252 : RowResult ⟨11, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_11_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 2 4)

theorem row_11_253 : RowResult ⟨11, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_11_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 2 4)

theorem row_11_254 : RowResult ⟨11, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_11_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 2 4)

theorem row_11_255 : RowResult ⟨11, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_11_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 2 4)

theorem row_11_256 : RowResult ⟨11, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_11_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 2 4)

theorem row_11_257 : RowResult ⟨11, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_11_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 2 4)

theorem row_11_258 : RowResult ⟨11, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_11_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 2 4)

theorem row_11_259 : RowResult ⟨11, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_11_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 2 4)

theorem row_11_260 : RowResult ⟨11, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_11_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 2 4)

theorem row_11_261 : RowResult ⟨11, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_11_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 2 4)

theorem row_11_262 : RowResult ⟨11, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_11_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 2 4)

theorem row_11_263 : RowResult ⟨11, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_11_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 2 4)

theorem row_11_264 : RowResult ⟨11, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_11_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 2 4)

theorem row_11_265 : RowResult ⟨11, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_11_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 2 4)

theorem row_11_266 : RowResult ⟨11, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_11_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 2 4)

theorem row_11_267 : RowResult ⟨11, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_11_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 2 4)

theorem row_11_268 : RowResult ⟨11, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_11_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 2 4)

theorem row_11_269 : RowResult ⟨11, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_11_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 2 4)

theorem row_11_270 : RowResult ⟨11, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_11_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 2 4)

theorem row_11_271 : RowResult ⟨11, by decide⟩ ⟨271, by decide⟩ := by
  have _previous := row_11_270
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨271, by decide⟩) 0 2 4)

theorem row_11_272 : RowResult ⟨11, by decide⟩ ⟨272, by decide⟩ := by
  have _previous := row_11_271
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨272, by decide⟩) 0 2 4)

theorem row_11_273 : RowResult ⟨11, by decide⟩ ⟨273, by decide⟩ := by
  have _previous := row_11_272
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨273, by decide⟩) 0 2 4)

theorem row_11_274 : RowResult ⟨11, by decide⟩ ⟨274, by decide⟩ := by
  have _previous := row_11_273
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨274, by decide⟩) 0 2 4)

theorem row_11_275 : RowResult ⟨11, by decide⟩ ⟨275, by decide⟩ := by
  have _previous := row_11_274
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨275, by decide⟩) 0 2 4)

theorem row_11_276 : RowResult ⟨11, by decide⟩ ⟨276, by decide⟩ := by
  have _previous := row_11_275
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨276, by decide⟩) 0 2 4)

theorem row_11_277 : RowResult ⟨11, by decide⟩ ⟨277, by decide⟩ := by
  have _previous := row_11_276
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨277, by decide⟩) 0 2 4)

theorem row_11_278 : RowResult ⟨11, by decide⟩ ⟨278, by decide⟩ := by
  have _previous := row_11_277
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨278, by decide⟩) 0 2 4)

theorem row_11_279 : RowResult ⟨11, by decide⟩ ⟨279, by decide⟩ := by
  have _previous := row_11_278
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨279, by decide⟩) 0 2 4)

theorem row_11_280 : RowResult ⟨11, by decide⟩ ⟨280, by decide⟩ := by
  have _previous := row_11_279
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨280, by decide⟩) 0 2 4)

theorem row_11_281 : RowResult ⟨11, by decide⟩ ⟨281, by decide⟩ := by
  have _previous := row_11_280
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨281, by decide⟩) 0 2 4)

theorem row_11_282 : RowResult ⟨11, by decide⟩ ⟨282, by decide⟩ := by
  have _previous := row_11_281
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨282, by decide⟩) 0 2 4)

theorem row_11_283 : RowResult ⟨11, by decide⟩ ⟨283, by decide⟩ := by
  have _previous := row_11_282
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨283, by decide⟩) 0 2 4)

theorem row_11_284 : RowResult ⟨11, by decide⟩ ⟨284, by decide⟩ := by
  have _previous := row_11_283
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨284, by decide⟩) 0 2 4)

theorem row_11_285 : RowResult ⟨11, by decide⟩ ⟨285, by decide⟩ := by
  have _previous := row_11_284
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨285, by decide⟩) 0 2 4)

theorem row_11_286 : RowResult ⟨11, by decide⟩ ⟨286, by decide⟩ := by
  have _previous := row_11_285
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨286, by decide⟩) 0 2 4)

theorem row_11_287 : RowResult ⟨11, by decide⟩ ⟨287, by decide⟩ := by
  have _previous := row_11_286
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨287, by decide⟩) 0 2 4)

theorem row_11_288 : RowResult ⟨11, by decide⟩ ⟨288, by decide⟩ := by
  have _previous := row_11_287
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨288, by decide⟩) 0 2 4)

theorem row_11_289 : RowResult ⟨11, by decide⟩ ⟨289, by decide⟩ := by
  have _previous := row_11_288
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) 0 2 4)

theorem row_11_290 : RowResult ⟨11, by decide⟩ ⟨290, by decide⟩ := by
  have _previous := row_11_289
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨290, by decide⟩) 0 2 4)

theorem row_11_291 : RowResult ⟨11, by decide⟩ ⟨291, by decide⟩ := by
  have _previous := row_11_290
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨291, by decide⟩) 0 2 4)

theorem row_11_292 : RowResult ⟨11, by decide⟩ ⟨292, by decide⟩ := by
  have _previous := row_11_291
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨292, by decide⟩) 0 2 4)

theorem row_11_293 : RowResult ⟨11, by decide⟩ ⟨293, by decide⟩ := by
  have _previous := row_11_292
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨293, by decide⟩) 0 2 4)

theorem row_11_294 : RowResult ⟨11, by decide⟩ ⟨294, by decide⟩ := by
  have _previous := row_11_293
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨294, by decide⟩) 0 2 4)

theorem row_11_295 : RowResult ⟨11, by decide⟩ ⟨295, by decide⟩ := by
  have _previous := row_11_294
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨295, by decide⟩) 0 2 4)

theorem row_11_296 : RowResult ⟨11, by decide⟩ ⟨296, by decide⟩ := by
  have _previous := row_11_295
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨296, by decide⟩) 0 2 4)

theorem row_11_297 : RowResult ⟨11, by decide⟩ ⟨297, by decide⟩ := by
  have _previous := row_11_296
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨297, by decide⟩) 0 2 4)

theorem row_11_298 : RowResult ⟨11, by decide⟩ ⟨298, by decide⟩ := by
  have _previous := row_11_297
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨298, by decide⟩) 0 2 4)

theorem row_11_299 : RowResult ⟨11, by decide⟩ ⟨299, by decide⟩ := by
  have _previous := row_11_298
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨299, by decide⟩) 0 2 4)

theorem row_11_300 : RowResult ⟨11, by decide⟩ ⟨300, by decide⟩ := by
  have _previous := row_11_299
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨300, by decide⟩) 0 1 6)

theorem row_11_301 : RowResult ⟨11, by decide⟩ ⟨301, by decide⟩ := by
  have _previous := row_11_300
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨301, by decide⟩) 0 1 6)

theorem row_11_302 : RowResult ⟨11, by decide⟩ ⟨302, by decide⟩ := by
  have _previous := row_11_301
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) 0 1 6)

theorem row_11_303 : RowResult ⟨11, by decide⟩ ⟨303, by decide⟩ := by
  have _previous := row_11_302
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨303, by decide⟩) 0 1 6)

theorem row_11_304 : RowResult ⟨11, by decide⟩ ⟨304, by decide⟩ := by
  have _previous := row_11_303
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨304, by decide⟩) 0 1 6)

theorem row_11_305 : RowResult ⟨11, by decide⟩ ⟨305, by decide⟩ := by
  have _previous := row_11_304
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨305, by decide⟩) 0 1 6)

theorem row_11_306 : RowResult ⟨11, by decide⟩ ⟨306, by decide⟩ := by
  have _previous := row_11_305
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨306, by decide⟩) 0 1 6)

theorem row_11_307 : RowResult ⟨11, by decide⟩ ⟨307, by decide⟩ := by
  have _previous := row_11_306
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨307, by decide⟩) 0 1 6)

theorem row_11_308 : RowResult ⟨11, by decide⟩ ⟨308, by decide⟩ := by
  have _previous := row_11_307
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨308, by decide⟩) 0 1 6)

theorem row_11_309 : RowResult ⟨11, by decide⟩ ⟨309, by decide⟩ := by
  have _previous := row_11_308
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) (orbitCodeOfNumber ⟨309, by decide⟩) 0 1 6)

end RelativeConicArcs.Q25PairCertificate
