import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_111_160 : RowResult ⟨111, by decide⟩ ⟨160, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_111_161 : RowResult ⟨111, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_111_160
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨161, by decide⟩) 1 4 6)

theorem row_111_162 : RowResult ⟨111, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_111_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_111_163 : RowResult ⟨111, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_111_162
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨163, by decide⟩) 4 5 6)

theorem row_111_164 : RowResult ⟨111, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_111_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_111_165 : RowResult ⟨111, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_111_164
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_111_166 : RowResult ⟨111, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_111_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨111, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 1 4 7)

theorem row_111_167 : RowResult ⟨111, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_111_166
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_111_168 : RowResult ⟨111, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_111_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
