import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_142_223 : RowResult ⟨142, by decide⟩ ⟨223, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_142_224 : RowResult ⟨142, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_142_223
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_142_225 : RowResult ⟨142, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_142_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_142_226 : RowResult ⟨142, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_142_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_142_227 : RowResult ⟨142, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_142_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_142_228 : RowResult ⟨142, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_142_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_142_229 : RowResult ⟨142, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_142_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_142_230 : RowResult ⟨142, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_142_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_142_231 : RowResult ⟨142, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_142_230
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_142_232 : RowResult ⟨142, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_142_231
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_142_233 : RowResult ⟨142, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_142_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_142_234 : RowResult ⟨142, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_142_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
