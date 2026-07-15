import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_210_211 : RowResult ⟨210, by decide⟩ ⟨211, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 0 4 6)

theorem row_210_212 : RowResult ⟨210, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_210_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 0 4 6)

theorem row_210_213 : RowResult ⟨210, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_210_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 0 4 6)

theorem row_210_214 : RowResult ⟨210, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_210_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 0 4 6)

theorem row_210_215 : RowResult ⟨210, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_210_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 0 4 6)

theorem row_210_216 : RowResult ⟨210, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_210_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 0 4 6)

theorem row_210_217 : RowResult ⟨210, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_210_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 0 4 6)

theorem row_210_218 : RowResult ⟨210, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_210_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 0 4 6)

theorem row_210_219 : RowResult ⟨210, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_210_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 0 4 6)

theorem row_210_220 : RowResult ⟨210, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_210_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 0 4 6)

theorem row_210_221 : RowResult ⟨210, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_210_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 0 4 6)

theorem row_210_222 : RowResult ⟨210, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_210_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 0 4 6)

theorem row_210_223 : RowResult ⟨210, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_210_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 0 4 6)

theorem row_210_224 : RowResult ⟨210, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_210_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 0 4 6)

theorem row_210_225 : RowResult ⟨210, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_210_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_210_226 : RowResult ⟨210, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_210_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_210_227 : RowResult ⟨210, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_210_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_210_228 : RowResult ⟨210, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_210_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_210_229 : RowResult ⟨210, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_210_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_210_230 : RowResult ⟨210, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_210_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_210_231 : RowResult ⟨210, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_210_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 2 5 6)

theorem row_210_232 : RowResult ⟨210, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_210_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨194, by decide⟩, by decide⟩

theorem row_210_233 : RowResult ⟨210, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_210_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_210_234 : RowResult ⟨210, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_210_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨194, by decide⟩, by decide⟩

theorem row_210_235 : RowResult ⟨210, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_210_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 1 4 6)

theorem row_210_236 : RowResult ⟨210, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_210_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨194, by decide⟩, by decide⟩

theorem row_210_237 : RowResult ⟨210, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_210_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨196, by decide⟩, by decide⟩

theorem row_210_238 : RowResult ⟨210, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_210_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 2 4 6)

theorem row_210_239 : RowResult ⟨210, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_210_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_210_240 : RowResult ⟨210, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_210_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 1 4 7)

theorem row_210_241 : RowResult ⟨210, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_210_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 2 4 7)

theorem row_210_242 : RowResult ⟨210, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_210_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨191, by decide⟩, by decide⟩

theorem row_210_243 : RowResult ⟨210, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_210_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
