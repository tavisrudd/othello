import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_109_196 : RowResult ⟨109, by decide⟩ ⟨196, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_109_197 : RowResult ⟨109, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_109_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_109_198 : RowResult ⟨109, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_109_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_109_199 : RowResult ⟨109, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_109_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 1 4 7)

theorem row_109_200 : RowResult ⟨109, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_109_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_109_201 : RowResult ⟨109, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_109_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_109_202 : RowResult ⟨109, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_109_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_109_203 : RowResult ⟨109, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_109_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_109_204 : RowResult ⟨109, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_109_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_109_205 : RowResult ⟨109, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_109_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_109_206 : RowResult ⟨109, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_109_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 4 5 6)

theorem row_109_207 : RowResult ⟨109, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_109_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_109_208 : RowResult ⟨109, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_109_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 2 4 6)

theorem row_109_209 : RowResult ⟨109, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_109_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨109, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
