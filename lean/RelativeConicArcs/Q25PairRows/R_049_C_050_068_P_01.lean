import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_49_50 : RowResult ⟨49, by decide⟩ ⟨50, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) 1 6 7)

theorem row_49_51 : RowResult ⟨49, by decide⟩ ⟨51, by decide⟩ := by
  have _previous := row_49_50
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 1 6 7)

theorem row_49_52 : RowResult ⟨49, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_49_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 1 6 7)

theorem row_49_53 : RowResult ⟨49, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_49_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 1 6 7)

theorem row_49_54 : RowResult ⟨49, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_49_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 1 6 7)

theorem row_49_55 : RowResult ⟨49, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_49_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 1 2 6)

theorem row_49_56 : RowResult ⟨49, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_49_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 2 3 6)

theorem row_49_57 : RowResult ⟨49, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_49_56
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_49_58 : RowResult ⟨49, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_49_57
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_49_59 : RowResult ⟨49, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_49_58
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) 1 4 7)

theorem row_49_60 : RowResult ⟨49, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_49_59
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) 2 5 6)

theorem row_49_61 : RowResult ⟨49, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_49_60
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) 4 5 6)

theorem row_49_62 : RowResult ⟨49, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_49_61
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_49_63 : RowResult ⟨49, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_49_62
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_49_64 : RowResult ⟨49, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_49_63
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_49_65 : RowResult ⟨49, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_49_64
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) 2 4 7)

theorem row_49_66 : RowResult ⟨49, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_49_65
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) 2 5 7)

theorem row_49_67 : RowResult ⟨49, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_49_66
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_49_68 : RowResult ⟨49, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_49_67
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
