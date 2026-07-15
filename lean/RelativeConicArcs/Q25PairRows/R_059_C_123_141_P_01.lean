import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_59_123 : RowResult ⟨59, by decide⟩ ⟨123, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_59_124 : RowResult ⟨59, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_59_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 1 4 7)

theorem row_59_125 : RowResult ⟨59, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_59_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_59_126 : RowResult ⟨59, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_59_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_59_127 : RowResult ⟨59, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_59_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_59_128 : RowResult ⟨59, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_59_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_59_129 : RowResult ⟨59, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_59_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_59_130 : RowResult ⟨59, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_59_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_59_131 : RowResult ⟨59, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_59_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_59_132 : RowResult ⟨59, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_59_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 2 5 7)

theorem row_59_133 : RowResult ⟨59, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_59_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 2 4 7)

theorem row_59_134 : RowResult ⟨59, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_59_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 1 4 6)

theorem row_59_135 : RowResult ⟨59, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_59_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 4 5 6)

theorem row_59_136 : RowResult ⟨59, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_59_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_59_137 : RowResult ⟨59, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_59_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_59_138 : RowResult ⟨59, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_59_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 2 5 6)

theorem row_59_139 : RowResult ⟨59, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_59_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_59_140 : RowResult ⟨59, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_59_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_59_141 : RowResult ⟨59, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_59_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
