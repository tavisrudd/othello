import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_97_198 : RowResult ⟨97, by decide⟩ ⟨198, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 2 4 7)

theorem row_97_199 : RowResult ⟨97, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_97_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_97_200 : RowResult ⟨97, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_97_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_97_201 : RowResult ⟨97, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_97_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_97_202 : RowResult ⟨97, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_97_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_97_203 : RowResult ⟨97, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_97_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_97_204 : RowResult ⟨97, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_97_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_97_205 : RowResult ⟨97, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_97_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_97_206 : RowResult ⟨97, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_97_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_97_207 : RowResult ⟨97, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_97_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 1 4 7)

theorem row_97_208 : RowResult ⟨97, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_97_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_97_209 : RowResult ⟨97, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_97_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_97_210 : RowResult ⟨97, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_97_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_97_211 : RowResult ⟨97, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_97_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 2 4 6)

theorem row_97_212 : RowResult ⟨97, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_97_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_97_213 : RowResult ⟨97, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_97_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨97, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 4 5 6)

theorem row_97_214 : RowResult ⟨97, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_97_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
