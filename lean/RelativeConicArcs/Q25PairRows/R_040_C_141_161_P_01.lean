import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_40_141 : RowResult ⟨40, by decide⟩ ⟨141, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 2 5 7)

theorem row_40_142 : RowResult ⟨40, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_40_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_40_143 : RowResult ⟨40, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_40_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 4 5 6)

theorem row_40_144 : RowResult ⟨40, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_40_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 2 4 6)

theorem row_40_145 : RowResult ⟨40, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_40_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_40_146 : RowResult ⟨40, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_40_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 2 5 6)

theorem row_40_147 : RowResult ⟨40, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_40_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_40_148 : RowResult ⟨40, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_40_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_40_149 : RowResult ⟨40, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_40_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_40_150 : RowResult ⟨40, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_40_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_40_151 : RowResult ⟨40, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_40_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_40_152 : RowResult ⟨40, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_40_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_40_153 : RowResult ⟨40, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_40_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_40_154 : RowResult ⟨40, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_40_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_40_155 : RowResult ⟨40, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_40_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_40_156 : RowResult ⟨40, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_40_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 2 4 6)

theorem row_40_157 : RowResult ⟨40, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_40_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_40_158 : RowResult ⟨40, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_40_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_40_159 : RowResult ⟨40, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_40_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 2 5 6)

theorem row_40_160 : RowResult ⟨40, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_40_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 1 4 7)

theorem row_40_161 : RowResult ⟨40, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_40_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
