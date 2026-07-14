import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_20_121 : RowResult ⟨20, by decide⟩ ⟨121, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 0 2 4)

theorem row_20_122 : RowResult ⟨20, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_20_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 0 2 4)

theorem row_20_123 : RowResult ⟨20, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_20_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 0 2 4)

theorem row_20_124 : RowResult ⟨20, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_20_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 0 2 4)

theorem row_20_125 : RowResult ⟨20, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_20_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 0 2 4)

theorem row_20_126 : RowResult ⟨20, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_20_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 0 2 4)

theorem row_20_127 : RowResult ⟨20, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_20_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 0 2 4)

theorem row_20_128 : RowResult ⟨20, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_20_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 0 2 4)

theorem row_20_129 : RowResult ⟨20, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_20_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 0 2 4)

theorem row_20_130 : RowResult ⟨20, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_20_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 0 2 4)

theorem row_20_131 : RowResult ⟨20, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_20_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 0 2 4)

theorem row_20_132 : RowResult ⟨20, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_20_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 0 2 4)

theorem row_20_133 : RowResult ⟨20, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_20_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 0 2 4)

theorem row_20_134 : RowResult ⟨20, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_20_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 0 2 4)

theorem row_20_135 : RowResult ⟨20, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_20_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 0 2 4)

theorem row_20_136 : RowResult ⟨20, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_20_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 0 2 4)

theorem row_20_137 : RowResult ⟨20, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_20_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 0 2 4)

theorem row_20_138 : RowResult ⟨20, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_20_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 0 2 4)

theorem row_20_139 : RowResult ⟨20, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_20_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 0 2 4)

theorem row_20_140 : RowResult ⟨20, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_20_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 0 2 4)

theorem row_20_141 : RowResult ⟨20, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_20_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 0 2 4)

theorem row_20_142 : RowResult ⟨20, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_20_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 0 2 4)

theorem row_20_143 : RowResult ⟨20, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_20_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 0 2 4)

theorem row_20_144 : RowResult ⟨20, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_20_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 0 2 4)

theorem row_20_145 : RowResult ⟨20, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_20_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 0 2 4)

theorem row_20_146 : RowResult ⟨20, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_20_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 0 2 4)

theorem row_20_147 : RowResult ⟨20, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_20_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 0 2 4)

theorem row_20_148 : RowResult ⟨20, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_20_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 0 2 4)

theorem row_20_149 : RowResult ⟨20, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_20_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 0 2 4)

theorem row_20_150 : RowResult ⟨20, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_20_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 0 2 4)

theorem row_20_151 : RowResult ⟨20, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_20_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 0 2 4)

theorem row_20_152 : RowResult ⟨20, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_20_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 0 2 4)

theorem row_20_153 : RowResult ⟨20, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_20_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 0 2 4)

theorem row_20_154 : RowResult ⟨20, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_20_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 0 2 4)

theorem row_20_155 : RowResult ⟨20, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_20_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 0 2 4)

theorem row_20_156 : RowResult ⟨20, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_20_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 0 2 4)

theorem row_20_157 : RowResult ⟨20, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_20_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 0 2 4)

theorem row_20_158 : RowResult ⟨20, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_20_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 0 2 4)

theorem row_20_159 : RowResult ⟨20, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_20_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 0 2 4)

theorem row_20_160 : RowResult ⟨20, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_20_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 0 2 4)

theorem row_20_161 : RowResult ⟨20, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_20_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 0 2 4)

theorem row_20_162 : RowResult ⟨20, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_20_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 0 2 4)

theorem row_20_163 : RowResult ⟨20, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_20_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 0 2 4)

theorem row_20_164 : RowResult ⟨20, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_20_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 0 2 4)

theorem row_20_165 : RowResult ⟨20, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_20_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 0 2 4)

theorem row_20_166 : RowResult ⟨20, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_20_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 0 2 4)

theorem row_20_167 : RowResult ⟨20, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_20_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 0 2 4)

theorem row_20_168 : RowResult ⟨20, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_20_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 0 2 4)

theorem row_20_169 : RowResult ⟨20, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_20_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 0 2 4)

theorem row_20_170 : RowResult ⟨20, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_20_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 0 2 4)

theorem row_20_171 : RowResult ⟨20, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_20_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 0 2 4)

theorem row_20_172 : RowResult ⟨20, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_20_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 0 2 4)

theorem row_20_173 : RowResult ⟨20, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_20_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 0 2 4)

theorem row_20_174 : RowResult ⟨20, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_20_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 0 2 4)

theorem row_20_175 : RowResult ⟨20, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_20_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 0 2 4)

theorem row_20_176 : RowResult ⟨20, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_20_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 0 2 4)

theorem row_20_177 : RowResult ⟨20, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_20_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 0 2 4)

theorem row_20_178 : RowResult ⟨20, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_20_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 0 2 4)

theorem row_20_179 : RowResult ⟨20, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_20_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 0 2 4)

theorem row_20_180 : RowResult ⟨20, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_20_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 0 2 4)

theorem row_20_181 : RowResult ⟨20, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_20_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 0 2 4)

theorem row_20_182 : RowResult ⟨20, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_20_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 0 2 4)

theorem row_20_183 : RowResult ⟨20, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_20_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 0 2 4)

theorem row_20_184 : RowResult ⟨20, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_20_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 0 2 4)

theorem row_20_185 : RowResult ⟨20, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_20_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 0 2 4)

theorem row_20_186 : RowResult ⟨20, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_20_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 0 2 4)

theorem row_20_187 : RowResult ⟨20, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_20_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 0 2 4)

theorem row_20_188 : RowResult ⟨20, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_20_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 0 2 4)

theorem row_20_189 : RowResult ⟨20, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_20_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 0 2 4)

theorem row_20_190 : RowResult ⟨20, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_20_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 0 2 4)

theorem row_20_191 : RowResult ⟨20, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_20_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 0 2 4)

theorem row_20_192 : RowResult ⟨20, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_20_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 0 2 4)

theorem row_20_193 : RowResult ⟨20, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_20_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 0 2 4)

theorem row_20_194 : RowResult ⟨20, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_20_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 0 2 4)

theorem row_20_195 : RowResult ⟨20, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_20_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 0 2 4)

theorem row_20_196 : RowResult ⟨20, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_20_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 0 2 4)

theorem row_20_197 : RowResult ⟨20, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_20_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 0 2 4)

theorem row_20_198 : RowResult ⟨20, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_20_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 0 2 4)

theorem row_20_199 : RowResult ⟨20, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_20_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 0 2 4)

theorem row_20_200 : RowResult ⟨20, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_20_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 0 2 4)

theorem row_20_201 : RowResult ⟨20, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_20_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 0 2 4)

theorem row_20_202 : RowResult ⟨20, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_20_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 0 2 4)

theorem row_20_203 : RowResult ⟨20, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_20_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 0 2 4)

theorem row_20_204 : RowResult ⟨20, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_20_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 0 2 4)

theorem row_20_205 : RowResult ⟨20, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_20_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 0 2 4)

theorem row_20_206 : RowResult ⟨20, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_20_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 0 2 4)

theorem row_20_207 : RowResult ⟨20, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_20_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 0 2 4)

theorem row_20_208 : RowResult ⟨20, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_20_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 0 2 4)

theorem row_20_209 : RowResult ⟨20, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_20_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 0 2 4)

theorem row_20_210 : RowResult ⟨20, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_20_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 0 2 4)

theorem row_20_211 : RowResult ⟨20, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_20_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 0 2 4)

theorem row_20_212 : RowResult ⟨20, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_20_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 0 2 4)

theorem row_20_213 : RowResult ⟨20, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_20_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 0 2 4)

theorem row_20_214 : RowResult ⟨20, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_20_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 0 2 4)

theorem row_20_215 : RowResult ⟨20, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_20_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 0 2 4)

theorem row_20_216 : RowResult ⟨20, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_20_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 0 2 4)

theorem row_20_217 : RowResult ⟨20, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_20_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 0 2 4)

theorem row_20_218 : RowResult ⟨20, by decide⟩ ⟨218, by decide⟩ := by
  have _previous := row_20_217
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨218, by decide⟩) 0 2 4)

theorem row_20_219 : RowResult ⟨20, by decide⟩ ⟨219, by decide⟩ := by
  have _previous := row_20_218
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨219, by decide⟩) 0 2 4)

theorem row_20_220 : RowResult ⟨20, by decide⟩ ⟨220, by decide⟩ := by
  have _previous := row_20_219
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) (orbitCodeOfNumber ⟨220, by decide⟩) 0 2 4)

end RelativeConicArcs.Q25PairCertificate
