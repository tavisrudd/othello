import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_98_99 : RowResult ⟨98, by decide⟩ ⟨99, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 0 4 6)

theorem row_98_100 : RowResult ⟨98, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_98_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_98_101 : RowResult ⟨98, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_98_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_98_102 : RowResult ⟨98, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_98_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_98_103 : RowResult ⟨98, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_98_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_98_104 : RowResult ⟨98, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_98_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_98_105 : RowResult ⟨98, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_98_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_98_106 : RowResult ⟨98, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_98_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 2 4 6)

theorem row_98_107 : RowResult ⟨98, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_98_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_98_108 : RowResult ⟨98, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_98_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 1 4 7)

theorem row_98_109 : RowResult ⟨98, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_98_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_98_110 : RowResult ⟨98, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_98_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 4 5 6)

theorem row_98_111 : RowResult ⟨98, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_98_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_98_112 : RowResult ⟨98, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_98_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 2 5 6)

theorem row_98_113 : RowResult ⟨98, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_98_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_98_114 : RowResult ⟨98, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_98_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_98_115 : RowResult ⟨98, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_98_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_98_116 : RowResult ⟨98, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_98_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
