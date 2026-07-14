import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_93_194 : RowResult ⟨93, by decide⟩ ⟨194, by decide⟩ := by
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨194, by decide⟩) 2 5 7)

theorem row_93_195 : RowResult ⟨93, by decide⟩ ⟨195, by decide⟩ := by
  have _previous := row_93_194
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨195, by decide⟩) 1 2 7)

theorem row_93_196 : RowResult ⟨93, by decide⟩ ⟨196, by decide⟩ := by
  have _previous := row_93_195
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_93_197 : RowResult ⟨93, by decide⟩ ⟨197, by decide⟩ := by
  have _previous := row_93_196
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨197, by decide⟩) 2 4 7)

theorem row_93_198 : RowResult ⟨93, by decide⟩ ⟨198, by decide⟩ := by
  have _previous := row_93_197
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_93_199 : RowResult ⟨93, by decide⟩ ⟨199, by decide⟩ := by
  have _previous := row_93_198
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨199, by decide⟩) 2 5 6)

theorem row_93_200 : RowResult ⟨93, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_93_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_93_201 : RowResult ⟨93, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_93_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_93_202 : RowResult ⟨93, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_93_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_93_203 : RowResult ⟨93, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_93_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_93_204 : RowResult ⟨93, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_93_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_93_205 : RowResult ⟨93, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_93_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_93_206 : RowResult ⟨93, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_93_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_93_207 : RowResult ⟨93, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_93_206
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨207, by decide⟩) 2 5 6)

theorem row_93_208 : RowResult ⟨93, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_93_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_93_209 : RowResult ⟨93, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_93_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_93_210 : RowResult ⟨93, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_93_209
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨210, by decide⟩) 2 4 7)

theorem row_93_211 : RowResult ⟨93, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_93_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨237, by decide⟩, by decide⟩

theorem row_93_212 : RowResult ⟨93, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_93_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_93_213 : RowResult ⟨93, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_93_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨93, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 1 4 7)

end RelativeConicArcs.Q25PairCertificate
