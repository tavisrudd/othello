import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_130_131 : RowResult ⟨130, by decide⟩ ⟨131, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 0 4 6)

theorem row_130_132 : RowResult ⟨130, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_130_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 0 4 6)

theorem row_130_133 : RowResult ⟨130, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_130_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 0 4 6)

theorem row_130_134 : RowResult ⟨130, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_130_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 0 4 6)

theorem row_130_135 : RowResult ⟨130, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_130_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 0 4 6)

theorem row_130_136 : RowResult ⟨130, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_130_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 0 4 6)

theorem row_130_137 : RowResult ⟨130, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_130_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 0 4 6)

theorem row_130_138 : RowResult ⟨130, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_130_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 0 4 6)

theorem row_130_139 : RowResult ⟨130, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_130_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 0 4 6)

theorem row_130_140 : RowResult ⟨130, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_130_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 0 4 6)

theorem row_130_141 : RowResult ⟨130, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_130_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 0 4 6)

theorem row_130_142 : RowResult ⟨130, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_130_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 0 4 6)

theorem row_130_143 : RowResult ⟨130, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_130_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 0 4 6)

theorem row_130_144 : RowResult ⟨130, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_130_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 0 4 6)

theorem row_130_145 : RowResult ⟨130, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_130_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 0 4 6)

theorem row_130_146 : RowResult ⟨130, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_130_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 0 4 6)

theorem row_130_147 : RowResult ⟨130, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_130_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 0 4 6)

theorem row_130_148 : RowResult ⟨130, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_130_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 0 4 6)

theorem row_130_149 : RowResult ⟨130, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_130_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 0 4 6)

theorem row_130_150 : RowResult ⟨130, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_130_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 2 4)

theorem row_130_151 : RowResult ⟨130, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_130_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 2 4)

theorem row_130_152 : RowResult ⟨130, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_130_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 2 4)

theorem row_130_153 : RowResult ⟨130, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_130_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 2 4)

theorem row_130_154 : RowResult ⟨130, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_130_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 2 4)

theorem row_130_155 : RowResult ⟨130, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_130_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 4)

theorem row_130_156 : RowResult ⟨130, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_130_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 1 2 4)

theorem row_130_157 : RowResult ⟨130, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_130_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 1 2 4)

theorem row_130_158 : RowResult ⟨130, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_130_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 1 2 4)

theorem row_130_159 : RowResult ⟨130, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_130_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 1 2 4)

theorem row_130_160 : RowResult ⟨130, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_130_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 1 2 4)

theorem row_130_161 : RowResult ⟨130, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_130_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 1 2 4)

theorem row_130_162 : RowResult ⟨130, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_130_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 1 2 4)

theorem row_130_163 : RowResult ⟨130, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_130_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 1 2 4)

theorem row_130_164 : RowResult ⟨130, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_130_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 1 2 4)

theorem row_130_165 : RowResult ⟨130, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_130_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 1 2 4)

theorem row_130_166 : RowResult ⟨130, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_130_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 1 2 4)

theorem row_130_167 : RowResult ⟨130, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_130_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 1 2 4)

theorem row_130_168 : RowResult ⟨130, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_130_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 1 2 4)

theorem row_130_169 : RowResult ⟨130, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_130_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 1 2 4)

theorem row_130_170 : RowResult ⟨130, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_130_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 4)

theorem row_130_171 : RowResult ⟨130, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_130_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 1 2 4)

theorem row_130_172 : RowResult ⟨130, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_130_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 1 2 4)

theorem row_130_173 : RowResult ⟨130, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_130_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 1 2 4)

theorem row_130_174 : RowResult ⟨130, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_130_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 1 2 4)

theorem row_130_175 : RowResult ⟨130, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_130_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 2 4)

theorem row_130_176 : RowResult ⟨130, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_130_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 2 4)

theorem row_130_177 : RowResult ⟨130, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_130_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 2 4)

theorem row_130_178 : RowResult ⟨130, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_130_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 2 4)

theorem row_130_179 : RowResult ⟨130, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_130_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 2 4)

theorem row_130_180 : RowResult ⟨130, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_130_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 4)

theorem row_130_181 : RowResult ⟨130, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_130_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 1 2 4)

theorem row_130_182 : RowResult ⟨130, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_130_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 1 2 4)

theorem row_130_183 : RowResult ⟨130, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_130_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 1 2 4)

theorem row_130_184 : RowResult ⟨130, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_130_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 1 2 4)

theorem row_130_185 : RowResult ⟨130, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_130_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 1 2 4)

theorem row_130_186 : RowResult ⟨130, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_130_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 1 2 4)

theorem row_130_187 : RowResult ⟨130, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_130_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 1 2 4)

theorem row_130_188 : RowResult ⟨130, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_130_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 1 2 4)

theorem row_130_189 : RowResult ⟨130, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_130_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 1 2 4)

theorem row_130_190 : RowResult ⟨130, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_130_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 1 2 4)

theorem row_130_191 : RowResult ⟨130, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_130_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 1 2 4)

theorem row_130_192 : RowResult ⟨130, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_130_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 1 2 4)

theorem row_130_193 : RowResult ⟨130, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_130_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 1 2 4)

theorem row_130_194 : RowResult ⟨130, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_130_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 1 2 4)

theorem row_130_195 : RowResult ⟨130, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_130_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 4)

theorem row_130_196 : RowResult ⟨130, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_130_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 1 2 4)

theorem row_130_197 : RowResult ⟨130, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_130_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 1 2 4)

theorem row_130_198 : RowResult ⟨130, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_130_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 1 2 4)

theorem row_130_199 : RowResult ⟨130, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_130_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 1 2 4)

theorem row_130_200 : RowResult ⟨130, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_130_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 2 4)

theorem row_130_201 : RowResult ⟨130, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_130_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 2 4)

theorem row_130_202 : RowResult ⟨130, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_130_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 2 4)

theorem row_130_203 : RowResult ⟨130, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_130_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 2 4)

theorem row_130_204 : RowResult ⟨130, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_130_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 2 4)

theorem row_130_205 : RowResult ⟨130, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_130_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 4)

theorem row_130_206 : RowResult ⟨130, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_130_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 1 2 4)

theorem row_130_207 : RowResult ⟨130, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_130_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 1 2 4)

theorem row_130_208 : RowResult ⟨130, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_130_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 1 2 4)

theorem row_130_209 : RowResult ⟨130, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_130_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 1 2 4)

theorem row_130_210 : RowResult ⟨130, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_130_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 1 2 4)

theorem row_130_211 : RowResult ⟨130, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_130_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 1 2 4)

theorem row_130_212 : RowResult ⟨130, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_130_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 1 2 4)

theorem row_130_213 : RowResult ⟨130, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_130_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 1 2 4)

theorem row_130_214 : RowResult ⟨130, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_130_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 1 2 4)

theorem row_130_215 : RowResult ⟨130, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_130_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 1 2 4)

theorem row_130_216 : RowResult ⟨130, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_130_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 1 2 4)

theorem row_130_217 : RowResult ⟨130, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_130_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 1 2 4)

theorem row_130_218 : RowResult ⟨130, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_130_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 1 2 4)

theorem row_130_219 : RowResult ⟨130, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_130_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 1 2 4)

theorem row_130_220 : RowResult ⟨130, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_130_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 4)

theorem row_130_221 : RowResult ⟨130, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_130_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 1 2 4)

theorem row_130_222 : RowResult ⟨130, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_130_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 1 2 4)

theorem row_130_223 : RowResult ⟨130, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_130_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 1 2 4)

theorem row_130_224 : RowResult ⟨130, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_130_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 1 2 4)

theorem row_130_225 : RowResult ⟨130, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_130_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 2 4)

theorem row_130_226 : RowResult ⟨130, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_130_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 2 4)

theorem row_130_227 : RowResult ⟨130, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_130_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 2 4)

theorem row_130_228 : RowResult ⟨130, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_130_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 2 4)

theorem row_130_229 : RowResult ⟨130, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_130_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 2 4)

theorem row_130_230 : RowResult ⟨130, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_130_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 4)

end RelativeConicArcs.Q25PairCertificate
