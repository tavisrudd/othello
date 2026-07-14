import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_81_142 : RowResult ⟨81, by decide⟩ ⟨142, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_81_143 : RowResult ⟨81, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_81_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_81_144 : RowResult ⟨81, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_81_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_81_145 : RowResult ⟨81, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_81_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_81_146 : RowResult ⟨81, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_81_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 1 4 7)

theorem row_81_147 : RowResult ⟨81, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_81_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 2 4 7)

theorem row_81_148 : RowResult ⟨81, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_81_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_81_149 : RowResult ⟨81, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_81_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 2 5 7)

theorem row_81_150 : RowResult ⟨81, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_81_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_81_151 : RowResult ⟨81, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_81_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_81_152 : RowResult ⟨81, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_81_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_81_153 : RowResult ⟨81, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_81_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_81_154 : RowResult ⟨81, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_81_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_81_155 : RowResult ⟨81, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_81_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_81_156 : RowResult ⟨81, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_81_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 1 4 6)

theorem row_81_157 : RowResult ⟨81, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_81_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_81_158 : RowResult ⟨81, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_81_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_81_159 : RowResult ⟨81, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_81_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
