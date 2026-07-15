import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_89_116 : RowResult ⟨89, by decide⟩ ⟨116, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_89_117 : RowResult ⟨89, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_89_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_89_118 : RowResult ⟨89, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_89_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_89_119 : RowResult ⟨89, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_89_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 1 4 7)

theorem row_89_120 : RowResult ⟨89, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_89_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_89_121 : RowResult ⟨89, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_89_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_89_122 : RowResult ⟨89, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_89_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_89_123 : RowResult ⟨89, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_89_122
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_89_124 : RowResult ⟨89, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_89_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 2 4 7)

theorem row_89_125 : RowResult ⟨89, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_89_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_89_126 : RowResult ⟨89, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_89_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_89_127 : RowResult ⟨89, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_89_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_89_128 : RowResult ⟨89, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_89_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_89_129 : RowResult ⟨89, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_89_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_89_130 : RowResult ⟨89, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_89_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨89, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
