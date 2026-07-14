import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_145_146 : RowResult ⟨145, by decide⟩ ⟨146, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 0 4 6)

theorem row_145_147 : RowResult ⟨145, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_145_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 0 4 6)

theorem row_145_148 : RowResult ⟨145, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_145_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 0 4 6)

theorem row_145_149 : RowResult ⟨145, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_145_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 0 4 6)

theorem row_145_150 : RowResult ⟨145, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_145_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 2 5)

theorem row_145_151 : RowResult ⟨145, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_145_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 2 5)

theorem row_145_152 : RowResult ⟨145, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_145_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 2 5)

theorem row_145_153 : RowResult ⟨145, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_145_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 2 5)

theorem row_145_154 : RowResult ⟨145, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_145_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 2 5)

theorem row_145_155 : RowResult ⟨145, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_145_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 5)

theorem row_145_156 : RowResult ⟨145, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_145_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 1 2 5)

theorem row_145_157 : RowResult ⟨145, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_145_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 1 2 5)

theorem row_145_158 : RowResult ⟨145, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_145_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 1 2 5)

theorem row_145_159 : RowResult ⟨145, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_145_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 1 2 5)

theorem row_145_160 : RowResult ⟨145, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_145_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 1 2 5)

theorem row_145_161 : RowResult ⟨145, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_145_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 1 2 5)

theorem row_145_162 : RowResult ⟨145, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_145_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 1 2 5)

theorem row_145_163 : RowResult ⟨145, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_145_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 1 2 5)

theorem row_145_164 : RowResult ⟨145, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_145_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 1 2 5)

theorem row_145_165 : RowResult ⟨145, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_145_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 1 2 5)

theorem row_145_166 : RowResult ⟨145, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_145_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 1 2 5)

theorem row_145_167 : RowResult ⟨145, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_145_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 1 2 5)

theorem row_145_168 : RowResult ⟨145, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_145_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 1 2 5)

theorem row_145_169 : RowResult ⟨145, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_145_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 1 2 5)

theorem row_145_170 : RowResult ⟨145, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_145_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 5)

theorem row_145_171 : RowResult ⟨145, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_145_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 1 2 5)

theorem row_145_172 : RowResult ⟨145, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_145_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 1 2 5)

theorem row_145_173 : RowResult ⟨145, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_145_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 1 2 5)

theorem row_145_174 : RowResult ⟨145, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_145_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 1 2 5)

theorem row_145_175 : RowResult ⟨145, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_145_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 2 5)

theorem row_145_176 : RowResult ⟨145, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_145_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 2 5)

theorem row_145_177 : RowResult ⟨145, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_145_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 2 5)

theorem row_145_178 : RowResult ⟨145, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_145_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 2 5)

theorem row_145_179 : RowResult ⟨145, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_145_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 2 5)

theorem row_145_180 : RowResult ⟨145, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_145_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 5)

theorem row_145_181 : RowResult ⟨145, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_145_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 1 2 5)

theorem row_145_182 : RowResult ⟨145, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_145_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 1 2 5)

theorem row_145_183 : RowResult ⟨145, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_145_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 1 2 5)

theorem row_145_184 : RowResult ⟨145, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_145_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 1 2 5)

theorem row_145_185 : RowResult ⟨145, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_145_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 1 2 5)

theorem row_145_186 : RowResult ⟨145, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_145_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 1 2 5)

theorem row_145_187 : RowResult ⟨145, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_145_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 1 2 5)

theorem row_145_188 : RowResult ⟨145, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_145_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 1 2 5)

theorem row_145_189 : RowResult ⟨145, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_145_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 1 2 5)

theorem row_145_190 : RowResult ⟨145, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_145_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 1 2 5)

theorem row_145_191 : RowResult ⟨145, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_145_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 1 2 5)

theorem row_145_192 : RowResult ⟨145, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_145_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 1 2 5)

theorem row_145_193 : RowResult ⟨145, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_145_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 1 2 5)

theorem row_145_194 : RowResult ⟨145, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_145_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 1 2 5)

theorem row_145_195 : RowResult ⟨145, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_145_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 5)

theorem row_145_196 : RowResult ⟨145, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_145_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 1 2 5)

theorem row_145_197 : RowResult ⟨145, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_145_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 1 2 5)

theorem row_145_198 : RowResult ⟨145, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_145_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 1 2 5)

theorem row_145_199 : RowResult ⟨145, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_145_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 1 2 5)

theorem row_145_200 : RowResult ⟨145, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_145_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 2 5)

theorem row_145_201 : RowResult ⟨145, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_145_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 2 5)

theorem row_145_202 : RowResult ⟨145, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_145_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 2 5)

theorem row_145_203 : RowResult ⟨145, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_145_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 2 5)

theorem row_145_204 : RowResult ⟨145, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_145_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 2 5)

theorem row_145_205 : RowResult ⟨145, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_145_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 5)

theorem row_145_206 : RowResult ⟨145, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_145_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 1 2 5)

theorem row_145_207 : RowResult ⟨145, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_145_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 1 2 5)

theorem row_145_208 : RowResult ⟨145, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_145_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 1 2 5)

theorem row_145_209 : RowResult ⟨145, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_145_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 1 2 5)

theorem row_145_210 : RowResult ⟨145, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_145_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 1 2 5)

theorem row_145_211 : RowResult ⟨145, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_145_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 1 2 5)

theorem row_145_212 : RowResult ⟨145, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_145_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 1 2 5)

theorem row_145_213 : RowResult ⟨145, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_145_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 1 2 5)

theorem row_145_214 : RowResult ⟨145, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_145_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 1 2 5)

theorem row_145_215 : RowResult ⟨145, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_145_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 1 2 5)

theorem row_145_216 : RowResult ⟨145, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_145_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 1 2 5)

theorem row_145_217 : RowResult ⟨145, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_145_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 1 2 5)

theorem row_145_218 : RowResult ⟨145, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_145_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 1 2 5)

theorem row_145_219 : RowResult ⟨145, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_145_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 1 2 5)

theorem row_145_220 : RowResult ⟨145, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_145_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 1 2 5)

theorem row_145_221 : RowResult ⟨145, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_145_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 1 2 5)

theorem row_145_222 : RowResult ⟨145, by decide⟩ ⟨222, by decide⟩ := by
  have _previous := row_145_221
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨222, by decide⟩) 1 2 5)

theorem row_145_223 : RowResult ⟨145, by decide⟩ ⟨223, by decide⟩ := by
  have _previous := row_145_222
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨223, by decide⟩) 1 2 5)

theorem row_145_224 : RowResult ⟨145, by decide⟩ ⟨224, by decide⟩ := by
  have _previous := row_145_223
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨224, by decide⟩) 1 2 5)

theorem row_145_225 : RowResult ⟨145, by decide⟩ ⟨225, by decide⟩ := by
  have _previous := row_145_224
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨225, by decide⟩) 1 2 5)

theorem row_145_226 : RowResult ⟨145, by decide⟩ ⟨226, by decide⟩ := by
  have _previous := row_145_225
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨226, by decide⟩) 1 2 5)

theorem row_145_227 : RowResult ⟨145, by decide⟩ ⟨227, by decide⟩ := by
  have _previous := row_145_226
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨227, by decide⟩) 1 2 5)

theorem row_145_228 : RowResult ⟨145, by decide⟩ ⟨228, by decide⟩ := by
  have _previous := row_145_227
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨228, by decide⟩) 1 2 5)

theorem row_145_229 : RowResult ⟨145, by decide⟩ ⟨229, by decide⟩ := by
  have _previous := row_145_228
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨229, by decide⟩) 1 2 5)

theorem row_145_230 : RowResult ⟨145, by decide⟩ ⟨230, by decide⟩ := by
  have _previous := row_145_229
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨230, by decide⟩) 1 2 5)

theorem row_145_231 : RowResult ⟨145, by decide⟩ ⟨231, by decide⟩ := by
  have _previous := row_145_230
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨231, by decide⟩) 1 2 5)

theorem row_145_232 : RowResult ⟨145, by decide⟩ ⟨232, by decide⟩ := by
  have _previous := row_145_231
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨232, by decide⟩) 1 2 5)

theorem row_145_233 : RowResult ⟨145, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_145_232
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨233, by decide⟩) 1 2 5)

theorem row_145_234 : RowResult ⟨145, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_145_233
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨234, by decide⟩) 1 2 5)

theorem row_145_235 : RowResult ⟨145, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_145_234
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨235, by decide⟩) 1 2 5)

theorem row_145_236 : RowResult ⟨145, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_145_235
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨236, by decide⟩) 1 2 5)

theorem row_145_237 : RowResult ⟨145, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_145_236
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨237, by decide⟩) 1 2 5)

theorem row_145_238 : RowResult ⟨145, by decide⟩ ⟨238, by decide⟩ := by
  have _previous := row_145_237
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨238, by decide⟩) 1 2 5)

theorem row_145_239 : RowResult ⟨145, by decide⟩ ⟨239, by decide⟩ := by
  have _previous := row_145_238
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨239, by decide⟩) 1 2 5)

theorem row_145_240 : RowResult ⟨145, by decide⟩ ⟨240, by decide⟩ := by
  have _previous := row_145_239
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨240, by decide⟩) 1 2 5)

theorem row_145_241 : RowResult ⟨145, by decide⟩ ⟨241, by decide⟩ := by
  have _previous := row_145_240
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨241, by decide⟩) 1 2 5)

theorem row_145_242 : RowResult ⟨145, by decide⟩ ⟨242, by decide⟩ := by
  have _previous := row_145_241
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨242, by decide⟩) 1 2 5)

theorem row_145_243 : RowResult ⟨145, by decide⟩ ⟨243, by decide⟩ := by
  have _previous := row_145_242
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨243, by decide⟩) 1 2 5)

theorem row_145_244 : RowResult ⟨145, by decide⟩ ⟨244, by decide⟩ := by
  have _previous := row_145_243
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨244, by decide⟩) 1 2 5)

theorem row_145_245 : RowResult ⟨145, by decide⟩ ⟨245, by decide⟩ := by
  have _previous := row_145_244
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) (orbitCodeOfNumber ⟨245, by decide⟩) 1 2 5)

end RelativeConicArcs.Q25PairCertificate
