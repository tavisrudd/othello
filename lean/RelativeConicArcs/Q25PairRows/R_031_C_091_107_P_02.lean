import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_31_91 : RowResult ⟨31, by decide⟩ ⟨91, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_31_92 : RowResult ⟨31, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_31_91
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_31_93 : RowResult ⟨31, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_31_92
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_31_94 : RowResult ⟨31, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_31_93
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_31_95 : RowResult ⟨31, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_31_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_31_96 : RowResult ⟨31, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_31_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 1 4 7)

theorem row_31_97 : RowResult ⟨31, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_31_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 2 5 6)

theorem row_31_98 : RowResult ⟨31, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_31_97
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_31_99 : RowResult ⟨31, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_31_98
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_31_100 : RowResult ⟨31, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_31_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_31_101 : RowResult ⟨31, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_31_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_31_102 : RowResult ⟨31, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_31_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_31_103 : RowResult ⟨31, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_31_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_31_104 : RowResult ⟨31, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_31_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_31_105 : RowResult ⟨31, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_31_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_31_106 : RowResult ⟨31, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_31_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 1 4 6)

theorem row_31_107 : RowResult ⟨31, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_31_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
