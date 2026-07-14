import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_33_34 : RowResult ⟨33, by decide⟩ ⟨34, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) 0 4 6)

theorem row_33_35 : RowResult ⟨33, by decide⟩ ⟨35, by decide⟩ := by
  have _previous := row_33_34
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨35, by decide⟩) 0 4 6)

theorem row_33_36 : RowResult ⟨33, by decide⟩ ⟨36, by decide⟩ := by
  have _previous := row_33_35
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) 0 4 6)

theorem row_33_37 : RowResult ⟨33, by decide⟩ ⟨37, by decide⟩ := by
  have _previous := row_33_36
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) 0 4 6)

theorem row_33_38 : RowResult ⟨33, by decide⟩ ⟨38, by decide⟩ := by
  have _previous := row_33_37
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) 0 4 6)

theorem row_33_39 : RowResult ⟨33, by decide⟩ ⟨39, by decide⟩ := by
  have _previous := row_33_38
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) 0 4 6)

theorem row_33_40 : RowResult ⟨33, by decide⟩ ⟨40, by decide⟩ := by
  have _previous := row_33_39
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) 0 4 6)

theorem row_33_41 : RowResult ⟨33, by decide⟩ ⟨41, by decide⟩ := by
  have _previous := row_33_40
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) 0 4 6)

theorem row_33_42 : RowResult ⟨33, by decide⟩ ⟨42, by decide⟩ := by
  have _previous := row_33_41
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) 0 4 6)

theorem row_33_43 : RowResult ⟨33, by decide⟩ ⟨43, by decide⟩ := by
  have _previous := row_33_42
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) 0 4 6)

theorem row_33_44 : RowResult ⟨33, by decide⟩ ⟨44, by decide⟩ := by
  have _previous := row_33_43
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) 0 4 6)

theorem row_33_45 : RowResult ⟨33, by decide⟩ ⟨45, by decide⟩ := by
  have _previous := row_33_44
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) 0 4 6)

theorem row_33_46 : RowResult ⟨33, by decide⟩ ⟨46, by decide⟩ := by
  have _previous := row_33_45
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) 0 4 6)

theorem row_33_47 : RowResult ⟨33, by decide⟩ ⟨47, by decide⟩ := by
  have _previous := row_33_46
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) 0 4 6)

theorem row_33_48 : RowResult ⟨33, by decide⟩ ⟨48, by decide⟩ := by
  have _previous := row_33_47
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) 0 4 6)

theorem row_33_49 : RowResult ⟨33, by decide⟩ ⟨49, by decide⟩ := by
  have _previous := row_33_48
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) 0 4 6)

theorem row_33_50 : RowResult ⟨33, by decide⟩ ⟨50, by decide⟩ := by
  have _previous := row_33_49
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) 1 6 7)

theorem row_33_51 : RowResult ⟨33, by decide⟩ ⟨51, by decide⟩ := by
  have _previous := row_33_50
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 1 6 7)

theorem row_33_52 : RowResult ⟨33, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_33_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 1 6 7)

theorem row_33_53 : RowResult ⟨33, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_33_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 1 6 7)

theorem row_33_54 : RowResult ⟨33, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_33_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 1 6 7)

theorem row_33_55 : RowResult ⟨33, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_33_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 1 2 6)

theorem row_33_56 : RowResult ⟨33, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_33_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 2 3 6)

theorem row_33_57 : RowResult ⟨33, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_33_56
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_33_58 : RowResult ⟨33, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_33_57
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) 1 4 6)

theorem row_33_59 : RowResult ⟨33, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_33_58
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_33_60 : RowResult ⟨33, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_33_59
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_61 : RowResult ⟨33, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_33_60
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_33_62 : RowResult ⟨33, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_33_61
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_33_63 : RowResult ⟨33, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_33_62
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
