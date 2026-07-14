import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_32_211 : RowResult ⟨32, by decide⟩ ⟨211, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_32_212 : RowResult ⟨32, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_32_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_213 : RowResult ⟨32, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_32_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_214 : RowResult ⟨32, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_32_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_32_215 : RowResult ⟨32, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_32_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_32_216 : RowResult ⟨32, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_32_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨32, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 2 5 6)

theorem row_32_217 : RowResult ⟨32, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_32_216
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
