import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_144_221 : RowResult ⟨144, by decide⟩ ⟨221, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_144_222 : RowResult ⟨144, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_144_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 4 5 6)

theorem row_144_223 : RowResult ⟨144, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_144_222
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_144_224 : RowResult ⟨144, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_144_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_144_225 : RowResult ⟨144, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_144_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_144_226 : RowResult ⟨144, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_144_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_144_227 : RowResult ⟨144, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_144_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_144_228 : RowResult ⟨144, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_144_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_144_229 : RowResult ⟨144, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_144_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_144_230 : RowResult ⟨144, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_144_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_144_231 : RowResult ⟨144, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_144_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_144_232 : RowResult ⟨144, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_144_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨216, by decide⟩, by decide⟩

theorem row_144_233 : RowResult ⟨144, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_144_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨224, by decide⟩, by decide⟩

theorem row_144_234 : RowResult ⟨144, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_144_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
