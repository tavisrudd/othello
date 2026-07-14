import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_66_124 : RowResult ⟨66, by decide⟩ ⟨124, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_66_125 : RowResult ⟨66, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_66_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_66_126 : RowResult ⟨66, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_66_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_66_127 : RowResult ⟨66, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_66_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_66_128 : RowResult ⟨66, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_66_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_66_129 : RowResult ⟨66, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_66_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_66_130 : RowResult ⟨66, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_66_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_66_131 : RowResult ⟨66, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_66_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 2 4 6)

theorem row_66_132 : RowResult ⟨66, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_66_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_66_133 : RowResult ⟨66, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_66_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_66_134 : RowResult ⟨66, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_66_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 4 5 6)

theorem row_66_135 : RowResult ⟨66, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_66_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_66_136 : RowResult ⟨66, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_66_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 1 4 7)

theorem row_66_137 : RowResult ⟨66, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_66_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_66_138 : RowResult ⟨66, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_66_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_66_139 : RowResult ⟨66, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_66_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 2 5 7)

theorem row_66_140 : RowResult ⟨66, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_66_139
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨140, by decide⟩) 2 4 7)

theorem row_66_141 : RowResult ⟨66, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_66_140
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) 1 4 6)

theorem row_66_142 : RowResult ⟨66, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_66_141
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨66, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) 2 5 6)

theorem row_66_143 : RowResult ⟨66, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_66_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
