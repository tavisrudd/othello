import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_211_212 : RowResult ⟨211, by decide⟩ ⟨212, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 0 4 6)

theorem row_211_213 : RowResult ⟨211, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_211_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 0 4 6)

theorem row_211_214 : RowResult ⟨211, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_211_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 0 4 6)

theorem row_211_215 : RowResult ⟨211, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_211_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 0 4 6)

theorem row_211_216 : RowResult ⟨211, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_211_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 0 4 6)

theorem row_211_217 : RowResult ⟨211, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_211_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 0 4 6)

theorem row_211_218 : RowResult ⟨211, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_211_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 0 4 6)

theorem row_211_219 : RowResult ⟨211, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_211_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 0 4 6)

theorem row_211_220 : RowResult ⟨211, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_211_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 0 4 6)

theorem row_211_221 : RowResult ⟨211, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_211_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 0 4 6)

theorem row_211_222 : RowResult ⟨211, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_211_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 0 4 6)

theorem row_211_223 : RowResult ⟨211, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_211_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 0 4 6)

theorem row_211_224 : RowResult ⟨211, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_211_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 0 4 6)

theorem row_211_225 : RowResult ⟨211, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_211_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_211_226 : RowResult ⟨211, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_211_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_211_227 : RowResult ⟨211, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_211_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_211_228 : RowResult ⟨211, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_211_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_211_229 : RowResult ⟨211, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_211_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_211_230 : RowResult ⟨211, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_211_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_211_231 : RowResult ⟨211, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_211_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 2 5 7)

theorem row_211_232 : RowResult ⟨211, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_211_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨196, by decide⟩, by decide⟩

theorem row_211_233 : RowResult ⟨211, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_211_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨194, by decide⟩, by decide⟩

theorem row_211_234 : RowResult ⟨211, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_211_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 4 6)

theorem row_211_235 : RowResult ⟨211, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_211_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨197, by decide⟩, by decide⟩

theorem row_211_236 : RowResult ⟨211, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_211_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 4 6)

theorem row_211_237 : RowResult ⟨211, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_211_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨196, by decide⟩, by decide⟩

theorem row_211_238 : RowResult ⟨211, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_211_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨197, by decide⟩, by decide⟩

theorem row_211_239 : RowResult ⟨211, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_211_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

theorem row_211_240 : RowResult ⟨211, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_211_239
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨197, by decide⟩, by decide⟩

theorem row_211_241 : RowResult ⟨211, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_211_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
