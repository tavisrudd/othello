import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_121_122 : RowResult ⟨121, by decide⟩ ⟨122, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 0 4 6)

theorem row_121_123 : RowResult ⟨121, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_121_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 0 4 6)

theorem row_121_124 : RowResult ⟨121, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_121_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 0 4 6)

theorem row_121_125 : RowResult ⟨121, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_121_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_121_126 : RowResult ⟨121, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_121_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_121_127 : RowResult ⟨121, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_121_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_121_128 : RowResult ⟨121, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_121_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_121_129 : RowResult ⟨121, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_121_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_121_130 : RowResult ⟨121, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_121_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_121_131 : RowResult ⟨121, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_121_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 1 4 7)

theorem row_121_132 : RowResult ⟨121, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_121_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 2 5 7)

theorem row_121_133 : RowResult ⟨121, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_121_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_121_134 : RowResult ⟨121, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_121_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_121_135 : RowResult ⟨121, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_121_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_121_136 : RowResult ⟨121, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_121_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_121_137 : RowResult ⟨121, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_121_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_121_138 : RowResult ⟨121, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_121_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 2 5 6)

theorem row_121_139 : RowResult ⟨121, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_121_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 2 4 6)

theorem row_121_140 : RowResult ⟨121, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_121_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_121_141 : RowResult ⟨121, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_121_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 4 5 6)

theorem row_121_142 : RowResult ⟨121, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_121_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
