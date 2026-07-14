import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_80_81 : RowResult ⟨80, by decide⟩ ⟨81, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 0 4 6)

theorem row_80_82 : RowResult ⟨80, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_80_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 0 4 6)

theorem row_80_83 : RowResult ⟨80, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_80_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 0 4 6)

theorem row_80_84 : RowResult ⟨80, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_80_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 0 4 6)

theorem row_80_85 : RowResult ⟨80, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_80_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 0 4 6)

theorem row_80_86 : RowResult ⟨80, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_80_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 0 4 6)

theorem row_80_87 : RowResult ⟨80, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_80_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 0 4 6)

theorem row_80_88 : RowResult ⟨80, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_80_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 0 4 6)

theorem row_80_89 : RowResult ⟨80, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_80_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 0 4 6)

theorem row_80_90 : RowResult ⟨80, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_80_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 0 4 6)

theorem row_80_91 : RowResult ⟨80, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_80_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 0 4 6)

theorem row_80_92 : RowResult ⟨80, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_80_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 0 4 6)

theorem row_80_93 : RowResult ⟨80, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_80_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 0 4 6)

theorem row_80_94 : RowResult ⟨80, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_80_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 0 4 6)

theorem row_80_95 : RowResult ⟨80, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_80_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 0 4 6)

theorem row_80_96 : RowResult ⟨80, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_80_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 0 4 6)

theorem row_80_97 : RowResult ⟨80, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_80_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 0 4 6)

theorem row_80_98 : RowResult ⟨80, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_80_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 0 4 6)

theorem row_80_99 : RowResult ⟨80, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_80_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 0 4 6)

theorem row_80_100 : RowResult ⟨80, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_80_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 2 4)

theorem row_80_101 : RowResult ⟨80, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_80_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 2 4)

theorem row_80_102 : RowResult ⟨80, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_80_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 2 4)

theorem row_80_103 : RowResult ⟨80, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_80_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 2 4)

theorem row_80_104 : RowResult ⟨80, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_80_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 2 4)

theorem row_80_105 : RowResult ⟨80, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_80_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 4)

theorem row_80_106 : RowResult ⟨80, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_80_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 1 2 4)

theorem row_80_107 : RowResult ⟨80, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_80_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 1 2 4)

theorem row_80_108 : RowResult ⟨80, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_80_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 1 2 4)

theorem row_80_109 : RowResult ⟨80, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_80_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 1 2 4)

theorem row_80_110 : RowResult ⟨80, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_80_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 1 2 4)

theorem row_80_111 : RowResult ⟨80, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_80_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 1 2 4)

theorem row_80_112 : RowResult ⟨80, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_80_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 1 2 4)

theorem row_80_113 : RowResult ⟨80, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_80_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 1 2 4)

theorem row_80_114 : RowResult ⟨80, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_80_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 1 2 4)

theorem row_80_115 : RowResult ⟨80, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_80_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 1 2 4)

theorem row_80_116 : RowResult ⟨80, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_80_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 1 2 4)

theorem row_80_117 : RowResult ⟨80, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_80_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 1 2 4)

theorem row_80_118 : RowResult ⟨80, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_80_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 1 2 4)

theorem row_80_119 : RowResult ⟨80, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_80_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 1 2 4)

theorem row_80_120 : RowResult ⟨80, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_80_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 4)

theorem row_80_121 : RowResult ⟨80, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_80_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 1 2 4)

theorem row_80_122 : RowResult ⟨80, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_80_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 1 2 4)

theorem row_80_123 : RowResult ⟨80, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_80_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 1 2 4)

theorem row_80_124 : RowResult ⟨80, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_80_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 1 2 4)

theorem row_80_125 : RowResult ⟨80, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_80_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 2 4)

theorem row_80_126 : RowResult ⟨80, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_80_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 2 4)

theorem row_80_127 : RowResult ⟨80, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_80_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 2 4)

theorem row_80_128 : RowResult ⟨80, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_80_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 2 4)

theorem row_80_129 : RowResult ⟨80, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_80_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 2 4)

theorem row_80_130 : RowResult ⟨80, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_80_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 4)

theorem row_80_131 : RowResult ⟨80, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_80_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 1 2 4)

theorem row_80_132 : RowResult ⟨80, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_80_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 1 2 4)

theorem row_80_133 : RowResult ⟨80, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_80_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 1 2 4)

theorem row_80_134 : RowResult ⟨80, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_80_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 1 2 4)

theorem row_80_135 : RowResult ⟨80, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_80_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 1 2 4)

theorem row_80_136 : RowResult ⟨80, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_80_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 1 2 4)

theorem row_80_137 : RowResult ⟨80, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_80_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 1 2 4)

theorem row_80_138 : RowResult ⟨80, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_80_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 1 2 4)

theorem row_80_139 : RowResult ⟨80, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_80_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 1 2 4)

theorem row_80_140 : RowResult ⟨80, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_80_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 1 2 4)

theorem row_80_141 : RowResult ⟨80, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_80_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 1 2 4)

theorem row_80_142 : RowResult ⟨80, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_80_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 1 2 4)

theorem row_80_143 : RowResult ⟨80, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_80_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 1 2 4)

theorem row_80_144 : RowResult ⟨80, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_80_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 1 2 4)

theorem row_80_145 : RowResult ⟨80, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_80_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 4)

theorem row_80_146 : RowResult ⟨80, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_80_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 1 2 4)

theorem row_80_147 : RowResult ⟨80, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_80_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 1 2 4)

theorem row_80_148 : RowResult ⟨80, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_80_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 1 2 4)

theorem row_80_149 : RowResult ⟨80, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_80_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 1 2 4)

theorem row_80_150 : RowResult ⟨80, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_80_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 2 4)

theorem row_80_151 : RowResult ⟨80, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_80_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 2 4)

theorem row_80_152 : RowResult ⟨80, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_80_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 2 4)

theorem row_80_153 : RowResult ⟨80, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_80_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 2 4)

theorem row_80_154 : RowResult ⟨80, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_80_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 2 4)

theorem row_80_155 : RowResult ⟨80, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_80_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 4)

theorem row_80_156 : RowResult ⟨80, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_80_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 1 2 4)

theorem row_80_157 : RowResult ⟨80, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_80_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 1 2 4)

theorem row_80_158 : RowResult ⟨80, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_80_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 1 2 4)

theorem row_80_159 : RowResult ⟨80, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_80_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 1 2 4)

theorem row_80_160 : RowResult ⟨80, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_80_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 1 2 4)

theorem row_80_161 : RowResult ⟨80, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_80_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 1 2 4)

theorem row_80_162 : RowResult ⟨80, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_80_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 1 2 4)

theorem row_80_163 : RowResult ⟨80, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_80_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 1 2 4)

theorem row_80_164 : RowResult ⟨80, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_80_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 1 2 4)

theorem row_80_165 : RowResult ⟨80, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_80_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 1 2 4)

theorem row_80_166 : RowResult ⟨80, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_80_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 1 2 4)

theorem row_80_167 : RowResult ⟨80, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_80_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 1 2 4)

theorem row_80_168 : RowResult ⟨80, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_80_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 1 2 4)

theorem row_80_169 : RowResult ⟨80, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_80_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 1 2 4)

theorem row_80_170 : RowResult ⟨80, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_80_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 4)

theorem row_80_171 : RowResult ⟨80, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_80_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 1 2 4)

theorem row_80_172 : RowResult ⟨80, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_80_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 1 2 4)

theorem row_80_173 : RowResult ⟨80, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_80_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 1 2 4)

theorem row_80_174 : RowResult ⟨80, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_80_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 1 2 4)

theorem row_80_175 : RowResult ⟨80, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_80_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 2 4)

theorem row_80_176 : RowResult ⟨80, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_80_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 2 4)

theorem row_80_177 : RowResult ⟨80, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_80_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 2 4)

theorem row_80_178 : RowResult ⟨80, by decide⟩ ⟨178, by decide⟩ := by
  have _previous := row_80_177
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨178, by decide⟩) 1 2 4)

theorem row_80_179 : RowResult ⟨80, by decide⟩ ⟨179, by decide⟩ := by
  have _previous := row_80_178
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨179, by decide⟩) 1 2 4)

theorem row_80_180 : RowResult ⟨80, by decide⟩ ⟨180, by decide⟩ := by
  have _previous := row_80_179
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) (orbitCodeOfNumber ⟨180, by decide⟩) 1 2 4)

end RelativeConicArcs.Q25PairCertificate
