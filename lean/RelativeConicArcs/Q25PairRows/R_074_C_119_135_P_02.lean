import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_74_119 : RowResult ⟨74, by decide⟩ ⟨119, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_74_120 : RowResult ⟨74, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_74_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_74_121 : RowResult ⟨74, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_74_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_74_122 : RowResult ⟨74, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_74_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_74_123 : RowResult ⟨74, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_74_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 4 5 6)

theorem row_74_124 : RowResult ⟨74, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_74_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 1 4 6)

theorem row_74_125 : RowResult ⟨74, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_74_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_74_126 : RowResult ⟨74, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_74_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_74_127 : RowResult ⟨74, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_74_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_74_128 : RowResult ⟨74, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_74_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_74_129 : RowResult ⟨74, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_74_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_74_130 : RowResult ⟨74, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_74_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_74_131 : RowResult ⟨74, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_74_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_74_132 : RowResult ⟨74, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_74_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_74_133 : RowResult ⟨74, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_74_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 2 5 6)

theorem row_74_134 : RowResult ⟨74, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_74_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨74, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 1 4 7)

theorem row_74_135 : RowResult ⟨74, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_74_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
