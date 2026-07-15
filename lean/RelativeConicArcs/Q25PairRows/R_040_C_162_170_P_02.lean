import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_40_162 : RowResult ⟨40, by decide⟩ ⟨162, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_40_163 : RowResult ⟨40, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_40_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_40_164 : RowResult ⟨40, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_40_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_40_165 : RowResult ⟨40, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_40_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 1 4 6)

theorem row_40_166 : RowResult ⟨40, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_40_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 2 4 7)

theorem row_40_167 : RowResult ⟨40, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_40_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨61, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_40_168 : RowResult ⟨40, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_40_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_40_169 : RowResult ⟨40, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_40_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_40_170 : RowResult ⟨40, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_40_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨40, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
