import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_131_222 : RowResult ⟨131, by decide⟩ ⟨222, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_131_223 : RowResult ⟨131, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_131_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_131_224 : RowResult ⟨131, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_131_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 2 4 6)

theorem row_131_225 : RowResult ⟨131, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_131_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_131_226 : RowResult ⟨131, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_131_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_131_227 : RowResult ⟨131, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_131_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_131_228 : RowResult ⟨131, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_131_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_131_229 : RowResult ⟨131, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_131_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_131_230 : RowResult ⟨131, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_131_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_131_231 : RowResult ⟨131, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_131_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
