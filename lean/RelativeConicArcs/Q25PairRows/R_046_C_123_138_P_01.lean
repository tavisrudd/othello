import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_46_123 : RowResult ⟨46, by decide⟩ ⟨123, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_46_124 : RowResult ⟨46, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_46_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 2 4 7)

theorem row_46_125 : RowResult ⟨46, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_46_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_46_126 : RowResult ⟨46, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_46_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_46_127 : RowResult ⟨46, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_46_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_46_128 : RowResult ⟨46, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_46_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_46_129 : RowResult ⟨46, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_46_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_46_130 : RowResult ⟨46, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_46_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_46_131 : RowResult ⟨46, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_46_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 1 4 7)

theorem row_46_132 : RowResult ⟨46, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_46_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_46_133 : RowResult ⟨46, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_46_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_46_134 : RowResult ⟨46, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_46_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_46_135 : RowResult ⟨46, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_46_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_46_136 : RowResult ⟨46, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_46_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_46_137 : RowResult ⟨46, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_46_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_46_138 : RowResult ⟨46, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_46_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 2 4 7)

end RelativeConicArcs.Q25PairCertificate
