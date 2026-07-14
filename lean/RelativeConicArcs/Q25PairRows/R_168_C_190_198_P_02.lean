import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_168_190 : RowResult ⟨168, by decide⟩ ⟨190, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_168_191 : RowResult ⟨168, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_168_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_168_192 : RowResult ⟨168, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_168_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_168_193 : RowResult ⟨168, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_168_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 1 4 6)

theorem row_168_194 : RowResult ⟨168, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_168_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_168_195 : RowResult ⟨168, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_168_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_168_196 : RowResult ⟨168, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_168_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 2 4 6)

theorem row_168_197 : RowResult ⟨168, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_168_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_168_198 : RowResult ⟨168, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_168_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
