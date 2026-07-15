import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false
set_option linter.unusedVariables false

theorem row_73_189 : RowResult ⟨73, by decide⟩ ⟨189, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_73_190 : RowResult ⟨73, by decide⟩ ⟨190, by decide⟩ := by
  have _previous := row_73_189
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨190, by decide⟩) 2 4 6)

theorem row_73_191 : RowResult ⟨73, by decide⟩ ⟨191, by decide⟩ := by
  have _previous := row_73_190
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨191, by decide⟩) 4 5 6)

theorem row_73_192 : RowResult ⟨73, by decide⟩ ⟨192, by decide⟩ := by
  have _previous := row_73_191
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨192, by decide⟩) 2 5 6)

theorem row_73_193 : RowResult ⟨73, by decide⟩ ⟨193, by decide⟩ := by
  have _previous := row_73_192
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_73_194 : RowResult ⟨73, by decide⟩ ⟨194, by decide⟩ := by
  have _previous := row_73_193
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨241, by decide⟩, by decide⟩

theorem row_73_195 : RowResult ⟨73, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_73_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_73_196 : RowResult ⟨73, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_73_195
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) 2 4 7)

theorem row_73_197 : RowResult ⟨73, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_73_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_73_198 : RowResult ⟨73, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_73_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 1 4 6)

theorem row_73_199 : RowResult ⟨73, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_73_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_73_200 : RowResult ⟨73, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_73_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_73_201 : RowResult ⟨73, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_73_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_73_202 : RowResult ⟨73, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_73_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_73_203 : RowResult ⟨73, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_73_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_73_204 : RowResult ⟨73, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_73_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_73_205 : RowResult ⟨73, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_73_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨73, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_73_206 : RowResult ⟨73, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_73_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
