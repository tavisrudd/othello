import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_35_36 : RowResult ⟨35, by decide⟩ ⟨36, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) 0 4 6)

theorem row_35_37 : RowResult ⟨35, by decide⟩ ⟨37, by decide⟩ := by
  have _previous := row_35_36
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) 0 4 6)

theorem row_35_38 : RowResult ⟨35, by decide⟩ ⟨38, by decide⟩ := by
  have _previous := row_35_37
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) 0 4 6)

theorem row_35_39 : RowResult ⟨35, by decide⟩ ⟨39, by decide⟩ := by
  have _previous := row_35_38
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) 0 4 6)

theorem row_35_40 : RowResult ⟨35, by decide⟩ ⟨40, by decide⟩ := by
  have _previous := row_35_39
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) 0 4 6)

theorem row_35_41 : RowResult ⟨35, by decide⟩ ⟨41, by decide⟩ := by
  have _previous := row_35_40
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) 0 4 6)

theorem row_35_42 : RowResult ⟨35, by decide⟩ ⟨42, by decide⟩ := by
  have _previous := row_35_41
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) 0 4 6)

theorem row_35_43 : RowResult ⟨35, by decide⟩ ⟨43, by decide⟩ := by
  have _previous := row_35_42
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) 0 4 6)

theorem row_35_44 : RowResult ⟨35, by decide⟩ ⟨44, by decide⟩ := by
  have _previous := row_35_43
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) 0 4 6)

theorem row_35_45 : RowResult ⟨35, by decide⟩ ⟨45, by decide⟩ := by
  have _previous := row_35_44
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) 0 4 6)

theorem row_35_46 : RowResult ⟨35, by decide⟩ ⟨46, by decide⟩ := by
  have _previous := row_35_45
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) 0 4 6)

theorem row_35_47 : RowResult ⟨35, by decide⟩ ⟨47, by decide⟩ := by
  have _previous := row_35_46
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) 0 4 6)

theorem row_35_48 : RowResult ⟨35, by decide⟩ ⟨48, by decide⟩ := by
  have _previous := row_35_47
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) 0 4 6)

theorem row_35_49 : RowResult ⟨35, by decide⟩ ⟨49, by decide⟩ := by
  have _previous := row_35_48
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) 0 4 6)

theorem row_35_50 : RowResult ⟨35, by decide⟩ ⟨50, by decide⟩ := by
  have _previous := row_35_49
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) 1 6 7)

theorem row_35_51 : RowResult ⟨35, by decide⟩ ⟨51, by decide⟩ := by
  have _previous := row_35_50
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 1 6 7)

theorem row_35_52 : RowResult ⟨35, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_35_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 1 6 7)

theorem row_35_53 : RowResult ⟨35, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_35_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 1 6 7)

theorem row_35_54 : RowResult ⟨35, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_35_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 1 6 7)

theorem row_35_55 : RowResult ⟨35, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_35_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 1 2 6)

theorem row_35_56 : RowResult ⟨35, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_35_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 2 3 4)

theorem row_35_57 : RowResult ⟨35, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_35_56
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) 2 3 4)

theorem row_35_58 : RowResult ⟨35, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_35_57
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) 2 3 4)

theorem row_35_59 : RowResult ⟨35, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_35_58
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) 2 3 4)

theorem row_35_60 : RowResult ⟨35, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_35_59
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) 1 4 6)

theorem row_35_61 : RowResult ⟨35, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_35_60
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) 2 3 4)

theorem row_35_62 : RowResult ⟨35, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_35_61
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) 2 3 4)

theorem row_35_63 : RowResult ⟨35, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_35_62
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) 2 3 4)

theorem row_35_64 : RowResult ⟨35, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_35_63
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) 2 3 4)

theorem row_35_65 : RowResult ⟨35, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_35_64
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) 1 4 7)

theorem row_35_66 : RowResult ⟨35, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_35_65
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) 2 3 4)

theorem row_35_67 : RowResult ⟨35, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_35_66
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) 2 3 4)

theorem row_35_68 : RowResult ⟨35, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_35_67
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) 2 3 4)

theorem row_35_69 : RowResult ⟨35, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_35_68
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 2 3 4)

theorem row_35_70 : RowResult ⟨35, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_35_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 1 2 7)

theorem row_35_71 : RowResult ⟨35, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_35_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 2 3 4)

theorem row_35_72 : RowResult ⟨35, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_35_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 2 3 4)

theorem row_35_73 : RowResult ⟨35, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_35_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 2 3 4)

theorem row_35_74 : RowResult ⟨35, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_35_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 2 3 4)

theorem row_35_75 : RowResult ⟨35, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_35_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_35_76 : RowResult ⟨35, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_35_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_35_77 : RowResult ⟨35, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_35_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_35_78 : RowResult ⟨35, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_35_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_35_79 : RowResult ⟨35, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_35_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_35_80 : RowResult ⟨35, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_35_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_35_81 : RowResult ⟨35, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_35_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 2 3 4)

theorem row_35_82 : RowResult ⟨35, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_35_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 2 3 4)

theorem row_35_83 : RowResult ⟨35, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_35_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 2 3 4)

theorem row_35_84 : RowResult ⟨35, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_35_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 2 3 4)

theorem row_35_85 : RowResult ⟨35, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_35_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 1 4 6)

theorem row_35_86 : RowResult ⟨35, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_35_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 4)

theorem row_35_87 : RowResult ⟨35, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_35_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 2 3 4)

theorem row_35_88 : RowResult ⟨35, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_35_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 2 3 4)

theorem row_35_89 : RowResult ⟨35, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_35_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 2 3 4)

theorem row_35_90 : RowResult ⟨35, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_35_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 1 4 7)

theorem row_35_91 : RowResult ⟨35, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_35_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 2 3 4)

theorem row_35_92 : RowResult ⟨35, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_35_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 2 3 4)

theorem row_35_93 : RowResult ⟨35, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_35_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 2 3 4)

theorem row_35_94 : RowResult ⟨35, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_35_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 2 3 4)

theorem row_35_95 : RowResult ⟨35, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_35_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_35_96 : RowResult ⟨35, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_35_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 2 3 4)

theorem row_35_97 : RowResult ⟨35, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_35_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 2 3 4)

theorem row_35_98 : RowResult ⟨35, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_35_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 2 3 4)

theorem row_35_99 : RowResult ⟨35, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_35_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 2 3 4)

theorem row_35_100 : RowResult ⟨35, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_35_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_35_101 : RowResult ⟨35, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_35_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_35_102 : RowResult ⟨35, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_35_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_35_103 : RowResult ⟨35, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_35_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_35_104 : RowResult ⟨35, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_35_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_35_105 : RowResult ⟨35, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_35_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_35_106 : RowResult ⟨35, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_35_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 2 3 4)

theorem row_35_107 : RowResult ⟨35, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_35_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 4)

theorem row_35_108 : RowResult ⟨35, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_35_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 2 3 4)

theorem row_35_109 : RowResult ⟨35, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_35_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 2 3 4)

theorem row_35_110 : RowResult ⟨35, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_35_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 1 4 6)

theorem row_35_111 : RowResult ⟨35, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_35_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 2 3 4)

theorem row_35_112 : RowResult ⟨35, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_35_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 2 3 4)

theorem row_35_113 : RowResult ⟨35, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_35_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 2 3 4)

theorem row_35_114 : RowResult ⟨35, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_35_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 2 3 4)

theorem row_35_115 : RowResult ⟨35, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_35_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 1 4 7)

theorem row_35_116 : RowResult ⟨35, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_35_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 2 3 4)

theorem row_35_117 : RowResult ⟨35, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_35_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 2 3 4)

theorem row_35_118 : RowResult ⟨35, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_35_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 2 3 4)

theorem row_35_119 : RowResult ⟨35, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_35_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 2 3 4)

theorem row_35_120 : RowResult ⟨35, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_35_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_35_121 : RowResult ⟨35, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_35_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 2 3 4)

theorem row_35_122 : RowResult ⟨35, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_35_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 2 3 4)

theorem row_35_123 : RowResult ⟨35, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_35_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 2 3 4)

theorem row_35_124 : RowResult ⟨35, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_35_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 2 3 4)

theorem row_35_125 : RowResult ⟨35, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_35_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_35_126 : RowResult ⟨35, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_35_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_35_127 : RowResult ⟨35, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_35_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_35_128 : RowResult ⟨35, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_35_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_35_129 : RowResult ⟨35, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_35_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_35_130 : RowResult ⟨35, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_35_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_35_131 : RowResult ⟨35, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_35_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 2 3 4)

theorem row_35_132 : RowResult ⟨35, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_35_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 2 3 4)

theorem row_35_133 : RowResult ⟨35, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_35_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 2 3 4)

theorem row_35_134 : RowResult ⟨35, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_35_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 2 3 4)

theorem row_35_135 : RowResult ⟨35, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_35_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
