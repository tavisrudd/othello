import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_95_96 : RowResult ⟨95, by decide⟩ ⟨96, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 0 4 6)

theorem row_95_97 : RowResult ⟨95, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_95_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 0 4 6)

theorem row_95_98 : RowResult ⟨95, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_95_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 0 4 6)

theorem row_95_99 : RowResult ⟨95, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_95_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 0 4 6)

theorem row_95_100 : RowResult ⟨95, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_95_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 2 5)

theorem row_95_101 : RowResult ⟨95, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_95_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 2 5)

theorem row_95_102 : RowResult ⟨95, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_95_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 2 5)

theorem row_95_103 : RowResult ⟨95, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_95_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 2 5)

theorem row_95_104 : RowResult ⟨95, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_95_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 2 5)

theorem row_95_105 : RowResult ⟨95, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_95_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 5)

theorem row_95_106 : RowResult ⟨95, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_95_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 1 2 5)

theorem row_95_107 : RowResult ⟨95, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_95_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 1 2 5)

theorem row_95_108 : RowResult ⟨95, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_95_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 1 2 5)

theorem row_95_109 : RowResult ⟨95, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_95_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 1 2 5)

theorem row_95_110 : RowResult ⟨95, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_95_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 1 2 5)

theorem row_95_111 : RowResult ⟨95, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_95_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 1 2 5)

theorem row_95_112 : RowResult ⟨95, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_95_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 1 2 5)

theorem row_95_113 : RowResult ⟨95, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_95_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 1 2 5)

theorem row_95_114 : RowResult ⟨95, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_95_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 1 2 5)

theorem row_95_115 : RowResult ⟨95, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_95_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 1 2 5)

theorem row_95_116 : RowResult ⟨95, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_95_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 1 2 5)

theorem row_95_117 : RowResult ⟨95, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_95_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 1 2 5)

theorem row_95_118 : RowResult ⟨95, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_95_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 1 2 5)

theorem row_95_119 : RowResult ⟨95, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_95_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 1 2 5)

theorem row_95_120 : RowResult ⟨95, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_95_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 5)

theorem row_95_121 : RowResult ⟨95, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_95_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 1 2 5)

theorem row_95_122 : RowResult ⟨95, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_95_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 1 2 5)

theorem row_95_123 : RowResult ⟨95, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_95_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 1 2 5)

theorem row_95_124 : RowResult ⟨95, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_95_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 1 2 5)

theorem row_95_125 : RowResult ⟨95, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_95_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 2 5)

theorem row_95_126 : RowResult ⟨95, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_95_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 2 5)

theorem row_95_127 : RowResult ⟨95, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_95_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 2 5)

theorem row_95_128 : RowResult ⟨95, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_95_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 2 5)

theorem row_95_129 : RowResult ⟨95, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_95_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 2 5)

theorem row_95_130 : RowResult ⟨95, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_95_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 5)

theorem row_95_131 : RowResult ⟨95, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_95_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 1 2 5)

theorem row_95_132 : RowResult ⟨95, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_95_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 1 2 5)

theorem row_95_133 : RowResult ⟨95, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_95_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 1 2 5)

theorem row_95_134 : RowResult ⟨95, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_95_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 1 2 5)

theorem row_95_135 : RowResult ⟨95, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_95_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 1 2 5)

theorem row_95_136 : RowResult ⟨95, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_95_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 1 2 5)

theorem row_95_137 : RowResult ⟨95, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_95_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 1 2 5)

theorem row_95_138 : RowResult ⟨95, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_95_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 1 2 5)

theorem row_95_139 : RowResult ⟨95, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_95_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 1 2 5)

theorem row_95_140 : RowResult ⟨95, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_95_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 1 2 5)

theorem row_95_141 : RowResult ⟨95, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_95_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 1 2 5)

theorem row_95_142 : RowResult ⟨95, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_95_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 1 2 5)

theorem row_95_143 : RowResult ⟨95, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_95_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 1 2 5)

theorem row_95_144 : RowResult ⟨95, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_95_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 1 2 5)

theorem row_95_145 : RowResult ⟨95, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_95_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 5)

theorem row_95_146 : RowResult ⟨95, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_95_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 1 2 5)

theorem row_95_147 : RowResult ⟨95, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_95_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 1 2 5)

theorem row_95_148 : RowResult ⟨95, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_95_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 1 2 5)

theorem row_95_149 : RowResult ⟨95, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_95_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 1 2 5)

theorem row_95_150 : RowResult ⟨95, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_95_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 2 5)

theorem row_95_151 : RowResult ⟨95, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_95_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 2 5)

theorem row_95_152 : RowResult ⟨95, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_95_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 2 5)

theorem row_95_153 : RowResult ⟨95, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_95_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 2 5)

theorem row_95_154 : RowResult ⟨95, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_95_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 2 5)

theorem row_95_155 : RowResult ⟨95, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_95_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 5)

theorem row_95_156 : RowResult ⟨95, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_95_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 1 2 5)

theorem row_95_157 : RowResult ⟨95, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_95_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 1 2 5)

theorem row_95_158 : RowResult ⟨95, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_95_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 1 2 5)

theorem row_95_159 : RowResult ⟨95, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_95_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 1 2 5)

theorem row_95_160 : RowResult ⟨95, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_95_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 1 2 5)

theorem row_95_161 : RowResult ⟨95, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_95_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 1 2 5)

theorem row_95_162 : RowResult ⟨95, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_95_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 1 2 5)

theorem row_95_163 : RowResult ⟨95, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_95_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 1 2 5)

theorem row_95_164 : RowResult ⟨95, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_95_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 1 2 5)

theorem row_95_165 : RowResult ⟨95, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_95_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 1 2 5)

theorem row_95_166 : RowResult ⟨95, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_95_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 1 2 5)

theorem row_95_167 : RowResult ⟨95, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_95_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 1 2 5)

theorem row_95_168 : RowResult ⟨95, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_95_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 1 2 5)

theorem row_95_169 : RowResult ⟨95, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_95_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 1 2 5)

theorem row_95_170 : RowResult ⟨95, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_95_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 5)

theorem row_95_171 : RowResult ⟨95, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_95_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 1 2 5)

theorem row_95_172 : RowResult ⟨95, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_95_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 1 2 5)

theorem row_95_173 : RowResult ⟨95, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_95_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 1 2 5)

theorem row_95_174 : RowResult ⟨95, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_95_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 1 2 5)

theorem row_95_175 : RowResult ⟨95, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_95_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 2 5)

theorem row_95_176 : RowResult ⟨95, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_95_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 2 5)

theorem row_95_177 : RowResult ⟨95, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_95_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 2 5)

theorem row_95_178 : RowResult ⟨95, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_95_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 2 5)

theorem row_95_179 : RowResult ⟨95, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_95_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 2 5)

theorem row_95_180 : RowResult ⟨95, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_95_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 5)

theorem row_95_181 : RowResult ⟨95, by decide⟩ ⟨181, by decide⟩ := by
  have _previous := row_95_180
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨181, by decide⟩) 1 2 5)

theorem row_95_182 : RowResult ⟨95, by decide⟩ ⟨182, by decide⟩ := by
  have _previous := row_95_181
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨182, by decide⟩) 1 2 5)

theorem row_95_183 : RowResult ⟨95, by decide⟩ ⟨183, by decide⟩ := by
  have _previous := row_95_182
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨183, by decide⟩) 1 2 5)

theorem row_95_184 : RowResult ⟨95, by decide⟩ ⟨184, by decide⟩ := by
  have _previous := row_95_183
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨184, by decide⟩) 1 2 5)

theorem row_95_185 : RowResult ⟨95, by decide⟩ ⟨185, by decide⟩ := by
  have _previous := row_95_184
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨185, by decide⟩) 1 2 5)

theorem row_95_186 : RowResult ⟨95, by decide⟩ ⟨186, by decide⟩ := by
  have _previous := row_95_185
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨186, by decide⟩) 1 2 5)

theorem row_95_187 : RowResult ⟨95, by decide⟩ ⟨187, by decide⟩ := by
  have _previous := row_95_186
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨187, by decide⟩) 1 2 5)

theorem row_95_188 : RowResult ⟨95, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_95_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 1 2 5)

theorem row_95_189 : RowResult ⟨95, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_95_188
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨189, by decide⟩) 1 2 5)

theorem row_95_190 : RowResult ⟨95, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_95_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 1 2 5)

theorem row_95_191 : RowResult ⟨95, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_95_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 1 2 5)

theorem row_95_192 : RowResult ⟨95, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_95_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 1 2 5)

theorem row_95_193 : RowResult ⟨95, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_95_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 1 2 5)

theorem row_95_194 : RowResult ⟨95, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_95_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 1 2 5)

theorem row_95_195 : RowResult ⟨95, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_95_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 5)

end RelativeConicArcs.Q25PairCertificate
