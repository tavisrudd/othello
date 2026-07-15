import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_83_194 : RowResult ⟨83, by decide⟩ ⟨194, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨241, by decide⟩, by decide⟩

theorem row_83_195 : RowResult ⟨83, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_83_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_83_196 : RowResult ⟨83, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_83_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨32, by decide⟩,
    orbitCodeOfNumber ⟨241, by decide⟩, by decide⟩

theorem row_83_197 : RowResult ⟨83, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_83_196
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨242, by decide⟩, by decide⟩

theorem row_83_198 : RowResult ⟨83, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_83_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 1 4 7)

theorem row_83_199 : RowResult ⟨83, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_83_198
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_83_200 : RowResult ⟨83, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_83_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_83_201 : RowResult ⟨83, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_83_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_83_202 : RowResult ⟨83, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_83_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_83_203 : RowResult ⟨83, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_83_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_83_204 : RowResult ⟨83, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_83_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_83_205 : RowResult ⟨83, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_83_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_83_206 : RowResult ⟨83, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_83_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 2 4 7)

theorem row_83_207 : RowResult ⟨83, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_83_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_83_208 : RowResult ⟨83, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_83_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 1 4 6)

theorem row_83_209 : RowResult ⟨83, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_83_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨83, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_83_210 : RowResult ⟨83, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_83_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨247, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
