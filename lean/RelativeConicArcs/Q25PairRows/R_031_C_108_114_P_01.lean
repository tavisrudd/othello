import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_31_108 : RowResult ⟨31, by decide⟩ ⟨108, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_31_109 : RowResult ⟨31, by decide⟩ ⟨109, by decide⟩ := by
  have _previous := row_31_108
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_31_110 : RowResult ⟨31, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_31_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 2 4 6)

theorem row_31_111 : RowResult ⟨31, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_31_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_31_112 : RowResult ⟨31, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_31_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_31_113 : RowResult ⟨31, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_31_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_31_114 : RowResult ⟨31, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_31_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
