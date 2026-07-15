import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_215_216 : RowResult ⟨215, by decide⟩ ⟨216, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 0 4 6)

theorem row_215_217 : RowResult ⟨215, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_215_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 0 4 6)

theorem row_215_218 : RowResult ⟨215, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_215_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 0 4 6)

theorem row_215_219 : RowResult ⟨215, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_215_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 0 4 6)

theorem row_215_220 : RowResult ⟨215, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_215_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 0 4 6)

theorem row_215_221 : RowResult ⟨215, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_215_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 0 4 6)

theorem row_215_222 : RowResult ⟨215, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_215_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 0 4 6)

theorem row_215_223 : RowResult ⟨215, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_215_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 0 4 6)

theorem row_215_224 : RowResult ⟨215, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_215_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 0 4 6)

theorem row_215_225 : RowResult ⟨215, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_215_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_215_226 : RowResult ⟨215, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_215_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_215_227 : RowResult ⟨215, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_215_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_215_228 : RowResult ⟨215, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_215_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_215_229 : RowResult ⟨215, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_215_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_215_230 : RowResult ⟨215, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_215_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_215_231 : RowResult ⟨215, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_215_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨198, by decide⟩, by decide⟩

theorem row_215_232 : RowResult ⟨215, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_215_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨198, by decide⟩, by decide⟩

theorem row_215_233 : RowResult ⟨215, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_215_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 2 5 6)

theorem row_215_234 : RowResult ⟨215, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_215_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 5 7)

theorem row_215_235 : RowResult ⟨215, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_215_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 1 4 7)

theorem row_215_236 : RowResult ⟨215, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_215_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨194, by decide⟩, by decide⟩

theorem row_215_237 : RowResult ⟨215, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_215_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 2 4 7)

theorem row_215_238 : RowResult ⟨215, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_215_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_215_239 : RowResult ⟨215, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_215_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_215_240 : RowResult ⟨215, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_215_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 1 4 6)

theorem row_215_241 : RowResult ⟨215, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_215_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 2 4 6)

theorem row_215_242 : RowResult ⟨215, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_215_241
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨198, by decide⟩, by decide⟩

theorem row_215_243 : RowResult ⟨215, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_215_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
