import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_217_218 : RowResult ⟨217, by decide⟩ ⟨218, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 0 4 6)

theorem row_217_219 : RowResult ⟨217, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_217_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 0 4 6)

theorem row_217_220 : RowResult ⟨217, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_217_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 0 4 6)

theorem row_217_221 : RowResult ⟨217, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_217_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 0 4 6)

theorem row_217_222 : RowResult ⟨217, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_217_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 0 4 6)

theorem row_217_223 : RowResult ⟨217, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_217_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 0 4 6)

theorem row_217_224 : RowResult ⟨217, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_217_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 0 4 6)

theorem row_217_225 : RowResult ⟨217, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_217_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_217_226 : RowResult ⟨217, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_217_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_217_227 : RowResult ⟨217, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_217_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_217_228 : RowResult ⟨217, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_217_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_217_229 : RowResult ⟨217, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_217_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_217_230 : RowResult ⟨217, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_217_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_217_231 : RowResult ⟨217, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_217_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_217_232 : RowResult ⟨217, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_217_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 4 5 6)

theorem row_217_233 : RowResult ⟨217, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_217_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 2 4 6)

theorem row_217_234 : RowResult ⟨217, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_217_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 4 7)

theorem row_217_235 : RowResult ⟨217, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_217_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 5 7)

theorem row_217_236 : RowResult ⟨217, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_217_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨198, by decide⟩, by decide⟩

theorem row_217_237 : RowResult ⟨217, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_217_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 4 7)

theorem row_217_238 : RowResult ⟨217, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_217_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨198, by decide⟩, by decide⟩

theorem row_217_239 : RowResult ⟨217, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_217_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_217_240 : RowResult ⟨217, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_217_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_217_241 : RowResult ⟨217, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_217_240
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨198, by decide⟩, by decide⟩

theorem row_217_242 : RowResult ⟨217, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_217_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 1 4 6)

theorem row_217_243 : RowResult ⟨217, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_217_242
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
