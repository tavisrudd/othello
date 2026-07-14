import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_32_93 : RowResult ⟨32, by decide⟩ ⟨93, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_94 : RowResult ⟨32, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_32_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 2 4 7)

theorem row_32_95 : RowResult ⟨32, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_32_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_32_96 : RowResult ⟨32, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_32_95
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_97 : RowResult ⟨32, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_32_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 1 4 7)

theorem row_32_98 : RowResult ⟨32, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_32_97
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_99 : RowResult ⟨32, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_32_98
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_32_100 : RowResult ⟨32, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_32_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_32_101 : RowResult ⟨32, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_32_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_32_102 : RowResult ⟨32, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_32_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_32_103 : RowResult ⟨32, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_32_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_32_104 : RowResult ⟨32, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_32_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_32_105 : RowResult ⟨32, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_32_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_32_106 : RowResult ⟨32, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_32_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 2 5 7)

theorem row_32_107 : RowResult ⟨32, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_32_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 1 4 6)

theorem row_32_108 : RowResult ⟨32, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_32_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_32_109 : RowResult ⟨32, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_32_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
