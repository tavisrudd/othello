import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_222_223 : RowResult ⟨222, by decide⟩ ⟨223, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 0 4 6)

theorem row_222_224 : RowResult ⟨222, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_222_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 0 4 6)

theorem row_222_225 : RowResult ⟨222, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_222_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_222_226 : RowResult ⟨222, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_222_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_222_227 : RowResult ⟨222, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_222_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_222_228 : RowResult ⟨222, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_222_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_222_229 : RowResult ⟨222, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_222_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_222_230 : RowResult ⟨222, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_222_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_222_231 : RowResult ⟨222, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_222_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨192, by decide⟩, by decide⟩

theorem row_222_232 : RowResult ⟨222, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_222_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 4 7)

theorem row_222_233 : RowResult ⟨222, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_222_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_222_234 : RowResult ⟨222, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_222_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨192, by decide⟩, by decide⟩

theorem row_222_235 : RowResult ⟨222, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_222_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨196, by decide⟩, by decide⟩

theorem row_222_236 : RowResult ⟨222, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_222_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 2 4 6)

theorem row_222_237 : RowResult ⟨222, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_222_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_222_238 : RowResult ⟨222, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_222_237
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨199, by decide⟩, by decide⟩

theorem row_222_239 : RowResult ⟨222, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_222_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
