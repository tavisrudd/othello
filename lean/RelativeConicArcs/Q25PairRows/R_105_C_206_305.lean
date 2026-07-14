import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_105_206 : RowResult ⟨105, by decide⟩ ⟨206, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 1 2 4)

theorem row_105_207 : RowResult ⟨105, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_105_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 1 2 4)

theorem row_105_208 : RowResult ⟨105, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_105_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 1 2 4)

theorem row_105_209 : RowResult ⟨105, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_105_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 1 2 4)

theorem row_105_210 : RowResult ⟨105, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_105_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 1 2 4)

theorem row_105_211 : RowResult ⟨105, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_105_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 1 2 4)

theorem row_105_212 : RowResult ⟨105, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_105_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 1 2 4)

theorem row_105_213 : RowResult ⟨105, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_105_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 1 2 4)

theorem row_105_214 : RowResult ⟨105, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_105_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 1 2 4)

theorem row_105_215 : RowResult ⟨105, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_105_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 1 2 4)

theorem row_105_216 : RowResult ⟨105, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_105_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 1 2 4)

theorem row_105_217 : RowResult ⟨105, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_105_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 1 2 4)

theorem row_105_218 : RowResult ⟨105, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_105_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 1 2 4)

theorem row_105_219 : RowResult ⟨105, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_105_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 1 2 4)

theorem row_105_220 : RowResult ⟨105, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_105_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 4)

theorem row_105_221 : RowResult ⟨105, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_105_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 1 2 4)

theorem row_105_222 : RowResult ⟨105, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_105_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 1 2 4)

theorem row_105_223 : RowResult ⟨105, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_105_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 1 2 4)

theorem row_105_224 : RowResult ⟨105, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_105_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 1 2 4)

theorem row_105_225 : RowResult ⟨105, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_105_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 2 4)

theorem row_105_226 : RowResult ⟨105, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_105_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 2 4)

theorem row_105_227 : RowResult ⟨105, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_105_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 2 4)

theorem row_105_228 : RowResult ⟨105, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_105_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 2 4)

theorem row_105_229 : RowResult ⟨105, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_105_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 2 4)

theorem row_105_230 : RowResult ⟨105, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_105_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 4)

theorem row_105_231 : RowResult ⟨105, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_105_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 1 2 4)

theorem row_105_232 : RowResult ⟨105, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_105_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 2 4)

theorem row_105_233 : RowResult ⟨105, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_105_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 1 2 4)

theorem row_105_234 : RowResult ⟨105, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_105_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 1 2 4)

theorem row_105_235 : RowResult ⟨105, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_105_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 1 2 4)

theorem row_105_236 : RowResult ⟨105, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_105_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 2 4)

theorem row_105_237 : RowResult ⟨105, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_105_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 2 4)

theorem row_105_238 : RowResult ⟨105, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_105_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 1 2 4)

theorem row_105_239 : RowResult ⟨105, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_105_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 2 4)

theorem row_105_240 : RowResult ⟨105, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_105_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 1 2 4)

theorem row_105_241 : RowResult ⟨105, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_105_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 1 2 4)

theorem row_105_242 : RowResult ⟨105, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_105_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 1 2 4)

theorem row_105_243 : RowResult ⟨105, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_105_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 1 2 4)

theorem row_105_244 : RowResult ⟨105, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_105_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 1 2 4)

theorem row_105_245 : RowResult ⟨105, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_105_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 4)

theorem row_105_246 : RowResult ⟨105, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_105_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 1 2 4)

theorem row_105_247 : RowResult ⟨105, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_105_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 1 2 4)

theorem row_105_248 : RowResult ⟨105, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_105_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 1 2 4)

theorem row_105_249 : RowResult ⟨105, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_105_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 1 2 4)

theorem row_105_250 : RowResult ⟨105, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_105_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_105_251 : RowResult ⟨105, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_105_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_105_252 : RowResult ⟨105, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_105_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_105_253 : RowResult ⟨105, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_105_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_105_254 : RowResult ⟨105, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_105_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_105_255 : RowResult ⟨105, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_105_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_105_256 : RowResult ⟨105, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_105_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_105_257 : RowResult ⟨105, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_105_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_105_258 : RowResult ⟨105, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_105_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_105_259 : RowResult ⟨105, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_105_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_105_260 : RowResult ⟨105, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_105_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_105_261 : RowResult ⟨105, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_105_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_105_262 : RowResult ⟨105, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_105_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_105_263 : RowResult ⟨105, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_105_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_105_264 : RowResult ⟨105, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_105_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_105_265 : RowResult ⟨105, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_105_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

theorem row_105_266 : RowResult ⟨105, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_105_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 6 7)

theorem row_105_267 : RowResult ⟨105, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_105_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 6 7)

theorem row_105_268 : RowResult ⟨105, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_105_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 6 7)

theorem row_105_269 : RowResult ⟨105, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_105_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 6 7)

theorem row_105_270 : RowResult ⟨105, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_105_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 6 7)

theorem row_105_271 : RowResult ⟨105, by decide⟩ ⟨271, by decide⟩ := by
  have _previous := row_105_270
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨271, by decide⟩) 0 6 7)

theorem row_105_272 : RowResult ⟨105, by decide⟩ ⟨272, by decide⟩ := by
  have _previous := row_105_271
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨272, by decide⟩) 0 6 7)

theorem row_105_273 : RowResult ⟨105, by decide⟩ ⟨273, by decide⟩ := by
  have _previous := row_105_272
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨273, by decide⟩) 0 6 7)

theorem row_105_274 : RowResult ⟨105, by decide⟩ ⟨274, by decide⟩ := by
  have _previous := row_105_273
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨274, by decide⟩) 0 6 7)

theorem row_105_275 : RowResult ⟨105, by decide⟩ ⟨275, by decide⟩ := by
  have _previous := row_105_274
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨275, by decide⟩) 0 6 7)

theorem row_105_276 : RowResult ⟨105, by decide⟩ ⟨276, by decide⟩ := by
  have _previous := row_105_275
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨276, by decide⟩) 0 6 7)

theorem row_105_277 : RowResult ⟨105, by decide⟩ ⟨277, by decide⟩ := by
  have _previous := row_105_276
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨277, by decide⟩) 0 6 7)

theorem row_105_278 : RowResult ⟨105, by decide⟩ ⟨278, by decide⟩ := by
  have _previous := row_105_277
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨278, by decide⟩) 0 6 7)

theorem row_105_279 : RowResult ⟨105, by decide⟩ ⟨279, by decide⟩ := by
  have _previous := row_105_278
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨279, by decide⟩) 0 6 7)

theorem row_105_280 : RowResult ⟨105, by decide⟩ ⟨280, by decide⟩ := by
  have _previous := row_105_279
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨280, by decide⟩) 0 6 7)

theorem row_105_281 : RowResult ⟨105, by decide⟩ ⟨281, by decide⟩ := by
  have _previous := row_105_280
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨281, by decide⟩) 0 6 7)

theorem row_105_282 : RowResult ⟨105, by decide⟩ ⟨282, by decide⟩ := by
  have _previous := row_105_281
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨282, by decide⟩) 0 6 7)

theorem row_105_283 : RowResult ⟨105, by decide⟩ ⟨283, by decide⟩ := by
  have _previous := row_105_282
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨283, by decide⟩) 0 6 7)

theorem row_105_284 : RowResult ⟨105, by decide⟩ ⟨284, by decide⟩ := by
  have _previous := row_105_283
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨284, by decide⟩) 0 6 7)

theorem row_105_285 : RowResult ⟨105, by decide⟩ ⟨285, by decide⟩ := by
  have _previous := row_105_284
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨285, by decide⟩) 0 6 7)

theorem row_105_286 : RowResult ⟨105, by decide⟩ ⟨286, by decide⟩ := by
  have _previous := row_105_285
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨286, by decide⟩) 0 6 7)

theorem row_105_287 : RowResult ⟨105, by decide⟩ ⟨287, by decide⟩ := by
  have _previous := row_105_286
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨287, by decide⟩) 0 6 7)

theorem row_105_288 : RowResult ⟨105, by decide⟩ ⟨288, by decide⟩ := by
  have _previous := row_105_287
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨288, by decide⟩) 0 6 7)

theorem row_105_289 : RowResult ⟨105, by decide⟩ ⟨289, by decide⟩ := by
  have _previous := row_105_288
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) 0 6 7)

theorem row_105_290 : RowResult ⟨105, by decide⟩ ⟨290, by decide⟩ := by
  have _previous := row_105_289
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨290, by decide⟩) 0 6 7)

theorem row_105_291 : RowResult ⟨105, by decide⟩ ⟨291, by decide⟩ := by
  have _previous := row_105_290
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨291, by decide⟩) 0 6 7)

theorem row_105_292 : RowResult ⟨105, by decide⟩ ⟨292, by decide⟩ := by
  have _previous := row_105_291
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨292, by decide⟩) 0 6 7)

theorem row_105_293 : RowResult ⟨105, by decide⟩ ⟨293, by decide⟩ := by
  have _previous := row_105_292
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨293, by decide⟩) 0 6 7)

theorem row_105_294 : RowResult ⟨105, by decide⟩ ⟨294, by decide⟩ := by
  have _previous := row_105_293
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨294, by decide⟩) 0 6 7)

theorem row_105_295 : RowResult ⟨105, by decide⟩ ⟨295, by decide⟩ := by
  have _previous := row_105_294
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨295, by decide⟩) 0 6 7)

theorem row_105_296 : RowResult ⟨105, by decide⟩ ⟨296, by decide⟩ := by
  have _previous := row_105_295
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨296, by decide⟩) 0 6 7)

theorem row_105_297 : RowResult ⟨105, by decide⟩ ⟨297, by decide⟩ := by
  have _previous := row_105_296
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨297, by decide⟩) 0 6 7)

theorem row_105_298 : RowResult ⟨105, by decide⟩ ⟨298, by decide⟩ := by
  have _previous := row_105_297
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨298, by decide⟩) 0 6 7)

theorem row_105_299 : RowResult ⟨105, by decide⟩ ⟨299, by decide⟩ := by
  have _previous := row_105_298
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨299, by decide⟩) 0 6 7)

theorem row_105_300 : RowResult ⟨105, by decide⟩ ⟨300, by decide⟩ := by
  have _previous := row_105_299
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨300, by decide⟩) 0 1 6)

theorem row_105_301 : RowResult ⟨105, by decide⟩ ⟨301, by decide⟩ := by
  have _previous := row_105_300
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨301, by decide⟩) 0 1 6)

theorem row_105_302 : RowResult ⟨105, by decide⟩ ⟨302, by decide⟩ := by
  have _previous := row_105_301
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) 0 1 6)

theorem row_105_303 : RowResult ⟨105, by decide⟩ ⟨303, by decide⟩ := by
  have _previous := row_105_302
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨303, by decide⟩) 0 1 6)

theorem row_105_304 : RowResult ⟨105, by decide⟩ ⟨304, by decide⟩ := by
  have _previous := row_105_303
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨304, by decide⟩) 0 1 6)

theorem row_105_305 : RowResult ⟨105, by decide⟩ ⟨305, by decide⟩ := by
  have _previous := row_105_304
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) (orbitCodeOfNumber ⟨305, by decide⟩) 0 1 6)

end RelativeConicArcs.Q25PairCertificate
