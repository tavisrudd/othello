import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_142_143 : RowResult ⟨142, by decide⟩ ⟨143, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 0 4 6)

theorem row_142_144 : RowResult ⟨142, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_142_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 0 4 6)

theorem row_142_145 : RowResult ⟨142, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_142_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 0 4 6)

theorem row_142_146 : RowResult ⟨142, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_142_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 0 4 6)

theorem row_142_147 : RowResult ⟨142, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_142_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 0 4 6)

theorem row_142_148 : RowResult ⟨142, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_142_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 0 4 6)

theorem row_142_149 : RowResult ⟨142, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_142_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 0 4 6)

theorem row_142_150 : RowResult ⟨142, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_142_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_142_151 : RowResult ⟨142, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_142_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_142_152 : RowResult ⟨142, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_142_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_142_153 : RowResult ⟨142, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_142_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_142_154 : RowResult ⟨142, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_142_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_142_155 : RowResult ⟨142, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_142_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_142_156 : RowResult ⟨142, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_142_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 2 4 7)

theorem row_142_157 : RowResult ⟨142, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_142_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_142_158 : RowResult ⟨142, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_142_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_142_159 : RowResult ⟨142, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_142_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_142_160 : RowResult ⟨142, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_142_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_142_161 : RowResult ⟨142, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_142_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_142_162 : RowResult ⟨142, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_142_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 1 4 7)

theorem row_142_163 : RowResult ⟨142, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_142_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_142_164 : RowResult ⟨142, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_142_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
