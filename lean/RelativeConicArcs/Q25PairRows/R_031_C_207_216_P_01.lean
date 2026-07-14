import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_31_207 : RowResult ⟨31, by decide⟩ ⟨207, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_31_208 : RowResult ⟨31, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_31_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_31_209 : RowResult ⟨31, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_31_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_31_210 : RowResult ⟨31, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_31_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨168, by decide⟩, by decide⟩

theorem row_31_211 : RowResult ⟨31, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_31_210
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨211, by decide⟩) 2 5 6)

theorem row_31_212 : RowResult ⟨31, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_31_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨147, by decide⟩, by decide⟩

theorem row_31_213 : RowResult ⟨31, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_31_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 2 4 7)

theorem row_31_214 : RowResult ⟨31, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_31_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_31_215 : RowResult ⟨31, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_31_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨31, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 2 4 6)

theorem row_31_216 : RowResult ⟨31, by decide⟩ ⟨216, by decide⟩ := by
  have _previous := row_31_215
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

end RelativeConicArcs.Q25PairCertificate
