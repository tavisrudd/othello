import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_99_116 : RowResult ⟨99, by decide⟩ ⟨116, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_99_117 : RowResult ⟨99, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_99_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_99_118 : RowResult ⟨99, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_99_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_99_119 : RowResult ⟨99, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_99_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 2 4 6)

theorem row_99_120 : RowResult ⟨99, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_99_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_99_121 : RowResult ⟨99, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_99_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 2 5 6)

theorem row_99_122 : RowResult ⟨99, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_99_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_99_123 : RowResult ⟨99, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_99_122
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_99_124 : RowResult ⟨99, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_99_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 1 4 6)

theorem row_99_125 : RowResult ⟨99, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_99_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_99_126 : RowResult ⟨99, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_99_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_99_127 : RowResult ⟨99, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_99_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_99_128 : RowResult ⟨99, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_99_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_99_129 : RowResult ⟨99, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_99_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_99_130 : RowResult ⟨99, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_99_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨99, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_99_131 : RowResult ⟨99, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_99_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨167, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
