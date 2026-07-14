import RelativeConicArcs.Q25PairCertificate

namespace RelativeConicArcs.Q25PairCertificate
open Q25Coordinates FiniteFields
set_option maxHeartbeats 1000000000
set_option maxRecDepth 100000
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

theorem row_118_207 : RowResult ⟨118, by decide⟩ ⟨207, by decide⟩ := by
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_118_208 : RowResult ⟨118, by decide⟩ ⟨208, by decide⟩ := by
  have _previous := row_118_207
  exact Or.inr ⟨orbitCodeOfNumber ⟨60, by decide⟩, by decide⟩

theorem row_118_209 : RowResult ⟨118, by decide⟩ ⟨209, by decide⟩ := by
  have _previous := row_118_208
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨209, by decide⟩) 2 3 6)

theorem row_118_210 : RowResult ⟨118, by decide⟩ ⟨210, by decide⟩ := by
  have _previous := row_118_209
  exact Or.inr ⟨orbitCodeOfNumber ⟨249, by decide⟩, by decide⟩

theorem row_118_211 : RowResult ⟨118, by decide⟩ ⟨211, by decide⟩ := by
  have _previous := row_118_210
  exact Or.inr ⟨orbitCodeOfNumber ⟨39, by decide⟩, by decide⟩

theorem row_118_212 : RowResult ⟨118, by decide⟩ ⟨212, by decide⟩ := by
  have _previous := row_118_211
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_118_213 : RowResult ⟨118, by decide⟩ ⟨213, by decide⟩ := by
  have _previous := row_118_212
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨213, by decide⟩) 1 4 7)

theorem row_118_214 : RowResult ⟨118, by decide⟩ ⟨214, by decide⟩ := by
  have _previous := row_118_213
  exact Or.inr ⟨orbitCodeOfNumber ⟨59, by decide⟩, by decide⟩

theorem row_118_215 : RowResult ⟨118, by decide⟩ ⟨215, by decide⟩ := by
  have _previous := row_118_214
  apply Or.inl
  exact not_rawCap_of_badWitness
    (by decide : BadWitnessValid (orbitCodeOfNumber ⟨5, by decide⟩) (orbitCodeOfNumber ⟨118, by decide⟩) (orbitCodeOfNumber ⟨215, by decide⟩) 2 5 6)

end RelativeConicArcs.Q25PairCertificate
