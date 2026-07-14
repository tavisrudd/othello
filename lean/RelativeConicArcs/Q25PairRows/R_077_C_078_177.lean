import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_77_78 : RowResult ⟨77, by decide⟩ ⟨78, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 0 4 6)

theorem row_77_79 : RowResult ⟨77, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_77_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 0 4 6)

theorem row_77_80 : RowResult ⟨77, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_77_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 0 4 6)

theorem row_77_81 : RowResult ⟨77, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_77_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 0 4 6)

theorem row_77_82 : RowResult ⟨77, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_77_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 0 4 6)

theorem row_77_83 : RowResult ⟨77, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_77_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 0 4 6)

theorem row_77_84 : RowResult ⟨77, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_77_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 0 4 6)

theorem row_77_85 : RowResult ⟨77, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_77_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 0 4 6)

theorem row_77_86 : RowResult ⟨77, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_77_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 0 4 6)

theorem row_77_87 : RowResult ⟨77, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_77_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 0 4 6)

theorem row_77_88 : RowResult ⟨77, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_77_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 0 4 6)

theorem row_77_89 : RowResult ⟨77, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_77_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 0 4 6)

theorem row_77_90 : RowResult ⟨77, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_77_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 0 4 6)

theorem row_77_91 : RowResult ⟨77, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_77_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 0 4 6)

theorem row_77_92 : RowResult ⟨77, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_77_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 0 4 6)

theorem row_77_93 : RowResult ⟨77, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_77_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 0 4 6)

theorem row_77_94 : RowResult ⟨77, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_77_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 0 4 6)

theorem row_77_95 : RowResult ⟨77, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_77_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 0 4 6)

theorem row_77_96 : RowResult ⟨77, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_77_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 0 4 6)

theorem row_77_97 : RowResult ⟨77, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_77_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 0 4 6)

theorem row_77_98 : RowResult ⟨77, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_77_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 0 4 6)

theorem row_77_99 : RowResult ⟨77, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_77_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 0 4 6)

theorem row_77_100 : RowResult ⟨77, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_77_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 4 5)

theorem row_77_101 : RowResult ⟨77, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_77_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 4 5)

theorem row_77_102 : RowResult ⟨77, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_77_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 4 5)

theorem row_77_103 : RowResult ⟨77, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_77_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 4 5)

theorem row_77_104 : RowResult ⟨77, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_77_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 4 5)

theorem row_77_105 : RowResult ⟨77, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_77_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_77_106 : RowResult ⟨77, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_77_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 1 4 5)

theorem row_77_107 : RowResult ⟨77, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_77_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 1 4 5)

theorem row_77_108 : RowResult ⟨77, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_77_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 1 4 5)

theorem row_77_109 : RowResult ⟨77, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_77_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 1 4 5)

theorem row_77_110 : RowResult ⟨77, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_77_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 1 4 5)

theorem row_77_111 : RowResult ⟨77, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_77_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 1 4 5)

theorem row_77_112 : RowResult ⟨77, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_77_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 1 4 5)

theorem row_77_113 : RowResult ⟨77, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_77_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 1 4 5)

theorem row_77_114 : RowResult ⟨77, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_77_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 1 4 5)

theorem row_77_115 : RowResult ⟨77, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_77_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 1 4 5)

theorem row_77_116 : RowResult ⟨77, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_77_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 1 4 5)

theorem row_77_117 : RowResult ⟨77, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_77_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 1 4 5)

theorem row_77_118 : RowResult ⟨77, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_77_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 1 4 5)

theorem row_77_119 : RowResult ⟨77, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_77_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 1 4 5)

theorem row_77_120 : RowResult ⟨77, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_77_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_77_121 : RowResult ⟨77, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_77_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 1 4 5)

theorem row_77_122 : RowResult ⟨77, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_77_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 1 4 5)

theorem row_77_123 : RowResult ⟨77, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_77_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 1 4 5)

theorem row_77_124 : RowResult ⟨77, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_77_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 1 4 5)

theorem row_77_125 : RowResult ⟨77, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_77_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 4 5)

theorem row_77_126 : RowResult ⟨77, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_77_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 4 5)

theorem row_77_127 : RowResult ⟨77, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_77_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 4 5)

theorem row_77_128 : RowResult ⟨77, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_77_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 4 5)

theorem row_77_129 : RowResult ⟨77, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_77_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 4 5)

theorem row_77_130 : RowResult ⟨77, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_77_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_77_131 : RowResult ⟨77, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_77_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 1 4 5)

theorem row_77_132 : RowResult ⟨77, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_77_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 1 4 5)

theorem row_77_133 : RowResult ⟨77, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_77_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 1 4 5)

theorem row_77_134 : RowResult ⟨77, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_77_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 1 4 5)

theorem row_77_135 : RowResult ⟨77, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_77_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 1 4 5)

theorem row_77_136 : RowResult ⟨77, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_77_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 1 4 5)

theorem row_77_137 : RowResult ⟨77, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_77_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 1 4 5)

theorem row_77_138 : RowResult ⟨77, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_77_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 1 4 5)

theorem row_77_139 : RowResult ⟨77, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_77_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 1 4 5)

theorem row_77_140 : RowResult ⟨77, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_77_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 1 4 5)

theorem row_77_141 : RowResult ⟨77, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_77_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 1 4 5)

theorem row_77_142 : RowResult ⟨77, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_77_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 1 4 5)

theorem row_77_143 : RowResult ⟨77, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_77_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 1 4 5)

theorem row_77_144 : RowResult ⟨77, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_77_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 1 4 5)

theorem row_77_145 : RowResult ⟨77, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_77_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_77_146 : RowResult ⟨77, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_77_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 1 4 5)

theorem row_77_147 : RowResult ⟨77, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_77_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 1 4 5)

theorem row_77_148 : RowResult ⟨77, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_77_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 1 4 5)

theorem row_77_149 : RowResult ⟨77, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_77_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 1 4 5)

theorem row_77_150 : RowResult ⟨77, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_77_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 4 5)

theorem row_77_151 : RowResult ⟨77, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_77_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 4 5)

theorem row_77_152 : RowResult ⟨77, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_77_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 4 5)

theorem row_77_153 : RowResult ⟨77, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_77_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 4 5)

theorem row_77_154 : RowResult ⟨77, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_77_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 4 5)

theorem row_77_155 : RowResult ⟨77, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_77_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 6)

theorem row_77_156 : RowResult ⟨77, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_77_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 1 4 5)

theorem row_77_157 : RowResult ⟨77, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_77_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 1 4 5)

theorem row_77_158 : RowResult ⟨77, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_77_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 1 4 5)

theorem row_77_159 : RowResult ⟨77, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_77_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 1 4 5)

theorem row_77_160 : RowResult ⟨77, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_77_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 1 4 5)

theorem row_77_161 : RowResult ⟨77, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_77_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 1 4 5)

theorem row_77_162 : RowResult ⟨77, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_77_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 1 4 5)

theorem row_77_163 : RowResult ⟨77, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_77_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 1 4 5)

theorem row_77_164 : RowResult ⟨77, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_77_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 1 4 5)

theorem row_77_165 : RowResult ⟨77, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_77_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 1 4 5)

theorem row_77_166 : RowResult ⟨77, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_77_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 1 4 5)

theorem row_77_167 : RowResult ⟨77, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_77_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 1 4 5)

theorem row_77_168 : RowResult ⟨77, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_77_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 1 4 5)

theorem row_77_169 : RowResult ⟨77, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_77_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 1 4 5)

theorem row_77_170 : RowResult ⟨77, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_77_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

theorem row_77_171 : RowResult ⟨77, by decide⟩ ⟨171, by decide⟩ := by
  have _previous := row_77_170
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨171, by decide⟩) 1 4 5)

theorem row_77_172 : RowResult ⟨77, by decide⟩ ⟨172, by decide⟩ := by
  have _previous := row_77_171
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨172, by decide⟩) 1 4 5)

theorem row_77_173 : RowResult ⟨77, by decide⟩ ⟨173, by decide⟩ := by
  have _previous := row_77_172
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) 1 4 5)

theorem row_77_174 : RowResult ⟨77, by decide⟩ ⟨174, by decide⟩ := by
  have _previous := row_77_173
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨174, by decide⟩) 1 4 5)

theorem row_77_175 : RowResult ⟨77, by decide⟩ ⟨175, by decide⟩ := by
  have _previous := row_77_174
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨175, by decide⟩) 1 4 5)

theorem row_77_176 : RowResult ⟨77, by decide⟩ ⟨176, by decide⟩ := by
  have _previous := row_77_175
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨176, by decide⟩) 1 4 5)

theorem row_77_177 : RowResult ⟨77, by decide⟩ ⟨177, by decide⟩ := by
  have _previous := row_77_176
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) (orbitCodeOfNumber ⟨177, by decide⟩) 1 4 5)

end RelativeConicArcs.Q25PairCertificate
