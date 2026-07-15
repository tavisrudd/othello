import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_166_199 : RowResult ⟨166, by decide⟩ ⟨199, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_166_200 : RowResult ⟨166, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_166_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_166_201 : RowResult ⟨166, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_166_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_166_202 : RowResult ⟨166, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_166_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_166_203 : RowResult ⟨166, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_166_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_166_204 : RowResult ⟨166, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_166_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_166_205 : RowResult ⟨166, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_166_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_166_206 : RowResult ⟨166, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_166_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨34, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_166_207 : RowResult ⟨166, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_166_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨244, by decide⟩, by decide⟩

theorem row_166_208 : RowResult ⟨166, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_166_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 2 5 6)

theorem row_166_209 : RowResult ⟨166, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_166_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_166_210 : RowResult ⟨166, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_166_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨31, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_166_211 : RowResult ⟨166, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_166_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 1 4 7)

theorem row_166_212 : RowResult ⟨166, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_166_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 2 4 7)

theorem row_166_213 : RowResult ⟨166, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_166_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 2 4 6)

theorem row_166_214 : RowResult ⟨166, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_166_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨33, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_166_215 : RowResult ⟨166, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_166_214
  exact Or.inr ⟨orbitCodeOfNumber ⟨37, by decide⟩,
    orbitCodeOfNumber ⟨248, by decide⟩, by decide⟩

theorem row_166_216 : RowResult ⟨166, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_166_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨166, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 1 4 6)

end RelativeConicArcs.Q25PairCertificate
