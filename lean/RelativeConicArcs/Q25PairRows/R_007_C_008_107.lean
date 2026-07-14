import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_7_8 : RowResult ⟨7, by decide⟩ ⟨8, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨8, by decide⟩) 0 2 4)

theorem row_7_9 : RowResult ⟨7, by decide⟩ ⟨9, by decide⟩ := by
  have _previous := row_7_8
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) 0 2 4)

theorem row_7_10 : RowResult ⟨7, by decide⟩ ⟨10, by decide⟩ := by
  have _previous := row_7_9
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨10, by decide⟩) 0 2 4)

theorem row_7_11 : RowResult ⟨7, by decide⟩ ⟨11, by decide⟩ := by
  have _previous := row_7_10
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) 0 2 4)

theorem row_7_12 : RowResult ⟨7, by decide⟩ ⟨12, by decide⟩ := by
  have _previous := row_7_11
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨12, by decide⟩) 0 2 4)

theorem row_7_13 : RowResult ⟨7, by decide⟩ ⟨13, by decide⟩ := by
  have _previous := row_7_12
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨13, by decide⟩) 0 2 4)

theorem row_7_14 : RowResult ⟨7, by decide⟩ ⟨14, by decide⟩ := by
  have _previous := row_7_13
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) 0 2 4)

theorem row_7_15 : RowResult ⟨7, by decide⟩ ⟨15, by decide⟩ := by
  have _previous := row_7_14
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨15, by decide⟩) 0 2 4)

theorem row_7_16 : RowResult ⟨7, by decide⟩ ⟨16, by decide⟩ := by
  have _previous := row_7_15
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨16, by decide⟩) 0 2 4)

theorem row_7_17 : RowResult ⟨7, by decide⟩ ⟨17, by decide⟩ := by
  have _previous := row_7_16
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨17, by decide⟩) 0 2 4)

theorem row_7_18 : RowResult ⟨7, by decide⟩ ⟨18, by decide⟩ := by
  have _previous := row_7_17
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) 0 2 4)

theorem row_7_19 : RowResult ⟨7, by decide⟩ ⟨19, by decide⟩ := by
  have _previous := row_7_18
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨19, by decide⟩) 0 2 4)

theorem row_7_20 : RowResult ⟨7, by decide⟩ ⟨20, by decide⟩ := by
  have _previous := row_7_19
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) 0 2 4)

theorem row_7_21 : RowResult ⟨7, by decide⟩ ⟨21, by decide⟩ := by
  have _previous := row_7_20
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) 0 2 4)

theorem row_7_22 : RowResult ⟨7, by decide⟩ ⟨22, by decide⟩ := by
  have _previous := row_7_21
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨22, by decide⟩) 0 2 4)

theorem row_7_23 : RowResult ⟨7, by decide⟩ ⟨23, by decide⟩ := by
  have _previous := row_7_22
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨23, by decide⟩) 0 2 4)

theorem row_7_24 : RowResult ⟨7, by decide⟩ ⟨24, by decide⟩ := by
  have _previous := row_7_23
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨24, by decide⟩) 0 2 4)

theorem row_7_25 : RowResult ⟨7, by decide⟩ ⟨25, by decide⟩ := by
  have _previous := row_7_24
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) 0 2 4)

theorem row_7_26 : RowResult ⟨7, by decide⟩ ⟨26, by decide⟩ := by
  have _previous := row_7_25
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨26, by decide⟩) 0 2 4)

theorem row_7_27 : RowResult ⟨7, by decide⟩ ⟨27, by decide⟩ := by
  have _previous := row_7_26
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) 0 2 4)

theorem row_7_28 : RowResult ⟨7, by decide⟩ ⟨28, by decide⟩ := by
  have _previous := row_7_27
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) 0 2 4)

theorem row_7_29 : RowResult ⟨7, by decide⟩ ⟨29, by decide⟩ := by
  have _previous := row_7_28
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨29, by decide⟩) 0 2 4)

theorem row_7_30 : RowResult ⟨7, by decide⟩ ⟨30, by decide⟩ := by
  have _previous := row_7_29
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨30, by decide⟩) 0 2 4)

theorem row_7_31 : RowResult ⟨7, by decide⟩ ⟨31, by decide⟩ := by
  have _previous := row_7_30
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) 0 2 4)

theorem row_7_32 : RowResult ⟨7, by decide⟩ ⟨32, by decide⟩ := by
  have _previous := row_7_31
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) 0 2 4)

theorem row_7_33 : RowResult ⟨7, by decide⟩ ⟨33, by decide⟩ := by
  have _previous := row_7_32
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) 0 2 4)

theorem row_7_34 : RowResult ⟨7, by decide⟩ ⟨34, by decide⟩ := by
  have _previous := row_7_33
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) 0 2 4)

theorem row_7_35 : RowResult ⟨7, by decide⟩ ⟨35, by decide⟩ := by
  have _previous := row_7_34
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) 0 2 4)

theorem row_7_36 : RowResult ⟨7, by decide⟩ ⟨36, by decide⟩ := by
  have _previous := row_7_35
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) 0 2 4)

theorem row_7_37 : RowResult ⟨7, by decide⟩ ⟨37, by decide⟩ := by
  have _previous := row_7_36
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) 0 2 4)

theorem row_7_38 : RowResult ⟨7, by decide⟩ ⟨38, by decide⟩ := by
  have _previous := row_7_37
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) 0 2 4)

theorem row_7_39 : RowResult ⟨7, by decide⟩ ⟨39, by decide⟩ := by
  have _previous := row_7_38
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) 0 2 4)

theorem row_7_40 : RowResult ⟨7, by decide⟩ ⟨40, by decide⟩ := by
  have _previous := row_7_39
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) 0 2 4)

theorem row_7_41 : RowResult ⟨7, by decide⟩ ⟨41, by decide⟩ := by
  have _previous := row_7_40
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) 0 2 4)

theorem row_7_42 : RowResult ⟨7, by decide⟩ ⟨42, by decide⟩ := by
  have _previous := row_7_41
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) 0 2 4)

theorem row_7_43 : RowResult ⟨7, by decide⟩ ⟨43, by decide⟩ := by
  have _previous := row_7_42
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) 0 2 4)

theorem row_7_44 : RowResult ⟨7, by decide⟩ ⟨44, by decide⟩ := by
  have _previous := row_7_43
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) 0 2 4)

theorem row_7_45 : RowResult ⟨7, by decide⟩ ⟨45, by decide⟩ := by
  have _previous := row_7_44
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) 0 2 4)

theorem row_7_46 : RowResult ⟨7, by decide⟩ ⟨46, by decide⟩ := by
  have _previous := row_7_45
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) 0 2 4)

theorem row_7_47 : RowResult ⟨7, by decide⟩ ⟨47, by decide⟩ := by
  have _previous := row_7_46
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) 0 2 4)

theorem row_7_48 : RowResult ⟨7, by decide⟩ ⟨48, by decide⟩ := by
  have _previous := row_7_47
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) 0 2 4)

theorem row_7_49 : RowResult ⟨7, by decide⟩ ⟨49, by decide⟩ := by
  have _previous := row_7_48
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) 0 2 4)

theorem row_7_50 : RowResult ⟨7, by decide⟩ ⟨50, by decide⟩ := by
  have _previous := row_7_49
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) 0 2 4)

theorem row_7_51 : RowResult ⟨7, by decide⟩ ⟨51, by decide⟩ := by
  have _previous := row_7_50
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 0 2 4)

theorem row_7_52 : RowResult ⟨7, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_7_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 0 2 4)

theorem row_7_53 : RowResult ⟨7, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_7_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 0 2 4)

theorem row_7_54 : RowResult ⟨7, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_7_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 0 2 4)

theorem row_7_55 : RowResult ⟨7, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_7_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 0 2 4)

theorem row_7_56 : RowResult ⟨7, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_7_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 0 2 4)

theorem row_7_57 : RowResult ⟨7, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_7_56
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) 0 2 4)

theorem row_7_58 : RowResult ⟨7, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_7_57
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) 0 2 4)

theorem row_7_59 : RowResult ⟨7, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_7_58
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) 0 2 4)

theorem row_7_60 : RowResult ⟨7, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_7_59
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) 0 2 4)

theorem row_7_61 : RowResult ⟨7, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_7_60
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) 0 2 4)

theorem row_7_62 : RowResult ⟨7, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_7_61
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) 0 2 4)

theorem row_7_63 : RowResult ⟨7, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_7_62
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) 0 2 4)

theorem row_7_64 : RowResult ⟨7, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_7_63
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) 0 2 4)

theorem row_7_65 : RowResult ⟨7, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_7_64
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) 0 2 4)

theorem row_7_66 : RowResult ⟨7, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_7_65
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) 0 2 4)

theorem row_7_67 : RowResult ⟨7, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_7_66
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) 0 2 4)

theorem row_7_68 : RowResult ⟨7, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_7_67
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) 0 2 4)

theorem row_7_69 : RowResult ⟨7, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_7_68
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 0 2 4)

theorem row_7_70 : RowResult ⟨7, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_7_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 0 2 4)

theorem row_7_71 : RowResult ⟨7, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_7_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 0 2 4)

theorem row_7_72 : RowResult ⟨7, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_7_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 0 2 4)

theorem row_7_73 : RowResult ⟨7, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_7_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 0 2 4)

theorem row_7_74 : RowResult ⟨7, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_7_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 0 2 4)

theorem row_7_75 : RowResult ⟨7, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_7_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 0 2 4)

theorem row_7_76 : RowResult ⟨7, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_7_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 0 2 4)

theorem row_7_77 : RowResult ⟨7, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_7_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 0 2 4)

theorem row_7_78 : RowResult ⟨7, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_7_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 0 2 4)

theorem row_7_79 : RowResult ⟨7, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_7_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 0 2 4)

theorem row_7_80 : RowResult ⟨7, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_7_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 0 2 4)

theorem row_7_81 : RowResult ⟨7, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_7_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 0 2 4)

theorem row_7_82 : RowResult ⟨7, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_7_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 0 2 4)

theorem row_7_83 : RowResult ⟨7, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_7_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 0 2 4)

theorem row_7_84 : RowResult ⟨7, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_7_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 0 2 4)

theorem row_7_85 : RowResult ⟨7, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_7_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 0 2 4)

theorem row_7_86 : RowResult ⟨7, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_7_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 0 2 4)

theorem row_7_87 : RowResult ⟨7, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_7_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 0 2 4)

theorem row_7_88 : RowResult ⟨7, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_7_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 0 2 4)

theorem row_7_89 : RowResult ⟨7, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_7_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 0 2 4)

theorem row_7_90 : RowResult ⟨7, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_7_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 0 2 4)

theorem row_7_91 : RowResult ⟨7, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_7_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 0 2 4)

theorem row_7_92 : RowResult ⟨7, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_7_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 0 2 4)

theorem row_7_93 : RowResult ⟨7, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_7_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 0 2 4)

theorem row_7_94 : RowResult ⟨7, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_7_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 0 2 4)

theorem row_7_95 : RowResult ⟨7, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_7_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 0 2 4)

theorem row_7_96 : RowResult ⟨7, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_7_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 0 2 4)

theorem row_7_97 : RowResult ⟨7, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_7_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 0 2 4)

theorem row_7_98 : RowResult ⟨7, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_7_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 0 2 4)

theorem row_7_99 : RowResult ⟨7, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_7_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 0 2 4)

theorem row_7_100 : RowResult ⟨7, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_7_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 0 2 4)

theorem row_7_101 : RowResult ⟨7, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_7_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 0 2 4)

theorem row_7_102 : RowResult ⟨7, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_7_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 0 2 4)

theorem row_7_103 : RowResult ⟨7, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_7_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 0 2 4)

theorem row_7_104 : RowResult ⟨7, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_7_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 0 2 4)

theorem row_7_105 : RowResult ⟨7, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_7_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 0 2 4)

theorem row_7_106 : RowResult ⟨7, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_7_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 0 2 4)

theorem row_7_107 : RowResult ⟨7, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_7_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 0 2 4)

end RelativeConicArcs.Q25PairCertificate
