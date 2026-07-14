import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_32_110 : RowResult ⟨32, by decide⟩ ⟨110, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_32_111 : RowResult ⟨32, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_32_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 2 4 7)

theorem row_32_112 : RowResult ⟨32, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_32_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_113 : RowResult ⟨32, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_32_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 2 5 6)

theorem row_32_114 : RowResult ⟨32, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_32_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_115 : RowResult ⟨32, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_32_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 2 4 6)

theorem row_32_116 : RowResult ⟨32, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_32_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_117 : RowResult ⟨32, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_32_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_118 : RowResult ⟨32, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_32_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 4 5 6)

theorem row_32_119 : RowResult ⟨32, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_32_118
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_32_120 : RowResult ⟨32, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_32_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
