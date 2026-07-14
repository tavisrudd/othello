import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_121_143 : RowResult ⟨121, by decide⟩ ⟨143, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_121_144 : RowResult ⟨121, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_121_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_121_145 : RowResult ⟨121, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_121_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_121_146 : RowResult ⟨121, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_121_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 1 4 6)

theorem row_121_147 : RowResult ⟨121, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_121_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_121_148 : RowResult ⟨121, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_121_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_121_149 : RowResult ⟨121, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_121_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_121_150 : RowResult ⟨121, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_121_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_121_151 : RowResult ⟨121, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_121_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_121_152 : RowResult ⟨121, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_121_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_121_153 : RowResult ⟨121, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_121_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_121_154 : RowResult ⟨121, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_121_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_121_155 : RowResult ⟨121, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_121_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_121_156 : RowResult ⟨121, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_121_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 1 4 7)

theorem row_121_157 : RowResult ⟨121, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_121_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_121_158 : RowResult ⟨121, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_121_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
