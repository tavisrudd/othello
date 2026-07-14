import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_62_63 : RowResult ⟨62, by decide⟩ ⟨63, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) 0 4 6)

theorem row_62_64 : RowResult ⟨62, by decide⟩ ⟨64, by decide⟩ := by
  have _previous := row_62_63
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨64, by decide⟩) 0 4 6)

theorem row_62_65 : RowResult ⟨62, by decide⟩ ⟨65, by decide⟩ := by
  have _previous := row_62_64
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) 0 4 6)

theorem row_62_66 : RowResult ⟨62, by decide⟩ ⟨66, by decide⟩ := by
  have _previous := row_62_65
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) 0 4 6)

theorem row_62_67 : RowResult ⟨62, by decide⟩ ⟨67, by decide⟩ := by
  have _previous := row_62_66
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨67, by decide⟩) 0 4 6)

theorem row_62_68 : RowResult ⟨62, by decide⟩ ⟨68, by decide⟩ := by
  have _previous := row_62_67
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) 0 4 6)

theorem row_62_69 : RowResult ⟨62, by decide⟩ ⟨69, by decide⟩ := by
  have _previous := row_62_68
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 0 4 6)

theorem row_62_70 : RowResult ⟨62, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_62_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 0 4 6)

theorem row_62_71 : RowResult ⟨62, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_62_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 0 4 6)

theorem row_62_72 : RowResult ⟨62, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_62_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 0 4 6)

theorem row_62_73 : RowResult ⟨62, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_62_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 0 4 6)

theorem row_62_74 : RowResult ⟨62, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_62_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 0 4 6)

theorem row_62_75 : RowResult ⟨62, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_62_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_62_76 : RowResult ⟨62, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_62_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_62_77 : RowResult ⟨62, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_62_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_62_78 : RowResult ⟨62, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_62_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_62_79 : RowResult ⟨62, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_62_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_62_80 : RowResult ⟨62, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_62_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_62_81 : RowResult ⟨62, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_62_80
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_82 : RowResult ⟨62, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_62_81
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_83 : RowResult ⟨62, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_62_82
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_84 : RowResult ⟨62, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_62_83
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_85 : RowResult ⟨62, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_62_84
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_62_86 : RowResult ⟨62, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_62_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_62_87 : RowResult ⟨62, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_62_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 1 4 6)

theorem row_62_88 : RowResult ⟨62, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_62_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 2 5 7)

theorem row_62_89 : RowResult ⟨62, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_62_88
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
