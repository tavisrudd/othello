import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_83_84 : RowResult ⟨83, by decide⟩ ⟨84, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) 0 4 6)

theorem row_83_85 : RowResult ⟨83, by decide⟩ ⟨85, by decide⟩ := by
  have _previous := row_83_84
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) 0 4 6)

theorem row_83_86 : RowResult ⟨83, by decide⟩ ⟨86, by decide⟩ := by
  have _previous := row_83_85
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨86, by decide⟩) 0 4 6)

theorem row_83_87 : RowResult ⟨83, by decide⟩ ⟨87, by decide⟩ := by
  have _previous := row_83_86
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) 0 4 6)

theorem row_83_88 : RowResult ⟨83, by decide⟩ ⟨88, by decide⟩ := by
  have _previous := row_83_87
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) 0 4 6)

theorem row_83_89 : RowResult ⟨83, by decide⟩ ⟨89, by decide⟩ := by
  have _previous := row_83_88
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 0 4 6)

theorem row_83_90 : RowResult ⟨83, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_83_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 0 4 6)

theorem row_83_91 : RowResult ⟨83, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_83_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 0 4 6)

theorem row_83_92 : RowResult ⟨83, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_83_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 0 4 6)

theorem row_83_93 : RowResult ⟨83, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_83_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 0 4 6)

theorem row_83_94 : RowResult ⟨83, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_83_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 0 4 6)

theorem row_83_95 : RowResult ⟨83, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_83_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 0 4 6)

theorem row_83_96 : RowResult ⟨83, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_83_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 0 4 6)

theorem row_83_97 : RowResult ⟨83, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_83_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 0 4 6)

theorem row_83_98 : RowResult ⟨83, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_83_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 0 4 6)

theorem row_83_99 : RowResult ⟨83, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_83_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 0 4 6)

theorem row_83_100 : RowResult ⟨83, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_83_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_83_101 : RowResult ⟨83, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_83_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_83_102 : RowResult ⟨83, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_83_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_83_103 : RowResult ⟨83, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_83_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_83_104 : RowResult ⟨83, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_83_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_83_105 : RowResult ⟨83, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_83_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_83_106 : RowResult ⟨83, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_83_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_83_107 : RowResult ⟨83, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_83_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_83_108 : RowResult ⟨83, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_83_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 1 4 6)

theorem row_83_109 : RowResult ⟨83, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_83_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_83_110 : RowResult ⟨83, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_83_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_83_111 : RowResult ⟨83, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_83_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_83_112 : RowResult ⟨83, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_83_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 2 4 7)

theorem row_83_113 : RowResult ⟨83, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_83_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_83_114 : RowResult ⟨83, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_83_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 2 4 6)

theorem row_83_115 : RowResult ⟨83, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_83_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_83_116 : RowResult ⟨83, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_83_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
