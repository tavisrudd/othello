import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_88_116 : RowResult ⟨88, by decide⟩ ⟨116, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_88_117 : RowResult ⟨88, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_88_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_88_118 : RowResult ⟨88, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_88_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 1 4 7)

theorem row_88_119 : RowResult ⟨88, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_88_118
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_88_120 : RowResult ⟨88, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_88_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨88, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_88_121 : RowResult ⟨88, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_88_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_88_122 : RowResult ⟨88, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_88_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_88_123 : RowResult ⟨88, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_88_122
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
