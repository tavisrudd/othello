import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_39_113 : RowResult ⟨39, by decide⟩ ⟨113, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_39_114 : RowResult ⟨39, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_39_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 1 4 6)

theorem row_39_115 : RowResult ⟨39, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_39_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_39_116 : RowResult ⟨39, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_39_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_39_117 : RowResult ⟨39, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_39_116
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨117, by decide⟩) 2 5 6)

theorem row_39_118 : RowResult ⟨39, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_39_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_39_119 : RowResult ⟨39, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_39_118
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨119, by decide⟩) 1 4 7)

theorem row_39_120 : RowResult ⟨39, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_39_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_39_121 : RowResult ⟨39, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_39_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_39_122 : RowResult ⟨39, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_39_121
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_39_123 : RowResult ⟨39, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_39_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨39, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
