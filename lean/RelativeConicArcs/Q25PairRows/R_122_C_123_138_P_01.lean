import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_122_123 : RowResult ⟨122, by decide⟩ ⟨123, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 0 4 6)

theorem row_122_124 : RowResult ⟨122, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_122_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 0 4 6)

theorem row_122_125 : RowResult ⟨122, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_122_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_122_126 : RowResult ⟨122, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_122_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_122_127 : RowResult ⟨122, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_122_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_122_128 : RowResult ⟨122, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_122_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_122_129 : RowResult ⟨122, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_122_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_122_130 : RowResult ⟨122, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_122_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_122_131 : RowResult ⟨122, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_122_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_122_132 : RowResult ⟨122, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_122_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 1 4 7)

theorem row_122_133 : RowResult ⟨122, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_122_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_122_134 : RowResult ⟨122, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_122_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨231, by decide⟩, by decide⟩

theorem row_122_135 : RowResult ⟨122, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_122_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_122_136 : RowResult ⟨122, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_122_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_122_137 : RowResult ⟨122, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_122_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_122_138 : RowResult ⟨122, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_122_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
