import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_85_161 : RowResult ⟨85, by decide⟩ ⟨161, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_85_162 : RowResult ⟨85, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_85_161
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_85_163 : RowResult ⟨85, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_85_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_85_164 : RowResult ⟨85, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_85_163
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_85_165 : RowResult ⟨85, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_85_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 1 4 7)

theorem row_85_166 : RowResult ⟨85, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_85_165
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) 2 4 6)

theorem row_85_167 : RowResult ⟨85, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_85_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 2 5 6)

theorem row_85_168 : RowResult ⟨85, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_85_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_85_169 : RowResult ⟨85, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_85_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_85_170 : RowResult ⟨85, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_85_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨85, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
