import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_41_42 : RowResult ⟨41, by decide⟩ ⟨42, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) 0 4 6)

theorem row_41_43 : RowResult ⟨41, by decide⟩ ⟨43, by decide⟩ := by
  have _previous := row_41_42
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) 0 4 6)

theorem row_41_44 : RowResult ⟨41, by decide⟩ ⟨44, by decide⟩ := by
  have _previous := row_41_43
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) 0 4 6)

theorem row_41_45 : RowResult ⟨41, by decide⟩ ⟨45, by decide⟩ := by
  have _previous := row_41_44
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) 0 4 6)

theorem row_41_46 : RowResult ⟨41, by decide⟩ ⟨46, by decide⟩ := by
  have _previous := row_41_45
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) 0 4 6)

theorem row_41_47 : RowResult ⟨41, by decide⟩ ⟨47, by decide⟩ := by
  have _previous := row_41_46
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) 0 4 6)

theorem row_41_48 : RowResult ⟨41, by decide⟩ ⟨48, by decide⟩ := by
  have _previous := row_41_47
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) 0 4 6)

theorem row_41_49 : RowResult ⟨41, by decide⟩ ⟨49, by decide⟩ := by
  have _previous := row_41_48
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) 0 4 6)

theorem row_41_50 : RowResult ⟨41, by decide⟩ ⟨50, by decide⟩ := by
  have _previous := row_41_49
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) 1 6 7)

theorem row_41_51 : RowResult ⟨41, by decide⟩ ⟨51, by decide⟩ := by
  have _previous := row_41_50
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 1 6 7)

theorem row_41_52 : RowResult ⟨41, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_41_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 1 6 7)

theorem row_41_53 : RowResult ⟨41, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_41_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 1 6 7)

theorem row_41_54 : RowResult ⟨41, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_41_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 1 6 7)

theorem row_41_55 : RowResult ⟨41, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_41_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 1 2 6)

theorem row_41_56 : RowResult ⟨41, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_41_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 2 3 6)

theorem row_41_57 : RowResult ⟨41, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_41_56
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) 2 5 7)

theorem row_41_58 : RowResult ⟨41, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_41_57
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_41_59 : RowResult ⟨41, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_41_58
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_41_60 : RowResult ⟨41, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_41_59
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_41_61 : RowResult ⟨41, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_41_60
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) 1 4 7)

theorem row_41_62 : RowResult ⟨41, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_41_61
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_41_63 : RowResult ⟨41, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_41_62
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_41_64 : RowResult ⟨41, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_41_63
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
