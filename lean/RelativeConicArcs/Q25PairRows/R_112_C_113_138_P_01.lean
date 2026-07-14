import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_112_113 : RowResult ⟨112, by decide⟩ ⟨113, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 0 4 6)

theorem row_112_114 : RowResult ⟨112, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_112_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 0 4 6)

theorem row_112_115 : RowResult ⟨112, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_112_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 0 4 6)

theorem row_112_116 : RowResult ⟨112, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_112_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 0 4 6)

theorem row_112_117 : RowResult ⟨112, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_112_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 0 4 6)

theorem row_112_118 : RowResult ⟨112, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_112_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 0 4 6)

theorem row_112_119 : RowResult ⟨112, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_112_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 0 4 6)

theorem row_112_120 : RowResult ⟨112, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_112_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 0 4 6)

theorem row_112_121 : RowResult ⟨112, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_112_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 0 4 6)

theorem row_112_122 : RowResult ⟨112, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_112_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 0 4 6)

theorem row_112_123 : RowResult ⟨112, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_112_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 0 4 6)

theorem row_112_124 : RowResult ⟨112, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_112_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 0 4 6)

theorem row_112_125 : RowResult ⟨112, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_112_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_112_126 : RowResult ⟨112, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_112_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_112_127 : RowResult ⟨112, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_112_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_112_128 : RowResult ⟨112, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_112_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_112_129 : RowResult ⟨112, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_112_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_112_130 : RowResult ⟨112, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_112_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_112_131 : RowResult ⟨112, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_112_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_112_132 : RowResult ⟨112, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_112_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_112_133 : RowResult ⟨112, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_112_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_112_134 : RowResult ⟨112, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_112_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 2 4 7)

theorem row_112_135 : RowResult ⟨112, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_112_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_112_136 : RowResult ⟨112, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_112_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_112_137 : RowResult ⟨112, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_112_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 1 4 6)

theorem row_112_138 : RowResult ⟨112, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_112_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
