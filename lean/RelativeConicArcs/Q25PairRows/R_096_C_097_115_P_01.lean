import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_96_97 : RowResult ⟨96, by decide⟩ ⟨97, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 0 4 6)

theorem row_96_98 : RowResult ⟨96, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_96_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 0 4 6)

theorem row_96_99 : RowResult ⟨96, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_96_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 0 4 6)

theorem row_96_100 : RowResult ⟨96, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_96_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_96_101 : RowResult ⟨96, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_96_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_96_102 : RowResult ⟨96, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_96_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_96_103 : RowResult ⟨96, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_96_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_96_104 : RowResult ⟨96, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_96_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_96_105 : RowResult ⟨96, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_96_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_96_106 : RowResult ⟨96, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_96_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 1 4 7)

theorem row_96_107 : RowResult ⟨96, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_96_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_96_108 : RowResult ⟨96, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_96_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_96_109 : RowResult ⟨96, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_96_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_96_110 : RowResult ⟨96, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_96_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 2 4 6)

theorem row_96_111 : RowResult ⟨96, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_96_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_96_112 : RowResult ⟨96, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_96_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_96_113 : RowResult ⟨96, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_96_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 4 5 6)

theorem row_96_114 : RowResult ⟨96, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_96_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_96_115 : RowResult ⟨96, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_96_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
