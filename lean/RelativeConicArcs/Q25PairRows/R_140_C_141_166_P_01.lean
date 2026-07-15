import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_140_141 : RowResult ⟨140, by decide⟩ ⟨141, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 0 4 6)

theorem row_140_142 : RowResult ⟨140, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_140_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 0 4 6)

theorem row_140_143 : RowResult ⟨140, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_140_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 0 4 6)

theorem row_140_144 : RowResult ⟨140, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_140_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 0 4 6)

theorem row_140_145 : RowResult ⟨140, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_140_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 0 4 6)

theorem row_140_146 : RowResult ⟨140, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_140_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 0 4 6)

theorem row_140_147 : RowResult ⟨140, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_140_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 0 4 6)

theorem row_140_148 : RowResult ⟨140, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_140_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 0 4 6)

theorem row_140_149 : RowResult ⟨140, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_140_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 0 4 6)

theorem row_140_150 : RowResult ⟨140, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_140_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_140_151 : RowResult ⟨140, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_140_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_140_152 : RowResult ⟨140, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_140_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_140_153 : RowResult ⟨140, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_140_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_140_154 : RowResult ⟨140, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_140_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_140_155 : RowResult ⟨140, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_140_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_140_156 : RowResult ⟨140, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_140_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_140_157 : RowResult ⟨140, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_140_156
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_140_158 : RowResult ⟨140, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_140_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_140_159 : RowResult ⟨140, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_140_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_140_160 : RowResult ⟨140, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_140_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 1 4 7)

theorem row_140_161 : RowResult ⟨140, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_140_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_140_162 : RowResult ⟨140, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_140_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_140_163 : RowResult ⟨140, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_140_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 2 5 6)

theorem row_140_164 : RowResult ⟨140, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_140_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 2 4 6)

theorem row_140_165 : RowResult ⟨140, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_140_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 1 4 6)

theorem row_140_166 : RowResult ⟨140, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_140_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
