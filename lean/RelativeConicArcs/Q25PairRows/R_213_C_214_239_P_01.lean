import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_213_214 : RowResult ⟨213, by decide⟩ ⟨214, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 0 4 6)

theorem row_213_215 : RowResult ⟨213, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_213_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 0 4 6)

theorem row_213_216 : RowResult ⟨213, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_213_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 0 4 6)

theorem row_213_217 : RowResult ⟨213, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_213_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 0 4 6)

theorem row_213_218 : RowResult ⟨213, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_213_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 0 4 6)

theorem row_213_219 : RowResult ⟨213, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_213_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 0 4 6)

theorem row_213_220 : RowResult ⟨213, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_213_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 0 4 6)

theorem row_213_221 : RowResult ⟨213, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_213_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 0 4 6)

theorem row_213_222 : RowResult ⟨213, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_213_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 0 4 6)

theorem row_213_223 : RowResult ⟨213, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_213_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 0 4 6)

theorem row_213_224 : RowResult ⟨213, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_213_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 0 4 6)

theorem row_213_225 : RowResult ⟨213, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_213_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_213_226 : RowResult ⟨213, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_213_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_213_227 : RowResult ⟨213, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_213_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_213_228 : RowResult ⟨213, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_213_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_213_229 : RowResult ⟨213, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_213_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_213_230 : RowResult ⟨213, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_213_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_213_231 : RowResult ⟨213, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_213_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_213_232 : RowResult ⟨213, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_213_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨194, by decide⟩, by decide⟩

theorem row_213_233 : RowResult ⟨213, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_213_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_213_234 : RowResult ⟨213, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_213_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨197, by decide⟩, by decide⟩

theorem row_213_235 : RowResult ⟨213, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_213_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_213_236 : RowResult ⟨213, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_213_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨197, by decide⟩, by decide⟩

theorem row_213_237 : RowResult ⟨213, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_213_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 2 5 7)

theorem row_213_238 : RowResult ⟨213, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_213_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 1 4 6)

theorem row_213_239 : RowResult ⟨213, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_213_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
