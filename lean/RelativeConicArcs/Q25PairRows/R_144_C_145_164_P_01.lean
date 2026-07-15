import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_144_145 : RowResult ⟨144, by decide⟩ ⟨145, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 0 4 6)

theorem row_144_146 : RowResult ⟨144, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_144_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 0 4 6)

theorem row_144_147 : RowResult ⟨144, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_144_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 0 4 6)

theorem row_144_148 : RowResult ⟨144, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_144_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 0 4 6)

theorem row_144_149 : RowResult ⟨144, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_144_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 0 4 6)

theorem row_144_150 : RowResult ⟨144, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_144_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_144_151 : RowResult ⟨144, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_144_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_144_152 : RowResult ⟨144, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_144_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_144_153 : RowResult ⟨144, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_144_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_144_154 : RowResult ⟨144, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_144_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_144_155 : RowResult ⟨144, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_144_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_144_156 : RowResult ⟨144, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_144_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 2 4 6)

theorem row_144_157 : RowResult ⟨144, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_144_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_144_158 : RowResult ⟨144, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_144_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_144_159 : RowResult ⟨144, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_144_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_144_160 : RowResult ⟨144, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_144_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_144_161 : RowResult ⟨144, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_144_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_144_162 : RowResult ⟨144, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_144_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_144_163 : RowResult ⟨144, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_144_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_144_164 : RowResult ⟨144, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_144_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
