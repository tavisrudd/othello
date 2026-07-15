import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_106_142 : RowResult ⟨106, by decide⟩ ⟨142, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_106_143 : RowResult ⟨106, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_106_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_106_144 : RowResult ⟨106, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_106_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_106_145 : RowResult ⟨106, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_106_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_106_146 : RowResult ⟨106, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_106_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 1 4 7)

theorem row_106_147 : RowResult ⟨106, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_106_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_106_148 : RowResult ⟨106, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_106_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_106_149 : RowResult ⟨106, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_106_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_106_150 : RowResult ⟨106, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_106_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_106_151 : RowResult ⟨106, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_106_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_106_152 : RowResult ⟨106, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_106_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_106_153 : RowResult ⟨106, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_106_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_106_154 : RowResult ⟨106, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_106_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_106_155 : RowResult ⟨106, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_106_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_106_156 : RowResult ⟨106, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_106_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 1 4 6)

theorem row_106_157 : RowResult ⟨106, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_106_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 4 5 6)

theorem row_106_158 : RowResult ⟨106, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_106_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_106_159 : RowResult ⟨106, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_106_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
