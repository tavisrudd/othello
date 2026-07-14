import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_18_19 : RowResult ⟨18, by decide⟩ ⟨19, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨19, by decide⟩) 0 2 4)

theorem row_18_20 : RowResult ⟨18, by decide⟩ ⟨20, by decide⟩ := by
  have _previous := row_18_19
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) 0 2 4)

theorem row_18_21 : RowResult ⟨18, by decide⟩ ⟨21, by decide⟩ := by
  have _previous := row_18_20
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) 0 2 4)

theorem row_18_22 : RowResult ⟨18, by decide⟩ ⟨22, by decide⟩ := by
  have _previous := row_18_21
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨22, by decide⟩) 0 2 4)

theorem row_18_23 : RowResult ⟨18, by decide⟩ ⟨23, by decide⟩ := by
  have _previous := row_18_22
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨23, by decide⟩) 0 2 4)

theorem row_18_24 : RowResult ⟨18, by decide⟩ ⟨24, by decide⟩ := by
  have _previous := row_18_23
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨24, by decide⟩) 0 2 4)

theorem row_18_25 : RowResult ⟨18, by decide⟩ ⟨25, by decide⟩ := by
  have _previous := row_18_24
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) 0 2 4)

theorem row_18_26 : RowResult ⟨18, by decide⟩ ⟨26, by decide⟩ := by
  have _previous := row_18_25
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨26, by decide⟩) 0 2 4)

theorem row_18_27 : RowResult ⟨18, by decide⟩ ⟨27, by decide⟩ := by
  have _previous := row_18_26
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) 0 2 4)

theorem row_18_28 : RowResult ⟨18, by decide⟩ ⟨28, by decide⟩ := by
  have _previous := row_18_27
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) 0 2 4)

theorem row_18_29 : RowResult ⟨18, by decide⟩ ⟨29, by decide⟩ := by
  have _previous := row_18_28
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨29, by decide⟩) 0 2 4)

theorem row_18_30 : RowResult ⟨18, by decide⟩ ⟨30, by decide⟩ := by
  have _previous := row_18_29
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨30, by decide⟩) 0 2 4)

theorem row_18_31 : RowResult ⟨18, by decide⟩ ⟨31, by decide⟩ := by
  have _previous := row_18_30
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) 0 2 4)

theorem row_18_32 : RowResult ⟨18, by decide⟩ ⟨32, by decide⟩ := by
  have _previous := row_18_31
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) 0 2 4)

theorem row_18_33 : RowResult ⟨18, by decide⟩ ⟨33, by decide⟩ := by
  have _previous := row_18_32
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) 0 2 4)

theorem row_18_34 : RowResult ⟨18, by decide⟩ ⟨34, by decide⟩ := by
  have _previous := row_18_33
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) 0 2 4)

theorem row_18_35 : RowResult ⟨18, by decide⟩ ⟨35, by decide⟩ := by
  have _previous := row_18_34
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) 0 2 4)

theorem row_18_36 : RowResult ⟨18, by decide⟩ ⟨36, by decide⟩ := by
  have _previous := row_18_35
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) 0 2 4)

theorem row_18_37 : RowResult ⟨18, by decide⟩ ⟨37, by decide⟩ := by
  have _previous := row_18_36
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) 0 2 4)

theorem row_18_38 : RowResult ⟨18, by decide⟩ ⟨38, by decide⟩ := by
  have _previous := row_18_37
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) 0 2 4)

theorem row_18_39 : RowResult ⟨18, by decide⟩ ⟨39, by decide⟩ := by
  have _previous := row_18_38
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) 0 2 4)

theorem row_18_40 : RowResult ⟨18, by decide⟩ ⟨40, by decide⟩ := by
  have _previous := row_18_39
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) 0 2 4)

theorem row_18_41 : RowResult ⟨18, by decide⟩ ⟨41, by decide⟩ := by
  have _previous := row_18_40
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) 0 2 4)

theorem row_18_42 : RowResult ⟨18, by decide⟩ ⟨42, by decide⟩ := by
  have _previous := row_18_41
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) 0 2 4)

theorem row_18_43 : RowResult ⟨18, by decide⟩ ⟨43, by decide⟩ := by
  have _previous := row_18_42
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) 0 2 4)

theorem row_18_44 : RowResult ⟨18, by decide⟩ ⟨44, by decide⟩ := by
  have _previous := row_18_43
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) 0 2 4)

theorem row_18_45 : RowResult ⟨18, by decide⟩ ⟨45, by decide⟩ := by
  have _previous := row_18_44
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) 0 2 4)

theorem row_18_46 : RowResult ⟨18, by decide⟩ ⟨46, by decide⟩ := by
  have _previous := row_18_45
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) 0 2 4)

theorem row_18_47 : RowResult ⟨18, by decide⟩ ⟨47, by decide⟩ := by
  have _previous := row_18_46
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) 0 2 4)

theorem row_18_48 : RowResult ⟨18, by decide⟩ ⟨48, by decide⟩ := by
  have _previous := row_18_47
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) 0 2 4)

theorem row_18_49 : RowResult ⟨18, by decide⟩ ⟨49, by decide⟩ := by
  have _previous := row_18_48
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) 0 2 4)

theorem row_18_50 : RowResult ⟨18, by decide⟩ ⟨50, by decide⟩ := by
  have _previous := row_18_49
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) 0 2 4)

theorem row_18_51 : RowResult ⟨18, by decide⟩ ⟨51, by decide⟩ := by
  have _previous := row_18_50
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 0 2 4)

theorem row_18_52 : RowResult ⟨18, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_18_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 0 2 4)

theorem row_18_53 : RowResult ⟨18, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_18_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 0 2 4)

theorem row_18_54 : RowResult ⟨18, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_18_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 0 2 4)

theorem row_18_55 : RowResult ⟨18, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_18_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 0 2 4)

theorem row_18_56 : RowResult ⟨18, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_18_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 0 2 4)

theorem row_18_57 : RowResult ⟨18, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_18_56
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) 0 2 4)

theorem row_18_58 : RowResult ⟨18, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_18_57
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) 0 2 4)

theorem row_18_59 : RowResult ⟨18, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_18_58
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) 0 2 4)

theorem row_18_60 : RowResult ⟨18, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_18_59
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) 0 2 4)

theorem row_18_61 : RowResult ⟨18, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_18_60
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) 0 2 4)

theorem row_18_62 : RowResult ⟨18, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_18_61
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) 0 2 4)

theorem row_18_63 : RowResult ⟨18, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_18_62
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) 0 2 4)

theorem row_18_64 : RowResult ⟨18, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_18_63
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) 0 2 4)

theorem row_18_65 : RowResult ⟨18, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_18_64
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) 0 2 4)

theorem row_18_66 : RowResult ⟨18, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_18_65
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) 0 2 4)

theorem row_18_67 : RowResult ⟨18, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_18_66
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) 0 2 4)

theorem row_18_68 : RowResult ⟨18, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_18_67
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) 0 2 4)

theorem row_18_69 : RowResult ⟨18, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_18_68
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 0 2 4)

theorem row_18_70 : RowResult ⟨18, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_18_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 0 2 4)

theorem row_18_71 : RowResult ⟨18, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_18_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 0 2 4)

theorem row_18_72 : RowResult ⟨18, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_18_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 0 2 4)

theorem row_18_73 : RowResult ⟨18, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_18_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 0 2 4)

theorem row_18_74 : RowResult ⟨18, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_18_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 0 2 4)

theorem row_18_75 : RowResult ⟨18, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_18_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 0 2 4)

theorem row_18_76 : RowResult ⟨18, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_18_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 0 2 4)

theorem row_18_77 : RowResult ⟨18, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_18_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 0 2 4)

theorem row_18_78 : RowResult ⟨18, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_18_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 0 2 4)

theorem row_18_79 : RowResult ⟨18, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_18_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 0 2 4)

theorem row_18_80 : RowResult ⟨18, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_18_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 0 2 4)

theorem row_18_81 : RowResult ⟨18, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_18_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 0 2 4)

theorem row_18_82 : RowResult ⟨18, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_18_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 0 2 4)

theorem row_18_83 : RowResult ⟨18, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_18_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 0 2 4)

theorem row_18_84 : RowResult ⟨18, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_18_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 0 2 4)

theorem row_18_85 : RowResult ⟨18, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_18_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 0 2 4)

theorem row_18_86 : RowResult ⟨18, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_18_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 0 2 4)

theorem row_18_87 : RowResult ⟨18, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_18_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 0 2 4)

theorem row_18_88 : RowResult ⟨18, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_18_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 0 2 4)

theorem row_18_89 : RowResult ⟨18, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_18_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 0 2 4)

theorem row_18_90 : RowResult ⟨18, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_18_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 0 2 4)

theorem row_18_91 : RowResult ⟨18, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_18_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 0 2 4)

theorem row_18_92 : RowResult ⟨18, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_18_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 0 2 4)

theorem row_18_93 : RowResult ⟨18, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_18_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 0 2 4)

theorem row_18_94 : RowResult ⟨18, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_18_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 0 2 4)

theorem row_18_95 : RowResult ⟨18, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_18_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 0 2 4)

theorem row_18_96 : RowResult ⟨18, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_18_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 0 2 4)

theorem row_18_97 : RowResult ⟨18, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_18_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 0 2 4)

theorem row_18_98 : RowResult ⟨18, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_18_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 0 2 4)

theorem row_18_99 : RowResult ⟨18, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_18_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 0 2 4)

theorem row_18_100 : RowResult ⟨18, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_18_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 0 2 4)

theorem row_18_101 : RowResult ⟨18, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_18_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 0 2 4)

theorem row_18_102 : RowResult ⟨18, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_18_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 0 2 4)

theorem row_18_103 : RowResult ⟨18, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_18_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 0 2 4)

theorem row_18_104 : RowResult ⟨18, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_18_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 0 2 4)

theorem row_18_105 : RowResult ⟨18, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_18_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 0 2 4)

theorem row_18_106 : RowResult ⟨18, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_18_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 0 2 4)

theorem row_18_107 : RowResult ⟨18, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_18_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 0 2 4)

theorem row_18_108 : RowResult ⟨18, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_18_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 0 2 4)

theorem row_18_109 : RowResult ⟨18, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_18_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 0 2 4)

theorem row_18_110 : RowResult ⟨18, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_18_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 0 2 4)

theorem row_18_111 : RowResult ⟨18, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_18_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 0 2 4)

theorem row_18_112 : RowResult ⟨18, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_18_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 0 2 4)

theorem row_18_113 : RowResult ⟨18, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_18_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 0 2 4)

theorem row_18_114 : RowResult ⟨18, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_18_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 0 2 4)

theorem row_18_115 : RowResult ⟨18, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_18_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 0 2 4)

theorem row_18_116 : RowResult ⟨18, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_18_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 0 2 4)

theorem row_18_117 : RowResult ⟨18, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_18_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 0 2 4)

theorem row_18_118 : RowResult ⟨18, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_18_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 0 2 4)

end RelativeConicArcs.Q25PairCertificate
