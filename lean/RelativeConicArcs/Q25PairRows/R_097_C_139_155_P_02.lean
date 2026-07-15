import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_97_139 : RowResult ⟨97, by decide⟩ ⟨139, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_97_140 : RowResult ⟨97, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_97_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_97_141 : RowResult ⟨97, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_97_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 2 4 6)

theorem row_97_142 : RowResult ⟨97, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_97_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_97_143 : RowResult ⟨97, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_97_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_97_144 : RowResult ⟨97, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_97_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 2 4 7)

theorem row_97_145 : RowResult ⟨97, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_97_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_97_146 : RowResult ⟨97, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_97_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_97_147 : RowResult ⟨97, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_97_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 1 4 6)

theorem row_97_148 : RowResult ⟨97, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_97_147
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_97_149 : RowResult ⟨97, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_97_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 4 5 6)

theorem row_97_150 : RowResult ⟨97, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_97_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_97_151 : RowResult ⟨97, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_97_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_97_152 : RowResult ⟨97, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_97_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_97_153 : RowResult ⟨97, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_97_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_97_154 : RowResult ⟨97, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_97_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_97_155 : RowResult ⟨97, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_97_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
