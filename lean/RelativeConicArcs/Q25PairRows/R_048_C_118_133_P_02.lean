import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_48_118 : RowResult ⟨48, by decide⟩ ⟨118, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_48_119 : RowResult ⟨48, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_48_118
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_48_120 : RowResult ⟨48, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_48_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_48_121 : RowResult ⟨48, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_48_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 2 4 6)

theorem row_48_122 : RowResult ⟨48, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_48_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_48_123 : RowResult ⟨48, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_48_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 1 4 6)

theorem row_48_124 : RowResult ⟨48, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_48_123
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_48_125 : RowResult ⟨48, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_48_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_48_126 : RowResult ⟨48, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_48_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_48_127 : RowResult ⟨48, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_48_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_48_128 : RowResult ⟨48, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_48_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_48_129 : RowResult ⟨48, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_48_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_48_130 : RowResult ⟨48, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_48_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_48_131 : RowResult ⟨48, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_48_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_48_132 : RowResult ⟨48, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_48_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_48_133 : RowResult ⟨48, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_48_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨48, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
