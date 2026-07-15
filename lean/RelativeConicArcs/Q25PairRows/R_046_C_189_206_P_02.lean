import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_46_189 : RowResult ⟨46, by decide⟩ ⟨189, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_46_190 : RowResult ⟨46, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_46_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 2 4 6)

theorem row_46_191 : RowResult ⟨46, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_46_190
  exact Or.inr ⟨orbitCodeOfNumber ⟨58, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_46_192 : RowResult ⟨46, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_46_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_46_193 : RowResult ⟨46, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_46_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 2 5 6)

theorem row_46_194 : RowResult ⟨46, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_46_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

theorem row_46_195 : RowResult ⟨46, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_46_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_46_196 : RowResult ⟨46, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_46_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 1 4 6)

theorem row_46_197 : RowResult ⟨46, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_46_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 4 5 6)

theorem row_46_198 : RowResult ⟨46, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_46_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_46_199 : RowResult ⟨46, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_46_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨57, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_46_200 : RowResult ⟨46, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_46_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_46_201 : RowResult ⟨46, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_46_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_46_202 : RowResult ⟨46, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_46_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_46_203 : RowResult ⟨46, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_46_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_46_204 : RowResult ⟨46, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_46_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_46_205 : RowResult ⟨46, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_46_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_46_206 : RowResult ⟨46, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_46_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨46, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
