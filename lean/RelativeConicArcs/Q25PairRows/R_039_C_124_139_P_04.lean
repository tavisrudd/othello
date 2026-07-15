import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_39_124 : RowResult ⟨39, by decide⟩ ⟨124, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_39_125 : RowResult ⟨39, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_39_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_39_126 : RowResult ⟨39, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_39_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_39_127 : RowResult ⟨39, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_39_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_39_128 : RowResult ⟨39, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_39_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_39_129 : RowResult ⟨39, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_39_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_39_130 : RowResult ⟨39, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_39_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_39_131 : RowResult ⟨39, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_39_130
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨131, by decide⟩) 2 4 6)

theorem row_39_132 : RowResult ⟨39, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_39_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_39_133 : RowResult ⟨39, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_39_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_39_134 : RowResult ⟨39, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_39_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_39_135 : RowResult ⟨39, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_39_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_39_136 : RowResult ⟨39, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_39_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 4 5 6)

theorem row_39_137 : RowResult ⟨39, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_39_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_39_138 : RowResult ⟨39, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_39_137
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_39_139 : RowResult ⟨39, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_39_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
