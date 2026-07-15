import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_81_82 : RowResult ⟨81, by decide⟩ ⟨82, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨82, by decide⟩) 0 4 6)

theorem row_81_83 : RowResult ⟨81, by decide⟩ ⟨83, by decide⟩ := by
  have _previous := row_81_82
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) 0 4 6)

theorem row_81_84 : RowResult ⟨81, by decide⟩ ⟨84, by decide⟩ := by
  have _previous := row_81_83
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 0 4 6)

theorem row_81_85 : RowResult ⟨81, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_81_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 0 4 6)

theorem row_81_86 : RowResult ⟨81, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_81_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 0 4 6)

theorem row_81_87 : RowResult ⟨81, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_81_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 0 4 6)

theorem row_81_88 : RowResult ⟨81, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_81_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 0 4 6)

theorem row_81_89 : RowResult ⟨81, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_81_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 0 4 6)

theorem row_81_90 : RowResult ⟨81, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_81_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 0 4 6)

theorem row_81_91 : RowResult ⟨81, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_81_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 0 4 6)

theorem row_81_92 : RowResult ⟨81, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_81_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 0 4 6)

theorem row_81_93 : RowResult ⟨81, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_81_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 0 4 6)

theorem row_81_94 : RowResult ⟨81, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_81_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 0 4 6)

theorem row_81_95 : RowResult ⟨81, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_81_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 0 4 6)

theorem row_81_96 : RowResult ⟨81, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_81_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 0 4 6)

theorem row_81_97 : RowResult ⟨81, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_81_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 0 4 6)

theorem row_81_98 : RowResult ⟨81, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_81_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 0 4 6)

theorem row_81_99 : RowResult ⟨81, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_81_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 0 4 6)

theorem row_81_100 : RowResult ⟨81, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_81_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_81_101 : RowResult ⟨81, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_81_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_81_102 : RowResult ⟨81, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_81_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_81_103 : RowResult ⟨81, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_81_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_81_104 : RowResult ⟨81, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_81_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_81_105 : RowResult ⟨81, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_81_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_81_106 : RowResult ⟨81, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_81_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 1 4 6)

theorem row_81_107 : RowResult ⟨81, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_81_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_81_108 : RowResult ⟨81, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_81_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 2 5 7)

theorem row_81_109 : RowResult ⟨81, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_81_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_81_110 : RowResult ⟨81, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_81_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_81_111 : RowResult ⟨81, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_81_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_81_112 : RowResult ⟨81, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_81_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_81_113 : RowResult ⟨81, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_81_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_81_114 : RowResult ⟨81, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_81_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
