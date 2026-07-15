import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_47_48 : RowResult ⟨47, by decide⟩ ⟨48, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) 0 4 6)

theorem row_47_49 : RowResult ⟨47, by decide⟩ ⟨49, by decide⟩ := by
  have _previous := row_47_48
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) 0 4 6)

theorem row_47_50 : RowResult ⟨47, by decide⟩ ⟨50, by decide⟩ := by
  have _previous := row_47_49
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) 1 6 7)

theorem row_47_51 : RowResult ⟨47, by decide⟩ ⟨51, by decide⟩ := by
  have _previous := row_47_50
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 1 6 7)

theorem row_47_52 : RowResult ⟨47, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_47_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 1 6 7)

theorem row_47_53 : RowResult ⟨47, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_47_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 1 6 7)

theorem row_47_54 : RowResult ⟨47, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_47_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 1 6 7)

theorem row_47_55 : RowResult ⟨47, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_47_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 1 2 6)

theorem row_47_56 : RowResult ⟨47, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_47_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 2 3 6)

theorem row_47_57 : RowResult ⟨47, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_47_56
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) 1 4 7)

theorem row_47_58 : RowResult ⟨47, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_47_57
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) 2 5 7)

theorem row_47_59 : RowResult ⟨47, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_47_58
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_47_60 : RowResult ⟨47, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_47_59
  exact Or.inr ⟨orbitCodeOfNumber ⟨88, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_47_61 : RowResult ⟨47, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_47_60
  exact Or.inr ⟨orbitCodeOfNumber ⟨81, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_47_62 : RowResult ⟨47, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_47_61
  exact Or.inr ⟨orbitCodeOfNumber ⟨83, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_47_63 : RowResult ⟨47, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_47_62
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) 2 4 6)

theorem row_47_64 : RowResult ⟨47, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_47_63
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) 4 5 6)

theorem row_47_65 : RowResult ⟨47, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_47_64
  exact Or.inr ⟨orbitCodeOfNumber ⟨83, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_47_66 : RowResult ⟨47, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_47_65
  exact Or.inr ⟨orbitCodeOfNumber ⟨83, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
