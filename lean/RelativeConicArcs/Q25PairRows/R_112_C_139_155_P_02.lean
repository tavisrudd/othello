import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_112_139 : RowResult ⟨112, by decide⟩ ⟨139, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_112_140 : RowResult ⟨112, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_112_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_112_141 : RowResult ⟨112, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_112_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_112_142 : RowResult ⟨112, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_112_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 1 4 7)

theorem row_112_143 : RowResult ⟨112, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_112_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 2 4 6)

theorem row_112_144 : RowResult ⟨112, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_112_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_112_145 : RowResult ⟨112, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_112_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_112_146 : RowResult ⟨112, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_112_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 2 5 7)

theorem row_112_147 : RowResult ⟨112, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_112_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 4 5 6)

theorem row_112_148 : RowResult ⟨112, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_112_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_112_149 : RowResult ⟨112, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_112_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_112_150 : RowResult ⟨112, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_112_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_112_151 : RowResult ⟨112, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_112_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_112_152 : RowResult ⟨112, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_112_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_112_153 : RowResult ⟨112, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_112_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_112_154 : RowResult ⟨112, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_112_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_112_155 : RowResult ⟨112, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_112_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
