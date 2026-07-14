import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_83_143 : RowResult ⟨83, by decide⟩ ⟨143, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_83_144 : RowResult ⟨83, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_83_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_83_145 : RowResult ⟨83, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_83_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_83_146 : RowResult ⟨83, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_83_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 2 4 7)

theorem row_83_147 : RowResult ⟨83, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_83_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_83_148 : RowResult ⟨83, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_83_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 1 4 7)

theorem row_83_149 : RowResult ⟨83, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_83_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_83_150 : RowResult ⟨83, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_83_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_83_151 : RowResult ⟨83, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_83_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_83_152 : RowResult ⟨83, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_83_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_83_153 : RowResult ⟨83, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_83_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_83_154 : RowResult ⟨83, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_83_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_83_155 : RowResult ⟨83, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_83_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_83_156 : RowResult ⟨83, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_83_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_83_157 : RowResult ⟨83, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_83_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_83_158 : RowResult ⟨83, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_83_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
