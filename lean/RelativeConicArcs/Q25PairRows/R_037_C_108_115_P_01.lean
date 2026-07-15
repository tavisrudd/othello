import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_37_108 : RowResult ⟨37, by decide⟩ ⟨108, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_37_109 : RowResult ⟨37, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_37_108
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) 4 5 6)

theorem row_37_110 : RowResult ⟨37, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_37_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_37_111 : RowResult ⟨37, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_37_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_37_112 : RowResult ⟨37, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_37_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨37, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 1 4 6)

theorem row_37_113 : RowResult ⟨37, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_37_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_37_114 : RowResult ⟨37, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_37_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_37_115 : RowResult ⟨37, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_37_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
