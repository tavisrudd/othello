import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_65_141 : RowResult ⟨65, by decide⟩ ⟨141, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_65_142 : RowResult ⟨65, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_65_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_65_143 : RowResult ⟨65, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_65_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_65_144 : RowResult ⟨65, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_65_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_65_145 : RowResult ⟨65, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_65_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨65, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_65_146 : RowResult ⟨65, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_65_145
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_65_147 : RowResult ⟨65, by decide⟩ ⟨147, by decide⟩ := by
  have _previous := row_65_146
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
