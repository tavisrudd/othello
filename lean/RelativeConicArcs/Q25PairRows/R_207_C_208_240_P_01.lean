import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_207_208 : RowResult ⟨207, by decide⟩ ⟨208, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 0 4 6)

theorem row_207_209 : RowResult ⟨207, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_207_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 0 4 6)

theorem row_207_210 : RowResult ⟨207, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_207_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 0 4 6)

theorem row_207_211 : RowResult ⟨207, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_207_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 0 4 6)

theorem row_207_212 : RowResult ⟨207, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_207_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 0 4 6)

theorem row_207_213 : RowResult ⟨207, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_207_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 0 4 6)

theorem row_207_214 : RowResult ⟨207, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_207_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 0 4 6)

theorem row_207_215 : RowResult ⟨207, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_207_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 0 4 6)

theorem row_207_216 : RowResult ⟨207, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_207_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 0 4 6)

theorem row_207_217 : RowResult ⟨207, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_207_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 0 4 6)

theorem row_207_218 : RowResult ⟨207, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_207_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 0 4 6)

theorem row_207_219 : RowResult ⟨207, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_207_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 0 4 6)

theorem row_207_220 : RowResult ⟨207, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_207_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 0 4 6)

theorem row_207_221 : RowResult ⟨207, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_207_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 0 4 6)

theorem row_207_222 : RowResult ⟨207, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_207_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 0 4 6)

theorem row_207_223 : RowResult ⟨207, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_207_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 0 4 6)

theorem row_207_224 : RowResult ⟨207, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_207_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 0 4 6)

theorem row_207_225 : RowResult ⟨207, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_207_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_207_226 : RowResult ⟨207, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_207_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_207_227 : RowResult ⟨207, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_207_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_207_228 : RowResult ⟨207, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_207_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_207_229 : RowResult ⟨207, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_207_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_207_230 : RowResult ⟨207, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_207_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_207_231 : RowResult ⟨207, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_207_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_207_232 : RowResult ⟨207, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_207_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 4 6)

theorem row_207_233 : RowResult ⟨207, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_207_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 2 5 7)

theorem row_207_234 : RowResult ⟨207, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_207_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_207_235 : RowResult ⟨207, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_207_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_207_236 : RowResult ⟨207, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_207_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_207_237 : RowResult ⟨207, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_207_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 4 5 6)

theorem row_207_238 : RowResult ⟨207, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_207_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_207_239 : RowResult ⟨207, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_207_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_207_240 : RowResult ⟨207, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_207_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
