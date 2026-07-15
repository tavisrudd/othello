import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_113_114 : RowResult ⟨113, by decide⟩ ⟨114, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 0 4 6)

theorem row_113_115 : RowResult ⟨113, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_113_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 0 4 6)

theorem row_113_116 : RowResult ⟨113, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_113_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 0 4 6)

theorem row_113_117 : RowResult ⟨113, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_113_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 0 4 6)

theorem row_113_118 : RowResult ⟨113, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_113_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 0 4 6)

theorem row_113_119 : RowResult ⟨113, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_113_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 0 4 6)

theorem row_113_120 : RowResult ⟨113, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_113_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 0 4 6)

theorem row_113_121 : RowResult ⟨113, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_113_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 0 4 6)

theorem row_113_122 : RowResult ⟨113, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_113_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 0 4 6)

theorem row_113_123 : RowResult ⟨113, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_113_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 0 4 6)

theorem row_113_124 : RowResult ⟨113, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_113_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 0 4 6)

theorem row_113_125 : RowResult ⟨113, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_113_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_113_126 : RowResult ⟨113, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_113_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_113_127 : RowResult ⟨113, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_113_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_113_128 : RowResult ⟨113, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_113_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_113_129 : RowResult ⟨113, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_113_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_113_130 : RowResult ⟨113, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_113_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_113_131 : RowResult ⟨113, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_113_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_113_132 : RowResult ⟨113, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_113_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_113_133 : RowResult ⟨113, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_113_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 2 5 7)

theorem row_113_134 : RowResult ⟨113, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_113_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 2 4 6)

theorem row_113_135 : RowResult ⟨113, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_113_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_113_136 : RowResult ⟨113, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_113_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_113_137 : RowResult ⟨113, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_113_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_113_138 : RowResult ⟨113, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_113_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 1 4 6)

theorem row_113_139 : RowResult ⟨113, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_113_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_113_140 : RowResult ⟨113, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_113_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
