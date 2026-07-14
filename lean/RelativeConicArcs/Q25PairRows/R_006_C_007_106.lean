import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_6_7 : RowResult ⟨6, by decide⟩ ⟨7, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨7, by decide⟩) 0 2 4)

theorem row_6_8 : RowResult ⟨6, by decide⟩ ⟨8, by decide⟩ := by
  have _previous := row_6_7
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨8, by decide⟩) 0 2 4)

theorem row_6_9 : RowResult ⟨6, by decide⟩ ⟨9, by decide⟩ := by
  have _previous := row_6_8
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨9, by decide⟩) 0 2 4)

theorem row_6_10 : RowResult ⟨6, by decide⟩ ⟨10, by decide⟩ := by
  have _previous := row_6_9
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨10, by decide⟩) 0 2 4)

theorem row_6_11 : RowResult ⟨6, by decide⟩ ⟨11, by decide⟩ := by
  have _previous := row_6_10
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨11, by decide⟩) 0 2 4)

theorem row_6_12 : RowResult ⟨6, by decide⟩ ⟨12, by decide⟩ := by
  have _previous := row_6_11
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨12, by decide⟩) 0 2 4)

theorem row_6_13 : RowResult ⟨6, by decide⟩ ⟨13, by decide⟩ := by
  have _previous := row_6_12
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨13, by decide⟩) 0 2 4)

theorem row_6_14 : RowResult ⟨6, by decide⟩ ⟨14, by decide⟩ := by
  have _previous := row_6_13
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨14, by decide⟩) 0 2 4)

theorem row_6_15 : RowResult ⟨6, by decide⟩ ⟨15, by decide⟩ := by
  have _previous := row_6_14
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨15, by decide⟩) 0 2 4)

theorem row_6_16 : RowResult ⟨6, by decide⟩ ⟨16, by decide⟩ := by
  have _previous := row_6_15
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨16, by decide⟩) 0 2 4)

theorem row_6_17 : RowResult ⟨6, by decide⟩ ⟨17, by decide⟩ := by
  have _previous := row_6_16
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨17, by decide⟩) 0 2 4)

theorem row_6_18 : RowResult ⟨6, by decide⟩ ⟨18, by decide⟩ := by
  have _previous := row_6_17
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨18, by decide⟩) 0 2 4)

theorem row_6_19 : RowResult ⟨6, by decide⟩ ⟨19, by decide⟩ := by
  have _previous := row_6_18
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨19, by decide⟩) 0 2 4)

theorem row_6_20 : RowResult ⟨6, by decide⟩ ⟨20, by decide⟩ := by
  have _previous := row_6_19
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨20, by decide⟩) 0 2 4)

theorem row_6_21 : RowResult ⟨6, by decide⟩ ⟨21, by decide⟩ := by
  have _previous := row_6_20
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨21, by decide⟩) 0 2 4)

theorem row_6_22 : RowResult ⟨6, by decide⟩ ⟨22, by decide⟩ := by
  have _previous := row_6_21
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨22, by decide⟩) 0 2 4)

theorem row_6_23 : RowResult ⟨6, by decide⟩ ⟨23, by decide⟩ := by
  have _previous := row_6_22
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨23, by decide⟩) 0 2 4)

theorem row_6_24 : RowResult ⟨6, by decide⟩ ⟨24, by decide⟩ := by
  have _previous := row_6_23
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨24, by decide⟩) 0 2 4)

theorem row_6_25 : RowResult ⟨6, by decide⟩ ⟨25, by decide⟩ := by
  have _previous := row_6_24
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨25, by decide⟩) 0 2 4)

theorem row_6_26 : RowResult ⟨6, by decide⟩ ⟨26, by decide⟩ := by
  have _previous := row_6_25
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨26, by decide⟩) 0 2 4)

theorem row_6_27 : RowResult ⟨6, by decide⟩ ⟨27, by decide⟩ := by
  have _previous := row_6_26
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨27, by decide⟩) 0 2 4)

theorem row_6_28 : RowResult ⟨6, by decide⟩ ⟨28, by decide⟩ := by
  have _previous := row_6_27
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨28, by decide⟩) 0 2 4)

theorem row_6_29 : RowResult ⟨6, by decide⟩ ⟨29, by decide⟩ := by
  have _previous := row_6_28
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨29, by decide⟩) 0 2 4)

theorem row_6_30 : RowResult ⟨6, by decide⟩ ⟨30, by decide⟩ := by
  have _previous := row_6_29
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨30, by decide⟩) 0 2 4)

theorem row_6_31 : RowResult ⟨6, by decide⟩ ⟨31, by decide⟩ := by
  have _previous := row_6_30
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) 0 2 4)

theorem row_6_32 : RowResult ⟨6, by decide⟩ ⟨32, by decide⟩ := by
  have _previous := row_6_31
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) 0 2 4)

theorem row_6_33 : RowResult ⟨6, by decide⟩ ⟨33, by decide⟩ := by
  have _previous := row_6_32
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) 0 2 4)

theorem row_6_34 : RowResult ⟨6, by decide⟩ ⟨34, by decide⟩ := by
  have _previous := row_6_33
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) 0 2 4)

theorem row_6_35 : RowResult ⟨6, by decide⟩ ⟨35, by decide⟩ := by
  have _previous := row_6_34
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) 0 2 4)

theorem row_6_36 : RowResult ⟨6, by decide⟩ ⟨36, by decide⟩ := by
  have _previous := row_6_35
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) 0 2 4)

theorem row_6_37 : RowResult ⟨6, by decide⟩ ⟨37, by decide⟩ := by
  have _previous := row_6_36
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) 0 2 4)

theorem row_6_38 : RowResult ⟨6, by decide⟩ ⟨38, by decide⟩ := by
  have _previous := row_6_37
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) 0 2 4)

theorem row_6_39 : RowResult ⟨6, by decide⟩ ⟨39, by decide⟩ := by
  have _previous := row_6_38
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) 0 2 4)

theorem row_6_40 : RowResult ⟨6, by decide⟩ ⟨40, by decide⟩ := by
  have _previous := row_6_39
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) 0 2 4)

theorem row_6_41 : RowResult ⟨6, by decide⟩ ⟨41, by decide⟩ := by
  have _previous := row_6_40
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) 0 2 4)

theorem row_6_42 : RowResult ⟨6, by decide⟩ ⟨42, by decide⟩ := by
  have _previous := row_6_41
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) 0 2 4)

theorem row_6_43 : RowResult ⟨6, by decide⟩ ⟨43, by decide⟩ := by
  have _previous := row_6_42
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) 0 2 4)

theorem row_6_44 : RowResult ⟨6, by decide⟩ ⟨44, by decide⟩ := by
  have _previous := row_6_43
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) 0 2 4)

theorem row_6_45 : RowResult ⟨6, by decide⟩ ⟨45, by decide⟩ := by
  have _previous := row_6_44
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) 0 2 4)

theorem row_6_46 : RowResult ⟨6, by decide⟩ ⟨46, by decide⟩ := by
  have _previous := row_6_45
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) 0 2 4)

theorem row_6_47 : RowResult ⟨6, by decide⟩ ⟨47, by decide⟩ := by
  have _previous := row_6_46
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) 0 2 4)

theorem row_6_48 : RowResult ⟨6, by decide⟩ ⟨48, by decide⟩ := by
  have _previous := row_6_47
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) 0 2 4)

theorem row_6_49 : RowResult ⟨6, by decide⟩ ⟨49, by decide⟩ := by
  have _previous := row_6_48
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) 0 2 4)

theorem row_6_50 : RowResult ⟨6, by decide⟩ ⟨50, by decide⟩ := by
  have _previous := row_6_49
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) 0 2 4)

theorem row_6_51 : RowResult ⟨6, by decide⟩ ⟨51, by decide⟩ := by
  have _previous := row_6_50
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 0 2 4)

theorem row_6_52 : RowResult ⟨6, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_6_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 0 2 4)

theorem row_6_53 : RowResult ⟨6, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_6_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 0 2 4)

theorem row_6_54 : RowResult ⟨6, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_6_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 0 2 4)

theorem row_6_55 : RowResult ⟨6, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_6_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 0 2 4)

theorem row_6_56 : RowResult ⟨6, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_6_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 0 2 4)

theorem row_6_57 : RowResult ⟨6, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_6_56
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) 0 2 4)

theorem row_6_58 : RowResult ⟨6, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_6_57
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) 0 2 4)

theorem row_6_59 : RowResult ⟨6, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_6_58
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) 0 2 4)

theorem row_6_60 : RowResult ⟨6, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_6_59
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) 0 2 4)

theorem row_6_61 : RowResult ⟨6, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_6_60
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) 0 2 4)

theorem row_6_62 : RowResult ⟨6, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_6_61
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) 0 2 4)

theorem row_6_63 : RowResult ⟨6, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_6_62
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) 0 2 4)

theorem row_6_64 : RowResult ⟨6, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_6_63
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) 0 2 4)

theorem row_6_65 : RowResult ⟨6, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_6_64
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) 0 2 4)

theorem row_6_66 : RowResult ⟨6, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_6_65
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) 0 2 4)

theorem row_6_67 : RowResult ⟨6, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_6_66
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) 0 2 4)

theorem row_6_68 : RowResult ⟨6, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_6_67
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) 0 2 4)

theorem row_6_69 : RowResult ⟨6, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_6_68
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 0 2 4)

theorem row_6_70 : RowResult ⟨6, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_6_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 0 2 4)

theorem row_6_71 : RowResult ⟨6, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_6_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 0 2 4)

theorem row_6_72 : RowResult ⟨6, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_6_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 0 2 4)

theorem row_6_73 : RowResult ⟨6, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_6_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 0 2 4)

theorem row_6_74 : RowResult ⟨6, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_6_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 0 2 4)

theorem row_6_75 : RowResult ⟨6, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_6_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 0 2 4)

theorem row_6_76 : RowResult ⟨6, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_6_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 0 2 4)

theorem row_6_77 : RowResult ⟨6, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_6_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 0 2 4)

theorem row_6_78 : RowResult ⟨6, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_6_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 0 2 4)

theorem row_6_79 : RowResult ⟨6, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_6_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 0 2 4)

theorem row_6_80 : RowResult ⟨6, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_6_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 0 2 4)

theorem row_6_81 : RowResult ⟨6, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_6_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 0 2 4)

theorem row_6_82 : RowResult ⟨6, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_6_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 0 2 4)

theorem row_6_83 : RowResult ⟨6, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_6_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 0 2 4)

theorem row_6_84 : RowResult ⟨6, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_6_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 0 2 4)

theorem row_6_85 : RowResult ⟨6, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_6_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 0 2 4)

theorem row_6_86 : RowResult ⟨6, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_6_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 0 2 4)

theorem row_6_87 : RowResult ⟨6, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_6_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 0 2 4)

theorem row_6_88 : RowResult ⟨6, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_6_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 0 2 4)

theorem row_6_89 : RowResult ⟨6, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_6_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 0 2 4)

theorem row_6_90 : RowResult ⟨6, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_6_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 0 2 4)

theorem row_6_91 : RowResult ⟨6, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_6_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 0 2 4)

theorem row_6_92 : RowResult ⟨6, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_6_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 0 2 4)

theorem row_6_93 : RowResult ⟨6, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_6_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 0 2 4)

theorem row_6_94 : RowResult ⟨6, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_6_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 0 2 4)

theorem row_6_95 : RowResult ⟨6, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_6_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 0 2 4)

theorem row_6_96 : RowResult ⟨6, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_6_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 0 2 4)

theorem row_6_97 : RowResult ⟨6, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_6_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 0 2 4)

theorem row_6_98 : RowResult ⟨6, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_6_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 0 2 4)

theorem row_6_99 : RowResult ⟨6, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_6_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 0 2 4)

theorem row_6_100 : RowResult ⟨6, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_6_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 0 2 4)

theorem row_6_101 : RowResult ⟨6, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_6_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 0 2 4)

theorem row_6_102 : RowResult ⟨6, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_6_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 0 2 4)

theorem row_6_103 : RowResult ⟨6, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_6_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 0 2 4)

theorem row_6_104 : RowResult ⟨6, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_6_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 0 2 4)

theorem row_6_105 : RowResult ⟨6, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_6_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 0 2 4)

theorem row_6_106 : RowResult ⟨6, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_6_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨6, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 0 2 4)

end RelativeConicArcs.Q25PairCertificate
