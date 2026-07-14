import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_114_232 : RowResult ⟨114, by decide⟩ ⟨232, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_114_233 : RowResult ⟨114, by decide⟩ ⟨233, by decide⟩ := by
  have _previous := row_114_232
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_114_234 : RowResult ⟨114, by decide⟩ ⟨234, by decide⟩ := by
  have _previous := row_114_233
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_114_235 : RowResult ⟨114, by decide⟩ ⟨235, by decide⟩ := by
  have _previous := row_114_234
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_114_236 : RowResult ⟨114, by decide⟩ ⟨236, by decide⟩ := by
  have _previous := row_114_235
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_114_237 : RowResult ⟨114, by decide⟩ ⟨237, by decide⟩ := by
  have _previous := row_114_236
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
