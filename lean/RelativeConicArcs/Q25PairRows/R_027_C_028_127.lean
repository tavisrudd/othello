import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_27_28 : RowResult ⟨27, by decide⟩ ⟨28, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) 0 4 6)

theorem row_27_29 : RowResult ⟨27, by decide⟩ ⟨29, by decide⟩ := by
  have _previous := row_27_28
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨29, by decide⟩) 0 4 6)

theorem row_27_30 : RowResult ⟨27, by decide⟩ ⟨30, by decide⟩ := by
  have _previous := row_27_29
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨30, by decide⟩) 0 4 6)

theorem row_27_31 : RowResult ⟨27, by decide⟩ ⟨31, by decide⟩ := by
  have _previous := row_27_30
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) 0 4 6)

theorem row_27_32 : RowResult ⟨27, by decide⟩ ⟨32, by decide⟩ := by
  have _previous := row_27_31
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) 0 4 6)

theorem row_27_33 : RowResult ⟨27, by decide⟩ ⟨33, by decide⟩ := by
  have _previous := row_27_32
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) 0 4 6)

theorem row_27_34 : RowResult ⟨27, by decide⟩ ⟨34, by decide⟩ := by
  have _previous := row_27_33
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) 0 4 6)

theorem row_27_35 : RowResult ⟨27, by decide⟩ ⟨35, by decide⟩ := by
  have _previous := row_27_34
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) 0 4 6)

theorem row_27_36 : RowResult ⟨27, by decide⟩ ⟨36, by decide⟩ := by
  have _previous := row_27_35
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) 0 4 6)

theorem row_27_37 : RowResult ⟨27, by decide⟩ ⟨37, by decide⟩ := by
  have _previous := row_27_36
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) 0 4 6)

theorem row_27_38 : RowResult ⟨27, by decide⟩ ⟨38, by decide⟩ := by
  have _previous := row_27_37
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) 0 4 6)

theorem row_27_39 : RowResult ⟨27, by decide⟩ ⟨39, by decide⟩ := by
  have _previous := row_27_38
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) 0 4 6)

theorem row_27_40 : RowResult ⟨27, by decide⟩ ⟨40, by decide⟩ := by
  have _previous := row_27_39
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) 0 4 6)

theorem row_27_41 : RowResult ⟨27, by decide⟩ ⟨41, by decide⟩ := by
  have _previous := row_27_40
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) 0 4 6)

theorem row_27_42 : RowResult ⟨27, by decide⟩ ⟨42, by decide⟩ := by
  have _previous := row_27_41
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) 0 4 6)

theorem row_27_43 : RowResult ⟨27, by decide⟩ ⟨43, by decide⟩ := by
  have _previous := row_27_42
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) 0 4 6)

theorem row_27_44 : RowResult ⟨27, by decide⟩ ⟨44, by decide⟩ := by
  have _previous := row_27_43
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) 0 4 6)

theorem row_27_45 : RowResult ⟨27, by decide⟩ ⟨45, by decide⟩ := by
  have _previous := row_27_44
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) 0 4 6)

theorem row_27_46 : RowResult ⟨27, by decide⟩ ⟨46, by decide⟩ := by
  have _previous := row_27_45
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) 0 4 6)

theorem row_27_47 : RowResult ⟨27, by decide⟩ ⟨47, by decide⟩ := by
  have _previous := row_27_46
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) 0 4 6)

theorem row_27_48 : RowResult ⟨27, by decide⟩ ⟨48, by decide⟩ := by
  have _previous := row_27_47
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) 0 4 6)

theorem row_27_49 : RowResult ⟨27, by decide⟩ ⟨49, by decide⟩ := by
  have _previous := row_27_48
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) 0 4 6)

theorem row_27_50 : RowResult ⟨27, by decide⟩ ⟨50, by decide⟩ := by
  have _previous := row_27_49
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) 1 4 5)

theorem row_27_51 : RowResult ⟨27, by decide⟩ ⟨51, by decide⟩ := by
  have _previous := row_27_50
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 1 4 5)

theorem row_27_52 : RowResult ⟨27, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_27_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 1 4 5)

theorem row_27_53 : RowResult ⟨27, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_27_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 1 4 5)

theorem row_27_54 : RowResult ⟨27, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_27_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 1 4 5)

theorem row_27_55 : RowResult ⟨27, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_27_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 1 2 6)

theorem row_27_56 : RowResult ⟨27, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_27_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 1 4 5)

theorem row_27_57 : RowResult ⟨27, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_27_56
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) 1 4 5)

theorem row_27_58 : RowResult ⟨27, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_27_57
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) 1 4 5)

theorem row_27_59 : RowResult ⟨27, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_27_58
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) 1 4 5)

theorem row_27_60 : RowResult ⟨27, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_27_59
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) 1 4 5)

theorem row_27_61 : RowResult ⟨27, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_27_60
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) 1 4 5)

theorem row_27_62 : RowResult ⟨27, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_27_61
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) 1 4 5)

theorem row_27_63 : RowResult ⟨27, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_27_62
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) 1 4 5)

theorem row_27_64 : RowResult ⟨27, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_27_63
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) 1 4 5)

theorem row_27_65 : RowResult ⟨27, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_27_64
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) 1 4 5)

theorem row_27_66 : RowResult ⟨27, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_27_65
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) 1 4 5)

theorem row_27_67 : RowResult ⟨27, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_27_66
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) 1 4 5)

theorem row_27_68 : RowResult ⟨27, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_27_67
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) 1 4 5)

theorem row_27_69 : RowResult ⟨27, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_27_68
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 1 4 5)

theorem row_27_70 : RowResult ⟨27, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_27_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 1 2 7)

theorem row_27_71 : RowResult ⟨27, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_27_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 1 4 5)

theorem row_27_72 : RowResult ⟨27, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_27_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 1 4 5)

theorem row_27_73 : RowResult ⟨27, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_27_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 1 4 5)

theorem row_27_74 : RowResult ⟨27, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_27_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 1 4 5)

theorem row_27_75 : RowResult ⟨27, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_27_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 4 5)

theorem row_27_76 : RowResult ⟨27, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_27_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 4 5)

theorem row_27_77 : RowResult ⟨27, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_27_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 4 5)

theorem row_27_78 : RowResult ⟨27, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_27_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 4 5)

theorem row_27_79 : RowResult ⟨27, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_27_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 4 5)

theorem row_27_80 : RowResult ⟨27, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_27_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_27_81 : RowResult ⟨27, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_27_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 1 4 5)

theorem row_27_82 : RowResult ⟨27, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_27_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 1 4 5)

theorem row_27_83 : RowResult ⟨27, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_27_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 1 4 5)

theorem row_27_84 : RowResult ⟨27, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_27_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 1 4 5)

theorem row_27_85 : RowResult ⟨27, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_27_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 1 4 5)

theorem row_27_86 : RowResult ⟨27, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_27_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 1 4 5)

theorem row_27_87 : RowResult ⟨27, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_27_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 1 4 5)

theorem row_27_88 : RowResult ⟨27, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_27_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 1 4 5)

theorem row_27_89 : RowResult ⟨27, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_27_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 1 4 5)

theorem row_27_90 : RowResult ⟨27, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_27_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 1 4 5)

theorem row_27_91 : RowResult ⟨27, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_27_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 1 4 5)

theorem row_27_92 : RowResult ⟨27, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_27_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 1 4 5)

theorem row_27_93 : RowResult ⟨27, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_27_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 1 4 5)

theorem row_27_94 : RowResult ⟨27, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_27_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 1 4 5)

theorem row_27_95 : RowResult ⟨27, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_27_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_27_96 : RowResult ⟨27, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_27_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 1 4 5)

theorem row_27_97 : RowResult ⟨27, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_27_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 1 4 5)

theorem row_27_98 : RowResult ⟨27, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_27_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 1 4 5)

theorem row_27_99 : RowResult ⟨27, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_27_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 1 4 5)

theorem row_27_100 : RowResult ⟨27, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_27_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 4 5)

theorem row_27_101 : RowResult ⟨27, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_27_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 4 5)

theorem row_27_102 : RowResult ⟨27, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_27_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 4 5)

theorem row_27_103 : RowResult ⟨27, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_27_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 4 5)

theorem row_27_104 : RowResult ⟨27, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_27_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 4 5)

theorem row_27_105 : RowResult ⟨27, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_27_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_27_106 : RowResult ⟨27, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_27_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 1 4 5)

theorem row_27_107 : RowResult ⟨27, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_27_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 1 4 5)

theorem row_27_108 : RowResult ⟨27, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_27_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 1 4 5)

theorem row_27_109 : RowResult ⟨27, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_27_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 1 4 5)

theorem row_27_110 : RowResult ⟨27, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_27_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 1 4 5)

theorem row_27_111 : RowResult ⟨27, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_27_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 1 4 5)

theorem row_27_112 : RowResult ⟨27, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_27_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 1 4 5)

theorem row_27_113 : RowResult ⟨27, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_27_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 1 4 5)

theorem row_27_114 : RowResult ⟨27, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_27_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 1 4 5)

theorem row_27_115 : RowResult ⟨27, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_27_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 1 4 5)

theorem row_27_116 : RowResult ⟨27, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_27_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 1 4 5)

theorem row_27_117 : RowResult ⟨27, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_27_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 1 4 5)

theorem row_27_118 : RowResult ⟨27, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_27_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 1 4 5)

theorem row_27_119 : RowResult ⟨27, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_27_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 1 4 5)

theorem row_27_120 : RowResult ⟨27, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_27_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_27_121 : RowResult ⟨27, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_27_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 1 4 5)

theorem row_27_122 : RowResult ⟨27, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_27_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 1 4 5)

theorem row_27_123 : RowResult ⟨27, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_27_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 1 4 5)

theorem row_27_124 : RowResult ⟨27, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_27_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 1 4 5)

theorem row_27_125 : RowResult ⟨27, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_27_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 4 5)

theorem row_27_126 : RowResult ⟨27, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_27_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 4 5)

theorem row_27_127 : RowResult ⟨27, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_27_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 4 5)

end RelativeConicArcs.Q25PairCertificate
