import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_174_210 : RowResult ⟨174, by decide⟩ ⟨210, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_174_211 : RowResult ⟨174, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_174_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_174_212 : RowResult ⟨174, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_174_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_174_213 : RowResult ⟨174, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_174_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_174_214 : RowResult ⟨174, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_174_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_174_215 : RowResult ⟨174, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_174_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
