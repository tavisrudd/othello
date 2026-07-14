import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_72_110 : RowResult ⟨72, by decide⟩ ⟨110, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨167, by decide⟩, by decide⟩

theorem row_72_111 : RowResult ⟨72, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_72_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_72_112 : RowResult ⟨72, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_72_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 2 4 7)

theorem row_72_113 : RowResult ⟨72, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_72_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 2 5 6)

theorem row_72_114 : RowResult ⟨72, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_72_113
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨72, by decide⟩) (orbitCodeOfNumber ⟨114, by decide⟩) 2 4 6)

theorem row_72_115 : RowResult ⟨72, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_72_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_72_116 : RowResult ⟨72, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_72_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_72_117 : RowResult ⟨72, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_72_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_72_118 : RowResult ⟨72, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_72_117
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
