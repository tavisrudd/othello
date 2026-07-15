import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_124_125 : RowResult ⟨124, by decide⟩ ⟨125, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_124_126 : RowResult ⟨124, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_124_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_124_127 : RowResult ⟨124, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_124_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_124_128 : RowResult ⟨124, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_124_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_124_129 : RowResult ⟨124, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_124_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_124_130 : RowResult ⟨124, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_124_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_124_131 : RowResult ⟨124, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_124_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_124_132 : RowResult ⟨124, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_124_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 2 4 6)

theorem row_124_133 : RowResult ⟨124, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_124_132
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_124_134 : RowResult ⟨124, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_124_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 1 4 7)

theorem row_124_135 : RowResult ⟨124, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_124_134
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨135, by decide⟩) 2 4 7)

theorem row_124_136 : RowResult ⟨124, by decide⟩ ⟨136, by decide⟩ := by
  have _previous := row_124_135
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_124_137 : RowResult ⟨124, by decide⟩ ⟨137, by decide⟩ := by
  have _previous := row_124_136
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨137, by decide⟩) 2 3 6)

theorem row_124_138 : RowResult ⟨124, by decide⟩ ⟨138, by decide⟩ := by
  have _previous := row_124_137
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) (orbitCodeOfNumber ⟨138, by decide⟩) 2 5 7)

theorem row_124_139 : RowResult ⟨124, by decide⟩ ⟨139, by decide⟩ := by
  have _previous := row_124_138
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_124_140 : RowResult ⟨124, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_124_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_124_141 : RowResult ⟨124, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_124_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
