import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_59_210 : RowResult ⟨59, by decide⟩ ⟨210, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_59_211 : RowResult ⟨59, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_59_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 2 4 7)

theorem row_59_212 : RowResult ⟨59, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_59_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_59_213 : RowResult ⟨59, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_59_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_59_214 : RowResult ⟨59, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_59_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_59_215 : RowResult ⟨59, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_59_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_59_216 : RowResult ⟨59, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_59_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
