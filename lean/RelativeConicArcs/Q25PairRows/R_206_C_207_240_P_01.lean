import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_206_207 : RowResult ⟨206, by decide⟩ ⟨207, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 0 4 6)

theorem row_206_208 : RowResult ⟨206, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_206_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 0 4 6)

theorem row_206_209 : RowResult ⟨206, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_206_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 0 4 6)

theorem row_206_210 : RowResult ⟨206, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_206_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 0 4 6)

theorem row_206_211 : RowResult ⟨206, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_206_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 0 4 6)

theorem row_206_212 : RowResult ⟨206, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_206_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 0 4 6)

theorem row_206_213 : RowResult ⟨206, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_206_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 0 4 6)

theorem row_206_214 : RowResult ⟨206, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_206_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 0 4 6)

theorem row_206_215 : RowResult ⟨206, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_206_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 0 4 6)

theorem row_206_216 : RowResult ⟨206, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_206_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 0 4 6)

theorem row_206_217 : RowResult ⟨206, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_206_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 0 4 6)

theorem row_206_218 : RowResult ⟨206, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_206_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 0 4 6)

theorem row_206_219 : RowResult ⟨206, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_206_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 0 4 6)

theorem row_206_220 : RowResult ⟨206, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_206_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 0 4 6)

theorem row_206_221 : RowResult ⟨206, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_206_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 0 4 6)

theorem row_206_222 : RowResult ⟨206, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_206_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 0 4 6)

theorem row_206_223 : RowResult ⟨206, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_206_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 0 4 6)

theorem row_206_224 : RowResult ⟨206, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_206_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 0 4 6)

theorem row_206_225 : RowResult ⟨206, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_206_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_206_226 : RowResult ⟨206, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_206_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_206_227 : RowResult ⟨206, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_206_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_206_228 : RowResult ⟨206, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_206_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_206_229 : RowResult ⟨206, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_206_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_206_230 : RowResult ⟨206, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_206_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_206_231 : RowResult ⟨206, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_206_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 1 4 6)

theorem row_206_232 : RowResult ⟨206, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_206_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨198, by decide⟩, by decide⟩

theorem row_206_233 : RowResult ⟨206, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_206_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨197, by decide⟩, by decide⟩

theorem row_206_234 : RowResult ⟨206, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_206_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨197, by decide⟩, by decide⟩

theorem row_206_235 : RowResult ⟨206, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_206_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_206_236 : RowResult ⟨206, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_206_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 4 5 6)

theorem row_206_237 : RowResult ⟨206, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_206_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_206_238 : RowResult ⟨206, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_206_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_206_239 : RowResult ⟨206, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_206_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_206_240 : RowResult ⟨206, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_206_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
