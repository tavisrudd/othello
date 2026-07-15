import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_216_217 : RowResult ⟨216, by decide⟩ ⟨217, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 0 4 6)

theorem row_216_218 : RowResult ⟨216, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_216_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 0 4 6)

theorem row_216_219 : RowResult ⟨216, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_216_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 0 4 6)

theorem row_216_220 : RowResult ⟨216, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_216_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 0 4 6)

theorem row_216_221 : RowResult ⟨216, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_216_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 0 4 6)

theorem row_216_222 : RowResult ⟨216, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_216_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 0 4 6)

theorem row_216_223 : RowResult ⟨216, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_216_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 0 4 6)

theorem row_216_224 : RowResult ⟨216, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_216_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 0 4 6)

theorem row_216_225 : RowResult ⟨216, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_216_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_216_226 : RowResult ⟨216, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_216_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_216_227 : RowResult ⟨216, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_216_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_216_228 : RowResult ⟨216, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_216_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_216_229 : RowResult ⟨216, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_216_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_216_230 : RowResult ⟨216, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_216_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_216_231 : RowResult ⟨216, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_216_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 4 5 6)

theorem row_216_232 : RowResult ⟨216, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_216_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨196, by decide⟩, by decide⟩

theorem row_216_233 : RowResult ⟨216, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_216_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_216_234 : RowResult ⟨216, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_216_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨194, by decide⟩, by decide⟩

theorem row_216_235 : RowResult ⟨216, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_216_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_216_236 : RowResult ⟨216, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_216_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 4 7)

theorem row_216_237 : RowResult ⟨216, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_216_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 2 4 6)

theorem row_216_238 : RowResult ⟨216, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_216_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_216_239 : RowResult ⟨216, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_216_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_216_240 : RowResult ⟨216, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_216_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨197, by decide⟩, by decide⟩

theorem row_216_241 : RowResult ⟨216, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_216_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
