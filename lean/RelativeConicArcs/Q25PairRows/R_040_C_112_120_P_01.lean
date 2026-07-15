import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_40_112 : RowResult ⟨40, by decide⟩ ⟨112, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_40_113 : RowResult ⟨40, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_40_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_40_114 : RowResult ⟨40, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_40_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_40_115 : RowResult ⟨40, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_40_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 1 4 6)

theorem row_40_116 : RowResult ⟨40, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_40_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_40_117 : RowResult ⟨40, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_40_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_40_118 : RowResult ⟨40, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_40_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_40_119 : RowResult ⟨40, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_40_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 2 4 7)

theorem row_40_120 : RowResult ⟨40, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_40_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
