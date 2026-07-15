import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_58_197 : RowResult ⟨58, by decide⟩ ⟨197, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨36, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_58_198 : RowResult ⟨58, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_58_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 1 4 7)

theorem row_58_199 : RowResult ⟨58, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_58_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 2 4 6)

theorem row_58_200 : RowResult ⟨58, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_58_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_58_201 : RowResult ⟨58, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_58_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_58_202 : RowResult ⟨58, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_58_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_58_203 : RowResult ⟨58, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_58_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_58_204 : RowResult ⟨58, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_58_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_58_205 : RowResult ⟨58, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_58_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_58_206 : RowResult ⟨58, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_58_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 4 5 6)

theorem row_58_207 : RowResult ⟨58, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_58_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 2 4 6)

theorem row_58_208 : RowResult ⟨58, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_58_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 1 4 6)

theorem row_58_209 : RowResult ⟨58, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_58_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_58_210 : RowResult ⟨58, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_58_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_58_211 : RowResult ⟨58, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_58_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_58_212 : RowResult ⟨58, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_58_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_58_213 : RowResult ⟨58, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_58_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 2 5 7)

theorem row_58_214 : RowResult ⟨58, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_58_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

theorem row_58_215 : RowResult ⟨58, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_58_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨58, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 2 5 6)

theorem row_58_216 : RowResult ⟨58, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_58_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨42, by decide⟩,
    orbitCodeOfNumber ⟨246, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
