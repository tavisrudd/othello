import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_72_119 : RowResult ⟨72, by decide⟩ ⟨119, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_72_120 : RowResult ⟨72, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_72_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_72_121 : RowResult ⟨72, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_72_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 4 5 6)

theorem row_72_122 : RowResult ⟨72, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_72_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 1 4 6)

theorem row_72_123 : RowResult ⟨72, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_72_122
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_72_124 : RowResult ⟨72, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_72_123
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_72_125 : RowResult ⟨72, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_72_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_72_126 : RowResult ⟨72, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_72_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_72_127 : RowResult ⟨72, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_72_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_72_128 : RowResult ⟨72, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_72_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_72_129 : RowResult ⟨72, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_72_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_72_130 : RowResult ⟨72, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_72_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_72_131 : RowResult ⟨72, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_72_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_72_132 : RowResult ⟨72, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_72_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 1 4 7)

theorem row_72_133 : RowResult ⟨72, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_72_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_72_134 : RowResult ⟨72, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_72_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 2 5 6)

theorem row_72_135 : RowResult ⟨72, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_72_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
