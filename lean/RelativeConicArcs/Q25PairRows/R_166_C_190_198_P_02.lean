import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_166_190 : RowResult ⟨166, by decide⟩ ⟨190, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_166_191 : RowResult ⟨166, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_166_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 1 4 6)

theorem row_166_192 : RowResult ⟨166, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_166_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 2 4 7)

theorem row_166_193 : RowResult ⟨166, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_166_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_166_194 : RowResult ⟨166, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_166_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

theorem row_166_195 : RowResult ⟨166, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_166_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_166_196 : RowResult ⟨166, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_166_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_166_197 : RowResult ⟨166, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_166_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_166_198 : RowResult ⟨166, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_166_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
