import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_38_39 : RowResult ⟨38, by decide⟩ ⟨39, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) 0 4 6)

theorem row_38_40 : RowResult ⟨38, by decide⟩ ⟨40, by decide⟩ := by
  have _previous := row_38_39
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) 0 4 6)

theorem row_38_41 : RowResult ⟨38, by decide⟩ ⟨41, by decide⟩ := by
  have _previous := row_38_40
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) 0 4 6)

theorem row_38_42 : RowResult ⟨38, by decide⟩ ⟨42, by decide⟩ := by
  have _previous := row_38_41
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨42, by decide⟩) 0 4 6)

theorem row_38_43 : RowResult ⟨38, by decide⟩ ⟨43, by decide⟩ := by
  have _previous := row_38_42
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) 0 4 6)

theorem row_38_44 : RowResult ⟨38, by decide⟩ ⟨44, by decide⟩ := by
  have _previous := row_38_43
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨44, by decide⟩) 0 4 6)

theorem row_38_45 : RowResult ⟨38, by decide⟩ ⟨45, by decide⟩ := by
  have _previous := row_38_44
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨45, by decide⟩) 0 4 6)

theorem row_38_46 : RowResult ⟨38, by decide⟩ ⟨46, by decide⟩ := by
  have _previous := row_38_45
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) 0 4 6)

theorem row_38_47 : RowResult ⟨38, by decide⟩ ⟨47, by decide⟩ := by
  have _previous := row_38_46
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) 0 4 6)

theorem row_38_48 : RowResult ⟨38, by decide⟩ ⟨48, by decide⟩ := by
  have _previous := row_38_47
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) 0 4 6)

theorem row_38_49 : RowResult ⟨38, by decide⟩ ⟨49, by decide⟩ := by
  have _previous := row_38_48
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) 0 4 6)

theorem row_38_50 : RowResult ⟨38, by decide⟩ ⟨50, by decide⟩ := by
  have _previous := row_38_49
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨50, by decide⟩) 1 6 7)

theorem row_38_51 : RowResult ⟨38, by decide⟩ ⟨51, by decide⟩ := by
  have _previous := row_38_50
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨51, by decide⟩) 1 6 7)

theorem row_38_52 : RowResult ⟨38, by decide⟩ ⟨52, by decide⟩ := by
  have _previous := row_38_51
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨52, by decide⟩) 1 6 7)

theorem row_38_53 : RowResult ⟨38, by decide⟩ ⟨53, by decide⟩ := by
  have _previous := row_38_52
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨53, by decide⟩) 1 6 7)

theorem row_38_54 : RowResult ⟨38, by decide⟩ ⟨54, by decide⟩ := by
  have _previous := row_38_53
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨54, by decide⟩) 1 6 7)

theorem row_38_55 : RowResult ⟨38, by decide⟩ ⟨55, by decide⟩ := by
  have _previous := row_38_54
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨55, by decide⟩) 1 2 6)

theorem row_38_56 : RowResult ⟨38, by decide⟩ ⟨56, by decide⟩ := by
  have _previous := row_38_55
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨56, by decide⟩) 2 3 6)

theorem row_38_57 : RowResult ⟨38, by decide⟩ ⟨57, by decide⟩ := by
  have _previous := row_38_56
  exact Or.inr ⟨orbitCodeOfNumber ⟨81, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_38_58 : RowResult ⟨38, by decide⟩ ⟨58, by decide⟩ := by
  have _previous := row_38_57
  exact Or.inr ⟨orbitCodeOfNumber ⟨81, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_38_59 : RowResult ⟨38, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_38_58
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) 4 5 6)

theorem row_38_60 : RowResult ⟨38, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_38_59
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) 2 4 7)

theorem row_38_61 : RowResult ⟨38, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_38_60
  exact Or.inr ⟨orbitCodeOfNumber ⟨81, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_38_62 : RowResult ⟨38, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_38_61
  exact Or.inr ⟨orbitCodeOfNumber ⟨82, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_38_63 : RowResult ⟨38, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_38_62
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) 1 4 6)

theorem row_38_64 : RowResult ⟨38, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_38_63
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_38_65 : RowResult ⟨38, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_38_64
  exact Or.inr ⟨orbitCodeOfNumber ⟨83, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_38_66 : RowResult ⟨38, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_38_65
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨38, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
