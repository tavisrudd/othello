import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_141_189 : RowResult ⟨141, by decide⟩ ⟨189, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_141_190 : RowResult ⟨141, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_141_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 4 5 6)

theorem row_141_191 : RowResult ⟨141, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_141_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 1 4 6)

theorem row_141_192 : RowResult ⟨141, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_141_191
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_141_193 : RowResult ⟨141, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_141_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_141_194 : RowResult ⟨141, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_141_193
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 2 5 7)

theorem row_141_195 : RowResult ⟨141, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_141_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_141_196 : RowResult ⟨141, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_141_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_141_197 : RowResult ⟨141, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_141_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_141_198 : RowResult ⟨141, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_141_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 2 4 7)

theorem row_141_199 : RowResult ⟨141, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_141_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 2 5 6)

theorem row_141_200 : RowResult ⟨141, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_141_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_141_201 : RowResult ⟨141, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_141_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_141_202 : RowResult ⟨141, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_141_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_141_203 : RowResult ⟨141, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_141_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_141_204 : RowResult ⟨141, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_141_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_141_205 : RowResult ⟨141, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_141_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_141_206 : RowResult ⟨141, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_141_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_141_207 : RowResult ⟨141, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_141_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨141, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
