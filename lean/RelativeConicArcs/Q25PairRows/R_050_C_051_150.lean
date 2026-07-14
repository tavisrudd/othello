import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_50_51 : RowResult ⟨50, by decide⟩ ⟨51, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 0 4 6)

theorem row_50_52 : RowResult ⟨50, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_50_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 0 4 6)

theorem row_50_53 : RowResult ⟨50, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_50_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 0 4 6)

theorem row_50_54 : RowResult ⟨50, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_50_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 0 4 6)

theorem row_50_55 : RowResult ⟨50, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_50_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 0 4 6)

theorem row_50_56 : RowResult ⟨50, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_50_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 0 4 6)

theorem row_50_57 : RowResult ⟨50, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_50_56
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) 0 4 6)

theorem row_50_58 : RowResult ⟨50, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_50_57
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) 0 4 6)

theorem row_50_59 : RowResult ⟨50, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_50_58
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) 0 4 6)

theorem row_50_60 : RowResult ⟨50, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_50_59
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) 0 4 6)

theorem row_50_61 : RowResult ⟨50, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_50_60
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) 0 4 6)

theorem row_50_62 : RowResult ⟨50, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_50_61
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) 0 4 6)

theorem row_50_63 : RowResult ⟨50, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_50_62
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) 0 4 6)

theorem row_50_64 : RowResult ⟨50, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_50_63
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) 0 4 6)

theorem row_50_65 : RowResult ⟨50, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_50_64
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) 0 4 6)

theorem row_50_66 : RowResult ⟨50, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_50_65
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) 0 4 6)

theorem row_50_67 : RowResult ⟨50, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_50_66
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) 0 4 6)

theorem row_50_68 : RowResult ⟨50, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_50_67
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) 0 4 6)

theorem row_50_69 : RowResult ⟨50, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_50_68
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 0 4 6)

theorem row_50_70 : RowResult ⟨50, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_50_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 0 4 6)

theorem row_50_71 : RowResult ⟨50, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_50_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 0 4 6)

theorem row_50_72 : RowResult ⟨50, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_50_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 0 4 6)

theorem row_50_73 : RowResult ⟨50, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_50_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 0 4 6)

theorem row_50_74 : RowResult ⟨50, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_50_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 0 4 6)

theorem row_50_75 : RowResult ⟨50, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_50_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 4 5)

theorem row_50_76 : RowResult ⟨50, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_50_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 4 5)

theorem row_50_77 : RowResult ⟨50, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_50_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 4 5)

theorem row_50_78 : RowResult ⟨50, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_50_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 4 5)

theorem row_50_79 : RowResult ⟨50, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_50_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 4 5)

theorem row_50_80 : RowResult ⟨50, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_50_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_50_81 : RowResult ⟨50, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_50_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 1 4 5)

theorem row_50_82 : RowResult ⟨50, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_50_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 1 4 5)

theorem row_50_83 : RowResult ⟨50, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_50_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 1 4 5)

theorem row_50_84 : RowResult ⟨50, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_50_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 1 4 5)

theorem row_50_85 : RowResult ⟨50, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_50_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 1 4 5)

theorem row_50_86 : RowResult ⟨50, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_50_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 1 4 5)

theorem row_50_87 : RowResult ⟨50, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_50_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 1 4 5)

theorem row_50_88 : RowResult ⟨50, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_50_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 1 4 5)

theorem row_50_89 : RowResult ⟨50, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_50_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 1 4 5)

theorem row_50_90 : RowResult ⟨50, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_50_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 1 4 5)

theorem row_50_91 : RowResult ⟨50, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_50_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 1 4 5)

theorem row_50_92 : RowResult ⟨50, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_50_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 1 4 5)

theorem row_50_93 : RowResult ⟨50, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_50_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 1 4 5)

theorem row_50_94 : RowResult ⟨50, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_50_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 1 4 5)

theorem row_50_95 : RowResult ⟨50, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_50_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_50_96 : RowResult ⟨50, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_50_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 1 4 5)

theorem row_50_97 : RowResult ⟨50, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_50_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 1 4 5)

theorem row_50_98 : RowResult ⟨50, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_50_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 1 4 5)

theorem row_50_99 : RowResult ⟨50, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_50_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 1 4 5)

theorem row_50_100 : RowResult ⟨50, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_50_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 4 5)

theorem row_50_101 : RowResult ⟨50, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_50_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 4 5)

theorem row_50_102 : RowResult ⟨50, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_50_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 4 5)

theorem row_50_103 : RowResult ⟨50, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_50_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 4 5)

theorem row_50_104 : RowResult ⟨50, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_50_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 4 5)

theorem row_50_105 : RowResult ⟨50, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_50_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_50_106 : RowResult ⟨50, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_50_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 1 4 5)

theorem row_50_107 : RowResult ⟨50, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_50_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 1 4 5)

theorem row_50_108 : RowResult ⟨50, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_50_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 1 4 5)

theorem row_50_109 : RowResult ⟨50, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_50_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 1 4 5)

theorem row_50_110 : RowResult ⟨50, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_50_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 1 4 5)

theorem row_50_111 : RowResult ⟨50, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_50_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 1 4 5)

theorem row_50_112 : RowResult ⟨50, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_50_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 1 4 5)

theorem row_50_113 : RowResult ⟨50, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_50_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 1 4 5)

theorem row_50_114 : RowResult ⟨50, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_50_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 1 4 5)

theorem row_50_115 : RowResult ⟨50, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_50_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 1 4 5)

theorem row_50_116 : RowResult ⟨50, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_50_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 1 4 5)

theorem row_50_117 : RowResult ⟨50, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_50_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 1 4 5)

theorem row_50_118 : RowResult ⟨50, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_50_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 1 4 5)

theorem row_50_119 : RowResult ⟨50, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_50_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 1 4 5)

theorem row_50_120 : RowResult ⟨50, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_50_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_50_121 : RowResult ⟨50, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_50_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 1 4 5)

theorem row_50_122 : RowResult ⟨50, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_50_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 1 4 5)

theorem row_50_123 : RowResult ⟨50, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_50_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 1 4 5)

theorem row_50_124 : RowResult ⟨50, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_50_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 1 4 5)

theorem row_50_125 : RowResult ⟨50, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_50_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 4 5)

theorem row_50_126 : RowResult ⟨50, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_50_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 4 5)

theorem row_50_127 : RowResult ⟨50, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_50_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 4 5)

theorem row_50_128 : RowResult ⟨50, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_50_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 4 5)

theorem row_50_129 : RowResult ⟨50, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_50_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 4 5)

theorem row_50_130 : RowResult ⟨50, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_50_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_50_131 : RowResult ⟨50, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_50_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 1 4 5)

theorem row_50_132 : RowResult ⟨50, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_50_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 1 4 5)

theorem row_50_133 : RowResult ⟨50, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_50_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 1 4 5)

theorem row_50_134 : RowResult ⟨50, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_50_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 1 4 5)

theorem row_50_135 : RowResult ⟨50, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_50_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 1 4 5)

theorem row_50_136 : RowResult ⟨50, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_50_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 1 4 5)

theorem row_50_137 : RowResult ⟨50, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_50_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 1 4 5)

theorem row_50_138 : RowResult ⟨50, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_50_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 1 4 5)

theorem row_50_139 : RowResult ⟨50, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_50_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 1 4 5)

theorem row_50_140 : RowResult ⟨50, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_50_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 1 4 5)

theorem row_50_141 : RowResult ⟨50, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_50_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 1 4 5)

theorem row_50_142 : RowResult ⟨50, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_50_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 1 4 5)

theorem row_50_143 : RowResult ⟨50, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_50_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 1 4 5)

theorem row_50_144 : RowResult ⟨50, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_50_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 1 4 5)

theorem row_50_145 : RowResult ⟨50, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_50_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_50_146 : RowResult ⟨50, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_50_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 1 4 5)

theorem row_50_147 : RowResult ⟨50, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_50_146
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨147, by decide⟩) 1 4 5)

theorem row_50_148 : RowResult ⟨50, by decide⟩ ⟨148, by decide⟩ := by
  have _previous := row_50_147
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨148, by decide⟩) 1 4 5)

theorem row_50_149 : RowResult ⟨50, by decide⟩ ⟨149, by decide⟩ := by
  have _previous := row_50_148
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨149, by decide⟩) 1 4 5)

theorem row_50_150 : RowResult ⟨50, by decide⟩ ⟨150, by decide⟩ := by
  have _previous := row_50_149
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) (orbitCodeOfNumber ⟨150, by decide⟩) 1 4 5)

end RelativeConicArcs.Q25PairCertificate
