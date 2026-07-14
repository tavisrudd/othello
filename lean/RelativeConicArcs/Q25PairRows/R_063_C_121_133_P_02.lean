import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_63_121 : RowResult ⟨63, by decide⟩ ⟨121, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_63_122 : RowResult ⟨63, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_63_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_63_123 : RowResult ⟨63, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_63_122
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_63_124 : RowResult ⟨63, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_63_123
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_63_125 : RowResult ⟨63, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_63_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_63_126 : RowResult ⟨63, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_63_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_63_127 : RowResult ⟨63, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_63_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_63_128 : RowResult ⟨63, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_63_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_63_129 : RowResult ⟨63, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_63_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_63_130 : RowResult ⟨63, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_63_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_63_131 : RowResult ⟨63, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_63_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_63_132 : RowResult ⟨63, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_63_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_63_133 : RowResult ⟨63, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_63_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨63, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
