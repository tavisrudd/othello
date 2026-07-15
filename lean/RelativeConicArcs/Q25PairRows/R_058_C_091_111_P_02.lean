import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_58_91 : RowResult ⟨58, by decide⟩ ⟨91, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_58_92 : RowResult ⟨58, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_58_91
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_58_93 : RowResult ⟨58, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_58_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 2 4 7)

theorem row_58_94 : RowResult ⟨58, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_58_93
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_58_95 : RowResult ⟨58, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_58_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_58_96 : RowResult ⟨58, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_58_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 2 5 6)

theorem row_58_97 : RowResult ⟨58, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_58_96
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_58_98 : RowResult ⟨58, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_58_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 1 4 7)

theorem row_58_99 : RowResult ⟨58, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_58_98
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_58_100 : RowResult ⟨58, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_58_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_58_101 : RowResult ⟨58, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_58_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_58_102 : RowResult ⟨58, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_58_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_58_103 : RowResult ⟨58, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_58_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_58_104 : RowResult ⟨58, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_58_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_58_105 : RowResult ⟨58, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_58_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_58_106 : RowResult ⟨58, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_58_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 2 4 6)

theorem row_58_107 : RowResult ⟨58, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_58_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_58_108 : RowResult ⟨58, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_58_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 1 4 6)

theorem row_58_109 : RowResult ⟨58, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_58_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 4 5 6)

theorem row_58_110 : RowResult ⟨58, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_58_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 2 5 6)

theorem row_58_111 : RowResult ⟨58, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_58_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
