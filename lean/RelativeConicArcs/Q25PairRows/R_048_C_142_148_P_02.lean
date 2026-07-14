import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_48_142 : RowResult ⟨48, by decide⟩ ⟨142, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_48_143 : RowResult ⟨48, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_48_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨196, by decide⟩, by decide⟩

theorem row_48_144 : RowResult ⟨48, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_48_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_48_145 : RowResult ⟨48, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_48_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_48_146 : RowResult ⟨48, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_48_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_48_147 : RowResult ⟨48, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_48_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 4 5 6)

theorem row_48_148 : RowResult ⟨48, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_48_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
