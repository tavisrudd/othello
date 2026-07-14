import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_137_138 : RowResult ⟨137, by decide⟩ ⟨138, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 0 4 6)

theorem row_137_139 : RowResult ⟨137, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_137_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 0 4 6)

theorem row_137_140 : RowResult ⟨137, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_137_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 0 4 6)

theorem row_137_141 : RowResult ⟨137, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_137_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 0 4 6)

theorem row_137_142 : RowResult ⟨137, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_137_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 0 4 6)

theorem row_137_143 : RowResult ⟨137, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_137_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 0 4 6)

theorem row_137_144 : RowResult ⟨137, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_137_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 0 4 6)

theorem row_137_145 : RowResult ⟨137, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_137_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 0 4 6)

theorem row_137_146 : RowResult ⟨137, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_137_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 0 4 6)

theorem row_137_147 : RowResult ⟨137, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_137_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 0 4 6)

theorem row_137_148 : RowResult ⟨137, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_137_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 0 4 6)

theorem row_137_149 : RowResult ⟨137, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_137_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 0 4 6)

theorem row_137_150 : RowResult ⟨137, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_137_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 6 7)

theorem row_137_151 : RowResult ⟨137, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_137_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 6 7)

theorem row_137_152 : RowResult ⟨137, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_137_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 6 7)

theorem row_137_153 : RowResult ⟨137, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_137_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 6 7)

theorem row_137_154 : RowResult ⟨137, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_137_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 6 7)

theorem row_137_155 : RowResult ⟨137, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_137_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_137_156 : RowResult ⟨137, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_137_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 2 3 4)

theorem row_137_157 : RowResult ⟨137, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_137_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 2 3 4)

theorem row_137_158 : RowResult ⟨137, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_137_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 2 3 4)

theorem row_137_159 : RowResult ⟨137, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_137_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 2 3 4)

theorem row_137_160 : RowResult ⟨137, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_137_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 2 3 4)

theorem row_137_161 : RowResult ⟨137, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_137_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 2 3 4)

theorem row_137_162 : RowResult ⟨137, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_137_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 1 4 6)

theorem row_137_163 : RowResult ⟨137, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_137_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 2 3 4)

theorem row_137_164 : RowResult ⟨137, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_137_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 2 3 4)

theorem row_137_165 : RowResult ⟨137, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_137_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 2 3 4)

theorem row_137_166 : RowResult ⟨137, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_137_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 2 3 4)

theorem row_137_167 : RowResult ⟨137, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_137_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 1 4 7)

theorem row_137_168 : RowResult ⟨137, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_137_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 2 3 4)

theorem row_137_169 : RowResult ⟨137, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_137_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 2 3 4)

theorem row_137_170 : RowResult ⟨137, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_137_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_137_171 : RowResult ⟨137, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_137_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 2 3 4)

theorem row_137_172 : RowResult ⟨137, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_137_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 2 3 4)

theorem row_137_173 : RowResult ⟨137, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_137_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 2 3 4)

theorem row_137_174 : RowResult ⟨137, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_137_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 2 3 4)

theorem row_137_175 : RowResult ⟨137, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_137_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 6 7)

theorem row_137_176 : RowResult ⟨137, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_137_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 6 7)

theorem row_137_177 : RowResult ⟨137, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_137_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 6 7)

theorem row_137_178 : RowResult ⟨137, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_137_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 6 7)

theorem row_137_179 : RowResult ⟨137, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_137_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 6 7)

theorem row_137_180 : RowResult ⟨137, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_137_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_137_181 : RowResult ⟨137, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_137_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 2 3 4)

theorem row_137_182 : RowResult ⟨137, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_137_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 2 3 4)

theorem row_137_183 : RowResult ⟨137, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_137_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 2 3 4)

theorem row_137_184 : RowResult ⟨137, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_137_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 2 3 4)

theorem row_137_185 : RowResult ⟨137, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_137_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 2 3 4)

theorem row_137_186 : RowResult ⟨137, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_137_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 2 3 4)

theorem row_137_187 : RowResult ⟨137, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_137_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 1 4 6)

theorem row_137_188 : RowResult ⟨137, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_137_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 4)

theorem row_137_189 : RowResult ⟨137, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_137_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 2 3 4)

theorem row_137_190 : RowResult ⟨137, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_137_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 2 3 4)

theorem row_137_191 : RowResult ⟨137, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_137_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 2 3 4)

theorem row_137_192 : RowResult ⟨137, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_137_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 1 4 7)

theorem row_137_193 : RowResult ⟨137, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_137_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 2 3 4)

theorem row_137_194 : RowResult ⟨137, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_137_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 2 3 4)

theorem row_137_195 : RowResult ⟨137, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_137_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_137_196 : RowResult ⟨137, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_137_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 2 3 4)

theorem row_137_197 : RowResult ⟨137, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_137_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 2 3 4)

theorem row_137_198 : RowResult ⟨137, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_137_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 2 3 4)

theorem row_137_199 : RowResult ⟨137, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_137_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 2 3 4)

theorem row_137_200 : RowResult ⟨137, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_137_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_137_201 : RowResult ⟨137, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_137_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_137_202 : RowResult ⟨137, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_137_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_137_203 : RowResult ⟨137, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_137_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_137_204 : RowResult ⟨137, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_137_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_137_205 : RowResult ⟨137, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_137_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_137_206 : RowResult ⟨137, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_137_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 2 3 4)

theorem row_137_207 : RowResult ⟨137, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_137_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 2 3 4)

theorem row_137_208 : RowResult ⟨137, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_137_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 2 3 4)

theorem row_137_209 : RowResult ⟨137, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_137_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 4)

theorem row_137_210 : RowResult ⟨137, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_137_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 2 3 4)

theorem row_137_211 : RowResult ⟨137, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_137_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 2 3 4)

theorem row_137_212 : RowResult ⟨137, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_137_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 1 4 6)

theorem row_137_213 : RowResult ⟨137, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_137_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 2 3 4)

theorem row_137_214 : RowResult ⟨137, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_137_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 2 3 4)

theorem row_137_215 : RowResult ⟨137, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_137_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 2 3 4)

theorem row_137_216 : RowResult ⟨137, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_137_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 2 3 4)

theorem row_137_217 : RowResult ⟨137, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_137_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 1 4 7)

theorem row_137_218 : RowResult ⟨137, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_137_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 2 3 4)

theorem row_137_219 : RowResult ⟨137, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_137_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 2 3 4)

theorem row_137_220 : RowResult ⟨137, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_137_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 7)

theorem row_137_221 : RowResult ⟨137, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_137_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 2 3 4)

theorem row_137_222 : RowResult ⟨137, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_137_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 2 3 4)

theorem row_137_223 : RowResult ⟨137, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_137_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 2 3 4)

theorem row_137_224 : RowResult ⟨137, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_137_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 2 3 4)

theorem row_137_225 : RowResult ⟨137, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_137_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 6 7)

theorem row_137_226 : RowResult ⟨137, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_137_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 6 7)

theorem row_137_227 : RowResult ⟨137, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_137_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 6 7)

theorem row_137_228 : RowResult ⟨137, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_137_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 6 7)

theorem row_137_229 : RowResult ⟨137, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_137_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 6 7)

theorem row_137_230 : RowResult ⟨137, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_137_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 6)

theorem row_137_231 : RowResult ⟨137, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_137_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 2 3 4)

theorem row_137_232 : RowResult ⟨137, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_137_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 2 3 4)

theorem row_137_233 : RowResult ⟨137, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_137_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 2 3 4)

theorem row_137_234 : RowResult ⟨137, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_137_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 2 3 4)

theorem row_137_235 : RowResult ⟨137, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_137_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 2 3 4)

theorem row_137_236 : RowResult ⟨137, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_137_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 2 3 4)

theorem row_137_237 : RowResult ⟨137, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_137_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
