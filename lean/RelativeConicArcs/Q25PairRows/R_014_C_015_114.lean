import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_14_15 : RowResult ⟨14, by decide⟩ ⟨15, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨15, by decide⟩) 0 2 4)

theorem row_14_16 : RowResult ⟨14, by decide⟩ ⟨16, by decide⟩ := by
  have _previous := row_14_15
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨16, by decide⟩) 0 2 4)

theorem row_14_17 : RowResult ⟨14, by decide⟩ ⟨17, by decide⟩ := by
  have _previous := row_14_16
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨17, by decide⟩) 0 2 4)

theorem row_14_18 : RowResult ⟨14, by decide⟩ ⟨18, by decide⟩ := by
  have _previous := row_14_17
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) 0 2 4)

theorem row_14_19 : RowResult ⟨14, by decide⟩ ⟨19, by decide⟩ := by
  have _previous := row_14_18
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨19, by decide⟩) 0 2 4)

theorem row_14_20 : RowResult ⟨14, by decide⟩ ⟨20, by decide⟩ := by
  have _previous := row_14_19
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) 0 2 4)

theorem row_14_21 : RowResult ⟨14, by decide⟩ ⟨21, by decide⟩ := by
  have _previous := row_14_20
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) 0 2 4)

theorem row_14_22 : RowResult ⟨14, by decide⟩ ⟨22, by decide⟩ := by
  have _previous := row_14_21
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨22, by decide⟩) 0 2 4)

theorem row_14_23 : RowResult ⟨14, by decide⟩ ⟨23, by decide⟩ := by
  have _previous := row_14_22
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨23, by decide⟩) 0 2 4)

theorem row_14_24 : RowResult ⟨14, by decide⟩ ⟨24, by decide⟩ := by
  have _previous := row_14_23
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨24, by decide⟩) 0 2 4)

theorem row_14_25 : RowResult ⟨14, by decide⟩ ⟨25, by decide⟩ := by
  have _previous := row_14_24
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) 0 2 4)

theorem row_14_26 : RowResult ⟨14, by decide⟩ ⟨26, by decide⟩ := by
  have _previous := row_14_25
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨26, by decide⟩) 0 2 4)

theorem row_14_27 : RowResult ⟨14, by decide⟩ ⟨27, by decide⟩ := by
  have _previous := row_14_26
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) 0 2 4)

theorem row_14_28 : RowResult ⟨14, by decide⟩ ⟨28, by decide⟩ := by
  have _previous := row_14_27
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) 0 2 4)

theorem row_14_29 : RowResult ⟨14, by decide⟩ ⟨29, by decide⟩ := by
  have _previous := row_14_28
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨29, by decide⟩) 0 2 4)

theorem row_14_30 : RowResult ⟨14, by decide⟩ ⟨30, by decide⟩ := by
  have _previous := row_14_29
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨30, by decide⟩) 0 2 4)

theorem row_14_31 : RowResult ⟨14, by decide⟩ ⟨31, by decide⟩ := by
  have _previous := row_14_30
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) 0 2 4)

theorem row_14_32 : RowResult ⟨14, by decide⟩ ⟨32, by decide⟩ := by
  have _previous := row_14_31
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) 0 2 4)

theorem row_14_33 : RowResult ⟨14, by decide⟩ ⟨33, by decide⟩ := by
  have _previous := row_14_32
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) 0 2 4)

theorem row_14_34 : RowResult ⟨14, by decide⟩ ⟨34, by decide⟩ := by
  have _previous := row_14_33
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) 0 2 4)

theorem row_14_35 : RowResult ⟨14, by decide⟩ ⟨35, by decide⟩ := by
  have _previous := row_14_34
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) 0 2 4)

theorem row_14_36 : RowResult ⟨14, by decide⟩ ⟨36, by decide⟩ := by
  have _previous := row_14_35
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) 0 2 4)

theorem row_14_37 : RowResult ⟨14, by decide⟩ ⟨37, by decide⟩ := by
  have _previous := row_14_36
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) 0 2 4)

theorem row_14_38 : RowResult ⟨14, by decide⟩ ⟨38, by decide⟩ := by
  have _previous := row_14_37
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) 0 2 4)

theorem row_14_39 : RowResult ⟨14, by decide⟩ ⟨39, by decide⟩ := by
  have _previous := row_14_38
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) 0 2 4)

theorem row_14_40 : RowResult ⟨14, by decide⟩ ⟨40, by decide⟩ := by
  have _previous := row_14_39
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) 0 2 4)

theorem row_14_41 : RowResult ⟨14, by decide⟩ ⟨41, by decide⟩ := by
  have _previous := row_14_40
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) 0 2 4)

theorem row_14_42 : RowResult ⟨14, by decide⟩ ⟨42, by decide⟩ := by
  have _previous := row_14_41
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) 0 2 4)

theorem row_14_43 : RowResult ⟨14, by decide⟩ ⟨43, by decide⟩ := by
  have _previous := row_14_42
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) 0 2 4)

theorem row_14_44 : RowResult ⟨14, by decide⟩ ⟨44, by decide⟩ := by
  have _previous := row_14_43
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) 0 2 4)

theorem row_14_45 : RowResult ⟨14, by decide⟩ ⟨45, by decide⟩ := by
  have _previous := row_14_44
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) 0 2 4)

theorem row_14_46 : RowResult ⟨14, by decide⟩ ⟨46, by decide⟩ := by
  have _previous := row_14_45
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) 0 2 4)

theorem row_14_47 : RowResult ⟨14, by decide⟩ ⟨47, by decide⟩ := by
  have _previous := row_14_46
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) 0 2 4)

theorem row_14_48 : RowResult ⟨14, by decide⟩ ⟨48, by decide⟩ := by
  have _previous := row_14_47
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) 0 2 4)

theorem row_14_49 : RowResult ⟨14, by decide⟩ ⟨49, by decide⟩ := by
  have _previous := row_14_48
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) 0 2 4)

theorem row_14_50 : RowResult ⟨14, by decide⟩ ⟨50, by decide⟩ := by
  have _previous := row_14_49
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) 0 2 4)

theorem row_14_51 : RowResult ⟨14, by decide⟩ ⟨51, by decide⟩ := by
  have _previous := row_14_50
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 0 2 4)

theorem row_14_52 : RowResult ⟨14, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_14_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 0 2 4)

theorem row_14_53 : RowResult ⟨14, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_14_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 0 2 4)

theorem row_14_54 : RowResult ⟨14, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_14_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 0 2 4)

theorem row_14_55 : RowResult ⟨14, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_14_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 0 2 4)

theorem row_14_56 : RowResult ⟨14, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_14_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 0 2 4)

theorem row_14_57 : RowResult ⟨14, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_14_56
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) 0 2 4)

theorem row_14_58 : RowResult ⟨14, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_14_57
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) 0 2 4)

theorem row_14_59 : RowResult ⟨14, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_14_58
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) 0 2 4)

theorem row_14_60 : RowResult ⟨14, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_14_59
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) 0 2 4)

theorem row_14_61 : RowResult ⟨14, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_14_60
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) 0 2 4)

theorem row_14_62 : RowResult ⟨14, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_14_61
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) 0 2 4)

theorem row_14_63 : RowResult ⟨14, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_14_62
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) 0 2 4)

theorem row_14_64 : RowResult ⟨14, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_14_63
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) 0 2 4)

theorem row_14_65 : RowResult ⟨14, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_14_64
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) 0 2 4)

theorem row_14_66 : RowResult ⟨14, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_14_65
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) 0 2 4)

theorem row_14_67 : RowResult ⟨14, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_14_66
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) 0 2 4)

theorem row_14_68 : RowResult ⟨14, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_14_67
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) 0 2 4)

theorem row_14_69 : RowResult ⟨14, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_14_68
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 0 2 4)

theorem row_14_70 : RowResult ⟨14, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_14_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 0 2 4)

theorem row_14_71 : RowResult ⟨14, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_14_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 0 2 4)

theorem row_14_72 : RowResult ⟨14, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_14_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 0 2 4)

theorem row_14_73 : RowResult ⟨14, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_14_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 0 2 4)

theorem row_14_74 : RowResult ⟨14, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_14_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 0 2 4)

theorem row_14_75 : RowResult ⟨14, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_14_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 0 2 4)

theorem row_14_76 : RowResult ⟨14, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_14_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 0 2 4)

theorem row_14_77 : RowResult ⟨14, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_14_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 0 2 4)

theorem row_14_78 : RowResult ⟨14, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_14_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 0 2 4)

theorem row_14_79 : RowResult ⟨14, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_14_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 0 2 4)

theorem row_14_80 : RowResult ⟨14, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_14_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 0 2 4)

theorem row_14_81 : RowResult ⟨14, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_14_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 0 2 4)

theorem row_14_82 : RowResult ⟨14, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_14_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 0 2 4)

theorem row_14_83 : RowResult ⟨14, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_14_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 0 2 4)

theorem row_14_84 : RowResult ⟨14, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_14_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 0 2 4)

theorem row_14_85 : RowResult ⟨14, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_14_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 0 2 4)

theorem row_14_86 : RowResult ⟨14, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_14_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 0 2 4)

theorem row_14_87 : RowResult ⟨14, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_14_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 0 2 4)

theorem row_14_88 : RowResult ⟨14, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_14_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 0 2 4)

theorem row_14_89 : RowResult ⟨14, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_14_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 0 2 4)

theorem row_14_90 : RowResult ⟨14, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_14_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 0 2 4)

theorem row_14_91 : RowResult ⟨14, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_14_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 0 2 4)

theorem row_14_92 : RowResult ⟨14, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_14_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 0 2 4)

theorem row_14_93 : RowResult ⟨14, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_14_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 0 2 4)

theorem row_14_94 : RowResult ⟨14, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_14_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 0 2 4)

theorem row_14_95 : RowResult ⟨14, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_14_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 0 2 4)

theorem row_14_96 : RowResult ⟨14, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_14_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 0 2 4)

theorem row_14_97 : RowResult ⟨14, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_14_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 0 2 4)

theorem row_14_98 : RowResult ⟨14, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_14_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 0 2 4)

theorem row_14_99 : RowResult ⟨14, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_14_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 0 2 4)

theorem row_14_100 : RowResult ⟨14, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_14_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 0 2 4)

theorem row_14_101 : RowResult ⟨14, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_14_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 0 2 4)

theorem row_14_102 : RowResult ⟨14, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_14_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 0 2 4)

theorem row_14_103 : RowResult ⟨14, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_14_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 0 2 4)

theorem row_14_104 : RowResult ⟨14, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_14_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 0 2 4)

theorem row_14_105 : RowResult ⟨14, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_14_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 0 2 4)

theorem row_14_106 : RowResult ⟨14, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_14_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 0 2 4)

theorem row_14_107 : RowResult ⟨14, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_14_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 0 2 4)

theorem row_14_108 : RowResult ⟨14, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_14_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 0 2 4)

theorem row_14_109 : RowResult ⟨14, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_14_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 0 2 4)

theorem row_14_110 : RowResult ⟨14, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_14_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 0 2 4)

theorem row_14_111 : RowResult ⟨14, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_14_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 0 2 4)

theorem row_14_112 : RowResult ⟨14, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_14_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 0 2 4)

theorem row_14_113 : RowResult ⟨14, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_14_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 0 2 4)

theorem row_14_114 : RowResult ⟨14, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_14_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 0 2 4)

end RelativeConicArcs.Q25PairCertificate
