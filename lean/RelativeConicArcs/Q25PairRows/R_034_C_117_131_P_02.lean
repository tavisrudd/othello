import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_34_117 : RowResult ⟨34, by decide⟩ ⟨117, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_34_118 : RowResult ⟨34, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_34_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 2 5 6)

theorem row_34_119 : RowResult ⟨34, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_34_118
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_34_120 : RowResult ⟨34, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_34_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_34_121 : RowResult ⟨34, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_34_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_34_122 : RowResult ⟨34, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_34_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_34_123 : RowResult ⟨34, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_34_122
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_34_124 : RowResult ⟨34, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_34_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 1 4 7)

theorem row_34_125 : RowResult ⟨34, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_34_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_34_126 : RowResult ⟨34, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_34_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_34_127 : RowResult ⟨34, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_34_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_34_128 : RowResult ⟨34, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_34_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_34_129 : RowResult ⟨34, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_34_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_34_130 : RowResult ⟨34, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_34_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨34, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_34_131 : RowResult ⟨34, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_34_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
