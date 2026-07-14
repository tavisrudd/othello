import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_142_189 : RowResult ⟨142, by decide⟩ ⟨189, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_142_190 : RowResult ⟨142, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_142_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_142_191 : RowResult ⟨142, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_142_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 4 5 6)

theorem row_142_192 : RowResult ⟨142, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_142_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 1 4 6)

theorem row_142_193 : RowResult ⟨142, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_142_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_142_194 : RowResult ⟨142, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_142_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_142_195 : RowResult ⟨142, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_142_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_142_196 : RowResult ⟨142, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_142_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_142_197 : RowResult ⟨142, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_142_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 2 4 6)

theorem row_142_198 : RowResult ⟨142, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_142_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
