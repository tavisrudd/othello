import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false
set_option linter.unusedVariables false

theorem row_73_115 : RowResult ⟨73, by decide⟩ ⟨115, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_73_116 : RowResult ⟨73, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_73_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_73_117 : RowResult ⟨73, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_73_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_73_118 : RowResult ⟨73, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_73_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_73_119 : RowResult ⟨73, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_73_118
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_73_120 : RowResult ⟨73, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_73_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_73_121 : RowResult ⟨73, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_73_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_73_122 : RowResult ⟨73, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_73_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 4 5 6)

theorem row_73_123 : RowResult ⟨73, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_73_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 1 4 6)

theorem row_73_124 : RowResult ⟨73, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_73_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 2 4 7)

theorem row_73_125 : RowResult ⟨73, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_73_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_73_126 : RowResult ⟨73, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_73_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_73_127 : RowResult ⟨73, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_73_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_73_128 : RowResult ⟨73, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_73_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_73_129 : RowResult ⟨73, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_73_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_73_130 : RowResult ⟨73, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_73_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_73_131 : RowResult ⟨73, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_73_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
