import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_94_190 : RowResult ⟨94, by decide⟩ ⟨190, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_94_191 : RowResult ⟨94, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_94_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_94_192 : RowResult ⟨94, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_94_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 4 5 6)

theorem row_94_193 : RowResult ⟨94, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_94_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 2 4 7)

theorem row_94_194 : RowResult ⟨94, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_94_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
