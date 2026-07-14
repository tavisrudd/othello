import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_88_89 : RowResult ⟨88, by decide⟩ ⟨89, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) 0 4 6)

theorem row_88_90 : RowResult ⟨88, by decide⟩ ⟨90, by decide⟩ := by
  have _previous := row_88_89
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) 0 4 6)

theorem row_88_91 : RowResult ⟨88, by decide⟩ ⟨91, by decide⟩ := by
  have _previous := row_88_90
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 0 4 6)

theorem row_88_92 : RowResult ⟨88, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_88_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 0 4 6)

theorem row_88_93 : RowResult ⟨88, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_88_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 0 4 6)

theorem row_88_94 : RowResult ⟨88, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_88_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 0 4 6)

theorem row_88_95 : RowResult ⟨88, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_88_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 0 4 6)

theorem row_88_96 : RowResult ⟨88, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_88_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 0 4 6)

theorem row_88_97 : RowResult ⟨88, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_88_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 0 4 6)

theorem row_88_98 : RowResult ⟨88, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_88_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 0 4 6)

theorem row_88_99 : RowResult ⟨88, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_88_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 0 4 6)

theorem row_88_100 : RowResult ⟨88, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_88_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_88_101 : RowResult ⟨88, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_88_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_88_102 : RowResult ⟨88, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_88_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_88_103 : RowResult ⟨88, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_88_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_88_104 : RowResult ⟨88, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_88_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_88_105 : RowResult ⟨88, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_88_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_88_106 : RowResult ⟨88, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_88_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_88_107 : RowResult ⟨88, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_88_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_88_108 : RowResult ⟨88, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_88_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_88_109 : RowResult ⟨88, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_88_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 4 5 6)

theorem row_88_110 : RowResult ⟨88, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_88_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_88_111 : RowResult ⟨88, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_88_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_88_112 : RowResult ⟨88, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_88_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_88_113 : RowResult ⟨88, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_88_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 1 4 6)

theorem row_88_114 : RowResult ⟨88, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_88_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_88_115 : RowResult ⟨88, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_88_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
