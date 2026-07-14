import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_70_71 : RowResult ⟨70, by decide⟩ ⟨71, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 0 4 6)

theorem row_70_72 : RowResult ⟨70, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_70_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 0 4 6)

theorem row_70_73 : RowResult ⟨70, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_70_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 0 4 6)

theorem row_70_74 : RowResult ⟨70, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_70_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 0 4 6)

theorem row_70_75 : RowResult ⟨70, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_70_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 2 5)

theorem row_70_76 : RowResult ⟨70, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_70_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 2 5)

theorem row_70_77 : RowResult ⟨70, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_70_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 2 5)

theorem row_70_78 : RowResult ⟨70, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_70_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 2 5)

theorem row_70_79 : RowResult ⟨70, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_70_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 2 5)

theorem row_70_80 : RowResult ⟨70, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_70_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 5)

theorem row_70_81 : RowResult ⟨70, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_70_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 1 2 5)

theorem row_70_82 : RowResult ⟨70, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_70_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 1 2 5)

theorem row_70_83 : RowResult ⟨70, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_70_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 1 2 5)

theorem row_70_84 : RowResult ⟨70, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_70_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 1 2 5)

theorem row_70_85 : RowResult ⟨70, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_70_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 1 2 5)

theorem row_70_86 : RowResult ⟨70, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_70_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 1 2 5)

theorem row_70_87 : RowResult ⟨70, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_70_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 1 2 5)

theorem row_70_88 : RowResult ⟨70, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_70_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 1 2 5)

theorem row_70_89 : RowResult ⟨70, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_70_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 1 2 5)

theorem row_70_90 : RowResult ⟨70, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_70_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 1 2 5)

theorem row_70_91 : RowResult ⟨70, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_70_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 1 2 5)

theorem row_70_92 : RowResult ⟨70, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_70_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 1 2 5)

theorem row_70_93 : RowResult ⟨70, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_70_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 1 2 5)

theorem row_70_94 : RowResult ⟨70, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_70_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 1 2 5)

theorem row_70_95 : RowResult ⟨70, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_70_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 5)

theorem row_70_96 : RowResult ⟨70, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_70_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 1 2 5)

theorem row_70_97 : RowResult ⟨70, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_70_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 1 2 5)

theorem row_70_98 : RowResult ⟨70, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_70_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 1 2 5)

theorem row_70_99 : RowResult ⟨70, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_70_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 1 2 5)

theorem row_70_100 : RowResult ⟨70, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_70_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 2 5)

theorem row_70_101 : RowResult ⟨70, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_70_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 2 5)

theorem row_70_102 : RowResult ⟨70, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_70_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 2 5)

theorem row_70_103 : RowResult ⟨70, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_70_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 2 5)

theorem row_70_104 : RowResult ⟨70, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_70_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 2 5)

theorem row_70_105 : RowResult ⟨70, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_70_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 5)

theorem row_70_106 : RowResult ⟨70, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_70_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 1 2 5)

theorem row_70_107 : RowResult ⟨70, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_70_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 1 2 5)

theorem row_70_108 : RowResult ⟨70, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_70_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 1 2 5)

theorem row_70_109 : RowResult ⟨70, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_70_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 1 2 5)

theorem row_70_110 : RowResult ⟨70, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_70_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 1 2 5)

theorem row_70_111 : RowResult ⟨70, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_70_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 1 2 5)

theorem row_70_112 : RowResult ⟨70, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_70_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 1 2 5)

theorem row_70_113 : RowResult ⟨70, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_70_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 1 2 5)

theorem row_70_114 : RowResult ⟨70, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_70_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 1 2 5)

theorem row_70_115 : RowResult ⟨70, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_70_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 1 2 5)

theorem row_70_116 : RowResult ⟨70, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_70_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 1 2 5)

theorem row_70_117 : RowResult ⟨70, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_70_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 1 2 5)

theorem row_70_118 : RowResult ⟨70, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_70_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 1 2 5)

theorem row_70_119 : RowResult ⟨70, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_70_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 1 2 5)

theorem row_70_120 : RowResult ⟨70, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_70_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 5)

theorem row_70_121 : RowResult ⟨70, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_70_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 1 2 5)

theorem row_70_122 : RowResult ⟨70, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_70_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 1 2 5)

theorem row_70_123 : RowResult ⟨70, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_70_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 1 2 5)

theorem row_70_124 : RowResult ⟨70, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_70_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 1 2 5)

theorem row_70_125 : RowResult ⟨70, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_70_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 2 5)

theorem row_70_126 : RowResult ⟨70, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_70_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 2 5)

theorem row_70_127 : RowResult ⟨70, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_70_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 2 5)

theorem row_70_128 : RowResult ⟨70, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_70_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 2 5)

theorem row_70_129 : RowResult ⟨70, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_70_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 2 5)

theorem row_70_130 : RowResult ⟨70, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_70_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 5)

theorem row_70_131 : RowResult ⟨70, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_70_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 1 2 5)

theorem row_70_132 : RowResult ⟨70, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_70_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 1 2 5)

theorem row_70_133 : RowResult ⟨70, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_70_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 1 2 5)

theorem row_70_134 : RowResult ⟨70, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_70_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 1 2 5)

theorem row_70_135 : RowResult ⟨70, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_70_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 1 2 5)

theorem row_70_136 : RowResult ⟨70, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_70_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 1 2 5)

theorem row_70_137 : RowResult ⟨70, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_70_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 1 2 5)

theorem row_70_138 : RowResult ⟨70, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_70_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 1 2 5)

theorem row_70_139 : RowResult ⟨70, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_70_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 1 2 5)

theorem row_70_140 : RowResult ⟨70, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_70_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 1 2 5)

theorem row_70_141 : RowResult ⟨70, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_70_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 1 2 5)

theorem row_70_142 : RowResult ⟨70, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_70_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 1 2 5)

theorem row_70_143 : RowResult ⟨70, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_70_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 1 2 5)

theorem row_70_144 : RowResult ⟨70, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_70_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 1 2 5)

theorem row_70_145 : RowResult ⟨70, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_70_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 5)

theorem row_70_146 : RowResult ⟨70, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_70_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 1 2 5)

theorem row_70_147 : RowResult ⟨70, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_70_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 1 2 5)

theorem row_70_148 : RowResult ⟨70, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_70_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 1 2 5)

theorem row_70_149 : RowResult ⟨70, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_70_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 1 2 5)

theorem row_70_150 : RowResult ⟨70, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_70_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 2 5)

theorem row_70_151 : RowResult ⟨70, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_70_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 2 5)

theorem row_70_152 : RowResult ⟨70, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_70_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 2 5)

theorem row_70_153 : RowResult ⟨70, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_70_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 2 5)

theorem row_70_154 : RowResult ⟨70, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_70_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 2 5)

theorem row_70_155 : RowResult ⟨70, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_70_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 5)

theorem row_70_156 : RowResult ⟨70, by decide⟩ ⟨156, by decide⟩ := by
  have _previous := row_70_155
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨156, by decide⟩) 1 2 5)

theorem row_70_157 : RowResult ⟨70, by decide⟩ ⟨157, by decide⟩ := by
  have _previous := row_70_156
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨157, by decide⟩) 1 2 5)

theorem row_70_158 : RowResult ⟨70, by decide⟩ ⟨158, by decide⟩ := by
  have _previous := row_70_157
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨158, by decide⟩) 1 2 5)

theorem row_70_159 : RowResult ⟨70, by decide⟩ ⟨159, by decide⟩ := by
  have _previous := row_70_158
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨159, by decide⟩) 1 2 5)

theorem row_70_160 : RowResult ⟨70, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_70_159
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨160, by decide⟩) 1 2 5)

theorem row_70_161 : RowResult ⟨70, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_70_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 1 2 5)

theorem row_70_162 : RowResult ⟨70, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_70_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 1 2 5)

theorem row_70_163 : RowResult ⟨70, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_70_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 1 2 5)

theorem row_70_164 : RowResult ⟨70, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_70_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 1 2 5)

theorem row_70_165 : RowResult ⟨70, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_70_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 1 2 5)

theorem row_70_166 : RowResult ⟨70, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_70_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 1 2 5)

theorem row_70_167 : RowResult ⟨70, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_70_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 1 2 5)

theorem row_70_168 : RowResult ⟨70, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_70_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 1 2 5)

theorem row_70_169 : RowResult ⟨70, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_70_168
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨169, by decide⟩) 1 2 5)

theorem row_70_170 : RowResult ⟨70, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_70_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 5)

end RelativeConicArcs.Q25PairCertificate
