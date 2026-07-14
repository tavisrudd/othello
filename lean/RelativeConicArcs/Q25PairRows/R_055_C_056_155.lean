import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_55_56 : RowResult ⟨55, by decide⟩ ⟨56, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 0 4 6)

theorem row_55_57 : RowResult ⟨55, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_55_56
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) 0 4 6)

theorem row_55_58 : RowResult ⟨55, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_55_57
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) 0 4 6)

theorem row_55_59 : RowResult ⟨55, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_55_58
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) 0 4 6)

theorem row_55_60 : RowResult ⟨55, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_55_59
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) 0 4 6)

theorem row_55_61 : RowResult ⟨55, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_55_60
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) 0 4 6)

theorem row_55_62 : RowResult ⟨55, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_55_61
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) 0 4 6)

theorem row_55_63 : RowResult ⟨55, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_55_62
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) 0 4 6)

theorem row_55_64 : RowResult ⟨55, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_55_63
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) 0 4 6)

theorem row_55_65 : RowResult ⟨55, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_55_64
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) 0 4 6)

theorem row_55_66 : RowResult ⟨55, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_55_65
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) 0 4 6)

theorem row_55_67 : RowResult ⟨55, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_55_66
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) 0 4 6)

theorem row_55_68 : RowResult ⟨55, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_55_67
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) 0 4 6)

theorem row_55_69 : RowResult ⟨55, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_55_68
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 0 4 6)

theorem row_55_70 : RowResult ⟨55, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_55_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 0 4 6)

theorem row_55_71 : RowResult ⟨55, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_55_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 0 4 6)

theorem row_55_72 : RowResult ⟨55, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_55_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 0 4 6)

theorem row_55_73 : RowResult ⟨55, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_55_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 0 4 6)

theorem row_55_74 : RowResult ⟨55, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_55_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 0 4 6)

theorem row_55_75 : RowResult ⟨55, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_55_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 2 4)

theorem row_55_76 : RowResult ⟨55, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_55_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 2 4)

theorem row_55_77 : RowResult ⟨55, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_55_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 2 4)

theorem row_55_78 : RowResult ⟨55, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_55_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 2 4)

theorem row_55_79 : RowResult ⟨55, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_55_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 2 4)

theorem row_55_80 : RowResult ⟨55, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_55_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 4)

theorem row_55_81 : RowResult ⟨55, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_55_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 1 2 4)

theorem row_55_82 : RowResult ⟨55, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_55_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 1 2 4)

theorem row_55_83 : RowResult ⟨55, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_55_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 1 2 4)

theorem row_55_84 : RowResult ⟨55, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_55_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 1 2 4)

theorem row_55_85 : RowResult ⟨55, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_55_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 1 2 4)

theorem row_55_86 : RowResult ⟨55, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_55_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 1 2 4)

theorem row_55_87 : RowResult ⟨55, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_55_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 1 2 4)

theorem row_55_88 : RowResult ⟨55, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_55_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 1 2 4)

theorem row_55_89 : RowResult ⟨55, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_55_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 1 2 4)

theorem row_55_90 : RowResult ⟨55, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_55_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 1 2 4)

theorem row_55_91 : RowResult ⟨55, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_55_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 1 2 4)

theorem row_55_92 : RowResult ⟨55, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_55_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 1 2 4)

theorem row_55_93 : RowResult ⟨55, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_55_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 1 2 4)

theorem row_55_94 : RowResult ⟨55, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_55_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 1 2 4)

theorem row_55_95 : RowResult ⟨55, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_55_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 4)

theorem row_55_96 : RowResult ⟨55, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_55_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 1 2 4)

theorem row_55_97 : RowResult ⟨55, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_55_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 1 2 4)

theorem row_55_98 : RowResult ⟨55, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_55_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 1 2 4)

theorem row_55_99 : RowResult ⟨55, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_55_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 1 2 4)

theorem row_55_100 : RowResult ⟨55, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_55_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 2 4)

theorem row_55_101 : RowResult ⟨55, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_55_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 2 4)

theorem row_55_102 : RowResult ⟨55, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_55_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 2 4)

theorem row_55_103 : RowResult ⟨55, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_55_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 2 4)

theorem row_55_104 : RowResult ⟨55, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_55_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 2 4)

theorem row_55_105 : RowResult ⟨55, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_55_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 4)

theorem row_55_106 : RowResult ⟨55, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_55_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 1 2 4)

theorem row_55_107 : RowResult ⟨55, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_55_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 1 2 4)

theorem row_55_108 : RowResult ⟨55, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_55_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 1 2 4)

theorem row_55_109 : RowResult ⟨55, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_55_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 1 2 4)

theorem row_55_110 : RowResult ⟨55, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_55_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 1 2 4)

theorem row_55_111 : RowResult ⟨55, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_55_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 1 2 4)

theorem row_55_112 : RowResult ⟨55, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_55_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 1 2 4)

theorem row_55_113 : RowResult ⟨55, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_55_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 1 2 4)

theorem row_55_114 : RowResult ⟨55, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_55_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 1 2 4)

theorem row_55_115 : RowResult ⟨55, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_55_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 1 2 4)

theorem row_55_116 : RowResult ⟨55, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_55_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 1 2 4)

theorem row_55_117 : RowResult ⟨55, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_55_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 1 2 4)

theorem row_55_118 : RowResult ⟨55, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_55_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 1 2 4)

theorem row_55_119 : RowResult ⟨55, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_55_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 1 2 4)

theorem row_55_120 : RowResult ⟨55, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_55_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 4)

theorem row_55_121 : RowResult ⟨55, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_55_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 1 2 4)

theorem row_55_122 : RowResult ⟨55, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_55_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 1 2 4)

theorem row_55_123 : RowResult ⟨55, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_55_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 1 2 4)

theorem row_55_124 : RowResult ⟨55, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_55_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 1 2 4)

theorem row_55_125 : RowResult ⟨55, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_55_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 2 4)

theorem row_55_126 : RowResult ⟨55, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_55_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 2 4)

theorem row_55_127 : RowResult ⟨55, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_55_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 2 4)

theorem row_55_128 : RowResult ⟨55, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_55_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 2 4)

theorem row_55_129 : RowResult ⟨55, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_55_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 2 4)

theorem row_55_130 : RowResult ⟨55, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_55_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 4)

theorem row_55_131 : RowResult ⟨55, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_55_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 1 2 4)

theorem row_55_132 : RowResult ⟨55, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_55_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 1 2 4)

theorem row_55_133 : RowResult ⟨55, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_55_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 1 2 4)

theorem row_55_134 : RowResult ⟨55, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_55_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 1 2 4)

theorem row_55_135 : RowResult ⟨55, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_55_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 1 2 4)

theorem row_55_136 : RowResult ⟨55, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_55_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 1 2 4)

theorem row_55_137 : RowResult ⟨55, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_55_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 1 2 4)

theorem row_55_138 : RowResult ⟨55, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_55_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 1 2 4)

theorem row_55_139 : RowResult ⟨55, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_55_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 1 2 4)

theorem row_55_140 : RowResult ⟨55, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_55_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 1 2 4)

theorem row_55_141 : RowResult ⟨55, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_55_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 1 2 4)

theorem row_55_142 : RowResult ⟨55, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_55_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 1 2 4)

theorem row_55_143 : RowResult ⟨55, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_55_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 1 2 4)

theorem row_55_144 : RowResult ⟨55, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_55_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 1 2 4)

theorem row_55_145 : RowResult ⟨55, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_55_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 4)

theorem row_55_146 : RowResult ⟨55, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_55_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 1 2 4)

theorem row_55_147 : RowResult ⟨55, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_55_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 1 2 4)

theorem row_55_148 : RowResult ⟨55, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_55_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 1 2 4)

theorem row_55_149 : RowResult ⟨55, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_55_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 1 2 4)

theorem row_55_150 : RowResult ⟨55, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_55_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 2 4)

theorem row_55_151 : RowResult ⟨55, by decide⟩ ⟨151, by decide⟩ := by
  have _previous := row_55_150
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨151, by decide⟩) 1 2 4)

theorem row_55_152 : RowResult ⟨55, by decide⟩ ⟨152, by decide⟩ := by
  have _previous := row_55_151
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨152, by decide⟩) 1 2 4)

theorem row_55_153 : RowResult ⟨55, by decide⟩ ⟨153, by decide⟩ := by
  have _previous := row_55_152
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨153, by decide⟩) 1 2 4)

theorem row_55_154 : RowResult ⟨55, by decide⟩ ⟨154, by decide⟩ := by
  have _previous := row_55_153
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨154, by decide⟩) 1 2 4)

theorem row_55_155 : RowResult ⟨55, by decide⟩ ⟨155, by decide⟩ := by
  have _previous := row_55_154
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) (orbitCodeOfNumber ⟨155, by decide⟩) 1 2 4)

end RelativeConicArcs.Q25PairCertificate
