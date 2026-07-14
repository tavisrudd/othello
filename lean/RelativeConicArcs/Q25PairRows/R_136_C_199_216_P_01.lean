import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_136_199 : RowResult ⟨136, by decide⟩ ⟨199, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_136_200 : RowResult ⟨136, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_136_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_136_201 : RowResult ⟨136, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_136_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_136_202 : RowResult ⟨136, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_136_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_136_203 : RowResult ⟨136, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_136_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_136_204 : RowResult ⟨136, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_136_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_136_205 : RowResult ⟨136, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_136_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_136_206 : RowResult ⟨136, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_136_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_136_207 : RowResult ⟨136, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_136_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_136_208 : RowResult ⟨136, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_136_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 4 5 6)

theorem row_136_209 : RowResult ⟨136, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_136_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_136_210 : RowResult ⟨136, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_136_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_136_211 : RowResult ⟨136, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_136_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 1 4 6)

theorem row_136_212 : RowResult ⟨136, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_136_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_136_213 : RowResult ⟨136, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_136_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 2 4 7)

theorem row_136_214 : RowResult ⟨136, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_136_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨183, by decide⟩, by decide⟩

theorem row_136_215 : RowResult ⟨136, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_136_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 2 4 6)

theorem row_136_216 : RowResult ⟨136, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_136_215
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨136, by decide⟩) (orbitCodeOfNumber ⟨216, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
