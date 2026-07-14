import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_57_58 : RowResult ⟨57, by decide⟩ ⟨58, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) 0 4 6)

theorem row_57_59 : RowResult ⟨57, by decide⟩ ⟨59, by decide⟩ := by
  have _previous := row_57_58
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) 0 4 6)

theorem row_57_60 : RowResult ⟨57, by decide⟩ ⟨60, by decide⟩ := by
  have _previous := row_57_59
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) 0 4 6)

theorem row_57_61 : RowResult ⟨57, by decide⟩ ⟨61, by decide⟩ := by
  have _previous := row_57_60
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) 0 4 6)

theorem row_57_62 : RowResult ⟨57, by decide⟩ ⟨62, by decide⟩ := by
  have _previous := row_57_61
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) 0 4 6)

theorem row_57_63 : RowResult ⟨57, by decide⟩ ⟨63, by decide⟩ := by
  have _previous := row_57_62
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) 0 4 6)

theorem row_57_64 : RowResult ⟨57, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_57_63
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) 0 4 6)

theorem row_57_65 : RowResult ⟨57, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_57_64
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) 0 4 6)

theorem row_57_66 : RowResult ⟨57, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_57_65
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) 0 4 6)

theorem row_57_67 : RowResult ⟨57, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_57_66
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) 0 4 6)

theorem row_57_68 : RowResult ⟨57, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_57_67
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) 0 4 6)

theorem row_57_69 : RowResult ⟨57, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_57_68
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 0 4 6)

theorem row_57_70 : RowResult ⟨57, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_57_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 0 4 6)

theorem row_57_71 : RowResult ⟨57, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_57_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 0 4 6)

theorem row_57_72 : RowResult ⟨57, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_57_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 0 4 6)

theorem row_57_73 : RowResult ⟨57, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_57_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 0 4 6)

theorem row_57_74 : RowResult ⟨57, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_57_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 0 4 6)

theorem row_57_75 : RowResult ⟨57, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_57_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_57_76 : RowResult ⟨57, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_57_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_57_77 : RowResult ⟨57, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_57_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_57_78 : RowResult ⟨57, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_57_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_57_79 : RowResult ⟨57, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_57_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_57_80 : RowResult ⟨57, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_57_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_57_81 : RowResult ⟨57, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_57_80
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_82 : RowResult ⟨57, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_57_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 1 4 6)

theorem row_57_83 : RowResult ⟨57, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_57_82
  exact Or.inr ⟨orbitCodeOfNumber ⟨167, by decide⟩, by decide⟩

theorem row_57_84 : RowResult ⟨57, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_57_83
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_57_85 : RowResult ⟨57, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_57_84
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_57_86 : RowResult ⟨57, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_57_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_57_87 : RowResult ⟨57, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_57_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨57, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 4 5 6)

theorem row_57_88 : RowResult ⟨57, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_57_87
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_89 : RowResult ⟨57, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_57_88
  exact Or.inr ⟨orbitCodeOfNumber ⟨167, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
