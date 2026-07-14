import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_121_210 : RowResult ⟨121, by decide⟩ ⟨210, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_121_211 : RowResult ⟨121, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_121_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_121_212 : RowResult ⟨121, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_121_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨121, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 2 4 6)

theorem row_121_213 : RowResult ⟨121, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_121_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_121_214 : RowResult ⟨121, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_121_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_121_215 : RowResult ⟨121, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_121_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_121_216 : RowResult ⟨121, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_121_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
