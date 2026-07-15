import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_42_219 : RowResult ⟨42, by decide⟩ ⟨219, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_42_220 : RowResult ⟨42, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_42_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_42_221 : RowResult ⟨42, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_42_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_42_222 : RowResult ⟨42, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_42_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_42_223 : RowResult ⟨42, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_42_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 4 5 6)

theorem row_42_224 : RowResult ⟨42, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_42_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 2 4 7)

theorem row_42_225 : RowResult ⟨42, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_42_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_42_226 : RowResult ⟨42, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_42_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_42_227 : RowResult ⟨42, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_42_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_42_228 : RowResult ⟨42, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_42_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_42_229 : RowResult ⟨42, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_42_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_42_230 : RowResult ⟨42, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_42_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_42_231 : RowResult ⟨42, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_42_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_42_232 : RowResult ⟨42, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_42_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 2 4 7)

theorem row_42_233 : RowResult ⟨42, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_42_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 2 5 6)

theorem row_42_234 : RowResult ⟨42, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_42_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 5 7)

theorem row_42_235 : RowResult ⟨42, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_42_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 4 6)

theorem row_42_236 : RowResult ⟨42, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_42_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_42_237 : RowResult ⟨42, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_42_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 4 7)

theorem row_42_238 : RowResult ⟨42, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_42_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨222, by decide⟩, by decide⟩

theorem row_42_239 : RowResult ⟨42, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_42_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
