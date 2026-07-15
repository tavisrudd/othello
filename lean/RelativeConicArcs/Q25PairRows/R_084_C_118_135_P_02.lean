import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_84_118 : RowResult ⟨84, by decide⟩ ⟨118, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_84_119 : RowResult ⟨84, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_84_118
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_84_120 : RowResult ⟨84, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_84_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_84_121 : RowResult ⟨84, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_84_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_84_122 : RowResult ⟨84, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_84_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 2 4 6)

theorem row_84_123 : RowResult ⟨84, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_84_122
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_84_124 : RowResult ⟨84, by decide⟩ ⟨124, by decide⟩ := by
  have _previous := row_84_123
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨124, by decide⟩) 1 4 7)

theorem row_84_125 : RowResult ⟨84, by decide⟩ ⟨125, by decide⟩ := by
  have _previous := row_84_124
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨125, by decide⟩) 1 6 7)

theorem row_84_126 : RowResult ⟨84, by decide⟩ ⟨126, by decide⟩ := by
  have _previous := row_84_125
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨126, by decide⟩) 1 6 7)

theorem row_84_127 : RowResult ⟨84, by decide⟩ ⟨127, by decide⟩ := by
  have _previous := row_84_126
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨127, by decide⟩) 1 6 7)

theorem row_84_128 : RowResult ⟨84, by decide⟩ ⟨128, by decide⟩ := by
  have _previous := row_84_127
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨128, by decide⟩) 1 6 7)

theorem row_84_129 : RowResult ⟨84, by decide⟩ ⟨129, by decide⟩ := by
  have _previous := row_84_128
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨129, by decide⟩) 1 6 7)

theorem row_84_130 : RowResult ⟨84, by decide⟩ ⟨130, by decide⟩ := by
  have _previous := row_84_129
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨130, by decide⟩) 1 2 6)

theorem row_84_131 : RowResult ⟨84, by decide⟩ ⟨131, by decide⟩ := by
  have _previous := row_84_130
  exact Or.inr ⟨orbitCodeOfNumber ⟨40, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_84_132 : RowResult ⟨84, by decide⟩ ⟨132, by decide⟩ := by
  have _previous := row_84_131
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨132, by decide⟩) 4 5 6)

theorem row_84_133 : RowResult ⟨84, by decide⟩ ⟨133, by decide⟩ := by
  have _previous := row_84_132
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨133, by decide⟩) 2 5 7)

theorem row_84_134 : RowResult ⟨84, by decide⟩ ⟨134, by decide⟩ := by
  have _previous := row_84_133
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨84, by decide⟩) (orbitCodeOfNumber ⟨134, by decide⟩) 1 4 6)

theorem row_84_135 : RowResult ⟨84, by decide⟩ ⟨135, by decide⟩ := by
  have _previous := row_84_134
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
