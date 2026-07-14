import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_101_102 : RowResult ⟨101, by decide⟩ ⟨102, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 0 4 6)

theorem row_101_103 : RowResult ⟨101, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_101_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 0 4 6)

theorem row_101_104 : RowResult ⟨101, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_101_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 0 4 6)

theorem row_101_105 : RowResult ⟨101, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_101_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 0 4 6)

theorem row_101_106 : RowResult ⟨101, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_101_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 0 4 6)

theorem row_101_107 : RowResult ⟨101, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_101_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 0 4 6)

theorem row_101_108 : RowResult ⟨101, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_101_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 0 4 6)

theorem row_101_109 : RowResult ⟨101, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_101_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 0 4 6)

theorem row_101_110 : RowResult ⟨101, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_101_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 0 4 6)

theorem row_101_111 : RowResult ⟨101, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_101_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 0 4 6)

theorem row_101_112 : RowResult ⟨101, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_101_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 0 4 6)

theorem row_101_113 : RowResult ⟨101, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_101_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 0 4 6)

theorem row_101_114 : RowResult ⟨101, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_101_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 0 4 6)

theorem row_101_115 : RowResult ⟨101, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_101_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 0 4 6)

theorem row_101_116 : RowResult ⟨101, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_101_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 0 4 6)

theorem row_101_117 : RowResult ⟨101, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_101_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 0 4 6)

theorem row_101_118 : RowResult ⟨101, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_101_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 0 4 6)

theorem row_101_119 : RowResult ⟨101, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_101_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 0 4 6)

theorem row_101_120 : RowResult ⟨101, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_101_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 0 4 6)

theorem row_101_121 : RowResult ⟨101, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_101_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 0 4 6)

theorem row_101_122 : RowResult ⟨101, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_101_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 0 4 6)

theorem row_101_123 : RowResult ⟨101, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_101_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 0 4 6)

theorem row_101_124 : RowResult ⟨101, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_101_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 0 4 6)

theorem row_101_125 : RowResult ⟨101, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_101_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 4 5)

theorem row_101_126 : RowResult ⟨101, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_101_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 4 5)

theorem row_101_127 : RowResult ⟨101, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_101_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 4 5)

theorem row_101_128 : RowResult ⟨101, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_101_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 4 5)

theorem row_101_129 : RowResult ⟨101, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_101_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 4 5)

theorem row_101_130 : RowResult ⟨101, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_101_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_101_131 : RowResult ⟨101, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_101_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 1 4 5)

theorem row_101_132 : RowResult ⟨101, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_101_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 1 4 5)

theorem row_101_133 : RowResult ⟨101, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_101_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 1 4 5)

theorem row_101_134 : RowResult ⟨101, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_101_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 1 4 5)

theorem row_101_135 : RowResult ⟨101, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_101_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 1 4 5)

theorem row_101_136 : RowResult ⟨101, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_101_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 1 4 5)

theorem row_101_137 : RowResult ⟨101, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_101_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 1 4 5)

theorem row_101_138 : RowResult ⟨101, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_101_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 1 4 5)

theorem row_101_139 : RowResult ⟨101, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_101_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 1 4 5)

theorem row_101_140 : RowResult ⟨101, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_101_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 1 4 5)

theorem row_101_141 : RowResult ⟨101, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_101_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 1 4 5)

theorem row_101_142 : RowResult ⟨101, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_101_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 1 4 5)

theorem row_101_143 : RowResult ⟨101, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_101_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 1 4 5)

theorem row_101_144 : RowResult ⟨101, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_101_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 1 4 5)

theorem row_101_145 : RowResult ⟨101, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_101_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_101_146 : RowResult ⟨101, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_101_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 1 4 5)

theorem row_101_147 : RowResult ⟨101, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_101_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 1 4 5)

theorem row_101_148 : RowResult ⟨101, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_101_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 1 4 5)

theorem row_101_149 : RowResult ⟨101, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_101_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 1 4 5)

theorem row_101_150 : RowResult ⟨101, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_101_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 4 5)

theorem row_101_151 : RowResult ⟨101, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_101_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 4 5)

theorem row_101_152 : RowResult ⟨101, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_101_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 4 5)

theorem row_101_153 : RowResult ⟨101, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_101_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 4 5)

theorem row_101_154 : RowResult ⟨101, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_101_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 4 5)

theorem row_101_155 : RowResult ⟨101, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_101_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_101_156 : RowResult ⟨101, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_101_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 1 4 5)

theorem row_101_157 : RowResult ⟨101, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_101_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 1 4 5)

theorem row_101_158 : RowResult ⟨101, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_101_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 1 4 5)

theorem row_101_159 : RowResult ⟨101, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_101_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 1 4 5)

theorem row_101_160 : RowResult ⟨101, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_101_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 1 4 5)

theorem row_101_161 : RowResult ⟨101, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_101_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 1 4 5)

theorem row_101_162 : RowResult ⟨101, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_101_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 1 4 5)

theorem row_101_163 : RowResult ⟨101, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_101_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 1 4 5)

theorem row_101_164 : RowResult ⟨101, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_101_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 1 4 5)

theorem row_101_165 : RowResult ⟨101, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_101_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 1 4 5)

theorem row_101_166 : RowResult ⟨101, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_101_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 1 4 5)

theorem row_101_167 : RowResult ⟨101, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_101_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 1 4 5)

theorem row_101_168 : RowResult ⟨101, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_101_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 1 4 5)

theorem row_101_169 : RowResult ⟨101, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_101_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 1 4 5)

theorem row_101_170 : RowResult ⟨101, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_101_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_101_171 : RowResult ⟨101, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_101_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 1 4 5)

theorem row_101_172 : RowResult ⟨101, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_101_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 1 4 5)

theorem row_101_173 : RowResult ⟨101, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_101_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 1 4 5)

theorem row_101_174 : RowResult ⟨101, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_101_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 1 4 5)

theorem row_101_175 : RowResult ⟨101, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_101_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 4 5)

theorem row_101_176 : RowResult ⟨101, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_101_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 4 5)

theorem row_101_177 : RowResult ⟨101, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_101_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 4 5)

theorem row_101_178 : RowResult ⟨101, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_101_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 4 5)

theorem row_101_179 : RowResult ⟨101, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_101_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 4 5)

theorem row_101_180 : RowResult ⟨101, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_101_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 6)

theorem row_101_181 : RowResult ⟨101, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_101_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 1 4 5)

theorem row_101_182 : RowResult ⟨101, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_101_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 1 4 5)

theorem row_101_183 : RowResult ⟨101, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_101_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 1 4 5)

theorem row_101_184 : RowResult ⟨101, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_101_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 1 4 5)

theorem row_101_185 : RowResult ⟨101, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_101_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 1 4 5)

theorem row_101_186 : RowResult ⟨101, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_101_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 1 4 5)

theorem row_101_187 : RowResult ⟨101, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_101_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 1 4 5)

theorem row_101_188 : RowResult ⟨101, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_101_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 1 4 5)

theorem row_101_189 : RowResult ⟨101, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_101_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 1 4 5)

theorem row_101_190 : RowResult ⟨101, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_101_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 1 4 5)

theorem row_101_191 : RowResult ⟨101, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_101_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 1 4 5)

theorem row_101_192 : RowResult ⟨101, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_101_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 1 4 5)

theorem row_101_193 : RowResult ⟨101, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_101_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 1 4 5)

theorem row_101_194 : RowResult ⟨101, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_101_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 1 4 5)

theorem row_101_195 : RowResult ⟨101, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_101_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_101_196 : RowResult ⟨101, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_101_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 1 4 5)

theorem row_101_197 : RowResult ⟨101, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_101_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 1 4 5)

theorem row_101_198 : RowResult ⟨101, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_101_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 1 4 5)

theorem row_101_199 : RowResult ⟨101, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_101_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 1 4 5)

theorem row_101_200 : RowResult ⟨101, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_101_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 4 5)

theorem row_101_201 : RowResult ⟨101, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_101_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 4 5)

end RelativeConicArcs.Q25PairCertificate
