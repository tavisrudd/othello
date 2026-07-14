import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_65_93 : RowResult ⟨65, by decide⟩ ⟨93, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_65_94 : RowResult ⟨65, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_65_93
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨94, by decide⟩) 2 4 6)

theorem row_65_95 : RowResult ⟨65, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_65_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_65_96 : RowResult ⟨65, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_65_95
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_65_97 : RowResult ⟨65, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_65_96
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_65_98 : RowResult ⟨65, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_65_97
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_65_99 : RowResult ⟨65, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_65_98
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_65_100 : RowResult ⟨65, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_65_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_65_101 : RowResult ⟨65, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_65_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_65_102 : RowResult ⟨65, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_65_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_65_103 : RowResult ⟨65, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_65_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_65_104 : RowResult ⟨65, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_65_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_65_105 : RowResult ⟨65, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_65_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_65_106 : RowResult ⟨65, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_65_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_65_107 : RowResult ⟨65, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_65_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_65_108 : RowResult ⟨65, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_65_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
