import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_115_187 : RowResult ⟨115, by decide⟩ ⟨187, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_115_188 : RowResult ⟨115, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_115_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_115_189 : RowResult ⟨115, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_115_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_115_190 : RowResult ⟨115, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_115_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 1 4 6)

theorem row_115_191 : RowResult ⟨115, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_115_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_115_192 : RowResult ⟨115, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_115_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_115_193 : RowResult ⟨115, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_115_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_115_194 : RowResult ⟨115, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_115_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_115_195 : RowResult ⟨115, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_115_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
