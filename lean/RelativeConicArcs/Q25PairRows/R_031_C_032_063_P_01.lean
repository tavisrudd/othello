import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_31_32 : RowResult ⟨31, by decide⟩ ⟨32, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) 0 4 6)

theorem row_31_33 : RowResult ⟨31, by decide⟩ ⟨33, by decide⟩ := by
  have _previous := row_31_32
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) 0 4 6)

theorem row_31_34 : RowResult ⟨31, by decide⟩ ⟨34, by decide⟩ := by
  have _previous := row_31_33
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) 0 4 6)

theorem row_31_35 : RowResult ⟨31, by decide⟩ ⟨35, by decide⟩ := by
  have _previous := row_31_34
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) 0 4 6)

theorem row_31_36 : RowResult ⟨31, by decide⟩ ⟨36, by decide⟩ := by
  have _previous := row_31_35
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) 0 4 6)

theorem row_31_37 : RowResult ⟨31, by decide⟩ ⟨37, by decide⟩ := by
  have _previous := row_31_36
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) 0 4 6)

theorem row_31_38 : RowResult ⟨31, by decide⟩ ⟨38, by decide⟩ := by
  have _previous := row_31_37
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) 0 4 6)

theorem row_31_39 : RowResult ⟨31, by decide⟩ ⟨39, by decide⟩ := by
  have _previous := row_31_38
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) 0 4 6)

theorem row_31_40 : RowResult ⟨31, by decide⟩ ⟨40, by decide⟩ := by
  have _previous := row_31_39
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) 0 4 6)

theorem row_31_41 : RowResult ⟨31, by decide⟩ ⟨41, by decide⟩ := by
  have _previous := row_31_40
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) 0 4 6)

theorem row_31_42 : RowResult ⟨31, by decide⟩ ⟨42, by decide⟩ := by
  have _previous := row_31_41
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) 0 4 6)

theorem row_31_43 : RowResult ⟨31, by decide⟩ ⟨43, by decide⟩ := by
  have _previous := row_31_42
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) 0 4 6)

theorem row_31_44 : RowResult ⟨31, by decide⟩ ⟨44, by decide⟩ := by
  have _previous := row_31_43
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) 0 4 6)

theorem row_31_45 : RowResult ⟨31, by decide⟩ ⟨45, by decide⟩ := by
  have _previous := row_31_44
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) 0 4 6)

theorem row_31_46 : RowResult ⟨31, by decide⟩ ⟨46, by decide⟩ := by
  have _previous := row_31_45
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) 0 4 6)

theorem row_31_47 : RowResult ⟨31, by decide⟩ ⟨47, by decide⟩ := by
  have _previous := row_31_46
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) 0 4 6)

theorem row_31_48 : RowResult ⟨31, by decide⟩ ⟨48, by decide⟩ := by
  have _previous := row_31_47
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) 0 4 6)

theorem row_31_49 : RowResult ⟨31, by decide⟩ ⟨49, by decide⟩ := by
  have _previous := row_31_48
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) 0 4 6)

theorem row_31_50 : RowResult ⟨31, by decide⟩ ⟨50, by decide⟩ := by
  have _previous := row_31_49
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) 1 6 7)

theorem row_31_51 : RowResult ⟨31, by decide⟩ ⟨51, by decide⟩ := by
  have _previous := row_31_50
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 1 6 7)

theorem row_31_52 : RowResult ⟨31, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_31_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 1 6 7)

theorem row_31_53 : RowResult ⟨31, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_31_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 1 6 7)

theorem row_31_54 : RowResult ⟨31, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_31_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 1 6 7)

theorem row_31_55 : RowResult ⟨31, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_31_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 1 2 6)

theorem row_31_56 : RowResult ⟨31, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_31_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 1 4 6)

theorem row_31_57 : RowResult ⟨31, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_31_56
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_31_58 : RowResult ⟨31, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_31_57
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) 2 4 7)

theorem row_31_59 : RowResult ⟨31, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_31_58
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_31_60 : RowResult ⟨31, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_31_59
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_31_61 : RowResult ⟨31, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_31_60
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_31_62 : RowResult ⟨31, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_31_61
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_31_63 : RowResult ⟨31, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_31_62
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
