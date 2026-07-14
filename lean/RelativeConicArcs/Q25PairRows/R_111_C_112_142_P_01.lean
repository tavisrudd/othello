import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_111_112 : RowResult ⟨111, by decide⟩ ⟨112, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 0 4 6)

theorem row_111_113 : RowResult ⟨111, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_111_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 0 4 6)

theorem row_111_114 : RowResult ⟨111, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_111_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 0 4 6)

theorem row_111_115 : RowResult ⟨111, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_111_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 0 4 6)

theorem row_111_116 : RowResult ⟨111, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_111_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 0 4 6)

theorem row_111_117 : RowResult ⟨111, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_111_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 0 4 6)

theorem row_111_118 : RowResult ⟨111, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_111_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 0 4 6)

theorem row_111_119 : RowResult ⟨111, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_111_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 0 4 6)

theorem row_111_120 : RowResult ⟨111, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_111_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 0 4 6)

theorem row_111_121 : RowResult ⟨111, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_111_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 0 4 6)

theorem row_111_122 : RowResult ⟨111, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_111_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 0 4 6)

theorem row_111_123 : RowResult ⟨111, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_111_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 0 4 6)

theorem row_111_124 : RowResult ⟨111, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_111_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 0 4 6)

theorem row_111_125 : RowResult ⟨111, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_111_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_111_126 : RowResult ⟨111, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_111_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_111_127 : RowResult ⟨111, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_111_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_111_128 : RowResult ⟨111, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_111_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_111_129 : RowResult ⟨111, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_111_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_111_130 : RowResult ⟨111, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_111_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_111_131 : RowResult ⟨111, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_111_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_111_132 : RowResult ⟨111, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_111_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_111_133 : RowResult ⟨111, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_111_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_111_134 : RowResult ⟨111, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_111_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_111_135 : RowResult ⟨111, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_111_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_111_136 : RowResult ⟨111, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_111_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 1 4 6)

theorem row_111_137 : RowResult ⟨111, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_111_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_111_138 : RowResult ⟨111, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_111_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 2 4 7)

theorem row_111_139 : RowResult ⟨111, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_111_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 2 5 7)

theorem row_111_140 : RowResult ⟨111, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_111_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_111_141 : RowResult ⟨111, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_111_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 1 4 7)

theorem row_111_142 : RowResult ⟨111, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_111_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
