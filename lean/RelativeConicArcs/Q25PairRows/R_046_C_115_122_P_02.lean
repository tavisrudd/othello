import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_46_115 : RowResult ⟨46, by decide⟩ ⟨115, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_46_116 : RowResult ⟨46, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_46_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_46_117 : RowResult ⟨46, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_46_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_46_118 : RowResult ⟨46, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_46_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_46_119 : RowResult ⟨46, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_46_118
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_46_120 : RowResult ⟨46, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_46_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_46_121 : RowResult ⟨46, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_46_120
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) 1 4 6)

theorem row_46_122 : RowResult ⟨46, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_46_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
