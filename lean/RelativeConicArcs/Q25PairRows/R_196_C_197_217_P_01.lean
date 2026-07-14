import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_196_197 : RowResult ⟨196, by decide⟩ ⟨197, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 0 4 6)

theorem row_196_198 : RowResult ⟨196, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_196_197
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) (orbitCodeOfNumber ⟨198, by decide⟩) 0 4 6)

theorem row_196_199 : RowResult ⟨196, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_196_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 0 4 6)

theorem row_196_200 : RowResult ⟨196, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_196_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_196_201 : RowResult ⟨196, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_196_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_196_202 : RowResult ⟨196, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_196_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_196_203 : RowResult ⟨196, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_196_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_196_204 : RowResult ⟨196, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_196_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_196_205 : RowResult ⟨196, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_196_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_196_206 : RowResult ⟨196, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_196_205
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) (orbitCodeOfNumber ⟨206, by decide⟩) 1 4 7)

theorem row_196_207 : RowResult ⟨196, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_196_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_196_208 : RowResult ⟨196, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_196_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_196_209 : RowResult ⟨196, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_196_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_196_210 : RowResult ⟨196, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_196_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_196_211 : RowResult ⟨196, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_196_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_196_212 : RowResult ⟨196, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_196_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_196_213 : RowResult ⟨196, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_196_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 4 5 6)

theorem row_196_214 : RowResult ⟨196, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_196_213
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) (orbitCodeOfNumber ⟨214, by decide⟩) 2 4 6)

theorem row_196_215 : RowResult ⟨196, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_196_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 2 5 7)

theorem row_196_216 : RowResult ⟨196, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_196_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_196_217 : RowResult ⟨196, by decide⟩ ⟨217, by decide⟩ := by
  have _previous := row_196_216
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨196, by decide⟩) (orbitCodeOfNumber ⟨217, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
