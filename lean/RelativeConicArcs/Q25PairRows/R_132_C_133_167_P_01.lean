import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_132_133 : RowResult ⟨132, by decide⟩ ⟨133, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 0 4 6)

theorem row_132_134 : RowResult ⟨132, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_132_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 0 4 6)

theorem row_132_135 : RowResult ⟨132, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_132_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 0 4 6)

theorem row_132_136 : RowResult ⟨132, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_132_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 0 4 6)

theorem row_132_137 : RowResult ⟨132, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_132_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 0 4 6)

theorem row_132_138 : RowResult ⟨132, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_132_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 0 4 6)

theorem row_132_139 : RowResult ⟨132, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_132_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 0 4 6)

theorem row_132_140 : RowResult ⟨132, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_132_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 0 4 6)

theorem row_132_141 : RowResult ⟨132, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_132_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 0 4 6)

theorem row_132_142 : RowResult ⟨132, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_132_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 0 4 6)

theorem row_132_143 : RowResult ⟨132, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_132_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 0 4 6)

theorem row_132_144 : RowResult ⟨132, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_132_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 0 4 6)

theorem row_132_145 : RowResult ⟨132, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_132_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 0 4 6)

theorem row_132_146 : RowResult ⟨132, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_132_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 0 4 6)

theorem row_132_147 : RowResult ⟨132, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_132_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 0 4 6)

theorem row_132_148 : RowResult ⟨132, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_132_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 0 4 6)

theorem row_132_149 : RowResult ⟨132, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_132_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 0 4 6)

theorem row_132_150 : RowResult ⟨132, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_132_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_132_151 : RowResult ⟨132, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_132_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_132_152 : RowResult ⟨132, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_132_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_132_153 : RowResult ⟨132, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_132_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_132_154 : RowResult ⟨132, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_132_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_132_155 : RowResult ⟨132, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_132_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_132_156 : RowResult ⟨132, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_132_155
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_132_157 : RowResult ⟨132, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_132_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 1 4 6)

theorem row_132_158 : RowResult ⟨132, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_132_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 6)

theorem row_132_159 : RowResult ⟨132, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_132_158
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_132_160 : RowResult ⟨132, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_132_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_132_161 : RowResult ⟨132, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_132_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 2 5 6)

theorem row_132_162 : RowResult ⟨132, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_132_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_132_163 : RowResult ⟨132, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_132_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 2 5 7)

theorem row_132_164 : RowResult ⟨132, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_132_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_132_165 : RowResult ⟨132, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_132_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 4 5 6)

theorem row_132_166 : RowResult ⟨132, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_132_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 2 4 6)

theorem row_132_167 : RowResult ⟨132, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_132_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
