import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_31_160 : RowResult ⟨31, by decide⟩ ⟨160, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_31_161 : RowResult ⟨31, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_31_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_31_162 : RowResult ⟨31, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_31_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_31_163 : RowResult ⟨31, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_31_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_31_164 : RowResult ⟨31, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_31_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_31_165 : RowResult ⟨31, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_31_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 4 5 6)

theorem row_31_166 : RowResult ⟨31, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_31_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_31_167 : RowResult ⟨31, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_31_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
