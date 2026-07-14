import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_61_114 : RowResult ⟨61, by decide⟩ ⟨114, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_61_115 : RowResult ⟨61, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_61_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨167, by decide⟩, by decide⟩

theorem row_61_116 : RowResult ⟨61, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_61_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 1 4 7)

theorem row_61_117 : RowResult ⟨61, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_61_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 2 4 6)

theorem row_61_118 : RowResult ⟨61, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_61_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_61_119 : RowResult ⟨61, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_61_118
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_61_120 : RowResult ⟨61, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_61_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_61_121 : RowResult ⟨61, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_61_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_61_122 : RowResult ⟨61, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_61_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_61_123 : RowResult ⟨61, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_61_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 2 4 7)

theorem row_61_124 : RowResult ⟨61, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_61_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 2 5 7)

theorem row_61_125 : RowResult ⟨61, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_61_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_61_126 : RowResult ⟨61, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_61_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_61_127 : RowResult ⟨61, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_61_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_61_128 : RowResult ⟨61, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_61_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_61_129 : RowResult ⟨61, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_61_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_61_130 : RowResult ⟨61, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_61_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨61, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
