import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_90_117 : RowResult ⟨90, by decide⟩ ⟨117, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_90_118 : RowResult ⟨90, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_90_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_90_119 : RowResult ⟨90, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_90_118
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_90_120 : RowResult ⟨90, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_90_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_90_121 : RowResult ⟨90, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_90_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 2 5 7)

theorem row_90_122 : RowResult ⟨90, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_90_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_90_123 : RowResult ⟨90, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_90_122
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_90_124 : RowResult ⟨90, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_90_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 4 5 6)

theorem row_90_125 : RowResult ⟨90, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_90_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_90_126 : RowResult ⟨90, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_90_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_90_127 : RowResult ⟨90, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_90_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_90_128 : RowResult ⟨90, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_90_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_90_129 : RowResult ⟨90, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_90_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_90_130 : RowResult ⟨90, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_90_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_90_131 : RowResult ⟨90, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_90_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_90_132 : RowResult ⟨90, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_90_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨90, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
