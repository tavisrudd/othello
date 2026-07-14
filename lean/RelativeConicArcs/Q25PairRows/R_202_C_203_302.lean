import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_202_203 : RowResult ⟨202, by decide⟩ ⟨203, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 0 4 6)

theorem row_202_204 : RowResult ⟨202, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_202_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 0 4 6)

theorem row_202_205 : RowResult ⟨202, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_202_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 0 4 6)

theorem row_202_206 : RowResult ⟨202, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_202_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 0 4 6)

theorem row_202_207 : RowResult ⟨202, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_202_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 0 4 6)

theorem row_202_208 : RowResult ⟨202, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_202_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 0 4 6)

theorem row_202_209 : RowResult ⟨202, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_202_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 0 4 6)

theorem row_202_210 : RowResult ⟨202, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_202_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 0 4 6)

theorem row_202_211 : RowResult ⟨202, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_202_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 0 4 6)

theorem row_202_212 : RowResult ⟨202, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_202_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 0 4 6)

theorem row_202_213 : RowResult ⟨202, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_202_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 0 4 6)

theorem row_202_214 : RowResult ⟨202, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_202_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 0 4 6)

theorem row_202_215 : RowResult ⟨202, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_202_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 0 4 6)

theorem row_202_216 : RowResult ⟨202, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_202_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 0 4 6)

theorem row_202_217 : RowResult ⟨202, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_202_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 0 4 6)

theorem row_202_218 : RowResult ⟨202, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_202_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 0 4 6)

theorem row_202_219 : RowResult ⟨202, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_202_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 0 4 6)

theorem row_202_220 : RowResult ⟨202, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_202_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 0 4 6)

theorem row_202_221 : RowResult ⟨202, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_202_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 0 4 6)

theorem row_202_222 : RowResult ⟨202, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_202_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 0 4 6)

theorem row_202_223 : RowResult ⟨202, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_202_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 0 4 6)

theorem row_202_224 : RowResult ⟨202, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_202_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 0 4 6)

theorem row_202_225 : RowResult ⟨202, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_202_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 4 5)

theorem row_202_226 : RowResult ⟨202, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_202_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 4 5)

theorem row_202_227 : RowResult ⟨202, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_202_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 4 5)

theorem row_202_228 : RowResult ⟨202, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_202_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 4 5)

theorem row_202_229 : RowResult ⟨202, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_202_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 4 5)

theorem row_202_230 : RowResult ⟨202, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_202_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_202_231 : RowResult ⟨202, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_202_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 1 4 5)

theorem row_202_232 : RowResult ⟨202, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_202_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 4 5)

theorem row_202_233 : RowResult ⟨202, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_202_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 1 4 5)

theorem row_202_234 : RowResult ⟨202, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_202_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 1 4 5)

theorem row_202_235 : RowResult ⟨202, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_202_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 1 4 5)

theorem row_202_236 : RowResult ⟨202, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_202_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 4 5)

theorem row_202_237 : RowResult ⟨202, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_202_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 4 5)

theorem row_202_238 : RowResult ⟨202, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_202_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 1 4 5)

theorem row_202_239 : RowResult ⟨202, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_202_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 4 5)

theorem row_202_240 : RowResult ⟨202, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_202_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 1 4 5)

theorem row_202_241 : RowResult ⟨202, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_202_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 1 4 5)

theorem row_202_242 : RowResult ⟨202, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_202_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 1 4 5)

theorem row_202_243 : RowResult ⟨202, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_202_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 1 4 5)

theorem row_202_244 : RowResult ⟨202, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_202_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 1 4 5)

theorem row_202_245 : RowResult ⟨202, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_202_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 7)

theorem row_202_246 : RowResult ⟨202, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_202_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 1 4 5)

theorem row_202_247 : RowResult ⟨202, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_202_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 1 4 5)

theorem row_202_248 : RowResult ⟨202, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_202_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 1 4 5)

theorem row_202_249 : RowResult ⟨202, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_202_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 1 4 5)

theorem row_202_250 : RowResult ⟨202, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_202_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_202_251 : RowResult ⟨202, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_202_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_202_252 : RowResult ⟨202, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_202_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_202_253 : RowResult ⟨202, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_202_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_202_254 : RowResult ⟨202, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_202_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_202_255 : RowResult ⟨202, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_202_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_202_256 : RowResult ⟨202, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_202_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_202_257 : RowResult ⟨202, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_202_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_202_258 : RowResult ⟨202, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_202_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_202_259 : RowResult ⟨202, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_202_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_202_260 : RowResult ⟨202, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_202_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_202_261 : RowResult ⟨202, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_202_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_202_262 : RowResult ⟨202, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_202_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_202_263 : RowResult ⟨202, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_202_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_202_264 : RowResult ⟨202, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_202_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_202_265 : RowResult ⟨202, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_202_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

theorem row_202_266 : RowResult ⟨202, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_202_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 6 7)

theorem row_202_267 : RowResult ⟨202, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_202_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 6 7)

theorem row_202_268 : RowResult ⟨202, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_202_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 6 7)

theorem row_202_269 : RowResult ⟨202, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_202_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 6 7)

theorem row_202_270 : RowResult ⟨202, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_202_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 6 7)

theorem row_202_271 : RowResult ⟨202, by decide⟩ ⟨271, by decide⟩ := by
  have _previous := row_202_270
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨271, by decide⟩) 0 6 7)

theorem row_202_272 : RowResult ⟨202, by decide⟩ ⟨272, by decide⟩ := by
  have _previous := row_202_271
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨272, by decide⟩) 0 6 7)

theorem row_202_273 : RowResult ⟨202, by decide⟩ ⟨273, by decide⟩ := by
  have _previous := row_202_272
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨273, by decide⟩) 0 6 7)

theorem row_202_274 : RowResult ⟨202, by decide⟩ ⟨274, by decide⟩ := by
  have _previous := row_202_273
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨274, by decide⟩) 0 6 7)

theorem row_202_275 : RowResult ⟨202, by decide⟩ ⟨275, by decide⟩ := by
  have _previous := row_202_274
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨275, by decide⟩) 0 6 7)

theorem row_202_276 : RowResult ⟨202, by decide⟩ ⟨276, by decide⟩ := by
  have _previous := row_202_275
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨276, by decide⟩) 0 6 7)

theorem row_202_277 : RowResult ⟨202, by decide⟩ ⟨277, by decide⟩ := by
  have _previous := row_202_276
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨277, by decide⟩) 0 6 7)

theorem row_202_278 : RowResult ⟨202, by decide⟩ ⟨278, by decide⟩ := by
  have _previous := row_202_277
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨278, by decide⟩) 0 6 7)

theorem row_202_279 : RowResult ⟨202, by decide⟩ ⟨279, by decide⟩ := by
  have _previous := row_202_278
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨279, by decide⟩) 0 6 7)

theorem row_202_280 : RowResult ⟨202, by decide⟩ ⟨280, by decide⟩ := by
  have _previous := row_202_279
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨280, by decide⟩) 0 6 7)

theorem row_202_281 : RowResult ⟨202, by decide⟩ ⟨281, by decide⟩ := by
  have _previous := row_202_280
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨281, by decide⟩) 0 6 7)

theorem row_202_282 : RowResult ⟨202, by decide⟩ ⟨282, by decide⟩ := by
  have _previous := row_202_281
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨282, by decide⟩) 0 6 7)

theorem row_202_283 : RowResult ⟨202, by decide⟩ ⟨283, by decide⟩ := by
  have _previous := row_202_282
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨283, by decide⟩) 0 6 7)

theorem row_202_284 : RowResult ⟨202, by decide⟩ ⟨284, by decide⟩ := by
  have _previous := row_202_283
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨284, by decide⟩) 0 6 7)

theorem row_202_285 : RowResult ⟨202, by decide⟩ ⟨285, by decide⟩ := by
  have _previous := row_202_284
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨285, by decide⟩) 0 6 7)

theorem row_202_286 : RowResult ⟨202, by decide⟩ ⟨286, by decide⟩ := by
  have _previous := row_202_285
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨286, by decide⟩) 0 6 7)

theorem row_202_287 : RowResult ⟨202, by decide⟩ ⟨287, by decide⟩ := by
  have _previous := row_202_286
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨287, by decide⟩) 0 6 7)

theorem row_202_288 : RowResult ⟨202, by decide⟩ ⟨288, by decide⟩ := by
  have _previous := row_202_287
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨288, by decide⟩) 0 6 7)

theorem row_202_289 : RowResult ⟨202, by decide⟩ ⟨289, by decide⟩ := by
  have _previous := row_202_288
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨289, by decide⟩) 0 6 7)

theorem row_202_290 : RowResult ⟨202, by decide⟩ ⟨290, by decide⟩ := by
  have _previous := row_202_289
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨290, by decide⟩) 0 6 7)

theorem row_202_291 : RowResult ⟨202, by decide⟩ ⟨291, by decide⟩ := by
  have _previous := row_202_290
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨291, by decide⟩) 0 6 7)

theorem row_202_292 : RowResult ⟨202, by decide⟩ ⟨292, by decide⟩ := by
  have _previous := row_202_291
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨292, by decide⟩) 0 6 7)

theorem row_202_293 : RowResult ⟨202, by decide⟩ ⟨293, by decide⟩ := by
  have _previous := row_202_292
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨293, by decide⟩) 0 6 7)

theorem row_202_294 : RowResult ⟨202, by decide⟩ ⟨294, by decide⟩ := by
  have _previous := row_202_293
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨294, by decide⟩) 0 6 7)

theorem row_202_295 : RowResult ⟨202, by decide⟩ ⟨295, by decide⟩ := by
  have _previous := row_202_294
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨295, by decide⟩) 0 6 7)

theorem row_202_296 : RowResult ⟨202, by decide⟩ ⟨296, by decide⟩ := by
  have _previous := row_202_295
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨296, by decide⟩) 0 6 7)

theorem row_202_297 : RowResult ⟨202, by decide⟩ ⟨297, by decide⟩ := by
  have _previous := row_202_296
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨297, by decide⟩) 0 6 7)

theorem row_202_298 : RowResult ⟨202, by decide⟩ ⟨298, by decide⟩ := by
  have _previous := row_202_297
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨298, by decide⟩) 0 6 7)

theorem row_202_299 : RowResult ⟨202, by decide⟩ ⟨299, by decide⟩ := by
  have _previous := row_202_298
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨299, by decide⟩) 0 6 7)

theorem row_202_300 : RowResult ⟨202, by decide⟩ ⟨300, by decide⟩ := by
  have _previous := row_202_299
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨300, by decide⟩) 0 1 6)

theorem row_202_301 : RowResult ⟨202, by decide⟩ ⟨301, by decide⟩ := by
  have _previous := row_202_300
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨301, by decide⟩) 0 1 6)

theorem row_202_302 : RowResult ⟨202, by decide⟩ ⟨302, by decide⟩ := by
  have _previous := row_202_301
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) (orbitCodeOfNumber ⟨302, by decide⟩) 0 1 6)

end RelativeConicArcs.Q25PairCertificate
