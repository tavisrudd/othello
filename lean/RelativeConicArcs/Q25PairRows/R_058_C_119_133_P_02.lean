import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_58_119 : RowResult ⟨58, by decide⟩ ⟨119, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_58_120 : RowResult ⟨58, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_58_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_58_121 : RowResult ⟨58, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_58_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨235, by decide⟩, by decide⟩

theorem row_58_122 : RowResult ⟨58, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_58_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_58_123 : RowResult ⟨58, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_58_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 1 4 7)

theorem row_58_124 : RowResult ⟨58, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_58_123
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_58_125 : RowResult ⟨58, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_58_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_58_126 : RowResult ⟨58, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_58_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_58_127 : RowResult ⟨58, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_58_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_58_128 : RowResult ⟨58, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_58_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_58_129 : RowResult ⟨58, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_58_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_58_130 : RowResult ⟨58, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_58_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_58_131 : RowResult ⟨58, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_58_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_58_132 : RowResult ⟨58, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_58_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_58_133 : RowResult ⟨58, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_58_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
