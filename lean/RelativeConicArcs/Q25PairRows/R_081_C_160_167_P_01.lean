import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_81_160 : RowResult ⟨81, by decide⟩ ⟨160, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_81_161 : RowResult ⟨81, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_81_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_81_162 : RowResult ⟨81, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_81_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨116, by decide⟩, by decide⟩

theorem row_81_163 : RowResult ⟨81, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_81_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨219, by decide⟩, by decide⟩

theorem row_81_164 : RowResult ⟨81, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_81_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 2 5 6)

theorem row_81_165 : RowResult ⟨81, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_81_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_81_166 : RowResult ⟨81, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_81_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_81_167 : RowResult ⟨81, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_81_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨81, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 4 5 6)

end RelativeConicArcs.Q25PairCertificate
