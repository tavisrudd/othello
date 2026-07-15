import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_47_194 : RowResult ⟨47, by decide⟩ ⟨194, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_47_195 : RowResult ⟨47, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_47_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_47_196 : RowResult ⟨47, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_47_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨65, by decide⟩,
    orbitCodeOfNumber ⟨238, by decide⟩, by decide⟩

theorem row_47_197 : RowResult ⟨47, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_47_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 1 4 6)

theorem row_47_198 : RowResult ⟨47, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_47_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 4 5 6)

theorem row_47_199 : RowResult ⟨47, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_47_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨243, by decide⟩, by decide⟩

theorem row_47_200 : RowResult ⟨47, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_47_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_47_201 : RowResult ⟨47, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_47_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_47_202 : RowResult ⟨47, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_47_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_47_203 : RowResult ⟨47, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_47_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_47_204 : RowResult ⟨47, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_47_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_47_205 : RowResult ⟨47, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_47_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_47_206 : RowResult ⟨47, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_47_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_47_207 : RowResult ⟨47, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_47_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 1 4 7)

theorem row_47_208 : RowResult ⟨47, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_47_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 2 4 7)

theorem row_47_209 : RowResult ⟨47, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_47_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_47_210 : RowResult ⟨47, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_47_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 4 5 6)

theorem row_47_211 : RowResult ⟨47, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_47_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨62, by decide⟩,
    orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_47_212 : RowResult ⟨47, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_47_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_47_213 : RowResult ⟨47, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_47_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨47, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
