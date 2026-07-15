import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_40_91 : RowResult ⟨40, by decide⟩ ⟨91, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_40_92 : RowResult ⟨40, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_40_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 2 4 6)

theorem row_40_93 : RowResult ⟨40, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_40_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 2 5 7)

theorem row_40_94 : RowResult ⟨40, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_40_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 4 5 6)

theorem row_40_95 : RowResult ⟨40, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_40_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_40_96 : RowResult ⟨40, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_40_95
  exact Or.inr ⟨orbitCodeOfNumber ⟨64, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_40_97 : RowResult ⟨40, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_40_96
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_40_98 : RowResult ⟨40, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_40_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 2 5 6)

theorem row_40_99 : RowResult ⟨40, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_40_98
  exact Or.inr ⟨orbitCodeOfNumber ⟨66, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_40_100 : RowResult ⟨40, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_40_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_40_101 : RowResult ⟨40, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_40_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_40_102 : RowResult ⟨40, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_40_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_40_103 : RowResult ⟨40, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_40_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_40_104 : RowResult ⟨40, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_40_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_40_105 : RowResult ⟨40, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_40_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_40_106 : RowResult ⟨40, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_40_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 2 5 6)

theorem row_40_107 : RowResult ⟨40, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_40_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_40_108 : RowResult ⟨40, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_40_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_40_109 : RowResult ⟨40, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_40_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 2 4 6)

theorem row_40_110 : RowResult ⟨40, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_40_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 1 4 7)

theorem row_40_111 : RowResult ⟨40, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_40_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
