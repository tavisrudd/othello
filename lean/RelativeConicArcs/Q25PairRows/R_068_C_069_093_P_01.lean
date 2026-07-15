import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_68_69 : RowResult ⟨68, by decide⟩ ⟨69, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨69, by decide⟩) 0 4 6)

theorem row_68_70 : RowResult ⟨68, by decide⟩ ⟨70, by decide⟩ := by
  have _previous := row_68_69
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨70, by decide⟩) 0 4 6)

theorem row_68_71 : RowResult ⟨68, by decide⟩ ⟨71, by decide⟩ := by
  have _previous := row_68_70
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) 0 4 6)

theorem row_68_72 : RowResult ⟨68, by decide⟩ ⟨72, by decide⟩ := by
  have _previous := row_68_71
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) 0 4 6)

theorem row_68_73 : RowResult ⟨68, by decide⟩ ⟨73, by decide⟩ := by
  have _previous := row_68_72
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) 0 4 6)

theorem row_68_74 : RowResult ⟨68, by decide⟩ ⟨74, by decide⟩ := by
  have _previous := row_68_73
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) 0 4 6)

theorem row_68_75 : RowResult ⟨68, by decide⟩ ⟨75, by decide⟩ := by
  have _previous := row_68_74
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨75, by decide⟩) 1 6 7)

theorem row_68_76 : RowResult ⟨68, by decide⟩ ⟨76, by decide⟩ := by
  have _previous := row_68_75
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨76, by decide⟩) 1 6 7)

theorem row_68_77 : RowResult ⟨68, by decide⟩ ⟨77, by decide⟩ := by
  have _previous := row_68_76
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨77, by decide⟩) 1 6 7)

theorem row_68_78 : RowResult ⟨68, by decide⟩ ⟨78, by decide⟩ := by
  have _previous := row_68_77
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨78, by decide⟩) 1 6 7)

theorem row_68_79 : RowResult ⟨68, by decide⟩ ⟨79, by decide⟩ := by
  have _previous := row_68_78
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨79, by decide⟩) 1 6 7)

theorem row_68_80 : RowResult ⟨68, by decide⟩ ⟨80, by decide⟩ := by
  have _previous := row_68_79
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨80, by decide⟩) 1 2 6)

theorem row_68_81 : RowResult ⟨68, by decide⟩ ⟨81, by decide⟩ := by
  have _previous := row_68_80
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) 2 4 7)

theorem row_68_82 : RowResult ⟨68, by decide⟩ ⟨82, by decide⟩ := by
  have _previous := row_68_81
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 2 4 6)

theorem row_68_83 : RowResult ⟨68, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_68_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 4 5 6)

theorem row_68_84 : RowResult ⟨68, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_68_83
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_68_85 : RowResult ⟨68, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_68_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 2 5 7)

theorem row_68_86 : RowResult ⟨68, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_68_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 2 3 6)

theorem row_68_87 : RowResult ⟨68, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_68_86
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_68_88 : RowResult ⟨68, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_68_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 1 4 7)

theorem row_68_89 : RowResult ⟨68, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_68_88
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_68_90 : RowResult ⟨68, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_68_89
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_68_91 : RowResult ⟨68, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_68_90
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_68_92 : RowResult ⟨68, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_68_91
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_68_93 : RowResult ⟨68, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_68_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
