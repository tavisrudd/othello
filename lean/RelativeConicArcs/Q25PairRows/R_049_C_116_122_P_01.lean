import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_49_116 : RowResult ⟨49, by decide⟩ ⟨116, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_49_117 : RowResult ⟨49, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_49_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_49_118 : RowResult ⟨49, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_49_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_49_119 : RowResult ⟨49, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_49_118
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_49_120 : RowResult ⟨49, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_49_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨49, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_49_121 : RowResult ⟨49, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_49_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_49_122 : RowResult ⟨49, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_49_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
