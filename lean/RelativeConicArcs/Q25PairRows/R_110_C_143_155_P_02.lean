import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_110_143 : RowResult ⟨110, by decide⟩ ⟨143, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_110_144 : RowResult ⟨110, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_110_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_110_145 : RowResult ⟨110, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_110_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_110_146 : RowResult ⟨110, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_110_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_110_147 : RowResult ⟨110, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_110_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_110_148 : RowResult ⟨110, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_110_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_110_149 : RowResult ⟨110, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_110_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_110_150 : RowResult ⟨110, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_110_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_110_151 : RowResult ⟨110, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_110_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_110_152 : RowResult ⟨110, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_110_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_110_153 : RowResult ⟨110, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_110_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_110_154 : RowResult ⟨110, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_110_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_110_155 : RowResult ⟨110, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_110_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
