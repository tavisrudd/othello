import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_34_35 : RowResult ⟨34, by decide⟩ ⟨35, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) 0 4 6)

theorem row_34_36 : RowResult ⟨34, by decide⟩ ⟨36, by decide⟩ := by
  have _previous := row_34_35
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) 0 4 6)

theorem row_34_37 : RowResult ⟨34, by decide⟩ ⟨37, by decide⟩ := by
  have _previous := row_34_36
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) 0 4 6)

theorem row_34_38 : RowResult ⟨34, by decide⟩ ⟨38, by decide⟩ := by
  have _previous := row_34_37
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) 0 4 6)

theorem row_34_39 : RowResult ⟨34, by decide⟩ ⟨39, by decide⟩ := by
  have _previous := row_34_38
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) 0 4 6)

theorem row_34_40 : RowResult ⟨34, by decide⟩ ⟨40, by decide⟩ := by
  have _previous := row_34_39
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) 0 4 6)

theorem row_34_41 : RowResult ⟨34, by decide⟩ ⟨41, by decide⟩ := by
  have _previous := row_34_40
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) 0 4 6)

theorem row_34_42 : RowResult ⟨34, by decide⟩ ⟨42, by decide⟩ := by
  have _previous := row_34_41
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) 0 4 6)

theorem row_34_43 : RowResult ⟨34, by decide⟩ ⟨43, by decide⟩ := by
  have _previous := row_34_42
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) 0 4 6)

theorem row_34_44 : RowResult ⟨34, by decide⟩ ⟨44, by decide⟩ := by
  have _previous := row_34_43
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) 0 4 6)

theorem row_34_45 : RowResult ⟨34, by decide⟩ ⟨45, by decide⟩ := by
  have _previous := row_34_44
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) 0 4 6)

theorem row_34_46 : RowResult ⟨34, by decide⟩ ⟨46, by decide⟩ := by
  have _previous := row_34_45
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) 0 4 6)

theorem row_34_47 : RowResult ⟨34, by decide⟩ ⟨47, by decide⟩ := by
  have _previous := row_34_46
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) 0 4 6)

theorem row_34_48 : RowResult ⟨34, by decide⟩ ⟨48, by decide⟩ := by
  have _previous := row_34_47
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) 0 4 6)

theorem row_34_49 : RowResult ⟨34, by decide⟩ ⟨49, by decide⟩ := by
  have _previous := row_34_48
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) 0 4 6)

theorem row_34_50 : RowResult ⟨34, by decide⟩ ⟨50, by decide⟩ := by
  have _previous := row_34_49
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) 1 6 7)

theorem row_34_51 : RowResult ⟨34, by decide⟩ ⟨51, by decide⟩ := by
  have _previous := row_34_50
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 1 6 7)

theorem row_34_52 : RowResult ⟨34, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_34_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 1 6 7)

theorem row_34_53 : RowResult ⟨34, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_34_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 1 6 7)

theorem row_34_54 : RowResult ⟨34, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_34_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 1 6 7)

theorem row_34_55 : RowResult ⟨34, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_34_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 1 2 6)

theorem row_34_56 : RowResult ⟨34, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_34_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 2 3 6)

theorem row_34_57 : RowResult ⟨34, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_34_56
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_34_58 : RowResult ⟨34, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_34_57
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_34_59 : RowResult ⟨34, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_34_58
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) 1 4 6)

theorem row_34_60 : RowResult ⟨34, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_34_59
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_34_61 : RowResult ⟨34, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_34_60
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_34_62 : RowResult ⟨34, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_34_61
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) 2 4 7)

theorem row_34_63 : RowResult ⟨34, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_34_62
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_34_64 : RowResult ⟨34, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_34_63
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) 2 5 6)

theorem row_34_65 : RowResult ⟨34, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_34_64
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) 2 4 6)

theorem row_34_66 : RowResult ⟨34, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_34_65
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_34_67 : RowResult ⟨34, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_34_66
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
