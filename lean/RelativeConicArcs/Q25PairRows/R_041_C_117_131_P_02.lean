import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_41_117 : RowResult ⟨41, by decide⟩ ⟨117, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_41_118 : RowResult ⟨41, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_41_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_41_119 : RowResult ⟨41, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_41_118
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_41_120 : RowResult ⟨41, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_41_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_41_121 : RowResult ⟨41, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_41_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 2 5 6)

theorem row_41_122 : RowResult ⟨41, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_41_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_41_123 : RowResult ⟨41, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_41_122
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_41_124 : RowResult ⟨41, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_41_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 4 5 6)

theorem row_41_125 : RowResult ⟨41, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_41_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_41_126 : RowResult ⟨41, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_41_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_41_127 : RowResult ⟨41, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_41_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_41_128 : RowResult ⟨41, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_41_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_41_129 : RowResult ⟨41, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_41_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_41_130 : RowResult ⟨41, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_41_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨41, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_41_131 : RowResult ⟨41, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_41_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
