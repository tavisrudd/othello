import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_71_109 : RowResult ⟨71, by decide⟩ ⟨109, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_71_110 : RowResult ⟨71, by decide⟩ ⟨110, by decide⟩ := by
  have _previous := row_71_109
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_71_111 : RowResult ⟨71, by decide⟩ ⟨111, by decide⟩ := by
  have _previous := row_71_110
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_71_112 : RowResult ⟨71, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_71_111
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨112, by decide⟩) 2 4 6)

theorem row_71_113 : RowResult ⟨71, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_71_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_71_114 : RowResult ⟨71, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_71_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_71_115 : RowResult ⟨71, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_71_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
