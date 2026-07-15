import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_98_117 : RowResult ⟨98, by decide⟩ ⟨117, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨241, by decide⟩, by decide⟩

theorem row_98_118 : RowResult ⟨98, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_98_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_98_119 : RowResult ⟨98, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_98_118
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨241, by decide⟩, by decide⟩

theorem row_98_120 : RowResult ⟨98, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_98_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_98_121 : RowResult ⟨98, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_98_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨241, by decide⟩, by decide⟩

theorem row_98_122 : RowResult ⟨98, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_98_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_98_123 : RowResult ⟨98, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_98_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 1 4 6)

theorem row_98_124 : RowResult ⟨98, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_98_123
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_98_125 : RowResult ⟨98, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_98_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_98_126 : RowResult ⟨98, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_98_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_98_127 : RowResult ⟨98, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_98_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_98_128 : RowResult ⟨98, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_98_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_98_129 : RowResult ⟨98, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_98_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_98_130 : RowResult ⟨98, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_98_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨98, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

end RelativeConicArcs.Q25PairCertificate
