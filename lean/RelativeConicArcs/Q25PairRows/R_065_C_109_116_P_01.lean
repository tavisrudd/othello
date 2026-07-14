import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_65_109 : RowResult ⟨65, by decide⟩ ⟨109, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_65_110 : RowResult ⟨65, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_65_109
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨110, by decide⟩) 1 4 7)

theorem row_65_111 : RowResult ⟨65, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_65_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_65_112 : RowResult ⟨65, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_65_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨196, by decide⟩, by decide⟩

theorem row_65_113 : RowResult ⟨65, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_65_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_65_114 : RowResult ⟨65, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_65_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_65_115 : RowResult ⟨65, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_65_114
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨115, by decide⟩) 1 4 6)

theorem row_65_116 : RowResult ⟨65, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_65_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
