import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_110_191 : RowResult ⟨110, by decide⟩ ⟨191, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_110_192 : RowResult ⟨110, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_110_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_110_193 : RowResult ⟨110, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_110_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_110_194 : RowResult ⟨110, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_110_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_110_195 : RowResult ⟨110, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_110_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_110_196 : RowResult ⟨110, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_110_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_110_197 : RowResult ⟨110, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_110_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 4 5 6)

theorem row_110_198 : RowResult ⟨110, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_110_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
