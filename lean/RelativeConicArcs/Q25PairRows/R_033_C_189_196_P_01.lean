import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_33_189 : RowResult ⟨33, by decide⟩ ⟨189, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_33_190 : RowResult ⟨33, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_33_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_191 : RowResult ⟨33, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_33_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_192 : RowResult ⟨33, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_33_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_33_193 : RowResult ⟨33, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_33_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 2 4 6)

theorem row_33_194 : RowResult ⟨33, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_33_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_33_195 : RowResult ⟨33, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_33_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨33, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_33_196 : RowResult ⟨33, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_33_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
