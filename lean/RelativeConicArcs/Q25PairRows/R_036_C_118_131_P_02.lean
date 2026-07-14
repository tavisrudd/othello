import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_36_118 : RowResult ⟨36, by decide⟩ ⟨118, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_36_119 : RowResult ⟨36, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_36_118
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_36_120 : RowResult ⟨36, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_36_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_36_121 : RowResult ⟨36, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_36_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_36_122 : RowResult ⟨36, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_36_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 2 5 6)

theorem row_36_123 : RowResult ⟨36, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_36_122
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_36_124 : RowResult ⟨36, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_36_123
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_36_125 : RowResult ⟨36, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_36_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_36_126 : RowResult ⟨36, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_36_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_36_127 : RowResult ⟨36, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_36_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_36_128 : RowResult ⟨36, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_36_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_36_129 : RowResult ⟨36, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_36_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_36_130 : RowResult ⟨36, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_36_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_36_131 : RowResult ⟨36, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_36_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
