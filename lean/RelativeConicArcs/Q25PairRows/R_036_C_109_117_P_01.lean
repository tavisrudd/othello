import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_36_109 : RowResult ⟨36, by decide⟩ ⟨109, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_36_110 : RowResult ⟨36, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_36_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_36_111 : RowResult ⟨36, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_36_110
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) 1 4 6)

theorem row_36_112 : RowResult ⟨36, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_36_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 2 4 6)

theorem row_36_113 : RowResult ⟨36, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_36_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_36_114 : RowResult ⟨36, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_36_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_36_115 : RowResult ⟨36, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_36_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_36_116 : RowResult ⟨36, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_36_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨36, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 1 4 7)

theorem row_36_117 : RowResult ⟨36, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_36_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
