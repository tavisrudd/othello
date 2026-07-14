import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_117_118 : RowResult ⟨117, by decide⟩ ⟨118, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 0 4 6)

theorem row_117_119 : RowResult ⟨117, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_117_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 0 4 6)

theorem row_117_120 : RowResult ⟨117, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_117_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 0 4 6)

theorem row_117_121 : RowResult ⟨117, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_117_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 0 4 6)

theorem row_117_122 : RowResult ⟨117, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_117_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 0 4 6)

theorem row_117_123 : RowResult ⟨117, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_117_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 0 4 6)

theorem row_117_124 : RowResult ⟨117, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_117_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 0 4 6)

theorem row_117_125 : RowResult ⟨117, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_117_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_117_126 : RowResult ⟨117, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_117_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_117_127 : RowResult ⟨117, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_117_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_117_128 : RowResult ⟨117, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_117_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_117_129 : RowResult ⟨117, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_117_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_117_130 : RowResult ⟨117, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_117_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_117_131 : RowResult ⟨117, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_117_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_117_132 : RowResult ⟨117, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_117_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 4 5 6)

theorem row_117_133 : RowResult ⟨117, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_117_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 2 5 6)

theorem row_117_134 : RowResult ⟨117, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_117_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_117_135 : RowResult ⟨117, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_117_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_117_136 : RowResult ⟨117, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_117_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_117_137 : RowResult ⟨117, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_117_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 1 4 7)

theorem row_117_138 : RowResult ⟨117, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_117_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_117_139 : RowResult ⟨117, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_117_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
