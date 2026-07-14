import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_68_110 : RowResult ⟨68, by decide⟩ ⟨110, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_68_111 : RowResult ⟨68, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_68_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_68_112 : RowResult ⟨68, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_68_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨196, by decide⟩, by decide⟩

theorem row_68_113 : RowResult ⟨68, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_68_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 1 4 7)

theorem row_68_114 : RowResult ⟨68, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_68_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_68_115 : RowResult ⟨68, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_68_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_68_116 : RowResult ⟨68, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_68_115
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨116, by decide⟩) 4 5 6)

theorem row_68_117 : RowResult ⟨68, by decide⟩ ⟨117, by decide⟩ := by
  have _previous := row_68_116
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_68_118 : RowResult ⟨68, by decide⟩ ⟨118, by decide⟩ := by
  have _previous := row_68_117
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨68, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
