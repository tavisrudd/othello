import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_45_46 : RowResult ⟨45, by decide⟩ ⟨46, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) 0 4 6)

theorem row_45_47 : RowResult ⟨45, by decide⟩ ⟨47, by decide⟩ := by
  have _previous := row_45_46
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) 0 4 6)

theorem row_45_48 : RowResult ⟨45, by decide⟩ ⟨48, by decide⟩ := by
  have _previous := row_45_47
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) 0 4 6)

theorem row_45_49 : RowResult ⟨45, by decide⟩ ⟨49, by decide⟩ := by
  have _previous := row_45_48
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) 0 4 6)

theorem row_45_50 : RowResult ⟨45, by decide⟩ ⟨50, by decide⟩ := by
  have _previous := row_45_49
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) 1 2 5)

theorem row_45_51 : RowResult ⟨45, by decide⟩ ⟨51, by decide⟩ := by
  have _previous := row_45_50
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 1 2 5)

theorem row_45_52 : RowResult ⟨45, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_45_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 1 2 5)

theorem row_45_53 : RowResult ⟨45, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_45_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 1 2 5)

theorem row_45_54 : RowResult ⟨45, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_45_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 1 2 5)

theorem row_45_55 : RowResult ⟨45, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_45_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 1 2 5)

theorem row_45_56 : RowResult ⟨45, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_45_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 1 2 5)

theorem row_45_57 : RowResult ⟨45, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_45_56
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) 1 2 5)

theorem row_45_58 : RowResult ⟨45, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_45_57
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) 1 2 5)

theorem row_45_59 : RowResult ⟨45, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_45_58
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) 1 2 5)

theorem row_45_60 : RowResult ⟨45, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_45_59
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) 1 2 5)

theorem row_45_61 : RowResult ⟨45, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_45_60
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) 1 2 5)

theorem row_45_62 : RowResult ⟨45, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_45_61
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) 1 2 5)

theorem row_45_63 : RowResult ⟨45, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_45_62
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) 1 2 5)

theorem row_45_64 : RowResult ⟨45, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_45_63
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) 1 2 5)

theorem row_45_65 : RowResult ⟨45, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_45_64
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) 1 2 5)

theorem row_45_66 : RowResult ⟨45, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_45_65
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) 1 2 5)

theorem row_45_67 : RowResult ⟨45, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_45_66
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) 1 2 5)

theorem row_45_68 : RowResult ⟨45, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_45_67
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) 1 2 5)

theorem row_45_69 : RowResult ⟨45, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_45_68
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 1 2 5)

theorem row_45_70 : RowResult ⟨45, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_45_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 1 2 5)

theorem row_45_71 : RowResult ⟨45, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_45_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 1 2 5)

theorem row_45_72 : RowResult ⟨45, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_45_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 1 2 5)

theorem row_45_73 : RowResult ⟨45, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_45_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 1 2 5)

theorem row_45_74 : RowResult ⟨45, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_45_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 1 2 5)

theorem row_45_75 : RowResult ⟨45, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_45_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 2 5)

theorem row_45_76 : RowResult ⟨45, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_45_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 2 5)

theorem row_45_77 : RowResult ⟨45, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_45_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 2 5)

theorem row_45_78 : RowResult ⟨45, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_45_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 2 5)

theorem row_45_79 : RowResult ⟨45, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_45_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 2 5)

theorem row_45_80 : RowResult ⟨45, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_45_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 5)

theorem row_45_81 : RowResult ⟨45, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_45_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 1 2 5)

theorem row_45_82 : RowResult ⟨45, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_45_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 1 2 5)

theorem row_45_83 : RowResult ⟨45, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_45_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 1 2 5)

theorem row_45_84 : RowResult ⟨45, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_45_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 1 2 5)

theorem row_45_85 : RowResult ⟨45, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_45_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 1 2 5)

theorem row_45_86 : RowResult ⟨45, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_45_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 1 2 5)

theorem row_45_87 : RowResult ⟨45, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_45_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 1 2 5)

theorem row_45_88 : RowResult ⟨45, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_45_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 1 2 5)

theorem row_45_89 : RowResult ⟨45, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_45_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 1 2 5)

theorem row_45_90 : RowResult ⟨45, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_45_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 1 2 5)

theorem row_45_91 : RowResult ⟨45, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_45_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 1 2 5)

theorem row_45_92 : RowResult ⟨45, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_45_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 1 2 5)

theorem row_45_93 : RowResult ⟨45, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_45_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 1 2 5)

theorem row_45_94 : RowResult ⟨45, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_45_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 1 2 5)

theorem row_45_95 : RowResult ⟨45, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_45_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 5)

theorem row_45_96 : RowResult ⟨45, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_45_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 1 2 5)

theorem row_45_97 : RowResult ⟨45, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_45_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 1 2 5)

theorem row_45_98 : RowResult ⟨45, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_45_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 1 2 5)

theorem row_45_99 : RowResult ⟨45, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_45_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 1 2 5)

theorem row_45_100 : RowResult ⟨45, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_45_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 2 5)

theorem row_45_101 : RowResult ⟨45, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_45_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 2 5)

theorem row_45_102 : RowResult ⟨45, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_45_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 2 5)

theorem row_45_103 : RowResult ⟨45, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_45_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 2 5)

theorem row_45_104 : RowResult ⟨45, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_45_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 2 5)

theorem row_45_105 : RowResult ⟨45, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_45_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 5)

theorem row_45_106 : RowResult ⟨45, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_45_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 1 2 5)

theorem row_45_107 : RowResult ⟨45, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_45_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 1 2 5)

theorem row_45_108 : RowResult ⟨45, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_45_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 1 2 5)

theorem row_45_109 : RowResult ⟨45, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_45_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 1 2 5)

theorem row_45_110 : RowResult ⟨45, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_45_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 1 2 5)

theorem row_45_111 : RowResult ⟨45, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_45_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 1 2 5)

theorem row_45_112 : RowResult ⟨45, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_45_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 1 2 5)

theorem row_45_113 : RowResult ⟨45, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_45_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 1 2 5)

theorem row_45_114 : RowResult ⟨45, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_45_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 1 2 5)

theorem row_45_115 : RowResult ⟨45, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_45_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 1 2 5)

theorem row_45_116 : RowResult ⟨45, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_45_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 1 2 5)

theorem row_45_117 : RowResult ⟨45, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_45_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 1 2 5)

theorem row_45_118 : RowResult ⟨45, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_45_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 1 2 5)

theorem row_45_119 : RowResult ⟨45, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_45_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 1 2 5)

theorem row_45_120 : RowResult ⟨45, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_45_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 5)

theorem row_45_121 : RowResult ⟨45, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_45_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 1 2 5)

theorem row_45_122 : RowResult ⟨45, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_45_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 1 2 5)

theorem row_45_123 : RowResult ⟨45, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_45_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 1 2 5)

theorem row_45_124 : RowResult ⟨45, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_45_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 1 2 5)

theorem row_45_125 : RowResult ⟨45, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_45_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 2 5)

theorem row_45_126 : RowResult ⟨45, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_45_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 2 5)

theorem row_45_127 : RowResult ⟨45, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_45_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 2 5)

theorem row_45_128 : RowResult ⟨45, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_45_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 2 5)

theorem row_45_129 : RowResult ⟨45, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_45_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 2 5)

theorem row_45_130 : RowResult ⟨45, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_45_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 5)

theorem row_45_131 : RowResult ⟨45, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_45_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 1 2 5)

theorem row_45_132 : RowResult ⟨45, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_45_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 1 2 5)

theorem row_45_133 : RowResult ⟨45, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_45_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 1 2 5)

theorem row_45_134 : RowResult ⟨45, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_45_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 1 2 5)

theorem row_45_135 : RowResult ⟨45, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_45_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 1 2 5)

theorem row_45_136 : RowResult ⟨45, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_45_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 1 2 5)

theorem row_45_137 : RowResult ⟨45, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_45_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 1 2 5)

theorem row_45_138 : RowResult ⟨45, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_45_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 1 2 5)

theorem row_45_139 : RowResult ⟨45, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_45_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 1 2 5)

theorem row_45_140 : RowResult ⟨45, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_45_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 1 2 5)

theorem row_45_141 : RowResult ⟨45, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_45_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 1 2 5)

theorem row_45_142 : RowResult ⟨45, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_45_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 1 2 5)

theorem row_45_143 : RowResult ⟨45, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_45_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 1 2 5)

theorem row_45_144 : RowResult ⟨45, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_45_143
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨144, by decide⟩) 1 2 5)

theorem row_45_145 : RowResult ⟨45, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_45_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 5)

end RelativeConicArcs.Q25PairCertificate
