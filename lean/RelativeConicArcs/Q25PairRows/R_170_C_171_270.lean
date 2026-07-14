import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_170_171 : RowResult ⟨170, by decide⟩ ⟨171, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 0 4 6)

theorem row_170_172 : RowResult ⟨170, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_170_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 0 4 6)

theorem row_170_173 : RowResult ⟨170, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_170_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 0 4 6)

theorem row_170_174 : RowResult ⟨170, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_170_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 0 4 6)

theorem row_170_175 : RowResult ⟨170, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_170_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 2 5)

theorem row_170_176 : RowResult ⟨170, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_170_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 2 5)

theorem row_170_177 : RowResult ⟨170, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_170_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 2 5)

theorem row_170_178 : RowResult ⟨170, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_170_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 2 5)

theorem row_170_179 : RowResult ⟨170, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_170_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 2 5)

theorem row_170_180 : RowResult ⟨170, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_170_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 5)

theorem row_170_181 : RowResult ⟨170, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_170_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 1 2 5)

theorem row_170_182 : RowResult ⟨170, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_170_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 1 2 5)

theorem row_170_183 : RowResult ⟨170, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_170_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 1 2 5)

theorem row_170_184 : RowResult ⟨170, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_170_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 1 2 5)

theorem row_170_185 : RowResult ⟨170, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_170_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 1 2 5)

theorem row_170_186 : RowResult ⟨170, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_170_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 1 2 5)

theorem row_170_187 : RowResult ⟨170, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_170_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 1 2 5)

theorem row_170_188 : RowResult ⟨170, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_170_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 1 2 5)

theorem row_170_189 : RowResult ⟨170, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_170_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 1 2 5)

theorem row_170_190 : RowResult ⟨170, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_170_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 1 2 5)

theorem row_170_191 : RowResult ⟨170, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_170_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 1 2 5)

theorem row_170_192 : RowResult ⟨170, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_170_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 1 2 5)

theorem row_170_193 : RowResult ⟨170, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_170_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 1 2 5)

theorem row_170_194 : RowResult ⟨170, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_170_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 1 2 5)

theorem row_170_195 : RowResult ⟨170, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_170_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 5)

theorem row_170_196 : RowResult ⟨170, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_170_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 1 2 5)

theorem row_170_197 : RowResult ⟨170, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_170_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 1 2 5)

theorem row_170_198 : RowResult ⟨170, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_170_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 1 2 5)

theorem row_170_199 : RowResult ⟨170, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_170_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 1 2 5)

theorem row_170_200 : RowResult ⟨170, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_170_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 2 5)

theorem row_170_201 : RowResult ⟨170, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_170_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 2 5)

theorem row_170_202 : RowResult ⟨170, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_170_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 2 5)

theorem row_170_203 : RowResult ⟨170, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_170_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 2 5)

theorem row_170_204 : RowResult ⟨170, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_170_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 2 5)

theorem row_170_205 : RowResult ⟨170, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_170_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 5)

theorem row_170_206 : RowResult ⟨170, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_170_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 1 2 5)

theorem row_170_207 : RowResult ⟨170, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_170_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 1 2 5)

theorem row_170_208 : RowResult ⟨170, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_170_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 1 2 5)

theorem row_170_209 : RowResult ⟨170, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_170_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 1 2 5)

theorem row_170_210 : RowResult ⟨170, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_170_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 1 2 5)

theorem row_170_211 : RowResult ⟨170, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_170_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 1 2 5)

theorem row_170_212 : RowResult ⟨170, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_170_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 1 2 5)

theorem row_170_213 : RowResult ⟨170, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_170_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 1 2 5)

theorem row_170_214 : RowResult ⟨170, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_170_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 1 2 5)

theorem row_170_215 : RowResult ⟨170, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_170_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 1 2 5)

theorem row_170_216 : RowResult ⟨170, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_170_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 1 2 5)

theorem row_170_217 : RowResult ⟨170, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_170_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 1 2 5)

theorem row_170_218 : RowResult ⟨170, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_170_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 1 2 5)

theorem row_170_219 : RowResult ⟨170, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_170_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 1 2 5)

theorem row_170_220 : RowResult ⟨170, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_170_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 5)

theorem row_170_221 : RowResult ⟨170, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_170_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 1 2 5)

theorem row_170_222 : RowResult ⟨170, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_170_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 1 2 5)

theorem row_170_223 : RowResult ⟨170, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_170_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 1 2 5)

theorem row_170_224 : RowResult ⟨170, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_170_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 1 2 5)

theorem row_170_225 : RowResult ⟨170, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_170_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 2 5)

theorem row_170_226 : RowResult ⟨170, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_170_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 2 5)

theorem row_170_227 : RowResult ⟨170, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_170_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 2 5)

theorem row_170_228 : RowResult ⟨170, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_170_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 2 5)

theorem row_170_229 : RowResult ⟨170, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_170_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 2 5)

theorem row_170_230 : RowResult ⟨170, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_170_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 5)

theorem row_170_231 : RowResult ⟨170, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_170_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 1 2 5)

theorem row_170_232 : RowResult ⟨170, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_170_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 2 5)

theorem row_170_233 : RowResult ⟨170, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_170_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 1 2 5)

theorem row_170_234 : RowResult ⟨170, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_170_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 1 2 5)

theorem row_170_235 : RowResult ⟨170, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_170_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 1 2 5)

theorem row_170_236 : RowResult ⟨170, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_170_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 2 5)

theorem row_170_237 : RowResult ⟨170, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_170_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 2 5)

theorem row_170_238 : RowResult ⟨170, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_170_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 1 2 5)

theorem row_170_239 : RowResult ⟨170, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_170_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 2 5)

theorem row_170_240 : RowResult ⟨170, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_170_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 1 2 5)

theorem row_170_241 : RowResult ⟨170, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_170_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 1 2 5)

theorem row_170_242 : RowResult ⟨170, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_170_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 1 2 5)

theorem row_170_243 : RowResult ⟨170, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_170_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 1 2 5)

theorem row_170_244 : RowResult ⟨170, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_170_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 1 2 5)

theorem row_170_245 : RowResult ⟨170, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_170_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 5)

theorem row_170_246 : RowResult ⟨170, by decide⟩ ⟨246, by decide⟩ := by
  have _previous := row_170_245
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨246, by decide⟩) 1 2 5)

theorem row_170_247 : RowResult ⟨170, by decide⟩ ⟨247, by decide⟩ := by
  have _previous := row_170_246
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨247, by decide⟩) 1 2 5)

theorem row_170_248 : RowResult ⟨170, by decide⟩ ⟨248, by decide⟩ := by
  have _previous := row_170_247
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨248, by decide⟩) 1 2 5)

theorem row_170_249 : RowResult ⟨170, by decide⟩ ⟨249, by decide⟩ := by
  have _previous := row_170_248
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨249, by decide⟩) 1 2 5)

theorem row_170_250 : RowResult ⟨170, by decide⟩ ⟨250, by decide⟩ := by
  have _previous := row_170_249
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨250, by decide⟩) 0 6 7)

theorem row_170_251 : RowResult ⟨170, by decide⟩ ⟨251, by decide⟩ := by
  have _previous := row_170_250
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨251, by decide⟩) 0 6 7)

theorem row_170_252 : RowResult ⟨170, by decide⟩ ⟨252, by decide⟩ := by
  have _previous := row_170_251
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨252, by decide⟩) 0 6 7)

theorem row_170_253 : RowResult ⟨170, by decide⟩ ⟨253, by decide⟩ := by
  have _previous := row_170_252
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨253, by decide⟩) 0 6 7)

theorem row_170_254 : RowResult ⟨170, by decide⟩ ⟨254, by decide⟩ := by
  have _previous := row_170_253
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨254, by decide⟩) 0 6 7)

theorem row_170_255 : RowResult ⟨170, by decide⟩ ⟨255, by decide⟩ := by
  have _previous := row_170_254
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨255, by decide⟩) 0 6 7)

theorem row_170_256 : RowResult ⟨170, by decide⟩ ⟨256, by decide⟩ := by
  have _previous := row_170_255
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨256, by decide⟩) 0 6 7)

theorem row_170_257 : RowResult ⟨170, by decide⟩ ⟨257, by decide⟩ := by
  have _previous := row_170_256
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨257, by decide⟩) 0 6 7)

theorem row_170_258 : RowResult ⟨170, by decide⟩ ⟨258, by decide⟩ := by
  have _previous := row_170_257
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨258, by decide⟩) 0 6 7)

theorem row_170_259 : RowResult ⟨170, by decide⟩ ⟨259, by decide⟩ := by
  have _previous := row_170_258
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨259, by decide⟩) 0 6 7)

theorem row_170_260 : RowResult ⟨170, by decide⟩ ⟨260, by decide⟩ := by
  have _previous := row_170_259
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨260, by decide⟩) 0 6 7)

theorem row_170_261 : RowResult ⟨170, by decide⟩ ⟨261, by decide⟩ := by
  have _previous := row_170_260
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨261, by decide⟩) 0 6 7)

theorem row_170_262 : RowResult ⟨170, by decide⟩ ⟨262, by decide⟩ := by
  have _previous := row_170_261
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨262, by decide⟩) 0 6 7)

theorem row_170_263 : RowResult ⟨170, by decide⟩ ⟨263, by decide⟩ := by
  have _previous := row_170_262
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨263, by decide⟩) 0 6 7)

theorem row_170_264 : RowResult ⟨170, by decide⟩ ⟨264, by decide⟩ := by
  have _previous := row_170_263
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨264, by decide⟩) 0 6 7)

theorem row_170_265 : RowResult ⟨170, by decide⟩ ⟨265, by decide⟩ := by
  have _previous := row_170_264
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨265, by decide⟩) 0 6 7)

theorem row_170_266 : RowResult ⟨170, by decide⟩ ⟨266, by decide⟩ := by
  have _previous := row_170_265
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨266, by decide⟩) 0 6 7)

theorem row_170_267 : RowResult ⟨170, by decide⟩ ⟨267, by decide⟩ := by
  have _previous := row_170_266
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨267, by decide⟩) 0 6 7)

theorem row_170_268 : RowResult ⟨170, by decide⟩ ⟨268, by decide⟩ := by
  have _previous := row_170_267
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨268, by decide⟩) 0 6 7)

theorem row_170_269 : RowResult ⟨170, by decide⟩ ⟨269, by decide⟩ := by
  have _previous := row_170_268
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨269, by decide⟩) 0 6 7)

theorem row_170_270 : RowResult ⟨170, by decide⟩ ⟨270, by decide⟩ := by
  have _previous := row_170_269
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) (orbitCodeOfNumber ⟨270, by decide⟩) 0 6 7)

end RelativeConicArcs.Q25PairCertificate
