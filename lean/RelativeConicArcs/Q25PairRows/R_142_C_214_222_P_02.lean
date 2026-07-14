import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_142_214 : RowResult ⟨142, by decide⟩ ⟨214, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_142_215 : RowResult ⟨142, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_142_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 2 5 6)

theorem row_142_216 : RowResult ⟨142, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_142_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_142_217 : RowResult ⟨142, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_142_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 1 4 6)

theorem row_142_218 : RowResult ⟨142, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_142_217
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_142_219 : RowResult ⟨142, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_142_218
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_142_220 : RowResult ⟨142, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_142_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_142_221 : RowResult ⟨142, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_142_220
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_142_222 : RowResult ⟨142, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_142_221
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
