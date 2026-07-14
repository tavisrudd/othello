import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_40_41 : RowResult ⟨40, by decide⟩ ⟨41, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) 0 4 6)

theorem row_40_42 : RowResult ⟨40, by decide⟩ ⟨42, by decide⟩ := by
  have _previous := row_40_41
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) 0 4 6)

theorem row_40_43 : RowResult ⟨40, by decide⟩ ⟨43, by decide⟩ := by
  have _previous := row_40_42
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) 0 4 6)

theorem row_40_44 : RowResult ⟨40, by decide⟩ ⟨44, by decide⟩ := by
  have _previous := row_40_43
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) 0 4 6)

theorem row_40_45 : RowResult ⟨40, by decide⟩ ⟨45, by decide⟩ := by
  have _previous := row_40_44
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) 0 4 6)

theorem row_40_46 : RowResult ⟨40, by decide⟩ ⟨46, by decide⟩ := by
  have _previous := row_40_45
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) 0 4 6)

theorem row_40_47 : RowResult ⟨40, by decide⟩ ⟨47, by decide⟩ := by
  have _previous := row_40_46
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) 0 4 6)

theorem row_40_48 : RowResult ⟨40, by decide⟩ ⟨48, by decide⟩ := by
  have _previous := row_40_47
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) 0 4 6)

theorem row_40_49 : RowResult ⟨40, by decide⟩ ⟨49, by decide⟩ := by
  have _previous := row_40_48
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) 0 4 6)

theorem row_40_50 : RowResult ⟨40, by decide⟩ ⟨50, by decide⟩ := by
  have _previous := row_40_49
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) 1 6 7)

theorem row_40_51 : RowResult ⟨40, by decide⟩ ⟨51, by decide⟩ := by
  have _previous := row_40_50
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 1 6 7)

theorem row_40_52 : RowResult ⟨40, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_40_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 1 6 7)

theorem row_40_53 : RowResult ⟨40, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_40_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 1 6 7)

theorem row_40_54 : RowResult ⟨40, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_40_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 1 6 7)

theorem row_40_55 : RowResult ⟨40, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_40_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 1 2 6)

theorem row_40_56 : RowResult ⟨40, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_40_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 2 3 6)

theorem row_40_57 : RowResult ⟨40, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_40_56
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) 2 4 6)

theorem row_40_58 : RowResult ⟨40, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_40_57
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) 2 5 6)

theorem row_40_59 : RowResult ⟨40, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_40_58
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_40_60 : RowResult ⟨40, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_40_59
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) 1 4 7)

theorem row_40_61 : RowResult ⟨40, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_40_60
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_40_62 : RowResult ⟨40, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_40_61
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_40_63 : RowResult ⟨40, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_40_62
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_40_64 : RowResult ⟨40, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_40_63
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_40_65 : RowResult ⟨40, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_40_64
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) 1 4 6)

theorem row_40_66 : RowResult ⟨40, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_40_65
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_40_67 : RowResult ⟨40, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_40_66
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
