import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_47_164 : RowResult ⟨47, by decide⟩ ⟨164, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_47_165 : RowResult ⟨47, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_47_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_47_166 : RowResult ⟨47, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_47_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

theorem row_47_167 : RowResult ⟨47, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_47_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_47_168 : RowResult ⟨47, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_47_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_47_169 : RowResult ⟨47, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_47_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_47_170 : RowResult ⟨47, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_47_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
