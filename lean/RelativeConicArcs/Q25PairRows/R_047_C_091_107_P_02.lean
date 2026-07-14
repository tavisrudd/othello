import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_47_91 : RowResult ⟨47, by decide⟩ ⟨91, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_47_92 : RowResult ⟨47, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_47_91
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_47_93 : RowResult ⟨47, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_47_92
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_47_94 : RowResult ⟨47, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_47_93
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_47_95 : RowResult ⟨47, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_47_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_47_96 : RowResult ⟨47, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_47_95
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) 2 5 6)

theorem row_47_97 : RowResult ⟨47, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_47_96
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) 1 4 6)

theorem row_47_98 : RowResult ⟨47, by decide⟩ ⟨98, by decide⟩ := by
  have _previous := row_47_97
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_47_99 : RowResult ⟨47, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_47_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 4 5 6)

theorem row_47_100 : RowResult ⟨47, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_47_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_47_101 : RowResult ⟨47, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_47_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_47_102 : RowResult ⟨47, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_47_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_47_103 : RowResult ⟨47, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_47_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_47_104 : RowResult ⟨47, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_47_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_47_105 : RowResult ⟨47, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_47_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_47_106 : RowResult ⟨47, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_47_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_47_107 : RowResult ⟨47, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_47_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
