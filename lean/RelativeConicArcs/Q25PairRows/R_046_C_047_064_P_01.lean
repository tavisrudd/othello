import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_46_47 : RowResult ⟨46, by decide⟩ ⟨47, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) 0 4 6)

theorem row_46_48 : RowResult ⟨46, by decide⟩ ⟨48, by decide⟩ := by
  have _previous := row_46_47
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) 0 4 6)

theorem row_46_49 : RowResult ⟨46, by decide⟩ ⟨49, by decide⟩ := by
  have _previous := row_46_48
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) 0 4 6)

theorem row_46_50 : RowResult ⟨46, by decide⟩ ⟨50, by decide⟩ := by
  have _previous := row_46_49
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) 1 6 7)

theorem row_46_51 : RowResult ⟨46, by decide⟩ ⟨51, by decide⟩ := by
  have _previous := row_46_50
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 1 6 7)

theorem row_46_52 : RowResult ⟨46, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_46_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 1 6 7)

theorem row_46_53 : RowResult ⟨46, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_46_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 1 6 7)

theorem row_46_54 : RowResult ⟨46, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_46_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 1 6 7)

theorem row_46_55 : RowResult ⟨46, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_46_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 1 2 6)

theorem row_46_56 : RowResult ⟨46, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_46_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 1 4 7)

theorem row_46_57 : RowResult ⟨46, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_46_56
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_46_58 : RowResult ⟨46, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_46_57
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_46_59 : RowResult ⟨46, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_46_58
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_46_60 : RowResult ⟨46, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_46_59
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_46_61 : RowResult ⟨46, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_46_60
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) 2 4 7)

theorem row_46_62 : RowResult ⟨46, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_46_61
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_46_63 : RowResult ⟨46, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_46_62
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) 4 5 6)

theorem row_46_64 : RowResult ⟨46, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_46_63
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
