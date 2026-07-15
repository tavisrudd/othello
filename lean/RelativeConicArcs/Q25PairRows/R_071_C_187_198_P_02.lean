import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_71_187 : RowResult ⟨71, by decide⟩ ⟨187, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_71_188 : RowResult ⟨71, by decide⟩ ⟨188, by decide⟩ := by
  have _previous := row_71_187
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨188, by decide⟩) 2 3 6)

theorem row_71_189 : RowResult ⟨71, by decide⟩ ⟨189, by decide⟩ := by
  have _previous := row_71_188
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_71_190 : RowResult ⟨71, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_71_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 2 4 7)

theorem row_71_191 : RowResult ⟨71, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_71_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨38, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_71_192 : RowResult ⟨71, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_71_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 2 5 7)

theorem row_71_193 : RowResult ⟨71, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_71_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_71_194 : RowResult ⟨71, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_71_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 4 5 6)

theorem row_71_195 : RowResult ⟨71, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_71_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_71_196 : RowResult ⟨71, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_71_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨71, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 1 4 6)

theorem row_71_197 : RowResult ⟨71, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_71_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_71_198 : RowResult ⟨71, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_71_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
