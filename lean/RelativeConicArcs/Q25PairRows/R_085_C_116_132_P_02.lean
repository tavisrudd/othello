import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_85_116 : RowResult ⟨85, by decide⟩ ⟨116, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_85_117 : RowResult ⟨85, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_85_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_85_118 : RowResult ⟨85, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_85_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_85_119 : RowResult ⟨85, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_85_118
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_85_120 : RowResult ⟨85, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_85_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_85_121 : RowResult ⟨85, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_85_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_85_122 : RowResult ⟨85, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_85_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 2 5 7)

theorem row_85_123 : RowResult ⟨85, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_85_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 2 5 6)

theorem row_85_124 : RowResult ⟨85, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_85_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 2 4 6)

theorem row_85_125 : RowResult ⟨85, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_85_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_85_126 : RowResult ⟨85, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_85_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_85_127 : RowResult ⟨85, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_85_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_85_128 : RowResult ⟨85, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_85_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_85_129 : RowResult ⟨85, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_85_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_85_130 : RowResult ⟨85, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_85_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_85_131 : RowResult ⟨85, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_85_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_85_132 : RowResult ⟨85, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_85_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
