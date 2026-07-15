import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_87_88 : RowResult ⟨87, by decide⟩ ⟨88, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 0 4 6)

theorem row_87_89 : RowResult ⟨87, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_87_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 0 4 6)

theorem row_87_90 : RowResult ⟨87, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_87_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 0 4 6)

theorem row_87_91 : RowResult ⟨87, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_87_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 0 4 6)

theorem row_87_92 : RowResult ⟨87, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_87_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 0 4 6)

theorem row_87_93 : RowResult ⟨87, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_87_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 0 4 6)

theorem row_87_94 : RowResult ⟨87, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_87_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 0 4 6)

theorem row_87_95 : RowResult ⟨87, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_87_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 0 4 6)

theorem row_87_96 : RowResult ⟨87, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_87_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 0 4 6)

theorem row_87_97 : RowResult ⟨87, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_87_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 0 4 6)

theorem row_87_98 : RowResult ⟨87, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_87_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 0 4 6)

theorem row_87_99 : RowResult ⟨87, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_87_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 0 4 6)

theorem row_87_100 : RowResult ⟨87, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_87_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_87_101 : RowResult ⟨87, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_87_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_87_102 : RowResult ⟨87, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_87_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_87_103 : RowResult ⟨87, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_87_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_87_104 : RowResult ⟨87, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_87_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_87_105 : RowResult ⟨87, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_87_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_87_106 : RowResult ⟨87, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_87_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_87_107 : RowResult ⟨87, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_87_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_87_108 : RowResult ⟨87, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_87_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 4 5 6)

theorem row_87_109 : RowResult ⟨87, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_87_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_87_110 : RowResult ⟨87, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_87_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_87_111 : RowResult ⟨87, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_87_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 2 4 7)

theorem row_87_112 : RowResult ⟨87, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_87_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 1 4 6)

theorem row_87_113 : RowResult ⟨87, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_87_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨241, by decide⟩, by decide⟩

theorem row_87_114 : RowResult ⟨87, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_87_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_87_115 : RowResult ⟨87, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_87_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 2 4 6)

theorem row_87_116 : RowResult ⟨87, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_87_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 2 5 6)

theorem row_87_117 : RowResult ⟨87, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_87_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 1 4 7)

theorem row_87_118 : RowResult ⟨87, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_87_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
