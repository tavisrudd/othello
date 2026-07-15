import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_198_199 : RowResult ⟨198, by decide⟩ ⟨199, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 0 4 6)

theorem row_198_200 : RowResult ⟨198, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_198_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_198_201 : RowResult ⟨198, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_198_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_198_202 : RowResult ⟨198, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_198_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_198_203 : RowResult ⟨198, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_198_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_198_204 : RowResult ⟨198, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_198_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_198_205 : RowResult ⟨198, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_198_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_198_206 : RowResult ⟨198, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_198_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_198_207 : RowResult ⟨198, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_198_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_198_208 : RowResult ⟨198, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_198_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 1 4 7)

theorem row_198_209 : RowResult ⟨198, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_198_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_198_210 : RowResult ⟨198, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_198_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 4 5 6)

theorem row_198_211 : RowResult ⟨198, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_198_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 2 5 6)

theorem row_198_212 : RowResult ⟨198, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_198_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨241, by decide⟩, by decide⟩

theorem row_198_213 : RowResult ⟨198, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_198_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_198_214 : RowResult ⟨198, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_198_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

theorem row_198_215 : RowResult ⟨198, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_198_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_198_216 : RowResult ⟨198, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_198_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 2 4 6)

end RelativeConicArcs.Q25PairCertificate
