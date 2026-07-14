import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_90_91 : RowResult ⟨90, by decide⟩ ⟨91, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨91, by decide⟩) 0 4 6)

theorem row_90_92 : RowResult ⟨90, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_90_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 0 4 6)

theorem row_90_93 : RowResult ⟨90, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_90_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 0 4 6)

theorem row_90_94 : RowResult ⟨90, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_90_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 0 4 6)

theorem row_90_95 : RowResult ⟨90, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_90_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 0 4 6)

theorem row_90_96 : RowResult ⟨90, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_90_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 0 4 6)

theorem row_90_97 : RowResult ⟨90, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_90_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 0 4 6)

theorem row_90_98 : RowResult ⟨90, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_90_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 0 4 6)

theorem row_90_99 : RowResult ⟨90, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_90_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 0 4 6)

theorem row_90_100 : RowResult ⟨90, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_90_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_90_101 : RowResult ⟨90, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_90_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_90_102 : RowResult ⟨90, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_90_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_90_103 : RowResult ⟨90, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_90_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_90_104 : RowResult ⟨90, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_90_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_90_105 : RowResult ⟨90, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_90_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_90_106 : RowResult ⟨90, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_90_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 2 4 7)

theorem row_90_107 : RowResult ⟨90, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_90_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_90_108 : RowResult ⟨90, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_90_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_90_109 : RowResult ⟨90, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_90_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_90_110 : RowResult ⟨90, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_90_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 1 4 7)

theorem row_90_111 : RowResult ⟨90, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_90_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_90_112 : RowResult ⟨90, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_90_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_90_113 : RowResult ⟨90, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_90_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 2 4 6)

theorem row_90_114 : RowResult ⟨90, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_90_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_90_115 : RowResult ⟨90, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_90_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 1 4 6)

theorem row_90_116 : RowResult ⟨90, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_90_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
