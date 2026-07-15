import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_199_200 : RowResult ⟨199, by decide⟩ ⟨200, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_199_201 : RowResult ⟨199, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_199_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_199_202 : RowResult ⟨199, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_199_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_199_203 : RowResult ⟨199, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_199_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_199_204 : RowResult ⟨199, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_199_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_199_205 : RowResult ⟨199, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_199_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_199_206 : RowResult ⟨199, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_199_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_199_207 : RowResult ⟨199, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_199_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 2 4 6)

theorem row_199_208 : RowResult ⟨199, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_199_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨240, by decide⟩, by decide⟩

theorem row_199_209 : RowResult ⟨199, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_199_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 1 4 7)

theorem row_199_210 : RowResult ⟨199, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_199_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_199_211 : RowResult ⟨199, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_199_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 4 5 6)

theorem row_199_212 : RowResult ⟨199, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_199_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_199_213 : RowResult ⟨199, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_199_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨235, by decide⟩, by decide⟩

theorem row_199_214 : RowResult ⟨199, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_199_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
