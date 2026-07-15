import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_37_91 : RowResult ⟨37, by decide⟩ ⟨91, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_37_92 : RowResult ⟨37, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_37_91
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨92, by decide⟩) 1 4 7)

theorem row_37_93 : RowResult ⟨37, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_37_92
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) 2 4 6)

theorem row_37_94 : RowResult ⟨37, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_37_93
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_37_95 : RowResult ⟨37, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_37_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_37_96 : RowResult ⟨37, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_37_95
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_37_97 : RowResult ⟨37, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_37_96
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_37_98 : RowResult ⟨37, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_37_97
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) 2 5 7)

theorem row_37_99 : RowResult ⟨37, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_37_98
  exact Or.inr ⟨orbitCodeOfNumber ⟨66, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_37_100 : RowResult ⟨37, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_37_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_37_101 : RowResult ⟨37, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_37_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_37_102 : RowResult ⟨37, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_37_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_37_103 : RowResult ⟨37, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_37_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_37_104 : RowResult ⟨37, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_37_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_37_105 : RowResult ⟨37, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_37_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_37_106 : RowResult ⟨37, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_37_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_37_107 : RowResult ⟨37, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_37_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
