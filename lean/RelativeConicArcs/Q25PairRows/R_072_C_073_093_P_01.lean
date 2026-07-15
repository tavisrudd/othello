import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_72_73 : RowResult ⟨72, by decide⟩ ⟨73, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 0 4 6)

theorem row_72_74 : RowResult ⟨72, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_72_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 0 4 6)

theorem row_72_75 : RowResult ⟨72, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_72_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_72_76 : RowResult ⟨72, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_72_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_72_77 : RowResult ⟨72, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_72_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_72_78 : RowResult ⟨72, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_72_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_72_79 : RowResult ⟨72, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_72_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_72_80 : RowResult ⟨72, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_72_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_72_81 : RowResult ⟨72, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_72_80
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_72_82 : RowResult ⟨72, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_72_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 1 4 7)

theorem row_72_83 : RowResult ⟨72, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_72_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 2 4 6)

theorem row_72_84 : RowResult ⟨72, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_72_83
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_72_85 : RowResult ⟨72, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_72_84
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_72_86 : RowResult ⟨72, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_72_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_72_87 : RowResult ⟨72, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_72_86
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_72_88 : RowResult ⟨72, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_72_87
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_72_89 : RowResult ⟨72, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_72_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 2 4 7)

theorem row_72_90 : RowResult ⟨72, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_72_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 2 5 6)

theorem row_72_91 : RowResult ⟨72, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_72_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 2 5 7)

theorem row_72_92 : RowResult ⟨72, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_72_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 4 5 6)

theorem row_72_93 : RowResult ⟨72, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_72_92
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
