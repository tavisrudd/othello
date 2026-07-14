import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_118_119 : RowResult ⟨118, by decide⟩ ⟨119, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 0 4 6)

theorem row_118_120 : RowResult ⟨118, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_118_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 0 4 6)

theorem row_118_121 : RowResult ⟨118, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_118_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 0 4 6)

theorem row_118_122 : RowResult ⟨118, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_118_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 0 4 6)

theorem row_118_123 : RowResult ⟨118, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_118_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 0 4 6)

theorem row_118_124 : RowResult ⟨118, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_118_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 0 4 6)

theorem row_118_125 : RowResult ⟨118, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_118_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_118_126 : RowResult ⟨118, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_118_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_118_127 : RowResult ⟨118, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_118_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_118_128 : RowResult ⟨118, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_118_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_118_129 : RowResult ⟨118, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_118_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_118_130 : RowResult ⟨118, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_118_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_118_131 : RowResult ⟨118, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_118_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_118_132 : RowResult ⟨118, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_118_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_118_133 : RowResult ⟨118, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_118_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 4 5 6)

theorem row_118_134 : RowResult ⟨118, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_118_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_118_135 : RowResult ⟨118, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_118_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 2 4 6)

theorem row_118_136 : RowResult ⟨118, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_118_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 2 5 6)

theorem row_118_137 : RowResult ⟨118, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_118_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_118_138 : RowResult ⟨118, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_118_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 1 4 7)

theorem row_118_139 : RowResult ⟨118, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_118_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_118_140 : RowResult ⟨118, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_118_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_118_141 : RowResult ⟨118, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_118_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_118_142 : RowResult ⟨118, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_118_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 2 5 7)

theorem row_118_143 : RowResult ⟨118, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_118_142
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨143, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
