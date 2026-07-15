import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_173_189 : RowResult ⟨173, by decide⟩ ⟨189, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_173_190 : RowResult ⟨173, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_173_189
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_173_191 : RowResult ⟨173, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_173_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 2 5 7)

theorem row_173_192 : RowResult ⟨173, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_173_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_173_193 : RowResult ⟨173, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_173_192
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨193, by decide⟩) 4 5 6)

theorem row_173_194 : RowResult ⟨173, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_173_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 2 5 6)

theorem row_173_195 : RowResult ⟨173, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_173_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_173_196 : RowResult ⟨173, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_173_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_173_197 : RowResult ⟨173, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_173_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 2 4 7)

theorem row_173_198 : RowResult ⟨173, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_173_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 1 4 6)

theorem row_173_199 : RowResult ⟨173, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_173_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_173_200 : RowResult ⟨173, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_173_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_173_201 : RowResult ⟨173, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_173_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_173_202 : RowResult ⟨173, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_173_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_173_203 : RowResult ⟨173, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_173_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_173_204 : RowResult ⟨173, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_173_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_173_205 : RowResult ⟨173, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_173_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨173, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_173_206 : RowResult ⟨173, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_173_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
