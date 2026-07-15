import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_49_123 : RowResult ⟨49, by decide⟩ ⟨123, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_49_124 : RowResult ⟨49, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_49_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 1 4 6)

theorem row_49_125 : RowResult ⟨49, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_49_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_49_126 : RowResult ⟨49, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_49_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_49_127 : RowResult ⟨49, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_49_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_49_128 : RowResult ⟨49, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_49_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_49_129 : RowResult ⟨49, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_49_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_49_130 : RowResult ⟨49, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_49_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_49_131 : RowResult ⟨49, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_49_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_49_132 : RowResult ⟨49, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_49_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_49_133 : RowResult ⟨49, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_49_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_49_134 : RowResult ⟨49, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_49_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 1 4 7)

theorem row_49_135 : RowResult ⟨49, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_49_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_49_136 : RowResult ⟨49, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_49_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_49_137 : RowResult ⟨49, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_49_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

end RelativeConicArcs.Q25PairCertificate
