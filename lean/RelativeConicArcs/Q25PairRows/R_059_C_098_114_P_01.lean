import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_59_98 : RowResult ⟨59, by decide⟩ ⟨98, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_59_99 : RowResult ⟨59, by decide⟩ ⟨99, by decide⟩ := by
  have _previous := row_59_98
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) 1 4 7)

theorem row_59_100 : RowResult ⟨59, by decide⟩ ⟨100, by decide⟩ := by
  have _previous := row_59_99
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨100, by decide⟩) 1 6 7)

theorem row_59_101 : RowResult ⟨59, by decide⟩ ⟨101, by decide⟩ := by
  have _previous := row_59_100
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨101, by decide⟩) 1 6 7)

theorem row_59_102 : RowResult ⟨59, by decide⟩ ⟨102, by decide⟩ := by
  have _previous := row_59_101
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨102, by decide⟩) 1 6 7)

theorem row_59_103 : RowResult ⟨59, by decide⟩ ⟨103, by decide⟩ := by
  have _previous := row_59_102
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨103, by decide⟩) 1 6 7)

theorem row_59_104 : RowResult ⟨59, by decide⟩ ⟨104, by decide⟩ := by
  have _previous := row_59_103
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨104, by decide⟩) 1 6 7)

theorem row_59_105 : RowResult ⟨59, by decide⟩ ⟨105, by decide⟩ := by
  have _previous := row_59_104
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨105, by decide⟩) 1 2 6)

theorem row_59_106 : RowResult ⟨59, by decide⟩ ⟨106, by decide⟩ := by
  have _previous := row_59_105
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_59_107 : RowResult ⟨59, by decide⟩ ⟨107, by decide⟩ := by
  have _previous := row_59_106
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨107, by decide⟩) 2 3 6)

theorem row_59_108 : RowResult ⟨59, by decide⟩ ⟨108, by decide⟩ := by
  have _previous := row_59_107
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨108, by decide⟩) 2 4 6)

theorem row_59_109 : RowResult ⟨59, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_59_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 1 4 6)

theorem row_59_110 : RowResult ⟨59, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_59_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_59_111 : RowResult ⟨59, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_59_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_59_112 : RowResult ⟨59, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_59_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_59_113 : RowResult ⟨59, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_59_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 2 4 7)

theorem row_59_114 : RowResult ⟨59, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_59_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
