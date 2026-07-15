import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_93_115 : RowResult ⟨93, by decide⟩ ⟨115, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_93_116 : RowResult ⟨93, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_93_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_93_117 : RowResult ⟨93, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_93_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 2 4 6)

theorem row_93_118 : RowResult ⟨93, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_93_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 1 4 6)

theorem row_93_119 : RowResult ⟨93, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_93_118
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_93_120 : RowResult ⟨93, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_93_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_93_121 : RowResult ⟨93, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_93_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_93_122 : RowResult ⟨93, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_93_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 4 5 6)

theorem row_93_123 : RowResult ⟨93, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_93_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 2 4 7)

theorem row_93_124 : RowResult ⟨93, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_93_123
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_93_125 : RowResult ⟨93, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_93_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_93_126 : RowResult ⟨93, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_93_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_93_127 : RowResult ⟨93, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_93_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_93_128 : RowResult ⟨93, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_93_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_93_129 : RowResult ⟨93, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_93_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_93_130 : RowResult ⟨93, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_93_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_93_131 : RowResult ⟨93, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_93_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
