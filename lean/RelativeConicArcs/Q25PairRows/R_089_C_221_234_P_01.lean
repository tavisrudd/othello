import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_89_221 : RowResult ⟨89, by decide⟩ ⟨221, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_89_222 : RowResult ⟨89, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_89_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨40, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_89_223 : RowResult ⟨89, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_89_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_89_224 : RowResult ⟨89, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_89_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_89_225 : RowResult ⟨89, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_89_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_89_226 : RowResult ⟨89, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_89_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_89_227 : RowResult ⟨89, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_89_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_89_228 : RowResult ⟨89, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_89_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_89_229 : RowResult ⟨89, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_89_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_89_230 : RowResult ⟨89, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_89_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_89_231 : RowResult ⟨89, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_89_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_89_232 : RowResult ⟨89, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_89_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨216, by decide⟩, by decide⟩

theorem row_89_233 : RowResult ⟨89, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_89_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 2 4 6)

theorem row_89_234 : RowResult ⟨89, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_89_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
