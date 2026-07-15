import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_87_222 : RowResult ⟨87, by decide⟩ ⟨222, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_87_223 : RowResult ⟨87, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_87_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_87_224 : RowResult ⟨87, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_87_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_87_225 : RowResult ⟨87, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_87_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_87_226 : RowResult ⟨87, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_87_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_87_227 : RowResult ⟨87, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_87_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_87_228 : RowResult ⟨87, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_87_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_87_229 : RowResult ⟨87, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_87_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_87_230 : RowResult ⟨87, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_87_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_87_231 : RowResult ⟨87, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_87_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_87_232 : RowResult ⟨87, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_87_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨221, by decide⟩, by decide⟩

theorem row_87_233 : RowResult ⟨87, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_87_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
