import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_97_113 : RowResult ⟨97, by decide⟩ ⟨113, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_97_114 : RowResult ⟨97, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_97_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 4 5 6)

theorem row_97_115 : RowResult ⟨97, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_97_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 2 5 7)

theorem row_97_116 : RowResult ⟨97, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_97_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_97_117 : RowResult ⟨97, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_97_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_97_118 : RowResult ⟨97, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_97_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_97_119 : RowResult ⟨97, by decide⟩ ⟨119, by decide⟩ := by
  have _previous := row_97_118
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_97_120 : RowResult ⟨97, by decide⟩ ⟨120, by decide⟩ := by
  have _previous := row_97_119
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨120, by decide⟩) 1 2 7)

theorem row_97_121 : RowResult ⟨97, by decide⟩ ⟨121, by decide⟩ := by
  have _previous := row_97_120
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_97_122 : RowResult ⟨97, by decide⟩ ⟨122, by decide⟩ := by
  have _previous := row_97_121
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨122, by decide⟩) 1 4 6)

theorem row_97_123 : RowResult ⟨97, by decide⟩ ⟨123, by decide⟩ := by
  have _previous := row_97_122
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨123, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
