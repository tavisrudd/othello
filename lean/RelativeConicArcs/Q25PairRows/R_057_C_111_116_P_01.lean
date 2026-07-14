import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_57_111 : RowResult ⟨57, by decide⟩ ⟨111, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_112 : RowResult ⟨57, by decide⟩ ⟨112, by decide⟩ := by
  have _previous := row_57_111
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_113 : RowResult ⟨57, by decide⟩ ⟨113, by decide⟩ := by
  have _previous := row_57_112
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_114 : RowResult ⟨57, by decide⟩ ⟨114, by decide⟩ := by
  have _previous := row_57_113
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_57_115 : RowResult ⟨57, by decide⟩ ⟨115, by decide⟩ := by
  have _previous := row_57_114
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_57_116 : RowResult ⟨57, by decide⟩ ⟨116, by decide⟩ := by
  have _previous := row_57_115
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
