import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_60_161 : RowResult ⟨60, by decide⟩ ⟨161, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_60_162 : RowResult ⟨60, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_60_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_60_163 : RowResult ⟨60, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_60_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_60_164 : RowResult ⟨60, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_60_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 4 5 6)

theorem row_60_165 : RowResult ⟨60, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_60_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 1 4 7)

theorem row_60_166 : RowResult ⟨60, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_60_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_60_167 : RowResult ⟨60, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_60_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨41, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_60_168 : RowResult ⟨60, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_60_167
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨168, by decide⟩) 2 5 6)

theorem row_60_169 : RowResult ⟨60, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_60_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_60_170 : RowResult ⟨60, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_60_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨60, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
