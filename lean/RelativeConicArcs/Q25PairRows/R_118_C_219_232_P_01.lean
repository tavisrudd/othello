import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_118_219 : RowResult ⟨118, by decide⟩ ⟨219, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 4 5 6)

theorem row_118_220 : RowResult ⟨118, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_118_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_118_221 : RowResult ⟨118, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_118_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_118_222 : RowResult ⟨118, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_118_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_118_223 : RowResult ⟨118, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_118_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_118_224 : RowResult ⟨118, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_118_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_118_225 : RowResult ⟨118, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_118_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_118_226 : RowResult ⟨118, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_118_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_118_227 : RowResult ⟨118, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_118_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_118_228 : RowResult ⟨118, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_118_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_118_229 : RowResult ⟨118, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_118_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_118_230 : RowResult ⟨118, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_118_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_118_231 : RowResult ⟨118, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_118_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_118_232 : RowResult ⟨118, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_118_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
