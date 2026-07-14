import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_87_199 : RowResult ⟨87, by decide⟩ ⟨199, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_87_200 : RowResult ⟨87, by decide⟩ ⟨200, by decide⟩ := by
  have _previous := row_87_199
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨200, by decide⟩) 1 6 7)

theorem row_87_201 : RowResult ⟨87, by decide⟩ ⟨201, by decide⟩ := by
  have _previous := row_87_200
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨201, by decide⟩) 1 6 7)

theorem row_87_202 : RowResult ⟨87, by decide⟩ ⟨202, by decide⟩ := by
  have _previous := row_87_201
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨202, by decide⟩) 1 6 7)

theorem row_87_203 : RowResult ⟨87, by decide⟩ ⟨203, by decide⟩ := by
  have _previous := row_87_202
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨203, by decide⟩) 1 6 7)

theorem row_87_204 : RowResult ⟨87, by decide⟩ ⟨204, by decide⟩ := by
  have _previous := row_87_203
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨204, by decide⟩) 1 6 7)

theorem row_87_205 : RowResult ⟨87, by decide⟩ ⟨205, by decide⟩ := by
  have _previous := row_87_204
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨205, by decide⟩) 1 2 6)

theorem row_87_206 : RowResult ⟨87, by decide⟩ ⟨206, by decide⟩ := by
  have _previous := row_87_205
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_87_207 : RowResult ⟨87, by decide⟩ ⟨207, by decide⟩ := by
  have _previous := row_87_206
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_87_208 : RowResult ⟨87, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_87_207
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨208, by decide⟩) 2 5 7)

theorem row_87_209 : RowResult ⟨87, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_87_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_87_210 : RowResult ⟨87, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_87_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_87_211 : RowResult ⟨87, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_87_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_87_212 : RowResult ⟨87, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_87_211
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨87, by decide⟩) (orbitCodeOfNumber ⟨212, by decide⟩) 1 4 6)

theorem row_87_213 : RowResult ⟨87, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_87_212
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
