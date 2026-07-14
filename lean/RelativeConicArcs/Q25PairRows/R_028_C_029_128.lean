import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_28_29 : RowResult ⟨28, by decide⟩ ⟨29, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨29, by decide⟩) 0 4 6)

theorem row_28_30 : RowResult ⟨28, by decide⟩ ⟨30, by decide⟩ := by
  have _previous := row_28_29
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨30, by decide⟩) 0 4 6)

theorem row_28_31 : RowResult ⟨28, by decide⟩ ⟨31, by decide⟩ := by
  have _previous := row_28_30
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) 0 4 6)

theorem row_28_32 : RowResult ⟨28, by decide⟩ ⟨32, by decide⟩ := by
  have _previous := row_28_31
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) 0 4 6)

theorem row_28_33 : RowResult ⟨28, by decide⟩ ⟨33, by decide⟩ := by
  have _previous := row_28_32
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) 0 4 6)

theorem row_28_34 : RowResult ⟨28, by decide⟩ ⟨34, by decide⟩ := by
  have _previous := row_28_33
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) 0 4 6)

theorem row_28_35 : RowResult ⟨28, by decide⟩ ⟨35, by decide⟩ := by
  have _previous := row_28_34
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) 0 4 6)

theorem row_28_36 : RowResult ⟨28, by decide⟩ ⟨36, by decide⟩ := by
  have _previous := row_28_35
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) 0 4 6)

theorem row_28_37 : RowResult ⟨28, by decide⟩ ⟨37, by decide⟩ := by
  have _previous := row_28_36
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) 0 4 6)

theorem row_28_38 : RowResult ⟨28, by decide⟩ ⟨38, by decide⟩ := by
  have _previous := row_28_37
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) 0 4 6)

theorem row_28_39 : RowResult ⟨28, by decide⟩ ⟨39, by decide⟩ := by
  have _previous := row_28_38
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) 0 4 6)

theorem row_28_40 : RowResult ⟨28, by decide⟩ ⟨40, by decide⟩ := by
  have _previous := row_28_39
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) 0 4 6)

theorem row_28_41 : RowResult ⟨28, by decide⟩ ⟨41, by decide⟩ := by
  have _previous := row_28_40
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) 0 4 6)

theorem row_28_42 : RowResult ⟨28, by decide⟩ ⟨42, by decide⟩ := by
  have _previous := row_28_41
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) 0 4 6)

theorem row_28_43 : RowResult ⟨28, by decide⟩ ⟨43, by decide⟩ := by
  have _previous := row_28_42
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) 0 4 6)

theorem row_28_44 : RowResult ⟨28, by decide⟩ ⟨44, by decide⟩ := by
  have _previous := row_28_43
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) 0 4 6)

theorem row_28_45 : RowResult ⟨28, by decide⟩ ⟨45, by decide⟩ := by
  have _previous := row_28_44
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) 0 4 6)

theorem row_28_46 : RowResult ⟨28, by decide⟩ ⟨46, by decide⟩ := by
  have _previous := row_28_45
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) 0 4 6)

theorem row_28_47 : RowResult ⟨28, by decide⟩ ⟨47, by decide⟩ := by
  have _previous := row_28_46
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) 0 4 6)

theorem row_28_48 : RowResult ⟨28, by decide⟩ ⟨48, by decide⟩ := by
  have _previous := row_28_47
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) 0 4 6)

theorem row_28_49 : RowResult ⟨28, by decide⟩ ⟨49, by decide⟩ := by
  have _previous := row_28_48
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) 0 4 6)

theorem row_28_50 : RowResult ⟨28, by decide⟩ ⟨50, by decide⟩ := by
  have _previous := row_28_49
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) 1 4 5)

theorem row_28_51 : RowResult ⟨28, by decide⟩ ⟨51, by decide⟩ := by
  have _previous := row_28_50
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 1 4 5)

theorem row_28_52 : RowResult ⟨28, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_28_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 1 4 5)

theorem row_28_53 : RowResult ⟨28, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_28_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 1 4 5)

theorem row_28_54 : RowResult ⟨28, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_28_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 1 4 5)

theorem row_28_55 : RowResult ⟨28, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_28_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 1 2 6)

theorem row_28_56 : RowResult ⟨28, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_28_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 1 4 5)

theorem row_28_57 : RowResult ⟨28, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_28_56
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) 1 4 5)

theorem row_28_58 : RowResult ⟨28, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_28_57
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) 1 4 5)

theorem row_28_59 : RowResult ⟨28, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_28_58
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) 1 4 5)

theorem row_28_60 : RowResult ⟨28, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_28_59
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) 1 4 5)

theorem row_28_61 : RowResult ⟨28, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_28_60
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) 1 4 5)

theorem row_28_62 : RowResult ⟨28, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_28_61
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) 1 4 5)

theorem row_28_63 : RowResult ⟨28, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_28_62
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) 1 4 5)

theorem row_28_64 : RowResult ⟨28, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_28_63
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) 1 4 5)

theorem row_28_65 : RowResult ⟨28, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_28_64
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) 1 4 5)

theorem row_28_66 : RowResult ⟨28, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_28_65
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) 1 4 5)

theorem row_28_67 : RowResult ⟨28, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_28_66
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) 1 4 5)

theorem row_28_68 : RowResult ⟨28, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_28_67
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) 1 4 5)

theorem row_28_69 : RowResult ⟨28, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_28_68
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 1 4 5)

theorem row_28_70 : RowResult ⟨28, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_28_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 1 2 7)

theorem row_28_71 : RowResult ⟨28, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_28_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 1 4 5)

theorem row_28_72 : RowResult ⟨28, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_28_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 1 4 5)

theorem row_28_73 : RowResult ⟨28, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_28_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 1 4 5)

theorem row_28_74 : RowResult ⟨28, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_28_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 1 4 5)

theorem row_28_75 : RowResult ⟨28, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_28_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 4 5)

theorem row_28_76 : RowResult ⟨28, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_28_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 4 5)

theorem row_28_77 : RowResult ⟨28, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_28_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 4 5)

theorem row_28_78 : RowResult ⟨28, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_28_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 4 5)

theorem row_28_79 : RowResult ⟨28, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_28_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 4 5)

theorem row_28_80 : RowResult ⟨28, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_28_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_28_81 : RowResult ⟨28, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_28_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 1 4 5)

theorem row_28_82 : RowResult ⟨28, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_28_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 1 4 5)

theorem row_28_83 : RowResult ⟨28, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_28_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 1 4 5)

theorem row_28_84 : RowResult ⟨28, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_28_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 1 4 5)

theorem row_28_85 : RowResult ⟨28, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_28_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 1 4 5)

theorem row_28_86 : RowResult ⟨28, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_28_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 1 4 5)

theorem row_28_87 : RowResult ⟨28, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_28_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 1 4 5)

theorem row_28_88 : RowResult ⟨28, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_28_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 1 4 5)

theorem row_28_89 : RowResult ⟨28, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_28_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 1 4 5)

theorem row_28_90 : RowResult ⟨28, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_28_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 1 4 5)

theorem row_28_91 : RowResult ⟨28, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_28_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 1 4 5)

theorem row_28_92 : RowResult ⟨28, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_28_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 1 4 5)

theorem row_28_93 : RowResult ⟨28, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_28_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 1 4 5)

theorem row_28_94 : RowResult ⟨28, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_28_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 1 4 5)

theorem row_28_95 : RowResult ⟨28, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_28_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_28_96 : RowResult ⟨28, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_28_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 1 4 5)

theorem row_28_97 : RowResult ⟨28, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_28_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 1 4 5)

theorem row_28_98 : RowResult ⟨28, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_28_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 1 4 5)

theorem row_28_99 : RowResult ⟨28, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_28_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 1 4 5)

theorem row_28_100 : RowResult ⟨28, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_28_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 4 5)

theorem row_28_101 : RowResult ⟨28, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_28_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 4 5)

theorem row_28_102 : RowResult ⟨28, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_28_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 4 5)

theorem row_28_103 : RowResult ⟨28, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_28_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 4 5)

theorem row_28_104 : RowResult ⟨28, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_28_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 4 5)

theorem row_28_105 : RowResult ⟨28, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_28_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_28_106 : RowResult ⟨28, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_28_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 1 4 5)

theorem row_28_107 : RowResult ⟨28, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_28_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 1 4 5)

theorem row_28_108 : RowResult ⟨28, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_28_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 1 4 5)

theorem row_28_109 : RowResult ⟨28, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_28_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 1 4 5)

theorem row_28_110 : RowResult ⟨28, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_28_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 1 4 5)

theorem row_28_111 : RowResult ⟨28, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_28_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 1 4 5)

theorem row_28_112 : RowResult ⟨28, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_28_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 1 4 5)

theorem row_28_113 : RowResult ⟨28, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_28_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 1 4 5)

theorem row_28_114 : RowResult ⟨28, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_28_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 1 4 5)

theorem row_28_115 : RowResult ⟨28, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_28_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 1 4 5)

theorem row_28_116 : RowResult ⟨28, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_28_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 1 4 5)

theorem row_28_117 : RowResult ⟨28, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_28_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 1 4 5)

theorem row_28_118 : RowResult ⟨28, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_28_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 1 4 5)

theorem row_28_119 : RowResult ⟨28, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_28_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 1 4 5)

theorem row_28_120 : RowResult ⟨28, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_28_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_28_121 : RowResult ⟨28, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_28_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 1 4 5)

theorem row_28_122 : RowResult ⟨28, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_28_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 1 4 5)

theorem row_28_123 : RowResult ⟨28, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_28_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 1 4 5)

theorem row_28_124 : RowResult ⟨28, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_28_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 1 4 5)

theorem row_28_125 : RowResult ⟨28, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_28_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 4 5)

theorem row_28_126 : RowResult ⟨28, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_28_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 4 5)

theorem row_28_127 : RowResult ⟨28, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_28_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 4 5)

theorem row_28_128 : RowResult ⟨28, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_28_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 4 5)

end RelativeConicArcs.Q25PairCertificate
