import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_122_139 : RowResult ⟨122, by decide⟩ ⟨139, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_122_140 : RowResult ⟨122, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_122_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_122_141 : RowResult ⟨122, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_122_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 2 5 6)

theorem row_122_142 : RowResult ⟨122, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_122_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 4 5 6)

theorem row_122_143 : RowResult ⟨122, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_122_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_122_144 : RowResult ⟨122, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_122_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 2 5 7)

theorem row_122_145 : RowResult ⟨122, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_122_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_122_146 : RowResult ⟨122, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_122_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_122_147 : RowResult ⟨122, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_122_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 1 4 6)

theorem row_122_148 : RowResult ⟨122, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_122_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 2 4 7)

theorem row_122_149 : RowResult ⟨122, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_122_148
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_122_150 : RowResult ⟨122, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_122_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_122_151 : RowResult ⟨122, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_122_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_122_152 : RowResult ⟨122, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_122_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_122_153 : RowResult ⟨122, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_122_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_122_154 : RowResult ⟨122, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_122_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_122_155 : RowResult ⟨122, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_122_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_122_156 : RowResult ⟨122, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_122_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_122_157 : RowResult ⟨122, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_122_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 1 4 7)

theorem row_122_158 : RowResult ⟨122, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_122_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
