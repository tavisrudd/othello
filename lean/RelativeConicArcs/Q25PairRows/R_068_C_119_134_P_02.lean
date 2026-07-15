import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_68_119 : RowResult ⟨68, by decide⟩ ⟨119, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_68_120 : RowResult ⟨68, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_68_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_68_121 : RowResult ⟨68, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_68_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_68_122 : RowResult ⟨68, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_68_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 2 5 7)

theorem row_68_123 : RowResult ⟨68, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_68_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 2 5 6)

theorem row_68_124 : RowResult ⟨68, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_68_123
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_68_125 : RowResult ⟨68, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_68_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_68_126 : RowResult ⟨68, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_68_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_68_127 : RowResult ⟨68, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_68_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_68_128 : RowResult ⟨68, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_68_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_68_129 : RowResult ⟨68, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_68_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_68_130 : RowResult ⟨68, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_68_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_68_131 : RowResult ⟨68, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_68_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 4 5 6)

theorem row_68_132 : RowResult ⟨68, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_68_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_68_133 : RowResult ⟨68, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_68_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_68_134 : RowResult ⟨68, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_68_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
