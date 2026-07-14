import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_96_116 : RowResult ⟨96, by decide⟩ ⟨116, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_96_117 : RowResult ⟨96, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_96_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_96_118 : RowResult ⟨96, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_96_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 2 4 7)

theorem row_96_119 : RowResult ⟨96, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_96_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 2 5 6)

theorem row_96_120 : RowResult ⟨96, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_96_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_96_121 : RowResult ⟨96, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_96_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 1 4 6)

theorem row_96_122 : RowResult ⟨96, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_96_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_96_123 : RowResult ⟨96, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_96_122
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_96_124 : RowResult ⟨96, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_96_123
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_96_125 : RowResult ⟨96, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_96_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_96_126 : RowResult ⟨96, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_96_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_96_127 : RowResult ⟨96, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_96_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_96_128 : RowResult ⟨96, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_96_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_96_129 : RowResult ⟨96, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_96_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_96_130 : RowResult ⟨96, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_96_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_96_131 : RowResult ⟨96, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_96_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨96, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 1 4 7)

theorem row_96_132 : RowResult ⟨96, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_96_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
