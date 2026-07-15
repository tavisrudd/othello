import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_59_91 : RowResult ⟨59, by decide⟩ ⟨91, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_59_92 : RowResult ⟨59, by decide⟩ ⟨92, by decide⟩ := by
  have _previous := row_59_91
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_59_93 : RowResult ⟨59, by decide⟩ ⟨93, by decide⟩ := by
  have _previous := row_59_92
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_59_94 : RowResult ⟨59, by decide⟩ ⟨94, by decide⟩ := by
  have _previous := row_59_93
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_59_95 : RowResult ⟨59, by decide⟩ ⟨95, by decide⟩ := by
  have _previous := row_59_94
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨59, by decide⟩) (orbitCodeOfNumber ⟨95, by decide⟩) 1 2 7)

theorem row_59_96 : RowResult ⟨59, by decide⟩ ⟨96, by decide⟩ := by
  have _previous := row_59_95
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_59_97 : RowResult ⟨59, by decide⟩ ⟨97, by decide⟩ := by
  have _previous := row_59_96
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
