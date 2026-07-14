import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_34_143 : RowResult ⟨34, by decide⟩ ⟨143, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_34_144 : RowResult ⟨34, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_34_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_34_145 : RowResult ⟨34, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_34_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_34_146 : RowResult ⟨34, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_34_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_34_147 : RowResult ⟨34, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_34_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 2 5 7)

theorem row_34_148 : RowResult ⟨34, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_34_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_34_149 : RowResult ⟨34, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_34_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 1 4 7)

theorem row_34_150 : RowResult ⟨34, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_34_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_34_151 : RowResult ⟨34, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_34_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_34_152 : RowResult ⟨34, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_34_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_34_153 : RowResult ⟨34, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_34_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_34_154 : RowResult ⟨34, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_34_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_34_155 : RowResult ⟨34, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_34_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_34_156 : RowResult ⟨34, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_34_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_34_157 : RowResult ⟨34, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_34_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_34_158 : RowResult ⟨34, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_34_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_34_159 : RowResult ⟨34, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_34_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 1 4 6)

theorem row_34_160 : RowResult ⟨34, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_34_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
