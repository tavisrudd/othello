import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_43_110 : RowResult ⟨43, by decide⟩ ⟨110, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_43_111 : RowResult ⟨43, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_43_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_43_112 : RowResult ⟨43, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_43_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨196, by decide⟩, by decide⟩

theorem row_43_113 : RowResult ⟨43, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_43_112
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨43, by decide⟩) (orbitCodeOfNumber ⟨113, by decide⟩) 1 4 7)

theorem row_43_114 : RowResult ⟨43, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_43_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_43_115 : RowResult ⟨43, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_43_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_43_116 : RowResult ⟨43, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_43_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
