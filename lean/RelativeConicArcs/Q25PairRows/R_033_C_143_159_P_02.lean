import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_33_143 : RowResult ⟨33, by decide⟩ ⟨143, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_144 : RowResult ⟨33, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_33_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_145 : RowResult ⟨33, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_33_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_33_146 : RowResult ⟨33, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_33_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_147 : RowResult ⟨33, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_33_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 2 5 6)

theorem row_33_148 : RowResult ⟨33, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_33_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 1 4 7)

theorem row_33_149 : RowResult ⟨33, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_33_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_33_150 : RowResult ⟨33, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_33_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_33_151 : RowResult ⟨33, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_33_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_33_152 : RowResult ⟨33, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_33_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_33_153 : RowResult ⟨33, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_33_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_33_154 : RowResult ⟨33, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_33_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_33_155 : RowResult ⟨33, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_33_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_33_156 : RowResult ⟨33, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_33_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_157 : RowResult ⟨33, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_33_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_158 : RowResult ⟨33, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_33_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 1 4 6)

theorem row_33_159 : RowResult ⟨33, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_33_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
