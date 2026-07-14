import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_72_94 : RowResult ⟨72, by decide⟩ ⟨94, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_72_95 : RowResult ⟨72, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_72_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_72_96 : RowResult ⟨72, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_72_95
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_72_97 : RowResult ⟨72, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_72_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 1 4 6)

theorem row_72_98 : RowResult ⟨72, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_72_97
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_72_99 : RowResult ⟨72, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_72_98
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_72_100 : RowResult ⟨72, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_72_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_72_101 : RowResult ⟨72, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_72_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_72_102 : RowResult ⟨72, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_72_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_72_103 : RowResult ⟨72, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_72_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_72_104 : RowResult ⟨72, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_72_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_72_105 : RowResult ⟨72, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_72_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_72_106 : RowResult ⟨72, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_72_105
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨106, by decide⟩) 2 5 7)

theorem row_72_107 : RowResult ⟨72, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_72_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 1 4 7)

theorem row_72_108 : RowResult ⟨72, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_72_107
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_72_109 : RowResult ⟨72, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_72_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
