import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_88_124 : RowResult ⟨88, by decide⟩ ⟨124, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_88_125 : RowResult ⟨88, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_88_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_88_126 : RowResult ⟨88, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_88_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_88_127 : RowResult ⟨88, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_88_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_88_128 : RowResult ⟨88, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_88_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_88_129 : RowResult ⟨88, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_88_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_88_130 : RowResult ⟨88, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_88_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_88_131 : RowResult ⟨88, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_88_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_88_132 : RowResult ⟨88, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_88_131
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_88_133 : RowResult ⟨88, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_88_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_88_134 : RowResult ⟨88, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_88_133
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_88_135 : RowResult ⟨88, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_88_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_88_136 : RowResult ⟨88, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_88_135
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) 2 4 7)

theorem row_88_137 : RowResult ⟨88, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_88_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_88_138 : RowResult ⟨88, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_88_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 1 4 6)

theorem row_88_139 : RowResult ⟨88, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_88_138
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨139, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
