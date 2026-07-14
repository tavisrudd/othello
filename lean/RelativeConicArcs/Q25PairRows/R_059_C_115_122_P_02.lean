import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_59_115 : RowResult ⟨59, by decide⟩ ⟨115, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_59_116 : RowResult ⟨59, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_59_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_59_117 : RowResult ⟨59, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_59_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_59_118 : RowResult ⟨59, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_59_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_59_119 : RowResult ⟨59, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_59_118
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_59_120 : RowResult ⟨59, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_59_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_59_121 : RowResult ⟨59, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_59_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 2 5 7)

theorem row_59_122 : RowResult ⟨59, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_59_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
