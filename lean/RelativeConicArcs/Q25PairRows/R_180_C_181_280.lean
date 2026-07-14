import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_180_181 : RowResult ⟨180, by decide⟩ ⟨181, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 0 4 6)

theorem row_180_182 : RowResult ⟨180, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_180_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 0 4 6)

theorem row_180_183 : RowResult ⟨180, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_180_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 0 4 6)

theorem row_180_184 : RowResult ⟨180, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_180_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 0 4 6)

theorem row_180_185 : RowResult ⟨180, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_180_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 0 4 6)

theorem row_180_186 : RowResult ⟨180, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_180_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 0 4 6)

theorem row_180_187 : RowResult ⟨180, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_180_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 0 4 6)

theorem row_180_188 : RowResult ⟨180, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_180_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 0 4 6)

theorem row_180_189 : RowResult ⟨180, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_180_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 0 4 6)

theorem row_180_190 : RowResult ⟨180, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_180_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 0 4 6)

theorem row_180_191 : RowResult ⟨180, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_180_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 0 4 6)

theorem row_180_192 : RowResult ⟨180, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_180_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 0 4 6)

theorem row_180_193 : RowResult ⟨180, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_180_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 0 4 6)

theorem row_180_194 : RowResult ⟨180, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_180_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 0 4 6)

theorem row_180_195 : RowResult ⟨180, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_180_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 0 4 6)

theorem row_180_196 : RowResult ⟨180, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_180_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 0 4 6)

theorem row_180_197 : RowResult ⟨180, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_180_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 0 4 6)

theorem row_180_198 : RowResult ⟨180, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_180_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 0 4 6)

theorem row_180_199 : RowResult ⟨180, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_180_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 0 4 6)

theorem row_180_200 : RowResult ⟨180, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_180_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 2 4)

theorem row_180_201 : RowResult ⟨180, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_180_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 2 4)

theorem row_180_202 : RowResult ⟨180, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_180_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 2 4)

theorem row_180_203 : RowResult ⟨180, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_180_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 2 4)

theorem row_180_204 : RowResult ⟨180, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_180_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 2 4)

theorem row_180_205 : RowResult ⟨180, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_180_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 4)

theorem row_180_206 : RowResult ⟨180, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_180_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 1 2 4)

theorem row_180_207 : RowResult ⟨180, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_180_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 1 2 4)

theorem row_180_208 : RowResult ⟨180, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_180_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 1 2 4)

theorem row_180_209 : RowResult ⟨180, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_180_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 1 2 4)

theorem row_180_210 : RowResult ⟨180, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_180_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 1 2 4)

theorem row_180_211 : RowResult ⟨180, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_180_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 1 2 4)

theorem row_180_212 : RowResult ⟨180, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_180_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 1 2 4)

theorem row_180_213 : RowResult ⟨180, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_180_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 1 2 4)

theorem row_180_214 : RowResult ⟨180, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_180_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 1 2 4)

theorem row_180_215 : RowResult ⟨180, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_180_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 1 2 4)

theorem row_180_216 : RowResult ⟨180, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_180_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 1 2 4)

theorem row_180_217 : RowResult ⟨180, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_180_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 1 2 4)

theorem row_180_218 : RowResult ⟨180, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_180_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 1 2 4)

theorem row_180_219 : RowResult ⟨180, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_180_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 1 2 4)

theorem row_180_220 : RowResult ⟨180, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_180_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 4)

theorem row_180_221 : RowResult ⟨180, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_180_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 1 2 4)

theorem row_180_222 : RowResult ⟨180, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_180_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 1 2 4)

theorem row_180_223 : RowResult ⟨180, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_180_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 1 2 4)

theorem row_180_224 : RowResult ⟨180, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_180_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 1 2 4)

theorem row_180_225 : RowResult ⟨180, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_180_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 2 4)

theorem row_180_226 : RowResult ⟨180, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_180_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 2 4)

theorem row_180_227 : RowResult ⟨180, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_180_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 2 4)

theorem row_180_228 : RowResult ⟨180, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_180_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 2 4)

theorem row_180_229 : RowResult ⟨180, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_180_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 2 4)

theorem row_180_230 : RowResult ⟨180, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_180_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 4)

theorem row_180_231 : RowResult ⟨180, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_180_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 1 2 4)

theorem row_180_232 : RowResult ⟨180, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_180_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 2 4)

theorem row_180_233 : RowResult ⟨180, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_180_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 1 2 4)

theorem row_180_234 : RowResult ⟨180, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_180_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 1 2 4)

theorem row_180_235 : RowResult ⟨180, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_180_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 1 2 4)

theorem row_180_236 : RowResult ⟨180, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_180_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 2 4)

theorem row_180_237 : RowResult ⟨180, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_180_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 2 4)

theorem row_180_238 : RowResult ⟨180, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_180_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 1 2 4)

theorem row_180_239 : RowResult ⟨180, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_180_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 2 4)

theorem row_180_240 : RowResult ⟨180, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_180_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 1 2 4)

theorem row_180_241 : RowResult ⟨180, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_180_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 1 2 4)

theorem row_180_242 : RowResult ⟨180, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_180_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 1 2 4)

theorem row_180_243 : RowResult ⟨180, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_180_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 1 2 4)

theorem row_180_244 : RowResult ⟨180, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_180_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 1 2 4)

theorem row_180_245 : RowResult ⟨180, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_180_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 4)

theorem row_180_246 : RowResult ⟨180, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_180_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 1 2 4)

theorem row_180_247 : RowResult ⟨180, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_180_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 1 2 4)

theorem row_180_248 : RowResult ⟨180, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_180_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 1 2 4)

theorem row_180_249 : RowResult ⟨180, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_180_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 1 2 4)

theorem row_180_250 : RowResult ⟨180, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_180_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_180_251 : RowResult ⟨180, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_180_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_180_252 : RowResult ⟨180, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_180_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_180_253 : RowResult ⟨180, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_180_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_180_254 : RowResult ⟨180, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_180_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_180_255 : RowResult ⟨180, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_180_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_180_256 : RowResult ⟨180, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_180_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_180_257 : RowResult ⟨180, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_180_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_180_258 : RowResult ⟨180, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_180_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_180_259 : RowResult ⟨180, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_180_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_180_260 : RowResult ⟨180, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_180_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_180_261 : RowResult ⟨180, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_180_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_180_262 : RowResult ⟨180, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_180_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_180_263 : RowResult ⟨180, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_180_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_180_264 : RowResult ⟨180, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_180_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_180_265 : RowResult ⟨180, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_180_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

theorem row_180_266 : RowResult ⟨180, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_180_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 6 7)

theorem row_180_267 : RowResult ⟨180, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_180_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 6 7)

theorem row_180_268 : RowResult ⟨180, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_180_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 6 7)

theorem row_180_269 : RowResult ⟨180, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_180_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 6 7)

theorem row_180_270 : RowResult ⟨180, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_180_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 6 7)

theorem row_180_271 : RowResult ⟨180, by decide⟩ ⟨271, by decide⟩ := by
  have _previous := row_180_270
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨271, by decide⟩) 0 6 7)

theorem row_180_272 : RowResult ⟨180, by decide⟩ ⟨272, by decide⟩ := by
  have _previous := row_180_271
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨272, by decide⟩) 0 6 7)

theorem row_180_273 : RowResult ⟨180, by decide⟩ ⟨273, by decide⟩ := by
  have _previous := row_180_272
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨273, by decide⟩) 0 6 7)

theorem row_180_274 : RowResult ⟨180, by decide⟩ ⟨274, by decide⟩ := by
  have _previous := row_180_273
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨274, by decide⟩) 0 6 7)

theorem row_180_275 : RowResult ⟨180, by decide⟩ ⟨275, by decide⟩ := by
  have _previous := row_180_274
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨275, by decide⟩) 0 6 7)

theorem row_180_276 : RowResult ⟨180, by decide⟩ ⟨276, by decide⟩ := by
  have _previous := row_180_275
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨276, by decide⟩) 0 6 7)

theorem row_180_277 : RowResult ⟨180, by decide⟩ ⟨277, by decide⟩ := by
  have _previous := row_180_276
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨277, by decide⟩) 0 6 7)

theorem row_180_278 : RowResult ⟨180, by decide⟩ ⟨278, by decide⟩ := by
  have _previous := row_180_277
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨278, by decide⟩) 0 6 7)

theorem row_180_279 : RowResult ⟨180, by decide⟩ ⟨279, by decide⟩ := by
  have _previous := row_180_278
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨279, by decide⟩) 0 6 7)

theorem row_180_280 : RowResult ⟨180, by decide⟩ ⟨280, by decide⟩ := by
  have _previous := row_180_279
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) (orbitCodeOfNumber ⟨280, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
