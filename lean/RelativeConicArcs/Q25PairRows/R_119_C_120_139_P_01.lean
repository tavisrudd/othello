import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_119_120 : RowResult ⟨119, by decide⟩ ⟨120, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 0 4 6)

theorem row_119_121 : RowResult ⟨119, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_119_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 0 4 6)

theorem row_119_122 : RowResult ⟨119, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_119_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 0 4 6)

theorem row_119_123 : RowResult ⟨119, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_119_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 0 4 6)

theorem row_119_124 : RowResult ⟨119, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_119_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 0 4 6)

theorem row_119_125 : RowResult ⟨119, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_119_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_119_126 : RowResult ⟨119, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_119_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_119_127 : RowResult ⟨119, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_119_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_119_128 : RowResult ⟨119, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_119_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_119_129 : RowResult ⟨119, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_119_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_119_130 : RowResult ⟨119, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_119_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_119_131 : RowResult ⟨119, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_119_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_119_132 : RowResult ⟨119, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_119_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_119_133 : RowResult ⟨119, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_119_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_119_134 : RowResult ⟨119, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_119_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 4 5 6)

theorem row_119_135 : RowResult ⟨119, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_119_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨196, by decide⟩, by decide⟩

theorem row_119_136 : RowResult ⟨119, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_119_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_119_137 : RowResult ⟨119, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_119_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_119_138 : RowResult ⟨119, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_119_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_119_139 : RowResult ⟨119, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_119_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
