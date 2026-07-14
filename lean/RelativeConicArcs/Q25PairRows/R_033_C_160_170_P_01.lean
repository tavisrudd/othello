import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_33_160 : RowResult ⟨33, by decide⟩ ⟨160, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_33_161 : RowResult ⟨33, by decide⟩ ⟨161, by decide⟩ := by
  have _previous := row_33_160
  exact Or.inr ⟨orbitCodeOfNumber ⟨85, by decide⟩, by decide⟩

theorem row_33_162 : RowResult ⟨33, by decide⟩ ⟨162, by decide⟩ := by
  have _previous := row_33_161
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨162, by decide⟩) 2 5 6)

theorem row_33_163 : RowResult ⟨33, by decide⟩ ⟨163, by decide⟩ := by
  have _previous := row_33_162
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_164 : RowResult ⟨33, by decide⟩ ⟨164, by decide⟩ := by
  have _previous := row_33_163
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨164, by decide⟩) 2 4 7)

theorem row_33_165 : RowResult ⟨33, by decide⟩ ⟨165, by decide⟩ := by
  have _previous := row_33_164
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨165, by decide⟩) 2 4 6)

theorem row_33_166 : RowResult ⟨33, by decide⟩ ⟨166, by decide⟩ := by
  have _previous := row_33_165
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_33_167 : RowResult ⟨33, by decide⟩ ⟨167, by decide⟩ := by
  have _previous := row_33_166
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨167, by decide⟩) 4 5 6)

theorem row_33_168 : RowResult ⟨33, by decide⟩ ⟨168, by decide⟩ := by
  have _previous := row_33_167
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_33_169 : RowResult ⟨33, by decide⟩ ⟨169, by decide⟩ := by
  have _previous := row_33_168
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_33_170 : RowResult ⟨33, by decide⟩ ⟨170, by decide⟩ := by
  have _previous := row_33_169
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨170, by decide⟩) 1 2 7)

end RelativeConicArcs.Q25PairCertificate
