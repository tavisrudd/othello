import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_136_192 : RowResult ⟨136, by decide⟩ ⟨192, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_136_193 : RowResult ⟨136, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_136_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_136_194 : RowResult ⟨136, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_136_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_136_195 : RowResult ⟨136, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_136_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_136_196 : RowResult ⟨136, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_136_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_136_197 : RowResult ⟨136, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_136_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_136_198 : RowResult ⟨136, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_136_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
