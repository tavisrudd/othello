import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_123_139 : RowResult ⟨123, by decide⟩ ⟨139, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_123_140 : RowResult ⟨123, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_123_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_123_141 : RowResult ⟨123, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_123_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 2 4 6)

theorem row_123_142 : RowResult ⟨123, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_123_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_123_143 : RowResult ⟨123, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_123_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 4 5 6)

theorem row_123_144 : RowResult ⟨123, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_123_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 2 4 7)

theorem row_123_145 : RowResult ⟨123, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_123_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_123_146 : RowResult ⟨123, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_123_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_123_147 : RowResult ⟨123, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_123_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_123_148 : RowResult ⟨123, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_123_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 1 4 6)

theorem row_123_149 : RowResult ⟨123, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_123_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 2 5 6)

theorem row_123_150 : RowResult ⟨123, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_123_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_123_151 : RowResult ⟨123, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_123_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_123_152 : RowResult ⟨123, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_123_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_123_153 : RowResult ⟨123, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_123_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_123_154 : RowResult ⟨123, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_123_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_123_155 : RowResult ⟨123, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_123_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_123_156 : RowResult ⟨123, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_123_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
