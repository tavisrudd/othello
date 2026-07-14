import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_93_94 : RowResult ⟨93, by decide⟩ ⟨94, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 0 4 6)

theorem row_93_95 : RowResult ⟨93, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_93_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 0 4 6)

theorem row_93_96 : RowResult ⟨93, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_93_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 0 4 6)

theorem row_93_97 : RowResult ⟨93, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_93_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 0 4 6)

theorem row_93_98 : RowResult ⟨93, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_93_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 0 4 6)

theorem row_93_99 : RowResult ⟨93, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_93_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 0 4 6)

theorem row_93_100 : RowResult ⟨93, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_93_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_93_101 : RowResult ⟨93, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_93_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_93_102 : RowResult ⟨93, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_93_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_93_103 : RowResult ⟨93, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_93_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_93_104 : RowResult ⟨93, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_93_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_93_105 : RowResult ⟨93, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_93_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_93_106 : RowResult ⟨93, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_93_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 2 5 6)

theorem row_93_107 : RowResult ⟨93, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_93_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_93_108 : RowResult ⟨93, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_93_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_93_109 : RowResult ⟨93, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_93_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_93_110 : RowResult ⟨93, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_93_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_93_111 : RowResult ⟨93, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_93_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_93_112 : RowResult ⟨93, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_93_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_93_113 : RowResult ⟨93, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_93_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 1 4 7)

theorem row_93_114 : RowResult ⟨93, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_93_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
