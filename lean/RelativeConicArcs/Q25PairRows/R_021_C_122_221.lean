import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_21_122 : RowResult ⟨21, by decide⟩ ⟨122, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 0 2 4)

theorem row_21_123 : RowResult ⟨21, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_21_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 0 2 4)

theorem row_21_124 : RowResult ⟨21, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_21_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 0 2 4)

theorem row_21_125 : RowResult ⟨21, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_21_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 0 2 4)

theorem row_21_126 : RowResult ⟨21, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_21_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 0 2 4)

theorem row_21_127 : RowResult ⟨21, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_21_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 0 2 4)

theorem row_21_128 : RowResult ⟨21, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_21_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 0 2 4)

theorem row_21_129 : RowResult ⟨21, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_21_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 0 2 4)

theorem row_21_130 : RowResult ⟨21, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_21_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 0 2 4)

theorem row_21_131 : RowResult ⟨21, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_21_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 0 2 4)

theorem row_21_132 : RowResult ⟨21, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_21_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 0 2 4)

theorem row_21_133 : RowResult ⟨21, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_21_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 0 2 4)

theorem row_21_134 : RowResult ⟨21, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_21_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 0 2 4)

theorem row_21_135 : RowResult ⟨21, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_21_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 0 2 4)

theorem row_21_136 : RowResult ⟨21, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_21_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 0 2 4)

theorem row_21_137 : RowResult ⟨21, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_21_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 0 2 4)

theorem row_21_138 : RowResult ⟨21, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_21_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 0 2 4)

theorem row_21_139 : RowResult ⟨21, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_21_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 0 2 4)

theorem row_21_140 : RowResult ⟨21, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_21_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 0 2 4)

theorem row_21_141 : RowResult ⟨21, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_21_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 0 2 4)

theorem row_21_142 : RowResult ⟨21, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_21_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 0 2 4)

theorem row_21_143 : RowResult ⟨21, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_21_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 0 2 4)

theorem row_21_144 : RowResult ⟨21, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_21_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 0 2 4)

theorem row_21_145 : RowResult ⟨21, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_21_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 0 2 4)

theorem row_21_146 : RowResult ⟨21, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_21_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 0 2 4)

theorem row_21_147 : RowResult ⟨21, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_21_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 0 2 4)

theorem row_21_148 : RowResult ⟨21, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_21_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 0 2 4)

theorem row_21_149 : RowResult ⟨21, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_21_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 0 2 4)

theorem row_21_150 : RowResult ⟨21, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_21_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 0 2 4)

theorem row_21_151 : RowResult ⟨21, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_21_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 0 2 4)

theorem row_21_152 : RowResult ⟨21, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_21_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 0 2 4)

theorem row_21_153 : RowResult ⟨21, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_21_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 0 2 4)

theorem row_21_154 : RowResult ⟨21, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_21_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 0 2 4)

theorem row_21_155 : RowResult ⟨21, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_21_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 0 2 4)

theorem row_21_156 : RowResult ⟨21, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_21_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 0 2 4)

theorem row_21_157 : RowResult ⟨21, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_21_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 0 2 4)

theorem row_21_158 : RowResult ⟨21, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_21_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 0 2 4)

theorem row_21_159 : RowResult ⟨21, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_21_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 0 2 4)

theorem row_21_160 : RowResult ⟨21, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_21_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 0 2 4)

theorem row_21_161 : RowResult ⟨21, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_21_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 0 2 4)

theorem row_21_162 : RowResult ⟨21, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_21_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 0 2 4)

theorem row_21_163 : RowResult ⟨21, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_21_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 0 2 4)

theorem row_21_164 : RowResult ⟨21, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_21_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 0 2 4)

theorem row_21_165 : RowResult ⟨21, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_21_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 0 2 4)

theorem row_21_166 : RowResult ⟨21, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_21_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 0 2 4)

theorem row_21_167 : RowResult ⟨21, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_21_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 0 2 4)

theorem row_21_168 : RowResult ⟨21, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_21_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 0 2 4)

theorem row_21_169 : RowResult ⟨21, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_21_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 0 2 4)

theorem row_21_170 : RowResult ⟨21, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_21_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 0 2 4)

theorem row_21_171 : RowResult ⟨21, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_21_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 0 2 4)

theorem row_21_172 : RowResult ⟨21, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_21_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 0 2 4)

theorem row_21_173 : RowResult ⟨21, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_21_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 0 2 4)

theorem row_21_174 : RowResult ⟨21, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_21_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 0 2 4)

theorem row_21_175 : RowResult ⟨21, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_21_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 0 2 4)

theorem row_21_176 : RowResult ⟨21, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_21_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 0 2 4)

theorem row_21_177 : RowResult ⟨21, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_21_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 0 2 4)

theorem row_21_178 : RowResult ⟨21, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_21_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 0 2 4)

theorem row_21_179 : RowResult ⟨21, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_21_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 0 2 4)

theorem row_21_180 : RowResult ⟨21, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_21_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 0 2 4)

theorem row_21_181 : RowResult ⟨21, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_21_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 0 2 4)

theorem row_21_182 : RowResult ⟨21, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_21_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 0 2 4)

theorem row_21_183 : RowResult ⟨21, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_21_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 0 2 4)

theorem row_21_184 : RowResult ⟨21, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_21_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 0 2 4)

theorem row_21_185 : RowResult ⟨21, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_21_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 0 2 4)

theorem row_21_186 : RowResult ⟨21, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_21_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 0 2 4)

theorem row_21_187 : RowResult ⟨21, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_21_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 0 2 4)

theorem row_21_188 : RowResult ⟨21, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_21_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 0 2 4)

theorem row_21_189 : RowResult ⟨21, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_21_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 0 2 4)

theorem row_21_190 : RowResult ⟨21, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_21_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 0 2 4)

theorem row_21_191 : RowResult ⟨21, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_21_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 0 2 4)

theorem row_21_192 : RowResult ⟨21, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_21_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 0 2 4)

theorem row_21_193 : RowResult ⟨21, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_21_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 0 2 4)

theorem row_21_194 : RowResult ⟨21, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_21_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 0 2 4)

theorem row_21_195 : RowResult ⟨21, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_21_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 0 2 4)

theorem row_21_196 : RowResult ⟨21, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_21_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 0 2 4)

theorem row_21_197 : RowResult ⟨21, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_21_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 0 2 4)

theorem row_21_198 : RowResult ⟨21, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_21_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 0 2 4)

theorem row_21_199 : RowResult ⟨21, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_21_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 0 2 4)

theorem row_21_200 : RowResult ⟨21, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_21_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 0 2 4)

theorem row_21_201 : RowResult ⟨21, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_21_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 0 2 4)

theorem row_21_202 : RowResult ⟨21, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_21_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 0 2 4)

theorem row_21_203 : RowResult ⟨21, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_21_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 0 2 4)

theorem row_21_204 : RowResult ⟨21, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_21_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 0 2 4)

theorem row_21_205 : RowResult ⟨21, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_21_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 0 2 4)

theorem row_21_206 : RowResult ⟨21, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_21_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 0 2 4)

theorem row_21_207 : RowResult ⟨21, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_21_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 0 2 4)

theorem row_21_208 : RowResult ⟨21, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_21_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 0 2 4)

theorem row_21_209 : RowResult ⟨21, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_21_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 0 2 4)

theorem row_21_210 : RowResult ⟨21, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_21_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 0 2 4)

theorem row_21_211 : RowResult ⟨21, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_21_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 0 2 4)

theorem row_21_212 : RowResult ⟨21, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_21_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 0 2 4)

theorem row_21_213 : RowResult ⟨21, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_21_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 0 2 4)

theorem row_21_214 : RowResult ⟨21, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_21_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 0 2 4)

theorem row_21_215 : RowResult ⟨21, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_21_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 0 2 4)

theorem row_21_216 : RowResult ⟨21, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_21_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 0 2 4)

theorem row_21_217 : RowResult ⟨21, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_21_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 0 2 4)

theorem row_21_218 : RowResult ⟨21, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_21_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 0 2 4)

theorem row_21_219 : RowResult ⟨21, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_21_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 0 2 4)

theorem row_21_220 : RowResult ⟨21, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_21_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 0 2 4)

theorem row_21_221 : RowResult ⟨21, by decide⟩ ⟨221, by decide⟩ := by
  have _previous := row_21_220
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) (orbitCodeOfNumber ⟨221, by decide⟩) 0 2 4)

end RelativeConicArcs.Q25PairCertificate
