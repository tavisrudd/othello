import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_89_141 : RowResult ⟨89, by decide⟩ ⟨141, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_89_142 : RowResult ⟨89, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_89_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_89_143 : RowResult ⟨89, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_89_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_89_144 : RowResult ⟨89, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_89_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 1 4 7)

theorem row_89_145 : RowResult ⟨89, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_89_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_89_146 : RowResult ⟨89, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_89_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 2 5 7)

theorem row_89_147 : RowResult ⟨89, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_89_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_89_148 : RowResult ⟨89, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_89_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_89_149 : RowResult ⟨89, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_89_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_89_150 : RowResult ⟨89, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_89_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_89_151 : RowResult ⟨89, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_89_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_89_152 : RowResult ⟨89, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_89_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_89_153 : RowResult ⟨89, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_89_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_89_154 : RowResult ⟨89, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_89_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_89_155 : RowResult ⟨89, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_89_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_89_156 : RowResult ⟨89, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_89_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 4 5 6)

theorem row_89_157 : RowResult ⟨89, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_89_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 2 4 7)

theorem row_89_158 : RowResult ⟨89, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_89_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
