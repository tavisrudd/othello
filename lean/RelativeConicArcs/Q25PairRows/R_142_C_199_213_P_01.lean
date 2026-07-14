import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_142_199 : RowResult ⟨142, by decide⟩ ⟨199, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_142_200 : RowResult ⟨142, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_142_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_142_201 : RowResult ⟨142, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_142_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_142_202 : RowResult ⟨142, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_142_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_142_203 : RowResult ⟨142, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_142_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_142_204 : RowResult ⟨142, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_142_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_142_205 : RowResult ⟨142, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_142_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_142_206 : RowResult ⟨142, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_142_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_142_207 : RowResult ⟨142, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_142_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_142_208 : RowResult ⟨142, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_142_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_142_209 : RowResult ⟨142, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_142_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_142_210 : RowResult ⟨142, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_142_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_142_211 : RowResult ⟨142, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_142_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_142_212 : RowResult ⟨142, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_142_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 1 4 7)

theorem row_142_213 : RowResult ⟨142, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_142_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨142, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 2 5 7)

end RelativeConicArcs.Q25PairCertificate
