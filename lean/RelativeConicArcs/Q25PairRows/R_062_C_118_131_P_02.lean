import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_62_118 : RowResult ⟨62, by decide⟩ ⟨118, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_119 : RowResult ⟨62, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_62_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 2 4 6)

theorem row_62_120 : RowResult ⟨62, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_62_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_62_121 : RowResult ⟨62, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_62_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_122 : RowResult ⟨62, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_62_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_62_123 : RowResult ⟨62, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_62_122
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_62_124 : RowResult ⟨62, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_62_123
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_62_125 : RowResult ⟨62, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_62_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_62_126 : RowResult ⟨62, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_62_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_62_127 : RowResult ⟨62, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_62_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_62_128 : RowResult ⟨62, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_62_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_62_129 : RowResult ⟨62, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_62_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_62_130 : RowResult ⟨62, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_62_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨62, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_62_131 : RowResult ⟨62, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_62_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
