import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_9_110 : RowResult ⟨9, by decide⟩ ⟨110, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 0 2 4)

theorem row_9_111 : RowResult ⟨9, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_9_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 0 2 4)

theorem row_9_112 : RowResult ⟨9, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_9_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 0 2 4)

theorem row_9_113 : RowResult ⟨9, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_9_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 0 2 4)

theorem row_9_114 : RowResult ⟨9, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_9_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 0 2 4)

theorem row_9_115 : RowResult ⟨9, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_9_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 0 2 4)

theorem row_9_116 : RowResult ⟨9, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_9_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 0 2 4)

theorem row_9_117 : RowResult ⟨9, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_9_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 0 2 4)

theorem row_9_118 : RowResult ⟨9, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_9_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 0 2 4)

theorem row_9_119 : RowResult ⟨9, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_9_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 0 2 4)

theorem row_9_120 : RowResult ⟨9, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_9_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 0 2 4)

theorem row_9_121 : RowResult ⟨9, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_9_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 0 2 4)

theorem row_9_122 : RowResult ⟨9, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_9_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 0 2 4)

theorem row_9_123 : RowResult ⟨9, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_9_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 0 2 4)

theorem row_9_124 : RowResult ⟨9, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_9_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 0 2 4)

theorem row_9_125 : RowResult ⟨9, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_9_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 0 2 4)

theorem row_9_126 : RowResult ⟨9, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_9_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 0 2 4)

theorem row_9_127 : RowResult ⟨9, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_9_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 0 2 4)

theorem row_9_128 : RowResult ⟨9, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_9_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 0 2 4)

theorem row_9_129 : RowResult ⟨9, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_9_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 0 2 4)

theorem row_9_130 : RowResult ⟨9, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_9_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 0 2 4)

theorem row_9_131 : RowResult ⟨9, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_9_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 0 2 4)

theorem row_9_132 : RowResult ⟨9, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_9_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 0 2 4)

theorem row_9_133 : RowResult ⟨9, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_9_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 0 2 4)

theorem row_9_134 : RowResult ⟨9, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_9_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 0 2 4)

theorem row_9_135 : RowResult ⟨9, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_9_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 0 2 4)

theorem row_9_136 : RowResult ⟨9, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_9_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 0 2 4)

theorem row_9_137 : RowResult ⟨9, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_9_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 0 2 4)

theorem row_9_138 : RowResult ⟨9, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_9_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 0 2 4)

theorem row_9_139 : RowResult ⟨9, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_9_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 0 2 4)

theorem row_9_140 : RowResult ⟨9, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_9_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 0 2 4)

theorem row_9_141 : RowResult ⟨9, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_9_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 0 2 4)

theorem row_9_142 : RowResult ⟨9, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_9_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 0 2 4)

theorem row_9_143 : RowResult ⟨9, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_9_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 0 2 4)

theorem row_9_144 : RowResult ⟨9, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_9_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 0 2 4)

theorem row_9_145 : RowResult ⟨9, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_9_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 0 2 4)

theorem row_9_146 : RowResult ⟨9, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_9_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 0 2 4)

theorem row_9_147 : RowResult ⟨9, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_9_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 0 2 4)

theorem row_9_148 : RowResult ⟨9, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_9_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 0 2 4)

theorem row_9_149 : RowResult ⟨9, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_9_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 0 2 4)

theorem row_9_150 : RowResult ⟨9, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_9_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 0 2 4)

theorem row_9_151 : RowResult ⟨9, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_9_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 0 2 4)

theorem row_9_152 : RowResult ⟨9, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_9_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 0 2 4)

theorem row_9_153 : RowResult ⟨9, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_9_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 0 2 4)

theorem row_9_154 : RowResult ⟨9, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_9_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 0 2 4)

theorem row_9_155 : RowResult ⟨9, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_9_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 0 2 4)

theorem row_9_156 : RowResult ⟨9, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_9_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 0 2 4)

theorem row_9_157 : RowResult ⟨9, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_9_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 0 2 4)

theorem row_9_158 : RowResult ⟨9, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_9_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 0 2 4)

theorem row_9_159 : RowResult ⟨9, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_9_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 0 2 4)

theorem row_9_160 : RowResult ⟨9, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_9_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 0 2 4)

theorem row_9_161 : RowResult ⟨9, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_9_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 0 2 4)

theorem row_9_162 : RowResult ⟨9, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_9_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 0 2 4)

theorem row_9_163 : RowResult ⟨9, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_9_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 0 2 4)

theorem row_9_164 : RowResult ⟨9, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_9_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 0 2 4)

theorem row_9_165 : RowResult ⟨9, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_9_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 0 2 4)

theorem row_9_166 : RowResult ⟨9, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_9_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 0 2 4)

theorem row_9_167 : RowResult ⟨9, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_9_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 0 2 4)

theorem row_9_168 : RowResult ⟨9, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_9_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 0 2 4)

theorem row_9_169 : RowResult ⟨9, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_9_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 0 2 4)

theorem row_9_170 : RowResult ⟨9, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_9_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 0 2 4)

theorem row_9_171 : RowResult ⟨9, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_9_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 0 2 4)

theorem row_9_172 : RowResult ⟨9, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_9_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 0 2 4)

theorem row_9_173 : RowResult ⟨9, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_9_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 0 2 4)

theorem row_9_174 : RowResult ⟨9, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_9_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 0 2 4)

theorem row_9_175 : RowResult ⟨9, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_9_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 0 2 4)

theorem row_9_176 : RowResult ⟨9, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_9_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 0 2 4)

theorem row_9_177 : RowResult ⟨9, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_9_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 0 2 4)

theorem row_9_178 : RowResult ⟨9, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_9_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 0 2 4)

theorem row_9_179 : RowResult ⟨9, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_9_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 0 2 4)

theorem row_9_180 : RowResult ⟨9, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_9_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 0 2 4)

theorem row_9_181 : RowResult ⟨9, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_9_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 0 2 4)

theorem row_9_182 : RowResult ⟨9, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_9_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 0 2 4)

theorem row_9_183 : RowResult ⟨9, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_9_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 0 2 4)

theorem row_9_184 : RowResult ⟨9, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_9_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 0 2 4)

theorem row_9_185 : RowResult ⟨9, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_9_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 0 2 4)

theorem row_9_186 : RowResult ⟨9, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_9_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 0 2 4)

theorem row_9_187 : RowResult ⟨9, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_9_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 0 2 4)

theorem row_9_188 : RowResult ⟨9, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_9_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 0 2 4)

theorem row_9_189 : RowResult ⟨9, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_9_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 0 2 4)

theorem row_9_190 : RowResult ⟨9, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_9_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 0 2 4)

theorem row_9_191 : RowResult ⟨9, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_9_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 0 2 4)

theorem row_9_192 : RowResult ⟨9, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_9_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 0 2 4)

theorem row_9_193 : RowResult ⟨9, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_9_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 0 2 4)

theorem row_9_194 : RowResult ⟨9, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_9_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 0 2 4)

theorem row_9_195 : RowResult ⟨9, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_9_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 0 2 4)

theorem row_9_196 : RowResult ⟨9, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_9_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 0 2 4)

theorem row_9_197 : RowResult ⟨9, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_9_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 0 2 4)

theorem row_9_198 : RowResult ⟨9, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_9_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 0 2 4)

theorem row_9_199 : RowResult ⟨9, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_9_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 0 2 4)

theorem row_9_200 : RowResult ⟨9, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_9_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 0 2 4)

theorem row_9_201 : RowResult ⟨9, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_9_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 0 2 4)

theorem row_9_202 : RowResult ⟨9, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_9_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 0 2 4)

theorem row_9_203 : RowResult ⟨9, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_9_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 0 2 4)

theorem row_9_204 : RowResult ⟨9, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_9_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 0 2 4)

theorem row_9_205 : RowResult ⟨9, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_9_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 0 2 4)

theorem row_9_206 : RowResult ⟨9, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_9_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 0 2 4)

theorem row_9_207 : RowResult ⟨9, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_9_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 0 2 4)

theorem row_9_208 : RowResult ⟨9, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_9_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 0 2 4)

theorem row_9_209 : RowResult ⟨9, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_9_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 0 2 4)

end RelativeConicArcs.Q25PairCertificate
