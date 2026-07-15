import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_60_108 : RowResult ⟨60, by decide⟩ ⟨108, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_60_109 : RowResult ⟨60, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_60_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨41, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_60_110 : RowResult ⟨60, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_60_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 1 4 6)

theorem row_60_111 : RowResult ⟨60, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_60_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 2 4 7)

theorem row_60_112 : RowResult ⟨60, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_60_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 4 5 6)

theorem row_60_113 : RowResult ⟨60, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_60_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_60_114 : RowResult ⟨60, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_60_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_60_115 : RowResult ⟨60, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_60_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 1 4 7)

theorem row_60_116 : RowResult ⟨60, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_60_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 2 5 7)

theorem row_60_117 : RowResult ⟨60, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_60_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_60_118 : RowResult ⟨60, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_60_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
