import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_122_159 : RowResult ⟨122, by decide⟩ ⟨159, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_122_160 : RowResult ⟨122, by decide⟩ ⟨160, by decide⟩ := by
  have _previous := row_122_159
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_122_161 : RowResult ⟨122, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_122_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_122_162 : RowResult ⟨122, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_122_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_122_163 : RowResult ⟨122, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_122_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_122_164 : RowResult ⟨122, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_122_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
