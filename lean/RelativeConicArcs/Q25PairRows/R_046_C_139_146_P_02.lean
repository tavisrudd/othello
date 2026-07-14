import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_46_139 : RowResult ⟨46, by decide⟩ ⟨139, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_46_140 : RowResult ⟨46, by decide⟩ ⟨140, by decide⟩ := by
  have _previous := row_46_139
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_46_141 : RowResult ⟨46, by decide⟩ ⟨141, by decide⟩ := by
  have _previous := row_46_140
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_46_142 : RowResult ⟨46, by decide⟩ ⟨142, by decide⟩ := by
  have _previous := row_46_141
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_46_143 : RowResult ⟨46, by decide⟩ ⟨143, by decide⟩ := by
  have _previous := row_46_142
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_46_144 : RowResult ⟨46, by decide⟩ ⟨144, by decide⟩ := by
  have _previous := row_46_143
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_46_145 : RowResult ⟨46, by decide⟩ ⟨145, by decide⟩ := by
  have _previous := row_46_144
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨145, by decide⟩) 1 2 7)

theorem row_46_146 : RowResult ⟨46, by decide⟩ ⟨146, by decide⟩ := by
  have _previous := row_46_145
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨146, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
