import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_91_92 : RowResult ⟨91, by decide⟩ ⟨92, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 0 4 6)

theorem row_91_93 : RowResult ⟨91, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_91_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 0 4 6)

theorem row_91_94 : RowResult ⟨91, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_91_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 0 4 6)

theorem row_91_95 : RowResult ⟨91, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_91_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 0 4 6)

theorem row_91_96 : RowResult ⟨91, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_91_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 0 4 6)

theorem row_91_97 : RowResult ⟨91, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_91_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 0 4 6)

theorem row_91_98 : RowResult ⟨91, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_91_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 0 4 6)

theorem row_91_99 : RowResult ⟨91, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_91_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 0 4 6)

theorem row_91_100 : RowResult ⟨91, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_91_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_91_101 : RowResult ⟨91, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_91_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_91_102 : RowResult ⟨91, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_91_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_91_103 : RowResult ⟨91, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_91_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_91_104 : RowResult ⟨91, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_91_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_91_105 : RowResult ⟨91, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_91_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_91_106 : RowResult ⟨91, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_91_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 2 5 7)

theorem row_91_107 : RowResult ⟨91, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_91_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_91_108 : RowResult ⟨91, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_91_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_91_109 : RowResult ⟨91, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_91_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_91_110 : RowResult ⟨91, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_91_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 2 4 7)

theorem row_91_111 : RowResult ⟨91, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_91_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 1 4 7)

theorem row_91_112 : RowResult ⟨91, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_91_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_91_113 : RowResult ⟨91, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_91_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 2 5 6)

theorem row_91_114 : RowResult ⟨91, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_91_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_91_115 : RowResult ⟨91, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_91_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_91_116 : RowResult ⟨91, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_91_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 1 4 6)

theorem row_91_117 : RowResult ⟨91, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_91_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
